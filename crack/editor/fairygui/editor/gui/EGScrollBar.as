package fairygui.editor.gui
{
   import fairygui.event.GTouchEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EGScrollBar extends ComExtention
   {
       
      
      private var _grip:EGObject;
      
      private var _arrowButton1:EGObject;
      
      private var _arrowButton2:EGObject;
      
      private var _bar:EGObject;
      
      private var _scrollPane:EScrollPane;
      
      private var _vertical:Boolean;
      
      private var _scrollPerc:Number;
      
      private var _dragging:Boolean;
      
      private var _dragOffset:Point;
      
      private var _fixedGripSize:Boolean;
      
      private var _mouseIn:Boolean;
      
      public function EGScrollBar()
      {
         super();
         this._dragOffset = new Point();
      }
      
      public function setScrollPane(param1:EScrollPane, param2:Boolean) : void
      {
         this._scrollPane = param1;
         this._vertical = param2;
      }
      
      public function set displayPerc(param1:Number) : void
      {
         if(!this._grip || !this._bar)
         {
            return;
         }
         if(this._vertical)
         {
            if(!this._fixedGripSize)
            {
               this._grip.height = param1 * this._bar.height;
            }
            this._grip.y = this._bar.y + (this._bar.height - this._grip.height) * this._scrollPerc;
         }
         else
         {
            if(!this._fixedGripSize)
            {
               this._grip.width = param1 * this._bar.width;
            }
            this._grip.x = this._bar.x + (this._bar.width - this._grip.width) * this._scrollPerc;
         }
      }
      
      public function set scrollPerc(param1:Number) : void
      {
         if(!this._grip || !this._bar)
         {
            return;
         }
         this._scrollPerc = param1;
         if(this._vertical)
         {
            this._grip.y = this._bar.y + (this._bar.height - this._grip.height) * this._scrollPerc;
         }
         else
         {
            this._grip.x = this._bar.x + (this._bar.width - this._grip.width) * this._scrollPerc;
         }
      }
      
      public function get minSize() : int
      {
         if(this._vertical)
         {
            return (this._arrowButton1 != null?this._arrowButton1.height:0) + (this._arrowButton2 != null?this._arrowButton2.height:0);
         }
         return (this._arrowButton1 != null?this._arrowButton1.width:0) + (this._arrowButton2 != null?this._arrowButton2.width:0);
      }
      
      public function get fixedGripSize() : Boolean
      {
         return this._fixedGripSize;
      }
      
      public function set fixedGripSize(param1:Boolean) : void
      {
         this._fixedGripSize = param1;
      }
      
      override protected function install() : void
      {
         this._grip = owner.getChild("grip");
         this._bar = owner.getChild("bar");
         this._arrowButton1 = owner.getChild("arrow1");
         this._arrowButton2 = owner.getChild("arrow2");
         if(_owner.editMode == 1)
         {
            if(this._grip)
            {
               this._grip.displayObject.addEventListener("mouseDown",this.__gripMouseDown);
            }
            if(this._arrowButton1)
            {
               this._arrowButton1.addEventListener("beginGTouch",this.__arrowButton1Click);
            }
            if(this._arrowButton2)
            {
               this._arrowButton2.addEventListener("beginGTouch",this.__arrowButton2Click);
            }
            _owner.addEventListener("beginGTouch",this.__barMouseDown);
         }
      }
      
      override protected function uninstall() : void
      {
         if(_owner.editMode == 1)
         {
            if(this._grip)
            {
               this._grip.displayObject.removeEventListener("mouseDown",this.__gripMouseDown);
            }
            if(this._arrowButton1)
            {
               this._arrowButton1.removeEventListener("beginGTouch",this.__arrowButton1Click);
            }
            if(this._arrowButton2)
            {
               this._arrowButton2.removeEventListener("beginGTouch",this.__arrowButton2Click);
            }
            _owner.removeEventListener("beginGTouch",this.__barMouseDown);
         }
         this._grip = null;
         this._arrowButton1 = null;
         this._arrowButton2 = null;
         this._bar = null;
      }
      
      override public function load(param1:XML) : void
      {
         if(param1)
         {
            this._fixedGripSize = param1.@fixedGripSize == "true";
         }
         else
         {
            this._fixedGripSize = false;
         }
      }
      
      override public function serialize() : XML
      {
         var _loc1_:XML = <ScrollBar/>;
         if(this._fixedGripSize)
         {
            _loc1_.@fixedGripSize = true;
         }
         return _loc1_;
      }
      
      private function __gripMouseDown(param1:MouseEvent) : void
      {
         if(!this._bar)
         {
            return;
         }
         param1.stopPropagation();
         this._dragOffset.x = this._grip.displayObject.stage.mouseX - this._grip.x;
         this._dragOffset.y = this._grip.displayObject.stage.mouseY - this._grip.y;
         this._dragging = true;
         this._grip.displayObject.stage.addEventListener("mouseMove",this.__stageMouseMove);
         this._grip.displayObject.stage.addEventListener("mouseUp",this.__stageMouseUp);
      }
      
      private function __stageMouseMove(param1:MouseEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._scrollPane == null)
         {
            return;
         }
         if(this._vertical)
         {
            _loc4_ = param1.stageY - this._dragOffset.y;
            _loc2_ = this._bar.height - this._grip.height;
            if(_loc2_ == 0)
            {
               this._scrollPane.setPercY(0,false);
            }
            else
            {
               this._scrollPane.setPercY((_loc4_ - this._bar.y) / _loc2_,false);
            }
         }
         else
         {
            _loc3_ = param1.stageX - this._dragOffset.x;
            _loc2_ = this._bar.width - this._grip.width;
            if(_loc2_ == 0)
            {
               this._scrollPane.setPercX(0,false);
            }
            else
            {
               this._scrollPane.setPercX((_loc3_ - this._bar.x) / _loc2_,false);
            }
         }
      }
      
      private function __stageMouseUp(param1:Event) : void
      {
         if(this._dragging)
         {
            this._dragging = false;
            this._grip.pkg.project.editorWindow.stage.removeEventListener("mouseUp",this.__stageMouseUp);
            this._grip.pkg.project.editorWindow.stage.removeEventListener("mouseMove",this.__stageMouseMove);
         }
      }
      
      private function __arrowButton1Click(param1:Event) : void
      {
         if(this._scrollPane == null)
         {
            return;
         }
         param1.stopPropagation();
         if(this._vertical)
         {
            this._scrollPane.scrollUp();
         }
         else
         {
            this._scrollPane.scrollLeft();
         }
      }
      
      private function __arrowButton2Click(param1:Event) : void
      {
         if(this._scrollPane == null)
         {
            return;
         }
         param1.stopPropagation();
         if(this._vertical)
         {
            this._scrollPane.scrollDown();
         }
         else
         {
            this._scrollPane.scrollRight();
         }
      }
      
      private function __barMouseDown(param1:GTouchEvent) : void
      {
         if(this._scrollPane == null || !this._grip)
         {
            return;
         }
         var _loc2_:Point = this._grip.displayObject.globalToLocal(new Point(param1.stageX,param1.stageY));
         if(this._vertical)
         {
            if(_loc2_.y < 0)
            {
               this._scrollPane.scrollUp(4);
            }
            else
            {
               this._scrollPane.scrollDown(4);
            }
         }
         else if(_loc2_.x < 0)
         {
            this._scrollPane.scrollLeft(4);
         }
         else
         {
            this._scrollPane.scrollRight(4);
         }
      }
   }
}

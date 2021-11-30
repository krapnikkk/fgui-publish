package fairygui
{
   import fairygui.event.GTouchEvent;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class GScrollBar extends GComponent
   {
       
      
      private var _grip:GObject;
      
      private var _arrowButton1:GObject;
      
      private var _arrowButton2:GObject;
      
      private var _bar:GObject;
      
      private var _target:ScrollPane;
      
      private var _vertical:Boolean;
      
      private var _scrollPerc:Number;
      
      private var _fixedGripSize:Boolean;
      
      private var _dragOffset:Point;
      
      public function GScrollBar()
      {
         super();
         _dragOffset = new Point();
         _scrollPerc = 0;
      }
      
      public function setScrollPane(param1:ScrollPane, param2:Boolean) : void
      {
         _target = param1;
         _vertical = param2;
      }
      
      public function setDisplayPerc(param1:Number) : void
      {
         if(_vertical)
         {
            if(!_fixedGripSize)
            {
               _grip.height = Math.floor(param1 * _bar.height);
            }
            _grip.y = _bar.y + (_bar.height - _grip.height) * _scrollPerc;
         }
         else
         {
            if(!_fixedGripSize)
            {
               _grip.width = Math.floor(param1 * _bar.width);
            }
            _grip.x = _bar.x + (_bar.width - _grip.width) * _scrollPerc;
         }
         _grip.visible = param1 != 0 && param1 != 1;
      }
      
      public function setScrollPerc(param1:Number) : void
      {
         _scrollPerc = param1;
         if(_vertical)
         {
            _grip.y = _bar.y + (_bar.height - _grip.height) * _scrollPerc;
         }
         else
         {
            _grip.x = _bar.x + (_bar.width - _grip.width) * _scrollPerc;
         }
      }
      
      public function get minSize() : int
      {
         if(_vertical)
         {
            return (_arrowButton1 != null?_arrowButton1.height:0) + (_arrowButton2 != null?_arrowButton2.height:0);
         }
         return (_arrowButton1 != null?_arrowButton1.width:0) + (_arrowButton2 != null?_arrowButton2.width:0);
      }
      
      public function get gripDragging() : Boolean
      {
         return _grip && _grip.isDown;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         param1 = param1.ScrollBar[0];
         if(param1 != null)
         {
            _fixedGripSize = param1.@fixedGripSize == "true";
         }
         _grip = getChild("grip");
         if(!_grip)
         {
            return;
            §§push(trace("需要定义grip"));
         }
         else
         {
            _bar = getChild("bar");
            if(!_bar)
            {
               return;
               §§push(trace("需要定义bar"));
            }
            else
            {
               _arrowButton1 = getChild("arrow1");
               _arrowButton2 = getChild("arrow2");
               _grip.addEventListener("beginGTouch",__gripMouseDown);
               _grip.addEventListener("dragGTouch",__gripDragging);
               _grip.addEventListener("endGTouch",__gripMouseUp);
               if(_arrowButton1)
               {
                  _arrowButton1.addEventListener("beginGTouch",__arrowButton1Click);
               }
               if(_arrowButton2)
               {
                  _arrowButton2.addEventListener("beginGTouch",__arrowButton2Click);
               }
               addEventListener("beginGTouch",__barMouseDown);
               return;
            }
         }
      }
      
      private function __gripMouseDown(param1:GTouchEvent) : void
      {
         if(!_bar)
         {
            return;
         }
         param1.stopPropagation();
         _dragOffset = this.globalToLocal(param1.stageX,param1.stageY);
         _dragOffset.x = _dragOffset.x - _grip.x;
         _dragOffset.y = _dragOffset.y - _grip.y;
      }
      
      private function __gripMouseUp(param1:GTouchEvent) : void
      {
         _target.updateScrollBarVisible();
      }
      
      private function __gripDragging(param1:GTouchEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc2_:Point = this.globalToLocal(param1.stageX,param1.stageY);
         if(_vertical)
         {
            _loc4_ = _loc2_.y - _dragOffset.y;
            _loc5_ = _bar.height - _grip.height;
            if(_loc5_ == 0)
            {
               _target.setPercY(0,false);
            }
            else
            {
               _target.setPercY((_loc4_ - _bar.y) / _loc5_,false);
            }
         }
         else
         {
            _loc3_ = _loc2_.x - _dragOffset.x;
            _loc5_ = _bar.width - _grip.width;
            if(_loc5_ == 0)
            {
               _target.setPercX(0,false);
            }
            else
            {
               _target.setPercX((_loc3_ - _bar.x) / _loc5_,false);
            }
         }
      }
      
      private function __arrowButton1Click(param1:Event) : void
      {
         param1.stopPropagation();
         if(_vertical)
         {
            _target.scrollUp();
         }
         else
         {
            _target.scrollLeft();
         }
      }
      
      private function __arrowButton2Click(param1:Event) : void
      {
         param1.stopPropagation();
         if(_vertical)
         {
            _target.scrollDown();
         }
         else
         {
            _target.scrollRight();
         }
      }
      
      private function __barMouseDown(param1:GTouchEvent) : void
      {
         var _loc2_:Point = _grip.globalToLocal(param1.stageX,param1.stageY);
         if(_vertical)
         {
            if(_loc2_.y < 0)
            {
               _target.scrollUp(4);
            }
            else
            {
               _target.scrollDown(4);
            }
         }
         else if(_loc2_.x < 0)
         {
            _target.scrollLeft(4);
         }
         else
         {
            _target.scrollRight(4);
         }
      }
   }
}

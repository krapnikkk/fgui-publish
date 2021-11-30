package fairygui.editor.gui
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EGSlider extends ComExtention
   {
      
      public static const TITLE_PERCENT:String = "percent";
      
      public static const TITLE_VALUE_AND_MAX:String = "valueAndmax";
      
      public static const TITLE_VALUE_ONLY:String = "value";
      
      public static const TITLE_MAX_ONLY:String = "max";
       
      
      private var _max:int;
      
      private var _value:int;
      
      private var _titleType:String;
      
      private var _reverse:Boolean;
      
      private var _titleObject:EGTextField;
      
      private var _barObjectH:EGObject;
      
      private var _barObjectV:EGObject;
      
      private var _barMaxWidth:int;
      
      private var _barMaxHeight:int;
      
      private var _gripObject:EGObject;
      
      private var _clickPos:Point;
      
      private var _clickPercent:Number;
      
      private var _barMaxWidthDelta:int;
      
      private var _barMaxHeightDelta:int;
      
      private var _barStartX:int;
      
      private var _barStartY:int;
      
      public function EGSlider()
      {
         super();
         this._titleType = "percent";
         this._value = 50;
         this._max = 100;
         this._clickPos = new Point();
      }
      
      public function get titleType() : String
      {
         return this._titleType;
      }
      
      public function set titleType(param1:String) : void
      {
         this._titleType = param1;
         this.update();
      }
      
      public function get max() : int
      {
         return this._max;
      }
      
      public function set max(param1:int) : void
      {
         this._max = param1;
         this.update();
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function set value(param1:int) : void
      {
         this._value = param1;
         this.update();
      }
      
      public function get reverse() : Boolean
      {
         return this._reverse;
      }
      
      public function set reverse(param1:Boolean) : void
      {
         this._reverse = param1;
         this.update();
      }
      
      override protected function install() : void
      {
         this._titleObject = owner.getChild("title") as EGTextField;
         this._barObjectH = owner.getChild("bar");
         this._barObjectV = owner.getChild("bar_v");
         this._gripObject = owner.getChild("grip");
         _owner.statusDispatcher.addListener(2,this.__ownerSizeChanged);
         if(this._barObjectH)
         {
            this._barMaxWidth = this._barObjectH.width;
            this._barMaxWidthDelta = _owner.width - this._barMaxWidth;
            this._barStartX = this._barObjectH.x;
         }
         if(this._barObjectV)
         {
            this._barMaxHeight = this._barObjectV.height;
            this._barMaxHeightDelta = _owner.height - this._barMaxHeight;
            this._barStartY = this._barObjectV.y;
         }
         if(owner.editMode == 1)
         {
            if(this._gripObject)
            {
               this._gripObject.displayObject.addEventListener("mouseDown",this.__gripMouseDown);
               _owner.displayObject.addEventListener("mouseDown",this.__barMouseDown);
            }
         }
         this.update();
      }
      
      private function __ownerSizeChanged() : void
      {
         if(this._barObjectH)
         {
            this._barMaxWidth = _owner.width - this._barMaxWidthDelta;
         }
         if(this._barObjectV)
         {
            this._barMaxHeight = _owner.height - this._barMaxHeightDelta;
         }
         this.update();
      }
      
      override protected function uninstall() : void
      {
         if(owner.editMode == 1)
         {
            if(this._gripObject)
            {
               this._gripObject.displayObject.removeEventListener("mouseDown",this.__gripMouseDown);
               _owner.displayObject.addEventListener("mouseDown",this.__barMouseDown);
            }
         }
         this._titleObject = null;
         this._barObjectH = null;
         this._barObjectV = null;
         this._gripObject = null;
      }
      
      public function update() : void
      {
         var _loc1_:* = NaN;
         if(owner.editMode == 3)
         {
            return;
         }
         if(this._max > 0)
         {
            _loc1_ = Number(Math.min(this._value / this._max,1));
         }
         else
         {
            _loc1_ = 1;
         }
         this.updateWidthPercent(_loc1_);
      }
      
      private function updateWidthPercent(param1:Number) : void
      {
         if(this._titleObject)
         {
            var _loc4_:* = this._titleType;
            if("percent" !== _loc4_)
            {
               if("valueAndmax" !== _loc4_)
               {
                  if("value" !== _loc4_)
                  {
                     if("max" === _loc4_)
                     {
                        this._titleObject.text = "" + this._max;
                     }
                  }
                  else
                  {
                     this._titleObject.text = "" + this._value;
                  }
               }
               else
               {
                  this._titleObject.text = this._value + "/" + this.max;
               }
            }
            else
            {
               this._titleObject.text = Math.round(param1 * 100) + "%";
            }
         }
         var _loc3_:int = _owner.width - this._barMaxWidthDelta;
         var _loc2_:int = _owner.height - this._barMaxHeightDelta;
         if(!this._reverse)
         {
            if(this._barObjectH)
            {
               this._barObjectH.width = _loc3_ * param1;
            }
            if(this._barObjectV)
            {
               this._barObjectV.height = _loc2_ * param1;
            }
         }
         else
         {
            if(this._barObjectH)
            {
               this._barObjectH.width = Math.round(_loc3_ * param1);
               this._barObjectH.x = this._barStartX + (_loc3_ - this._barObjectH.width);
            }
            if(this._barObjectV)
            {
               this._barObjectV.height = Math.round(_loc2_ * param1);
               this._barObjectV.y = this._barStartY + (_loc2_ - this._barObjectV.height);
            }
         }
      }
      
      private function __gripMouseDown(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this._clickPos.x = this._gripObject.displayObject.stage.mouseX;
         this._clickPos.y = this._gripObject.displayObject.stage.mouseY;
         this._clickPercent = this._value / this._max;
         this._gripObject.displayObject.stage.addEventListener("mouseMove",this.__gripMouseMove);
         this._gripObject.displayObject.stage.addEventListener("mouseUp",this.__gripMouseUp);
      }
      
      private function __gripMouseMove(param1:MouseEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:int = param1.stageX - this._clickPos.x;
         var _loc2_:int = param1.stageY - this._clickPos.y;
         if(this._reverse)
         {
            _loc4_ = -_loc4_;
            _loc2_ = -_loc2_;
         }
         if(this._barObjectH)
         {
            _loc3_ = Number(this._clickPercent + _loc4_ / this._barMaxWidth);
         }
         else
         {
            _loc3_ = Number(this._clickPercent + _loc2_ / this._barMaxHeight);
         }
         if(_loc3_ > 1)
         {
            _loc3_ = 1;
         }
         else if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         this._value = Math.round(this._max * _loc3_);
         this.updateWidthPercent(_loc3_);
      }
      
      private function __gripMouseUp(param1:MouseEvent) : void
      {
         this._gripObject.displayObject.stage.removeEventListener("mouseMove",this.__gripMouseMove);
         this._gripObject.displayObject.stage.removeEventListener("mouseUp",this.__gripMouseUp);
      }
      
      private function __barMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Point = this._gripObject.displayObject.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc2_:* = Number(this._value / this._max);
         if(this._barObjectH)
         {
            _loc3_ = (_loc4_.x - this._gripObject.width / 2) / this._barMaxWidth;
         }
         if(this._barObjectV)
         {
            _loc3_ = (_loc4_.y - this._gripObject.height / 2) / this._barMaxHeight;
         }
         if(this._reverse)
         {
            _loc2_ = Number(_loc2_ - _loc3_);
         }
         else
         {
            _loc2_ = Number(_loc2_ + _loc3_);
         }
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         else if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         this._value = Math.round(this._max * _loc2_);
         this.updateWidthPercent(_loc2_);
      }
      
      override public function load(param1:XML) : void
      {
         var _loc2_:String = null;
         _loc2_ = param1.@titleType;
         if(_loc2_)
         {
            this._titleType = _loc2_;
         }
         else
         {
            this._titleType = "percent";
         }
         this._reverse = param1.@reverse == "true";
      }
      
      override public function serialize() : XML
      {
         var _loc1_:XML = <Slider/>;
         if(this._titleType != "percent")
         {
            _loc1_.@titleType = this._titleType;
         }
         if(this._reverse)
         {
            _loc1_.@reverse = "true";
         }
         return _loc1_;
      }
      
      override public function fromXML(param1:XML) : void
      {
         this._value = parseInt(param1.@value);
         this._max = parseInt(param1.@max);
         if(this._max == 0)
         {
            this._max = 100;
         }
         this.update();
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = <Slider/>;
         if(this._value)
         {
            _loc1_.@value = this._value;
         }
         if(this._max)
         {
            _loc1_.@max = this._max;
         }
         if(_loc1_.attributes().length() == 0)
         {
            return null;
         }
         return _loc1_;
      }
   }
}

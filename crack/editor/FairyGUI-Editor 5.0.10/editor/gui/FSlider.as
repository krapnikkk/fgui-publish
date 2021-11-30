package fairygui.editor.gui
{
   import fairygui.utils.ToolSet;
   import fairygui.utils.XData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class FSlider extends ComExtention
   {
      
      public static const TITLE_PERCENT:String = "percent";
      
      public static const TITLE_VALUE_AND_MAX:String = "valueAndmax";
      
      public static const TITLE_VALUE_ONLY:String = "value";
      
      public static const TITLE_MAX_ONLY:String = "max";
       
      
      private var _min:Number;
      
      private var _max:Number;
      
      private var _value:Number;
      
      private var _titleType:String;
      
      private var _wholeNumbers:Boolean;
      
      private var _reverse:Boolean;
      
      private var _titleObject:FTextField;
      
      private var _barObjectH:FObject;
      
      private var _barObjectV:FObject;
      
      private var _barMaxWidth:int;
      
      private var _barMaxHeight:int;
      
      private var _gripObject:FObject;
      
      private var _clickPos:Point;
      
      private var _clickPercent:Number;
      
      private var _barMaxWidthDelta:int;
      
      private var _barMaxHeightDelta:int;
      
      private var _barStartX:int;
      
      private var _barStartY:int;
      
      public var changeOnClick:Boolean = true;
      
      public function FSlider()
      {
         super();
         this._titleType = TITLE_PERCENT;
         this._value = 50;
         this._min = 0;
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
      
      public function get min() : Number
      {
         return this._min;
      }
      
      public function set min(param1:Number) : void
      {
         this._min = param1;
         this.update();
      }
      
      public function get max() : Number
      {
         return this._max;
      }
      
      public function set max(param1:Number) : void
      {
         this._max = param1;
         this.update();
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         this._value = param1;
         if(this._value < this._min)
         {
            this._value = this._min;
         }
         if(this._value > this._max)
         {
            this._value = this._max;
         }
         this.update();
      }
      
      public function get reverse() : Boolean
      {
         return this._reverse;
      }
      
      public function set reverse(param1:Boolean) : void
      {
         this._reverse = param1;
      }
      
      public function get wholeNumbers() : Boolean
      {
         return this._wholeNumbers;
      }
      
      public function set wholeNumbers(param1:Boolean) : void
      {
         this._wholeNumbers = param1;
      }
      
      override public function create() : void
      {
         this._titleObject = owner.getChild("title") as FTextField;
         this._barObjectH = owner.getChild("bar");
         this._barObjectV = owner.getChild("bar_v");
         this._gripObject = owner.getChild("grip");
         _owner.dispatcher.on(FObject.SIZE_CHANGED,this.__ownerSizeChanged);
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
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            if(this._gripObject)
            {
               this._gripObject.displayObject.addEventListener(MouseEvent.MOUSE_DOWN,this.__gripMouseDown);
               _owner.displayObject.addEventListener(MouseEvent.MOUSE_DOWN,this.__barMouseDown);
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
      
      override public function dispose() : void
      {
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            if(this._gripObject)
            {
               this._gripObject.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.__gripMouseDown);
               _owner.displayObject.addEventListener(MouseEvent.MOUSE_DOWN,this.__barMouseDown);
            }
         }
      }
      
      public function update() : void
      {
         if(FObjectFlags.isDocRoot(_owner._flags) != 0)
         {
            return;
         }
         this.updateWidthPercent((this._value - this._min) / (this._max - this._min),false);
      }
      
      private function updateWidthPercent(param1:Number, param2:Boolean) : void
      {
         var _loc5_:Number = NaN;
         param1 = ToolSet.clamp01(param1);
         if(param2)
         {
            _loc5_ = ToolSet.clamp(this._min + (this._max - this._min) * param1,this._min,this._max);
            if(this._wholeNumbers)
            {
               _loc5_ = Math.round(_loc5_);
               param1 = ToolSet.clamp01((_loc5_ - this._min) / (this._max - this._min));
            }
            if(_loc5_ != this._value)
            {
               this._value = _loc5_;
            }
         }
         if(this._titleObject)
         {
            switch(this._titleType)
            {
               case TITLE_PERCENT:
                  this._titleObject.text = Math.round(param1 * 100) + "%";
                  break;
               case TITLE_VALUE_AND_MAX:
                  this._titleObject.text = this._value + "/" + this.max;
                  break;
               case TITLE_VALUE_ONLY:
                  this._titleObject.text = "" + this._value;
                  break;
               case TITLE_MAX_ONLY:
                  this._titleObject.text = "" + this._max;
            }
         }
         var _loc3_:int = _owner.width - this._barMaxWidthDelta;
         var _loc4_:int = _owner.height - this._barMaxHeightDelta;
         if(!this._reverse)
         {
            if(this._barObjectH)
            {
               this._barObjectH.width = _loc3_ * param1;
            }
            if(this._barObjectV)
            {
               this._barObjectV.height = _loc4_ * param1;
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
               this._barObjectV.height = Math.round(_loc4_ * param1);
               this._barObjectV.y = this._barStartY + (_loc4_ - this._barObjectV.height);
            }
         }
      }
      
      private function __gripMouseDown(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this._clickPos = _owner.globalToLocal(param1.stageX,param1.stageY);
         this._clickPercent = ToolSet.clamp01((this._value - this._min) / (this._max - this._min));
         this._gripObject.displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__gripMouseMove);
         this._gripObject.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP,this.__gripMouseUp);
      }
      
      private function __gripMouseMove(param1:MouseEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Point = _owner.globalToLocal(param1.stageX,param1.stageY);
         var _loc3_:int = _loc2_.x - this._clickPos.x;
         var _loc4_:int = _loc2_.y - this._clickPos.y;
         if(this._reverse)
         {
            _loc3_ = -_loc3_;
            _loc4_ = -_loc4_;
         }
         if(this._barObjectH)
         {
            _loc5_ = this._clickPercent + _loc3_ / this._barMaxWidth;
         }
         else
         {
            _loc5_ = this._clickPercent + _loc4_ / this._barMaxHeight;
         }
         this.updateWidthPercent(_loc5_,true);
      }
      
      private function __gripMouseUp(param1:MouseEvent) : void
      {
         this._gripObject.displayObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__gripMouseMove);
         this._gripObject.displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__gripMouseUp);
      }
      
      private function __barMouseDown(param1:MouseEvent) : void
      {
         var _loc4_:Number = NaN;
         if(!this.changeOnClick)
         {
            return;
         }
         var _loc2_:Point = this._gripObject.globalToLocal(param1.stageX,param1.stageY);
         var _loc3_:Number = ToolSet.clamp01((this._value - this._min) / (this._max - this._min));
         if(this._barObjectH)
         {
            _loc4_ = _loc2_.x / this._barMaxWidth;
         }
         if(this._barObjectV)
         {
            _loc4_ = _loc2_.y / this._barMaxHeight;
         }
         if(this._reverse)
         {
            _loc3_ = _loc3_ - _loc4_;
         }
         else
         {
            _loc3_ = _loc3_ + _loc4_;
         }
         this.updateWidthPercent(_loc3_,true);
      }
      
      override public function read_editMode(param1:XData) : void
      {
         this._titleType = param1.getAttribute("titleType",TITLE_PERCENT);
         this._reverse = param1.getAttributeBool("reverse");
         this._wholeNumbers = param1.getAttributeBool("wholeNumbers");
         this.changeOnClick = param1.getAttributeBool("changeOnClick",true);
      }
      
      override public function write_editMode() : XData
      {
         var _loc1_:XData = XData.create("Slider");
         if(this._titleType != TITLE_PERCENT)
         {
            _loc1_.setAttribute("titleType",this._titleType);
         }
         if(this._reverse)
         {
            _loc1_.setAttribute("reverse",true);
         }
         if(this._wholeNumbers)
         {
            _loc1_.setAttribute("wholeNumbers",true);
         }
         if(!this.changeOnClick)
         {
            _loc1_.setAttribute("changeOnClick",false);
         }
         return _loc1_;
      }
      
      override public function read(param1:XData, param2:Object) : void
      {
         this._value = param1.getAttributeInt("value");
         this._max = param1.getAttributeInt("max");
         this._min = param1.getAttributeInt("min");
         if(this._max == 0)
         {
            this._max = 100;
         }
         this.update();
      }
      
      override public function write() : XData
      {
         var _loc1_:XData = XData.create("Slider");
         if(this._value)
         {
            _loc1_.setAttribute("value",this._value);
         }
         if(this._max)
         {
            _loc1_.setAttribute("max",this._max);
         }
         if(this._min)
         {
            _loc1_.setAttribute("min",this._min);
         }
         if(_loc1_.hasAttributes())
         {
            return _loc1_;
         }
         return null;
      }
   }
}

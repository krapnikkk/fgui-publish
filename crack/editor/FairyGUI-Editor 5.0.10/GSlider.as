package fairygui
{
   import fairygui.event.GTouchEvent;
   import fairygui.event.StateChangeEvent;
   import fairygui.utils.ToolSet;
   import flash.geom.Point;
   
   public class GSlider extends GComponent
   {
       
      
      private var _min:Number;
      
      private var _max:Number;
      
      private var _value:Number;
      
      private var _titleType:int;
      
      private var _reverse:Boolean;
      
      private var _wholeNumbers:Boolean;
      
      private var _titleObject:GTextField;
      
      private var _barObjectH:GObject;
      
      private var _barObjectV:GObject;
      
      private var _barMaxWidth:int;
      
      private var _barMaxHeight:int;
      
      private var _barMaxWidthDelta:int;
      
      private var _barMaxHeightDelta:int;
      
      private var _gripObject:GObject;
      
      private var _clickPos:Point;
      
      private var _clickPercent:Number;
      
      private var _barStartX:int;
      
      private var _barStartY:int;
      
      public var changeOnClick:Boolean = true;
      
      public var canDrag:Boolean = true;
      
      public function GSlider()
      {
         super();
         _titleType = 0;
         _value = 50;
         _max = 100;
         _clickPos = new Point();
      }
      
      public final function get titleType() : int
      {
         return _titleType;
      }
      
      public final function set titleType(param1:int) : void
      {
         _titleType = param1;
      }
      
      public function get wholeNumbers() : Boolean
      {
         return _wholeNumbers;
      }
      
      public function set wholeNumbers(param1:Boolean) : void
      {
         if(_wholeNumbers != param1)
         {
            _wholeNumbers = param1;
            update();
         }
      }
      
      public function get min() : Number
      {
         return _min;
      }
      
      public function set min(param1:Number) : void
      {
         if(_min != param1)
         {
            _min = param1;
            update();
         }
      }
      
      public final function get max() : Number
      {
         return _max;
      }
      
      public final function set max(param1:Number) : void
      {
         if(_max != param1)
         {
            _max = param1;
            update();
         }
      }
      
      public final function get value() : Number
      {
         return _value;
      }
      
      public final function set value(param1:Number) : void
      {
         if(_value != param1)
         {
            _value = param1;
            update();
         }
      }
      
      public function update() : void
      {
         updateWithPercent((_value - _min) / (_max - _min),false);
      }
      
      private function updateWithPercent(param1:Number, param2:Boolean) : void
      {
         var _loc3_:Number = NaN;
         param1 = ToolSet.clamp01(param1);
         if(param2)
         {
            _loc3_ = ToolSet.clamp(_min + (_max - _min) * param1,_min,_max);
            if(_wholeNumbers)
            {
               _loc3_ = Math.round(_loc3_);
               param1 = ToolSet.clamp01((_loc3_ - _min) / (_max - _min));
            }
            if(_loc3_ != _value)
            {
               _value = _loc3_;
               dispatchEvent(new StateChangeEvent("stateChanged"));
            }
         }
         if(_titleObject)
         {
            switch(int(_titleType))
            {
               case 0:
                  _titleObject.text = Math.round(param1 * 100) + "%";
                  break;
               case 1:
                  _titleObject.text = _value + "/" + _max;
                  break;
               case 2:
                  _titleObject.text = "" + _value;
                  break;
               case 3:
                  _titleObject.text = "" + _max;
            }
         }
         var _loc5_:int = this.width - this._barMaxWidthDelta;
         var _loc4_:int = this.height - this._barMaxHeightDelta;
         if(!_reverse)
         {
            if(_barObjectH)
            {
               _barObjectH.width = Math.round(_loc5_ * param1);
            }
            if(_barObjectV)
            {
               _barObjectV.height = Math.round(_loc4_ * param1);
            }
         }
         else
         {
            if(_barObjectH)
            {
               _barObjectH.width = Math.round(_loc5_ * param1);
               _barObjectH.x = _barStartX + (_loc5_ - _barObjectH.width);
            }
            if(_barObjectV)
            {
               _barObjectV.height = Math.round(_loc4_ * param1);
               _barObjectV.y = _barStartY + (_loc4_ - _barObjectV.height);
            }
         }
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:* = null;
         super.constructFromXML(param1);
         param1 = param1.Slider[0];
         _loc2_ = param1.@titleType;
         if(_loc2_)
         {
            _titleType = ProgressTitleType.parse(_loc2_);
         }
         _reverse = param1.@reverse == "true";
         _wholeNumbers = param1.@wholeNumbers == "true";
         changeOnClick = param1.@changeOnClick != "false";
         _titleObject = getChild("title") as GTextField;
         _barObjectH = getChild("bar");
         _barObjectV = getChild("bar_v");
         _gripObject = getChild("grip");
         if(_barObjectH)
         {
            _barMaxWidth = _barObjectH.width;
            _barMaxWidthDelta = this.width - _barMaxWidth;
            _barStartX = _barObjectH.x;
         }
         if(_barObjectV)
         {
            _barMaxHeight = _barObjectV.height;
            _barMaxHeightDelta = this.height - _barMaxHeight;
            _barStartY = _barObjectV.y;
         }
         if(_gripObject)
         {
            _gripObject.addEventListener("beginGTouch",__gripMouseDown);
            _gripObject.addEventListener("dragGTouch",__gripMouseMove);
         }
         addEventListener("beginGTouch",__barMouseDown);
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(_barObjectH)
         {
            _barMaxWidth = this.width - _barMaxWidthDelta;
         }
         if(_barObjectV)
         {
            _barMaxHeight = this.height - _barMaxHeightDelta;
         }
         if(!this._underConstruct)
         {
            update();
         }
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         super.setup_afterAdd(param1);
         param1 = param1.Slider[0];
         if(param1)
         {
            _value = parseInt(param1.@value);
            if(isNaN(_value))
            {
               _value = 0;
            }
            _max = parseInt(param1.@max);
            if(isNaN(_max))
            {
               _max = 0;
            }
            _min = parseInt(param1.@min);
            if(isNaN(_min))
            {
               _min = 0;
            }
         }
         update();
      }
      
      private function __gripMouseDown(param1:GTouchEvent) : void
      {
         this.canDrag = true;
         param1.stopPropagation();
         _clickPos = this.globalToLocal(param1.stageX,param1.stageY);
         _clickPercent = ToolSet.clamp01((_value - _min) / (_max - _min));
      }
      
      private function __gripMouseMove(param1:GTouchEvent) : void
      {
         var _loc5_:Number = NaN;
         if(!this.canDrag)
         {
            return;
         }
         var _loc2_:Point = this.globalToLocal(param1.stageX,param1.stageY);
         var _loc3_:int = _loc2_.x - _clickPos.x;
         var _loc4_:int = _loc2_.y - _clickPos.y;
         if(_reverse)
         {
            _loc3_ = -_loc3_;
            _loc4_ = -_loc4_;
         }
         if(_barObjectH)
         {
            _loc5_ = _clickPercent + _loc3_ / _barMaxWidth;
         }
         else
         {
            _loc5_ = _clickPercent + _loc4_ / _barMaxHeight;
         }
         updateWithPercent(_loc5_,true);
      }
      
      private function __barMouseDown(param1:GTouchEvent) : void
      {
         var _loc3_:Number = NaN;
         if(!changeOnClick)
         {
            return;
         }
         var _loc2_:Point = _gripObject.globalToLocal(param1.stageX,param1.stageY);
         var _loc4_:Number = ToolSet.clamp01((_value - _min) / (_max - _min));
         if(_barObjectH)
         {
            _loc3_ = (_loc2_.x - _gripObject.width / 2) / _barMaxWidth;
         }
         if(_barObjectV)
         {
            _loc3_ = (_loc2_.y - _gripObject.height / 2) / _barMaxHeight;
         }
         if(_reverse)
         {
            _loc4_ = _loc4_ - _loc3_;
         }
         else
         {
            _loc4_ = _loc4_ + _loc3_;
         }
         updateWithPercent(_loc4_,true);
      }
   }
}

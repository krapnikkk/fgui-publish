package fairygui
{
   import fairygui.event.GTouchEvent;
   import fairygui.event.StateChangeEvent;
   import flash.geom.Point;
   
   public class GSlider extends GComponent
   {
       
      
      private var _max:int;
      
      private var _value:int;
      
      private var _titleType:int;
      
      private var _reverse:Boolean;
      
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
      
      public final function get max() : int
      {
         return _max;
      }
      
      public final function set max(param1:int) : void
      {
         if(_max != param1)
         {
            _max = param1;
            update();
         }
      }
      
      public final function get value() : int
      {
         return _value;
      }
      
      public final function set value(param1:int) : void
      {
         if(_value != param1)
         {
            _value = param1;
            update();
         }
      }
      
      public function update() : void
      {
         var _loc1_:Number = Math.min(_value / _max,1);
         updateWidthPercent(_loc1_);
      }
      
      private function updateWidthPercent(param1:Number) : void
      {
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
         var _loc2_:int = this.width - this._barMaxWidthDelta;
         var _loc3_:int = this.height - this._barMaxHeightDelta;
         if(!_reverse)
         {
            if(_barObjectH)
            {
               _barObjectH.width = _loc2_ * param1;
            }
            if(_barObjectV)
            {
               _barObjectV.height = _loc3_ * param1;
            }
         }
         else
         {
            if(_barObjectH)
            {
               _barObjectH.width = Math.round(_loc2_ * param1);
               _barObjectH.x = _barStartX + (_loc2_ - _barObjectH.width);
            }
            if(_barObjectV)
            {
               _barObjectV.height = Math.round(_loc3_ * param1);
               _barObjectV.y = _barStartY + (_loc3_ - _barObjectV.height);
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
            _max = parseInt(param1.@max);
         }
         update();
      }
      
      private function __gripMouseDown(param1:GTouchEvent) : void
      {
         this.canDrag = true;
         param1.stopPropagation();
         _clickPos = this.globalToLocal(param1.stageX,param1.stageY);
         _clickPercent = _value / _max;
      }
      
      private function __gripMouseMove(param1:GTouchEvent) : void
      {
         var _loc3_:* = NaN;
         if(!this.canDrag)
         {
            return;
         }
         var _loc4_:Point = this.globalToLocal(param1.stageX,param1.stageY);
         var _loc5_:int = _loc4_.x - _clickPos.x;
         var _loc6_:int = _loc4_.y - _clickPos.y;
         if(_reverse)
         {
            _loc5_ = -_loc5_;
            _loc6_ = -_loc6_;
         }
         if(_barObjectH)
         {
            _loc3_ = Number(_clickPercent + _loc5_ / _barMaxWidth);
         }
         else
         {
            _loc3_ = Number(_clickPercent + _loc6_ / _barMaxHeight);
         }
         if(_loc3_ > 1)
         {
            _loc3_ = 1;
         }
         else if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         var _loc2_:int = Math.round(_max * _loc3_);
         if(_loc2_ != _value)
         {
            _value = _loc2_;
            dispatchEvent(new StateChangeEvent("stateChanged"));
         }
         updateWidthPercent(_loc3_);
      }
      
      private function __barMouseDown(param1:GTouchEvent) : void
      {
         var _loc4_:Number = NaN;
         if(!changeOnClick)
         {
            return;
         }
         var _loc5_:Point = _gripObject.globalToLocal(param1.stageX,param1.stageY);
         var _loc3_:* = Number(_value / _max);
         if(_barObjectH)
         {
            _loc4_ = (_loc5_.x - _gripObject.width / 2) / _barMaxWidth;
         }
         if(_barObjectV)
         {
            _loc4_ = (_loc5_.y - _gripObject.height / 2) / _barMaxHeight;
         }
         if(_reverse)
         {
            _loc3_ = Number(_loc3_ - _loc4_);
         }
         else
         {
            _loc3_ = Number(_loc3_ + _loc4_);
         }
         if(_loc3_ > 1)
         {
            _loc3_ = 1;
         }
         else if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         var _loc2_:int = Math.round(_max * _loc3_);
         if(_loc2_ != _value)
         {
            _value = _loc2_;
            dispatchEvent(new StateChangeEvent("stateChanged"));
         }
         updateWidthPercent(_loc3_);
      }
   }
}

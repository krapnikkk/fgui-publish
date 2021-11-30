package fairygui
{
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.ToolSet;
   
   public class GProgressBar extends GComponent
   {
       
      
      private var _min:Number;
      
      private var _max:Number;
      
      private var _value:Number;
      
      private var _titleType:int;
      
      private var _reverse:Boolean;
      
      private var _titleObject:GTextField;
      
      private var _aniObject:GObject;
      
      private var _barObjectH:GObject;
      
      private var _barObjectV:GObject;
      
      private var _barMaxWidth:int;
      
      private var _barMaxHeight:int;
      
      private var _barMaxWidthDelta:int;
      
      private var _barMaxHeightDelta:int;
      
      private var _barStartX:int;
      
      private var _barStartY:int;
      
      public function GProgressBar()
      {
         super();
         _titleType = 0;
         _value = 50;
         _max = 100;
      }
      
      public final function get titleType() : int
      {
         return _titleType;
      }
      
      public final function set titleType(param1:int) : void
      {
         if(_titleType != param1)
         {
            _titleType = param1;
            update(_value);
         }
      }
      
      public final function get min() : Number
      {
         return _min;
      }
      
      public final function set min(param1:Number) : void
      {
         if(_min != param1)
         {
            _min = param1;
            update(_value);
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
            update(_value);
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
            GTween.kill(this,false,this.update);
            _value = param1;
            if(_value < _min)
            {
               _value = _min;
            }
            if(_value > _max)
            {
               _value = _max;
            }
            update(_value);
         }
      }
      
      public function tweenValue(param1:Number, param2:Number) : GTweener
      {
         var _loc3_:Number = NaN;
         var _loc4_:GTweener = GTween.getTween(this,this.update);
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_.value.x;
            _loc4_.kill();
         }
         else
         {
            _loc3_ = _value;
         }
         _value = param1;
         return GTween.to(_loc3_,_value,param2).setTarget(this,this.update).setEase(0);
      }
      
      public function update(param1:int) : void
      {
         var _loc4_:Number = ToolSet.clamp01((_value - _min) / (_max - _min));
         if(_titleObject)
         {
            switch(int(_titleType))
            {
               case 0:
                  _titleObject.text = Math.round(_loc4_ * 100) + "%";
                  break;
               case 1:
                  _titleObject.text = Math.round(param1) + "/" + Math.round(_max);
                  break;
               case 2:
                  _titleObject.text = "" + Math.round(param1);
                  break;
               case 3:
                  _titleObject.text = "" + Math.round(_max);
            }
         }
         var _loc3_:int = this.width - this._barMaxWidthDelta;
         var _loc2_:int = this.height - this._barMaxHeightDelta;
         if(!_reverse)
         {
            if(_barObjectH)
            {
               _barObjectH.width = Math.round(_loc3_ * _loc4_);
            }
            if(_barObjectV)
            {
               _barObjectV.height = Math.round(_loc2_ * _loc4_);
            }
         }
         else
         {
            if(_barObjectH)
            {
               _barObjectH.width = Math.round(_loc3_ * _loc4_);
               _barObjectH.x = _barStartX + (_loc3_ - _barObjectH.width);
            }
            if(_barObjectV)
            {
               _barObjectV.height = Math.round(_loc2_ * _loc4_);
               _barObjectV.y = _barStartY + (_loc2_ - _barObjectV.height);
            }
         }
         if(_aniObject is GMovieClip)
         {
            GMovieClip(_aniObject).frame = Math.round(_loc4_ * 100);
         }
         else if(_aniObject is GSwfObject)
         {
            GSwfObject(_aniObject).frame = Math.round(_loc4_ * 100);
         }
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:* = null;
         super.constructFromXML(param1);
         param1 = param1.ProgressBar[0];
         _loc2_ = param1.@titleType;
         if(_loc2_)
         {
            _titleType = ProgressTitleType.parse(_loc2_);
         }
         _reverse = param1.@reverse == "true";
         _titleObject = getChild("title") as GTextField;
         _barObjectH = getChild("bar");
         _barObjectV = getChild("bar_v");
         _aniObject = getChild("ani");
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
            update(_value);
         }
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         super.setup_afterAdd(param1);
         param1 = param1.ProgressBar[0];
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
         update(_value);
      }
   }
}

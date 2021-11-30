package fairygui.editor.gui
{
   import fairygui.GMovieClip;
   import fairygui.utils.ToolSet;
   import fairygui.utils.XData;
   
   public class FProgressBar extends ComExtention
   {
      
      public static const TITLE_PERCENT:String = "percent";
      
      public static const TITLE_VALUE_AND_MAX:String = "valueAndmax";
      
      public static const TITLE_VALUE_ONLY:String = "value";
      
      public static const TITLE_MAX_ONLY:String = "max";
       
      
      private var _min:int;
      
      private var _max:int;
      
      private var _value:int;
      
      private var _titleType:String;
      
      private var _reverse:Boolean;
      
      private var _titleObject:FTextField;
      
      private var _aniObject:GMovieClip;
      
      private var _barObjectH:FObject;
      
      private var _barObjectV:FObject;
      
      private var _barMaxWidth:int;
      
      private var _barMaxHeight:int;
      
      private var _barMaxWidthDelta:int;
      
      private var _barMaxHeightDelta:int;
      
      private var _barStartX:int;
      
      private var _barStartY:int;
      
      public function FProgressBar()
      {
         super();
         this._titleType = TITLE_PERCENT;
         this._value = 50;
         this._min = 0;
         this._max = 100;
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
      
      public function get min() : int
      {
         return this._min;
      }
      
      public function set min(param1:int) : void
      {
         this._min = param1;
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
         this.update();
      }
      
      override public function create() : void
      {
         this._titleObject = owner.getChild("title") as FTextField;
         this._barObjectH = owner.getChild("bar");
         this._barObjectV = owner.getChild("bar_v");
         this._aniObject = owner.getChild("ani") as GMovieClip;
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
      
      public function update() : void
      {
         if(FObjectFlags.isDocRoot(_owner._flags))
         {
            return;
         }
         var _loc1_:Number = ToolSet.clamp01((this._value - this._min) / (this._max - this._min));
         if(this._titleObject)
         {
            switch(this._titleType)
            {
               case TITLE_PERCENT:
                  this._titleObject.text = Math.floor(_loc1_ * 100) + "%";
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
         var _loc2_:int = _owner.width - this._barMaxWidthDelta;
         var _loc3_:int = _owner.height - this._barMaxHeightDelta;
         if(!this._reverse)
         {
            if(this._barObjectH)
            {
               if(this._barObjectH is FImage && FImage(this._barObjectH).fillMethod != "none")
               {
                  FImage(this._barObjectH).fillAmount = _loc1_ * 100;
               }
               else if(this._barObjectH is FLoader && FLoader(this._barObjectH).fillMethod != "none")
               {
                  FLoader(this._barObjectH).fillAmount = _loc1_ * 100;
               }
               else
               {
                  this._barObjectH.width = _loc2_ * _loc1_;
               }
            }
            if(this._barObjectV)
            {
               if(this._barObjectV is FImage && FImage(this._barObjectV).fillMethod != "none")
               {
                  FImage(this._barObjectV).fillAmount = _loc1_ * 100;
               }
               else if(this._barObjectV is FLoader && FLoader(this._barObjectV).fillMethod != "none")
               {
                  FLoader(this._barObjectV).fillAmount = _loc1_ * 100;
               }
               else
               {
                  this._barObjectV.height = _loc3_ * _loc1_;
               }
            }
         }
         else
         {
            if(this._barObjectH)
            {
               if(this._barObjectH is FImage && FImage(this._barObjectH).fillMethod != "none")
               {
                  FImage(this._barObjectH).fillAmount = (1 - _loc1_) * 100;
               }
               else if(this._barObjectH is FLoader && FLoader(this._barObjectH).fillMethod != "none")
               {
                  FLoader(this._barObjectH).fillAmount = (1 - _loc1_) * 100;
               }
               else
               {
                  this._barObjectH.width = Math.round(_loc2_ * _loc1_);
                  this._barObjectH.x = this._barStartX + (_loc2_ - this._barObjectH.width);
               }
            }
            if(this._barObjectV)
            {
               if(this._barObjectV is FImage && FImage(this._barObjectV).fillMethod != "none")
               {
                  FImage(this._barObjectV).fillAmount = (1 - _loc1_) * 100;
               }
               else if(this._barObjectV is FLoader && FLoader(this._barObjectV).fillMethod != "none")
               {
                  FLoader(this._barObjectV).fillAmount = (1 - _loc1_) * 100;
               }
               else
               {
                  this._barObjectV.height = Math.round(_loc3_ * _loc1_);
                  this._barObjectV.y = this._barStartY + (_loc3_ - this._barObjectV.height);
               }
            }
         }
         if(this._aniObject)
         {
            this._aniObject.frame = Math.round(_loc1_ * 100);
         }
      }
      
      override public function read_editMode(param1:XData) : void
      {
         this._titleType = param1.getAttribute("titleType",TITLE_PERCENT);
         this._reverse = param1.getAttributeBool("reverse");
      }
      
      override public function write_editMode() : XData
      {
         var _loc1_:XData = XData.create("ProgressBar");
         if(this._titleType != TITLE_PERCENT)
         {
            _loc1_.setAttribute("titleType",this._titleType);
         }
         if(this._reverse)
         {
            _loc1_.setAttribute("reverse",true);
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
         var _loc1_:XData = XData.create("ProgressBar");
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

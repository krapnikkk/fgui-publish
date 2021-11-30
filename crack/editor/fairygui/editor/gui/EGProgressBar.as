package fairygui.editor.gui
{
   public class EGProgressBar extends ComExtention
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
      
      private var _aniObject:EGAniObject;
      
      private var _barObjectH:EGObject;
      
      private var _barObjectV:EGObject;
      
      private var _barMaxWidth:int;
      
      private var _barMaxHeight:int;
      
      private var _barMaxWidthDelta:int;
      
      private var _barMaxHeightDelta:int;
      
      private var _barStartX:int;
      
      private var _barStartY:int;
      
      public function EGProgressBar()
      {
         super();
         this._titleType = "percent";
         this._value = 50;
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
         this._aniObject = owner.getChild("ani") as EGAniObject;
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
         this._titleObject = null;
         this._barObjectH = null;
         this._barObjectV = null;
         this._aniObject = null;
      }
      
      public function update() : void
      {
         if(owner.editMode == 3)
         {
            return;
         }
         var _loc3_:Number = this._max > 0?Number(Math.min(this._value / this._max,1)):1;
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
               this._titleObject.text = Math.round(_loc3_ * 100) + "%";
            }
         }
         var _loc2_:int = _owner.width - this._barMaxWidthDelta;
         var _loc1_:int = _owner.height - this._barMaxHeightDelta;
         if(!this._reverse)
         {
            if(this._barObjectH)
            {
               if(this._barObjectH is EGImage && EGImage(this._barObjectH).fillMethod != "none")
               {
                  EGImage(this._barObjectH).fillAmount = _loc3_ * 100;
               }
               else if(this._barObjectH is EGLoader && EGLoader(this._barObjectH).fillMethod != "none")
               {
                  EGLoader(this._barObjectH).fillAmount = _loc3_ * 100;
               }
               else
               {
                  this._barObjectH.width = _loc2_ * _loc3_;
               }
            }
            if(this._barObjectV)
            {
               if(this._barObjectV is EGImage && EGImage(this._barObjectV).fillMethod != "none")
               {
                  EGImage(this._barObjectV).fillAmount = _loc3_ * 100;
               }
               else if(this._barObjectV is EGLoader && EGLoader(this._barObjectV).fillMethod != "none")
               {
                  EGLoader(this._barObjectV).fillAmount = _loc3_ * 100;
               }
               else
               {
                  this._barObjectV.height = _loc1_ * _loc3_;
               }
            }
         }
         else
         {
            if(this._barObjectH)
            {
               if(this._barObjectH is EGImage && EGImage(this._barObjectH).fillMethod != "none")
               {
                  EGImage(this._barObjectH).fillAmount = (1 - _loc3_) * 100;
               }
               else if(this._barObjectH is EGLoader && EGLoader(this._barObjectH).fillMethod != "none")
               {
                  EGLoader(this._barObjectH).fillAmount = (1 - _loc3_) * 100;
               }
               else
               {
                  this._barObjectH.width = Math.round(_loc2_ * _loc3_);
                  this._barObjectH.x = this._barStartX + (_loc2_ - this._barObjectH.width);
               }
            }
            if(this._barObjectV)
            {
               if(this._barObjectV is EGImage && EGImage(this._barObjectV).fillMethod != "none")
               {
                  EGImage(this._barObjectV).fillAmount = (1 - _loc3_) * 100;
               }
               else if(this._barObjectV is EGLoader && EGLoader(this._barObjectV).fillMethod != "none")
               {
                  EGLoader(this._barObjectV).fillAmount = (1 - _loc3_) * 100;
               }
               else
               {
                  this._barObjectV.height = Math.round(_loc1_ * _loc3_);
                  this._barObjectV.y = this._barStartY + (_loc1_ - this._barObjectV.height);
               }
            }
         }
         if(this._aniObject)
         {
            this._aniObject.frame = Math.round(_loc3_ * 100);
         }
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
         var _loc1_:XML = <ProgressBar/>;
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
         var _loc1_:XML = <ProgressBar/>;
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

package fairygui.editor.extui
{
   import fairygui.Controller;
   import fairygui.GLabel;
   import fairygui.GObject;
   import fairygui.GTextField;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class NumericInput extends GLabel
   {
       
      
      private var _min:Number;
      
      private var _max:Number;
      
      private var _value:Number;
      
      private var _holder:GObject;
      
      private var _lastHolderPos:Point;
      
      private var _dragged:Boolean;
      
      private var _fractionDigits:int;
      
      private var _step:Number;
      
      private var _c1:Controller;
      
      public function NumericInput()
      {
         super();
         this._min = 0;
         this._max = 2147483647;
         this._value = 0;
         this._step = 1;
         this._fractionDigits = 0;
         this._lastHolderPos = new Point();
      }
      
      public function get max() : Number
      {
         return this._max;
      }
      
      public function set max(param1:Number) : void
      {
         this._max = param1;
      }
      
      public function get min() : Number
      {
         return this._min;
      }
      
      public function set min(param1:Number) : void
      {
         this._min = param1;
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         this._value = param1;
         if(this._value > this._max)
         {
            this._value = this._max;
         }
         else if(this._value < this._min)
         {
            this._value = this._min;
         }
         .super.text = UtilsStr.toFixed(this._value,this._fractionDigits);
      }
      
      public function get step() : Number
      {
         return this._step;
      }
      
      public function set step(param1:Number) : void
      {
         this._step = param1;
      }
      
      public function get fractionDigits() : int
      {
         return this._fractionDigits;
      }
      
      public function set fractionDigits(param1:int) : void
      {
         this._fractionDigits = param1;
      }
      
      override public function set text(param1:String) : void
      {
         this._value = parseFloat(param1);
         if(isNaN(this._value))
         {
            this._value = 0;
         }
         if(this._value > this._max)
         {
            this._value = this._max;
         }
         else if(this._value < this._min)
         {
            this._value = this._min;
         }
         .super.text = UtilsStr.toFixed(this._value,this._fractionDigits);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this.opaque = true;
         this._holder = getChild("holder");
         this._holder.draggable = true;
         this._holder.addEventListener("startDrag",this.__holderDragStart);
         this._holder.addEventListener("endDrag",this.__holderDragEnd);
         this._c1 = getController("c1");
         this._c1.selectedIndex = 0;
         var _loc2_:GTextField = this.getTextField();
         _loc2_.touchable = false;
         _loc2_.asTextInput.disableIME = true;
         _loc2_.addEventListener("focusOut",this.__focusOut);
         _loc2_.addEventListener("keyDown",this.__keyDown);
         this._holder.addClickListener(this.__click);
         this._holder.addEventListener("mouseWheel",this.__mouseWheel);
         this.displayObject.addEventListener("mouseDown",this.__mousedown);
         this.addEventListener("addedToStage",this.__addedToStage);
      }
      
      private function __addedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",this.__addedToStage);
         EditorWindow.getInstance(this).cursorManager.setCursorForObject(this.displayObject,CursorManager.ADJUST,this.__changeCursor,true);
      }
      
      private function __holderDragStart(param1:Event) : void
      {
         if(this._c1.selectedIndex == 1)
         {
            param1.preventDefault();
         }
         else
         {
            this._dragged = true;
            this._holder.addXYChangeCallback(this.__holderXYChanged);
         }
      }
      
      private function __holderDragEnd(param1:Event) : void
      {
         this._holder.removeXYChangeCallback(this.__holderXYChanged);
         this._holder.setXY(0,0);
         this._lastHolderPos.x = 0;
         this._lastHolderPos.y = 0;
      }
      
      private function __holderXYChanged() : void
      {
         var _loc3_:int = this._holder.x - this._lastHolderPos.x;
         var _loc2_:int = this._holder.y - this._lastHolderPos.y;
         var _loc1_:int = Math.abs(_loc3_) > Math.abs(_loc2_)?int(_loc3_):int(_loc2_);
         if(_loc1_ != 0)
         {
            this._lastHolderPos.x = this._holder.x;
            this._lastHolderPos.y = this._holder.y;
            this.text = "" + (this._value + _loc1_ * this._step);
            this.dispatchEvent(new SubmitEvent("__submit"));
         }
      }
      
      private function __click(param1:Event) : void
      {
         if(this._dragged)
         {
            this._dragged = false;
            return;
         }
         this._c1.selectedIndex = 1;
         this._titleObject.touchable = true;
         EditorWindow.getInstance(this).cursorManager.updateCursor();
         var _loc2_:TextField = this._titleObject.displayObject as TextField;
         this.root.nativeStage.focus = _loc2_;
         _loc2_.setSelection(0,_loc2_.length);
      }
      
      private function __focusOut(param1:Event) : void
      {
         var _loc2_:* = Number(parseFloat(this.text));
         if(isNaN(_loc2_))
         {
            _loc2_ = 0;
         }
         if(_loc2_ < this._min)
         {
            _loc2_ = Number(this._min);
         }
         else if(_loc2_ > this._max)
         {
            _loc2_ = Number(this._max);
         }
         this._c1.selectedIndex = 0;
         this._titleObject.touchable = false;
         if(_loc2_ != this._value)
         {
            this.text = "" + _loc2_;
            this.dispatchEvent(new SubmitEvent("__submit"));
         }
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:* = NaN;
         if(param1.keyCode == 13)
         {
            _loc2_ = Number(parseFloat(this.text));
            if(isNaN(_loc2_))
            {
               _loc2_ = 0;
            }
            if(_loc2_ < this._min)
            {
               _loc2_ = Number(this._min);
            }
            else if(_loc2_ > this._max)
            {
               _loc2_ = Number(this._max);
            }
            param1.preventDefault();
            if(_loc2_ != this._value)
            {
               this._value = _loc2_;
               this.dispatchEvent(new SubmitEvent("__submit"));
            }
         }
      }
      
      private function __changeCursor() : Boolean
      {
         return !this._titleObject.touchable;
      }
      
      private function __mouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta < 0)
         {
            this.value = this.value + this._step;
         }
         else
         {
            this.value = this.value - this._step;
         }
         this.dispatchEvent(new SubmitEvent("__submit"));
      }
      
      private function __mousedown(param1:Event) : void
      {
         param1.stopPropagation();
      }
   }
}

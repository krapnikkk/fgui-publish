package fairygui.editor.dialogs
{
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.GLabel;
   import fairygui.GObject;
   import fairygui.GSlider;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.extui.SubmitEvent;
   import fairygui.editor.utils.UtilsColor;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.GTouchEvent;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class ColorPickerDialog extends WindowBase
   {
       
      
      private var _input:ColorInput;
      
      private var _sbBox:GComponent;
      
      private var _sbArea:GGraph;
      
      private var _sbValue:GObject;
      
      private var _currentColorBox:GGraph;
      
      private var _oldColorBox:GGraph;
      
      private var _hsb_h_input:NumericInput;
      
      private var _hsb_s_input:NumericInput;
      
      private var _hsb_b_input:NumericInput;
      
      private var _rgb_r_input:NumericInput;
      
      private var _rgb_g_input:NumericInput;
      
      private var _rgb_b_input:NumericInput;
      
      private var _alphaInput:GLabel;
      
      private var _colorInput:GLabel;
      
      private var _hueSlider:GSlider;
      
      private var _rgb:Object;
      
      private var _hsb:Object;
      
      private var _alpha:Number;
      
      public function ColorPickerDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Basic","ColorPickerDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._rgb = {};
         this._hsb = {};
         this._alpha = 1;
         this._sbBox = contentPane.getChild("sbBox").asCom;
         this._sbBox.addEventListener("beginGTouch",this.onSbBoxTouchDown);
         this._sbArea = this._sbBox.getChild("sbArea").asGraph;
         this._sbValue = this._sbBox.getChild("sbValue");
         this._sbValue.draggable = true;
         this._sbValue.addEventListener("dragMoving",this.onColorChanged1);
         this._currentColorBox = contentPane.getChild("currentColorBox").asGraph;
         this._oldColorBox = contentPane.getChild("oldColorBox").asGraph;
         this._hueSlider = contentPane.getChild("hueSlider").asSlider;
         this._hueSlider.changeOnClick = true;
         this._hueSlider.addEventListener("stateChanged",this.onColorChanged2);
         this._hsb_h_input = NumericInput(contentPane.getChild("hsb_h"));
         this._hsb_s_input = NumericInput(contentPane.getChild("hsb_s"));
         this._hsb_b_input = NumericInput(contentPane.getChild("hsb_b"));
         this._rgb_r_input = NumericInput(contentPane.getChild("rgb_r"));
         this._rgb_g_input = NumericInput(contentPane.getChild("rgb_g"));
         this._rgb_b_input = NumericInput(contentPane.getChild("rgb_b"));
         this._alphaInput = contentPane.getChild("alphaValue").asLabel;
         this._alphaInput.getTextField().asTextInput.disableIME = true;
         this._colorInput = contentPane.getChild("colorValue").asLabel;
         this._colorInput.getTextField().asTextInput.disableIME = true;
         this._hsb_h_input.min = 0;
         this._hsb_h_input.max = 360;
         this._hsb_s_input.min = 0;
         this._hsb_s_input.max = 100;
         this._hsb_b_input.min = 0;
         this._hsb_b_input.max = 100;
         this._rgb_r_input.min = 0;
         this._rgb_r_input.max = 255;
         this._rgb_g_input.min = 0;
         this._rgb_g_input.max = 255;
         this._rgb_b_input.min = 0;
         this._rgb_b_input.max = 255;
         this._hsb_h_input.addEventListener("__submit",this.onColorChanged3);
         this._hsb_s_input.addEventListener("__submit",this.onColorChanged3);
         this._hsb_b_input.addEventListener("__submit",this.onColorChanged3);
         this._rgb_r_input.addEventListener("__submit",this.onColorChanged4);
         this._rgb_g_input.addEventListener("__submit",this.onColorChanged4);
         this._rgb_b_input.addEventListener("__submit",this.onColorChanged4);
         this._alphaInput.getTextField().addEventListener("change",this.onColorChanged5);
         this._colorInput.getTextField().addEventListener("change",this.onColorChanged6);
         contentPane.getChild("ok").addClickListener(__actionHandler);
         contentPane.getChild("apply").addClickListener(this.__apply);
         contentPane.getChild("cancel").addClickListener(closeEventHandler);
      }
      
      public function open(param1:ColorInput, param2:uint, param3:Number, param4:Boolean) : void
      {
         this.show();
         this._input = param1;
         contentPane.getController("showAlpha").selectedIndex = !!param4?1:0;
         this._rgb.r = (param2 & 16711680) >> 16;
         this._rgb.g = (param2 & 65280) >> 8;
         this._rgb.b = param2 & 255;
         this._alpha = param3 * 255;
         this._oldColorBox.drawRect(1,0,0,param2,param3);
         this.setHSB();
         this.updateColor();
         _editorWindow.screenColorPickerManager.start(this,this.onPickScreenColor);
      }
      
      private function setHSB() : void
      {
         this._hsb = UtilsColor.RGBtoHSB(this._rgb.r,this._rgb.g,this._rgb.b);
      }
      
      private function setRGB() : void
      {
         this._rgb = UtilsColor.HSBtoRGB(this._hsb.h,this._hsb.s,this._hsb.b);
      }
      
      private function __apply(param1:Event) : void
      {
         this._input.colorValue = parseInt(this._colorInput.text,16);
         this._input.alphaValue = parseInt(this._alphaInput.text,16) / 255;
         this._input.dispatchEvent(new SubmitEvent("__submit"));
      }
      
      override public function actionHandler() : void
      {
         this.__apply(null);
         this.hide();
      }
      
      private function updateColor(param1:int = 0) : void
      {
         var _loc6_:int = Math.round(this._rgb.r);
         var _loc4_:int = Math.round(this._rgb.g);
         var _loc5_:int = Math.round(this._rgb.b);
         var _loc2_:int = (_loc6_ << 16) + (_loc4_ << 8) + _loc5_;
         this._sbArea.color = this.getHcolor(this._hsb.h);
         this._currentColorBox.drawRect(1,0,0,_loc2_,this._alpha / 255);
         if(param1 != 1)
         {
            this._sbValue.setXY(this._hsb.s / 100 * this._sbBox.width,(1 - this._hsb.b / 100) * this._sbBox.height);
         }
         if(param1 != 2)
         {
            this._hueSlider.value = 360 - this._hsb.h;
         }
         if(param1 != 3)
         {
            this._hsb_h_input.value = Math.round(this._hsb.h);
            this._hsb_s_input.value = Math.round(this._hsb.s);
            this._hsb_b_input.value = Math.round(this._hsb.b);
         }
         if(param1 != 4)
         {
            this._rgb_r_input.value = _loc6_;
            this._rgb_g_input.value = _loc4_;
            this._rgb_b_input.value = _loc5_;
         }
         var _loc3_:String = UtilsStr.convertToHtmlColor((this._alpha << 24) + _loc2_,true);
         if(param1 != 5)
         {
            this._alphaInput.text = _loc3_.substr(1,2).toUpperCase();
         }
         if(param1 != 6)
         {
            this._colorInput.text = _loc3_.substr(3).toUpperCase();
         }
      }
      
      private function onSbBoxTouchDown(param1:GTouchEvent) : void
      {
         var _loc2_:Point = this._sbArea.parent.globalToLocal(param1.stageX,param1.stageY);
         this._sbValue.setXY(_loc2_.x,_loc2_.y);
         this._sbValue.dragBounds = this._sbArea.parent.localToGlobalRect(0,0,this._sbBox.width + 12,this._sbBox.height + 12);
         this._sbValue.startDrag();
         this.onColorChanged1(null);
      }
      
      private function onColorChanged1(param1:Event) : void
      {
         this._hsb.s = this._sbValue.x / this._sbBox.width * 100;
         this._hsb.b = (1 - this._sbValue.y / this._sbBox.height) * 100;
         this.setRGB();
         this.updateColor(1);
      }
      
      private function onColorChanged2(param1:Event) : void
      {
         this._hsb.h = 360 - this._hueSlider.value;
         this.setRGB();
         this.updateColor(2);
      }
      
      private function onColorChanged3(param1:Event) : void
      {
         var _loc3_:NumericInput = NumericInput(param1.currentTarget);
         var _loc2_:String = _loc3_.name.charAt(4);
         this._hsb[_loc2_] = _loc3_.value;
         this.setRGB();
         this.updateColor(3);
      }
      
      private function onColorChanged4(param1:Event) : void
      {
         var _loc3_:NumericInput = NumericInput(param1.currentTarget);
         var _loc2_:String = _loc3_.name.charAt(4);
         this._rgb[_loc2_] = _loc3_.value;
         this.setHSB();
         this.updateColor(4);
      }
      
      private function onColorChanged5(param1:Event) : void
      {
         this._alpha = parseInt(this._alphaInput.text,16);
         this.updateColor(5);
      }
      
      private function onColorChanged6(param1:Event) : void
      {
         var _loc2_:uint = UtilsStr.convertFromHtmlColor("#" + this._colorInput.text);
         this._rgb.r = (_loc2_ & 16711680) >> 16;
         this._rgb.g = (_loc2_ & 65280) >> 8;
         this._rgb.b = _loc2_ & 255;
         this.setHSB();
         this.updateColor(6);
      }
      
      private function getHcolor(param1:Number) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(param1 < 60)
         {
            _loc2_ = Math.round(param1 / 60 * 255);
            _loc3_ = 16711680 + (_loc2_ << 8);
         }
         else if(param1 >= 60 && param1 < 120)
         {
            _loc2_ = Math.round(255 - (param1 - 60) / 60 * 255);
            _loc3_ = (_loc2_ << 16) + 65280;
         }
         else if(param1 >= 120 && param1 < 180)
         {
            _loc2_ = Math.round((param1 - 120) / 60 * 255);
            _loc3_ = 65280 + _loc2_;
         }
         else if(param1 >= 180 && param1 < 240)
         {
            _loc2_ = Math.round(255 - (param1 - 180) / 60 * 255);
            _loc3_ = (_loc2_ << 8) + 255;
         }
         else if(param1 >= 240 && param1 < 300)
         {
            _loc2_ = Math.round((param1 - 240) / 60 * 255);
            _loc3_ = (_loc2_ << 16) + 255;
         }
         else
         {
            _loc2_ = Math.round(255 - (param1 - 300) / 60 * 255);
            _loc3_ = 16711680 + Math.round(_loc2_);
         }
         return _loc3_;
      }
      
      private function onPickScreenColor(param1:uint) : void
      {
         this._rgb.r = (param1 & 16711680) >> 16;
         this._rgb.g = (param1 & 65280) >> 8;
         this._rgb.b = param1 & 255;
         this.setHSB();
         this.updateColor(0);
      }
   }
}

package fairygui.editor.extui
{
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.GImage;
   import fairygui.GLabel;
   import fairygui.GObject;
   import fairygui.GRoot;
   import fairygui.GTextField;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.dialogs.ColorPickerDialog;
   import fairygui.utils.ToolSet;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class ColorPicker
   {
       
      
      private var self:GComponent;
      
      private var _editorWindow:EditorWindow;
      
      private var _input:ColorInput;
      
      private var _currentColorBox:GGraph;
      
      private var _currentColorValue:GLabel;
      
      private var _alphaInput:NumericInput;
      
      private var _colorTable:GObject;
      
      private var _colorValue:int;
      
      private var _alphaValue:Number;
      
      private var _tmpColorValue:int;
      
      private var _movingInTable:Boolean;
      
      private var _inputTextField:GTextField;
      
      public function ColorPicker(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this.self = UIPackage.createObject("Basic","ColorPickerPopup").asCom;
         this._currentColorBox = this.self.getChild("currentColorBox").asGraph;
         this._currentColorValue = this.self.getChild("currentColorValue").asLabel;
         this._currentColorValue.addEventListener("focusOut",this.__focusOut);
         this._inputTextField = this._currentColorValue.getTextField();
         this._inputTextField.asTextInput.disableIME = true;
         this._inputTextField.addEventListener("keyDown",this.__keyDown);
         this._alphaInput = NumericInput(this.self.getChild("alphaInput"));
         this._alphaInput.addEventListener("__submit",this.__alphaChanged);
         this._alphaInput.value = 100;
         this._alphaInput.max = 100;
         this._colorTable = this.self.getChild("colorTable");
         this.self.getChild("picker").addClickListener(this.__picker);
         this.self.getChild("more").addClickListener(this.__more);
         this.self.addClickListener(this.__click);
         this.self.addEventListener("mouseMove",this.__mouseMove);
         this._colorValue = 0;
         this._alphaValue = 1;
         this.update();
      }
      
      public function get isShowing() : Boolean
      {
         return this.self.displayObject.stage != null;
      }
      
      public function show(param1:ColorInput, param2:GObject, param3:uint, param4:Number, param5:Boolean) : void
      {
         this._input = param1;
         this._editorWindow.groot.showPopup(this.self,param2);
         this.self.getController("showAlpha").selectedIndex = !!param5?1:0;
         this._colorValue = param3 & 16777215;
         this._alphaValue = param4;
         this._alphaInput.value = Math.round(this._alphaValue * 100);
         this.update();
      }
      
      public function hide() : void
      {
         this._editorWindow.groot.hidePopup(this.self);
      }
      
      private function onPickScreenColor(param1:uint) : void
      {
         this._colorValue = param1;
         this._editorWindow.groot.hidePopup(this.self);
         this.notifyOwner();
      }
      
      private function notifyOwner() : void
      {
         this._input.colorValue = this._colorValue;
         this._input.alphaValue = this._alphaValue;
         this._input.dispatchEvent(new SubmitEvent("__submit"));
      }
      
      private function update() : void
      {
         this._currentColorBox.drawRect(1,0,1,this._colorValue,this._alphaValue);
         this._currentColorValue.text = ToolSet.convertToHtmlColor(this._colorValue).toUpperCase();
      }
      
      private function __focusOut(param1:Event) : void
      {
         this._colorValue = ToolSet.convertFromHtmlColor(this._currentColorValue.text);
         this.update();
         this.notifyOwner();
      }
      
      private function __alphaChanged(param1:Event) : void
      {
         this._alphaValue = this._alphaInput.value / 100;
         this.update();
         this.notifyOwner();
      }
      
      private function __click(param1:Event) : void
      {
         if(!this._movingInTable)
         {
            return;
         }
         this._colorValue = this._tmpColorValue;
         this.update();
         this._editorWindow.groot.hidePopup(this.self);
         this.notifyOwner();
      }
      
      private function __mouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:Number = this._colorTable.displayObject.mouseX;
         var _loc4_:Number = this._colorTable.displayObject.mouseY;
         var _loc5_:GRoot = this._editorWindow.groot;
         if(_loc6_ > 0 && _loc6_ < this._colorTable.width && _loc4_ > 0 && _loc4_ < this._colorTable.height && !_loc5_.buttonDown && _loc5_.nativeStage.focus != this._inputTextField.displayObject)
         {
            this._movingInTable = true;
            _loc2_ = _loc6_ / 15;
            _loc3_ = _loc4_ / 15;
            this._tmpColorValue = Bitmap(GImage(this._colorTable).displayObject).bitmapData.getPixel(_loc2_ * 15 + 8,_loc3_ * 15 + 8);
            this._currentColorBox.drawRect(1,0,1,this._tmpColorValue,this._alphaValue);
            this._currentColorValue.text = ToolSet.convertToHtmlColor(this._tmpColorValue).toUpperCase();
         }
         else
         {
            if(this._movingInTable)
            {
               this.update();
            }
            this._movingInTable = false;
         }
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            param1.stopPropagation();
            this.__focusOut(null);
            this._editorWindow.groot.hidePopup(this.self);
         }
         else if(param1.keyCode == 27)
         {
            param1.stopPropagation();
            this._currentColorValue.text = ToolSet.convertToHtmlColor(this._colorValue).toUpperCase();
            this._editorWindow.groot.hidePopup(this.self);
         }
      }
      
      private function __picker(param1:Event) : void
      {
         this._editorWindow.screenColorPickerManager.start(this.self,this.onPickScreenColor);
      }
      
      private function __more(param1:Event) : void
      {
         param1.stopPropagation();
         ColorPickerDialog(this._editorWindow.getDialog(ColorPickerDialog)).open(this._input,this._colorValue,this._alphaValue,this.self.getController("showAlpha").selectedIndex == 1);
         this._editorWindow.groot.hidePopup(this.self);
      }
   }
}

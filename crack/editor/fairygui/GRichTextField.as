package fairygui
{
   import fairygui.display.UIRichTextField;
   import fairygui.text.RichTextField;
   import fairygui.utils.ToolSet;
   import flash.text.TextFormat;
   
   public class GRichTextField extends GTextField
   {
       
      
      protected var _richTextField:RichTextField;
      
      public function GRichTextField()
      {
         super();
      }
      
      override protected function createDisplayObject() : void
      {
         _richTextField = new UIRichTextField(this);
         _textField = _richTextField.nativeTextField;
         setDisplayObject(_richTextField);
      }
      
      public function get ALinkFormat() : TextFormat
      {
         return _richTextField.ALinkFormat;
      }
      
      public function set ALinkFormat(param1:TextFormat) : void
      {
         _richTextField.ALinkFormat = param1;
         render();
      }
      
      public function get AHoverFormat() : TextFormat
      {
         return _richTextField.AHoverFormat;
      }
      
      public function set AHoverFormat(param1:TextFormat) : void
      {
         _richTextField.AHoverFormat = param1;
         render();
      }
      
      override protected function updateAutoSize() : void
      {
         if(_heightAutoSize)
         {
            _textField.autoSize = "left";
         }
         else
         {
            _textField.autoSize = "none";
         }
      }
      
      override protected function render() : void
      {
         renderNow(true);
      }
      
      override protected function renderNow(param1:Boolean = true) : void
      {
         _richTextField.defaultTextFormat = _textFormat;
         if(_ubbEnabled)
         {
            _richTextField.text = ToolSet.parseUBB(_text);
         }
         else
         {
            _richTextField.text = _text;
         }
         var _loc2_:* = _richTextField.numLines <= 1;
         _textWidth = Math.ceil(_richTextField.textWidth);
         if(_textWidth > 0)
         {
            _textWidth = _textWidth + 5;
         }
         _textHeight = Math.ceil(_richTextField.textHeight);
         if(_textHeight > 0)
         {
            if(_loc2_)
            {
               _textHeight = _textHeight + 1;
            }
            else
            {
               _textHeight = _textHeight + 4;
            }
         }
         if(_heightAutoSize)
         {
            _richTextField.height = _textHeight + _fontAdjustment;
            _updatingSize = true;
            this.height = _textHeight;
            _updatingSize = false;
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         if(!_updatingSize)
         {
            _richTextField.width = this.width;
            _richTextField.height = this.height + _fontAdjustment;
         }
      }
   }
}

package fairygui
{
   import fairygui.utils.ToolSet;
   import flash.events.Event;
   import flash.system.Capabilities;
   import flash.system.IME;
   
   public class GTextInput extends GTextField
   {
       
      
      private var _changed:Boolean;
      
      private var _promptText:String;
      
      private var _password:Boolean;
      
      public var disableIME:Boolean;
      
      public function GTextInput()
      {
         super();
         this.focusable = true;
         _textField.wordWrap = true;
         _textField.addEventListener("keyDown",__textChanged);
         _textField.addEventListener("change",__textChanged);
         _textField.addEventListener("focusIn",__focusIn);
         _textField.addEventListener("focusOut",__focusOut);
      }
      
      public function set maxLength(param1:int) : void
      {
         _textField.maxChars = param1;
      }
      
      public function get maxLength() : int
      {
         return _textField.maxChars;
      }
      
      public function set editable(param1:Boolean) : void
      {
         if(param1)
         {
            _textField.type = "input";
            _textField.selectable = true;
         }
         else
         {
            _textField.type = "dynamic";
            _textField.selectable = false;
         }
      }
      
      public function get editable() : Boolean
      {
         return _textField.type == "input";
      }
      
      public function get promptText() : String
      {
         return _promptText;
      }
      
      public function set promptText(param1:String) : void
      {
         _promptText = param1;
         renderNow();
      }
      
      public function get restrict() : String
      {
         return _textField.restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         _textField.restrict = param1;
      }
      
      public function get password() : Boolean
      {
         return _password;
      }
      
      public function set password(param1:Boolean) : void
      {
         if(_password != param1)
         {
            _password = param1;
            render();
         }
      }
      
      override protected function createDisplayObject() : void
      {
         super.createDisplayObject();
         _textField.type = "input";
         _textField.selectable = true;
         _textField.mouseEnabled = true;
      }
      
      override public function get text() : String
      {
         if(_changed)
         {
            _changed = false;
            _text = _textField.text.replace(/\r\n/g,"\n");
            _text = _text.replace(/\r/g,"\n");
         }
         return _text;
      }
      
      override protected function updateAutoSize() : void
      {
      }
      
      override protected function render() : void
      {
         renderNow(true);
      }
      
      override protected function renderNow(param1:Boolean = true) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc2_ = this.width;
         if(_loc2_ != _textField.width)
         {
            _textField.width = _loc2_;
         }
         _loc3_ = this.height + _fontAdjustment;
         if(_loc3_ != _textField.height)
         {
            _textField.height = _loc3_;
         }
         _yOffset = -_fontAdjustment;
         _textField.y = this.y + _yOffset;
         if(!_text && _promptText)
         {
            _textField.displayAsPassword = false;
            _textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(_promptText));
         }
         else
         {
            _textField.displayAsPassword = _password;
            _textField.text = _text;
         }
         _changed = false;
      }
      
      override protected function handleSizeChanged() : void
      {
         _textField.width = this.width;
         _textField.height = this.height + _fontAdjustment;
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         super.setup_beforeAdd(param1);
         _promptText = param1.@prompt;
         var _loc2_:String = param1.@maxLength;
         if(_loc2_)
         {
            _textField.maxChars = parseInt(_loc2_);
         }
         _loc2_ = param1.@restrict;
         if(_loc2_)
         {
            _textField.restrict = _loc2_;
         }
         _password = param1.@password == "true";
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         super.setup_afterAdd(param1);
         if(!_text)
         {
            if(_promptText)
            {
               _textField.displayAsPassword = false;
               _textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(_promptText));
            }
         }
      }
      
      private function __textChanged(param1:Event) : void
      {
         _changed = true;
         TextInputHistory.inst.markChanged(_textField);
      }
      
      private function __focusIn(param1:Event) : void
      {
         if(disableIME && Capabilities.hasIME)
         {
            IME.enabled = false;
         }
         if(!_text && _promptText)
         {
            _textField.displayAsPassword = _password;
            _textField.text = "";
         }
         TextInputHistory.inst.startRecord(_textField);
      }
      
      private function __focusOut(param1:Event) : void
      {
         if(disableIME && Capabilities.hasIME)
         {
            IME.enabled = true;
         }
         _text = _textField.text;
         TextInputHistory.inst.stopRecord(_textField);
         _changed = false;
         if(!_text && _promptText)
         {
            _textField.displayAsPassword = false;
            _textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(_promptText));
         }
      }
   }
}

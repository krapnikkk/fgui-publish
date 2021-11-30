package fairygui
{
   import flash.text.TextField;
   
   public class TextInputHistory
   {
      
      private static var _inst:TextInputHistory;
       
      
      private var _undoBuffer:Vector.<String>;
      
      private var _redoBuffer:Vector.<String>;
      
      private var _currentText:String;
      
      private var _textField:TextField;
      
      private var _lock:Boolean;
      
      public var maxHistoryLength:int = 5;
      
      public function TextInputHistory()
      {
         super();
         _undoBuffer = new Vector.<String>();
         _redoBuffer = new Vector.<String>();
      }
      
      public static function get inst() : TextInputHistory
      {
         if(_inst == null)
         {
            _inst = new TextInputHistory();
         }
         return _inst;
      }
      
      public function startRecord(param1:TextField) : void
      {
         _undoBuffer.length = 0;
         _redoBuffer.length = 0;
         _textField = param1;
         _lock = false;
         _currentText = param1.text;
      }
      
      public function markChanged(param1:TextField) : void
      {
         if(_textField != param1)
         {
            return;
         }
         if(_lock)
         {
            return;
         }
         var _loc2_:String = _textField.text;
         if(_currentText == _loc2_)
         {
            return;
         }
         _undoBuffer.push(_currentText);
         if(_undoBuffer.length > maxHistoryLength)
         {
            _undoBuffer.splice(0,1);
         }
         _currentText = _loc2_;
      }
      
      public function stopRecord(param1:TextField) : void
      {
         if(_textField != param1)
         {
            return;
         }
         _undoBuffer.length = 0;
         _redoBuffer.length = 0;
         _textField = null;
         _currentText = null;
      }
      
      public function undo(param1:TextField) : void
      {
         if(_textField != param1)
         {
            return;
         }
         if(_undoBuffer.length == 0)
         {
            return;
         }
         var _loc2_:String = _undoBuffer.pop();
         _redoBuffer.push(_currentText);
         _lock = true;
         _textField.text = _loc2_;
         _currentText = _loc2_;
         _lock = false;
      }
      
      public function redo(param1:TextField) : void
      {
         if(_textField != param1)
         {
            return;
         }
         if(_redoBuffer.length == 0)
         {
            return;
         }
         var _loc2_:String = _redoBuffer.pop();
         _undoBuffer.push(_currentText);
         _lock = true;
         _textField.text = _loc2_;
         var _loc3_:int = _loc2_.length - _currentText.length;
         if(_loc3_ > 0)
         {
            _textField.setSelection(_textField.caretIndex + _loc3_,_textField.caretIndex + _loc3_);
         }
         _currentText = _loc2_;
         _lock = false;
      }
   }
}

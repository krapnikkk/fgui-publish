package fairygui.editor.utils
{
   public class XDataEnumerator
   {
       
      
      private var _owner:XData;
      
      private var _selector:String;
      
      private var _index:int;
      
      private var _total:int;
      
      private var _current:XData;
      
      public function XDataEnumerator(param1:XData, param2:String)
      {
         super();
         this._owner = param1;
         this._selector = param2;
         this._index = -1;
         this._total = this._owner.getChildren().length;
      }
      
      public function get current() : XData
      {
         return this._current;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function moveNext() : Boolean
      {
         while(true)
         {
            var _loc1_:* = this._index + 1;
            this._index++;
            if(_loc1_ < this._total)
            {
               this._current = this._owner.getChildren()[this._index];
               if(this._selector == null || this._current.getName() == this._selector)
               {
                  return true;
               }
               continue;
            }
            break;
         }
         this._current = null;
         return false;
      }
      
      public function erase() : void
      {
         if(this._current)
         {
            this._owner.removeChildAt(this._index);
            this._index--;
            this._total--;
            this._current = null;
         }
      }
      
      public function reset() : void
      {
         this._index = -1;
      }
   }
}

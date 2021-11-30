package fairygui.utils
{
   public class DispatcherLite
   {
       
      
      private var iElements:Array;
      
      private var iEnumI:int;
      
      private var iDispatchingType:int;
      
      public function DispatcherLite()
      {
         super();
         this.iElements = [];
         this.iDispatchingType = -1;
      }
      
      public function on(param1:int, param2:Function) : void
      {
         var _loc3_:Array = this.iElements[param1];
         if(!_loc3_)
         {
            _loc3_ = [];
            this.iElements[param1] = _loc3_;
            _loc3_.push(param2);
         }
         else if(_loc3_.indexOf(param2) == -1)
         {
            _loc3_.push(param2);
         }
      }
      
      public function off(param1:int, param2:Function) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Array = this.iElements[param1];
         if(_loc3_)
         {
            _loc4_ = _loc3_.indexOf(param2);
            if(_loc4_ != -1)
            {
               _loc3_.splice(_loc4_,1);
               if(param1 == this.iDispatchingType && _loc4_ <= this.iEnumI)
               {
                  this.iEnumI--;
               }
            }
         }
      }
      
      public function emit(param1:Object, param2:int) : void
      {
         var _loc4_:Function = null;
         var _loc3_:Array = this.iElements[param2];
         if(!_loc3_ || _loc3_.length == 0 || this.iDispatchingType == param2)
         {
            return;
         }
         this.iEnumI = 0;
         this.iDispatchingType = param2;
         while(this.iEnumI < _loc3_.length)
         {
            _loc4_ = _loc3_[this.iEnumI];
            if(_loc4_.length == 1)
            {
               _loc4_(param1);
            }
            else
            {
               _loc4_();
            }
            this.iEnumI++;
         }
         this.iDispatchingType = -1;
      }
      
      public function offAll() : void
      {
         this.iElements.length = 0;
      }
   }
}

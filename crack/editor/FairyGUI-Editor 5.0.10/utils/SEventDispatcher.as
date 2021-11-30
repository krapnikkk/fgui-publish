package fairygui.utils
{
   public class SEventDispatcher
   {
       
      
      private var _elements:Object;
      
      private var _dispatching:Object;
      
      public var errorHandler:Function;
      
      public function SEventDispatcher()
      {
         super();
         this._elements = {};
         this._dispatching = {};
      }
      
      public function on(param1:String, param2:Function) : void
      {
         var _loc3_:Array = this._elements[param1];
         if(!_loc3_)
         {
            _loc3_ = new Array();
            this._elements[param1] = _loc3_;
            _loc3_.push(param2);
         }
         else if(_loc3_.indexOf(param2) == -1)
         {
            _loc3_.push(param2);
         }
      }
      
      public function off(param1:String, param2:Function) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Array = this._elements[param1];
         if(_loc3_)
         {
            _loc4_ = _loc3_.indexOf(param2);
            if(_loc4_ != -1)
            {
               _loc3_[_loc4_] = null;
            }
         }
      }
      
      public function emit(param1:String, param2:* = undefined) : void
      {
         var func:Function = null;
         var j:int = 0;
         var type:String = param1;
         var param:* = param2;
         var arr:Array = this._elements[type];
         if(!arr || arr.length == 0 || this._dispatching[type])
         {
            return;
         }
         this._dispatching[type] = true;
         var cnt:int = arr.length;
         var freePosStart:int = -1;
         var i:int = 0;
         while(i < cnt)
         {
            func = arr[i];
            if(func == null)
            {
               if(freePosStart == -1)
               {
                  freePosStart = i;
               }
            }
            else
            {
               if(this.errorHandler != null)
               {
                  try
                  {
                     if(func.length == 1)
                     {
                        func(param);
                     }
                     else
                     {
                        func();
                     }
                  }
                  catch(err:Error)
                  {
                     errorHandler(err);
                  }
               }
               else if(func.length == 1)
               {
                  func(param);
               }
               else
               {
                  func();
               }
               if(freePosStart != -1)
               {
                  arr[freePosStart] = func;
                  arr[i] = null;
                  freePosStart++;
               }
            }
            i++;
         }
         if(freePosStart >= 0)
         {
            if(arr.length != cnt)
            {
               j = cnt;
               cnt = arr.length - cnt;
               i = 0;
               while(i < cnt)
               {
                  arr[freePosStart++] = arr[j++];
                  i++;
               }
            }
            arr.length = freePosStart;
         }
         this._dispatching[type] = false;
      }
   }
}

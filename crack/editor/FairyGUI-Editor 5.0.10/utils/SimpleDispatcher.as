package fairygui.utils
{
   public class SimpleDispatcher
   {
       
      
      private var _elements:Array;
      
      private var _dispatching:int;
      
      public function SimpleDispatcher()
      {
         super();
         _elements = [];
      }
      
      public function addListener(param1:int, param2:Function) : void
      {
         var _loc3_:Array = _elements[param1];
         if(!_loc3_)
         {
            _loc3_ = [];
            _elements[param1] = _loc3_;
            _loc3_.push(param2);
         }
         else if(_loc3_.indexOf(param2) == -1)
         {
            _loc3_.push(param2);
         }
      }
      
      public function removeListener(param1:int, param2:Function) : void
      {
         var _loc4_:int = 0;
         var _loc3_:Array = _elements[param1];
         if(_loc3_)
         {
            _loc4_ = _loc3_.indexOf(param2);
            if(_loc4_ != -1)
            {
               _loc3_[_loc4_] = null;
            }
         }
      }
      
      public function hasListener(param1:int) : Boolean
      {
         var _loc2_:Array = _elements[param1];
         if(_loc2_ && _loc2_.length > 0)
         {
            return true;
         }
         return false;
      }
      
      public function dispatch(param1:Object, param2:int) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:* = null;
         var _loc3_:Array = _elements[param2];
         if(!_loc3_ || _loc3_.length == 0)
         {
            return;
         }
         var _loc6_:int = 0;
         _dispatching = Number(_dispatching) + 1;
         while(_loc6_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc6_];
            if(_loc5_ != null)
            {
               if(_loc5_.length == 1)
               {
                  _loc5_(param1);
               }
               else
               {
                  _loc5_();
               }
            }
            else
            {
               _loc4_ = true;
            }
            _loc6_++;
         }
         _dispatching = Number(_dispatching) - 1;
         if(_loc4_ && _dispatching == 0)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc6_];
               if(_loc5_ == null)
               {
                  _loc3_.splice(_loc6_,1);
               }
               else
               {
                  _loc6_++;
               }
            }
         }
      }
      
      public function clear() : void
      {
         _elements.length = 0;
      }
   }
}

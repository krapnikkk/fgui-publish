package fairygui
{
   public class GObjectPool
   {
       
      
      private var _pool:Object;
      
      private var _count:int;
      
      private var _initCallback:Function;
      
      public function GObjectPool()
      {
         super();
         _pool = {};
      }
      
      public function get initCallback() : Function
      {
         return _initCallback;
      }
      
      public function set initCallback(param1:Function) : void
      {
         _initCallback = param1;
      }
      
      public function clear() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:* = _pool;
         for each(var _loc1_ in _pool)
         {
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_[_loc3_].dispose();
               _loc3_++;
            }
         }
         _pool = {};
         _count = 0;
      }
      
      public function get count() : int
      {
         return _count;
      }
      
      public function getObject(param1:String) : GObject
      {
         param1 = UIPackage.normalizeURL(param1);
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Vector.<GObject> = _pool[param1];
         if(_loc2_ != null && _loc2_.length)
         {
            _count = Number(_count) - 1;
            return _loc2_.shift();
         }
         var _loc3_:GObject = UIPackage.createObjectFromURL(param1);
         if(_loc3_)
         {
            if(_initCallback != null)
            {
               _initCallback(_loc3_);
            }
         }
         return _loc3_;
      }
      
      public function returnObject(param1:GObject) : void
      {
         var _loc3_:String = param1.resourceURL;
         if(!_loc3_)
         {
            return;
         }
         var _loc2_:Vector.<GObject> = _pool[_loc3_];
         if(_loc2_ == null)
         {
            _loc2_ = new Vector.<GObject>();
            _pool[_loc3_] = _loc2_;
         }
         _count = Number(_count) + 1;
         _loc2_.push(param1);
      }
   }
}

package fairygui.utils.loader
{
   import fairygui.utils.UtilsStr;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class EasyLoader
   {
      
      private static var iRunnings:Array = [];
       
      
      public function EasyLoader()
      {
         super();
      }
      
      public static function loadInNewDomain(param1:String, param2:Object, param3:Function) : void
      {
         loadExecSwf(param1,true,param3);
      }
      
      public static function loadExecSwf(param1:String, param2:Boolean, param3:Function) : void
      {
         var _loc4_:Object = {};
         var _loc5_:LoaderContext = new LoaderContext(false,!!param2?new ApplicationDomain():ApplicationDomain.currentDomain);
         if(UtilsStr.startsWith(param1,"file:/") || UtilsStr.startsWith(param1,"app:/"))
         {
            _loc5_.allowLoadBytesCodeExecution = true;
         }
         _loc4_.context = _loc5_;
         load(param1,_loc4_,param3);
      }
      
      public static function load(param1:String, param2:Object, param3:Function) : void
      {
         var _loc4_:LoaderExt = new LoaderExt();
         _loc4_.addEventListener(Event.COMPLETE,onLoadComplete);
         _loc4_.addEventListener(ErrorEvent.ERROR,onLoadComplete);
         _loc4_.load(param1,param2);
         iRunnings.push([_loc4_,param3]);
      }
      
      public static function loadMultiple(param1:Array, param2:Object, param3:Function) : void
      {
         var _loc6_:LoaderExt = null;
         var _loc4_:Array = [param1.length,param3];
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = new LoaderExt();
            _loc6_.addEventListener(Event.COMPLETE,onLoadMultipleComplete);
            _loc6_.addEventListener(ErrorEvent.ERROR,onLoadMultipleComplete);
            _loc6_.load(param1[_loc5_],param2);
            iRunnings.push([_loc6_,_loc4_,_loc5_]);
            _loc5_++;
         }
      }
      
      public static function get hasJob() : Boolean
      {
         return iRunnings.length > 0;
      }
      
      private static function onLoadComplete(param1:Event) : void
      {
         var _loc3_:Function = null;
         var _loc5_:Object = null;
         var _loc2_:LoaderExt = LoaderExt(param1.currentTarget);
         var _loc4_:int = 0;
         while(_loc4_ < iRunnings.length)
         {
            _loc5_ = iRunnings[_loc4_];
            if(_loc2_ == _loc5_[0])
            {
               _loc3_ = _loc5_[1];
               iRunnings.splice(_loc4_,1);
               break;
            }
            _loc4_++;
         }
         if(_loc3_ != null)
         {
            _loc3_(_loc2_);
         }
      }
      
      private static function onLoadMultipleComplete(param1:Event) : void
      {
         var _loc3_:Function = null;
         var _loc4_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc2_:LoaderExt = LoaderExt(param1.currentTarget);
         var _loc5_:int = 0;
         while(_loc5_ < iRunnings.length)
         {
            _loc6_ = iRunnings[_loc5_];
            if(_loc2_ == _loc6_[0])
            {
               _loc4_ = _loc6_[1];
               _loc4_[2 + _loc6_[2]] = _loc2_;
               _loc7_ = _loc4_[0];
               _loc7_--;
               if(_loc7_ == 0)
               {
                  _loc3_ = _loc4_[1];
               }
               else
               {
                  _loc4_[0] = _loc7_;
               }
               iRunnings.splice(_loc5_,1);
               break;
            }
            _loc5_++;
         }
         if(_loc3_ != null)
         {
            _loc4_.splice(0,2);
            _loc3_(_loc4_);
         }
      }
   }
}

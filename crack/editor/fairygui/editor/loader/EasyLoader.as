package fairygui.editor.loader
{
   import fairygui.editor.utils.UtilsStr;
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
         var _loc5_:Object = {};
         var _loc4_:LoaderContext = new LoaderContext(false,!!param2?new ApplicationDomain():ApplicationDomain.currentDomain);
         if(UtilsStr.startsWith(param1,"file:/") || UtilsStr.startsWith(param1,"app:/"))
         {
            _loc4_.allowLoadBytesCodeExecution = true;
         }
         _loc5_.context = _loc4_;
         load(param1,_loc5_,param3);
      }
      
      public static function load(param1:String, param2:Object, param3:Function) : void
      {
         var _loc4_:LoaderExt = new LoaderExt();
         _loc4_.addEventListener("complete",onLoadComplete);
         _loc4_.addEventListener("error",onLoadComplete);
         _loc4_.load(param1,param2);
         iRunnings.push([_loc4_,param3]);
      }
      
      public static function loadMultiple(param1:Array, param2:Object, param3:Function) : void
      {
         var _loc5_:LoaderExt = null;
         var _loc6_:Array = [param1.length,param3];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = new LoaderExt();
            _loc5_.addEventListener("complete",onLoadMultipleComplete);
            _loc5_.addEventListener("error",onLoadMultipleComplete);
            _loc5_.load(param1[_loc4_],param2);
            iRunnings.push([_loc5_,_loc6_,_loc4_]);
            _loc4_++;
         }
      }
      
      public static function get hasJob() : Boolean
      {
         return iRunnings.length > 0;
      }
      
      private static function onLoadComplete(param1:Event) : void
      {
         var _loc3_:Function = null;
         var _loc2_:Object = null;
         var _loc5_:LoaderExt = LoaderExt(param1.currentTarget);
         var _loc4_:int = 0;
         while(_loc4_ < iRunnings.length)
         {
            _loc2_ = iRunnings[_loc4_];
            if(_loc5_ == _loc2_[0])
            {
               _loc3_ = _loc2_[1];
               iRunnings.splice(_loc4_,1);
               break;
            }
            _loc4_++;
         }
         if(_loc3_ != null)
         {
            _loc3_(_loc5_);
         }
      }
      
      private static function onLoadMultipleComplete(param1:Event) : void
      {
         var _loc5_:Function = null;
         var _loc6_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc7_:LoaderExt = LoaderExt(param1.currentTarget);
         var _loc2_:int = 0;
         while(_loc2_ < iRunnings.length)
         {
            _loc3_ = iRunnings[_loc2_];
            if(_loc7_ == _loc3_[0])
            {
               _loc6_ = _loc3_[1];
               _loc6_[2 + _loc3_[2]] = _loc7_;
               _loc4_ = _loc6_[0];
               _loc4_--;
               if(_loc4_ == 0)
               {
                  _loc5_ = _loc6_[1];
               }
               else
               {
                  _loc6_[0] = _loc4_;
               }
               iRunnings.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         if(_loc5_ != null)
         {
            _loc6_.splice(0,2);
            _loc5_(_loc6_);
         }
      }
   }
}

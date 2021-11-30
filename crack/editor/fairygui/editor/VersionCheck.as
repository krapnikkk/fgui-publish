package fairygui.editor
{
   import fairygui.editor.utils.RuntimeErrorUtil;
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   
   public class VersionCheck extends EventDispatcher
   {
      
      private static var _inst:VersionCheck;
       
      
      private var iLoader:URLLoader;
      
      private var iRunning:Boolean;
      
      public var initiator:EditorWindow;
      
      public const VER_URL:String = "http://111.230.7.136/webapi/editor/version/check";
      
      public function VersionCheck()
      {
         super();
      }
      
      public static function get inst() : VersionCheck
      {
         if(!_inst)
         {
            _inst = new VersionCheck();
         }
         return _inst;
      }
      
      public function start(param1:EditorWindow = null) : void
      {
         if(this.iRunning)
         {
            return;
         }
         this.initiator = param1;
         this.iRunning = true;
         var _loc8_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc6_:Namespace = _loc8_.namespace("");
         var _loc7_:String = _loc8_._loc6_::versionNumber;
         var _loc2_:Array = _loc7_.split(".");
         var _loc3_:int = int(_loc2_[0]) * 10000 + int(_loc2_[1]) * 100 + int(_loc2_[2]);
         var _loc5_:URLVariables = new URLVariables();
         _loc5_.pid = _loc8_._loc6_::id;
         _loc5_.ver = _loc3_;
         _loc5_.type = Capabilities.os.toLowerCase().indexOf("mac") != -1?"mac":"win";
         this.iLoader = new URLLoader();
         this.iLoader.addEventListener("complete",this.checkCompleteHandler);
         this.iLoader.addEventListener("ioError",this.checkErrorHandler);
         var _loc4_:URLRequest = new URLRequest();
         _loc4_.url = "http://111.230.7.136/webapi/editor/version/check";
         _loc4_.method = "GET";
         _loc4_.data = _loc5_;
         this.iLoader.load(_loc4_);
      }
      
      public function cancel() : void
      {
         this.cleanup();
      }
      
      private function success(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = param1;
         this.cleanup();
         if(!_loc3_)
         {
            ClassEditor.onVersionCheckComplete(null);
            return;
         }
         try
         {
            _loc2_ = JSON.parse(_loc3_);
         }
         catch(err:*)
         {
            _loc2_ = {};
            _loc2_.code = 10001;
            _loc2_.msg = RuntimeErrorUtil.toString(err);
         }
         if(_loc2_.code == 999)
         {
            NativeApplication.nativeApplication.exit();
            return;
         }
         if(_loc2_.code || !_loc2_.url)
         {
            return;
         }
         ClassEditor.onVersionCheckComplete(_loc2_);
      }
      
      private function failed(param1:String) : void
      {
         this.cleanup();
      }
      
      private function cleanup() : void
      {
         try
         {
            this.iLoader.close();
         }
         catch(e:*)
         {
         }
         this.iLoader = null;
         this.iRunning = false;
      }
      
      private function checkCompleteHandler(param1:Event) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(_loc2_ != this.iLoader)
         {
            return;
         }
         this.success(_loc2_.data);
      }
      
      private function checkErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(_loc2_ != this.iLoader)
         {
            return;
         }
         this.failed(param1.text);
      }
   }
}

package fairygui.editor.publish
{
   import fairygui.editor.plugin.IPublishHandler;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.RuntimeErrorUtil;
   
   public class CallPlugins extends PublishStep
   {
       
      
      private var _index:int;
      
      private var _myCallback:Callback;
      
      private var _handlers:Vector.<IPublishHandler>;
      
      public function CallPlugins()
      {
         super();
      }
      
      override public function run() : void
      {
         this._handlers = publishData._project.plugInManager1.publishHandlers;
         if(this._handlers.length == 0)
         {
            stepCallback.callOnSuccessImmediately();
            return;
         }
         this._index = 0;
         this._myCallback = new Callback();
         this._myCallback.success = function():void
         {
            stepCallback.addMsgs(_myCallback.msgs);
            _myCallback.msgs.length = 0;
            callPlugin();
         };
         this._myCallback.failed = function():void
         {
            stepCallback.msgs.length = 0;
            stepCallback.addMsgs(_myCallback.msgs);
            stepCallback.callOnFailImmediately();
         };
         this.callPlugin();
      }
      
      private function callPlugin() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         if(this._index >= this._handlers.length)
         {
            stepCallback.callOnSuccessImmediately();
            return;
         }
         var _loc3_:IPublishHandler = this._handlers[this._index];
         this._index++;
         try
         {
            _loc1_ = _loc3_.doExport(publishData,this._myCallback);
         }
         catch(err:Error)
         {
            _myCallback.failed = _loc5_;
            _myCallback.success = _loc5_;
            stepCallback.msgs.length = 0;
            _loc2_ = err.getStackTrace();
            if(_loc2_)
            {
               stepCallback.addMsg("Plugin error: " + RuntimeErrorUtil.toString(err) + "\n" + _loc2_);
            }
            else
            {
               stepCallback.addMsg("Plugin error: " + RuntimeErrorUtil.toString(err));
            }
            stepCallback.callOnFailImmediately();
            return;
         }
         if(!_loc1_)
         {
            this.callPlugin();
         }
      }
   }
}

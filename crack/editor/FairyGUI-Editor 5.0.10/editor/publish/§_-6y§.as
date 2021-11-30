package fairygui.editor.publish
{
   import fairygui.editor.plugin.IPublishData;
   import fairygui.editor.plugin.IPublishHandler;
   import fairygui.editor.plugin.PublishDataProxy;
   import fairygui.utils.Callback;
   
   public class §_-6y§ extends taskRun
   {
       
      
      private var _index:int;
      
      private var §_-6w§:Callback;
      
      private var _handlers:Vector.<IPublishHandler>;
      
      private var §_-2U§:IPublishData;
      
      public function §_-6y§()
      {
         super();
      }
      
      override public function run() : void
      {
         this._handlers = publishData.project.getVar("PublishPlugins");
         if(!this._handlers || this._handlers.length == 0)
         {
            _stepCallback.callOnSuccessImmediately();
            return;
         }
         this._index = 0;
         this.§_-2U§ = new PublishDataProxy(publishData);
         this.§_-6w§ = new Callback();
         this.§_-6w§.success = function():void
         {
            _stepCallback.addMsgs(§_-6w§.msgs);
            §_-6w§.msgs.length = 0;
            §_-FF§();
         };
         this.§_-6w§.failed = function():void
         {
            _stepCallback.msgs.length = 0;
            _stepCallback.addMsgs(§_-6w§.msgs);
            _stepCallback.callOnFailImmediately();
         };
         this.§_-FF§();
      }
      
      private function §_-FF§() : void
      {
         var ret:Boolean = false;
         if(this._index >= this._handlers.length)
         {
            _stepCallback.callOnSuccessImmediately();
            return;
         }
         var handler:IPublishHandler = this._handlers[this._index];
         this._index++;
         try
         {
            ret = handler.doExport(this.§_-2U§,this.§_-6w§);
         }
         catch(err:Error)
         {
            §_-6w§.success = §_-6w§.failed = null;
            _stepCallback.msgs.length = 0;
            publishData.project.editor.consoleView.logError("Plugin error: ",err);
            _stepCallback.addMsg("Plugin error");
            _stepCallback.callOnFailImmediately();
            return;
         }
         if(!ret)
         {
            this.§_-FF§();
         }
      }
   }
}

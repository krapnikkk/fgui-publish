package fairygui.editor.worker
{
   import fairygui.editor.api.IUIProject;
   import fairygui.utils.pack.PackSettings;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.net.registerClassAlias;
   import flash.system.MessageChannel;
   import flash.system.Worker;
   import flash.system.WorkerDomain;
   
   public class WorkerClient
   {
      
      private static var worker_ByteClass:Class = WorkerClient_worker_ByteClass;
      
      private static var _inst:WorkerClient;
       
      
      private var _worker:Worker;
      
      private var _outChannel:MessageChannel;
      
      private var _inChannel:MessageChannel;
      
      private var _msgs:Object;
      
      private var _nextMsgId:uint;
      
      public function WorkerClient()
      {
         super();
         registerClassAlias("WorkerMessage",WorkerMessage);
         registerClassAlias("ConvertMessage",ConvertMessage);
         registerClassAlias("PackSettings",PackSettings);
         this._msgs = {};
      }
      
      public static function get inst() : WorkerClient
      {
         if(!_inst)
         {
            _inst = new WorkerClient();
         }
         return _inst;
      }
      
      public function dispose() : void
      {
         if(this._worker)
         {
            this._inChannel.close();
            this._outChannel.close();
            this._worker.terminate();
         }
      }
      
      public function setSharedProperty(param1:String, param2:*) : void
      {
         if(!this._worker)
         {
            this.createWorker();
         }
         this._worker.setSharedProperty(param1,param2);
      }
      
      public function getSharedProperty(param1:String) : *
      {
         if(!this._worker)
         {
            this.createWorker();
         }
         return this._worker.getSharedProperty(param1);
      }
      
      public function send(param1:IUIProject, param2:String, param3:Object = null, param4:Function = null, param5:Function = null) : void
      {
         if(!this._worker)
         {
            this.createWorker();
         }
         var _loc6_:WorkerMessage = new WorkerMessage();
         _loc6_.msgId = this._nextMsgId++;
         _loc6_.cmd = param2;
         _loc6_.data = param3;
         this._msgs[_loc6_.msgId] = {
            "project":param1,
            "onComplete":param4,
            "onError":param5
         };
         this._outChannel.send(_loc6_);
      }
      
      public function removeRequests(param1:IUIProject) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Array = [];
         for(_loc3_ in this._msgs)
         {
            if(this._msgs[_loc3_].project == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         _loc4_ = _loc2_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            delete this._msgs[_loc2_[_loc5_]];
            _loc5_++;
         }
      }
      
      private function createWorker() : void
      {
         this._worker = WorkerDomain.current.createWorker(new worker_ByteClass(),true);
         this._outChannel = Worker.current.createMessageChannel(this._worker);
         this._inChannel = this._worker.createMessageChannel(Worker.current);
         this._inChannel.addEventListener(Event.CHANNEL_MESSAGE,this.__channelMessage);
         this._worker.setSharedProperty("outChannel",this._outChannel);
         this._worker.setSharedProperty("inChannel",this._inChannel);
         this._worker.setSharedProperty("applicationDirectory",File.applicationDirectory.nativePath);
         this._worker.start();
      }
      
      private function __channelMessage(param1:Event) : void
      {
         var _loc2_:WorkerMessage = null;
         var _loc3_:Object = null;
         while(this._inChannel.messageAvailable)
         {
            _loc2_ = this._inChannel.receive();
            if(_loc2_.cmd != "trace")
            {
               _loc3_ = this._msgs[_loc2_.msgId];
               if(_loc3_)
               {
                  if(_loc2_.error)
                  {
                     if(_loc3_.onError != null)
                     {
                        if(_loc3_.onError.length == 1)
                        {
                           _loc3_.onError(_loc2_.error);
                        }
                        else
                        {
                           _loc3_.onError(_loc2_.error,_loc2_.data);
                        }
                     }
                  }
                  else if(_loc3_.onComplete)
                  {
                     if(_loc3_.onComplete.length == 1)
                     {
                        _loc3_.onComplete(_loc2_.data);
                     }
                     else
                     {
                        _loc3_.onComplete();
                     }
                  }
                  delete this._msgs[_loc2_.msgId];
               }
            }
         }
      }
   }
}

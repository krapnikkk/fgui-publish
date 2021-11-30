package fairygui.editor.pack
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.settings.AtlasSettings;
   import fairygui.utils.GTimers;
   import flash.events.Event;
   import flash.net.registerClassAlias;
   import flash.system.MessageChannel;
   import flash.system.Worker;
   import flash.system.WorkerDomain;
   import flash.utils.ByteArray;
   
   public class BinPackManager
   {
       
      
      private var _worker:Worker;
      
      private var _outChannel:MessageChannel;
      
      private var _inChannel:MessageChannel;
      
      private var _callback:Function;
      
      public function BinPackManager(param1:EditorWindow)
      {
         super();
         registerClassAlias("PackSettings",PackSettings);
      }
      
      public function pack(param1:Vector.<NodeRect>, param2:PackSettings, param3:Function) : void
      {
         var _loc10_:Vector.<Page> = null;
         var _loc9_:int = 0;
         var _loc8_:int = 0;
         var _loc6_:Page = null;
         var _loc7_:NodeRect = null;
         if(param1.length == 0)
         {
            GTimers.inst.callLater(param3,new Vector.<Page>());
            return;
         }
         if(param1.length == 1)
         {
            _loc10_ = new Vector.<Page>();
            _loc9_ = param1[0].width;
            _loc8_ = param1[0].height;
            if(param2.pot)
            {
               _loc9_ = MaxRectsPacker.getNextPowerOfTwo(_loc9_);
               _loc8_ = MaxRectsPacker.getNextPowerOfTwo(_loc8_);
            }
            if(param2.square)
            {
               _loc8_ = Math.max(_loc9_,_loc8_);
               _loc9_ = Math.max(_loc9_,_loc8_);
            }
            _loc6_ = new Page();
            _loc6_.width = _loc9_;
            _loc6_.height = _loc8_;
            _loc6_.occupancy = 1;
            _loc6_.outputRects.push(param1[0]);
            _loc10_.push(_loc6_);
            GTimers.inst.callLater(param3,_loc10_);
            return;
         }
         if(!this._worker)
         {
            this.createWorker();
         }
         var _loc11_:ByteArray = new ByteArray();
         _loc11_.shareable = true;
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = param1[_loc5_];
            _loc11_.writeInt(_loc7_.id);
            _loc11_.writeInt(_loc7_.x);
            _loc11_.writeInt(_loc7_.y);
            _loc11_.writeInt(_loc7_.width);
            _loc11_.writeInt(_loc7_.height);
            _loc5_++;
         }
         this._worker.setSharedProperty("rects",_loc11_);
         this._worker.setSharedProperty("settings",param2);
         this._callback = param3;
         this._outChannel.send("do");
      }
      
      private function createWorker() : void
      {
         this._worker = WorkerDomain.current.createWorker(Workers.fairygui_editor_pack_BinPackWorker);
         this._outChannel = Worker.current.createMessageChannel(this._worker);
         this._inChannel = this._worker.createMessageChannel(Worker.current);
         this._inChannel.addEventListener("channelMessage",this.__channelMessage);
         this._worker.setSharedProperty("outChannel",this._outChannel);
         this._worker.setSharedProperty("inChannel",this._inChannel);
         this._worker.start();
      }
      
      private function __channelMessage(param1:Event) : void
      {
         var _loc8_:int = 0;
         var _loc9_:Vector.<Page> = null;
         var _loc4_:int = 0;
         var _loc7_:Page = null;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:NodeRect = null;
         var _loc10_:ByteArray = this._worker.getSharedProperty("rects1");
         _loc10_.position = 0;
         if(_loc10_.length > 0)
         {
            _loc8_ = _loc10_.readByte();
            if(_loc8_ > 0)
            {
               _loc9_ = new Vector.<Page>();
               _loc4_ = 0;
               while(_loc4_ < _loc8_)
               {
                  _loc7_ = new Page();
                  _loc7_.width = _loc10_.readInt();
                  _loc7_.height = _loc10_.readInt();
                  _loc7_.outputRects = new Vector.<NodeRect>();
                  _loc9_.push(_loc7_);
                  _loc6_ = _loc10_.readInt();
                  _loc5_ = 0;
                  while(_loc5_ < _loc6_)
                  {
                     _loc3_ = new NodeRect();
                     _loc3_.id = _loc10_.readInt();
                     _loc3_.x = _loc10_.readInt();
                     _loc3_.y = _loc10_.readInt();
                     _loc3_.width = _loc10_.readInt();
                     _loc3_.height = _loc10_.readInt();
                     _loc3_.rotated = _loc10_.readByte() == 1;
                     _loc7_.outputRects.push(_loc3_);
                     _loc5_++;
                  }
                  _loc4_++;
               }
            }
         }
         var _loc2_:Function = this._callback;
         this._callback = null;
      }
   }
}

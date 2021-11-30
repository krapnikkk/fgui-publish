package fairygui.utils.loader
{
   import fairygui.utils.GTimers;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.getTimer;
   
   public class Downloader extends EventDispatcher
   {
      
      public static const PART_SIZE:int = 1024000;
       
      
      private var _sizeLoader:SizeLoader;
      
      private var _bodyLoaders:Array;
      
      private var _url:String;
      
      private var _threadCnt:int;
      
      private var _failedParts:Array;
      
      private var _allowResuming:Boolean;
      
      private var _running:Boolean;
      
      private var _file:File;
      
      private var _tmpFile:File;
      
      private var _fileStream:FileStream;
      
      private var _writeQueue:Array;
      
      private var _curWritePart:int;
      
      private var _partCount:int;
      
      private var _loadCompleted:Boolean;
      
      private var _fileSize:int;
      
      private var _startPosBase:int;
      
      private var _startPos:int;
      
      private var _endPos:int;
      
      private var _confirmBytes:int;
      
      private var _speed:int;
      
      private var _prevBytes:int;
      
      private var _addedBytes:int;
      
      private var _lastCheckTime:int;
      
      private var _checkInterval:int;
      
      public function Downloader()
      {
         super();
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get filePath() : String
      {
         return this._file.nativePath;
      }
      
      public function get speed() : int
      {
         return this._speed;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function download(param1:String, param2:String, param3:int = 3, param4:Boolean = true) : void
      {
         this.cleanup();
         this._running = true;
         this._url = param1;
         this._file = new File(param2);
         this._threadCnt = param3;
         this._bodyLoaders = [];
         this._failedParts = [];
         this._writeQueue = [];
         this._loadCompleted = false;
         this._speed = 0;
         this._checkInterval = 500;
         this._allowResuming = param4;
         this._sizeLoader = new SizeLoader();
         this._sizeLoader.addEventListener(Event.COMPLETE,this.onGetSizeComplete);
         this._sizeLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onGetSizeError);
         this._sizeLoader.load(param1);
      }
      
      public function cancel() : void
      {
         this.cleanup();
      }
      
      private function onGetSizeComplete(param1:Event) : void
      {
         this._fileSize = this._sizeLoader.resultSize;
         this.loadStart();
      }
      
      private function onGetSizeError(param1:IOErrorEvent) : void
      {
         this.cleanup();
         dispatchEvent(param1);
      }
      
      private function loadStart() : void
      {
         var _loc1_:* = this._file.nativePath + ".tmp";
         this._tmpFile = new File(_loc1_);
         if(this._tmpFile.exists)
         {
            if(this._allowResuming)
            {
               this._startPos = this._tmpFile.size;
            }
            else
            {
               this._startPos = 0;
            }
         }
         else
         {
            this._startPos = 0;
         }
         this._endPos = -1;
         this._startPosBase = this._startPos;
         this._prevBytes = this._startPos;
         this._confirmBytes = this._startPos;
         this._curWritePart = 0;
         this._partCount = Math.ceil((this._fileSize - this._startPosBase) / PART_SIZE);
         this._fileStream = new FileStream();
         this._fileStream.open(this._tmpFile,!!this._allowResuming?FileMode.APPEND:FileMode.WRITE);
         var _loc2_:int = this._threadCnt;
         this._threadCnt = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.loadPart(null))
            {
               this._threadCnt++;
               _loc3_++;
               continue;
            }
            break;
         }
         if(this._threadCnt == 0)
         {
            this.loadCompleted();
         }
         else
         {
            GTimers.inst.add(50,0,this.delayWriteHandler);
            GTimers.inst.add(50,0,this.speedHandler);
         }
      }
      
      private function loadCompleted() : void
      {
         this.cleanup();
         try
         {
            this._tmpFile.moveTo(this._file,true);
         }
         catch(err:Error)
         {
            throw new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,err.message);
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function loadPart(param1:PartLoader) : Boolean
      {
         if(this._endPos > 0)
         {
            this._startPos = this._endPos + 1;
         }
         this._endPos = this._startPos + PART_SIZE - 1;
         if(this._endPos > this._fileSize - 1)
         {
            this._endPos = this._fileSize - 1;
         }
         if(this._endPos < this._startPos)
         {
            return false;
         }
         if(!param1)
         {
            param1 = new PartLoader();
            param1.addEventListener(ProgressEvent.PROGRESS,this.onGetPartProgress);
            param1.addEventListener(Event.COMPLETE,this.onGetPartComplete);
            param1.addEventListener(IOErrorEvent.IO_ERROR,this.onGetPartError);
            this._bodyLoaders.push(param1);
         }
         param1.load(this._url,this._startPos,this._endPos);
         return true;
      }
      
      private function delayWriteHandler() : void
      {
         if(this._writeQueue[0])
         {
            this.doWrite();
            this.loadNext();
         }
         else if(this._loadCompleted)
         {
            this.loadCompleted();
         }
      }
      
      private function doWrite() : void
      {
         try
         {
            this._fileStream.writeBytes(this._writeQueue.shift());
            this._curWritePart++;
            if(this._curWritePart >= this._partCount)
            {
               this._loadCompleted = true;
            }
            return;
         }
         catch(err:Error)
         {
            cleanup();
            throw new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,err.message);
         }
      }
      
      private function speedHandler() : void
      {
         if(!this._lastCheckTime)
         {
            return;
         }
         var _loc1_:int = getTimer();
         var _loc2_:int = _loc1_ - this._lastCheckTime;
         if(_loc2_ < this._checkInterval)
         {
            return;
         }
         if(this._checkInterval < 2000)
         {
            this._checkInterval = this._checkInterval + 500;
         }
         this._lastCheckTime = _loc1_;
         this._speed = this._addedBytes / _loc2_ * 1000;
         this._addedBytes = 0;
      }
      
      private function onGetPartProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = this._confirmBytes;
         var _loc3_:int = 0;
         while(_loc3_ < this._bodyLoaders.length)
         {
            _loc2_ = _loc2_ + this._bodyLoaders[_loc3_].bytesLoaded;
            _loc3_++;
         }
         param1.bytesLoaded = _loc2_;
         param1.bytesTotal = this._fileSize;
         _loc2_ = param1.bytesLoaded - this._prevBytes;
         if(_loc2_ > 0)
         {
            this._addedBytes = this._addedBytes + _loc2_;
         }
         this._prevBytes = param1.bytesLoaded;
         if(!this._lastCheckTime)
         {
            this._lastCheckTime = getTimer();
         }
         dispatchEvent(param1);
      }
      
      private function onGetPartComplete(param1:Event) : void
      {
         var _loc2_:PartLoader = PartLoader(param1.currentTarget);
         this._confirmBytes = this._confirmBytes + _loc2_.bytesLoaded;
         var _loc3_:int = (_loc2_.startPos - this._startPosBase) / PART_SIZE - this._curWritePart;
         this._writeQueue[_loc3_] = _loc2_.data;
         if(_loc3_ == 0)
         {
            this.doWrite();
         }
         this.loadNext();
      }
      
      private function loadNext() : void
      {
         var _loc2_:PartLoader = null;
         var _loc3_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._bodyLoaders.length)
         {
            _loc2_ = this._bodyLoaders[_loc1_];
            if(_loc2_.idle)
            {
               if(this._failedParts.length)
               {
                  _loc3_ = this._failedParts.pop();
                  _loc2_.load(this._url,_loc3_[0],_loc3_[1]);
               }
               else
               {
                  if(this._writeQueue.length >= 8)
                  {
                     break;
                  }
                  if(!this.loadPart(_loc2_))
                  {
                     this._bodyLoaders.splice(_loc1_,1);
                     continue;
                  }
               }
            }
            _loc1_++;
         }
      }
      
      private function onGetPartError(param1:IOErrorEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:PartLoader = PartLoader(param1.currentTarget);
         this._threadCnt--;
         if(this._threadCnt == 0)
         {
            this.cleanup();
            dispatchEvent(param1);
         }
         else
         {
            _loc3_ = this._bodyLoaders.indexOf(_loc2_);
            this._bodyLoaders.splice(_loc3_,1);
            this._failedParts.push([_loc2_.startPos,_loc2_.endPos]);
            this.loadNext();
         }
      }
      
      private function cleanup() : void
      {
         var _loc1_:int = 0;
         this._running = false;
         GTimers.inst.remove(this.delayWriteHandler);
         GTimers.inst.remove(this.speedHandler);
         if(this._sizeLoader)
         {
            this._sizeLoader.dispose();
            this._sizeLoader = null;
         }
         if(this._bodyLoaders)
         {
            _loc1_ = 0;
            while(_loc1_ < this._bodyLoaders.length)
            {
               this._bodyLoaders[_loc1_].dispose();
               _loc1_++;
            }
         }
         if(this._fileStream)
         {
            try
            {
               this._fileStream.close();
            }
            catch(e:*)
            {
            }
            this._fileStream = null;
         }
      }
   }
}

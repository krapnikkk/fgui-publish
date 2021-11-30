package fairygui.editor.utils.zip
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   
   class ZipParser
   {
       
      
      private var _zip:ZipArchive;
      
      private var _data:ByteArray;
      
      private var _entries:int;
      
      private var _offsetOfFirstEntry:int;
      
      function ZipParser()
      {
         super();
         this._entries = 0;
         this._offsetOfFirstEntry = 0;
      }
      
      function loadZipFromFile(param1:ZipArchive, param2:String) : void
      {
         this._zip = param1;
         this._data = new ByteArray();
         this._data.endian = "littleEndian";
         this.load(param2);
      }
      
      function loadZipFromBytes(param1:ZipArchive, param2:ByteArray) : void
      {
         this._zip = param1;
         this._data = param2;
         this._data.position = 0;
         this._data.endian = "littleEndian";
         this.parse();
      }
      
      private function load(param1:String) : void
      {
         var _loc2_:URLStream = new URLStream();
         _loc2_.load(new URLRequest(param1));
         _loc2_.addEventListener("progress",this.zipLoadHanlder);
         _loc2_.addEventListener("complete",this.zipLoadHanlder);
         _loc2_.addEventListener("ioError",this.zipLoadHanlder);
      }
      
      private function zipLoadHanlder(param1:Event) : void
      {
         var _loc2_:* = param1.type;
         if("complete" !== _loc2_)
         {
            if("progress" !== _loc2_)
            {
               if("ioError" === _loc2_)
               {
                  param1.target.removeEventListener("progress",this.zipLoadHanlder);
                  param1.target.removeEventListener("complete",this.zipLoadHanlder);
                  param1.target.removeEventListener("ioError",this.zipLoadHanlder);
                  this._zip.dispatchEvent(new ZipEvent("error",IOErrorEvent(param1).text));
               }
            }
            else
            {
               this._zip.dispatchEvent(new ZipEvent("progress",{
                  "bytesLoaded":ProgressEvent(param1).bytesLoaded,
                  "bytesTotal":ProgressEvent(param1).bytesTotal
               }));
            }
         }
         else
         {
            param1.target.removeEventListener("progress",this.zipLoadHanlder);
            param1.target.removeEventListener("complete",this.zipLoadHanlder);
            param1.target.removeEventListener("ioError",this.zipLoadHanlder);
            URLStream(param1.target).readBytes(this._data);
            this._zip.dispatchEvent(new ZipEvent("loaded"));
            this.parse();
         }
      }
      
      private function parse() : void
      {
         var _loc3_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc10_:int = 0;
         var _loc7_:ByteArray = null;
         try
         {
            _loc3_ = this.locateBlockWithSignature(101010256,this._data.length,22,65535);
            if(_loc3_ < 0)
            {
               throw new Error("Cannot find central directory");
            }
            _loc9_ = this._data.readUnsignedShort();
            _loc1_ = this._data.readUnsignedShort();
            _loc6_ = this._data.readUnsignedShort();
            _loc4_ = this._data.readUnsignedShort();
            _loc5_ = this._data.readUnsignedInt();
            _loc8_ = this._data.readUnsignedInt();
            _loc2_ = this._data.readUnsignedShort();
            if(_loc2_ > 0)
            {
               _loc7_ = new ByteArray();
               this._data.readBytes(_loc7_,0,_loc2_);
               this._zip.comment = _loc7_.readMultiByte(_loc7_.length,this._zip.encoding);
            }
            this._offsetOfFirstEntry = 0;
            if(_loc8_ < _loc3_ - (4 + _loc5_))
            {
               this._offsetOfFirstEntry = _loc3_ - (4 + _loc5_ + _loc8_);
               if(this._offsetOfFirstEntry <= 0)
               {
                  throw new Error("Invalid embedded zip archive!");
               }
            }
            this._entries = _loc6_;
            this._data.position = this._offsetOfFirstEntry + _loc8_;
            _loc10_ = 0;
            while(_loc10_ < _loc6_)
            {
               this.parseFile();
               _loc10_++;
            }
            this._zip.dispatchEvent(new ZipEvent("init"));
         }
         catch(e:Error)
         {
            _zip.dispatchEvent(new ZipEvent("error",e.message));
         }
         this._data = null;
      }
      
      private function parseFile() : void
      {
         var _loc19_:ByteArray = null;
         if(this._data.readUnsignedInt() != 33639248)
         {
            throw new Error("Invalid central directory signature!");
         }
         var _loc12_:int = this._data.readUnsignedShort();
         var _loc10_:int = this._data.readUnsignedShort();
         var _loc8_:int = this._data.readUnsignedShort();
         var _loc9_:int = this._data.readUnsignedShort();
         var _loc14_:int = this._data.readUnsignedInt();
         var _loc15_:int = this._data.readUnsignedInt();
         var _loc18_:int = this._data.readUnsignedInt();
         var _loc16_:int = this._data.readUnsignedInt();
         var _loc17_:int = this._data.readUnsignedShort();
         var _loc2_:int = this._data.readUnsignedShort();
         var _loc4_:int = this._data.readUnsignedShort();
         var _loc3_:int = this._data.readUnsignedShort();
         var _loc6_:int = this._data.readUnsignedShort();
         var _loc1_:int = this._data.readUnsignedInt();
         var _loc11_:int = this._data.readUnsignedInt();
         var _loc13_:String = (_loc8_ & 2048) != 0?"utf-8":this._zip.encoding;
         var _loc7_:String = this._data.readMultiByte(_loc17_,_loc13_);
         var _loc5_:ZipFile = new ZipFile(_loc7_);
         _loc5_._crc32 = _loc15_ & 4294967295;
         _loc5_._size = _loc16_ & 4294967295;
         _loc5_._compressedSize = _loc18_ & 4294967295;
         _loc5_._compressionMethod = _loc9_;
         _loc5_._flag = _loc8_;
         _loc5_._dostime = _loc14_;
         _loc5_.encoding = _loc13_;
         _loc5_._encrypted = (_loc8_ & 1) == 1;
         if(_loc2_ > 0)
         {
            _loc19_ = new ByteArray();
            this._data.readBytes(_loc19_,0,_loc2_);
            _loc5_._extra = _loc19_;
         }
         if(_loc4_ > 0)
         {
            _loc5_._comment = this._data.readMultiByte(_loc4_,_loc5_.encoding);
         }
         this.parseContent(_loc5_,_loc11_);
         this._zip.addFile(_loc5_);
      }
      
      private function parseContent(param1:ZipFile, param2:int) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:ZipInflater = null;
         var _loc5_:int = this._data.position;
         this._data.position = param2 + 30 + param1.name.length;
         var _loc6_:ByteArray = new ByteArray();
         this._data.readBytes(_loc6_,0,param1._compressedSize);
         this._data.position = _loc5_;
         if(param1.encrypted)
         {
            param1._data = _loc6_;
            return;
         }
         switch(int(param1._compressionMethod))
         {
            case 0:
               param1._data = _loc6_;
               break;
            default:
            default:
            default:
            default:
            default:
            default:
            default:
               throw new Error("Invalid compression method!");
            case 8:
               _loc3_ = new ByteArray();
               _loc4_ = new ZipInflater();
               _loc4_.setInput(_loc6_);
               _loc4_.inflate(_loc3_);
               param1._data = _loc3_;
         }
      }
      
      private function locateBlockWithSignature(param1:int, param2:int, param3:int, param4:int) : int
      {
         var _loc5_:int = param2 - param3;
         var _loc6_:int = Math.max(_loc5_ - param4,0);
         if(_loc5_ < 0 || _loc5_ < _loc6_)
         {
            return -1;
         }
         while(_loc5_ >= _loc6_)
         {
            if(this._data[_loc5_] == 80)
            {
               this._data.position = _loc5_;
               if(this._data.readUnsignedInt() == param1)
               {
                  return _loc5_;
               }
            }
            _loc5_--;
         }
         return -1;
      }
   }
}

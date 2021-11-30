package fairygui.editor.utils.zip
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class ZipArchive extends EventDispatcher
   {
       
      
      private var _name:String;
      
      private var _comment:String;
      
      private var _encoding:String;
      
      private var _list:Array;
      
      private var _entry:Dictionary;
      
      public function ZipArchive(param1:String = null, param2:String = "utf-8")
      {
         super();
         this._name = param1;
         this._encoding = param2;
         this._list = [];
         this._entry = new Dictionary();
      }
      
      public function load(param1:String) : void
      {
         var _loc2_:ZipParser = null;
         try
         {
            if(!this._name)
            {
               this._name = param1;
            }
            _loc2_ = new ZipParser();
            _loc2_.loadZipFromFile(this,param1);
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function open(param1:ByteArray) : Boolean
      {
         var _loc2_:ZipParser = null;
         try
         {
            if(param1 == null || param1.length == 0)
            {
               var _loc4_:Boolean = false;
               return _loc4_;
            }
            _loc2_ = new ZipParser();
            _loc2_.loadZipFromBytes(this,param1);
            var _loc5_:Boolean = true;
            return _loc5_;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function addFile(param1:ZipFile, param2:int = -1) : ZipFile
      {
         if(param1 != null)
         {
            if(param2 < 0 || param2 >= this._list.length)
            {
               this._list.push(param1);
            }
            else
            {
               this._list.splice(param2,0,param1);
            }
            this._entry[param1.name] = param1;
            return param1;
         }
         return null;
      }
      
      public function addFileFromBytes(param1:String, param2:ByteArray = null, param3:int = -1) : ZipFile
      {
         if(this._entry[param1] != null)
         {
            dispatchEvent(new ZipEvent("error","File: " + param1 + " already exists."));
         }
         try
         {
            param2.position = 0;
            param2.uncompress();
         }
         catch(e:Error)
         {
         }
         var _loc4_:ZipFile = new ZipFile(param1);
         _loc4_._data = param2;
         _loc4_._size = param2.length;
         _loc4_._version = 20;
         _loc4_._flag = 0;
         _loc4_._crc32 = CRC32.getCRC32(param2);
         _loc4_.date = new Date();
         return this.addFile(_loc4_,param3);
      }
      
      public function addFileFromString(param1:String, param2:String, param3:int = -1) : ZipFile
      {
         if(param2 == null)
         {
            return null;
         }
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeUTFBytes(param2);
         var _loc4_:ZipFile = this.addFileFromBytes(param1,_loc5_,param3);
         _loc4_.encoding = "utf-8";
         return _loc4_;
      }
      
      public function getFileByName(param1:String) : ZipFile
      {
         return this._entry[param1];
      }
      
      public function getFileAt(param1:int) : ZipFile
      {
         if(param1 < 0 || param1 > this._list.length)
         {
            return null;
         }
         return this._list[param1];
      }
      
      public function getAsyncDisplayObject(param1:String, param2:Function = null) : void
      {
         param1 = param1;
         param2 = param2;
         var onAsyncBitmap:Function = null;
         var name:String = param1;
         var onLoad:Function = param2;
         onAsyncBitmap = function(param1:Event):void
         {
            var _loc2_:LoaderInfo = param1.target as LoaderInfo;
            param1.target.removeEventListener("complete",onAsyncBitmap);
            onLoad.call(null,_loc2_.content);
            loader = null;
         };
         var file:ZipFile = this.getFileByName(name);
         if(file == null)
         {
            dispatchEvent(new ZipEvent("error","Can\'t find file with name: " + name));
         }
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener("complete",onAsyncBitmap);
         loader.loadBytes(file.data);
      }
      
      public function removeFileByName(param1:String) : ZipFile
      {
         var _loc2_:int = 0;
         if(this._entry[param1] != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this._list.length)
            {
               if(param1 == this._list[_loc2_].name)
               {
                  return this.removeFileAt(_loc2_);
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public function removeFileAt(param1:int) : ZipFile
      {
         var _loc2_:ZipFile = this.getFileAt(param1);
         if(_loc2_ != null)
         {
            this._list.splice(param1,1);
            delete this._entry[_loc2_.name];
            return _loc2_;
         }
         return null;
      }
      
      public function output(param1:uint = 8) : ByteArray
      {
         var _loc2_:ZipSerializer = new ZipSerializer();
         return _loc2_.serialize(this,param1) as ByteArray;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get numFiles() : int
      {
         return this._list.length;
      }
      
      public function get comment() : String
      {
         return this._comment;
      }
      
      public function set comment(param1:String) : void
      {
         this._comment = param1;
      }
      
      public function get encoding() : String
      {
         return this._encoding;
      }
      
      public function set encoding(param1:String) : void
      {
         this._encoding = param1;
      }
      
      override public function toString() : String
      {
         return "[ZipArchive name=\"" + this.name + "\" files=" + this.numFiles + "]";
      }
      
      public function toComplexString() : String
      {
         var _loc2_:* = this.toString() + "\r";
         var _loc1_:int = 0;
         while(_loc1_ < this.numFiles)
         {
            _loc2_ = _loc2_ + ("Index:" + _loc1_ + " --> " + this._list[_loc1_].toString());
            _loc1_++;
         }
         return _loc2_;
      }
   }
}

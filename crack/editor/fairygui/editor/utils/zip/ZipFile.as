package fairygui.editor.utils.zip
{
   import flash.utils.ByteArray;
   
   public class ZipFile
   {
       
      
      var _name:String;
      
      var _data:ByteArray;
      
      var _size:int;
      
      var _compressedSize:int;
      
      var _crc32:uint;
      
      var _comment:String;
      
      var _extra:ByteArray;
      
      var _version:int;
      
      var _dostime:uint;
      
      var _flag:int;
      
      var _encrypted:Boolean;
      
      private var _encoding:String;
      
      var _compressionMethod:int = -1;
      
      public function ZipFile(param1:String = null, param2:String = "utf-8")
      {
         super();
         if(param1)
         {
            this._name = param1;
         }
         this._encoding = param2;
         this._data = new ByteArray();
      }
      
      public function get encoding() : String
      {
         return this._encoding;
      }
      
      public function set encoding(param1:String) : void
      {
         this._encoding = param1;
      }
      
      public function set name(param1:String) : void
      {
         this._name = this.name;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function get size() : int
      {
         return this._size;
      }
      
      public function get compressionMethod() : int
      {
         return this._compressionMethod;
      }
      
      public function get crc32() : uint
      {
         return this._crc32;
      }
      
      public function get compressedSize() : int
      {
         return this._compressedSize;
      }
      
      public function get encrypted() : Boolean
      {
         return this._encrypted;
      }
      
      public function set comment(param1:String) : void
      {
         this._comment = param1;
      }
      
      public function get comment() : String
      {
         return this._comment;
      }
      
      public function set data(param1:ByteArray) : void
      {
         this._data = param1;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
      
      public function set date(param1:Date) : void
      {
         this._dostime = (param1.fullYear - 1980 & 127) << 25 | param1.month + 1 << 21 | param1.date << 16 | param1.hours << 11 | param1.minutes << 5 | param1.seconds >> 1;
      }
      
      public function get date() : Date
      {
         var _loc6_:* = (this._dostime & 31) << 1;
         var _loc5_:* = this._dostime >> 5 & 63;
         var _loc3_:* = this._dostime >> 11 & 31;
         var _loc4_:* = this._dostime >> 16 & 31;
         var _loc1_:* = this._dostime >> 21 & 14;
         var _loc2_:int = (this._dostime >> 25 & 127) + 1980;
         return new Date(_loc2_,_loc1_,_loc4_,_loc3_,_loc5_,_loc6_);
      }
      
      public function get extra() : ByteArray
      {
         return this._extra;
      }
      
      public function hasExtra() : Boolean
      {
         return this._extra != null && this._extra.length > 0;
      }
      
      public function isDirectory() : Boolean
      {
         return this._name.charAt(this._name.length - 1) == "/";
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[ZipFile Path=\"";
         _loc1_ = _loc1_ + (this._name + "\"]\rsize:" + this._size + " compressedSize:" + this._compressedSize + " CRC32:" + this._crc32.toString(16).toLocaleUpperCase());
         _loc1_ = _loc1_ + ("\rLast modify time:" + this.date + "\r");
         return _loc1_;
      }
   }
}

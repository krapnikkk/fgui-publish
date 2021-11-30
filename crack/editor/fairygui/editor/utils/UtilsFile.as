package fairygui.editor.utils
{
   import flash.events.Event;
   import flash.events.FileListEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   
   public class UtilsFile
   {
       
      
      public function UtilsFile()
      {
         super();
      }
      
      public static function browseForOpen(param1:String, param2:Array, param3:Function, param4:File = null) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         var title:String = param1;
         var filters:Array = param2;
         var callback:Function = param3;
         var initiator:File = param4;
         if(initiator == null)
         {
            initiator = new File();
         }
         initiator.browseForOpen(title,filters);
         initiator.addEventListener("select",function(param1:Event):void
         {
         });
      }
      
      public static function browseForOpenMultiple(param1:String, param2:Array, param3:Function, param4:File = null) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         var title:String = param1;
         var filters:Array = param2;
         var callback:Function = param3;
         var initiator:File = param4;
         if(initiator == null)
         {
            initiator = new File();
         }
         initiator.browseForOpenMultiple(title,filters);
         initiator.addEventListener("select",function(param1:Event):void
         {
         });
         initiator.addEventListener("selectMultiple",function(param1:FileListEvent):void
         {
         });
      }
      
      public static function browseForDirectory(param1:String, param2:Function, param3:File = null) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var title:String = param1;
         var callback:Function = param2;
         var initiator:File = param3;
         if(initiator == null)
         {
            initiator = new File();
         }
         initiator.browseForDirectory(title);
         initiator.addEventListener("select",function(param1:Event):void
         {
         });
      }
      
      public static function browseForSave(param1:String, param2:Function, param3:File = null) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var title:String = param1;
         var callback:Function = param2;
         var initiator:File = param3;
         if(initiator == null)
         {
            initiator = new File();
         }
         initiator.browseForSave(title);
         initiator.addEventListener("select",function(param1:Event):void
         {
         });
      }
      
      public static function listAllFiles(param1:File, param2:Array) : void
      {
         var _loc4_:File = null;
         var _loc3_:Array = param1.getDirectoryListing();
         var _loc6_:int = 0;
         var _loc5_:* = _loc3_;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.isDirectory)
            {
               listAllFiles(_loc4_,param2);
            }
            else
            {
               param2.push(_loc4_);
            }
         }
      }
      
      public static function loadString(param1:File, param2:String = null, param3:int = 2147483647) : String
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:ByteArray = loadBytes(param1,param3);
         if(_loc6_ == null)
         {
            return null;
         }
         if(!param2)
         {
            if(_loc6_.bytesAvailable > 2)
            {
               _loc4_ = _loc6_.readUnsignedByte();
               _loc5_ = _loc6_.readUnsignedByte();
               if(_loc4_ == 239 && _loc5_ == 187)
               {
                  param2 = "utf-8";
                  _loc6_.position = Number(_loc6_.position) + 1;
               }
               else if(_loc4_ == 254 && _loc5_ == 255)
               {
                  param2 = "unicodeFFFE";
               }
               else if(_loc4_ == 255 && _loc5_ == 254)
               {
                  param2 = "unicode";
               }
               else
               {
                  param2 = "utf-8";
                  _loc6_.position = _loc6_.position - 2;
               }
            }
            else
            {
               param2 = "utf-8";
            }
         }
         if(param2.toLowerCase() == "utf-8")
         {
            return _loc6_.readUTFBytes(_loc6_.length - _loc6_.position);
         }
         return _loc6_.readMultiByte(_loc6_.length - _loc6_.position,param2);
      }
      
      public static function saveString(param1:File, param2:String, param3:String = null) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         if(!param3 || param3.toUpperCase() == "UTF-8")
         {
            _loc4_.writeUTFBytes(param2);
         }
         else
         {
            _loc4_.writeMultiByte(param2,param3);
         }
         saveBytes(param1,_loc4_);
      }
      
      public static function loadBytes(param1:File, param2:int = 2147483647) : ByteArray
      {
         if(!param1.exists)
         {
            return null;
         }
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(param1,"read");
         var _loc4_:ByteArray = new ByteArray();
         _loc3_.readBytes(_loc4_,0,Math.min(param1.size,param2));
         _loc3_.close();
         return _loc4_;
      }
      
      public static function saveBytes(param1:File, param2:ByteArray) : void
      {
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(param1,"write");
         param2.position = 0;
         _loc3_.writeBytes(param2);
         _loc3_.close();
      }
      
      public static function loadXML(param1:File) : XML
      {
         var _loc2_:String = loadString(param1);
         if(_loc2_)
         {
            return new XML(_loc2_);
         }
         return null;
      }
      
      public static function saveXML(param1:File, param2:XML) : void
      {
         saveString(param1,"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" + param2.toXMLString());
      }
      
      public static function loadJSON(param1:File) : Object
      {
         var _loc2_:String = loadString(param1);
         if(_loc2_)
         {
            return JSON.parse(_loc2_);
         }
         return null;
      }
      
      public static function saveJSON(param1:File, param2:Object, param3:Boolean = false) : void
      {
         if(param3)
         {
            saveString(param1,OrderedJSONEncoder.encode(param2));
         }
         else
         {
            saveString(param1,JSON.stringify(param2,null,"\t"));
         }
      }
      
      public static function deleteFile(param1:File, param2:Boolean = false) : Boolean
      {
         var _loc3_:* = param1;
         var _loc4_:* = param2;
         try
         {
            if(_loc4_)
            {
               _loc3_.moveToTrash();
            }
            else
            {
               _loc3_.deleteFile();
            }
            var _loc6_:Boolean = true;
            return _loc6_;
         }
         catch(e:Error)
         {
            if(e.errorID == 3001 && !_loc4_)
            {
               try
               {
                  _loc3_.moveToTrash();
               }
               catch(e:Error)
               {
               }
            }
            else if(e.errorID != 3003)
            {
            }
         }
         return false;
      }
      
      public static function copyFile(param1:File, param2:File) : Boolean
      {
         var _loc3_:* = param1;
         var _loc4_:* = param2;
         if(_loc3_.nativePath == _loc4_.nativePath)
         {
            return true;
         }
         deleteFile(_loc4_);
         try
         {
            if(_loc3_.exists)
            {
               _loc3_.copyTo(_loc4_,true);
               var _loc6_:Boolean = true;
               return _loc6_;
            }
            var _loc7_:Boolean = false;
            return _loc7_;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}

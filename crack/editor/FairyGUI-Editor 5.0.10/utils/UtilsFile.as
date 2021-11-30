package fairygui.utils
{
   import flash.events.Event;
   import flash.events.FileListEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   
   public class UtilsFile
   {
      
      private static var helperBuffer:ByteArray = new ByteArray();
      
      private static var elementBuffer:ByteArray = new ByteArray();
       
      
      public function UtilsFile()
      {
         super();
      }
      
      public static function browseForOpen(param1:String, param2:Array, param3:Function, param4:File = null) : void
      {
         var title:String = param1;
         var filters:Array = param2;
         var callback:Function = param3;
         var initiator:File = param4;
         if(initiator == null)
         {
            initiator = new File();
         }
         initiator.browseForOpen(title,filters);
         initiator.addEventListener(Event.SELECT,function(param1:Event):void
         {
            callback(param1.target as File);
         });
      }
      
      public static function browseForOpenMultiple(param1:String, param2:Array, param3:Function, param4:File = null) : void
      {
         var title:String = param1;
         var filters:Array = param2;
         var callback:Function = param3;
         var initiator:File = param4;
         if(initiator == null)
         {
            initiator = new File();
         }
         initiator.browseForOpenMultiple(title,filters);
         initiator.addEventListener(Event.SELECT,function(param1:Event):void
         {
            callback([param1.target]);
         });
         initiator.addEventListener(FileListEvent.SELECT_MULTIPLE,function(param1:FileListEvent):void
         {
            callback(param1.files);
         });
      }
      
      public static function browseForDirectory(param1:String, param2:Function, param3:File = null) : void
      {
         var title:String = param1;
         var callback:Function = param2;
         var initiator:File = param3;
         if(initiator == null)
         {
            initiator = new File();
         }
         initiator.browseForDirectory(title);
         initiator.addEventListener(Event.SELECT,function(param1:Event):void
         {
            callback(param1.target as File);
         });
      }
      
      public static function browseForSave(param1:String, param2:Function, param3:File = null) : void
      {
         var title:String = param1;
         var callback:Function = param2;
         var initiator:File = param3;
         if(initiator == null)
         {
            initiator = new File();
         }
         initiator.browseForSave(title);
         initiator.addEventListener(Event.SELECT,function(param1:Event):void
         {
            callback(param1.target as File);
         });
      }
      
      public static function listAllFiles(param1:File, param2:Array) : void
      {
         var _loc4_:File = null;
         var _loc3_:Array = param1.getDirectoryListing();
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
      
      public static function loadString(param1:File, param2:String = null) : String
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc3_:ByteArray = loadBytes(param1);
         if(_loc3_ == null)
         {
            return null;
         }
         if(!param2)
         {
            if(_loc3_.bytesAvailable > 2)
            {
               _loc4_ = _loc3_.readUnsignedByte();
               _loc5_ = _loc3_.readUnsignedByte();
               if(_loc4_ == 239 && _loc5_ == 187)
               {
                  param2 = "utf-8";
                  _loc3_.position++;
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
                  _loc3_.position = _loc3_.position - 2;
               }
            }
            else
            {
               param2 = "utf-8";
            }
         }
         if(param2.toLowerCase() == "utf-8")
         {
            return _loc3_.readUTFBytes(_loc3_.length - _loc3_.position);
         }
         return _loc3_.readMultiByte(_loc3_.length - _loc3_.position,param2);
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
      
      public static function loadBytes(param1:File) : ByteArray
      {
         if(!param1.exists)
         {
            return null;
         }
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(param1,FileMode.READ);
         var _loc3_:ByteArray = new ByteArray();
         _loc2_.readBytes(_loc3_,0,param1.size);
         _loc2_.close();
         return _loc3_;
      }
      
      public static function saveBytes(param1:File, param2:ByteArray) : void
      {
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(param1,FileMode.WRITE);
         param2.position = 0;
         _loc3_.writeBytes(param2);
         _loc3_.close();
      }
      
      public static function loadXMLRoot(param1:File) : XData
      {
         var i:int = 0;
         var elementStart:int = 0;
         var b:int = 0;
         var str:String = null;
         var file:File = param1;
         if(!file.exists)
         {
            return null;
         }
         var fs:FileStream = new FileStream();
         fs.open(file,FileMode.READ);
         var len:int = Math.min(file.size,1024);
         helperBuffer.length = 0;
         fs.readBytes(helperBuffer,0,len);
         fs.close();
         while(i++ < len)
         {
            b = helperBuffer.readByte();
            if(b == 60)
            {
               elementStart = i - 1;
               while(i++ < len)
               {
                  b = helperBuffer.readByte();
                  if(b == 62)
                  {
                     helperBuffer.position = elementStart;
                     str = helperBuffer.readUTFBytes(i - elementStart);
                     if(str.charCodeAt(1) != 63 && str.charCodeAt(1) != 33)
                     {
                        if(str.charCodeAt(str.length - 2) != 47)
                        {
                           i = str.indexOf(" ");
                           if(i == -1)
                           {
                              i = str.length - 1;
                           }
                           str = str + "</" + str.substring(1,i) + ">";
                        }
                        try
                        {
                           return XData.parse(str);
                        }
                        catch(err:Error)
                        {
                           return null;
                        }
                        helperBuffer.position = i;
                        break;
                     }
                     helperBuffer.position = i;
                     break;
                  }
               }
               continue;
            }
         }
         return null;
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
      
      public static function loadXData(param1:File) : XData
      {
         var _loc2_:String = loadString(param1);
         if(_loc2_)
         {
            return XData.parse(_loc2_);
         }
         return null;
      }
      
      public static function saveXData(param1:File, param2:XData) : void
      {
         saveXML(param1,param2.toXML());
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
         var file:File = param1;
         var moveToTrash:Boolean = param2;
         try
         {
            if(moveToTrash)
            {
               file.moveToTrashAsync();
            }
            else
            {
               file.deleteFile();
            }
            return true;
         }
         catch(e:Error)
         {
            if(e.errorID == 3001 && !moveToTrash)
            {
               try
               {
                  file.moveToTrashAsync();
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
         var srcFile:File = param1;
         var dstFile:File = param2;
         if(srcFile.nativePath == dstFile.nativePath)
         {
            return true;
         }
         deleteFile(dstFile);
         try
         {
            if(srcFile.exists)
            {
               srcFile.copyTo(dstFile,true);
               return true;
            }
            return false;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public static function renameFile(param1:File, param2:File) : void
      {
         var _loc4_:File = null;
         var _loc3_:* = param2.name.toLowerCase() == param1.name.toLowerCase();
         if(param2.exists && !_loc3_)
         {
            throw new Error("file already exits");
         }
         if(_loc3_)
         {
            _loc4_ = new File(param2.nativePath + "_" + Math.random() * 1000);
            param1.moveTo(_loc4_);
            _loc4_.moveTo(param2);
         }
         else
         {
            param1.moveTo(param2);
         }
      }
   }
}

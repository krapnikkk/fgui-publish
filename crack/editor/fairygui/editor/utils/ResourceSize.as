package fairygui.editor.utils
{
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class ResourceSize
   {
      
      private static var SIGS:Array = [[71,73,70],[137,80,78,71,13,10,26,10],[255,216,255],[0,5,121,121,116,111,117],[70,87,83],[67,87,83],[90,87,83]];
      
      private static var buffer:ByteArray = new ByteArray();
      
      private static var fileStream:FileStream = new FileStream();
      
      private static var fileLen:Number;
      
      private static var result:Object;
      
      private static const M_PSEUDO:int = 65496;
      
      private static const M_SOF0:int = 192;
      
      private static const M_SOF1:int = 193;
      
      private static const M_SOF2:int = 194;
      
      private static const M_SOF3:int = 195;
      
      private static const M_SOF5:int = 197;
      
      private static const M_SOF6:int = 198;
      
      private static const M_SOF7:int = 199;
      
      private static const M_SOF9:int = 201;
      
      private static const M_SOF10:int = 202;
      
      private static const M_SOF11:int = 203;
      
      private static const M_SOF13:int = 205;
      
      private static const M_SOF14:int = 206;
      
      private static const M_SOF15:int = 207;
      
      private static const M_SOI:int = 216;
      
      private static const M_EOI:int = 217;
      
      private static const M_SOS:int = 218;
      
      private static const M_APP0:int = 224;
      
      private static const M_APP1:int = 225;
      
      private static const M_APP2:int = 226;
      
      private static const M_APP3:int = 227;
      
      private static const M_APP4:int = 228;
      
      private static const M_APP5:int = 229;
      
      private static const M_APP6:int = 230;
      
      private static const M_APP7:int = 231;
      
      private static const M_APP8:int = 232;
      
      private static const M_APP9:int = 233;
      
      private static const M_APP10:int = 234;
      
      private static const M_APP11:int = 235;
      
      private static const M_APP12:int = 236;
      
      private static const M_APP13:int = 237;
      
      private static const M_APP14:int = 238;
      
      private static const M_APP15:int = 239;
      
      private static const M_COM:int = 254;
      
      private static var marker:int;
      
      private static var pos:int;
      
      private static var _mySwf:MySwf;
       
      
      public function ResourceSize()
      {
         super();
      }
      
      public static function getSize(param1:File) : Object
      {
         var _loc3_:int = 0;
         var _loc2_:* = param1;
         if(!_loc2_.exists || _loc2_.isDirectory)
         {
            return null;
         }
         fileLen = _loc2_.size;
         fileStream = new FileStream();
         fileStream.open(_loc2_,"read");
         result = null;
         var _loc4_:int = 0;
         try
         {
            _loc3_ = checkSig();
            if(_loc3_ == 0)
            {
               checkGIF();
            }
            else if(_loc3_ == 1)
            {
               checkPNG();
            }
            else if(_loc3_ == 2)
            {
               checkJPG();
            }
            else if(_loc3_ == 3)
            {
               checkJta();
            }
            else if(_loc3_ == 4 || _loc3_ == 5 || _loc3_ == 6)
            {
               checkSwf(_loc3_ - 4);
            }
         }
         catch(_loc5_:*)
         {
            _loc4_ = 1;
         }
         fileStream.close();
         if(!int(_loc4_))
         {
            return result;
         }
         throw _loc5_;
      }
      
      private static function checkSig() : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc1_:Array = null;
         if(fileStream.bytesAvailable < 8)
         {
            return -1;
         }
         fileStream.readBytes(buffer,0,8);
         buffer.position = 0;
         _loc3_ = 0;
         while(_loc3_ < SIGS.length)
         {
            _loc1_ = SIGS[_loc3_];
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(buffer.readUnsignedByte() == _loc1_[_loc2_])
               {
                  _loc2_++;
                  continue;
               }
               break;
            }
            buffer.position = 0;
            if(_loc2_ != _loc1_.length)
            {
               _loc3_++;
               continue;
            }
            return _loc3_;
         }
         return -1;
      }
      
      private static function checkGIF() : void
      {
         if(fileLen < 10)
         {
            return;
         }
         fileStream.position = 6;
         fileStream.readBytes(buffer,0,4);
         buffer.endian = "littleEndian";
         buffer.position = 0;
         result = {
            "type":"gif",
            "width":buffer.readUnsignedShort(),
            "height":buffer.readUnsignedShort()
         };
      }
      
      private static function checkPNG() : void
      {
         if(fileLen < 26)
         {
            return;
         }
         fileStream.position = 16;
         fileStream.readBytes(buffer,0,10);
         buffer.endian = "bigEndian";
         buffer.position = 0;
         result = {
            "type":"png",
            "width":buffer.readUnsignedInt(),
            "height":buffer.readUnsignedInt(),
            "bitDepth":buffer.readByte(),
            "colorType":buffer.readByte()
         };
      }
      
      private static function checkJPG() : void
      {
         marker = 65496;
         pos = 2;
         buffer.endian = "bigEndian";
         nextMarker();
      }
      
      private static function nextMarker() : void
      {
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc3_:int = marker;
         var _loc2_:int = 0;
         if(254 == _loc3_)
         {
            _loc1_ = 2;
         }
         else
         {
            _loc1_ = 0;
         }
         if(fileLen <= pos)
         {
            return;
         }
         while(fileLen > pos + _loc2_)
         {
            fileStream.position = pos + _loc2_;
            _loc4_ = fileStream.readUnsignedByte();
            if(254 == _loc3_ && 0 < _loc1_)
            {
               if(255 != _loc4_)
               {
                  _loc4_ = 255;
                  _loc1_--;
               }
               else
               {
                  _loc3_ = 65496;
               }
            }
            _loc2_++;
            if(255 != _loc4_)
            {
               if(2 > _loc2_)
               {
                  return;
               }
               if(254 == _loc3_ && _loc1_)
               {
                  return;
               }
               pos = pos + _loc2_;
               marker = _loc4_;
               blockBody();
               return;
            }
         }
      }
      
      private static function blockBody() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = marker;
         if(192 !== _loc2_)
         {
            if(193 !== _loc2_)
            {
               if(194 !== _loc2_)
               {
                  if(195 !== _loc2_)
                  {
                     if(197 !== _loc2_)
                     {
                        if(198 !== _loc2_)
                        {
                           if(199 !== _loc2_)
                           {
                              if(201 !== _loc2_)
                              {
                                 if(202 !== _loc2_)
                                 {
                                    if(203 !== _loc2_)
                                    {
                                       if(205 !== _loc2_)
                                       {
                                          if(206 !== _loc2_)
                                          {
                                             if(207 !== _loc2_)
                                             {
                                                if(218 !== _loc2_)
                                                {
                                                   if(217 !== _loc2_)
                                                   {
                                                      if(fileLen <= pos + 2)
                                                      {
                                                         return;
                                                      }
                                                      fileStream.position = pos;
                                                      fileStream.readBytes(buffer,0,2);
                                                      buffer.position = 0;
                                                      _loc1_ = buffer.readUnsignedShort();
                                                      pos = pos + _loc1_;
                                                      nextMarker();
                                                   }
                                                }
                                             }
                                             addr140:
                                             return;
                                          }
                                          addr19:
                                          if(fileLen <= pos + 2 + 1 + 2 + 2)
                                          {
                                             return;
                                          }
                                          fileStream.position = pos + 3;
                                          fileStream.readBytes(buffer,0,4);
                                          buffer.position = 0;
                                          result = {"type":"jpg"};
                                          result.height = buffer.readUnsignedShort();
                                          result.width = buffer.readUnsignedShort();
                                          §§goto(addr140);
                                       }
                                       addr18:
                                       §§goto(addr19);
                                    }
                                    addr17:
                                    §§goto(addr18);
                                 }
                                 addr16:
                                 §§goto(addr17);
                              }
                              addr15:
                              §§goto(addr16);
                           }
                           addr14:
                           §§goto(addr15);
                        }
                        addr13:
                        §§goto(addr14);
                     }
                     addr12:
                     §§goto(addr13);
                  }
                  addr11:
                  §§goto(addr12);
               }
               addr10:
               §§goto(addr11);
            }
            addr9:
            §§goto(addr10);
         }
         §§goto(addr9);
      }
      
      private static function checkJta() : void
      {
         if(fileLen < 23)
         {
            return;
         }
         fileStream.position = 19;
         fileStream.readBytes(buffer,0,4);
         buffer.position = 0;
         buffer.endian = "bigEndian";
         result = {
            "type":"jta",
            "width":buffer.readUnsignedShort(),
            "height":buffer.readUnsignedShort()
         };
      }
      
      private static function checkJtb() : void
      {
         fileStream.position = 16;
         var _loc3_:int = fileStream.readInt();
         var _loc1_:String = fileStream.readUTFBytes(_loc3_);
         var _loc2_:Object = JSON.parse(_loc1_);
         result = {
            "type":"jtb",
            "width":0,
            "height":0
         };
      }
      
      private static function checkSwf(param1:int) : void
      {
         var _loc3_:Rectangle = null;
         var _loc2_:* = param1;
         fileStream.position = 0;
         fileStream.readBytes(buffer,0,fileLen);
         if(_mySwf == null)
         {
            _mySwf = new MySwf();
         }
         try
         {
            _mySwf.parseHeaderOnly(buffer);
            _loc3_ = _mySwf.frameSize.rect;
            result = {
               "type":"swf",
               "width":_loc3_.width,
               "height":_loc3_.height
            };
            return;
         }
         catch(err:Error)
         {
            result = {"type":"jta"};
            return;
         }
      }
   }
}

import com.codeazur.as3swf.SWF;
import flash.utils.ByteArray;

class MySwf extends SWF
{
    
   
   function MySwf()
   {
      super();
   }
   
   public function parseHeaderOnly(param1:ByteArray) : void
   {
      bytes.length = 0;
      param1.position = 0;
      param1.readBytes(bytes);
      parseHeader();
   }
}

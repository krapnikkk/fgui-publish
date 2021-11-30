package fairygui.utils
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class FontInfoReader
   {
      
      private static var isMac:Boolean;
       
      
      public function FontInfoReader()
      {
         super();
      }
      
      public static function enumerateFonts() : Array
      {
         var fontFolder:File = null;
         var files:Array = null;
         var fontFile:File = null;
         var ext:String = null;
         var info:Array = null;
         var m:Object = null;
         isMac = Capabilities.os.toLowerCase().indexOf("mac") != -1;
         if(isMac)
         {
            fontFolder = new File("/System/Library/Fonts");
            if(fontFolder.exists)
            {
               files = fontFolder.getDirectoryListing();
            }
            fontFolder = new File("/Library/Fonts");
            if(fontFolder.exists)
            {
               files = files.concat(fontFolder.getDirectoryListing());
            }
            fontFolder = File.userDirectory.resolvePath("Library/Fonts");
            if(fontFolder.exists)
            {
               files = files.concat(fontFolder.getDirectoryListing());
            }
         }
         else
         {
            fontFolder = new File("c:\\windows\\fonts\\");
            files = fontFolder.getDirectoryListing();
            fontFolder = File.userDirectory.resolvePath("appdata\\local\\microsoft\\windows\\fonts\\");
            if(fontFolder.exists)
            {
               files = files.concat(fontFolder.getDirectoryListing());
            }
         }
         var result:Array = [];
         var keys:Object = {};
         for each(fontFile in files)
         {
            if(fontFile.name.charAt(0) != ".")
            {
               ext = fontFile.extension;
               if(ext)
               {
                  ext = ext.toLowerCase();
                  if(ext == "ttf" || ext == "ttc" || ext == "otf" || ext == "dfont")
                  {
                     try
                     {
                        info = getFontFamily(fontFile);
                        if(info)
                        {
                           for each(m in info)
                           {
                              if(!keys[m.family])
                              {
                                 result.push(m);
                                 keys[m.family] = true;
                              }
                           }
                        }
                     }
                     catch(err:Error)
                     {
                        continue;
                     }
                  }
               }
            }
         }
         result.sort(sortFont);
         return result;
      }
      
      private static function sortFont(param1:Object, param2:Object) : int
      {
         var _loc3_:int = param2.matchLang - param1.matchLang;
         if(_loc3_ != 0)
         {
            return _loc3_;
         }
         return param1.family.localeCompare(param2.family);
      }
      
      public static function getFontFamily(param1:File) : Array
      {
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:FileStream = new FileStream();
         _loc2_.endian = Endian.BIG_ENDIAN;
         _loc2_.open(param1,FileMode.READ);
         var _loc3_:Array = [];
         var _loc4_:uint = _loc2_.readUnsignedInt();
         if(_loc4_ == 65536 || _loc4_ == 1330926671)
         {
            _loc5_ = readTTF(_loc2_,0);
            if(_loc5_ != null)
            {
               _loc3_.push(_loc5_);
            }
         }
         else if(_loc4_ == 1953784678)
         {
            _loc6_ = [];
            _loc2_.readInt();
            _loc7_ = _loc2_.readInt();
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc6_.push(_loc2_.readInt());
               _loc8_++;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc5_ = readTTF(_loc2_,_loc6_[_loc8_]);
               if(_loc5_ != null)
               {
                  _loc3_.push(_loc5_);
               }
               _loc8_++;
            }
         }
         _loc2_.close();
         return _loc3_;
      }
      
      public static function readTTF(param1:FileStream, param2:int) : Object
      {
         var _loc17_:String = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:String = null;
         var _loc25_:String = null;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.endian = Endian.BIG_ENDIAN;
         param1.position = param2;
         var _loc4_:uint = param1.readUnsignedInt();
         if(_loc4_ != 65536 && _loc4_ != 1330926671)
         {
            return null;
         }
         var _loc5_:int = param1.readShort();
         var _loc6_:int = -1;
         param1.position = param1.position + 6;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            param1.position = param2 + 12 + 16 * _loc7_;
            _loc17_ = param1.readMultiByte(4,"iso-8859-1");
            if(_loc17_ == "name")
            {
               param1.position = param1.position + 4;
               _loc6_ = param1.readUnsignedInt();
               break;
            }
            _loc7_++;
         }
         if(_loc6_ == -1)
         {
            return null;
         }
         var _loc8_:Array = [];
         param1.position = _loc6_;
         var _loc9_:int = param1.readUnsignedShort();
         var _loc10_:int = param1.readUnsignedShort();
         var _loc11_:int = param1.readUnsignedShort();
         var _loc12_:int = param1.position;
         var _loc13_:int = _loc6_ + _loc11_;
         _loc10_ = Math.min(_loc10_,int((_loc11_ - 6) / 12));
         var _loc14_:int = 0;
         while(_loc14_ < _loc10_)
         {
            param1.position = _loc12_ + _loc14_ * 12;
            _loc18_ = param1.readUnsignedShort();
            _loc19_ = param1.readUnsignedShort();
            _loc20_ = param1.readUnsignedShort();
            _loc21_ = param1.readUnsignedShort();
            _loc22_ = param1.readUnsignedShort();
            _loc23_ = param1.readUnsignedShort();
            if(_loc21_ == 1)
            {
               param1.position = _loc13_ + _loc23_;
               param1.readBytes(_loc3_,0,_loc22_);
               _loc3_.position = 0;
               _loc24_ = "utf8";
               if(_loc18_ == 0)
               {
                  _loc24_ = "unicodeFFFE";
               }
               else if(_loc18_ == 1)
               {
                  switch(_loc19_)
                  {
                     case 0:
                        _loc24_ = "utf8";
                        break;
                     case 1:
                        _loc24_ = "shift_jis";
                        break;
                     case 2:
                        _loc24_ = "big5";
                        break;
                     case 3:
                        _loc24_ = "korean";
                        break;
                     case 4:
                        _loc24_ = "arabic";
                        break;
                     case 5:
                        _loc24_ = "hebrew";
                        break;
                     case 6:
                        _loc24_ = "greek";
                        break;
                     case 7:
                        _loc24_ = "x-mac-cyrillic";
                        break;
                     case 24:
                        _loc24_ = "iso-8859-1";
                        break;
                     case 25:
                        _loc24_ = "gbk";
                  }
               }
               else if(_loc18_ == 3)
               {
                  switch(_loc19_)
                  {
                     case 0:
                        _loc24_ = "utf8";
                        break;
                     case 1:
                        _loc24_ = "unicodeFFFE";
                        break;
                     case 2:
                        _loc24_ = "shift_jis";
                        break;
                     case 3:
                        _loc24_ = "gbk";
                        break;
                     case 4:
                        _loc24_ = "big5";
                  }
               }
               _loc25_ = _loc3_.readMultiByte(_loc22_,_loc24_);
               _loc25_ = UtilsStr.trim(_loc25_);
               if(_loc25_.length)
               {
                  if(_loc25_.charAt(0) != ".")
                  {
                     _loc8_.push(translateLangId(_loc18_,_loc20_),_loc18_,_loc25_);
                  }
               }
            }
            _loc14_++;
         }
         var _loc15_:Object = {"matchLang":0};
         var _loc16_:int = _loc8_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc16_)
         {
            if(_loc8_[_loc7_] == 1033 || _loc8_[_loc7_] == 0)
            {
               if(_loc15_.family)
               {
                  if(isMac && _loc15_[_loc7_ + 1] == 1 || !isMac && _loc15_[_loc7_ + 1] != 1)
                  {
                     _loc15_.family = _loc8_[_loc7_ + 2];
                     _loc8_[_loc7_] = -1;
                  }
               }
               else
               {
                  _loc15_.family = _loc8_[_loc7_ + 2];
                  _loc8_[_loc7_] = -1;
               }
            }
            _loc7_ = _loc7_ + 3;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc16_)
         {
            if(_loc8_[_loc7_] >= 0)
            {
               if(matchLanguage(_loc8_[_loc7_]))
               {
                  _loc15_.matchLang = 1;
                  _loc15_.localeFamily = _loc8_[_loc7_ + 2];
               }
               else if(!_loc15_.localeFamily && _loc8_[_loc7_ + 2] != _loc15_.family)
               {
                  _loc15_.localeFamily = _loc8_[_loc7_ + 2];
               }
            }
            _loc7_ = _loc7_ + 3;
         }
         if(!_loc15_.family)
         {
            _loc15_.family = _loc15_.localeFamily;
         }
         if(!_loc15_.family)
         {
            return null;
         }
         return _loc15_;
      }
      
      private static function translateLangId(param1:int, param2:int) : int
      {
         if(param1 == 1)
         {
            switch(param2)
            {
               case 25:
                  return 2052;
               case 19:
                  return 1028;
               case 1:
                  return 1041;
               case 3:
                  return 1042;
               default:
                  return 1033;
            }
         }
         else
         {
            return param2;
         }
      }
      
      private static function matchLanguage(param1:int) : Boolean
      {
         var _loc2_:String = Capabilities.language;
         if(_loc2_ == "zh-CN" && param1 == 2052 || _loc2_ == "zh-TW" && param1 == 1028 || _loc2_ == "zh_HK" && param1 == 3076 || _loc2_ == "ja_JP" && param1 == 1041 || _loc2_ == "ko_KR" && param1 == 1042)
         {
            return true;
         }
         return false;
      }
   }
}

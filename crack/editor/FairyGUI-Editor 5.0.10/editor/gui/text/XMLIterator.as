package fairygui.editor.gui.text
{
   import fairygui.utils.UtilsStr;
   
   public class XMLIterator
   {
      
      public static var tagName:String;
      
      public static var tagType:int;
      
      public static var lastTagName:String;
      
      private static var source:String;
      
      private static var sourceLen:int;
      
      private static var parsePos:int;
      
      private static var tagPos:int;
      
      private static var tagLength:int;
      
      private static var lastTagEnd:int;
      
      private static var attrParsed:Boolean;
      
      private static var lowerCaseName:Boolean;
      
      private static var attributes:Object;
      
      public static const TAG_START:int = 0;
      
      public static const TAG_END:int = 1;
      
      public static const TAG_VOID:int = 2;
      
      public static const TAG_CDATA:int = 3;
      
      public static const TAG_COMMENT:int = 4;
      
      public static const TAG_INSTRUCTION:int = 5;
      
      private static const CDATA_START:String = "<![CDATA[";
      
      private static const CDATA_END:String = "]]>";
      
      private static const COMMENT_START:String = "<!--";
      
      private static const COMMENT_END:String = "-->";
       
      
      public function XMLIterator()
      {
         super();
      }
      
      public static function begin(param1:String, param2:Boolean = false) : void
      {
         XMLIterator.source = param1;
         XMLIterator.lowerCaseName = param2;
         sourceLen = param1.length;
         parsePos = 0;
         lastTagEnd = 0;
         tagPos = 0;
         tagLength = 0;
         tagName = null;
      }
      
      public static function nextTag() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = false;
         var _loc4_:* = false;
         var _loc5_:int = 0;
         tagType = TAG_START;
         lastTagEnd = parsePos;
         attrParsed = false;
         lastTagName = tagName;
         if((_loc1_ = source.indexOf("<",parsePos)) != -1)
         {
            parsePos = _loc1_;
            _loc1_++;
            if(_loc1_ != sourceLen)
            {
               _loc2_ = source.charCodeAt(_loc1_);
               if(_loc2_ == 33)
               {
                  if(sourceLen > _loc1_ + 7 && source.substr(_loc1_ - 1,9) == CDATA_START)
                  {
                     _loc1_ = source.indexOf(CDATA_END,_loc1_);
                     tagType = TAG_CDATA;
                     tagName = "";
                     tagPos = parsePos;
                     if(_loc1_ == -1)
                     {
                        tagLength = sourceLen - parsePos;
                     }
                     else
                     {
                        tagLength = _loc1_ + 3 - parsePos;
                     }
                     parsePos = parsePos + tagLength;
                     return true;
                  }
                  if(sourceLen > _loc1_ + 2 && source.substr(_loc1_ - 1,4) == COMMENT_START)
                  {
                     _loc1_ = source.indexOf(COMMENT_END,_loc1_);
                     tagType = TAG_COMMENT;
                     tagName = "";
                     tagPos = parsePos;
                     if(_loc1_ == -1)
                     {
                        tagLength = sourceLen - parsePos;
                     }
                     else
                     {
                        tagLength = _loc1_ + 3 - parsePos;
                     }
                     parsePos = parsePos + tagLength;
                     return true;
                  }
                  _loc1_++;
                  tagType = TAG_INSTRUCTION;
               }
               else if(_loc2_ == 47)
               {
                  _loc1_++;
                  tagType = TAG_END;
               }
               else if(_loc2_ == 63)
               {
                  _loc1_++;
                  tagType = TAG_INSTRUCTION;
               }
               while(_loc1_ < sourceLen)
               {
                  _loc2_ = source.charCodeAt(_loc1_);
                  if(_loc2_ == 32 || _loc2_ == 9 || _loc2_ == 10 || _loc2_ == 13 || _loc2_ == 62 || _loc2_ == 47)
                  {
                     break;
                  }
                  _loc1_++;
               }
               if(_loc1_ != sourceLen)
               {
                  if(source.charCodeAt(parsePos + 1) == 47)
                  {
                     tagName = source.substr(parsePos + 2,_loc1_ - parsePos - 2);
                  }
                  else
                  {
                     tagName = source.substr(parsePos + 1,_loc1_ - parsePos - 1);
                  }
                  if(lowerCaseName)
                  {
                     tagName = tagName.toLowerCase();
                  }
                  _loc3_ = false;
                  _loc4_ = false;
                  _loc5_ = -1;
                  while(_loc1_ < sourceLen)
                  {
                     _loc2_ = source.charCodeAt(_loc1_);
                     if(_loc2_ == 34)
                     {
                        if(!_loc3_)
                        {
                           _loc4_ = !_loc4_;
                        }
                     }
                     else if(_loc2_ == 39)
                     {
                        if(!_loc4_)
                        {
                           _loc3_ = !_loc3_;
                        }
                     }
                     if(_loc2_ == 62)
                     {
                        if(!(_loc3_ || _loc4_))
                        {
                           _loc5_ = -1;
                           break;
                        }
                        _loc5_ = _loc1_;
                     }
                     else if(_loc2_ == 60)
                     {
                        break;
                     }
                     _loc1_++;
                  }
                  if(_loc5_ != -1)
                  {
                     _loc1_ = _loc5_;
                  }
                  if(_loc1_ != sourceLen)
                  {
                     if(source.charCodeAt(_loc1_ - 1) == 47)
                     {
                        tagType = TAG_VOID;
                     }
                     tagPos = parsePos;
                     tagLength = _loc1_ + 1 - parsePos;
                     parsePos = parsePos + tagLength;
                     return true;
                  }
               }
            }
         }
         tagPos = sourceLen;
         tagLength = 0;
         tagName = null;
         return false;
      }
      
      public static function getTagSource() : String
      {
         return source.substr(tagPos,tagLength);
      }
      
      public static function getRawText(param1:Boolean = false) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(lastTagEnd == tagPos)
         {
            return "";
         }
         if(param1)
         {
            _loc2_ = lastTagEnd;
            while(_loc2_ < tagPos)
            {
               _loc3_ = source.charCodeAt(_loc2_);
               if(_loc3_ != 32 && _loc3_ != 9 && _loc3_ != 13 && _loc3_ != 10)
               {
                  break;
               }
               _loc2_++;
            }
            if(_loc2_ == tagPos)
            {
               return "";
            }
            return UtilsStr.trimRight(source.substr(_loc2_,tagPos - _loc2_));
         }
         return source.substr(lastTagEnd,tagPos - lastTagEnd);
      }
      
      public static function getText(param1:Boolean = false) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(lastTagEnd == tagPos)
         {
            return "";
         }
         if(param1)
         {
            _loc2_ = lastTagEnd;
            while(_loc2_ < tagPos)
            {
               _loc3_ = source.charCodeAt(_loc2_);
               if(_loc3_ != 32 && _loc3_ != 9 && _loc3_ != 13 && _loc3_ != 10)
               {
                  break;
               }
               _loc2_++;
            }
            if(_loc2_ == tagPos)
            {
               return "";
            }
            return UtilsStr.decodeXML(UtilsStr.trimRight(source.substr(_loc2_,tagPos - _loc2_)));
         }
         return UtilsStr.decodeXML(source.substr(lastTagEnd,tagPos - lastTagEnd));
      }
      
      public static function hasAttribute(param1:Boolean) : Boolean
      {
         if(!attrParsed)
         {
            attributes = {};
            parseAttributes(attributes);
            attrParsed = true;
         }
         return attributes.ContainsKey(param1);
      }
      
      public static function getAttribute(param1:String, param2:String = null) : String
      {
         if(!attrParsed)
         {
            attributes = {};
            parseAttributes(attributes);
            attrParsed = true;
         }
         var _loc3_:* = attributes[param1];
         if(_loc3_ != undefined)
         {
            return _loc3_.toString();
         }
         return param2;
      }
      
      public static function getAttributeInt(param1:String, param2:int = 0) : int
      {
         var _loc4_:Number = NaN;
         var _loc3_:String = getAttribute(param1);
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return param2;
         }
         if(_loc3_.charAt(_loc3_.length - 1) == "%")
         {
            _loc4_ = parseInt(_loc3_.substr(0,_loc3_.length - 1));
            if(isNaN(_loc4_))
            {
               return 0;
            }
            return _loc4_ / 100 * param2;
         }
         _loc4_ = parseInt(_loc3_);
         if(isNaN(_loc4_))
         {
            return 0;
         }
         return int(_loc4_);
      }
      
      public static function getAttributeFloat(param1:String, param2:Number = 0) : Number
      {
         var _loc4_:Number = NaN;
         var _loc3_:String = getAttribute(param1);
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return param2;
         }
         if(_loc3_.charAt(_loc3_.length - 1) == "%")
         {
            _loc4_ = parseFloat(_loc3_.substr(0,_loc3_.length - 1));
            if(isNaN(_loc4_))
            {
               return 0;
            }
            return _loc4_ / 100 * param2;
         }
         _loc4_ = parseFloat(_loc3_);
         if(isNaN(_loc4_))
         {
            return 0;
         }
         return _loc4_;
      }
      
      public static function getAttributeBool(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:String = getAttribute(param1);
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return param2;
         }
         return _loc3_ == "true";
      }
      
      public static function getAttributes() : Object
      {
         var _loc2_:* = null;
         var _loc1_:Object = {};
         if(attrParsed)
         {
            for(_loc2_ in attributes)
            {
               _loc1_[_loc2_] = attributes[_loc2_];
            }
         }
         else
         {
            parseAttributes(_loc1_);
         }
         return _loc1_;
      }
      
      private static function parseAttributes(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc5_:Boolean = false;
         var _loc7_:int = tagPos;
         var _loc8_:int = tagPos + tagLength;
         var _loc10_:String = "";
         if(_loc7_ < _loc8_ && source.charCodeAt(_loc7_) == 60)
         {
            while(_loc7_ < _loc8_)
            {
               _loc9_ = source.charCodeAt(_loc7_);
               if(_loc9_ == 32 || _loc9_ == 9 || _loc9_ == 10 || _loc9_ == 13 || _loc9_ == 62 || _loc9_ == 47)
               {
                  break;
               }
               _loc7_++;
            }
         }
         while(_loc7_ < _loc8_)
         {
            _loc9_ = source.charCodeAt(_loc7_);
            if(_loc9_ == 61)
            {
               _loc3_ = -1;
               _loc4_ = -1;
               _loc6_ = 0;
               _loc11_ = _loc7_ + 1;
               while(_loc11_ < _loc8_)
               {
                  _loc12_ = source.charCodeAt(_loc11_);
                  if(_loc12_ == 32 || _loc12_ == 9 && _loc12_ == 13 || _loc12_ == 10)
                  {
                     if(_loc3_ != -1 && _loc6_ == 0)
                     {
                        _loc4_ = _loc11_ - 1;
                        break;
                     }
                  }
                  else if(_loc12_ == 62)
                  {
                     if(_loc6_ == 0)
                     {
                        _loc4_ = _loc11_ - 1;
                        break;
                     }
                  }
                  else if(_loc12_ == 34)
                  {
                     if(_loc3_ != -1)
                     {
                        if(_loc6_ != 1)
                        {
                           _loc4_ = _loc11_ - 1;
                           break;
                        }
                     }
                     else
                     {
                        _loc6_ = 2;
                        _loc3_ = _loc11_ + 1;
                     }
                  }
                  else if(_loc12_ == 39)
                  {
                     if(_loc3_ != -1)
                     {
                        if(_loc6_ != 2)
                        {
                           _loc4_ = _loc11_ - 1;
                           break;
                        }
                     }
                     else
                     {
                        _loc6_ = 1;
                        _loc3_ = _loc11_ + 1;
                     }
                  }
                  else if(_loc3_ == -1)
                  {
                     _loc3_ = _loc11_;
                  }
                  _loc11_++;
               }
               if(_loc3_ != -1 && _loc4_ != -1)
               {
                  _loc2_ = _loc10_;
                  if(lowerCaseName)
                  {
                     _loc2_ = _loc2_.toLowerCase();
                  }
                  _loc10_ = "";
                  param1[_loc2_] = UtilsStr.decodeXML(source.substr(_loc3_,_loc4_ - _loc3_ + 1));
                  _loc7_ = _loc4_ + 1;
               }
               else
               {
                  break;
               }
            }
            else if(_loc9_ != 32 && _loc9_ != 9 && _loc9_ != 13 && _loc9_ != 10)
            {
               if(_loc5_ || _loc9_ == 47 || _loc9_ == 62)
               {
                  if(_loc10_.length > 0)
                  {
                     _loc2_ = _loc10_;
                     if(lowerCaseName)
                     {
                        _loc2_ = _loc2_.toLowerCase();
                     }
                     param1[_loc2_] = "";
                     _loc10_ = "";
                  }
                  _loc5_ = false;
               }
               if(_loc9_ != 47 && _loc9_ != 62)
               {
                  _loc10_ = _loc10_ + String.fromCharCode(_loc9_);
               }
            }
            else if(_loc10_.length > 0)
            {
               _loc5_ = true;
            }
            _loc7_++;
         }
      }
   }
}

package fairygui.text
{
   import fairygui.utils.ToolSet;
   
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
         var _loc3_:* = 0;
         var _loc1_:int = 0;
         var _loc2_:* = false;
         var _loc5_:* = 0;
         tagType = 0;
         lastTagEnd = parsePos;
         attrParsed = false;
         lastTagName = tagName;
         _loc3_ = int(source.indexOf("<",parsePos));
         if(source.indexOf("<",parsePos) != -1)
         {
            parsePos = _loc3_;
            _loc3_++;
            if(_loc3_ != sourceLen)
            {
               _loc1_ = source.charCodeAt(_loc3_);
               if(_loc1_ == 33)
               {
                  if(sourceLen > _loc3_ + 7 && source.substr(_loc3_ - 1,9) == "<![CDATA[")
                  {
                     _loc3_ = int(source.indexOf("]]>",_loc3_));
                     tagType = 3;
                     tagName = "";
                     tagPos = parsePos;
                     if(_loc3_ == -1)
                     {
                        tagLength = sourceLen - parsePos;
                     }
                     else
                     {
                        tagLength = _loc3_ + 3 - parsePos;
                     }
                     parsePos = parsePos + tagLength;
                     return true;
                  }
                  if(sourceLen > _loc3_ + 2 && source.substr(_loc3_ - 1,4) == "<!--")
                  {
                     _loc3_ = int(source.indexOf("-->",_loc3_));
                     tagType = 4;
                     tagName = "";
                     tagPos = parsePos;
                     if(_loc3_ == -1)
                     {
                        tagLength = sourceLen - parsePos;
                     }
                     else
                     {
                        tagLength = _loc3_ + 3 - parsePos;
                     }
                     parsePos = parsePos + tagLength;
                     return true;
                  }
                  _loc3_++;
                  tagType = 5;
               }
               else if(_loc1_ == 47)
               {
                  _loc3_++;
                  tagType = 1;
               }
               else if(_loc1_ == 63)
               {
                  _loc3_++;
                  tagType = 5;
               }
               while(_loc3_ < sourceLen)
               {
                  _loc1_ = source.charCodeAt(_loc3_);
                  if(!(_loc1_ == 32 || _loc1_ == 9 || _loc1_ == 10 || _loc1_ == 13 || _loc1_ == 62 || _loc1_ == 47))
                  {
                     _loc3_++;
                     continue;
                  }
                  break;
               }
               if(_loc3_ != sourceLen)
               {
                  if(source.charCodeAt(parsePos + 1) == 47)
                  {
                     tagName = source.substr(parsePos + 2,_loc3_ - parsePos - 2);
                  }
                  else
                  {
                     tagName = source.substr(parsePos + 1,_loc3_ - parsePos - 1);
                  }
                  if(lowerCaseName)
                  {
                     tagName = tagName.toLowerCase();
                  }
                  _loc2_ = false;
                  var _loc4_:* = false;
                  _loc5_ = -1;
                  while(_loc3_ < sourceLen)
                  {
                     _loc1_ = source.charCodeAt(_loc3_);
                     if(_loc1_ == 34)
                     {
                        if(!_loc2_)
                        {
                           _loc4_ = !_loc4_;
                        }
                     }
                     else if(_loc1_ == 39)
                     {
                        if(!_loc4_)
                        {
                           _loc2_ = !_loc2_;
                        }
                     }
                     if(_loc1_ == 62)
                     {
                        if(!(_loc2_ || _loc4_))
                        {
                           _loc5_ = -1;
                           break;
                        }
                        _loc5_ = _loc3_;
                     }
                     else if(_loc1_ == 60)
                     {
                        break;
                     }
                     _loc3_++;
                  }
                  if(_loc5_ != -1)
                  {
                     _loc3_ = _loc5_;
                  }
                  if(_loc3_ != sourceLen)
                  {
                     if(source.charCodeAt(_loc3_ - 1) == 47)
                     {
                        tagType = 2;
                     }
                     tagPos = parsePos;
                     tagLength = _loc3_ + 1 - parsePos;
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
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(lastTagEnd == tagPos)
         {
            return "";
         }
         if(param1)
         {
            _loc3_ = lastTagEnd;
            while(_loc3_ < tagPos)
            {
               _loc2_ = source.charCodeAt(_loc3_);
               if(!(_loc2_ != 32 && _loc2_ != 9 && _loc2_ != 13 && _loc2_ != 10))
               {
                  _loc3_++;
                  continue;
               }
               break;
            }
            if(_loc3_ == tagPos)
            {
               return "";
            }
            return ToolSet.trimRight(source.substr(_loc3_,tagPos - _loc3_));
         }
         return source.substr(lastTagEnd,tagPos - lastTagEnd);
      }
      
      public static function getText(param1:Boolean = false) : String
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(lastTagEnd == tagPos)
         {
            return "";
         }
         if(param1)
         {
            _loc3_ = lastTagEnd;
            while(_loc3_ < tagPos)
            {
               _loc2_ = source.charCodeAt(_loc3_);
               if(!(_loc2_ != 32 && _loc2_ != 9 && _loc2_ != 13 && _loc2_ != 10))
               {
                  _loc3_++;
                  continue;
               }
               break;
            }
            if(_loc3_ == tagPos)
            {
               return "";
            }
            return ToolSet.decodeXML(ToolSet.trimRight(source.substr(_loc3_,tagPos - _loc3_)));
         }
         return ToolSet.decodeXML(source.substr(lastTagEnd,tagPos - lastTagEnd));
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
         var _loc3_:Number = NaN;
         var _loc4_:String = getAttribute(param1);
         if(_loc4_ == null || _loc4_.length == 0)
         {
            return param2;
         }
         if(_loc4_.charAt(_loc4_.length - 1) == "%")
         {
            _loc3_ = parseInt(_loc4_.substr(0,_loc4_.length - 1));
            if(isNaN(_loc3_))
            {
               return 0;
            }
            return _loc3_ / 100 * param2;
         }
         _loc3_ = parseInt(_loc4_);
         if(isNaN(_loc3_))
         {
            return 0;
         }
         return int(_loc3_);
      }
      
      public static function getAttributeFloat(param1:String, param2:Number = 0) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:String = getAttribute(param1);
         if(_loc4_ == null || _loc4_.length == 0)
         {
            return param2;
         }
         if(_loc4_.charAt(_loc4_.length - 1) == "%")
         {
            _loc3_ = parseFloat(_loc4_.substr(0,_loc4_.length - 1));
            if(isNaN(_loc3_))
            {
               return 0;
            }
            return _loc3_ / 100 * param2;
         }
         _loc3_ = parseFloat(_loc4_);
         if(isNaN(_loc3_))
         {
            return 0;
         }
         return _loc3_;
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
         var _loc1_:Object = {};
         if(attrParsed)
         {
            var _loc4_:int = 0;
            var _loc3_:* = attributes;
            for(var _loc2_ in attributes)
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
         var _loc11_:* = null;
         var _loc2_:* = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc12_:int = 0;
         var _loc5_:Boolean = false;
         var _loc7_:int = tagPos;
         var _loc10_:int = tagPos + tagLength;
         var _loc9_:String = "";
         if(_loc7_ < _loc10_ && source.charCodeAt(_loc7_) == 60)
         {
            while(_loc7_ < _loc10_)
            {
               _loc4_ = source.charCodeAt(_loc7_);
               if(!(_loc4_ == 32 || _loc4_ == 9 || _loc4_ == 10 || _loc4_ == 13 || _loc4_ == 62 || _loc4_ == 47))
               {
                  _loc7_++;
                  continue;
               }
               break;
            }
         }
         while(_loc7_ < _loc10_)
         {
            _loc4_ = source.charCodeAt(_loc7_);
            if(_loc4_ == 61)
            {
               _loc2_ = -1;
               _loc6_ = -1;
               _loc3_ = 0;
               _loc8_ = _loc7_ + 1;
               while(_loc8_ < _loc10_)
               {
                  _loc12_ = source.charCodeAt(_loc8_);
                  if(_loc12_ == 32 || _loc12_ == 9 && _loc12_ == 13 || _loc12_ == 10)
                  {
                     if(_loc2_ != -1 && _loc3_ == 0)
                     {
                        _loc6_ = _loc8_ - 1;
                        break;
                     }
                  }
                  else if(_loc12_ == 62)
                  {
                     if(_loc3_ == 0)
                     {
                        _loc6_ = _loc8_ - 1;
                        break;
                     }
                  }
                  else if(_loc12_ == 34)
                  {
                     if(_loc2_ != -1)
                     {
                        if(_loc3_ != 1)
                        {
                           _loc6_ = _loc8_ - 1;
                           break;
                        }
                     }
                     else
                     {
                        _loc3_ = 2;
                        _loc2_ = int(_loc8_ + 1);
                     }
                  }
                  else if(_loc12_ == 39)
                  {
                     if(_loc2_ != -1)
                     {
                        if(_loc3_ != 2)
                        {
                           _loc6_ = _loc8_ - 1;
                           break;
                        }
                     }
                     else
                     {
                        _loc3_ = 1;
                        _loc2_ = int(_loc8_ + 1);
                     }
                  }
                  else if(_loc2_ == -1)
                  {
                     _loc2_ = _loc8_;
                  }
                  _loc8_++;
               }
               if(_loc2_ != -1 && _loc6_ != -1)
               {
                  _loc11_ = _loc9_;
                  if(lowerCaseName)
                  {
                     _loc11_ = _loc11_.toLowerCase();
                  }
                  _loc9_ = "";
                  param1[_loc11_] = ToolSet.decodeXML(source.substr(_loc2_,_loc6_ - _loc2_ + 1));
                  _loc7_ = _loc6_ + 1;
               }
               else
               {
                  break;
               }
            }
            else if(_loc4_ != 32 && _loc4_ != 9 && _loc4_ != 13 && _loc4_ != 10)
            {
               if(_loc5_ || _loc4_ == 47 || _loc4_ == 62)
               {
                  if(_loc9_.length > 0)
                  {
                     _loc11_ = _loc9_;
                     if(lowerCaseName)
                     {
                        _loc11_ = _loc11_.toLowerCase();
                     }
                     param1[_loc11_] = "";
                     _loc9_ = "";
                  }
                  _loc5_ = false;
               }
               if(_loc4_ != 47 && _loc4_ != 62)
               {
                  _loc9_ = _loc9_ + String.fromCharCode(_loc4_);
               }
            }
            else if(_loc9_.length > 0)
            {
               _loc5_ = true;
            }
            _loc7_++;
         }
      }
   }
}

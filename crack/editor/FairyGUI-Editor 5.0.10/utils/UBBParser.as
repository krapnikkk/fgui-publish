package fairygui.utils
{
   public class UBBParser
   {
      
      public static var inst:UBBParser = new UBBParser();
       
      
      private var _text:String;
      
      private var _readPos:int;
      
      protected var _handlers:Object;
      
      public var smallFontSize:int = 12;
      
      public var normalFontSize:int = 14;
      
      public var largeFontSize:int = 16;
      
      public var defaultImgWidth:int = 0;
      
      public var defaultImgHeight:int = 0;
      
      public var maxFontSize:int = 0;
      
      public var unrecognizedTags:Object;
      
      public function UBBParser()
      {
         unrecognizedTags = {};
         super();
         _handlers = {};
         _handlers["url"] = onTag_URL;
         _handlers["img"] = onTag_IMG;
         _handlers["b"] = onTag_Simple;
         _handlers["i"] = onTag_Simple;
         _handlers["u"] = onTag_Simple;
         _handlers["sup"] = onTag_Simple;
         _handlers["sub"] = onTag_Simple;
         _handlers["color"] = onTag_COLOR;
         _handlers["font"] = onTag_FONT;
         _handlers["size"] = onTag_SIZE;
         _handlers["align"] = onTag_ALIGN;
      }
      
      protected function onTag_URL(param1:String, param2:Boolean, param3:String) : String
      {
         var _loc4_:* = null;
         if(!param2)
         {
            if(param3 != null)
            {
               return "<a href=\"" + param3 + "\" target=\"_blank\">";
            }
            _loc4_ = getTagText();
            return "<a href=\"" + _loc4_ + "\" target=\"_blank\">";
         }
         return "</a>";
      }
      
      protected function onTag_IMG(param1:String, param2:Boolean, param3:String) : String
      {
         var _loc4_:* = null;
         if(!param2)
         {
            _loc4_ = getTagText(true);
            if(!_loc4_)
            {
               return null;
            }
            if(defaultImgWidth)
            {
               return "<img src=\"" + _loc4_ + "\" width=\"" + defaultImgWidth + "\" height=\"" + defaultImgHeight + "\"/>";
            }
            return "<img src=\"" + _loc4_ + "\"/>";
         }
         return null;
      }
      
      protected function onTag_Simple(param1:String, param2:Boolean, param3:String) : String
      {
         return !!param2?"</" + param1 + ">":"<" + param1 + ">";
      }
      
      protected function onTag_COLOR(param1:String, param2:Boolean, param3:String) : String
      {
         if(!param2)
         {
            return "<font color=\"" + param3 + "\">";
         }
         return "</font>";
      }
      
      protected function onTag_FONT(param1:String, param2:Boolean, param3:String) : String
      {
         if(!param2)
         {
            return "<font face=\"" + param3 + "\">";
         }
         return "</font>";
      }
      
      protected function onTag_ALIGN(param1:String, param2:Boolean, param3:String) : String
      {
         if(!param2)
         {
            return "<p align=\"" + param3 + "\">";
         }
         return "</p>";
      }
      
      protected function onTag_SIZE(param1:String, param2:Boolean, param3:String) : String
      {
         var _loc4_:int = 0;
         if(!param2)
         {
            if(param3 == "normal")
            {
               _loc4_ = normalFontSize;
            }
            else if(param3 == "small")
            {
               _loc4_ = smallFontSize;
            }
            else if(param3 == "large")
            {
               _loc4_ = largeFontSize;
            }
            else if(param3.length && param3.charAt(0) == "+")
            {
               _loc4_ = smallFontSize + int(param3.substr(1));
            }
            else if(param3.length && param3.charAt(0) == "-")
            {
               _loc4_ = smallFontSize - int(param3.substr(1));
            }
            else
            {
               _loc4_ = parseInt(param3);
            }
            if(_loc4_ > maxFontSize)
            {
               maxFontSize = _loc4_;
            }
            return "<font size=\"" + _loc4_ + "\">";
         }
         return "</font>";
      }
      
      protected function getTagText(param1:Boolean = false) : String
      {
         var _loc4_:int = 0;
         var _loc3_:int = _readPos;
         var _loc2_:* = "";
         while(true)
         {
            _loc4_ = _text.indexOf("[",_loc3_);
            if(_text.indexOf("[",_loc3_) != -1)
            {
               if(_text.charCodeAt(_loc4_ - 1) == 92)
               {
                  _loc2_ = _loc2_ + _text.substring(_loc3_,_loc4_ - 1);
                  _loc2_ = _loc2_ + "[";
                  _loc3_ = _loc4_ + 1;
                  continue;
               }
               _loc2_ = _loc2_ + _text.substring(_loc3_,_loc4_);
               break;
            }
            break;
         }
         if(_loc4_ == -1)
         {
            return null;
         }
         if(param1)
         {
            _readPos = _loc4_;
         }
         return _loc2_;
      }
      
      public function parse(param1:String, param2:Boolean = false) : String
      {
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc7_:* = false;
         var _loc11_:* = null;
         var _loc10_:* = null;
         var _loc8_:* = null;
         var _loc4_:* = null;
         _text = param1;
         maxFontSize = 0;
         var _loc5_:* = 0;
         var _loc3_:* = "";
         while(true)
         {
            _loc6_ = _text.indexOf("[",_loc5_);
            if(_text.indexOf("[",_loc5_) != -1)
            {
               if(_loc6_ > 0 && _text.charCodeAt(_loc6_ - 1) == 92)
               {
                  _loc3_ = _loc3_ + _text.substring(_loc5_,_loc6_ - 1);
                  _loc3_ = _loc3_ + "[";
                  _loc5_ = int(_loc6_ + 1);
                  continue;
               }
               _loc3_ = _loc3_ + _text.substring(_loc5_,_loc6_);
               _loc5_ = _loc6_;
               _loc6_ = _text.indexOf("]",_loc5_);
               if(_loc6_ != -1)
               {
                  _loc7_ = _text.charAt(_loc5_ + 1) == "/";
                  _loc10_ = _text.substring(!!_loc7_?_loc5_ + 2:Number(_loc5_ + 1),_loc6_);
                  _readPos = _loc6_ + 1;
                  _loc11_ = null;
                  _loc8_ = null;
                  _loc9_ = _loc10_.indexOf("=");
                  if(_loc9_ != -1)
                  {
                     _loc11_ = _loc10_.substring(_loc9_ + 1);
                     _loc10_ = _loc10_.substring(0,_loc9_);
                  }
                  _loc10_ = _loc10_.toLowerCase();
                  _loc4_ = _handlers[_loc10_];
                  if(_loc4_ != null)
                  {
                     _loc8_ = _loc4_(_loc10_,_loc7_,_loc11_);
                     if(_loc8_ != null && !param2)
                     {
                        _loc3_ = _loc3_ + _loc8_;
                     }
                  }
                  else if(!unrecognizedTags[_loc10_])
                  {
                     _loc3_ = _loc3_ + _text.substring(_loc5_,_readPos);
                  }
                  _loc5_ = int(_readPos);
                  continue;
               }
               break;
            }
            break;
         }
         if(_loc5_ < _text.length)
         {
            _loc3_ = _loc3_ + _text.substr(_loc5_);
         }
         _text = null;
         return _loc3_;
      }
   }
}

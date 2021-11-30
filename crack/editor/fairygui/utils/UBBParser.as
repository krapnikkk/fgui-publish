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
      
      public function UBBParser()
      {
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
      
      protected function onTag_SIZE(param1:String, param2:Boolean, param3:String) : String
      {
         if(!param2)
         {
            if(param3 == "normal")
            {
               param3 = "" + normalFontSize;
            }
            else if(param3 == "small")
            {
               param3 = "" + smallFontSize;
            }
            else if(param3 == "large")
            {
               param3 = "" + largeFontSize;
            }
            else if(param3.length && param3.charAt(0) == "+")
            {
               param3 = "" + (smallFontSize + int(param3.substr(1)));
            }
            else if(param3.length && param3.charAt(0) == "-")
            {
               param3 = "" + (smallFontSize - int(param3.substr(1)));
            }
            return "<font size=\"" + param3 + "\">";
         }
         return "</font>";
      }
      
      protected function getTagText(param1:Boolean = false) : String
      {
         var _loc3_:int = _text.indexOf("[",_readPos);
         if(_loc3_ == -1)
         {
            return null;
         }
         var _loc2_:String = _text.substring(_readPos,_loc3_);
         if(param1)
         {
            _readPos = _loc3_;
         }
         return _loc2_;
      }
      
      public function parse(param1:String) : String
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc9_:* = false;
         var _loc8_:* = null;
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = null;
         _text = param1;
         var _loc2_:* = 0;
         while(true)
         {
            _loc4_ = _text.indexOf("[",_loc2_);
            if(_text.indexOf("[",_loc2_) != -1)
            {
               _loc2_ = _loc4_;
               _loc4_ = _text.indexOf("]",_loc2_);
               if(_loc4_ != -1)
               {
                  _loc9_ = _text.charAt(_loc2_ + 1) == "/";
                  _loc5_ = _text.substring(!!_loc9_?_loc2_ + 2:_loc2_ + 1,_loc4_);
                  _loc4_++;
                  _readPos = _loc4_;
                  _loc8_ = null;
                  _loc7_ = null;
                  _loc3_ = _loc5_.indexOf("=");
                  if(_loc3_ != -1)
                  {
                     _loc8_ = _loc5_.substring(_loc3_ + 1);
                     _loc5_ = _loc5_.substring(0,_loc3_);
                  }
                  _loc5_ = _loc5_.toLowerCase();
                  _loc6_ = _handlers[_loc5_];
                  if(_loc6_ != null)
                  {
                     _loc7_ = _loc6_(_loc5_,_loc9_,_loc8_);
                     if(_loc7_ == null)
                     {
                        _loc7_ = "";
                     }
                     _text = _text.substring(0,_loc2_) + _loc7_ + _text.substring(_readPos);
                  }
                  else
                  {
                     _loc2_ = _loc4_;
                  }
                  continue;
               }
               break;
            }
            break;
         }
         return _text;
      }
   }
}

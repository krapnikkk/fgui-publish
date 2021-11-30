package fairygui.text
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class HtmlText
   {
       
      
      public var parsedText:String;
      
      public var elements:Vector.<HtmlElement>;
      
      public function HtmlText(param1:String)
      {
         var _loc2_:Boolean = false;
         var _loc4_:* = null;
         var _loc3_:* = null;
         super();
         elements = new Vector.<HtmlElement>();
         try
         {
            param1 = param1.replace(/\r\n/g,"\n");
            param1 = param1.replace(/\r/g,"\n");
            _loc2_ = XML.ignoreWhitespace;
            XML.ignoreWhitespace = false;
            _loc4_ = new XML("<dummy>" + param1 + "</dummy>");
            XML.ignoreWhitespace = _loc2_;
            _loc3_ = _loc4_.children();
            parsedText = "";
            parseXML(_loc3_);
            return;
         }
         catch(e:*)
         {
            parsedText = param1;
            elements.length = 0;
            trace(e);
            return;
         }
      }
      
      public function appendTo(param1:TextField) : void
      {
         var _loc3_:int = 0;
         var _loc2_:* = null;
         var _loc4_:int = param1.text.length;
         param1.replaceText(_loc4_,_loc4_,parsedText);
         _loc3_ = elements.length - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = elements[_loc3_];
            param1.setTextFormat(_loc2_.textformat,_loc4_ + _loc2_.start,_loc4_ + _loc2_.end + 1);
            _loc3_--;
         }
      }
      
      private function parseXML(param1:XMLList) : void
      {
         var _loc7_:* = null;
         var _loc9_:* = null;
         var _loc3_:* = null;
         var _loc8_:* = null;
         var _loc6_:int = 0;
         var _loc2_:* = null;
         var _loc10_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = param1.length();
         _loc10_ = 0;
         while(_loc10_ < _loc5_)
         {
            _loc3_ = param1[_loc10_];
            _loc7_ = _loc3_.name();
            if(_loc7_ == "font")
            {
               _loc8_ = new TextFormat();
               _loc9_ = _loc3_.attribute("size");
               if(_loc9_.length())
               {
                  _loc8_.size = int(_loc9_[0]);
               }
               _loc9_ = _loc3_.attribute("color");
               if(_loc9_.length())
               {
                  _loc8_.color = parseInt(_loc9_[0].substr(1),16);
               }
               _loc9_ = _loc3_.attribute("italic");
               if(_loc9_.length())
               {
                  _loc8_.italic = _loc9_[0] == "true";
               }
               _loc9_ = _loc3_.attribute("underline");
               if(_loc9_.length())
               {
                  _loc8_.underline = _loc9_[0] == "true";
               }
               _loc9_ = _loc3_.attribute("face");
               if(_loc9_.length())
               {
                  _loc8_.font = _loc9_[0];
               }
               _loc6_ = parsedText.length;
               if(_loc3_.hasSimpleContent())
               {
                  parsedText = parsedText + _loc3_.text();
               }
               else
               {
                  parseXML(_loc3_.children());
               }
               if(parsedText.length > _loc6_)
               {
                  _loc2_ = new HtmlElement();
                  _loc2_.start = _loc6_;
                  _loc2_.end = parsedText.length - 1;
                  _loc2_.textformat = _loc8_;
                  elements.push(_loc2_);
               }
            }
            else if(_loc7_ == "a")
            {
               _loc8_ = new TextFormat();
               _loc8_.underline = true;
               _loc8_.url = "#";
               _loc6_ = parsedText.length;
               if(_loc3_.hasSimpleContent())
               {
                  parsedText = parsedText + _loc3_.text();
               }
               else
               {
                  parseXML(_loc3_.children());
               }
               if(parsedText.length > _loc6_)
               {
                  _loc2_ = new HtmlElement();
                  _loc2_.type = 1;
                  _loc2_.start = _loc6_;
                  _loc2_.end = parsedText.length - 1;
                  _loc2_.textformat = _loc8_;
                  _loc2_.id = _loc3_.attribute("id").toString();
                  _loc2_.href = _loc3_.attribute("href").toString();
                  _loc2_.target = _loc3_.attribute("target").toString();
                  elements.push(_loc2_);
               }
            }
            else if(_loc7_ == "img")
            {
               _loc6_ = parsedText.length;
               _loc8_ = new TextFormat();
               parsedText = parsedText + "　";
               _loc2_ = new HtmlElement();
               _loc2_.type = 2;
               _loc2_.id = _loc3_.attribute("id").toString();
               _loc2_.src = _loc3_.attribute("src").toString();
               _loc2_.width = int(_loc3_.attribute("width").toString());
               _loc2_.height = int(_loc3_.attribute("height").toString());
               _loc2_.start = _loc6_;
               _loc2_.end = parsedText.length - 1;
               _loc2_.textformat = _loc8_;
               elements.push(_loc2_);
            }
            else if(_loc7_ == "b")
            {
               _loc8_ = new TextFormat();
               _loc8_.bold = true;
               _loc6_ = parsedText.length;
               if(_loc3_.hasSimpleContent())
               {
                  parsedText = parsedText + _loc3_.text();
               }
               else
               {
                  parseXML(_loc3_.children());
               }
               if(parsedText.length > _loc6_)
               {
                  _loc2_ = new HtmlElement();
                  _loc2_.start = _loc6_;
                  _loc2_.end = parsedText.length - 1;
                  _loc2_.textformat = _loc8_;
                  elements.push(_loc2_);
               }
            }
            else if(_loc7_ == "i")
            {
               _loc8_ = new TextFormat();
               _loc8_.italic = true;
               _loc6_ = parsedText.length;
               if(_loc3_.hasSimpleContent())
               {
                  parsedText = parsedText + _loc3_.text();
               }
               else
               {
                  parseXML(_loc3_.children());
               }
               if(parsedText.length > _loc6_)
               {
                  _loc2_ = new HtmlElement();
                  _loc2_.start = _loc6_;
                  _loc2_.end = parsedText.length - 1;
                  _loc2_.textformat = _loc8_;
                  elements.push(_loc2_);
               }
            }
            else if(_loc7_ == "u")
            {
               _loc8_ = new TextFormat();
               _loc8_.underline = true;
               _loc6_ = parsedText.length;
               if(_loc3_.hasSimpleContent())
               {
                  parsedText = parsedText + _loc3_.text();
               }
               else
               {
                  parseXML(_loc3_.children());
               }
               if(parsedText.length > _loc6_)
               {
                  _loc2_ = new HtmlElement();
                  _loc2_.start = _loc6_;
                  _loc2_.end = parsedText.length - 1;
                  _loc2_.textformat = _loc8_;
                  elements.push(_loc2_);
               }
            }
            else if(_loc7_ == "br")
            {
               parsedText = parsedText + "\n";
            }
            else if(_loc3_.nodeKind() == "text")
            {
               _loc4_ = _loc3_.toString();
               parsedText = parsedText + _loc4_;
            }
            else
            {
               parseXML(_loc3_.children());
            }
            _loc10_++;
         }
      }
   }
}

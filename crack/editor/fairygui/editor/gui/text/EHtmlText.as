package fairygui.editor.gui.text
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class EHtmlText
   {
       
      
      public var parsedText:String;
      
      public var elements:Vector.<EHtmlElement>;
      
      public function EHtmlText(param1:String)
      {
         var _loc3_:Boolean = false;
         var _loc5_:XML = null;
         var _loc4_:XMLList = null;
         var _loc2_:* = param1;
         super();
         this.elements = new Vector.<EHtmlElement>();
         try
         {
            _loc2_ = _loc2_.replace(/\r\n/g,"\n");
            _loc2_ = _loc2_.replace(/\r/g,"\n");
            _loc3_ = XML.ignoreWhitespace;
            XML.ignoreWhitespace = false;
            _loc5_ = new XML("<dummy>" + _loc2_ + "</dummy>");
            XML.ignoreWhitespace = _loc3_;
            _loc4_ = _loc5_.children();
            this.parsedText = "";
            this.parseXML(_loc4_);
            return;
         }
         catch(e:*)
         {
            parsedText = _loc2_;
            elements.length = 0;
            return;
         }
      }
      
      public function appendTo(param1:TextField) : void
      {
         var _loc3_:EHtmlElement = null;
         var _loc4_:int = param1.text.length;
         param1.replaceText(_loc4_,_loc4_,this.parsedText);
         var _loc2_:int = this.elements.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = this.elements[_loc2_];
            param1.setTextFormat(_loc3_.textformat,_loc4_ + _loc3_.start,_loc4_ + _loc3_.end + 1);
            _loc2_--;
         }
      }
      
      private function parseXML(param1:XMLList) : void
      {
         var _loc8_:String = null;
         var _loc9_:XMLList = null;
         var _loc2_:XML = null;
         var _loc4_:TextFormat = null;
         var _loc7_:int = 0;
         var _loc6_:EHtmlElement = null;
         var _loc3_:String = null;
         var _loc10_:int = param1.length();
         var _loc5_:int = 0;
         while(_loc5_ < _loc10_)
         {
            _loc2_ = param1[_loc5_];
            _loc8_ = _loc2_.name();
            if(_loc8_ == "font")
            {
               _loc4_ = new TextFormat();
               _loc9_ = _loc2_.attribute("size");
               if(_loc9_.length())
               {
                  _loc4_.size = int(_loc9_[0]);
               }
               _loc9_ = _loc2_.attribute("color");
               if(_loc9_.length())
               {
                  _loc4_.color = parseInt(_loc9_[0].substr(1),16);
               }
               _loc9_ = _loc2_.attribute("italic");
               if(_loc9_.length())
               {
                  _loc4_.italic = _loc9_[0] == "true";
               }
               _loc9_ = _loc2_.attribute("underline");
               if(_loc9_.length())
               {
                  _loc4_.underline = _loc9_[0] == "true";
               }
               _loc9_ = _loc2_.attribute("face");
               if(_loc9_.length())
               {
                  _loc4_.font = _loc9_[0];
               }
               _loc7_ = this.parsedText.length;
               if(_loc2_.hasSimpleContent())
               {
                  this.parsedText = this.parsedText + _loc2_.text();
               }
               else
               {
                  this.parseXML(_loc2_.children());
               }
               if(this.parsedText.length > _loc7_)
               {
                  _loc6_ = new EHtmlElement();
                  _loc6_.start = _loc7_;
                  _loc6_.end = this.parsedText.length - 1;
                  _loc6_.textformat = _loc4_;
                  this.elements.push(_loc6_);
               }
            }
            else if(_loc8_ == "a")
            {
               _loc4_ = new TextFormat();
               _loc4_.underline = true;
               _loc4_.url = "#";
               _loc7_ = this.parsedText.length;
               if(_loc2_.hasSimpleContent())
               {
                  this.parsedText = this.parsedText + _loc2_.text();
               }
               else
               {
                  this.parseXML(_loc2_.children());
               }
               if(this.parsedText.length > _loc7_)
               {
                  _loc6_ = new EHtmlElement();
                  _loc6_.type = 1;
                  _loc6_.start = _loc7_;
                  _loc6_.end = this.parsedText.length - 1;
                  _loc6_.textformat = _loc4_;
                  _loc6_.id = _loc2_.attribute("id").toString();
                  _loc6_.href = _loc2_.attribute("href").toString();
                  _loc6_.target = _loc2_.attribute("target").toString();
                  this.elements.push(_loc6_);
               }
            }
            else if(_loc8_ == "img")
            {
               _loc7_ = this.parsedText.length;
               _loc4_ = new TextFormat();
               this.parsedText = this.parsedText + "　";
               _loc6_ = new EHtmlElement();
               _loc6_.type = 2;
               _loc6_.id = _loc2_.attribute("id").toString();
               _loc6_.src = _loc2_.attribute("src").toString();
               _loc6_.width = int(_loc2_.attribute("width").toString());
               _loc6_.height = int(_loc2_.attribute("height").toString());
               _loc6_.start = _loc7_;
               _loc6_.end = this.parsedText.length - 1;
               _loc6_.textformat = _loc4_;
               this.elements.push(_loc6_);
            }
            else if(_loc8_ == "b")
            {
               _loc4_ = new TextFormat();
               _loc4_.bold = true;
               _loc7_ = this.parsedText.length;
               if(_loc2_.hasSimpleContent())
               {
                  this.parsedText = this.parsedText + _loc2_.text();
               }
               else
               {
                  this.parseXML(_loc2_.children());
               }
               if(this.parsedText.length > _loc7_)
               {
                  _loc6_ = new EHtmlElement();
                  _loc6_.start = _loc7_;
                  _loc6_.end = this.parsedText.length - 1;
                  _loc6_.textformat = _loc4_;
                  this.elements.push(_loc6_);
               }
            }
            else if(_loc8_ == "i")
            {
               _loc4_ = new TextFormat();
               _loc4_.italic = true;
               _loc7_ = this.parsedText.length;
               if(_loc2_.hasSimpleContent())
               {
                  this.parsedText = this.parsedText + _loc2_.text();
               }
               else
               {
                  this.parseXML(_loc2_.children());
               }
               if(this.parsedText.length > _loc7_)
               {
                  _loc6_ = new EHtmlElement();
                  _loc6_.start = _loc7_;
                  _loc6_.end = this.parsedText.length - 1;
                  _loc6_.textformat = _loc4_;
                  this.elements.push(_loc6_);
               }
            }
            else if(_loc8_ == "u")
            {
               _loc4_ = new TextFormat();
               _loc4_.underline = true;
               _loc7_ = this.parsedText.length;
               if(_loc2_.hasSimpleContent())
               {
                  this.parsedText = this.parsedText + _loc2_.text();
               }
               else
               {
                  this.parseXML(_loc2_.children());
               }
               if(this.parsedText.length > _loc7_)
               {
                  _loc6_ = new EHtmlElement();
                  _loc6_.start = _loc7_;
                  _loc6_.end = this.parsedText.length - 1;
                  _loc6_.textformat = _loc4_;
                  this.elements.push(_loc6_);
               }
            }
            else if(_loc8_ == "br")
            {
               this.parsedText = this.parsedText + "\n";
            }
            else if(_loc2_.nodeKind() == "text")
            {
               _loc3_ = _loc2_.toString();
               this.parsedText = this.parsedText + _loc3_;
            }
            else
            {
               this.parseXML(_loc2_.children());
            }
            _loc5_++;
         }
      }
   }
}

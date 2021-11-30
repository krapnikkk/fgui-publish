package fairygui.text
{
   import fairygui.PackageItem;
   import fairygui.UIPackage;
   import fairygui.utils.CharSize;
   import fairygui.utils.FontUtils;
   import fairygui.utils.ToolSet;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class RichTextField extends Sprite
   {
      
      public static var objectFactory:IRichTextObjectFactory = new RichTextObjectFactory();
       
      
      private var _textField:TextField;
      
      private var _ALinkFormat:TextFormat;
      
      private var _AHoverFormat:TextFormat;
      
      private var _defaultTextFormat:TextFormat;
      
      private var _lineInfo:Array;
      
      private var _linkButtonCache:Vector.<LinkButton>;
      
      private var _nodeCache:Vector.<HtmlNode>;
      
      private var _needUpdateNodePos:Boolean;
      
      public function RichTextField()
      {
         super();
         this.mouseEnabled = false;
         _linkButtonCache = new Vector.<LinkButton>();
         _nodeCache = new Vector.<HtmlNode>();
         _ALinkFormat = new TextFormat();
         _ALinkFormat.underline = true;
         _AHoverFormat = new TextFormat();
         _AHoverFormat.underline = true;
         _lineInfo = [];
         _textField = new TextField();
         _textField.wordWrap = true;
         _textField.selectable = false;
         addChild(_textField);
      }
      
      override public function set width(param1:Number) : void
      {
         _textField.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         if(_textField.height != param1)
         {
            _textField.height = param1;
            adjustNodes();
         }
      }
      
      override public function get width() : Number
      {
         return _textField.width;
      }
      
      override public function get height() : Number
      {
         return _textField.height;
      }
      
      public function get nativeTextField() : TextField
      {
         return _textField;
      }
      
      public function get text() : String
      {
         return _textField.text;
      }
      
      public function set text(param1:String) : void
      {
         clear();
         if(param1.length)
         {
            appendText(param1);
         }
         else
         {
            fixTextSize();
         }
      }
      
      public function set defaultTextFormat(param1:TextFormat) : void
      {
         _defaultTextFormat = param1;
         if(_defaultTextFormat)
         {
            if(_defaultTextFormat.underline == null)
            {
               _defaultTextFormat.underline = false;
            }
            if(_defaultTextFormat.letterSpacing == null)
            {
               _defaultTextFormat.letterSpacing = 0;
            }
            if(_defaultTextFormat.kerning == null)
            {
               _defaultTextFormat.kerning = false;
            }
         }
         _textField.embedFonts = FontUtils.isEmbeddedFont(_defaultTextFormat);
         _textField.defaultTextFormat = _defaultTextFormat;
      }
      
      public function get defaultTextFormat() : TextFormat
      {
         return _textField.defaultTextFormat;
      }
      
      public function get ALinkFormat() : TextFormat
      {
         return _ALinkFormat;
      }
      
      public function set ALinkFormat(param1:TextFormat) : void
      {
         _ALinkFormat = param1;
      }
      
      public function get AHoverFormat() : TextFormat
      {
         return _AHoverFormat;
      }
      
      public function set AHoverFormat(param1:TextFormat) : void
      {
         _AHoverFormat = param1;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         _textField.selectable = param1;
         _textField.mouseEnabled = param1;
      }
      
      public function get selectable() : Boolean
      {
         return _textField.selectable;
      }
      
      public function get textHeight() : Number
      {
         return _textField.textHeight;
      }
      
      public function get textWidth() : Number
      {
         return _textField.textWidth;
      }
      
      public function get numLines() : int
      {
         return _textField.numLines;
      }
      
      public function getLinkCount() : int
      {
         var _loc6_:int = 0;
         var _loc3_:* = undefined;
         var _loc1_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = _lineInfo.length;
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            _loc3_ = _lineInfo[_loc6_];
            if(_loc3_)
            {
               _loc1_ = _loc3_.length;
               _loc4_ = 0;
               while(_loc4_ < _loc1_)
               {
                  if(_loc3_[_loc4_].element.type == 1)
                  {
                     _loc5_++;
                  }
                  _loc4_++;
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function getImageCount() : int
      {
         var _loc6_:int = 0;
         var _loc3_:* = undefined;
         var _loc1_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = _lineInfo.length;
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            _loc3_ = _lineInfo[_loc6_];
            if(_loc3_)
            {
               _loc1_ = _loc3_.length;
               _loc4_ = 0;
               while(_loc4_ < _loc1_)
               {
                  if(_loc3_[_loc4_].element.type == 2)
                  {
                     _loc5_++;
                  }
                  _loc4_++;
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function getObjectRect(param1:String, param2:DisplayObject) : Rectangle
      {
         var _loc8_:int = 0;
         var _loc6_:* = undefined;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:* = null;
         var _loc5_:int = _lineInfo.length;
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = _lineInfo[_loc8_];
            if(_loc6_)
            {
               _loc4_ = _loc6_.length;
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  _loc3_ = _loc6_[_loc7_];
                  if(_loc3_.element.id == param1 && _loc3_.displayObject != null)
                  {
                     return _loc3_.displayObject.getRect(param2);
                  }
                  _loc7_++;
               }
            }
            _loc8_++;
         }
         return null;
      }
      
      public function getLinkRectByOrder(param1:int, param2:DisplayObject) : Rectangle
      {
         var _loc8_:int = 0;
         var _loc6_:* = undefined;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:* = null;
         var _loc5_:int = _lineInfo.length;
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = _lineInfo[_loc8_];
            if(_loc6_)
            {
               _loc4_ = _loc6_.length;
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  _loc3_ = _loc6_[_loc7_];
                  if(_loc3_.element.type == 1 && _loc3_.displayObject != null && param1 == 0)
                  {
                     return _loc3_.displayObject.getRect(param2);
                  }
                  _loc7_++;
               }
            }
            _loc8_++;
         }
         return null;
      }
      
      public function getLinkRectByHref(param1:String, param2:DisplayObject) : Rectangle
      {
         var _loc8_:int = 0;
         var _loc6_:* = undefined;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:* = null;
         var _loc5_:int = _lineInfo.length;
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = _lineInfo[_loc8_];
            if(_loc6_)
            {
               _loc4_ = _loc6_.length;
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  _loc3_ = _loc6_[_loc7_];
                  if(_loc3_.element.type == 1 && _loc3_.displayObject != null && _loc3_.element.href == param1)
                  {
                     return _loc3_.displayObject.getRect(param2);
                  }
                  _loc7_++;
               }
            }
            _loc8_++;
         }
         return null;
      }
      
      public function getLinkHref(param1:int) : String
      {
         var _loc7_:int = 0;
         var _loc5_:* = undefined;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:* = null;
         var _loc4_:int = _lineInfo.length;
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = _lineInfo[_loc7_];
            if(_loc5_)
            {
               _loc3_ = _loc5_.length;
               _loc6_ = 0;
               while(_loc6_ < _loc3_)
               {
                  _loc2_ = _loc5_[_loc6_];
                  if(_loc2_.element.type == 1 && param1 == 0)
                  {
                     return _loc2_.element.href;
                  }
                  _loc6_++;
               }
            }
            _loc7_++;
         }
         return null;
      }
      
      public function appendText(param1:String) : void
      {
         appendParsedText(new HtmlText(param1));
      }
      
      public function appendParsedText(param1:HtmlText) : void
      {
         var _loc9_:int = 0;
         var _loc4_:* = null;
         var _loc8_:int = 0;
         var _loc7_:* = null;
         if(_defaultTextFormat)
         {
            _textField.defaultTextFormat = _defaultTextFormat;
         }
         var _loc6_:int = _textField.text.length;
         var _loc3_:String = param1.parsedText;
         _textField.replaceText(_loc6_,_loc6_,_loc3_);
         var _loc5_:int = param1.elements.length;
         _loc9_ = _loc5_ - 1;
         while(_loc9_ >= 0)
         {
            _loc4_ = param1.elements[_loc9_];
            if(_loc4_.type == 1)
            {
               if(_ALinkFormat)
               {
                  _textField.setTextFormat(_ALinkFormat,_loc6_ + _loc4_.start,_loc6_ + _loc4_.end + 1);
               }
            }
            else if(_loc4_.type == 2)
            {
               _loc8_ = 20;
               var _loc2_:int = 20;
               if(ToolSet.startsWith(_loc4_.src,"ui://"))
               {
                  _loc7_ = UIPackage.getItemByURL(_loc4_.src);
                  if(_loc7_ != null)
                  {
                     _loc8_ = _loc7_.width;
                     _loc2_ = _loc7_.height;
                  }
               }
               if(_loc4_.width == 0)
               {
                  _loc4_.realWidth = _loc8_;
               }
               else
               {
                  _loc4_.realWidth = _loc4_.width;
               }
               if(_loc4_.height == 0)
               {
                  _loc4_.realHeight = _loc2_;
               }
               else
               {
                  _loc4_.realHeight = _loc4_.height;
               }
               _loc4_.textformat.font = !!_textField.embedFonts?_defaultTextFormat.font:CharSize.PLACEHOLDER_FONT;
               _loc4_.textformat.size = _loc4_.realHeight + 2;
               _loc4_.textformat.underline = false;
               _loc4_.textformat.letterSpacing = _loc4_.realWidth + 4 - CharSize.getHolderWidth(_loc4_.textformat.font,_loc4_.realHeight + 2);
               _textField.setTextFormat(_loc4_.textformat,_loc6_ + _loc4_.start,_loc6_ + _loc4_.end + 1);
            }
            else
            {
               _textField.setTextFormat(_loc4_.textformat,_loc6_ + _loc4_.start,_loc6_ + _loc4_.end + 1);
            }
            _loc9_--;
         }
         fixTextSize();
         _loc9_ = 0;
         while(_loc9_ < _loc5_)
         {
            _loc4_ = param1.elements[_loc9_];
            if(_loc4_.type == 1)
            {
               addLink(_loc6_,_loc4_);
            }
            else if(_loc4_.type == 2)
            {
               addImage(_loc6_,_loc4_);
            }
            _loc9_++;
         }
         if(this.stage == null && !_needUpdateNodePos)
         {
            _needUpdateNodePos = true;
            this.addEventListener("addedToStage",__addedToStage,false,0,true);
         }
      }
      
      private function __addedToStage(param1:Event) : void
      {
         if(!_needUpdateNodePos)
         {
            return;
         }
         adjustNodes();
         _needUpdateNodePos = false;
      }
      
      public function deleteLines(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         var _loc10_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:* = 0;
         var _loc4_:* = null;
         var _loc8_:* = undefined;
         var _loc3_:Boolean = false;
         if(param1 + param2 > _textField.numLines)
         {
            param2 = _textField.numLines - param1;
            if(param2 <= 0)
            {
               return;
            }
         }
         var _loc7_:int = _textField.getLineOffset(param1);
         if(param1 == _textField.numLines - 1)
         {
            _loc6_ = _textField.text.length;
         }
         else if(param2 != 1)
         {
            _loc10_ = param1 + param2 - 1;
            _loc6_ = _textField.getLineOffset(_loc10_) + _textField.getLineLength(_loc10_);
         }
         else
         {
            _loc6_ = _textField.getLineLength(param1);
         }
         var _loc5_:int = _loc6_ - _loc7_;
         if(_loc7_ != 0 && _textField.text.charCodeAt(_loc7_ - 1) != 13)
         {
            _textField.replaceText(_loc7_,_loc6_,"\r");
            _loc5_--;
         }
         else
         {
            _textField.replaceText(_loc7_,_loc6_,"");
         }
         _loc11_ = 0;
         while(_loc11_ < param2)
         {
            _loc8_ = _lineInfo[param1 + _loc11_];
            if(_loc8_)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc8_.length)
               {
                  _loc4_ = _loc8_[_loc9_];
                  destroyNode(_loc4_);
                  _loc9_++;
               }
            }
            _loc11_++;
         }
         _lineInfo.splice(param1,param2);
         _loc11_ = param1;
         while(_loc11_ < _lineInfo.length)
         {
            _loc8_ = _lineInfo[_loc11_];
            if(_loc8_)
            {
               _loc3_ = isLineVisible(_loc11_);
               _loc9_ = 0;
               while(_loc9_ < _loc8_.length)
               {
                  _loc4_ = _loc8_[_loc9_];
                  _loc4_.charStart = _loc4_.charStart - _loc5_;
                  _loc4_.charEnd = _loc4_.charEnd - _loc5_;
                  _loc4_.lineIndex = _loc4_.lineIndex - param2;
                  _loc4_.posUpdated = false;
                  if(_loc3_)
                  {
                     showNode(_loc4_);
                  }
                  else
                  {
                     hideNode(_loc4_);
                  }
                  _loc9_++;
               }
            }
            _loc11_++;
         }
      }
      
      private function adjustNodes() : void
      {
         var _loc6_:int = 0;
         var _loc4_:* = null;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:* = null;
         var _loc2_:int = _lineInfo.length;
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            _loc4_ = _lineInfo[_loc6_];
            if(_loc4_)
            {
               _loc3_ = _loc4_.length;
               if(isLineVisible(_loc6_))
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc3_)
                  {
                     _loc1_ = _loc4_[_loc5_];
                     if(_needUpdateNodePos)
                     {
                        _loc1_.posUpdated = false;
                     }
                     showNode(_loc1_);
                     _loc5_++;
                  }
               }
               else
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc3_)
                  {
                     _loc1_ = _loc4_[_loc5_];
                     if(_needUpdateNodePos)
                     {
                        _loc1_.posUpdated = false;
                     }
                     hideNode(_loc1_);
                     _loc5_++;
                  }
               }
            }
            _loc6_++;
         }
      }
      
      private function clear() : void
      {
         var _loc5_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc1_:* = null;
         var _loc2_:int = _lineInfo.length;
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = _lineInfo[_loc5_];
            if(_loc3_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc1_ = _loc3_[_loc4_];
                  destroyNode(_loc1_);
                  _loc4_++;
               }
            }
            _loc5_++;
         }
         _lineInfo.length = 0;
         _textField.htmlText = "";
         if(_defaultTextFormat)
         {
            _textField.defaultTextFormat = _defaultTextFormat;
         }
         _needUpdateNodePos = false;
      }
      
      private function fixTextSize() : void
      {
         _textField.textWidth;
      }
      
      private function isLineVisible(param1:int) : Boolean
      {
         return true;
      }
      
      private function createNode(param1:int) : HtmlNode
      {
         var _loc2_:* = null;
         var _loc3_:Vector.<HtmlNode> = _lineInfo[param1];
         if(!_loc3_)
         {
            _loc3_ = new Vector.<HtmlNode>();
            _lineInfo[param1] = _loc3_;
         }
         if(_nodeCache.length)
         {
            _loc2_ = _nodeCache.pop();
         }
         else
         {
            _loc2_ = new HtmlNode();
         }
         _loc2_.lineIndex = param1;
         _loc2_.nodeIndex = _loc3_.length;
         _loc3_.push(_loc2_);
         return _loc2_;
      }
      
      private function destroyNode(param1:HtmlNode) : void
      {
         if(param1.displayObject != null)
         {
            if(param1.displayObject.parent != null)
            {
               removeChild(param1.displayObject);
            }
            if(param1.element.type == 1)
            {
               _linkButtonCache.push(param1.displayObject);
            }
            else if(param1.element.type == 2)
            {
               objectFactory.freeObject(param1.displayObject);
            }
         }
         param1.reset();
         _nodeCache.push(param1);
      }
      
      private function addLink(param1:int, param2:HtmlElement) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = param1 + param2.start;
         var _loc7_:int = param1 + param2.end;
         var _loc6_:int = _textField.getLineIndexOfChar(_loc4_);
         var _loc8_:int = _textField.getLineIndexOfChar(_loc7_);
         if(_loc6_ == _loc8_)
         {
            addLinkButton(_loc6_,_loc4_,_loc7_,param2);
         }
         else
         {
            _loc3_ = _textField.getLineOffset(_loc6_);
            addLinkButton(_loc6_,_loc4_,_loc3_ + _textField.getLineLength(_loc6_) - 1,param2);
            _loc5_ = _loc6_ + 1;
            while(_loc5_ < _loc8_)
            {
               _loc3_ = _textField.getLineOffset(_loc5_);
               addLinkButton(_loc5_,_loc3_,_loc3_ + _textField.getLineLength(_loc5_) - 1,param2);
               _loc5_++;
            }
            addLinkButton(_loc8_,_textField.getLineOffset(_loc8_),_loc7_,param2);
         }
      }
      
      private function addLinkButton(param1:int, param2:int, param3:int, param4:HtmlElement) : void
      {
         param2 = skipLeftCR(param2,param3);
         param3 = skipRightCR(param2,param3);
         var _loc5_:HtmlNode = createNode(param1);
         _loc5_.charStart = param2;
         _loc5_.charEnd = param3;
         _loc5_.element = param4;
         if(isLineVisible(param1))
         {
            showNode(_loc5_);
         }
      }
      
      private function addImage(param1:int, param2:HtmlElement) : void
      {
         var _loc4_:int = param1 + param2.start;
         var _loc5_:int = _textField.getLineIndexOfChar(_loc4_);
         var _loc3_:HtmlNode = createNode(_loc5_);
         _loc3_.charStart = _loc4_;
         _loc3_.charEnd = _loc4_;
         _loc3_.element = param2;
         if(isLineVisible(_loc5_))
         {
            showNode(_loc3_);
         }
      }
      
      private function showNode(param1:HtmlNode) : void
      {
         var _loc7_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc2_:int = 0;
         var _loc8_:int = 0;
         var _loc5_:* = null;
         var _loc4_:HtmlElement = param1.element;
         if(_loc4_.type == 1)
         {
            if(param1.displayObject == null)
            {
               if(_linkButtonCache.length)
               {
                  _loc7_ = _linkButtonCache.pop();
               }
               else
               {
                  _loc7_ = new LinkButton();
                  _loc7_.addEventListener("rollOver",__linkRollOver);
                  _loc7_.addEventListener("rollOut",__linkRollOut);
                  _loc7_.addEventListener("click",__linkClick);
               }
               _loc7_.owner = param1;
               param1.displayObject = _loc7_;
            }
            if(!param1.posUpdated)
            {
               _loc3_ = _textField.getCharBoundaries(param1.charStart);
               if(_loc3_ == null)
               {
                  return;
               }
               _loc6_ = _textField.getCharBoundaries(param1.charEnd);
               if(_loc6_ == null)
               {
                  return;
               }
               _loc2_ = _loc6_.right - _loc3_.left;
               if(_loc3_.left + _loc2_ > _textField.width - 2)
               {
                  _loc2_ = _textField.width - _loc3_.left - 2;
               }
               _loc8_ = Math.max(_loc3_.height,_loc6_.height);
               param1.displayObject.x = _loc3_.left;
               LinkButton(param1.displayObject).setSize(_loc2_,_loc8_);
               if(_loc3_.top < _loc6_.top)
               {
                  param1.topY = 0;
               }
               else
               {
                  param1.topY = _loc6_.top - _loc3_.top;
               }
               param1.posUpdated = true;
            }
            else
            {
               _loc3_ = _textField.getCharBoundaries(param1.charStart);
               if(_loc3_ == null)
               {
                  return;
               }
            }
            param1.displayObject.y = _loc3_.top + param1.topY;
            if(param1.displayObject.parent == null)
            {
               addChild(param1.displayObject);
            }
         }
         else if(_loc4_.type == 2)
         {
            if(param1.displayObject == null)
            {
               if(objectFactory != null)
               {
                  param1.displayObject = objectFactory.createObject(_loc4_.src,_loc4_.width,_loc4_.height);
               }
               if(param1.displayObject == null)
               {
                  return;
               }
            }
            _loc3_ = _textField.getCharBoundaries(param1.charStart);
            if(_loc3_ == null)
            {
               return;
            }
            _loc5_ = _textField.getLineMetrics(param1.lineIndex);
            if(_loc5_ == null)
            {
               return;
            }
            param1.displayObject.x = _loc3_.left + 2;
            if(_loc4_.realHeight < _loc5_.ascent)
            {
               param1.displayObject.y = _loc3_.top + _loc5_.ascent - _loc4_.realHeight;
            }
            else
            {
               param1.displayObject.y = _loc3_.bottom - _loc4_.realHeight;
            }
            if(param1.displayObject.x + param1.displayObject.width < _textField.width - 2)
            {
               if(param1.displayObject.parent == null)
               {
                  addChildAt(param1.displayObject,this.numChildren);
               }
            }
         }
      }
      
      private function hideNode(param1:HtmlNode) : void
      {
         if(param1.displayObject && param1.displayObject.parent)
         {
            removeChild(param1.displayObject);
         }
      }
      
      private function skipLeftCR(param1:int, param2:int) : int
      {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc3_:String = _textField.text;
         _loc5_ = param1;
         while(_loc5_ < param2)
         {
            _loc4_ = _loc3_.charAt(_loc5_);
            if(!(_loc4_ != "\r" && _loc4_ != "\n"))
            {
               _loc5_++;
               continue;
            }
            break;
         }
         return _loc5_;
      }
      
      private function skipRightCR(param1:int, param2:int) : int
      {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc3_:String = _textField.text;
         _loc5_ = param2;
         while(_loc5_ > param1)
         {
            _loc4_ = _loc3_.charAt(_loc5_);
            if(!(_loc4_ != "\r" && _loc4_ != "\n"))
            {
               _loc5_--;
               continue;
            }
            break;
         }
         return _loc5_;
      }
      
      private function findLinkStart(param1:HtmlNode, param2:Boolean) : int
      {
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc7_:int = param1.nodeIndex;
         var _loc6_:int = param1.lineIndex;
         _loc7_--;
         var _loc4_:Vector.<HtmlNode> = _lineInfo[_loc6_];
         while(true)
         {
            if(_loc7_ < 0)
            {
               if(_loc5_ != param1)
               {
                  _loc5_ = param1;
                  _loc6_--;
                  _loc4_ = _lineInfo[_loc6_];
                  if(_loc4_)
                  {
                     _loc7_ = _loc4_.length - 1;
                  }
                  break;
               }
               break;
            }
            _loc3_ = _loc4_[_loc7_];
            if(_loc3_.element.type == 1)
            {
               if(_loc3_.element == param1.element)
               {
                  param1 = _loc3_;
                  continue;
               }
               break;
            }
         }
         return param1.charStart;
      }
      
      private function findLinkEnd(param1:HtmlNode, param2:Boolean) : int
      {
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc7_:int = param1.nodeIndex;
         var _loc6_:int = param1.lineIndex;
         _loc7_++;
         var _loc4_:Vector.<HtmlNode> = _lineInfo[_loc6_];
         if(!_loc4_)
         {
            return param1.charEnd;
         }
         while(true)
         {
            if(_loc7_ > _loc4_.length - 1)
            {
               if(_loc5_ != param1)
               {
                  _loc5_ = param1;
                  _loc6_++;
                  _loc4_ = _lineInfo[_loc6_];
                  if(_loc4_)
                  {
                     _loc7_ = 0;
                  }
                  break;
               }
               break;
            }
            _loc3_ = _loc4_[_loc7_];
            if(_loc3_.element.type == 1)
            {
               if(_loc3_.element == param1.element)
               {
                  param1 = _loc3_;
                  continue;
               }
               break;
            }
         }
         return param1.charEnd;
      }
      
      private function __linkRollOver(param1:Event) : void
      {
         var _loc2_:HtmlNode = LinkButton(param1.currentTarget).owner;
         var _loc4_:int = findLinkStart(_loc2_,true);
         var _loc3_:int = findLinkEnd(_loc2_,true) + 1;
         if(_AHoverFormat)
         {
            _textField.setTextFormat(_AHoverFormat,_loc4_,_loc3_);
         }
      }
      
      private function __linkRollOut(param1:Event) : void
      {
         var _loc2_:HtmlNode = LinkButton(param1.currentTarget).owner;
         if(_loc2_.lineIndex == -1)
         {
            return;
         }
         if(_AHoverFormat && _ALinkFormat)
         {
            _textField.setTextFormat(_ALinkFormat,findLinkStart(_loc2_,false),findLinkEnd(_loc2_,false) + 1);
         }
      }
      
      private function __linkClick(param1:Event) : void
      {
         param1.stopPropagation();
         var _loc2_:HtmlNode = LinkButton(param1.currentTarget).owner;
         var _loc3_:String = _loc2_.element.href;
         var _loc4_:int = _loc3_.indexOf("event:");
         if(_loc4_ == 0)
         {
            this.dispatchEvent(new TextEvent("link",true,false,_loc3_.substring(6)));
         }
         else
         {
            navigateToURL(new URLRequest(_loc3_),_loc2_.element.target);
         }
      }
   }
}

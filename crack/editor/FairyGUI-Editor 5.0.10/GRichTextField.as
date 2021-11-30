package fairygui
{
   import fairygui.display.UISprite;
   import fairygui.text.HtmlElement;
   import fairygui.text.HtmlNode;
   import fairygui.text.IRichTextObjectFactory;
   import fairygui.text.LinkButton;
   import fairygui.text.RichTextObjectFactory;
   import fairygui.text.XMLIterator;
   import fairygui.utils.CharSize;
   import fairygui.utils.ToolSet;
   import fairygui.utils.UBBParser;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class GRichTextField extends GTextField
   {
      
      public static var objectFactory:IRichTextObjectFactory = new RichTextObjectFactory();
      
      private static var _nodeCache:Vector.<HtmlNode> = new Vector.<HtmlNode>();
      
      private static var _elementCache:Vector.<HtmlElement> = new Vector.<HtmlElement>();
       
      
      private var _ALinkFormat:TextFormat;
      
      private var _AHoverFormat:TextFormat;
      
      private var _elements:Vector.<HtmlElement>;
      
      private var _nodes:Vector.<HtmlNode>;
      
      private var _objectsContainer:Sprite;
      
      private var _linkButtonCache:Vector.<LinkButton>;
      
      public function GRichTextField()
      {
         super();
         _ALinkFormat = new TextFormat();
         _ALinkFormat.underline = true;
         _AHoverFormat = new TextFormat();
         _AHoverFormat.underline = true;
         _elements = new Vector.<HtmlElement>();
         _nodes = new Vector.<HtmlNode>();
         _linkButtonCache = new Vector.<LinkButton>();
      }
      
      public function get ALinkFormat() : TextFormat
      {
         return _ALinkFormat;
      }
      
      public function set ALinkFormat(param1:TextFormat) : void
      {
         _ALinkFormat = param1;
         render();
      }
      
      public function get AHoverFormat() : TextFormat
      {
         return _AHoverFormat;
      }
      
      public function set AHoverFormat(param1:TextFormat) : void
      {
         _AHoverFormat = param1;
      }
      
      override protected function createDisplayObject() : void
      {
         super.createDisplayObject();
         _textField.mouseEnabled = true;
         _objectsContainer = new Sprite();
         _objectsContainer.mouseEnabled = false;
         var _loc1_:UISprite = new UISprite(this);
         _loc1_.mouseEnabled = false;
         _loc1_.addChild(_textField);
         _loc1_.addChild(_objectsContainer);
         setDisplayObject(_loc1_);
      }
      
      override protected function updateTextFieldText(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         destroyNodes();
         clearElements();
         _textField.htmlText = "";
         _textField.defaultTextFormat = _textFormat;
         if(!_text.length)
         {
            return;
         }
         if(_ubbEnabled)
         {
            param1 = UBBParser.inst.parse(param1);
         }
         _textField.text = parseHtml(param1);
         var _loc2_:int = _elements.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _elements[_loc3_];
            if(_loc4_.textFormat && _loc4_.end > _loc4_.start)
            {
               _textField.setTextFormat(_loc4_.textFormat,_loc4_.start,_loc4_.end);
            }
            _loc3_++;
         }
         createNodes();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         adjustNodes();
      }
      
      override protected function doAlign() : void
      {
         super.doAlign();
         _objectsContainer.y = _yOffset;
         if(_objectsContainer.stage == null)
         {
            _objectsContainer.addEventListener("addedToStage",onAddedToStage,false,0,true);
         }
         else
         {
            adjustNodes();
         }
      }
      
      override public function dispose() : void
      {
         destroyNodes();
         super.dispose();
      }
      
      private function parseHtml(param1:String) : String
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc11_:* = null;
         var _loc8_:int = 0;
         var _loc6_:* = null;
         var _loc9_:int = 0;
         var _loc3_:Boolean = false;
         var _loc7_:* = "";
         var _loc10_:Boolean = false;
         XMLIterator.begin(param1,true);
         while(XMLIterator.nextTag())
         {
            if(_loc9_ == 0)
            {
               _loc2_ = XMLIterator.getText(_loc3_);
               if(_loc2_.length > 0)
               {
                  if(_loc10_ && _loc2_.charCodeAt(0) == 10)
                  {
                     _loc7_ = _loc7_ + _loc2_.substr(1);
                  }
                  else
                  {
                     _loc7_ = _loc7_ + _loc2_;
                  }
               }
            }
            _loc10_ = false;
            var _loc12_:* = XMLIterator.tagName;
            if("b" !== _loc12_)
            {
               if("i" !== _loc12_)
               {
                  if("u" !== _loc12_)
                  {
                     if("font" !== _loc12_)
                     {
                        if("br" !== _loc12_)
                        {
                           if("img" !== _loc12_)
                           {
                              if("a" !== _loc12_)
                              {
                                 if("p" !== _loc12_)
                                 {
                                    if("ui" !== _loc12_)
                                    {
                                       if("div" !== _loc12_)
                                       {
                                          if("li" !== _loc12_)
                                          {
                                             if("html" !== _loc12_)
                                             {
                                                if("body" !== _loc12_)
                                                {
                                                   if("input" !== _loc12_)
                                                   {
                                                      if("select" !== _loc12_)
                                                      {
                                                         if("head" !== _loc12_)
                                                         {
                                                            if("style" !== _loc12_)
                                                            {
                                                               if("script" !== _loc12_)
                                                               {
                                                                  if("form" !== _loc12_)
                                                                  {
                                                                     continue;
                                                                  }
                                                               }
                                                               addr611:
                                                               if(XMLIterator.tagType == 0)
                                                               {
                                                                  _loc9_++;
                                                               }
                                                               else if(XMLIterator.tagType == 1)
                                                               {
                                                                  _loc9_--;
                                                               }
                                                               continue;
                                                            }
                                                            addr610:
                                                            §§goto(addr611);
                                                         }
                                                         addr609:
                                                         §§goto(addr610);
                                                      }
                                                      addr608:
                                                      §§goto(addr609);
                                                   }
                                                   §§goto(addr608);
                                                }
                                             }
                                             _loc3_ = true;
                                             continue;
                                          }
                                       }
                                       addr565:
                                       if(XMLIterator.tagType == 0)
                                       {
                                          if(_loc7_.length && _loc7_.charCodeAt(_loc7_.length - 1) != 10)
                                          {
                                             _loc7_ = _loc7_ + "\n";
                                          }
                                       }
                                       else if(XMLIterator.tagType == 1)
                                       {
                                          _loc7_ = _loc7_ + "\n";
                                          _loc10_ = true;
                                       }
                                       continue;
                                    }
                                    §§goto(addr565);
                                 }
                                 else
                                 {
                                    if(XMLIterator.tagType == 0)
                                    {
                                       if(_loc7_.length && _loc7_.charCodeAt(_loc7_.length - 1) != 10)
                                       {
                                          _loc7_ = _loc7_ + "\n";
                                       }
                                       _loc2_ = XMLIterator.getAttribute("align");
                                       if(_loc2_ == "center" || _loc2_ == "right")
                                       {
                                          _loc11_ = createElement();
                                          _loc11_.tag = XMLIterator.tagName;
                                          _loc11_.start = _loc7_.length;
                                          _loc11_.end = -1;
                                          _loc4_ = new TextFormat();
                                          _loc4_.align = _loc2_;
                                          _loc11_.textFormat = _loc4_;
                                       }
                                    }
                                    else if(XMLIterator.tagType == 1)
                                    {
                                       _loc7_ = _loc7_ + "\n";
                                       _loc10_ = true;
                                       _loc11_ = findStartTag(XMLIterator.tagName);
                                       if(_loc11_)
                                       {
                                          _loc11_.end = _loc7_.length;
                                       }
                                    }
                                    continue;
                                 }
                              }
                              else
                              {
                                 if(XMLIterator.tagType == 0)
                                 {
                                    _loc11_ = createElement();
                                    _loc11_.tag = XMLIterator.tagName;
                                    _loc11_.start = _loc7_.length;
                                    _loc11_.end = -1;
                                    _loc11_.text = XMLIterator.getAttribute("href");
                                    _loc11_.textFormat = _ALinkFormat;
                                 }
                                 else if(XMLIterator.tagType == 1)
                                 {
                                    _loc11_ = findStartTag(XMLIterator.tagName);
                                    if(_loc11_)
                                    {
                                       _loc11_.end = _loc7_.length;
                                    }
                                 }
                                 continue;
                              }
                           }
                           else
                           {
                              if(XMLIterator.tagType == 0 || XMLIterator.tagType == 2)
                              {
                                 _loc2_ = XMLIterator.getAttribute("src");
                                 if(_loc2_)
                                 {
                                    _loc11_ = createElement();
                                    _loc11_.tag = XMLIterator.tagName;
                                    _loc11_.start = _loc7_.length;
                                    _loc11_.end = _loc11_.start + 1;
                                    _loc11_.text = _loc2_;
                                    _loc6_ = UIPackage.getItemByURL(_loc2_);
                                    if(_loc6_)
                                    {
                                       _loc11_.width = _loc6_.width;
                                       _loc11_.height = _loc6_.height;
                                    }
                                    _loc11_.width = XMLIterator.getAttributeInt("width",_loc11_.width);
                                    _loc11_.height = XMLIterator.getAttributeInt("height",_loc11_.height);
                                    _loc4_ = new TextFormat();
                                    _loc4_.font = _textFormat.font;
                                    _loc8_ = CharSize.getFontSizeByHeight(_loc11_.height,_loc4_.font);
                                    _loc4_.size = _loc8_;
                                    if(_loc8_ > _maxFontSize)
                                    {
                                       _maxFontSize = _loc8_;
                                    }
                                    _loc4_.bold = false;
                                    _loc4_.italic = false;
                                    _loc4_.letterSpacing = _loc11_.width + 4 - CharSize.getHolderWidth(_loc4_.font,int(_loc4_.size));
                                    _loc11_.textFormat = _loc4_;
                                    _loc7_ = _loc7_ + "　";
                                 }
                              }
                              continue;
                           }
                        }
                        else
                        {
                           _loc7_ = _loc7_ + "\n";
                           continue;
                        }
                     }
                     else
                     {
                        if(XMLIterator.tagType == 0)
                        {
                           _loc11_ = createElement();
                           _loc11_.tag = XMLIterator.tagName;
                           _loc11_.start = _loc7_.length;
                           _loc11_.end = -1;
                           _loc4_ = new TextFormat();
                           _loc8_ = XMLIterator.getAttributeInt("size",-1);
                           if(_loc8_ > 0)
                           {
                              _loc4_.size = _loc8_;
                              if(_loc8_ > _maxFontSize)
                              {
                                 _maxFontSize = _loc8_;
                              }
                           }
                           _loc2_ = XMLIterator.getAttribute("color");
                           if(_loc2_)
                           {
                              _loc4_.color = ToolSet.convertFromHtmlColor(_loc2_);
                           }
                           _loc2_ = XMLIterator.getAttribute("align");
                           if(_loc2_)
                           {
                              _loc4_.align = _loc2_;
                           }
                           _loc11_.textFormat = _loc4_;
                        }
                        else if(XMLIterator.tagType == 1)
                        {
                           _loc11_ = findStartTag(XMLIterator.tagName);
                           if(_loc11_)
                           {
                              _loc11_.end = _loc7_.length;
                           }
                        }
                        continue;
                     }
                  }
                  else
                  {
                     if(XMLIterator.tagType == 0)
                     {
                        _loc11_ = createElement();
                        _loc11_.tag = XMLIterator.tagName;
                        _loc11_.start = _loc7_.length;
                        _loc11_.end = -1;
                        _loc4_ = new TextFormat();
                        _loc4_.underline = true;
                        _loc11_.textFormat = _loc4_;
                     }
                     else if(XMLIterator.tagType == 1)
                     {
                        _loc11_ = findStartTag(XMLIterator.tagName);
                        if(_loc11_)
                        {
                           _loc11_.end = _loc7_.length;
                        }
                     }
                     continue;
                  }
               }
               else
               {
                  if(XMLIterator.tagType == 0)
                  {
                     _loc11_ = createElement();
                     _loc11_.tag = XMLIterator.tagName;
                     _loc11_.start = _loc7_.length;
                     _loc11_.end = -1;
                     _loc4_ = new TextFormat();
                     _loc4_.italic = true;
                     _loc11_.textFormat = _loc4_;
                  }
                  else if(XMLIterator.tagType == 1)
                  {
                     _loc11_ = findStartTag(XMLIterator.tagName);
                     if(_loc11_)
                     {
                        _loc11_.end = _loc7_.length;
                     }
                  }
                  continue;
               }
            }
            else
            {
               if(XMLIterator.tagType == 0)
               {
                  _loc4_ = new TextFormat();
                  _loc4_.bold = true;
                  _loc11_ = createElement();
                  _loc11_.tag = XMLIterator.tagName;
                  _loc11_.start = _loc7_.length;
                  _loc11_.end = -1;
                  _loc11_.textFormat = _loc4_;
               }
               else if(XMLIterator.tagType == 1)
               {
                  _loc11_ = findStartTag(XMLIterator.tagName);
                  if(_loc11_)
                  {
                     _loc11_.end = _loc7_.length;
                  }
               }
               continue;
            }
         }
         if(_loc9_ == 0)
         {
            _loc2_ = XMLIterator.getText(_loc3_);
            if(_loc2_.length > 0)
            {
               if(_loc10_ && _loc2_.charCodeAt(0) == 10)
               {
                  _loc7_ = _loc7_ + _loc2_.substr(1);
               }
               else
               {
                  _loc7_ = _loc7_ + _loc2_;
               }
            }
         }
         return _loc7_;
      }
      
      private function createElement() : HtmlElement
      {
         var _loc1_:* = null;
         if(_elementCache.length)
         {
            _loc1_ = _elementCache.pop();
         }
         else
         {
            _loc1_ = new HtmlElement();
         }
         _elements.push(_loc1_);
         return _loc1_;
      }
      
      private function createNodes() : void
      {
         var _loc5_:int = 0;
         var _loc10_:* = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:* = null;
         var _loc3_:int = _elements.length;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc10_ = _elements[_loc5_];
            if(_loc10_.tag == "a")
            {
               _loc4_ = _loc10_.start;
               _loc6_ = _loc10_.end - 1;
               if(_loc6_ < 0)
               {
                  return;
               }
               _loc9_ = _textField.getLineIndexOfChar(_loc4_);
               _loc8_ = _textField.getLineIndexOfChar(_loc6_);
               if(_loc9_ == _loc8_)
               {
                  createLinkButton(_loc4_,_loc6_,_loc10_);
               }
               else
               {
                  _loc2_ = _textField.getLineOffset(_loc9_);
                  createLinkButton(_loc4_,_loc2_ + _textField.getLineLength(_loc9_) - 1,_loc10_);
                  _loc7_ = _loc9_ + 1;
                  while(_loc7_ < _loc8_)
                  {
                     _loc2_ = _textField.getLineOffset(_loc7_);
                     createLinkButton(_loc2_,_loc2_ + _textField.getLineLength(_loc7_) - 1,_loc10_);
                     _loc7_++;
                  }
                  createLinkButton(_textField.getLineOffset(_loc8_),_loc6_,_loc10_);
               }
            }
            else if(_loc10_.tag == "img")
            {
               _loc1_ = createNode();
               _loc1_.charStart = _loc10_.start;
               _loc1_.charEnd = _loc10_.start;
               _loc1_.element = _loc10_;
            }
            _loc5_++;
         }
      }
      
      private function createNode() : HtmlNode
      {
         var _loc1_:* = null;
         if(_nodeCache.length)
         {
            _loc1_ = _nodeCache.pop();
         }
         else
         {
            _loc1_ = new HtmlNode();
         }
         _nodes.push(_loc1_);
         return _loc1_;
      }
      
      private function createLinkButton(param1:int, param2:int, param3:HtmlElement) : void
      {
         param1 = skipLeftCR(param1,param2);
         param2 = skipRightCR(param1,param2);
         var _loc4_:HtmlNode = createNode();
         _loc4_.charStart = param1;
         _loc4_.charEnd = param2;
         _loc4_.element = param3;
      }
      
      private function clearElements() : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc1_:int = _elements.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _elements[_loc2_];
            _loc3_.textFormat = null;
            _loc3_.text = null;
            _loc3_.tag = null;
            _elementCache.push(_loc3_);
            _loc2_++;
         }
         _elements.length = 0;
      }
      
      private function destroyNodes() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         var _loc2_:int = _nodes.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _nodes[_loc3_];
            if(_loc1_.displayObject != null)
            {
               if(_loc1_.displayObject.parent != null)
               {
                  _objectsContainer.removeChild(_loc1_.displayObject);
               }
               if(_loc1_.element.tag == "a")
               {
                  _linkButtonCache.push(_loc1_.displayObject);
               }
               else if(_loc1_.element.tag == "img")
               {
                  objectFactory.freeObject(_loc1_.displayObject);
               }
            }
            _loc1_.reset();
            _nodeCache.push(_loc1_);
            _loc3_++;
         }
         _nodes.length = 0;
         _objectsContainer.removeChildren();
      }
      
      private function adjustNodes() : void
      {
         var _loc7_:* = null;
         var _loc10_:* = null;
         var _loc3_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:* = null;
         var _loc12_:* = null;
         var _loc11_:* = null;
         var _loc2_:* = null;
         var _loc5_:int = 0;
         var _loc4_:* = null;
         var _loc9_:* = null;
         var _loc6_:int = _nodes.length;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc1_ = _nodes[_loc8_];
            _loc12_ = _loc1_.element;
            if(_loc12_.tag == "a")
            {
               if(_loc1_.displayObject == null)
               {
                  if(_linkButtonCache.length)
                  {
                     _loc11_ = _linkButtonCache.pop();
                  }
                  else
                  {
                     _loc11_ = new LinkButton();
                     _loc11_.addEventListener("rollOver",onLinkRollOver);
                     _loc11_.addEventListener("rollOut",onLinkRollOut);
                     _loc11_.addEventListener("click",onLinkClick);
                  }
                  _loc11_.owner = _loc1_;
                  _loc1_.displayObject = _loc11_;
               }
               _loc7_ = _textField.getCharBoundaries(_loc1_.charStart);
               if(_loc7_ == null)
               {
                  return;
               }
               _loc10_ = _textField.getCharBoundaries(_loc1_.charEnd);
               if(_loc10_ == null)
               {
                  return;
               }
               _loc3_ = _textField.getLineIndexOfChar(_loc1_.charStart);
               _loc2_ = _textField.getLineMetrics(_loc3_);
               _loc5_ = _loc10_.right - _loc7_.left;
               if(_loc7_.left + _loc5_ > _textField.width - 2)
               {
                  _loc5_ = _textField.width - _loc7_.left - 2;
               }
               _loc1_.displayObject.x = _loc7_.left;
               LinkButton(_loc1_.displayObject).setSize(_loc5_,_loc2_.height);
               if(_loc7_.top < _loc10_.top)
               {
                  _loc1_.topY = 0;
               }
               else
               {
                  _loc1_.topY = _loc10_.top - _loc7_.top;
               }
               _loc1_.displayObject.y = _loc7_.top + _loc1_.topY;
               if(isLineVisible(_loc3_))
               {
                  if(_loc1_.displayObject.parent == null)
                  {
                     _objectsContainer.addChild(_loc1_.displayObject);
                  }
               }
               else if(_loc1_.displayObject.parent)
               {
                  _objectsContainer.removeChild(_loc1_.displayObject);
               }
            }
            else if(_loc12_.tag == "img")
            {
               if(_loc1_.displayObject == null)
               {
                  _loc4_ = objectFactory.createObject(_loc12_.text,_loc12_.width,_loc12_.height);
                  _loc1_.displayObject = _loc4_;
               }
               _loc7_ = _textField.getCharBoundaries(_loc1_.charStart);
               if(_loc7_ == null)
               {
                  return;
               }
               _loc3_ = _textField.getLineIndexOfChar(_loc1_.charStart);
               _loc9_ = _textField.getLineMetrics(_loc3_);
               if(_loc9_ == null)
               {
                  return;
               }
               _loc1_.displayObject.x = _loc7_.left + 2;
               if(_loc12_.height < _loc9_.ascent)
               {
                  _loc1_.displayObject.y = _loc7_.top + _loc9_.ascent - _loc12_.height;
               }
               else
               {
                  _loc1_.displayObject.y = _loc7_.bottom - _loc12_.height;
               }
               if(isLineVisible(_loc3_) && _loc1_.displayObject.x + _loc12_.width < _textField.width - 2)
               {
                  if(_loc1_.displayObject.parent == null)
                  {
                     _objectsContainer.addChildAt(_loc1_.displayObject,_objectsContainer.numChildren);
                  }
               }
               else if(_loc1_.displayObject.parent)
               {
                  _objectsContainer.removeChild(_loc1_.displayObject);
               }
            }
            _loc8_++;
         }
      }
      
      private function findStartTag(param1:String) : HtmlElement
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc2_:int = _elements.length;
         _loc3_ = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = _elements[_loc3_];
            if(_loc4_.tag == param1 && _loc4_.end == -1)
            {
               return _loc4_;
            }
            _loc3_--;
         }
         return null;
      }
      
      private function isLineVisible(param1:int) : Boolean
      {
         return param1 >= _textField.scrollV - 1 && param1 <= _textField.bottomScrollV - 1;
      }
      
      private function skipLeftCR(param1:int, param2:int) : int
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc5_:String = _textField.text;
         _loc4_ = param1;
         while(_loc4_ < param2)
         {
            _loc3_ = _loc5_.charAt(_loc4_);
            if(!(_loc3_ != "\r" && _loc3_ != "\n"))
            {
               _loc4_++;
               continue;
            }
            break;
         }
         return _loc4_;
      }
      
      private function skipRightCR(param1:int, param2:int) : int
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc5_:String = _textField.text;
         _loc4_ = param2;
         while(_loc4_ > param1)
         {
            _loc3_ = _loc5_.charAt(_loc4_);
            if(!(_loc3_ != "\r" && _loc3_ != "\n"))
            {
               _loc4_--;
               continue;
            }
            break;
         }
         return _loc4_;
      }
      
      private function onLinkRollOver(param1:Event) : void
      {
         var _loc2_:HtmlNode = LinkButton(param1.currentTarget).owner;
         if(_AHoverFormat)
         {
            _textField.setTextFormat(_AHoverFormat,_loc2_.element.start,_loc2_.element.end);
         }
      }
      
      private function onLinkRollOut(param1:Event) : void
      {
         var _loc2_:HtmlNode = LinkButton(param1.currentTarget).owner;
         if(!_loc2_.displayObject || !_loc2_.displayObject.stage)
         {
            return;
         }
         if(_AHoverFormat && _ALinkFormat)
         {
            _textField.setTextFormat(_ALinkFormat,_loc2_.element.start,_loc2_.element.end);
         }
      }
      
      private function onLinkClick(param1:Event) : void
      {
         param1.stopPropagation();
         var _loc2_:HtmlNode = LinkButton(param1.currentTarget).owner;
         var _loc4_:String = _loc2_.element.text;
         var _loc3_:int = _loc4_.indexOf("event:");
         if(_loc3_ == 0)
         {
            _loc4_ = _loc4_.substring(6);
            this.displayObject.dispatchEvent(new TextEvent("link",true,false,_loc4_));
         }
         else
         {
            navigateToURL(new URLRequest(_loc4_),"_blank");
         }
      }
   }
}

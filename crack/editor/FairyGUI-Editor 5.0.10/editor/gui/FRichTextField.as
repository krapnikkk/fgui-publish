package fairygui.editor.gui
{
   import fairygui.editor.gui.text.FHtmlElement;
   import fairygui.editor.gui.text.FHtmlNode;
   import fairygui.editor.gui.text.FLinkButton;
   import fairygui.editor.gui.text.XMLIterator;
   import fairygui.utils.CharSize;
   import fairygui.utils.UBBParser;
   import fairygui.utils.UtilsStr;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class FRichTextField extends FTextField
   {
       
      
      private var _objectsContainer:Sprite;
      
      private var _ALinkFormat:TextFormat;
      
      private var _elements:Vector.<FHtmlElement>;
      
      private var _nodes:Vector.<FHtmlNode>;
      
      private var _hasLink:Boolean;
      
      private var _linkButtonCache:Vector.<FLinkButton>;
      
      private var _nodeCache:Vector.<FHtmlNode>;
      
      public function FRichTextField()
      {
         super();
         this._objectType = FObjectType.RICHTEXT;
         this._objectsContainer = new Sprite();
         this._objectsContainer.mouseEnabled = false;
         _displayObject.container.addChild(this._objectsContainer);
         this._ALinkFormat = new TextFormat();
         this._ALinkFormat.underline = true;
         this._ALinkFormat.url = "#";
         this._elements = new Vector.<FHtmlElement>();
         this._nodes = new Vector.<FHtmlNode>();
         this._linkButtonCache = new Vector.<FLinkButton>();
         this._nodeCache = new Vector.<FHtmlNode>();
      }
      
      public function updateRichText(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc4_:FHtmlElement = null;
         this.destroyNodes();
         this._elements.length = 0;
         _textField.htmlText = "";
         _textField.defaultTextFormat = _textFormat;
         if(!_text.length)
         {
            this.updateSize();
            return;
         }
         if(_ubbEnabled)
         {
            param1 = UBBParser.inst.parse(param1);
         }
         _textField.defaultTextFormat = _textFormat;
         _textField.text = this.parseHtml(param1);
         var _loc3_:int = this._elements.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._elements[_loc2_];
            if(_loc4_.textformat && _loc4_.end > _loc4_.start)
            {
               _textField.setTextFormat(_loc4_.textformat,_loc4_.start,_loc4_.end);
            }
            _loc2_++;
         }
         this.createNodes();
      }
      
      override protected function updateSize(param1:Boolean = false) : void
      {
         var fromSizeChanged:Boolean = param1;
         super.updateSize(fromSizeChanged);
         if(fromSizeChanged && this._hasLink)
         {
            this.destroyNodes();
            this.createNodes();
         }
         if(_displayObject.stage == null)
         {
            _displayObject.addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
            {
               adjustNodes();
            },false,0,true);
         }
         else
         {
            this.adjustNodes();
         }
      }
      
      override protected function doAlign() : void
      {
         super.doAlign();
         this._objectsContainer.y = _yOffset;
      }
      
      override public function get deprecated() : Boolean
      {
         var _loc4_:FHtmlNode = null;
         var _loc1_:Boolean = super.deprecated;
         if(_loc1_)
         {
            return _loc1_;
         }
         var _loc2_:int = this._nodes.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._nodes[_loc3_];
            if(_loc4_.displayObject && _loc4_.element.tag == "img")
            {
               if(FSprite(_loc4_.displayObject).owner.validate(true))
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      override protected function handleDispose() : void
      {
         super.handleDispose();
         this.destroyNodes();
      }
      
      private function parseHtml(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc6_:TextFormat = null;
         var _loc7_:int = 0;
         var _loc8_:FHtmlElement = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:FPackageItem = null;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         XMLIterator.begin(param1,true);
         var _loc5_:* = "";
         var _loc9_:Boolean = false;
         while(XMLIterator.nextTag())
         {
            if(_loc2_ == 0)
            {
               _loc4_ = XMLIterator.getText(_loc3_);
               if(_loc4_.length > 0)
               {
                  if(_loc9_ && _loc4_.charCodeAt(0) == 10)
                  {
                     _loc5_ = _loc5_ + _loc4_.substr(1);
                  }
                  else
                  {
                     _loc5_ = _loc5_ + _loc4_;
                  }
               }
            }
            _loc9_ = false;
            switch(XMLIterator.tagName)
            {
               case "b":
                  if(XMLIterator.tagType == XMLIterator.TAG_START)
                  {
                     _loc6_ = new TextFormat();
                     _loc6_.bold = true;
                     _loc8_ = new FHtmlElement();
                     _loc8_.tag = XMLIterator.tagName;
                     _loc8_.start = _loc5_.length;
                     _loc8_.end = -1;
                     _loc8_.textformat = _loc6_;
                     this._elements.push(_loc8_);
                  }
                  else if(XMLIterator.tagType == XMLIterator.TAG_END)
                  {
                     _loc8_ = this.findStartTag(XMLIterator.tagName);
                     if(_loc8_)
                     {
                        _loc8_.end = _loc5_.length;
                     }
                  }
                  continue;
               case "i":
                  if(XMLIterator.tagType == XMLIterator.TAG_START)
                  {
                     _loc8_ = new FHtmlElement();
                     _loc8_.tag = XMLIterator.tagName;
                     _loc8_.start = _loc5_.length;
                     _loc8_.end = -1;
                     this._elements.push(_loc8_);
                     _loc6_ = new TextFormat();
                     _loc6_.italic = true;
                     _loc8_.textformat = _loc6_;
                  }
                  else if(XMLIterator.tagType == XMLIterator.TAG_END)
                  {
                     _loc8_ = this.findStartTag(XMLIterator.tagName);
                     if(_loc8_)
                     {
                        _loc8_.end = _loc5_.length;
                     }
                  }
                  continue;
               case "u":
                  if(XMLIterator.tagType == XMLIterator.TAG_START)
                  {
                     _loc8_ = new FHtmlElement();
                     _loc8_.tag = XMLIterator.tagName;
                     _loc8_.start = _loc5_.length;
                     _loc8_.end = -1;
                     this._elements.push(_loc8_);
                     _loc6_ = new TextFormat();
                     _loc6_.underline = true;
                     _loc8_.textformat = _loc6_;
                  }
                  else if(XMLIterator.tagType == XMLIterator.TAG_END)
                  {
                     _loc8_ = this.findStartTag(XMLIterator.tagName);
                     if(_loc8_)
                     {
                        _loc8_.end = _loc5_.length;
                     }
                  }
                  continue;
               case "font":
                  if(XMLIterator.tagType == XMLIterator.TAG_START)
                  {
                     _loc8_ = new FHtmlElement();
                     _loc8_.tag = XMLIterator.tagName;
                     _loc8_.start = _loc5_.length;
                     _loc8_.end = -1;
                     this._elements.push(_loc8_);
                     _loc6_ = new TextFormat();
                     _loc10_ = XMLIterator.getAttributeInt("size",-1);
                     if(_loc10_ > 0)
                     {
                        _loc6_.size = _loc10_;
                        if(_loc10_ > _maxFontSize)
                        {
                           _maxFontSize = _loc10_;
                        }
                     }
                     _loc11_ = XMLIterator.getAttribute("color");
                     if(_loc11_ != null)
                     {
                        _loc6_.color = UtilsStr.convertFromHtmlColor(_loc11_);
                     }
                     _loc8_.textformat = _loc6_;
                  }
                  else if(XMLIterator.tagType == XMLIterator.TAG_END)
                  {
                     _loc8_ = this.findStartTag(XMLIterator.tagName);
                     if(_loc8_)
                     {
                        _loc8_.end = _loc5_.length;
                     }
                  }
                  continue;
               case "br":
                  _loc5_ = _loc5_ + "\n";
                  continue;
               case "img":
                  if(XMLIterator.tagType == XMLIterator.TAG_START || XMLIterator.tagType == XMLIterator.TAG_VOID)
                  {
                     _loc12_ = XMLIterator.getAttribute("src");
                     if(_loc12_)
                     {
                        _loc8_ = new FHtmlElement();
                        _loc8_.tag = XMLIterator.tagName;
                        _loc8_.start = _loc5_.length;
                        _loc8_.end = _loc8_.start + 1;
                        _loc8_.text = _loc12_;
                        _loc13_ = _pkg.project.getItemByURL(_loc12_);
                        if(_loc13_)
                        {
                           _loc8_.width = _loc13_.width;
                           _loc8_.height = _loc13_.height;
                        }
                        _loc8_.width = XMLIterator.getAttributeInt("width",_loc8_.width);
                        _loc8_.height = XMLIterator.getAttributeInt("height",_loc8_.height);
                        this._elements.push(_loc8_);
                        _loc6_ = new TextFormat();
                        _loc6_.font = _textFormat.font;
                        _loc10_ = CharSize.getFontSizeByHeight(_loc8_.height,_loc6_.font);
                        _loc6_.size = _loc10_;
                        if(_loc10_ > _maxFontSize)
                        {
                           _maxFontSize = _loc10_;
                        }
                        _loc6_.bold = false;
                        _loc6_.italic = false;
                        _loc6_.letterSpacing = _loc8_.width + 4 - CharSize.getHolderWidth(_loc6_.font,int(_loc6_.size));
                        _loc8_.textformat = _loc6_;
                        _loc5_ = _loc5_ + "　";
                     }
                  }
                  continue;
               case "a":
                  if(XMLIterator.tagType == XMLIterator.TAG_START)
                  {
                     _loc8_ = new FHtmlElement();
                     _loc8_.tag = XMLIterator.tagName;
                     _loc8_.start = _loc5_.length;
                     _loc8_.end = -1;
                     _loc8_.text = XMLIterator.getAttribute("href");
                     _loc8_.textformat = this._ALinkFormat;
                     this._elements.push(_loc8_);
                  }
                  else if(XMLIterator.tagType == XMLIterator.TAG_END)
                  {
                     _loc8_ = this.findStartTag(XMLIterator.tagName);
                     if(_loc8_)
                     {
                        _loc8_.end = _loc5_.length;
                     }
                  }
                  continue;
               case "p":
                  if(XMLIterator.tagType == XMLIterator.TAG_START)
                  {
                     if(_loc5_.length && _loc5_.charCodeAt(_loc5_.length - 1) != 10)
                     {
                        _loc5_ = _loc5_ + "\n";
                     }
                     _loc4_ = XMLIterator.getAttribute("align");
                     if(_loc4_ == "center" || _loc4_ == "right")
                     {
                        _loc8_ = new FHtmlElement();
                        _loc8_.tag = XMLIterator.tagName;
                        _loc8_.start = _loc5_.length;
                        _loc8_.end = -1;
                        this._elements.push(_loc8_);
                        _loc6_ = new TextFormat();
                        _loc6_.align = _loc4_;
                        _loc8_.textformat = _loc6_;
                     }
                  }
                  else if(XMLIterator.tagType == XMLIterator.TAG_END)
                  {
                     _loc5_ = _loc5_ + "\n";
                     _loc9_ = true;
                     _loc8_ = this.findStartTag(XMLIterator.tagName);
                     if(_loc8_)
                     {
                        _loc8_.end = _loc5_.length;
                     }
                  }
                  continue;
               case "ui":
               case "div":
               case "li":
                  if(XMLIterator.tagType == XMLIterator.TAG_START)
                  {
                     if(_loc5_.length && _loc5_.charCodeAt(_loc5_.length - 1) != 10)
                     {
                        _loc5_ = _loc5_ + "\n";
                     }
                  }
                  else if(XMLIterator.tagType == XMLIterator.TAG_END)
                  {
                     _loc5_ = _loc5_ + "\n";
                     _loc9_ = true;
                  }
                  continue;
               case "html":
               case "body":
                  _loc3_ = true;
                  continue;
               case "input":
               case "select":
               case "head":
               case "style":
               case "script":
               case "form":
                  if(XMLIterator.tagType == XMLIterator.TAG_START)
                  {
                     _loc2_++;
                  }
                  else if(XMLIterator.tagType == XMLIterator.TAG_END)
                  {
                     _loc2_--;
                  }
                  continue;
               default:
                  continue;
            }
         }
         if(_loc2_ == 0)
         {
            _loc4_ = XMLIterator.getText(_loc3_);
            if(_loc4_.length > 0)
            {
               if(_loc9_ && _loc4_.charCodeAt(0) == 10)
               {
                  _loc5_ = _loc5_ + _loc4_.substr(1);
               }
               else
               {
                  _loc5_ = _loc5_ + _loc4_;
               }
            }
         }
         return _loc5_;
      }
      
      private function createNodes() : void
      {
         var _loc3_:FHtmlElement = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:FHtmlNode = null;
         var _loc1_:int = this._elements.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._elements[_loc2_];
            if(_loc3_.tag == "a")
            {
               if((_flags & FObjectFlags.IN_TEST) != 0)
               {
                  _loc4_ = _loc3_.start;
                  _loc5_ = _loc3_.end - 1;
                  if(_loc5_ < 0)
                  {
                     return;
                  }
                  this._hasLink = true;
                  _loc6_ = _textField.getLineIndexOfChar(_loc4_);
                  _loc7_ = _textField.getLineIndexOfChar(_loc5_);
                  if(_loc6_ == _loc7_)
                  {
                     this.createLinkButton(_loc4_,_loc5_,_loc3_);
                  }
                  else
                  {
                     _loc8_ = _textField.getLineOffset(_loc6_);
                     this.createLinkButton(_loc4_,_loc8_ + _textField.getLineLength(_loc6_) - 1,_loc3_);
                     _loc9_ = _loc6_ + 1;
                     while(_loc9_ < _loc7_)
                     {
                        _loc8_ = _textField.getLineOffset(_loc9_);
                        this.createLinkButton(_loc8_,_loc8_ + _textField.getLineLength(_loc9_) - 1,_loc3_);
                        _loc9_++;
                     }
                     this.createLinkButton(_textField.getLineOffset(_loc7_),_loc5_,_loc3_);
                  }
               }
            }
            else if(_loc3_.tag == "img")
            {
               _loc10_ = this.createNode();
               _loc10_.charStart = _loc3_.start;
               _loc10_.charEnd = _loc3_.start;
               _loc10_.element = _loc3_;
            }
            _loc2_++;
         }
      }
      
      private function createNode() : FHtmlNode
      {
         var _loc1_:FHtmlNode = null;
         if(this._nodeCache.length)
         {
            _loc1_ = this._nodeCache.pop();
         }
         else
         {
            _loc1_ = new FHtmlNode();
         }
         this._nodes.push(_loc1_);
         return _loc1_;
      }
      
      private function createLinkButton(param1:int, param2:int, param3:FHtmlElement) : void
      {
         param1 = this.skipLeftCR(param1,param2);
         param2 = this.skipRightCR(param1,param2);
         var _loc4_:FHtmlNode = this.createNode();
         _loc4_.charStart = param1;
         _loc4_.charEnd = param2;
         _loc4_.element = param3;
      }
      
      private function destroyNodes() : void
      {
         var _loc3_:FHtmlNode = null;
         var _loc1_:int = this._nodes.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._nodes[_loc2_];
            if(_loc3_.displayObject != null)
            {
               if(_loc3_.displayObject.parent != null)
               {
                  this._objectsContainer.removeChild(_loc3_.displayObject);
               }
               if(_loc3_.element.tag == "a")
               {
                  this._linkButtonCache.push(_loc3_.displayObject);
               }
               else if(_loc3_.element.tag == "img")
               {
                  FSprite(_loc3_.displayObject).owner.dispose();
               }
            }
            _loc3_.reset();
            this._nodeCache.push(_loc3_);
            _loc2_++;
         }
         this._nodes.length = 0;
         this._hasLink = false;
         this._objectsContainer.removeChildren();
      }
      
      private function adjustNodes() : void
      {
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         var _loc6_:FHtmlNode = null;
         var _loc7_:FHtmlElement = null;
         var _loc8_:TextLineMetrics = null;
         var _loc9_:int = 0;
         var _loc10_:FLinkButton = null;
         var _loc11_:TextLineMetrics = null;
         var _loc12_:FLoader = null;
         var _loc1_:int = this._nodes.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc1_)
         {
            _loc6_ = this._nodes[_loc5_];
            _loc7_ = _loc6_.element;
            if(_loc7_.tag == "a")
            {
               if(_loc6_.displayObject == null)
               {
                  if(this._linkButtonCache.length)
                  {
                     _loc10_ = this._linkButtonCache.pop();
                  }
                  else
                  {
                     _loc10_ = new FLinkButton();
                  }
                  _loc10_.owner = _loc6_;
                  _loc6_.displayObject = _loc10_;
               }
               _loc2_ = _textField.getCharBoundaries(_loc6_.charStart);
               if(_loc2_ == null)
               {
                  return;
               }
               _loc3_ = _textField.getCharBoundaries(_loc6_.charEnd);
               if(_loc3_ == null)
               {
                  return;
               }
               _loc4_ = _textField.getLineIndexOfChar(_loc6_.charStart);
               _loc8_ = _textField.getLineMetrics(_loc4_);
               _loc9_ = _loc3_.right - _loc2_.left;
               if(_loc2_.left + _loc9_ > _textField.width - 2)
               {
                  _loc9_ = _textField.width - _loc2_.left - 2;
               }
               _loc6_.displayObject.x = _loc2_.left;
               FLinkButton(_loc6_.displayObject).setSize(_loc9_,_loc8_.height);
               if(_loc2_.top < _loc3_.top)
               {
                  _loc6_.topY = 0;
               }
               else
               {
                  _loc6_.topY = _loc3_.top - _loc2_.top;
               }
               _loc6_.displayObject.y = _loc2_.top + _loc6_.topY;
               if(this.isLineVisible(_loc4_))
               {
                  if(_loc6_.displayObject.parent == null)
                  {
                     this._objectsContainer.addChild(_loc6_.displayObject);
                  }
               }
               else if(_loc6_.displayObject.parent)
               {
                  this._objectsContainer.removeChild(_loc6_.displayObject);
               }
            }
            else if(_loc7_.tag == "img")
            {
               if(_loc6_.displayObject == null)
               {
                  _loc12_ = FLoader(FObjectFactory.createObject2(this._pkg,"loader",null,_flags & 255));
                  _loc12_.fill = "scaleFree";
                  _loc12_.setSize(_loc7_.width,_loc7_.height);
                  _loc12_.url = _loc7_.text;
                  _loc6_.displayObject = _loc12_.displayObject;
               }
               _loc2_ = _textField.getCharBoundaries(_loc6_.charStart);
               if(_loc2_ == null)
               {
                  return;
               }
               _loc4_ = _textField.getLineIndexOfChar(_loc6_.charStart);
               _loc11_ = _textField.getLineMetrics(_loc4_);
               if(_loc11_ == null)
               {
                  return;
               }
               _loc6_.displayObject.x = _loc2_.left + 2;
               if(_loc7_.height < _loc11_.ascent)
               {
                  _loc6_.displayObject.y = _loc2_.top + _loc11_.ascent - _loc7_.height;
               }
               else
               {
                  _loc6_.displayObject.y = _loc2_.bottom - _loc7_.height;
               }
               if(this.isLineVisible(_loc4_) && _loc6_.displayObject.x + _loc6_.displayObject.width < _textField.width - 2)
               {
                  if(_loc6_.displayObject.parent == null)
                  {
                     this._objectsContainer.addChildAt(_loc6_.displayObject,this._objectsContainer.numChildren);
                  }
               }
               else if(_loc6_.displayObject.parent)
               {
                  this._objectsContainer.removeChild(_loc6_.displayObject);
               }
            }
            _loc5_++;
         }
      }
      
      private function findStartTag(param1:String) : FHtmlElement
      {
         var _loc4_:FHtmlElement = null;
         var _loc2_:int = this._elements.length;
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = this._elements[_loc3_];
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
         var _loc5_:String = null;
         var _loc3_:String = _textField.text;
         var _loc4_:int = param1;
         while(_loc4_ < param2)
         {
            _loc5_ = _loc3_.charAt(_loc4_);
            if(_loc5_ != "\r" && _loc5_ != "\n")
            {
               break;
            }
            _loc4_++;
         }
         return _loc4_;
      }
      
      private function skipRightCR(param1:int, param2:int) : int
      {
         var _loc5_:String = null;
         var _loc3_:String = _textField.text;
         var _loc4_:int = param2;
         while(_loc4_ > param1)
         {
            _loc5_ = _loc3_.charAt(_loc4_);
            if(_loc5_ != "\r" && _loc5_ != "\n")
            {
               break;
            }
            _loc4_--;
         }
         return _loc4_;
      }
   }
}

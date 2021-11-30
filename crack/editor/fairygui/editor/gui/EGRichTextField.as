package fairygui.editor.gui
{
   import fairygui.editor.gui.text.EHtmlElement;
   import fairygui.editor.gui.text.EHtmlNode;
   import fairygui.editor.gui.text.EHtmlText;
   import fairygui.editor.gui.text.ELinkButton;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.CharSize;
   import fairygui.utils.UBBParser;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class EGRichTextField extends EGTextField
   {
       
      
      private var _lineInfo:Array;
      
      private var _linkButtonCache:Vector.<ELinkButton>;
      
      private var _nodeCache:Vector.<EHtmlNode>;
      
      private var _needUpdateNodePos:Boolean;
      
      private var _ALinkFormat:TextFormat;
      
      private var _AHoverFormat:TextFormat;
      
      private var _objectsContainer:Sprite;
      
      public function EGRichTextField()
      {
         super();
         this.objectType = "richtext";
         this._linkButtonCache = new Vector.<ELinkButton>();
         this._nodeCache = new Vector.<EHtmlNode>();
         this._ALinkFormat = new TextFormat();
         this._ALinkFormat.underline = true;
         this._AHoverFormat = new TextFormat();
         this._AHoverFormat.underline = true;
         this._objectsContainer = new Sprite();
         this._objectsContainer.mouseEnabled = false;
         _displayObject.container.addChild(this._objectsContainer);
         this._lineInfo = [];
      }
      
      public function updateRichText() : void
      {
         var _loc1_:int = 0;
         var _loc6_:EHtmlElement = null;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:EPackageItem = null;
         this.clear();
         if(!_text.length)
         {
            this.fixTextSize();
            return;
         }
         var _loc10_:String = _text;
         if(_ubbEnabled)
         {
            _loc10_ = UBBParser.inst.parse(_loc10_);
         }
         var _loc9_:EHtmlText = new EHtmlText(_loc10_);
         _textField.defaultTextFormat = _textFormat;
         var _loc7_:int = _textField.text.length;
         var _loc8_:String = _loc9_.parsedText;
         _textField.replaceText(_loc7_,_loc7_,_loc8_);
         var _loc2_:int = _loc9_.elements.length;
         _loc1_ = _loc2_ - 1;
         while(_loc1_ >= 0)
         {
            _loc6_ = _loc9_.elements[_loc1_];
            if(_loc6_.type == 1)
            {
               if(this._ALinkFormat)
               {
                  _textField.setTextFormat(this._ALinkFormat,_loc7_ + _loc6_.start,_loc7_ + _loc6_.end + 1);
               }
            }
            else if(_loc6_.type == 2)
            {
               _loc5_ = 20;
               _loc4_ = 20;
               if(UtilsStr.startsWith(_loc6_.src,"ui://"))
               {
                  _loc3_ = this.pkg.project.getItemByURL(_loc6_.src);
                  if(_loc3_ != null)
                  {
                     _loc5_ = _loc3_.width;
                     _loc4_ = _loc3_.height;
                  }
               }
               if(_loc6_.width == 0)
               {
                  _loc6_.realWidth = _loc5_;
               }
               else
               {
                  _loc6_.realWidth = _loc6_.width;
               }
               if(_loc6_.height == 0)
               {
                  _loc6_.realHeight = _loc4_;
               }
               else
               {
                  _loc6_.realHeight = _loc6_.height;
               }
               _loc6_.textformat.font = !!_textField.embedFonts?_textFormat.font:CharSize.PLACEHOLDER_FONT;
               _loc6_.textformat.size = _loc6_.realHeight + 2;
               _loc6_.textformat.underline = false;
               _loc6_.textformat.letterSpacing = _loc6_.realWidth + 4 - CharSize.getHolderWidth(_loc6_.textformat.font,_loc6_.realHeight + 2);
               _textField.setTextFormat(_loc6_.textformat,_loc7_ + _loc6_.start,_loc7_ + _loc6_.end + 1);
            }
            else
            {
               _textField.setTextFormat(_loc6_.textformat,_loc7_ + _loc6_.start,_loc7_ + _loc6_.end + 1);
            }
            _loc1_--;
         }
         this.fixTextSize();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = _loc9_.elements[_loc1_];
            if(_loc6_.type == 1)
            {
               this.addLink(_loc7_,_loc6_);
            }
            else if(_loc6_.type == 2)
            {
               this.addImage(_loc7_,_loc6_);
            }
            _loc1_++;
         }
         if(_displayObject.stage == null && !this._needUpdateNodePos)
         {
            this._needUpdateNodePos = true;
            _displayObject.addEventListener("addedToStage",this.__addedToStage,false,0,true);
         }
      }
      
      override protected function handleDispose() : void
      {
         super.handleDispose();
         this.resetLines();
      }
      
      private function __addedToStage(param1:Event) : void
      {
         if(!this._needUpdateNodePos)
         {
            return;
         }
         this.adjustNodes();
         this._needUpdateNodePos = false;
      }
      
      private function adjustNodes() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:EHtmlNode = null;
         var _loc6_:int = this._lineInfo.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = this._lineInfo[_loc5_];
            if(_loc3_)
            {
               _loc4_ = _loc3_.length;
               if(this.isLineVisible(_loc5_))
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc4_)
                  {
                     _loc2_ = _loc3_[_loc1_];
                     if(this._needUpdateNodePos)
                     {
                        _loc2_.posUpdated = false;
                     }
                     this.showNode(_loc2_);
                     _loc1_++;
                  }
               }
               else
               {
                  _loc1_ = 0;
                  while(_loc1_ < _loc4_)
                  {
                     _loc2_ = _loc3_[_loc1_];
                     if(this._needUpdateNodePos)
                     {
                        _loc2_.posUpdated = false;
                     }
                     this.hideNode(_loc2_);
                     _loc1_++;
                  }
               }
            }
            _loc5_++;
         }
      }
      
      private function resetLines() : void
      {
         var _loc2_:Vector.<EHtmlNode> = null;
         var _loc3_:int = 0;
         var _loc1_:EHtmlNode = null;
         var _loc5_:int = this._lineInfo.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = this._lineInfo[_loc4_];
            if(_loc2_)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc1_ = _loc2_[_loc3_];
                  this.destroyNode(_loc1_);
                  _loc3_++;
               }
            }
            _loc4_++;
         }
         this._lineInfo.length = 0;
      }
      
      private function clear() : void
      {
         this.resetLines();
         _textField.htmlText = "";
         _textField.defaultTextFormat = _textFormat;
         this._objectsContainer.removeChildren();
         this._needUpdateNodePos = false;
      }
      
      private function fixTextSize() : void
      {
         _textField.textWidth;
      }
      
      private function isLineVisible(param1:int) : Boolean
      {
         return true;
      }
      
      private function createNode(param1:int) : EHtmlNode
      {
         var _loc2_:EHtmlNode = null;
         var _loc3_:Vector.<EHtmlNode> = this._lineInfo[param1];
         if(!_loc3_)
         {
            _loc3_ = new Vector.<EHtmlNode>();
            this._lineInfo[param1] = _loc3_;
         }
         if(this._nodeCache.length)
         {
            _loc2_ = this._nodeCache.pop();
         }
         else
         {
            _loc2_ = new EHtmlNode();
         }
         _loc2_.lineIndex = param1;
         _loc2_.nodeIndex = _loc3_.length;
         _loc3_.push(_loc2_);
         return _loc2_;
      }
      
      private function destroyNode(param1:EHtmlNode) : void
      {
         if(param1.displayObject != null)
         {
            if(param1.displayObject.parent != null)
            {
               this._objectsContainer.removeChild(param1.displayObject);
            }
            if(param1.element.type == 1)
            {
               this._linkButtonCache.push(param1.displayObject);
            }
            else if(param1.element.type == 2)
            {
               EUISprite(param1.displayObject).owner.dispose();
            }
         }
         param1.reset();
         this._nodeCache.push(param1);
      }
      
      private function addLink(param1:int, param2:EHtmlElement) : void
      {
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:int = param1 + param2.start;
         var _loc8_:int = param1 + param2.end;
         var _loc3_:int = _textField.getLineIndexOfChar(_loc7_);
         var _loc4_:int = _textField.getLineIndexOfChar(_loc8_);
         if(_loc3_ == _loc4_)
         {
            this.addLinkButton(_loc3_,_loc7_,_loc8_,param2);
         }
         else
         {
            _loc6_ = _textField.getLineOffset(_loc3_);
            this.addLinkButton(_loc3_,_loc7_,_loc6_ + _textField.getLineLength(_loc3_) - 1,param2);
            _loc5_ = _loc3_ + 1;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _textField.getLineOffset(_loc5_);
               this.addLinkButton(_loc5_,_loc6_,_loc6_ + _textField.getLineLength(_loc5_) - 1,param2);
               _loc5_++;
            }
            this.addLinkButton(_loc4_,_textField.getLineOffset(_loc4_),_loc8_,param2);
         }
      }
      
      private function addLinkButton(param1:int, param2:int, param3:int, param4:EHtmlElement) : void
      {
         param2 = this.skipLeftCR(param2,param3);
         param3 = this.skipRightCR(param2,param3);
         var _loc5_:EHtmlNode = this.createNode(param1);
         _loc5_.charStart = param2;
         _loc5_.charEnd = param3;
         _loc5_.element = param4;
         if(this.isLineVisible(param1))
         {
            this.showNode(_loc5_);
         }
      }
      
      private function addImage(param1:int, param2:EHtmlElement) : void
      {
         var _loc4_:int = param1 + param2.start;
         var _loc5_:int = _textField.getLineIndexOfChar(_loc4_);
         var _loc3_:EHtmlNode = this.createNode(_loc5_);
         _loc3_.charStart = _loc4_;
         _loc3_.charEnd = _loc4_;
         _loc3_.element = param2;
         if(this.isLineVisible(_loc5_))
         {
            this.showNode(_loc3_);
         }
      }
      
      private function showNode(param1:EHtmlNode) : void
      {
         var _loc7_:ELinkButton = null;
         var _loc8_:Rectangle = null;
         var _loc2_:Rectangle = null;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:TextLineMetrics = null;
         var _loc4_:EGLoader = null;
         var _loc9_:EHtmlElement = param1.element;
         if(_loc9_.type == 1)
         {
            if(param1.displayObject == null)
            {
               if(this._linkButtonCache.length)
               {
                  _loc7_ = this._linkButtonCache.pop();
               }
               else
               {
                  _loc7_ = new ELinkButton();
               }
               _loc7_.owner = param1;
               param1.displayObject = _loc7_;
            }
            if(!param1.posUpdated)
            {
               _loc8_ = _textField.getCharBoundaries(param1.charStart);
               if(_loc8_ == null)
               {
                  return;
               }
               _loc2_ = _textField.getCharBoundaries(param1.charEnd);
               if(_loc2_ == null)
               {
                  return;
               }
               _loc3_ = _loc2_.right - _loc8_.left;
               if(_loc8_.left + _loc3_ > _textField.width - 2)
               {
                  _loc3_ = _textField.width - _loc8_.left - 2;
               }
               _loc6_ = Math.max(_loc8_.height,_loc2_.height);
               param1.displayObject.x = _loc8_.left;
               param1.displayObject.width = _loc3_;
               param1.displayObject.height = _loc6_;
               if(_loc8_.top < _loc2_.top)
               {
                  param1.topY = 0;
               }
               else
               {
                  param1.topY = _loc2_.top - _loc8_.top;
               }
               param1.posUpdated = true;
            }
            else
            {
               _loc8_ = _textField.getCharBoundaries(param1.charStart);
               if(_loc8_ == null)
               {
                  return;
               }
            }
            param1.displayObject.y = _loc8_.top + param1.topY;
            if(param1.displayObject.parent == null)
            {
               this._objectsContainer.addChild(param1.displayObject);
            }
         }
         else if(_loc9_.type == 2)
         {
            if(param1.displayObject == null)
            {
               _loc4_ = EGLoader(EUIObjectFactory.createObject2(this.pkg,"loader",editMode == 1?1:0));
               _loc4_.fill = "scaleFree";
               _loc4_.url = _loc9_.src;
               _loc4_.width = _loc9_.realWidth;
               _loc4_.height = _loc9_.realHeight;
               param1.displayObject = _loc4_.displayObject;
            }
            _loc8_ = _textField.getCharBoundaries(param1.charStart);
            if(_loc8_ == null)
            {
               return;
            }
            _loc5_ = _textField.getLineMetrics(param1.lineIndex);
            if(_loc5_ == null)
            {
               return;
            }
            param1.displayObject.x = _loc8_.left + 2;
            if(_loc9_.realHeight < _loc5_.ascent)
            {
               param1.displayObject.y = _loc8_.top + _loc5_.ascent - _loc9_.realHeight;
            }
            else
            {
               param1.displayObject.y = _loc8_.bottom - _loc9_.realHeight;
            }
            if(param1.displayObject.x + param1.displayObject.width < _textField.width - 2)
            {
               if(param1.displayObject.parent == null)
               {
                  this._objectsContainer.addChildAt(param1.displayObject,this._objectsContainer.numChildren);
               }
            }
         }
      }
      
      private function hideNode(param1:EHtmlNode) : void
      {
         if(param1.displayObject && param1.displayObject.parent)
         {
            this._objectsContainer.removeChild(param1.displayObject);
         }
      }
      
      private function skipLeftCR(param1:int, param2:int) : int
      {
         var _loc3_:String = null;
         var _loc4_:String = _textField.text;
         var _loc5_:* = param1;
         while(_loc5_ < param2)
         {
            _loc3_ = _loc4_.charAt(_loc5_);
            if(!(_loc3_ != "\r" && _loc3_ != "\n"))
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
         var _loc3_:String = null;
         var _loc4_:String = _textField.text;
         var _loc5_:* = param2;
         while(_loc5_ > param1)
         {
            _loc3_ = _loc4_.charAt(_loc5_);
            if(!(_loc3_ != "\r" && _loc3_ != "\n"))
            {
               _loc5_--;
               continue;
            }
            break;
         }
         return _loc5_;
      }
   }
}

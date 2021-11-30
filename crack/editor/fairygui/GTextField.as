package fairygui
{
   import fairygui.display.UIImage;
   import fairygui.display.UITextField;
   import fairygui.text.BMGlyph;
   import fairygui.text.BitmapFont;
   import fairygui.utils.CharSize;
   import fairygui.utils.FontUtils;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import flash.display.BitmapData;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class GTextField extends GObject implements ITextColorGear
   {
      
      private static const GUTTER_X:int = 2;
      
      private static const GUTTER_Y:int = 2;
       
      
      protected var _ubbEnabled:Boolean;
      
      protected var _autoSize:int;
      
      protected var _widthAutoSize:Boolean;
      
      protected var _heightAutoSize:Boolean;
      
      protected var _textFormat:TextFormat;
      
      protected var _text:String;
      
      protected var _font:String;
      
      protected var _fontSize:int;
      
      protected var _align:int;
      
      protected var _verticalAlign:int;
      
      protected var _color:uint;
      
      protected var _leading:int;
      
      protected var _letterSpacing:int;
      
      protected var _underline:Boolean;
      
      protected var _bold:Boolean;
      
      protected var _italic:Boolean;
      
      protected var _singleLine:Boolean;
      
      protected var _stroke:int;
      
      protected var _strokeColor:uint;
      
      protected var _shadowOffset:Point;
      
      protected var _textFilters:Array;
      
      protected var _textField:TextField;
      
      protected var _bitmap:UIImage;
      
      protected var _bitmapData:BitmapData;
      
      protected var _updatingSize:Boolean;
      
      protected var _requireRender:Boolean;
      
      protected var _sizeDirty:Boolean;
      
      protected var _textWidth:int;
      
      protected var _textHeight:int;
      
      protected var _fontAdjustment:int;
      
      protected var _bitmapFont:BitmapFont;
      
      protected var _lines:Vector.<LineInfo#212>;
      
      public function GTextField()
      {
         super();
         _textFormat = new TextFormat();
         _fontSize = 12;
         _color = 0;
         _align = 0;
         _verticalAlign = 0;
         _text = "";
         _leading = 3;
         _autoSize = 1;
         _widthAutoSize = true;
         _heightAutoSize = true;
         updateAutoSize();
      }
      
      override protected function createDisplayObject() : void
      {
         _textField = new UITextField(this);
         _textField.mouseEnabled = false;
         _textField.selectable = false;
         _textField.multiline = true;
         _textField.width = 10;
         _textField.height = 1;
         setDisplayObject(_textField);
      }
      
      private function switchBitmapMode(param1:Boolean) : void
      {
         if(param1 && this.displayObject == _textField)
         {
            if(_bitmap == null)
            {
               _bitmap = new UIImage(this);
            }
            switchDisplayObject(_bitmap);
         }
         else if(!param1 && this.displayObject == _bitmap)
         {
            switchDisplayObject(_textField);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(_bitmapData)
         {
            _bitmapData.dispose();
            _bitmapData = null;
         }
         _requireRender = false;
         _bitmapFont = null;
      }
      
      override public function set text(param1:String) : void
      {
         _text = param1;
         if(_text == null)
         {
            _text = "";
         }
         updateGear(6);
         if(parent && parent._underConstruct)
         {
            renderNow();
         }
         else
         {
            render();
         }
      }
      
      override public function get text() : String
      {
         return _text;
      }
      
      public final function get font() : String
      {
         return _font;
      }
      
      public function set font(param1:String) : void
      {
         if(_font != param1)
         {
            _font = param1;
            updateTextFormat();
         }
      }
      
      public final function get fontSize() : int
      {
         return _fontSize;
      }
      
      public function set fontSize(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         if(_fontSize != param1)
         {
            _fontSize = param1;
            updateTextFormat();
         }
      }
      
      public final function get color() : uint
      {
         return _color;
      }
      
      public function set color(param1:uint) : void
      {
         if(_color != param1)
         {
            _color = param1;
            updateGear(4);
            updateTextFormat();
         }
      }
      
      public final function get align() : int
      {
         return _align;
      }
      
      public function set align(param1:int) : void
      {
         if(_align != param1)
         {
            _align = param1;
            updateTextFormat();
         }
      }
      
      public final function get verticalAlign() : int
      {
         return _verticalAlign;
      }
      
      public function set verticalAlign(param1:int) : void
      {
         if(_verticalAlign != param1)
         {
            _verticalAlign = param1;
            doAlign();
         }
      }
      
      public final function get leading() : int
      {
         return _leading;
      }
      
      public function set leading(param1:int) : void
      {
         if(_leading != param1)
         {
            _leading = param1;
            updateTextFormat();
         }
      }
      
      public final function get letterSpacing() : int
      {
         return _letterSpacing;
      }
      
      public function set letterSpacing(param1:int) : void
      {
         if(_letterSpacing != param1)
         {
            _letterSpacing = param1;
            updateTextFormat();
         }
      }
      
      public final function get underline() : Boolean
      {
         return _underline;
      }
      
      public function set underline(param1:Boolean) : void
      {
         if(_underline != param1)
         {
            _underline = param1;
            updateTextFormat();
         }
      }
      
      public final function get bold() : Boolean
      {
         return _bold;
      }
      
      public function set bold(param1:Boolean) : void
      {
         if(_bold != param1)
         {
            _bold = param1;
            updateTextFormat();
         }
      }
      
      public final function get italic() : Boolean
      {
         return _italic;
      }
      
      public function set italic(param1:Boolean) : void
      {
         if(_italic != param1)
         {
            _italic = param1;
            updateTextFormat();
         }
      }
      
      public function get singleLine() : Boolean
      {
         return _singleLine;
      }
      
      public function set singleLine(param1:Boolean) : void
      {
         if(_singleLine != param1)
         {
            _singleLine = param1;
            _textField.multiline = !_singleLine;
            if(!_widthAutoSize)
            {
               _textField.wordWrap = !_singleLine;
            }
            if(!_underConstruct)
            {
               render();
            }
         }
      }
      
      public final function get stroke() : int
      {
         return _stroke;
      }
      
      public function set stroke(param1:int) : void
      {
         if(_stroke != param1)
         {
            _stroke = param1;
            updateTextFilters();
         }
      }
      
      public final function get strokeColor() : uint
      {
         return _strokeColor;
      }
      
      public function set strokeColor(param1:uint) : void
      {
         if(_strokeColor != param1)
         {
            _strokeColor = param1;
            updateTextFilters();
            updateGear(4);
         }
      }
      
      public final function get shadowOffset() : Point
      {
         return _shadowOffset;
      }
      
      public function set shadowOffset(param1:Point) : void
      {
         _shadowOffset = param1;
         updateTextFilters();
      }
      
      private function updateTextFilters() : void
      {
         if(_stroke && _shadowOffset != null)
         {
            _textFilters = [new DropShadowFilter(_stroke,45,_strokeColor,1,1,1,5,1),new DropShadowFilter(_stroke,222,_strokeColor,1,1,1,5,1),new DropShadowFilter(Math.sqrt(Math.pow(_shadowOffset.x,2) + Math.pow(_shadowOffset.y,2)),Math.atan2(_shadowOffset.y,_shadowOffset.x) * 57.2957795130823,_strokeColor,1,1,2)];
         }
         else if(_stroke)
         {
            _textFilters = [new DropShadowFilter(_stroke,45,_strokeColor,1,1,1,5,1),new DropShadowFilter(_stroke,222,_strokeColor,1,1,1,5,1)];
         }
         else if(_shadowOffset != null)
         {
            _textFilters = [new DropShadowFilter(Math.sqrt(Math.pow(_shadowOffset.x,2) + Math.pow(_shadowOffset.y,2)),Math.atan2(_shadowOffset.y,_shadowOffset.x) * 57.2957795130823,_strokeColor,1,1,2)];
         }
         else
         {
            _textFilters = null;
         }
         _textField.filters = _textFilters;
      }
      
      public function set ubbEnabled(param1:Boolean) : void
      {
         if(_ubbEnabled != param1)
         {
            _ubbEnabled = param1;
            render();
         }
      }
      
      public final function get ubbEnabled() : Boolean
      {
         return _ubbEnabled;
      }
      
      public function set autoSize(param1:int) : void
      {
         if(_autoSize != param1)
         {
            _autoSize = param1;
            _widthAutoSize = param1 == 1;
            _heightAutoSize = param1 == 1 || param1 == 2;
            updateAutoSize();
            render();
         }
      }
      
      public final function get autoSize() : int
      {
         return _autoSize;
      }
      
      public function get textWidth() : int
      {
         if(_requireRender)
         {
            renderNow();
         }
         return _textWidth;
      }
      
      override public function ensureSizeCorrect() : void
      {
         if(_sizeDirty && _requireRender)
         {
            renderNow();
         }
      }
      
      protected function updateTextFormat() : void
      {
         var _loc1_:* = null;
         _textFormat.size = _fontSize;
         if(ToolSet.startsWith(_font,"ui://"))
         {
            _bitmapFont = UIPackage.getBitmapFontByURL(_font);
            _fontAdjustment = 0;
         }
         else
         {
            _bitmapFont = null;
            if(_font)
            {
               _textFormat.font = _font;
            }
            else
            {
               _textFormat.font = UIConfig.defaultFont;
            }
            _loc1_ = CharSize.getSize(int(_textFormat.size),_textFormat.font,_bold);
            _fontAdjustment = _loc1_.yIndent;
         }
         if(this.grayed)
         {
            _textFormat.color = 11184810;
         }
         else
         {
            _textFormat.color = _color;
         }
         _textFormat.align = AlignType.toString(_align);
         _textFormat.leading = _leading - _fontAdjustment;
         _textFormat.letterSpacing = _letterSpacing;
         _textFormat.bold = _bold;
         _textFormat.underline = _underline;
         _textFormat.italic = _italic;
         _textField.defaultTextFormat = _textFormat;
         _textField.embedFonts = FontUtils.isEmbeddedFont(_textFormat);
         if(!_underConstruct)
         {
            render();
         }
      }
      
      protected function updateAutoSize() : void
      {
         if(_widthAutoSize)
         {
            _textField.autoSize = "left";
            _textField.wordWrap = false;
         }
         else
         {
            _textField.autoSize = "none";
            _textField.wordWrap = !_singleLine;
         }
      }
      
      protected function render() : void
      {
         if(!_requireRender)
         {
            _requireRender = true;
            GTimers.inst.add(0,1,__render);
         }
         if(!_sizeDirty && (_widthAutoSize || _heightAutoSize))
         {
            _sizeDirty = true;
            _dispatcher.dispatch(this,3);
         }
      }
      
      private function __render() : void
      {
         if(_requireRender)
         {
            renderNow();
         }
      }
      
      protected function renderNow(param1:Boolean = true) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         _requireRender = false;
         _sizeDirty = false;
         if(_bitmapFont != null)
         {
            renderWithBitmapFont(param1);
            return;
         }
         switchBitmapMode(false);
         _loc2_ = _width;
         if(_loc2_ != _textField.width)
         {
            _textField.width = _loc2_;
         }
         _loc4_ = Math.max(_height,int(_textFormat.size));
         if(_loc4_ != _textField.height)
         {
            _textField.height = _loc4_;
         }
         if(_ubbEnabled)
         {
            _textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(_text));
         }
         else
         {
            _textField.text = _text;
         }
         _textField.defaultTextFormat = _textFormat;
         var _loc3_:* = _textField.numLines <= 1;
         _textWidth = Math.ceil(_textField.textWidth);
         if(_textWidth > 0)
         {
            _textWidth = _textWidth + 5;
         }
         _textHeight = Math.ceil(_textField.textHeight);
         if(_textHeight > 0)
         {
            if(_loc3_)
            {
               _textHeight = _textHeight + 1;
            }
            else
            {
               _textHeight = _textHeight + 4;
            }
         }
         if(_widthAutoSize)
         {
            _loc2_ = _textWidth;
         }
         if(_heightAutoSize)
         {
            _loc4_ = _textHeight;
         }
         else
         {
            _loc4_ = _height;
         }
         if(maxHeight > 0 && _loc4_ > maxHeight)
         {
            _loc4_ = maxHeight;
         }
         if(_textHeight > _loc4_)
         {
            _textHeight = _loc4_;
         }
         _textField.height = _textHeight + _fontAdjustment + 3;
         if(param1)
         {
            _updatingSize = true;
            this.setSize(_loc2_,_loc4_);
            _updatingSize = false;
            doAlign();
         }
      }
      
      private function renderWithBitmapFont(param1:Boolean) : void
      {
         var _loc9_:* = null;
         var _loc16_:int = 0;
         var _loc30_:* = null;
         var _loc33_:int = 0;
         var _loc22_:* = null;
         var _loc24_:int = 0;
         var _loc26_:int = 0;
         var _loc29_:int = 0;
         var _loc28_:int = 0;
         var _loc17_:int = 0;
         var _loc27_:int = 0;
         var _loc25_:int = 0;
         switchBitmapMode(true);
         if(!_lines)
         {
            _lines = new Vector.<LineInfo#212>();
         }
         else
         {
            LineInfo#212.returnList(_lines);
         }
         var _loc21_:int = _letterSpacing;
         var _loc7_:int = _leading - 1;
         var _loc6_:int = this.width - 2 * 2;
         var _loc23_:* = 0;
         var _loc2_:* = 0;
         var _loc15_:* = 0;
         var _loc5_:int = 0;
         var _loc13_:int = 0;
         var _loc31_:int = 0;
         var _loc14_:* = 0;
         var _loc11_:* = 0;
         var _loc18_:* = 0;
         var _loc32_:* = "";
         var _loc19_:int = 2;
         var _loc8_:Boolean = !_widthAutoSize && !_singleLine;
         var _loc10_:Number = !!_bitmapFont.resizable?_fontSize / _bitmapFont.size:1;
         _textWidth = 0;
         _textHeight = 0;
         var _loc3_:int = _text.length;
         _loc16_ = 0;
         while(_loc16_ < _loc3_)
         {
            _loc30_ = _text.charAt(_loc16_);
            _loc33_ = _loc30_.charCodeAt(0);
            if(_loc33_ == 10)
            {
               _loc32_ = _loc32_ + _loc30_;
               _loc9_ = LineInfo#212.borrow();
               _loc9_.width = _loc23_;
               if(_loc15_ == 0)
               {
                  if(_loc18_ == 0)
                  {
                     _loc18_ = int(_fontSize);
                  }
                  if(_loc2_ == 0)
                  {
                     _loc2_ = _loc18_;
                  }
                  _loc15_ = _loc2_;
               }
               _loc9_.height = _loc2_;
               _loc18_ = _loc2_;
               _loc9_.textHeight = _loc15_;
               _loc9_.text = _loc32_;
               _loc9_.y = _loc19_;
               _loc19_ = _loc19_ + (_loc9_.height + _loc7_);
               if(_loc9_.width > _textWidth)
               {
                  _textWidth = _loc9_.width;
               }
               _lines.push(_loc9_);
               _loc32_ = "";
               _loc23_ = 0;
               _loc2_ = 0;
               _loc15_ = 0;
               _loc31_ = 0;
               _loc14_ = 0;
               _loc11_ = 0;
            }
            else
            {
               if(_loc33_ >= 65 && _loc33_ <= 90 || _loc33_ >= 97 && _loc33_ <= 122)
               {
                  if(_loc31_ == 0)
                  {
                     _loc14_ = _loc23_;
                  }
                  _loc31_++;
               }
               else
               {
                  if(_loc31_ > 0)
                  {
                     _loc11_ = _loc23_;
                  }
                  _loc31_ = 0;
               }
               if(_loc33_ == 32)
               {
                  _loc5_ = Math.ceil(_fontSize / 2);
                  _loc13_ = _fontSize;
               }
               else
               {
                  _loc22_ = _bitmapFont.glyphs[_loc30_];
                  if(_loc22_)
                  {
                     _loc5_ = Math.ceil(_loc22_.advance * _loc10_);
                     _loc13_ = Math.ceil(_loc22_.lineHeight * _loc10_);
                  }
                  else
                  {
                     _loc5_ = 0;
                     _loc13_ = 0;
                  }
               }
               if(_loc13_ > _loc15_)
               {
                  _loc15_ = _loc13_;
               }
               if(_loc13_ > _loc2_)
               {
                  _loc2_ = _loc13_;
               }
               if(_loc23_ != 0)
               {
                  _loc23_ = int(_loc23_ + _loc21_);
               }
               _loc23_ = int(_loc23_ + _loc5_);
               if(!_loc8_ || _loc23_ <= _loc6_)
               {
                  _loc32_ = _loc32_ + _loc30_;
               }
               else
               {
                  _loc9_ = LineInfo#212.borrow();
                  _loc9_.height = _loc2_;
                  _loc9_.textHeight = _loc15_;
                  if(_loc32_.length == 0)
                  {
                     _loc9_.text = _loc30_;
                  }
                  else if(_loc31_ > 0 && _loc11_ > 0)
                  {
                     _loc32_ = _loc32_ + _loc30_;
                     _loc24_ = _loc32_.length - _loc31_;
                     _loc9_.text = ToolSet.trimRight(_loc32_.substr(0,_loc24_));
                     _loc9_.width = _loc11_;
                     _loc32_ = _loc32_.substr(_loc24_);
                     _loc23_ = int(_loc23_ - _loc14_);
                  }
                  else
                  {
                     _loc9_.text = _loc32_;
                     _loc9_.width = _loc23_ - (_loc5_ + _loc21_);
                     _loc32_ = _loc30_;
                     _loc23_ = _loc5_;
                     _loc2_ = _loc13_;
                     _loc15_ = _loc13_;
                  }
                  _loc9_.y = _loc19_;
                  _loc19_ = _loc19_ + (_loc9_.height + _loc7_);
                  if(_loc9_.width > _textWidth)
                  {
                     _textWidth = _loc9_.width;
                  }
                  _loc31_ = 0;
                  _loc14_ = 0;
                  _loc11_ = 0;
                  _lines.push(_loc9_);
               }
            }
            _loc16_++;
         }
         if(_loc32_.length > 0)
         {
            _loc9_ = LineInfo#212.borrow();
            _loc9_.width = _loc23_;
            if(_loc2_ == 0)
            {
               _loc2_ = _loc18_;
            }
            if(_loc15_ == 0)
            {
               _loc15_ = _loc2_;
            }
            _loc9_.height = _loc2_;
            _loc9_.textHeight = _loc15_;
            _loc9_.text = _loc32_;
            _loc9_.y = _loc19_;
            if(_loc9_.width > _textWidth)
            {
               _textWidth = _loc9_.width;
            }
            _lines.push(_loc9_);
         }
         if(_textWidth > 0)
         {
            _textWidth = _textWidth + 2 * 2;
         }
         var _loc4_:int = _lines.length;
         if(_loc4_ == 0)
         {
            _textHeight = 0;
         }
         else
         {
            _loc9_ = _lines[_lines.length - 1];
            _textHeight = _loc9_.y + _loc9_.height + 2;
         }
         if(_widthAutoSize)
         {
            _loc29_ = _textWidth;
         }
         else
         {
            _loc29_ = this.width;
         }
         if(_heightAutoSize)
         {
            _loc26_ = _textHeight;
         }
         else
         {
            _loc26_ = this.height;
         }
         if(maxHeight > 0 && _loc26_ > maxHeight)
         {
            _loc26_ = maxHeight;
         }
         if(param1)
         {
            _updatingSize = true;
            this.setSize(_loc29_,_loc26_);
            _updatingSize = false;
            doAlign();
         }
         if(_bitmapData != null)
         {
            _bitmapData.dispose();
         }
         if(_loc29_ == 0 || _loc26_ == 0)
         {
            return;
         }
         _bitmapData = new BitmapData(_loc29_,_loc26_,true,0);
         _bitmap.bitmapData = _bitmapData;
         var _loc20_:int = 2;
         _loc6_ = this.width - 2 * 2;
         var _loc12_:int = _lines.length;
         _loc27_ = 0;
         while(_loc27_ < _loc12_)
         {
            _loc9_ = _lines[_loc27_];
            _loc20_ = 2;
            if(_align == 1)
            {
               _loc28_ = (_loc6_ - _loc9_.width) / 2;
            }
            else if(_align == 2)
            {
               _loc28_ = _loc6_ - _loc9_.width;
            }
            else
            {
               _loc28_ = 0;
            }
            _loc3_ = _loc9_.text.length;
            _loc25_ = 0;
            while(_loc25_ < _loc3_)
            {
               _loc30_ = _loc9_.text.charAt(_loc25_);
               _loc33_ = _loc30_.charCodeAt(0);
               if(_loc33_ != 10)
               {
                  if(_loc33_ == 32)
                  {
                     _loc20_ = _loc20_ + (_letterSpacing + Math.ceil(_fontSize / 2));
                  }
                  else
                  {
                     _loc22_ = _bitmapFont.glyphs[_loc30_];
                     if(_loc22_ != null)
                     {
                        _loc17_ = (_loc9_.height + _loc9_.textHeight) / 2 - Math.ceil(_loc22_.lineHeight * _loc10_);
                        _bitmapFont.draw(_bitmapData,_loc22_,_loc20_ + _loc28_,_loc9_.y + _loc17_,_color,_loc10_);
                        _loc20_ = _loc20_ + (_loc21_ + Math.ceil(_loc22_.advance * _loc10_));
                     }
                     else
                     {
                        _loc20_ = _loc20_ + _loc21_;
                     }
                  }
               }
               _loc25_++;
            }
            _loc27_++;
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         if(!_updatingSize)
         {
            if(!_widthAutoSize)
            {
               render();
            }
            else
            {
               doAlign();
            }
         }
      }
      
      override protected function handleGrayedChanged() : void
      {
         super.handleGrayedChanged();
         updateTextFormat();
      }
      
      protected function doAlign() : void
      {
         var _loc1_:Number = NaN;
         if(_verticalAlign == 0)
         {
            _yOffset = 0;
         }
         else
         {
            if(_textHeight == 0)
            {
               _loc1_ = this.height - int(_textFormat.size);
            }
            else
            {
               _loc1_ = this.height - _textHeight;
            }
            if(_loc1_ > _fontAdjustment)
            {
               if(_verticalAlign == 1)
               {
                  _yOffset = int((_loc1_ - _fontAdjustment) / 2);
               }
               else
               {
                  _yOffset = int(_loc1_);
               }
            }
            else
            {
               _yOffset = 0;
            }
         }
         _yOffset = _yOffset - _fontAdjustment;
         displayObject.y = this.y + _yOffset;
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         super.setup_beforeAdd(param1);
         _loc2_ = param1.@font;
         if(_loc2_)
         {
            _font = _loc2_;
         }
         _loc2_ = param1.@fontSize;
         if(_loc2_)
         {
            _fontSize = parseInt(_loc2_);
         }
         _loc2_ = param1.@color;
         if(_loc2_)
         {
            _color = ToolSet.convertFromHtmlColor(_loc2_);
         }
         _loc2_ = param1.@align;
         if(_loc2_)
         {
            _align = AlignType.parse(_loc2_);
         }
         _loc2_ = param1.@vAlign;
         if(_loc2_)
         {
            _verticalAlign = VertAlignType.parse(_loc2_);
         }
         _loc2_ = param1.@leading;
         if(_loc2_)
         {
            _leading = parseInt(_loc2_);
         }
         else
         {
            _leading = 3;
         }
         _loc2_ = param1.@letterSpacing;
         if(_loc2_)
         {
            _letterSpacing = parseInt(_loc2_);
         }
         _ubbEnabled = param1.@ubb == "true";
         _loc2_ = param1.@autoSize;
         if(_loc2_)
         {
            _autoSize = AutoSizeType.parse(_loc2_);
            _widthAutoSize = _autoSize == 1;
            _heightAutoSize = _autoSize == 1 || _autoSize == 2;
            updateAutoSize();
         }
         _underline = param1.@underline == "true";
         _italic = param1.@italic == "true";
         _bold = param1.@bold == "true";
         this.singleLine = param1.@singleLine == "true";
         _loc2_ = param1.@strokeColor;
         if(_loc2_)
         {
            _strokeColor = ToolSet.convertFromHtmlColor(_loc2_);
            _loc2_ = param1.@strokeSize;
            if(_loc2_)
            {
               _stroke = parseInt(_loc2_);
            }
            else
            {
               _stroke = 1;
            }
         }
         _loc2_ = param1.@shadowColor;
         if(_loc2_)
         {
            if(!_stroke)
            {
               _strokeColor = ToolSet.convertFromHtmlColor(_loc2_);
            }
            _loc2_ = param1.@shadowOffset;
            if(_loc2_)
            {
               _loc3_ = _loc2_.split(",");
               _shadowOffset = new Point(parseFloat(_loc3_[0]),parseFloat(_loc3_[1]));
            }
         }
         if(_stroke || _shadowOffset != null)
         {
            updateTextFilters();
         }
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         super.setup_afterAdd(param1);
         updateTextFormat();
         var _loc2_:String = param1.@text;
         if(_loc2_)
         {
            this.text = _loc2_;
         }
         _sizeDirty = false;
      }
   }
}

class LineInfo#212
{
   
   private static var pool:Array = [];
    
   
   public var width:int;
   
   public var height:int;
   
   public var textHeight:int;
   
   public var text:String;
   
   public var y:int;
   
   function LineInfo#212()
   {
      super();
   }
   
   public static function borrow() : LineInfo#212
   {
      var _loc1_:* = null;
      if(pool.length)
      {
         _loc1_ = pool.pop();
         _loc1_.width = 0;
         _loc1_.height = 0;
         _loc1_.textHeight = 0;
         _loc1_.text = null;
         _loc1_.y = 0;
         return _loc1_;
      }
      return new LineInfo#212();
   }
   
   public static function returns(param1:LineInfo#212) : void
   {
      pool.push(param1);
   }
   
   public static function returnList(param1:Vector.<LineInfo#212>) : void
   {
      var _loc4_:int = 0;
      var _loc3_:* = param1;
      for each(var _loc2_ in param1)
      {
         pool.push(_loc2_);
      }
      param1.length = 0;
   }
}

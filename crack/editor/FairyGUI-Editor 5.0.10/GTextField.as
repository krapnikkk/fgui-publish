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
   import fairygui.utils.UBBParser;
   import flash.display.BitmapData;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class GTextField extends GObject
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
      
      protected var _templateVars:Object;
      
      protected var _textField:TextField;
      
      protected var _bitmap:UIImage;
      
      protected var _bitmapData:BitmapData;
      
      protected var _updatingSize:Boolean;
      
      protected var _requireRender:Boolean;
      
      protected var _sizeDirty:Boolean;
      
      protected var _textWidth:int;
      
      protected var _textHeight:int;
      
      protected var _fontAdjustment:int;
      
      protected var _maxFontSize:int;
      
      protected var _bitmapFont:BitmapFont;
      
      protected var _lines:Vector.<LineInfo#770>;
      
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
         if(ToolSet.startsWith(_font,"ui://") && !(this is GRichTextField))
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
      
      protected function updateTextFieldText(param1:String) : void
      {
         if(_ubbEnabled)
         {
            _textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(param1));
            _maxFontSize = Math.max(_maxFontSize,UBBParser.inst.maxFontSize);
         }
         else
         {
            _textField.text = param1;
         }
      }
      
      protected function renderNow() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = NaN;
         _requireRender = false;
         _sizeDirty = false;
         if(_bitmapFont != null)
         {
            renderWithBitmapFont();
            return;
         }
         switchBitmapMode(false);
         _loc1_ = _width;
         if(_loc1_ != _textField.width)
         {
            _textField.width = _loc1_;
         }
         _loc3_ = Math.max(_height,int(_textFormat.size));
         if(_loc3_ != _textField.height)
         {
            _textField.height = _loc3_;
         }
         _textField.defaultTextFormat = _textFormat;
         _maxFontSize = int(_textFormat.size);
         var _loc2_:String = _text;
         if(_templateVars != null)
         {
            _loc2_ = parseTemplate(_loc2_);
         }
         updateTextFieldText(_loc2_);
         _textWidth = Math.ceil(_textField.textWidth);
         if(_textWidth > 0)
         {
            _textWidth = _textWidth + 5;
         }
         _textHeight = Math.ceil(_textField.textHeight);
         if(_textHeight > 0)
         {
            if(_textField.numLines == 1)
            {
               _textHeight = CharSize.getSize(_maxFontSize,_textFormat.font,_textFormat.bold).height;
            }
            _textHeight = _textHeight + 4;
         }
         if(_widthAutoSize)
         {
            _loc1_ = _textWidth;
         }
         else
         {
            _loc1_ = _width;
         }
         if(_heightAutoSize)
         {
            _loc3_ = _textHeight;
         }
         else
         {
            _loc3_ = _height;
         }
         if(maxHeight > 0 && _loc3_ > maxHeight)
         {
            _loc3_ = maxHeight;
         }
         if(_textHeight > _loc3_)
         {
            _textHeight = _loc3_;
         }
         _textField.height = _textHeight + _fontAdjustment + 3;
         if(_widthAutoSize || _heightAutoSize)
         {
            _updatingSize = true;
            if(_parent && _parent._underConstruct && _rawWidth == _loc1_ && _rawHeight == _loc3_)
            {
               _dispatcher.dispatch(this,2);
            }
            else
            {
               setSize(_loc1_,_loc3_);
            }
            _updatingSize = false;
         }
         doAlign();
      }
      
      private function renderWithBitmapFont() : void
      {
         var _loc3_:* = null;
         var _loc15_:int = 0;
         var _loc16_:* = null;
         var _loc13_:int = 0;
         var _loc25_:* = null;
         var _loc9_:int = 0;
         var _loc18_:int = 0;
         var _loc28_:int = 0;
         var _loc26_:int = 0;
         var _loc29_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         switchBitmapMode(true);
         if(!_lines)
         {
            _lines = new Vector.<LineInfo#770>();
         }
         else
         {
            LineInfo#770.returnList(_lines);
         }
         var _loc19_:int = _letterSpacing;
         var _loc6_:int = _leading - 1;
         var _loc1_:int = this.width - 2 * 2;
         var _loc7_:* = 0;
         var _loc30_:* = 0;
         var _loc31_:* = 0;
         var _loc32_:int = 0;
         var _loc24_:int = 0;
         var _loc8_:int = 0;
         var _loc11_:* = 0;
         var _loc10_:* = 0;
         var _loc5_:* = 0;
         var _loc23_:* = "";
         var _loc2_:int = 2;
         var _loc4_:Boolean = !_widthAutoSize && !_singleLine;
         var _loc33_:Number = !!_bitmapFont.resizable?_fontSize / _bitmapFont.size:1;
         _textWidth = 0;
         _textHeight = 0;
         var _loc27_:String = _text;
         if(_templateVars != null)
         {
            _loc27_ = parseTemplate(_loc27_);
         }
         var _loc20_:int = _loc27_.length;
         _loc15_ = 0;
         while(_loc15_ < _loc20_)
         {
            _loc16_ = _loc27_.charAt(_loc15_);
            _loc13_ = _loc16_.charCodeAt(0);
            if(_loc13_ == 10)
            {
               _loc23_ = _loc23_ + _loc16_;
               _loc3_ = LineInfo#770.borrow();
               _loc3_.width = _loc7_;
               if(_loc31_ == 0)
               {
                  if(_loc5_ == 0)
                  {
                     _loc5_ = int(_fontSize);
                  }
                  if(_loc30_ == 0)
                  {
                     _loc30_ = _loc5_;
                  }
                  _loc31_ = _loc30_;
               }
               _loc3_.height = _loc30_;
               _loc5_ = _loc30_;
               _loc3_.textHeight = _loc31_;
               _loc3_.text = _loc23_;
               _loc3_.y = _loc2_;
               _loc2_ = _loc2_ + (_loc3_.height + _loc6_);
               if(_loc3_.width > _textWidth)
               {
                  _textWidth = _loc3_.width;
               }
               _lines.push(_loc3_);
               _loc23_ = "";
               _loc7_ = 0;
               _loc30_ = 0;
               _loc31_ = 0;
               _loc8_ = 0;
               _loc11_ = 0;
               _loc10_ = 0;
            }
            else
            {
               if(_loc13_ >= 65 && _loc13_ <= 90 || _loc13_ >= 97 && _loc13_ <= 122)
               {
                  if(_loc8_ == 0)
                  {
                     _loc11_ = _loc7_;
                  }
                  _loc8_++;
               }
               else
               {
                  if(_loc8_ > 0)
                  {
                     _loc10_ = _loc7_;
                  }
                  _loc8_ = 0;
               }
               if(_loc13_ == 32)
               {
                  _loc32_ = Math.ceil(_fontSize / 2);
                  _loc24_ = _fontSize;
               }
               else
               {
                  _loc25_ = _bitmapFont.glyphs[_loc16_];
                  if(_loc25_)
                  {
                     _loc32_ = Math.ceil(_loc25_.advance * _loc33_);
                     _loc24_ = Math.ceil(_loc25_.lineHeight * _loc33_);
                  }
                  else
                  {
                     _loc32_ = 0;
                     _loc24_ = 0;
                  }
               }
               if(_loc24_ > _loc31_)
               {
                  _loc31_ = _loc24_;
               }
               if(_loc24_ > _loc30_)
               {
                  _loc30_ = _loc24_;
               }
               if(_loc7_ != 0)
               {
                  _loc7_ = int(_loc7_ + _loc19_);
               }
               _loc7_ = int(_loc7_ + _loc32_);
               if(!_loc4_ || _loc7_ <= _loc1_)
               {
                  _loc23_ = _loc23_ + _loc16_;
               }
               else
               {
                  _loc3_ = LineInfo#770.borrow();
                  _loc3_.height = _loc30_;
                  _loc3_.textHeight = _loc31_;
                  if(_loc23_.length == 0)
                  {
                     _loc3_.text = _loc16_;
                  }
                  else if(_loc8_ > 0 && _loc10_ > 0)
                  {
                     _loc23_ = _loc23_ + _loc16_;
                     _loc9_ = _loc23_.length - _loc8_;
                     _loc3_.text = ToolSet.trimRight(_loc23_.substr(0,_loc9_));
                     _loc3_.width = _loc10_;
                     _loc23_ = _loc23_.substr(_loc9_);
                     _loc7_ = int(_loc7_ - _loc11_);
                  }
                  else
                  {
                     _loc3_.text = _loc23_;
                     _loc3_.width = _loc7_ - (_loc32_ + _loc19_);
                     _loc23_ = _loc16_;
                     _loc7_ = _loc32_;
                     _loc30_ = _loc24_;
                     _loc31_ = _loc24_;
                  }
                  _loc3_.y = _loc2_;
                  _loc2_ = _loc2_ + (_loc3_.height + _loc6_);
                  if(_loc3_.width > _textWidth)
                  {
                     _textWidth = _loc3_.width;
                  }
                  _loc8_ = 0;
                  _loc11_ = 0;
                  _loc10_ = 0;
                  _lines.push(_loc3_);
               }
            }
            _loc15_++;
         }
         if(_loc23_.length > 0)
         {
            _loc3_ = LineInfo#770.borrow();
            _loc3_.width = _loc7_;
            if(_loc30_ == 0)
            {
               _loc30_ = _loc5_;
            }
            if(_loc31_ == 0)
            {
               _loc31_ = _loc30_;
            }
            _loc3_.height = _loc30_;
            _loc3_.textHeight = _loc31_;
            _loc3_.text = _loc23_;
            _loc3_.y = _loc2_;
            if(_loc3_.width > _textWidth)
            {
               _textWidth = _loc3_.width;
            }
            _lines.push(_loc3_);
         }
         if(_textWidth > 0)
         {
            _textWidth = _textWidth + 2 * 2;
         }
         var _loc17_:int = _lines.length;
         if(_loc17_ == 0)
         {
            _textHeight = 0;
         }
         else
         {
            _loc3_ = _lines[_lines.length - 1];
            _textHeight = _loc3_.y + _loc3_.height + 2;
         }
         if(_widthAutoSize)
         {
            _loc28_ = _textWidth;
         }
         else
         {
            _loc28_ = _width;
         }
         if(_heightAutoSize)
         {
            _loc18_ = _textHeight;
         }
         else
         {
            _loc18_ = _height;
         }
         if(maxHeight > 0 && _loc18_ > maxHeight)
         {
            _loc18_ = maxHeight;
         }
         if(_widthAutoSize || _heightAutoSize)
         {
            _updatingSize = true;
            if(_parent && _parent._underConstruct && _rawWidth == _loc28_ && _rawHeight == _loc18_)
            {
               _dispatcher.dispatch(this,2);
            }
            else
            {
               setSize(_loc28_,_loc18_);
            }
            _updatingSize = false;
         }
         doAlign();
         if(_bitmapData != null)
         {
            _bitmapData.dispose();
         }
         if(_loc28_ == 0 || _loc18_ == 0)
         {
            return;
         }
         _bitmapData = new BitmapData(_loc28_,_loc18_,true,0);
         var _loc14_:int = 2;
         _loc1_ = this.width - 2 * 2;
         var _loc12_:int = _lines.length;
         _loc21_ = 0;
         while(_loc21_ < _loc12_)
         {
            _loc3_ = _lines[_loc21_];
            _loc14_ = 2;
            if(_align == 1)
            {
               _loc26_ = (_loc1_ - _loc3_.width) / 2;
            }
            else if(_align == 2)
            {
               _loc26_ = _loc1_ - _loc3_.width;
            }
            else
            {
               _loc26_ = 0;
            }
            _loc20_ = _loc3_.text.length;
            _loc22_ = 0;
            while(_loc22_ < _loc20_)
            {
               _loc16_ = _loc3_.text.charAt(_loc22_);
               _loc13_ = _loc16_.charCodeAt(0);
               if(_loc13_ != 10)
               {
                  if(_loc13_ == 32)
                  {
                     _loc14_ = _loc14_ + (_letterSpacing + Math.ceil(_fontSize / 2));
                  }
                  else
                  {
                     _loc25_ = _bitmapFont.glyphs[_loc16_];
                     if(_loc25_ != null)
                     {
                        _loc29_ = (_loc3_.height + _loc3_.textHeight) / 2 - Math.ceil(_loc25_.lineHeight * _loc33_);
                        _bitmapFont.draw(_bitmapData,_loc25_,_loc14_ + _loc26_,_loc3_.y + _loc29_,_color,_loc33_);
                        _loc14_ = _loc14_ + (_loc19_ + Math.ceil(_loc25_.advance * _loc33_));
                     }
                     else
                     {
                        _loc14_ = _loc14_ + _loc19_;
                     }
                  }
               }
               _loc22_++;
            }
            _loc21_++;
         }
         _bitmap.bitmapData = _bitmapData;
         _bitmap.smoothing = true;
      }
      
      protected function parseTemplate(param1:String) : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = "";
         while(true)
         {
            _loc4_ = param1.indexOf("{",_loc3_);
            if(param1.indexOf("{",_loc3_) != -1)
            {
               if(_loc4_ > 0 && param1.charCodeAt(_loc4_ - 1) == 92)
               {
                  _loc2_ = _loc2_ + param1.substring(_loc3_,_loc4_ - 1);
                  _loc2_ = _loc2_ + "{";
                  _loc3_ = int(_loc4_ + 1);
                  continue;
               }
               _loc2_ = _loc2_ + param1.substring(_loc3_,_loc4_);
               _loc3_ = _loc4_;
               _loc4_ = param1.indexOf("}",_loc3_);
               if(_loc4_ != -1)
               {
                  if(_loc4_ == _loc3_ + 1)
                  {
                     _loc2_ = _loc2_ + param1.substr(_loc3_,2);
                     _loc3_ = int(_loc4_ + 1);
                  }
                  else
                  {
                     _loc6_ = param1.substring(_loc3_ + 1,_loc4_);
                     _loc5_ = _loc6_.indexOf("=");
                     if(_loc5_ != -1)
                     {
                        _loc7_ = _templateVars[_loc6_.substring(0,_loc5_)];
                        if(_loc7_ == null)
                        {
                           _loc2_ = _loc2_ + _loc6_.substring(_loc5_ + 1);
                        }
                        else
                        {
                           _loc2_ = _loc2_ + _loc7_;
                        }
                     }
                     else
                     {
                        _loc7_ = _templateVars[_loc6_];
                        if(_loc7_ != null)
                        {
                           _loc2_ = _loc2_ + _loc7_;
                        }
                     }
                     _loc3_ = int(_loc4_ + 1);
                  }
                  continue;
               }
               break;
            }
            break;
         }
         if(_loc3_ < param1.length)
         {
            _loc2_ = _loc2_ + param1.substr(_loc3_);
         }
         return _loc2_;
      }
      
      public function get templateVars() : Object
      {
         return _templateVars;
      }
      
      public function set templateVars(param1:Object) : void
      {
         if(_templateVars == null && param1 == null)
         {
            return;
         }
         _templateVars = param1;
         flushVars();
      }
      
      public function setVar(param1:String, param2:String) : GTextField
      {
         if(!_templateVars)
         {
            _templateVars = {};
         }
         _templateVars[param1] = param2;
         return this;
      }
      
      public function flushVars() : void
      {
         render();
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
         if(_bitmapFont)
         {
            super.handleGrayedChanged();
         }
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
            if(_verticalAlign == 1)
            {
               _yOffset = int(_loc1_ / 2);
            }
            else
            {
               _yOffset = int(_loc1_);
            }
         }
         _yOffset = _yOffset - _fontAdjustment;
         displayObject.y = this.y + _yOffset;
      }
      
      override public function getProp(param1:int) : *
      {
         switch(int(param1) - 2)
         {
            case 0:
               return this.color;
            case 1:
               return this.strokeColor;
            default:
            default:
            default:
            default:
               return super.getProp(param1);
            case 6:
               return this.fontSize;
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         switch(int(param1) - 2)
         {
            case 0:
               this.color = param2;
               break;
            case 1:
               this.strokeColor = param2;
               break;
            default:
            default:
            default:
            default:
               super.setProp(param1,param2);
               break;
            case 6:
               this.fontSize = param2;
         }
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
         if(param1.@vars == "true")
         {
            _templateVars = {};
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

class LineInfo#770
{
   
   private static var pool:Array = [];
    
   
   public var width:int;
   
   public var height:int;
   
   public var textHeight:int;
   
   public var text:String;
   
   public var y:int;
   
   function LineInfo#770()
   {
      super();
   }
   
   public static function borrow() : LineInfo#770
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
      return new LineInfo#770();
   }
   
   public static function returns(param1:LineInfo#770) : void
   {
      pool.push(param1);
   }
   
   public static function returnList(param1:Vector.<LineInfo#770>) : void
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

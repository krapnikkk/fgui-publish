package fairygui.editor.gui
{
   import fairygui.editor.gui.text.EBMGlyph;
   import fairygui.editor.gui.text.EBitmapFont;
   import fairygui.editor.settings.CommonSettings;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.CharSize;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import fairygui.utils.UBBParser;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class EGTextField extends EGObject implements EITextColorGear
   {
      
      public static const AUTOSIZE_NONE:String = "none";
      
      public static const AUTOSIZE_BOTH:String = "both";
      
      public static const AUTOSIZE_HEIGHT:String = "height";
      
      private static const GUTTER_X:int = 0;
      
      private static const GUTTER_Y:int = 0;
      
      private static const INIT_MIN_WIDTH:int = 40;
      
      private static var helperMatrix:Matrix = new Matrix();
       
      
      protected var _textField:TextField;
      
      protected var _ubbEnabled:Boolean;
      
      protected var _autoSize:String;
      
      protected var _widthAutoSize:Boolean;
      
      protected var _heightAutoSize:Boolean;
      
      protected var _textFormat:TextFormat;
      
      protected var _text:String;
      
      protected var _font:String;
      
      protected var _fontSize:int;
      
      protected var _align:String;
      
      protected var _verticalAlign:String;
      
      protected var _color:uint;
      
      protected var _leading:int;
      
      protected var _letterSpacing:int;
      
      protected var _underline:Boolean;
      
      protected var _handCursor:Boolean;
      
      protected var _input:Boolean;
      
      protected var _bold:Boolean;
      
      protected var _italic:Boolean;
      
      protected var _stroke:Boolean;
      
      protected var _strokeColor:uint;
      
      protected var _strokeSize:int;
      
      protected var _shadow:Boolean;
      
      protected var _shadowX:Number;
      
      protected var _shadowY:Number;
      
      protected var _singleLine:Boolean;
      
      protected var _fontAdjustment:int;
      
      protected var _textWidth:int;
      
      protected var _textHeight:int;
      
      protected var _updatingSize:Boolean;
      
      protected var _yOffset:int;
      
      protected var _bitmapMode:Boolean;
      
      protected var _shrinkScale:Number;
      
      protected var _promptText:String;
      
      protected var _restrict:String;
      
      protected var _maxLength:int;
      
      protected var _keyboardType:String;
      
      protected var _password:Boolean;
      
      protected var _bitmapFont:EBitmapFont;
      
      protected var _lines:Vector.<LineInfo#695>;
      
      protected var _bitmap:Bitmap;
      
      protected var _bitmapData:BitmapData;
      
      protected var _fontVersion:uint;
      
      public function EGTextField()
      {
         super();
         this.objectType = "text";
         this._textField = new TextField();
         this._textField.mouseEnabled = false;
         this._textFormat = new TextFormat();
         this._textField.defaultTextFormat = this._textFormat;
         this._fontSize = 12;
         this._color = 0;
         this._align = "left";
         this._verticalAlign = "top";
         this._text = "";
         _internalMinWidth = 10;
         this._leading = 3;
         this._strokeSize = 1;
         this._shadowX = 1;
         this._shadowY = 1;
         this._keyboardType = "";
         this._shrinkScale = 1;
         this._updatingSize = true;
         this.autoSize = "both";
         this._updatingSize = false;
         this._textField.selectable = false;
         this._textField.multiline = true;
         _useSourceSize = false;
         _displayObject.container.addChild(this._textField);
      }
      
      override public function set text(param1:String) : void
      {
         param1 = param1.replace(/\r\n/g,"\n");
         param1 = param1.replace(/\r/g,"\n");
         this._text = param1;
         this._textField.width = this.width;
         this._textField.defaultTextFormat = this._textFormat;
         if(this._input && editMode == 1)
         {
            if(!this._text && this._promptText)
            {
               this._textField.displayAsPassword = false;
               this._textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(this._promptText));
            }
            else
            {
               this._textField.displayAsPassword = this._password;
               this._textField.text = this._text;
            }
         }
         else if(this is EGRichTextField)
         {
            EGRichTextField(this).updateRichText();
         }
         else
         {
            this._textField.displayAsPassword = this._input && this._password;
            if(this._ubbEnabled)
            {
               this._textField.htmlText = UBBParser.inst.parse(UtilsStr.encodeHTML(param1));
            }
            else
            {
               this._textField.text = param1;
            }
         }
         this.updateSize();
         updateGear(6);
      }
      
      override public function get text() : String
      {
         return this._text;
      }
      
      public function get font() : String
      {
         return this._font;
      }
      
      public function set font(param1:String) : void
      {
         if(this._font != param1)
         {
            this._font = param1;
            this.updateTextFormat();
         }
      }
      
      public function get fontSize() : int
      {
         return this._fontSize;
      }
      
      public function set fontSize(param1:int) : void
      {
         if(param1 < 0)
         {
            return;
         }
         if(this._fontSize != param1)
         {
            this._fontSize = param1;
            this.updateTextFormat();
         }
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color != param1)
         {
            this._color = param1;
            updateGear(4);
            this.updateTextFormat();
         }
      }
      
      public function get align() : String
      {
         return this._align;
      }
      
      public function set align(param1:String) : void
      {
         if(this._align != param1)
         {
            this._align = param1;
            this.updateTextFormat();
         }
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign != param1)
         {
            this._verticalAlign = param1;
            this.doAlign();
         }
      }
      
      public function get leading() : int
      {
         return this._leading;
      }
      
      public function set leading(param1:int) : void
      {
         if(this._leading != param1)
         {
            this._leading = param1;
            this.updateTextFormat();
         }
      }
      
      public function get letterSpacing() : int
      {
         return this._letterSpacing;
      }
      
      public function set letterSpacing(param1:int) : void
      {
         if(this._letterSpacing != param1)
         {
            this._letterSpacing = param1;
            this.updateTextFormat();
         }
      }
      
      public function get handCursor() : Boolean
      {
         return this._handCursor;
      }
      
      public function set handCursor(param1:Boolean) : void
      {
         if(this._handCursor != param1)
         {
            this._handCursor = param1;
            this.updateTextFormat();
         }
      }
      
      public function get underline() : Boolean
      {
         return this._underline;
      }
      
      public function set underline(param1:Boolean) : void
      {
         if(this._underline != param1)
         {
            this._underline = param1;
            this.updateTextFormat();
         }
      }
      
      public function get bold() : Boolean
      {
         return this._bold;
      }
      
      public function set bold(param1:Boolean) : void
      {
         if(this._bold != param1)
         {
            this._bold = param1;
            this.updateTextFormat();
         }
      }
      
      public function get italic() : Boolean
      {
         return this._italic;
      }
      
      public function set italic(param1:Boolean) : void
      {
         if(this._italic != param1)
         {
            this._italic = param1;
            this.updateTextFormat();
         }
      }
      
      public function get stroke() : Boolean
      {
         return this._stroke;
      }
      
      public function set stroke(param1:Boolean) : void
      {
         if(this._stroke != param1)
         {
            this._stroke = param1;
            this.updateStrokeAndShadow();
         }
      }
      
      public function get strokeColor() : uint
      {
         return this._strokeColor;
      }
      
      public function set strokeColor(param1:uint) : void
      {
         if(this._strokeColor != param1)
         {
            this._strokeColor = param1;
            this.updateStrokeAndShadow();
            updateGear(4);
         }
      }
      
      public function get strokeSize() : int
      {
         return this._strokeSize;
      }
      
      public function set strokeSize(param1:int) : void
      {
         if(this._strokeSize != param1)
         {
            this._strokeSize = param1;
            this.updateStrokeAndShadow();
         }
      }
      
      private function updateStrokeAndShadow() : void
      {
         if(this._stroke && this._shadow)
         {
            _displayObject.container.filters = [new DropShadowFilter(this._strokeSize,45,this._strokeColor,1,1,1,5,1),new DropShadowFilter(this._strokeSize,222,this._strokeColor,1,1,1,5,1),new DropShadowFilter(Math.sqrt(Math.pow(this._shadowX,2) + Math.pow(this._shadowY,2)),Math.atan2(this._shadowY,this._shadowX) * 57.2957795130823,this._strokeColor,1,1,2)];
         }
         else if(this._stroke)
         {
            _displayObject.container.filters = [new DropShadowFilter(this._strokeSize,45,this._strokeColor,1,1,1,5,1),new DropShadowFilter(this._strokeSize,222,this._strokeColor,1,1,1,5,1)];
         }
         else if(this._shadow)
         {
            _displayObject.container.filters = [new DropShadowFilter(Math.sqrt(Math.pow(this._shadowX,2) + Math.pow(this._shadowY,2)),Math.atan2(this._shadowY,this._shadowX) * 57.2957795130823,this._strokeColor,1,1,2)];
         }
         else
         {
            _displayObject.container.filters = null;
         }
      }
      
      public function get shadowY() : Number
      {
         return this._shadowY;
      }
      
      public function set shadowY(param1:Number) : void
      {
         if(this._shadowY != param1)
         {
            this._shadowY = param1;
            this.updateStrokeAndShadow();
         }
      }
      
      public function get shadowX() : Number
      {
         return this._shadowX;
      }
      
      public function set shadowX(param1:Number) : void
      {
         if(this._shadowX != param1)
         {
            this._shadowX = param1;
            this.updateStrokeAndShadow();
         }
      }
      
      public function get shadow() : Boolean
      {
         return this._shadow;
      }
      
      public function set shadow(param1:Boolean) : void
      {
         if(this._shadow != param1)
         {
            this._shadow = param1;
            this.updateStrokeAndShadow();
         }
      }
      
      public function set ubbEnabled(param1:Boolean) : void
      {
         if(this._ubbEnabled != param1)
         {
            this._ubbEnabled = param1;
            this.text = this._text;
         }
      }
      
      public function get ubbEnabled() : Boolean
      {
         return this._ubbEnabled;
      }
      
      public function set autoSize(param1:String) : void
      {
         if(this._autoSize != param1)
         {
            if(this._input && editMode == 1)
            {
               param1 = "none";
            }
            this._autoSize = param1;
            this._widthAutoSize = param1 == "both";
            widthEnabled = !this._widthAutoSize;
            this._heightAutoSize = param1 == "both" || param1 == "height";
            heightEnabled = !this._heightAutoSize;
            if(this._widthAutoSize)
            {
               this._textField.autoSize = "left";
               this._textField.wordWrap = false;
            }
            else
            {
               this._textField.autoSize = "none";
               this._textField.wordWrap = !this._singleLine && this._autoSize != "shrink";
               this._textField.width = this.width;
            }
            this.updateSize();
         }
      }
      
      public function get autoSize() : String
      {
         return this._autoSize;
      }
      
      public function get selectable() : Boolean
      {
         return this._textField.selectable;
      }
      
      public function set selectable(param1:Boolean) : void
      {
         this._textField.selectable = param1;
      }
      
      public function get input() : Boolean
      {
         return this._input;
      }
      
      public function set input(param1:Boolean) : void
      {
         if(this._input != param1)
         {
            this._input = param1;
            if(this.editMode == 1 && this._input)
            {
               this._widthAutoSize = false;
               this._heightAutoSize = false;
               this._textField.type = "input";
               this._textField.mouseEnabled = true;
               this._textField.maxChars = this._maxLength;
               this._textField.autoSize = "none";
               this._textField.wordWrap = !this._singleLine;
               this._textField.width = this.width;
               this._textField.height = this.height;
               this._textField.selectable = true;
               _displayObject.mouseEnabled = this.touchable;
               _displayObject.mouseChildren = this.touchable;
               this._textField.addEventListener("focusIn",this.__focusIn);
               this._textField.addEventListener("focusOut",this.__focusOut);
            }
         }
      }
      
      public function get password() : Boolean
      {
         return this._password;
      }
      
      public function set password(param1:Boolean) : void
      {
         this._password = param1;
         this.text = this._text;
      }
      
      public function get keyboardType() : String
      {
         return this._keyboardType;
      }
      
      public function set keyboardType(param1:String) : void
      {
         this._keyboardType = param1;
      }
      
      public function get maxLength() : int
      {
         return this._maxLength;
      }
      
      public function set maxLength(param1:int) : void
      {
         this._maxLength = param1;
         this._textField.maxChars = this._maxLength;
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         this._restrict = param1;
      }
      
      public function get promptText() : String
      {
         return this._promptText;
      }
      
      public function set promptText(param1:String) : void
      {
         this._promptText = param1;
         if(!underConstruct && editMode == 1)
         {
            this.text = this._text;
         }
      }
      
      public function get singleLine() : Boolean
      {
         return this._singleLine;
      }
      
      public function set singleLine(param1:Boolean) : void
      {
         if(this._singleLine != param1)
         {
            this._singleLine = param1;
            if(!this._widthAutoSize && this._autoSize != "shrink")
            {
               this._textField.wordWrap = !this._singleLine;
            }
            this._textField.multiline = !this._singleLine;
            if(this is EGRichTextField)
            {
               this.updateTextFormat();
            }
            else
            {
               this.updateSize();
            }
         }
      }
      
      public function initFrom(param1:EGTextField) : void
      {
         if(param1 != null)
         {
            this._font = param1.font;
            this._fontSize = param1.fontSize;
            this._color = param1.color;
            this._leading = param1.leading;
            this._letterSpacing = param1.letterSpacing;
            this._bold = param1.bold;
            this._italic = param1.italic;
            this._underline = param1.underline;
            this._align = param1.align;
            this._verticalAlign = param1.verticalAlign;
            this._strokeColor = param1.strokeColor;
            this.stroke = param1.stroke;
         }
         this.updateTextFormat();
      }
      
      override public function create() : void
      {
         if(editMode == 2)
         {
            _displayObject.setDashedRect(true,null);
         }
         var _loc1_:CommonSettings = pkg.project.settingsCenter.common;
         this._fontSize = _loc1_.fontSize;
         this._color = _loc1_.textColor;
         this._fontVersion = pkg.project.globalFontVersion;
         if(EUIObjectFactory.constructingDepth == 0)
         {
            this.updateTextFormat();
         }
      }
      
      override protected function handleDispose() : void
      {
         if(this._bitmapData != null)
         {
            this._bitmapData.dispose();
            this._bitmapData = null;
         }
      }
      
      override public function get deprecated() : Boolean
      {
         if(this._bitmapFont != null && packageItemVersion != this._bitmapFont.packageItem.version || this._bitmapFont == null && this._fontVersion != pkg.project.globalFontVersion)
         {
            return true;
         }
         return false;
      }
      
      protected function updateSize(param1:Boolean = false) : void
      {
         if(this._bitmapFont)
         {
            this.updateSize_bmfont(param1);
            return;
         }
         if(this._updatingSize)
         {
            return;
         }
         this._updatingSize = true;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         this._textWidth = Math.ceil(this._textField.textWidth);
         if(this._textWidth > 0)
         {
            this._textWidth = this._textWidth + 5;
         }
         if(this._widthAutoSize)
         {
            _loc5_ = Number(this._textWidth);
         }
         else
         {
            _loc5_ = Number(_width);
         }
         this._textHeight = Math.ceil(this._textField.textHeight);
         if(this._textHeight > 0)
         {
            if(this._textField.numLines > 1)
            {
               this._textHeight = this._textHeight + 4;
            }
            else
            {
               this._textHeight = this._textHeight + 1;
            }
         }
         if(this._heightAutoSize)
         {
            _loc3_ = Number(this._textHeight);
         }
         else
         {
            _loc3_ = Number(_height);
         }
         if(_loc3_ > 0 && _loc3_ < _internalMinHeight)
         {
            _loc3_ = Number(_internalMinHeight);
         }
         if(_maxHeight > 0 && _loc3_ > _maxHeight)
         {
            _loc3_ = Number(_maxHeight);
         }
         if(this._textHeight > _loc3_)
         {
            this._textHeight = _loc3_;
         }
         if(!(this._input && editMode == 1))
         {
            this._textField.height = Math.max(this._textHeight + this._fontAdjustment + 3,_loc3_);
         }
         if(this._textWidth > _width && this._autoSize == "shrink")
         {
            this._shrinkScale = _width / this._textWidth;
         }
         else
         {
            this._shrinkScale = 1;
         }
         var _loc4_:Boolean = _settingManually;
         var _loc2_:Boolean = this.fixedByDoc;
         _settingManually = false;
         if(_loc3_ < _internalMinHeight)
         {
            _loc3_ = Number(_internalMinHeight);
         }
         if(_loc5_ == 0 && this._widthAutoSize && _width == 40)
         {
            _loc5_ = 40;
         }
         if(param1)
         {
            this.fixedByDoc = false;
            _loc5_ = Number(_rawWidth);
         }
         this.setSize(_loc5_,_loc3_);
         this.fixedByDoc = _loc2_;
         this.doAlign();
         _settingManually = _loc4_;
         this._updatingSize = false;
         this.render();
      }
      
      private function updateSize_bmfont(param1:Boolean = false) : void
      {
         var _loc14_:LineInfo = null;
         var _loc12_:int = 0;
         var _loc18_:int = 0;
         var _loc4_:String = null;
         var _loc21_:int = 0;
         var _loc6_:EBMGlyph = null;
         var _loc20_:int = 0;
         if(this._updatingSize)
         {
            return;
         }
         this._updatingSize = true;
         if(!this._lines)
         {
            this._lines = new Vector.<LineInfo#695>();
         }
         else
         {
            this._lines.length = 0;
         }
         var _loc8_:int = _width - 0 * 2;
         var _loc19_:* = 0;
         var _loc7_:* = 0;
         var _loc23_:* = 0;
         var _loc10_:int = 0;
         var _loc25_:int = 0;
         var _loc11_:int = 0;
         var _loc24_:* = 0;
         var _loc15_:* = 0;
         var _loc2_:* = 0;
         var _loc16_:* = "";
         var _loc3_:int = 0;
         var _loc9_:Number = !!this._bitmapFont.resizable?Number(this._fontSize / this._bitmapFont.size):1;
         this._textWidth = 0;
         this._textHeight = 0;
         var _loc22_:int = this._text.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc22_)
         {
            _loc4_ = this._text.charAt(_loc5_);
            _loc21_ = _loc4_.charCodeAt(0);
            if(_loc21_ == 10)
            {
               _loc16_ = _loc16_ + _loc4_;
               _loc14_ = new LineInfo#695();
               _loc14_.width = _loc19_;
               if(_loc23_ == 0)
               {
                  if(_loc2_ == 0)
                  {
                     _loc2_ = int(this._fontSize);
                  }
                  if(_loc7_ == 0)
                  {
                     _loc7_ = _loc2_;
                  }
                  _loc23_ = _loc7_;
               }
               _loc14_.height = _loc7_;
               _loc2_ = _loc7_;
               _loc14_.textHeight = _loc23_;
               _loc14_.text = _loc16_;
               _loc14_.y = _loc3_;
               _loc3_ = _loc3_ + (_loc14_.height + this._leading);
               if(_loc14_.width > this._textWidth)
               {
                  this._textWidth = _loc14_.width;
               }
               this._lines.push(_loc14_);
               _loc16_ = "";
               _loc19_ = 0;
               _loc7_ = 0;
               _loc23_ = 0;
               _loc11_ = 0;
               _loc24_ = 0;
               _loc15_ = 0;
            }
            else
            {
               if(_loc21_ >= 65 && _loc21_ <= 90 || _loc21_ >= 97 && _loc21_ <= 122)
               {
                  if(_loc11_ == 0)
                  {
                     _loc24_ = _loc19_;
                  }
                  _loc11_++;
               }
               else
               {
                  if(_loc11_ > 0)
                  {
                     _loc15_ = _loc19_;
                  }
                  _loc11_ = 0;
               }
               if(_loc21_ == 32)
               {
                  _loc10_ = Math.ceil(this._fontSize / 2);
                  _loc25_ = this._fontSize;
               }
               else
               {
                  _loc6_ = this._bitmapFont.getGlyph(_loc4_);
                  if(_loc6_)
                  {
                     _loc10_ = Math.ceil(_loc6_.advance * _loc9_);
                     _loc25_ = Math.ceil(_loc6_.lineHeight * _loc9_);
                  }
                  else
                  {
                     _loc10_ = 0;
                     _loc25_ = 0;
                  }
               }
               if(_loc25_ > _loc23_)
               {
                  _loc23_ = _loc25_;
               }
               if(_loc25_ > _loc7_)
               {
                  _loc7_ = _loc25_;
               }
               if(_loc19_ != 0)
               {
                  _loc19_ = int(_loc19_ + this._letterSpacing);
               }
               _loc19_ = int(_loc19_ + _loc10_);
               if(!this._textField.wordWrap || _loc19_ <= _loc8_)
               {
                  _loc16_ = _loc16_ + _loc4_;
               }
               else
               {
                  _loc14_ = new LineInfo#695();
                  _loc14_.height = _loc7_;
                  _loc14_.textHeight = _loc23_;
                  if(_loc16_.length == 0)
                  {
                     _loc14_.text = _loc4_;
                  }
                  else if(_loc11_ > 0 && _loc15_ > 0)
                  {
                     _loc16_ = _loc16_ + _loc4_;
                     _loc20_ = _loc16_.length - _loc11_;
                     _loc14_.text = UtilsStr.trimRight(_loc16_.substr(0,_loc20_));
                     _loc14_.width = _loc15_;
                     _loc16_ = _loc16_.substr(_loc20_);
                     _loc19_ = int(_loc19_ - _loc24_);
                  }
                  else
                  {
                     _loc14_.text = _loc16_;
                     _loc14_.width = _loc19_ - (_loc10_ + this._letterSpacing);
                     _loc16_ = _loc4_;
                     _loc19_ = _loc10_;
                     _loc7_ = _loc25_;
                     _loc23_ = _loc25_;
                  }
                  _loc14_.y = _loc3_;
                  _loc3_ = _loc3_ + (_loc14_.height + this._leading);
                  if(_loc14_.width > this._textWidth)
                  {
                     this._textWidth = _loc14_.width;
                  }
                  _loc11_ = 0;
                  _loc24_ = 0;
                  _loc15_ = 0;
                  this._lines.push(_loc14_);
               }
            }
            _loc5_++;
         }
         if(_loc16_.length > 0)
         {
            _loc14_ = new LineInfo#695();
            _loc14_.width = _loc19_;
            if(_loc7_ == 0)
            {
               _loc7_ = _loc2_;
            }
            if(_loc23_ == 0)
            {
               _loc23_ = _loc7_;
            }
            _loc14_.height = _loc7_;
            _loc14_.textHeight = _loc23_;
            _loc14_.text = _loc16_;
            _loc14_.y = _loc3_;
            if(_loc14_.width > this._textWidth)
            {
               this._textWidth = _loc14_.width;
            }
            this._lines.push(_loc14_);
         }
         if(this._textWidth > 0)
         {
            this._textWidth = this._textWidth + 0 * 2;
         }
         var _loc17_:int = this._lines.length;
         if(_loc17_ == 0)
         {
            this._textHeight = 0;
         }
         else
         {
            _loc14_ = this._lines[this._lines.length - 1];
            this._textHeight = _loc14_.y + _loc14_.height + 0;
         }
         if(this._widthAutoSize)
         {
            if(this._textWidth == 0)
            {
               _loc12_ = 0;
            }
            else
            {
               _loc12_ = this._textWidth;
            }
         }
         else
         {
            _loc12_ = _width;
         }
         if(this._heightAutoSize)
         {
            _loc18_ = this._textHeight;
         }
         else
         {
            _loc18_ = _height;
         }
         if(_maxHeight > 0 && _loc18_ > _maxHeight)
         {
            _loc18_ = _maxHeight;
         }
         if(this._textHeight > _loc18_)
         {
            this._textHeight = _loc18_;
         }
         var _loc26_:Boolean = _settingManually;
         var _loc13_:Boolean = this.fixedByDoc;
         _settingManually = false;
         if(_loc18_ < _internalMinHeight)
         {
            _loc18_ = _internalMinHeight;
         }
         if(_loc12_ == 0 && this._widthAutoSize && _width == 40)
         {
            _loc12_ = 40;
         }
         if(param1)
         {
            this.fixedByDoc = false;
            _loc12_ = _rawWidth;
         }
         this.setSize(_loc12_,_loc18_);
         this.fixedByDoc = _loc13_;
         this.doAlign();
         _settingManually = _loc26_;
         this._bitmapFont.prepareCharacters(this._text);
         this._updatingSize = false;
         this.render();
      }
      
      private function render() : void
      {
         GTimers.inst.callLater(this.delayUpdate);
      }
      
      private function delayUpdate() : void
      {
         if(this._bitmapFont)
         {
            if(this._bitmapFont.textReady)
            {
               this.buildBitmapText();
            }
            else
            {
               GTimers.inst.callLater(this.delayUpdate);
            }
         }
         else
         {
            this.buildText();
         }
      }
      
      public function get bitmapMode() : Boolean
      {
         return this._bitmapMode;
      }
      
      public function set bitmapMode(param1:Boolean) : void
      {
         if(this._bitmapMode != param1)
         {
            this._bitmapMode = param1;
            if(this._bitmapFont == null)
            {
               this.updateSize();
               if(this._bitmapMode)
               {
                  GTimers.inst.callLater(this.updateSize);
               }
            }
         }
      }
      
      private function prepareCanvas() : Boolean
      {
         if((this._bitmapFont != null || this._bitmapMode || this._shrinkScale != 1) && !this._input)
         {
            if(!this._bitmap)
            {
               this._bitmap = new Bitmap();
               this._bitmap.y = this._yOffset;
            }
            if(!this._bitmap.parent)
            {
               _displayObject.container.removeChild(this._textField);
               _displayObject.container.addChildAt(this._bitmap,0);
            }
            if(_width == 0 || _height == 0)
            {
               this._bitmap.bitmapData = null;
               return false;
            }
            if(this._bitmapData != null && (this._bitmapData.width != _width || this._bitmapData.height != _height))
            {
               this._bitmapData.dispose();
               this._bitmapData = null;
            }
            if(!this._bitmapData)
            {
               this._bitmapData = new BitmapData(_width,_height,true,0);
            }
            else
            {
               this._bitmapData.fillRect(this._bitmapData.rect,0);
            }
            this._bitmap.bitmapData = this._bitmapData;
            this._bitmap.smoothing = true;
         }
         else if(!this._textField.parent)
         {
            _displayObject.container.removeChild(this._bitmap);
            _displayObject.container.addChildAt(this._textField,0);
         }
         return true;
      }
      
      private function buildText() : void
      {
         if(!this.prepareCanvas())
         {
            return;
         }
         if(this._textField.parent)
         {
            return;
         }
         helperMatrix.identity();
         helperMatrix.scale(this._shrinkScale,this._shrinkScale);
         if(this._autoSize == "shrink" && this._shrinkScale != 1)
         {
            this._textField.autoSize = "left";
            this._bitmapData.draw(this._textField,helperMatrix,null,null,null,true);
            this._textField.autoSize = "none";
         }
         else
         {
            this._bitmapData.draw(this._textField,helperMatrix,null,null,null,true);
         }
      }
      
      private function buildBitmapText() : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:LineInfo = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:String = null;
         var _loc1_:int = 0;
         var _loc9_:EBMGlyph = null;
         if(!this.prepareCanvas())
         {
            return;
         }
         var _loc10_:int = _width - 0 * 2;
         var _loc8_:int = 0;
         var _loc11_:Rectangle = new Rectangle();
         var _loc12_:Point = new Point();
         var _loc15_:Number = !!this._bitmapFont.resizable?Number(this._fontSize / this._bitmapFont.size):1;
         var _loc14_:int = this._lines.length;
         var _loc13_:int = 0;
         while(_loc13_ < _loc14_)
         {
            _loc2_ = this._lines[_loc13_];
            _loc8_ = 0;
            if(this._align == "center")
            {
               _loc6_ = (_loc10_ - _loc2_.width) / 2;
            }
            else if(this._align == "right")
            {
               _loc6_ = _loc10_ - _loc2_.width;
            }
            else
            {
               _loc6_ = 0;
            }
            _loc4_ = _loc2_.text.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc2_.text.charAt(_loc3_);
               _loc1_ = _loc5_.charCodeAt(0);
               if(_loc1_ != 10)
               {
                  if(_loc1_ == 32)
                  {
                     _loc8_ = _loc8_ + (this._letterSpacing + Math.ceil(this._fontSize / 2));
                  }
                  else
                  {
                     _loc9_ = this._bitmapFont.getGlyph(_loc5_);
                     if(_loc9_ != null)
                     {
                        _loc7_ = (_loc2_.height + _loc2_.textHeight) / 2 - Math.ceil(_loc9_.lineHeight * _loc15_);
                        _loc12_.x = Math.ceil(_loc8_ + _loc6_);
                        _loc12_.y = Math.ceil(_loc2_.y + _loc7_);
                        this._bitmapFont.draw(this._bitmapData,_loc9_,_loc12_,this._color,_loc15_);
                        _loc8_ = _loc8_ + (this._letterSpacing + Math.ceil(_loc9_.advance * _loc15_));
                     }
                     else
                     {
                        _loc8_ = _loc8_ + this._letterSpacing;
                     }
                  }
               }
               _loc3_++;
            }
            _loc13_++;
         }
      }
      
      private function updateTextFormat() : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = null;
         var _loc1_:EPackageItem = null;
         if(this._font)
         {
            _loc3_ = this._font;
         }
         else
         {
            _loc3_ = pkg.project.settingsCenter.common.font;
         }
         if(!UtilsStr.startsWith(_loc3_,"ui://"))
         {
            this._bitmapFont = null;
            this._textFormat.font = _loc3_;
            _loc2_ = CharSize.getSize(this._fontSize,_loc3_,this._bold);
            if(pkg.project.settingsCenter.common.fontAdjustment)
            {
               this._fontAdjustment = _loc2_.yIndent;
            }
            else
            {
               this._fontAdjustment = 0;
            }
            _internalMinHeight = _loc2_.height + 4;
         }
         else
         {
            _loc1_ = pkg.project.getItemByURL(_loc3_);
            if(_loc1_ != null)
            {
               this._bitmapFont = _loc1_.owner.getBitmapFont(_loc1_);
               packageItemVersion = _loc1_.version;
               _internalMinHeight = Math.ceil(this._bitmapFont.lineHeight * (!!this._bitmapFont.resizable?this._fontSize / this._bitmapFont.size:1));
            }
            else
            {
               _internalMinHeight = 0;
               this._bitmapFont = null;
            }
            this._fontAdjustment = 0;
         }
         this._textFormat.size = this._fontSize;
         this._textFormat.bold = this._bold;
         this._textFormat.italic = this._italic;
         this._textFormat.color = this._color;
         this._textFormat.align = this._align;
         this._textFormat.leading = this._leading - this._fontAdjustment;
         this._textFormat.letterSpacing = this._letterSpacing;
         this._textFormat.underline = this._underline;
         if(this._handCursor)
         {
            this._textFormat.url = "event:x";
         }
         else
         {
            this._textFormat.url = null;
         }
         this._textField.defaultTextFormat = this._textFormat;
         this._textField.setTextFormat(this._textFormat);
         if(this._ubbEnabled)
         {
            this.text = this._text;
         }
         this.updateSize();
      }
      
      override protected function handleSizeChanged() : void
      {
         if(!this._updatingSize)
         {
            if(this._bitmapFont != null)
            {
               this.updateSize(true);
            }
            else if(!this._widthAutoSize)
            {
               this._textField.width = _width;
               this.updateSize(true);
            }
            else
            {
               this.doAlign();
            }
         }
         super.handleSizeChanged();
      }
      
      private function doAlign() : void
      {
         var _loc1_:Number = NaN;
         if(this._verticalAlign == "top")
         {
            this._yOffset = 0;
         }
         else
         {
            if(this._textHeight == 0)
            {
               _loc1_ = _height - int(int(this._textFormat.size) * this._shrinkScale);
            }
            else
            {
               _loc1_ = _height - int(this._textHeight * this._shrinkScale);
            }
            if(_loc1_ > this._fontAdjustment)
            {
               if(this._verticalAlign == "middle")
               {
                  this._yOffset = int((_loc1_ - this._fontAdjustment * this._shrinkScale) / 2);
               }
               else
               {
                  this._yOffset = int(_loc1_);
               }
            }
            else
            {
               this._yOffset = 0;
            }
         }
         this._yOffset = this._yOffset - this._fontAdjustment * this._shrinkScale;
         if(this._bitmap)
         {
            this._bitmap.y = this._yOffset;
         }
         this._textField.y = this._yOffset;
      }
      
      override public function fromXML_beforeAdd(param1:XML) : void
      {
         var _loc3_:String = null;
         var _loc2_:Array = null;
         super.fromXML_beforeAdd(param1);
         this._updatingSize = true;
         this.input = param1.@input == "true";
         if(this._input)
         {
            this._promptText = param1.@prompt;
            _loc3_ = param1.@maxLength;
            if(_loc3_)
            {
               this._maxLength = parseInt(_loc3_);
            }
            this._restrict = param1.@restrict;
            this._keyboardType = param1.@keyboardType;
            this._password = param1.@password == "true";
         }
         else if(editMode != 2)
         {
            this.displayObject.mouseChildren = false;
         }
         _loc3_ = param1.@font;
         if(_loc3_)
         {
            this._font = _loc3_;
         }
         else
         {
            this._font = null;
         }
         _loc3_ = param1.@fontSize;
         if(_loc3_)
         {
            this._fontSize = parseInt(_loc3_);
         }
         else
         {
            this._fontSize = pkg.project.settingsCenter.common.fontSize;
         }
         _loc3_ = param1.@color;
         if(_loc3_)
         {
            this._color = UtilsStr.convertFromHtmlColor(_loc3_);
         }
         else
         {
            this._color = 0;
         }
         _loc3_ = param1.@align;
         if(_loc3_)
         {
            this._align = _loc3_;
         }
         else
         {
            this._align = "left";
         }
         _loc3_ = param1.@vAlign;
         if(_loc3_)
         {
            this._verticalAlign = _loc3_;
         }
         else
         {
            this._verticalAlign = "top";
         }
         _loc3_ = param1.@leading;
         if(_loc3_)
         {
            this._leading = parseInt(_loc3_);
         }
         else
         {
            this._leading = 3;
         }
         _loc3_ = param1.@letterSpacing;
         if(_loc3_)
         {
            this._letterSpacing = parseInt(_loc3_);
         }
         else
         {
            this._letterSpacing = 0;
         }
         this._ubbEnabled = param1.@ubb == "true";
         this._underline = param1.@underline == "true";
         this._italic = param1.@italic == "true";
         this._bold = param1.@bold == "true";
         this._singleLine = param1.@singleLine == "true";
         this._textField.multiline = !this._singleLine;
         _loc3_ = param1.@strokeColor;
         if(_loc3_)
         {
            this._strokeColor = UtilsStr.convertFromHtmlColor(_loc3_);
            _loc3_ = param1.@strokeSize;
            if(_loc3_)
            {
               this._strokeSize = parseInt(_loc3_);
            }
            this.stroke = true;
         }
         _loc3_ = param1.@shadowColor;
         if(_loc3_)
         {
            if(!this._stroke)
            {
               this._strokeColor = UtilsStr.convertFromHtmlColor(_loc3_);
            }
            _loc3_ = param1.@shadowOffset;
            if(_loc3_)
            {
               _loc2_ = _loc3_.split(",");
               this._shadowX = parseFloat(_loc2_[0]);
               this._shadowY = parseFloat(_loc2_[1]);
            }
            this.shadow = true;
         }
         _loc3_ = param1.@autoSize;
         if(_loc3_)
         {
            this.autoSize = _loc3_;
         }
         else
         {
            this.autoSize = "both";
         }
         if(!this._widthAutoSize && _loc3_ != "shrink")
         {
            this._textField.wordWrap = !this._singleLine;
         }
         this.updateTextFormat();
         this._updatingSize = false;
         this.text = param1.@text;
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         if(this._input)
         {
            _loc1_.@input = true;
            if(this._promptText)
            {
               _loc1_.@prompt = this._promptText;
            }
            if(this._maxLength > 0)
            {
               _loc1_.@maxLength = this._maxLength;
            }
            if(this._restrict)
            {
               _loc1_.@restrict = this._restrict;
            }
            if(this._keyboardType)
            {
               _loc1_.@keyboardType = this._keyboardType;
            }
            if(this._password)
            {
               _loc1_.@password = "true";
            }
         }
         if(this._font)
         {
            _loc1_.@font = this._font;
         }
         _loc1_.@fontSize = this._fontSize;
         if(this._color != 0)
         {
            _loc1_.@color = UtilsStr.convertToHtmlColor(this._color);
         }
         if(this._align != "left")
         {
            _loc1_.@align = this._align;
         }
         if(this._verticalAlign != "top")
         {
            _loc1_.@vAlign = this._verticalAlign;
         }
         if(this._leading != 3)
         {
            _loc1_.@leading = this._leading;
         }
         if(this._letterSpacing != 0)
         {
            _loc1_.@letterSpacing = this._letterSpacing;
         }
         if(this._ubbEnabled)
         {
            _loc1_.@ubb = "true";
         }
         if(this._autoSize != "both")
         {
            _loc1_.@autoSize = this._autoSize;
         }
         if(this._underline)
         {
            _loc1_.@underline = "true";
         }
         if(this._bold)
         {
            _loc1_.@bold = "true";
         }
         if(this._italic)
         {
            _loc1_.@italic = "true";
         }
         if(this._stroke)
         {
            _loc1_.@strokeColor = UtilsStr.convertToHtmlColor(this._strokeColor);
            if(this._strokeSize != 1)
            {
               _loc1_.@strokeSize = this._strokeSize;
            }
         }
         if(this._shadow)
         {
            _loc1_.@shadowColor = UtilsStr.convertToHtmlColor(this._strokeColor);
            _loc1_.@shadowOffset = this._shadowX + "," + this._shadowY;
         }
         if(this._singleLine)
         {
            _loc1_.@singleLine = "true";
         }
         _loc1_.@text = this._text;
         return _loc1_;
      }
      
      private function __focusIn(param1:Event) : void
      {
         if(!this._text && this._promptText)
         {
            this._textField.displayAsPassword = this.password;
            this._textField.text = "";
         }
      }
      
      private function __focusOut(param1:Event) : void
      {
         this._text = this._textField.text;
         if(!this._text && this._promptText)
         {
            this._textField.displayAsPassword = false;
            this._textField.htmlText = ToolSet.parseUBB(ToolSet.encodeHTML(this._promptText));
         }
      }
   }
}

class LineInfo#695
{
    
   
   public var width:int;
   
   public var height:int;
   
   public var textHeight:int;
   
   public var text:String;
   
   public var y:int;
   
   function LineInfo#695()
   {
      super();
   }
}

package fairygui.editor.gui
{
   import fairygui.ObjectPropID;
   import fairygui.editor.gui.text.FBMGlyph;
   import fairygui.editor.gui.text.FBitmapFont;
   import fairygui.utils.CharSize;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import fairygui.utils.UBBParser;
   import fairygui.utils.Utils;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class FTextField extends FObject
   {
      
      public static const AUTOSIZE_NONE:String = "none";
      
      public static const AUTOSIZE_BOTH:String = "both";
      
      public static const AUTOSIZE_HEIGHT:String = "height";
      
      private static const GUTTER_X:int = 2;
      
      private static const GUTTER_Y:int = 2;
      
      private static const INIT_MIN_WIDTH:int = 40;
      
      private static var helperMatrix:Matrix = new Matrix();
       
      
      public var clearOnPublish:Boolean;
      
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
      
      protected var _varsEnabled:Boolean;
      
      protected var _textFilters:Array;
      
      protected var _maxFontSize:int;
      
      protected var _shrinkScale:Number;
      
      protected var _promptText:String;
      
      protected var _restrict:String;
      
      protected var _maxLength:int;
      
      protected var _keyboardType:int;
      
      protected var _password:Boolean;
      
      protected var _bitmapFontRef:ResourceRef;
      
      protected var _lines:Vector.<LineInfo#1187>;
      
      protected var _bitmap:Bitmap;
      
      protected var _bitmapData:BitmapData;
      
      protected var _fontVersion:uint;
      
      public function FTextField()
      {
         super();
         this._objectType = FObjectType.TEXT;
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
         this._keyboardType = 0;
         this._shrinkScale = 1;
         this._updatingSize = true;
         this.autoSize = "both";
         this._updatingSize = false;
         this._textField.selectable = false;
         this._textField.multiline = true;
         _useSourceSize = false;
         _displayObject.container.addChild(this._textField);
      }
      
      public function get nativeTextField() : TextField
      {
         return this._textField;
      }
      
      override public function set text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         param1 = param1.replace(/\r\n/g,"\n");
         param1 = param1.replace(/\r/g,"\n");
         this._text = param1;
         this._textField.width = this.width;
         if(this._textField.height < int(this._textFormat.size))
         {
            this._textField.height = int(this._textFormat.size);
         }
         this._textField.defaultTextFormat = this._textFormat;
         this._maxFontSize = 0;
         if(this._varsEnabled)
         {
            param1 = this.parseTemplate(param1);
         }
         if(this._input)
         {
            if(!this._text && this._promptText)
            {
               this._textField.displayAsPassword = false;
               this._textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(this._promptText));
            }
            else
            {
               this._textField.displayAsPassword = this._password;
               this._textField.text = param1;
            }
         }
         else if(this is FRichTextField)
         {
            FRichTextField(this).updateRichText(param1);
         }
         else
         {
            this._textField.displayAsPassword = this._input && this._password;
            if(this._ubbEnabled)
            {
               this._textField.htmlText = UBBParser.inst.parse(UtilsStr.encodeXML(param1));
               this._maxFontSize = UBBParser.inst.maxFontSize;
            }
            else
            {
               this._textField.text = param1;
            }
         }
         if(this._bitmapFontRef)
         {
            this._bitmapFontRef.displayItem.getBitmapFont().prepareCharacters(param1,_flags);
         }
         this.updateSize();
         updateGear(6);
      }
      
      protected function parseTemplate(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc2_:int = 0;
         var _loc6_:* = "";
         while((_loc3_ = param1.indexOf("{",_loc2_)) != -1)
         {
            if(_loc3_ > 0 && param1.charCodeAt(_loc3_ - 1) == 92)
            {
               _loc6_ = _loc6_ + param1.substring(_loc2_,_loc3_ - 1);
               _loc6_ = _loc6_ + "{";
               _loc2_ = _loc3_ + 1;
            }
            else
            {
               _loc6_ = _loc6_ + param1.substring(_loc2_,_loc3_);
               _loc2_ = _loc3_;
               _loc3_ = param1.indexOf("}",_loc2_);
               if(_loc3_ == -1)
               {
                  break;
               }
               if(_loc3_ == _loc2_ + 1)
               {
                  _loc6_ = _loc6_ + param1.substr(_loc2_,2);
                  _loc2_ = _loc3_ + 1;
               }
               else
               {
                  _loc5_ = param1.substring(_loc2_ + 1,_loc3_);
                  _loc4_ = _loc5_.indexOf("=");
                  if(_loc4_ != -1)
                  {
                     _loc6_ = _loc6_ + _loc5_.substring(_loc4_ + 1);
                  }
                  _loc2_ = _loc3_ + 1;
               }
            }
         }
         if(_loc2_ < param1.length)
         {
            _loc6_ = _loc6_ + param1.substr(_loc2_);
         }
         return _loc6_;
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
            updateGear(9);
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
         this._textFilters = null;
         if(this._stroke && this._shadow)
         {
            this._textFilters = [new DropShadowFilter(this._strokeSize,45,this._strokeColor,1,1,1,5,1),new DropShadowFilter(this._strokeSize,222,this._strokeColor,1,1,1,5,1),new DropShadowFilter(Math.sqrt(Math.pow(this._shadowX,2) + Math.pow(this._shadowY,2)),Math.atan2(this._shadowY,this._shadowX) * Utils.RAD_TO_DEG,this._strokeColor,1,1,2)];
         }
         else if(this._stroke)
         {
            this._textFilters = [new DropShadowFilter(this._strokeSize,45,this._strokeColor,1,1,1,5,1),new DropShadowFilter(this._strokeSize,222,this._strokeColor,1,1,1,5,1)];
         }
         else if(this._shadow)
         {
            this._textFilters = [new DropShadowFilter(Math.sqrt(Math.pow(this._shadowX,2) + Math.pow(this._shadowY,2)),Math.atan2(this._shadowY,this._shadowX) * Utils.RAD_TO_DEG,this._strokeColor,1,1,2)];
         }
         if(this._textField.parent)
         {
            this._textField.filters = this._textFilters;
         }
         else
         {
            this._bitmap.filters = this._textFilters;
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
      
      public function get varsEnabled() : Boolean
      {
         return this._varsEnabled;
      }
      
      public function set varsEnabled(param1:Boolean) : void
      {
         if(this._varsEnabled != param1)
         {
            this._varsEnabled = param1;
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
            if(this._input && (_flags & FObjectFlags.IN_TEST) != 0)
            {
               param1 = "none";
            }
            this._autoSize = param1;
            this._widthAutoSize = param1 == "both";
            _widthEnabled = !this._widthAutoSize;
            this._heightAutoSize = param1 == "both" || param1 == "height";
            _heightEnabled = !this._heightAutoSize;
            if(this._widthAutoSize)
            {
               this._textField.autoSize = TextFieldAutoSize.LEFT;
               this._textField.wordWrap = false;
            }
            else
            {
               this._textField.autoSize = TextFieldAutoSize.NONE;
               this._textField.wordWrap = !this._singleLine;
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
            this.touchDisabled = !this._input;
            if((_flags & FObjectFlags.IN_TEST) != 0 && this._input)
            {
               this._widthAutoSize = false;
               this._heightAutoSize = false;
               this._textField.type = TextFieldType.INPUT;
               this._textField.mouseEnabled = true;
               this._textField.maxChars = this._maxLength;
               this._textField.autoSize = TextFieldAutoSize.NONE;
               this._textField.wordWrap = !this._singleLine;
               this._textField.width = this.width;
               this._textField.height = this.height;
               this._textField.selectable = true;
               this._textField.addEventListener(FocusEvent.FOCUS_IN,this.__focusIn);
               this._textField.addEventListener(FocusEvent.FOCUS_OUT,this.__focusOut);
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
      
      public function get keyboardType() : int
      {
         return this._keyboardType;
      }
      
      public function set keyboardType(param1:int) : void
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
         if(!_underConstruct && this._input)
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
            if(!this._widthAutoSize)
            {
               this._textField.wordWrap = !this._singleLine;
            }
            this._textField.multiline = !this._singleLine;
            if(this is FRichTextField)
            {
               this.updateTextFormat();
            }
            else
            {
               this.updateSize();
            }
         }
      }
      
      public function initFrom(param1:FTextField) : void
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
      
      override protected function handleCreate() : void
      {
         this.touchDisabled = !(this is FRichTextField);
         this._fontSize = _pkg.project.getSetting("common","fontSize");
         this._color = _pkg.project.getSetting("common","textColor");
         if(FObjectFactory.constructingDepth == 0)
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
         if(this._bitmapFontRef)
         {
            this._bitmapFontRef.release();
            this._bitmapFontRef = null;
         }
      }
      
      override public function get deprecated() : Boolean
      {
         if(this._bitmapFontRef != null && this._bitmapFontRef.deprecated || this._bitmapFontRef == null && this._fontVersion != FProject(_pkg.project)._globalFontVersion)
         {
            return true;
         }
         return false;
      }
      
      protected function updateSize(param1:Boolean = false) : void
      {
         if(this._updatingSize)
         {
            return;
         }
         this._updatingSize = true;
         if(this._shrinkScale != 1)
         {
            this._textFormat.size = this._fontSize;
            this._textField.setTextFormat(this._textFormat);
            this._shrinkScale = 1;
         }
         if(this._bitmapFontRef)
         {
            this.buildLines();
         }
         else
         {
            this.getTextSize();
         }
         if(this._autoSize == "shrink")
         {
            this.doShrink();
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(this._widthAutoSize)
         {
            _loc2_ = this._textWidth;
         }
         else
         {
            _loc2_ = _width;
         }
         if(this._heightAutoSize)
         {
            _loc3_ = this._textHeight;
         }
         else
         {
            _loc3_ = _height;
         }
         if((_flags & FObjectFlags.INSPECTING) != 0)
         {
            if(_loc3_ > 0 && _loc3_ < _internalMinHeight)
            {
               _loc3_ = _internalMinHeight;
            }
         }
         if(_maxHeight > 0 && _loc3_ > _maxHeight)
         {
            _loc3_ = _maxHeight;
         }
         if(this._textHeight > _loc3_)
         {
            this._textHeight = _loc3_;
         }
         if(!(this._input && (_flags & FObjectFlags.IN_TEST) != 0))
         {
            this._textField.height = Math.max(this._textHeight + this._fontAdjustment + 3,_loc3_);
         }
         if((_flags & FObjectFlags.INSPECTING) != 0)
         {
            if(_loc3_ < _internalMinHeight)
            {
               _loc3_ = _internalMinHeight;
            }
            if(_loc2_ == 0 && this._widthAutoSize && _width == INIT_MIN_WIDTH)
            {
               _loc2_ = INIT_MIN_WIDTH;
            }
         }
         if(param1)
         {
            _loc2_ = _rawWidth;
         }
         if(this._widthAutoSize || this._heightAutoSize)
         {
            if((_flags & FObjectFlags.IN_TEST) != 0 && _parent && _parent._underConstruct && _rawWidth == _loc2_ && _rawHeight == _loc3_)
            {
               _dispatcher.emit(this,SIZE_CHANGED);
            }
            else
            {
               setSize(_loc2_,_loc3_,false,true);
            }
         }
         this._updatingSize = false;
         this.doAlign();
         this.render();
      }
      
      private function getTextSize() : void
      {
         if(this._textField.wordWrap && this._textField.numLines > 1)
         {
            this._textWidth = this._textField.width;
         }
         else
         {
            this._textWidth = Math.ceil(this._textField.textWidth);
            if(this._textWidth > 0)
            {
               this._textWidth = this._textWidth + 5;
            }
         }
         this._textHeight = Math.ceil(this._textField.textHeight);
         if(this._textHeight > 0)
         {
            if(this._textField.numLines == 1)
            {
               this._textHeight = CharSize.getSize(this._maxFontSize != 0?int(this._maxFontSize):int(int(this._textFormat.size)),this._textFormat.font,this._textFormat.bold).height + 4;
            }
            else
            {
               this._textHeight = this._textHeight + 4;
            }
         }
      }
      
      private function buildLines() : void
      {
         var _loc14_:LineInfo = null;
         var _loc20_:String = null;
         var _loc21_:int = 0;
         var _loc22_:FBMGlyph = null;
         var _loc23_:int = 0;
         var _loc1_:FBitmapFont = this._bitmapFontRef.displayItem.getBitmapFont();
         if(!this._lines)
         {
            this._lines = new Vector.<LineInfo#1187>();
         }
         else
         {
            this._lines.length = 0;
         }
         var _loc2_:int = _width - GUTTER_X * 2;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = "";
         var _loc13_:int = GUTTER_Y;
         var _loc15_:Number = (!!_loc1_.resizable?this._fontSize / _loc1_.size:1) * this._shrinkScale;
         this._textWidth = 0;
         this._textHeight = 0;
         var _loc16_:String = this._text;
         if(this._ubbEnabled)
         {
            _loc16_ = UBBParser.inst.parse(_loc16_,true);
         }
         var _loc17_:int = _loc16_.length;
         var _loc18_:int = 0;
         while(_loc18_ < _loc17_)
         {
            _loc20_ = _loc16_.charAt(_loc18_);
            _loc21_ = _loc20_.charCodeAt(0);
            if(_loc21_ == 10)
            {
               _loc12_ = _loc12_ + _loc20_;
               _loc14_ = new LineInfo#1187();
               _loc14_.width = _loc3_;
               if(_loc5_ == 0)
               {
                  if(_loc11_ == 0)
                  {
                     _loc11_ = this._fontSize;
                  }
                  if(_loc4_ == 0)
                  {
                     _loc4_ = _loc11_;
                  }
                  _loc5_ = _loc4_;
               }
               _loc14_.height = _loc4_;
               _loc11_ = _loc4_;
               _loc14_.textHeight = _loc5_;
               _loc14_.text = _loc12_;
               _loc14_.y = _loc13_;
               _loc13_ = _loc13_ + (_loc14_.height + this._leading);
               if(_loc14_.width > this._textWidth)
               {
                  this._textWidth = _loc14_.width;
               }
               this._lines.push(_loc14_);
               _loc12_ = "";
               _loc3_ = 0;
               _loc4_ = 0;
               _loc5_ = 0;
               _loc8_ = 0;
               _loc9_ = 0;
               _loc10_ = 0;
            }
            else
            {
               if(_loc21_ >= 65 && _loc21_ <= 90 || _loc21_ >= 97 && _loc21_ <= 122)
               {
                  if(_loc8_ == 0)
                  {
                     _loc9_ = _loc3_;
                  }
                  _loc8_++;
               }
               else
               {
                  if(_loc8_ > 0)
                  {
                     _loc10_ = _loc3_;
                  }
                  _loc8_ = 0;
               }
               if(_loc21_ == 32)
               {
                  _loc6_ = Math.ceil(this._fontSize * _loc15_ / 2);
                  _loc7_ = this._fontSize;
               }
               else
               {
                  _loc22_ = _loc1_.getGlyph(_loc20_);
                  if(_loc22_)
                  {
                     _loc6_ = Math.ceil(_loc22_.advance * _loc15_);
                     _loc7_ = Math.ceil(_loc22_.lineHeight * _loc15_);
                  }
                  else
                  {
                     _loc6_ = 0;
                     _loc7_ = 0;
                  }
               }
               if(_loc7_ > _loc5_)
               {
                  _loc5_ = _loc7_;
               }
               if(_loc7_ > _loc4_)
               {
                  _loc4_ = _loc7_;
               }
               if(_loc3_ != 0)
               {
                  _loc3_ = _loc3_ + this._letterSpacing;
               }
               _loc3_ = _loc3_ + _loc6_;
               if(!this._textField.wordWrap || _loc3_ <= _loc2_)
               {
                  _loc12_ = _loc12_ + _loc20_;
               }
               else
               {
                  _loc14_ = new LineInfo#1187();
                  _loc14_.height = _loc4_;
                  _loc14_.textHeight = _loc5_;
                  if(_loc12_.length == 0)
                  {
                     _loc14_.text = _loc20_;
                  }
                  else if(_loc8_ > 0 && _loc10_ > 0)
                  {
                     _loc12_ = _loc12_ + _loc20_;
                     _loc23_ = _loc12_.length - _loc8_;
                     _loc14_.text = UtilsStr.trimRight(_loc12_.substr(0,_loc23_));
                     _loc14_.width = _loc10_;
                     _loc12_ = _loc12_.substr(_loc23_);
                     _loc3_ = _loc3_ - _loc9_;
                  }
                  else
                  {
                     _loc14_.text = _loc12_;
                     _loc14_.width = _loc3_ - (_loc6_ + this._letterSpacing);
                     _loc12_ = _loc20_;
                     _loc3_ = _loc6_;
                     _loc4_ = _loc7_;
                     _loc5_ = _loc7_;
                  }
                  _loc14_.y = _loc13_;
                  _loc13_ = _loc13_ + (_loc14_.height + this._leading);
                  if(_loc14_.width > this._textWidth)
                  {
                     this._textWidth = _loc14_.width;
                  }
                  _loc8_ = 0;
                  _loc9_ = 0;
                  _loc10_ = 0;
                  this._lines.push(_loc14_);
               }
            }
            _loc18_++;
         }
         if(_loc12_.length > 0)
         {
            _loc14_ = new LineInfo#1187();
            _loc14_.width = _loc3_;
            if(_loc4_ == 0)
            {
               _loc4_ = _loc11_;
            }
            if(_loc5_ == 0)
            {
               _loc5_ = _loc4_;
            }
            _loc14_.height = _loc4_;
            _loc14_.textHeight = _loc5_;
            _loc14_.text = _loc12_;
            _loc14_.y = _loc13_;
            if(_loc14_.width > this._textWidth)
            {
               this._textWidth = _loc14_.width;
            }
            this._lines.push(_loc14_);
         }
         if(this._textWidth > 0)
         {
            this._textWidth = this._textWidth + GUTTER_X * 2;
         }
         var _loc19_:int = this._lines.length;
         if(_loc19_ == 0)
         {
            this._textHeight = 0;
         }
         else
         {
            _loc14_ = this._lines[this._lines.length - 1];
            this._textHeight = _loc14_.y + _loc14_.height + GUTTER_Y;
         }
      }
      
      private function resizeText(param1:int) : void
      {
         this._shrinkScale = param1 / this._fontSize;
         if(this._bitmapFontRef)
         {
            this.buildLines();
         }
         else
         {
            this._textFormat.size = param1;
            this._textField.setTextFormat(this._textFormat);
            this.getTextSize();
         }
      }
      
      protected function doShrink() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:int = !!this._bitmapFontRef?int(this._lines.length):int(this._textField.numLines);
         if(_loc3_ > 1 && this._textHeight > _height)
         {
            _loc4_ = 0;
            _loc5_ = this._fontSize;
            _loc1_ = Math.sqrt(_height / this._textHeight);
            _loc2_ = Math.floor(_loc1_ * this._fontSize);
            while(true)
            {
               this.resizeText(_loc2_);
               if(this._textWidth > _width || this._textHeight > _height)
               {
                  _loc5_ = _loc2_;
               }
               else
               {
                  _loc4_ = _loc2_;
               }
               if(_loc5_ - _loc4_ > 1 || _loc5_ != _loc4_ && _loc2_ == _loc5_)
               {
                  _loc2_ = _loc4_ + (_loc5_ - _loc4_) / 2;
                  continue;
               }
               break;
            }
         }
         else if(this._textWidth > _width)
         {
            _loc1_ = _width / this._textWidth;
            _loc2_ = Math.floor(_loc1_ * this._fontSize);
            this.resizeText(_loc2_);
            while(_loc2_ > 1 && this._textWidth > _width)
            {
               _loc2_--;
               this.resizeText(_loc2_);
            }
         }
      }
      
      private function render() : void
      {
         GTimers.inst.callLater(this.delayUpdate);
      }
      
      private function delayUpdate() : void
      {
         if(this._bitmapFontRef)
         {
            if(this._bitmapFontRef.displayItem.getBitmapFont().textReady)
            {
               this.drawBitmapText();
            }
            else
            {
               GTimers.inst.callLater(this.delayUpdate);
            }
         }
         else
         {
            this.drawText();
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
            if(this._bitmapFontRef == null)
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
         var _loc1_:int = 0;
         if((this._bitmapFontRef != null || this._bitmapMode) && !this._input)
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
            _loc1_ = _height - this._bitmap.y;
            if(_width == 0 || _loc1_ == 0)
            {
               this._bitmap.bitmapData = null;
               return false;
            }
            if(this._bitmapData != null && (this._bitmapData.width != _width || this._bitmapData.height != _loc1_))
            {
               this._bitmapData.dispose();
               this._bitmapData = null;
            }
            if(!this._bitmapData)
            {
               this._bitmapData = new BitmapData(_width,_loc1_,true,0);
            }
            else
            {
               this._bitmapData.fillRect(this._bitmapData.rect,0);
            }
            this._bitmap.bitmapData = this._bitmapData;
            this._bitmap.smoothing = true;
            if(this._bitmap.filters != this._textFilters)
            {
               this._bitmap.filters = this._textFilters;
            }
         }
         else
         {
            if(!this._textField.parent)
            {
               _displayObject.container.removeChild(this._bitmap);
               _displayObject.container.addChildAt(this._textField,0);
            }
            if(this._textField.filters != this._textFilters)
            {
               this._textField.filters = this._textFilters;
            }
         }
         return true;
      }
      
      private function drawText() : void
      {
         if(!this.prepareCanvas())
         {
            return;
         }
         if(this._textField.parent)
         {
            return;
         }
         this._bitmapData.draw(this._textField,null,null,null,null,true);
      }
      
      private function drawBitmapText() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc11_:LineInfo = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:FBMGlyph = null;
         if(!this.prepareCanvas())
         {
            return;
         }
         var _loc1_:FBitmapFont = this._bitmapFontRef.displayItem.getBitmapFont();
         var _loc2_:int = _width - GUTTER_X * 2;
         var _loc3_:int = GUTTER_X;
         var _loc6_:Rectangle = new Rectangle();
         var _loc7_:Point = new Point();
         var _loc8_:Number = (!!_loc1_.resizable?this._fontSize / _loc1_.size:1) * this._shrinkScale;
         var _loc9_:int = this._lines.length;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc11_ = this._lines[_loc10_];
            _loc3_ = GUTTER_X;
            if(this._align == "center")
            {
               _loc4_ = (_loc2_ - _loc11_.width) / 2;
            }
            else if(this._align == "right")
            {
               _loc4_ = _loc2_ - _loc11_.width;
            }
            else
            {
               _loc4_ = 0;
            }
            _loc12_ = _loc11_.text.length;
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc14_ = _loc11_.text.charAt(_loc13_);
               _loc15_ = _loc14_.charCodeAt(0);
               if(_loc15_ != 10)
               {
                  if(_loc15_ == 32)
                  {
                     _loc3_ = _loc3_ + (this._letterSpacing + Math.ceil(this._fontSize * _loc8_ / 2));
                  }
                  else
                  {
                     _loc16_ = _loc1_.getGlyph(_loc14_);
                     if(_loc16_ != null)
                     {
                        _loc5_ = (_loc11_.height + _loc11_.textHeight) / 2 - Math.ceil(_loc16_.lineHeight * _loc8_);
                        _loc7_.x = _loc3_ + _loc4_;
                        _loc7_.y = _loc11_.y + _loc5_;
                        _loc1_.draw(this._bitmapData,_loc16_,_loc7_,this._color,_loc8_,_flags);
                        _loc3_ = _loc3_ + (this._letterSpacing + Math.ceil(_loc16_.advance * _loc8_));
                     }
                     else
                     {
                        _loc3_ = _loc3_ + this._letterSpacing;
                     }
                  }
               }
               _loc13_++;
            }
            _loc10_++;
         }
      }
      
      private function updateTextFormat() : void
      {
         var _loc1_:String = null;
         var _loc2_:FPackageItem = null;
         var _loc3_:FBitmapFont = null;
         var _loc4_:Object = null;
         if(this._font)
         {
            _loc1_ = this._font;
         }
         else
         {
            _loc1_ = _pkg.project.getSetting("common","font");
         }
         if(this._bitmapFontRef)
         {
            this._bitmapFontRef.release();
            this._bitmapFontRef = null;
         }
         if(UtilsStr.startsWith(_loc1_,"ui://"))
         {
            _loc2_ = _pkg.project.getItemByURL(_loc1_);
            if(_loc2_ != null)
            {
               this._bitmapFontRef = new ResourceRef(_loc2_,null,_flags);
               _loc3_ = this._bitmapFontRef.displayItem.getBitmapFont();
               this._fontVersion = _loc2_.version;
               _internalMinHeight = Math.ceil(_loc3_.lineHeight * (!!_loc3_.resizable?this._fontSize / _loc3_.size:1));
               this._fontAdjustment = 0;
            }
            else
            {
               _loc1_ = "Arial";
            }
         }
         if(this._bitmapFontRef == null)
         {
            this._textFormat.font = _loc1_;
            this._fontVersion = FProject(_pkg.project)._globalFontVersion;
            _loc4_ = CharSize.getSize(this._fontSize,_loc1_,this._bold);
            if(_pkg.project.getSetting("common","fontAdjustment"))
            {
               this._fontAdjustment = _loc4_.yIndent;
            }
            else
            {
               this._fontAdjustment = 0;
            }
            _internalMinHeight = _loc4_.height + 4;
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
      
      override public function handleSizeChanged() : void
      {
         if(!this._updatingSize)
         {
            if(this._bitmapFontRef != null)
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
      
      protected function doAlign() : void
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
               _loc1_ = _height - int(int(this._textFormat.size));
            }
            else
            {
               _loc1_ = _height - int(this._textHeight);
            }
            if(this._verticalAlign == "middle")
            {
               this._yOffset = int(_loc1_ / 2);
            }
            else
            {
               this._yOffset = int(_loc1_);
            }
         }
         this._yOffset = this._yOffset - this._fontAdjustment;
         if(this._bitmap)
         {
            this._bitmap.y = this._yOffset;
         }
         this._textField.y = this._yOffset;
         if(this._yOffset != 0)
         {
            this._textField.height = _height - this._yOffset;
         }
      }
      
      public function copyTextFormat(param1:FTextField) : void
      {
         this._font = param1._font;
         this._fontSize = param1._fontSize;
         this._color = param1._color;
         this._align = param1._align;
         this._verticalAlign = param1._verticalAlign;
         this._leading = param1._leading;
         this._letterSpacing = param1._letterSpacing;
         this._ubbEnabled = param1._ubbEnabled;
         this._underline = param1._underline;
         this._italic = param1._italic;
         this._bold = param1._bold;
         this._singleLine = param1._singleLine;
         this._textField.multiline = param1._textField.multiline;
         this._varsEnabled = param1._varsEnabled;
         this._strokeColor = param1._strokeColor;
         this._strokeSize = param1._strokeSize;
         this.stroke = param1.stroke;
         this._shadowX = param1._shadowX;
         this._shadowY = param1._shadowY;
         this.shadow = param1.shadow;
         this.updateTextFormat();
      }
      
      override public function getProp(param1:int) : *
      {
         switch(param1)
         {
            case ObjectPropID.Color:
               return this.color;
            case ObjectPropID.OutlineColor:
               return this.strokeColor;
            case ObjectPropID.FontSize:
               return this.fontSize;
            default:
               return super.getProp(param1);
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         switch(param1)
         {
            case ObjectPropID.Color:
               this.color = param2;
               break;
            case ObjectPropID.OutlineColor:
               this.strokeColor = param2;
               break;
            case ObjectPropID.FontSize:
               this.fontSize = param2;
               break;
            default:
               super.setProp(param1,param2);
         }
      }
      
      override public function read_beforeAdd(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         super.read_beforeAdd(param1,param2);
         this._updatingSize = true;
         this.input = param1.getAttributeBool("input");
         if(this._input)
         {
            this._promptText = param1.getAttribute("prompt","");
            if(param2)
            {
               _loc5_ = param2[_id + "-prompt"];
               if(_loc5_ != undefined)
               {
                  this._promptText = _loc5_;
               }
            }
            this._maxLength = param1.getAttributeInt("maxLength");
            this._restrict = param1.getAttribute("restrict");
            this._keyboardType = param1.getAttributeInt("keyboardType");
            this._password = param1.getAttributeBool("password");
            this.touchDisabled = false;
            handleTouchableChanged();
         }
         this._font = param1.getAttribute("font");
         this._fontSize = param1.getAttributeInt("fontSize",_pkg.project.getSetting("common","fontSize"));
         this._color = param1.getAttributeColor("color",false,0);
         this._align = param1.getAttribute("align","left");
         this._verticalAlign = param1.getAttribute("vAlign","top");
         this._leading = param1.getAttributeInt("leading",3);
         this._letterSpacing = param1.getAttributeInt("letterSpacing");
         this._ubbEnabled = param1.getAttributeBool("ubb");
         this._varsEnabled = param1.getAttributeBool("vars");
         this._underline = param1.getAttributeBool("underline");
         this._italic = param1.getAttributeBool("italic");
         this._bold = param1.getAttributeBool("bold");
         this._singleLine = param1.getAttributeBool("singleLine");
         this._textField.multiline = !this._singleLine;
         _loc3_ = param1.getAttribute("strokeColor");
         if(_loc3_)
         {
            this._strokeColor = UtilsStr.convertFromHtmlColor(_loc3_);
            this._strokeSize = param1.getAttributeInt("strokeSize",1);
            this.stroke = true;
         }
         _loc3_ = param1.getAttribute("shadowColor");
         if(_loc3_)
         {
            if(!this._stroke)
            {
               this._strokeColor = UtilsStr.convertFromHtmlColor(_loc3_);
            }
            _loc3_ = param1.getAttribute("shadowOffset");
            if(_loc3_)
            {
               _loc4_ = _loc3_.split(",");
               this._shadowX = parseFloat(_loc4_[0]);
               this._shadowY = parseFloat(_loc4_[1]);
            }
            this.shadow = true;
         }
         _loc3_ = param1.getAttribute("autoSize","both");
         this.autoSize = _loc3_;
         if(!this._widthAutoSize)
         {
            this._textField.wordWrap = !this._singleLine;
         }
         this.clearOnPublish = param1.getAttributeBool("autoClearText");
         this.updateTextFormat();
         this._updatingSize = false;
         _loc3_ = param1.getAttribute("text","");
         if(_loc3_ || this._input)
         {
            if(param2)
            {
               _loc5_ = param2[_id];
               if(_loc5_ != undefined)
               {
                  _loc3_ = _loc5_;
               }
            }
            this.text = _loc3_;
         }
      }
      
      override public function write() : XData
      {
         var _loc1_:XData = super.write();
         if(this._input)
         {
            _loc1_.setAttribute("input",true);
            if(this._promptText)
            {
               _loc1_.setAttribute("prompt",this._promptText);
            }
            if(this._maxLength > 0)
            {
               _loc1_.setAttribute("maxLength",this._maxLength);
            }
            if(this._restrict)
            {
               _loc1_.setAttribute("restrict",this._restrict);
            }
            if(this._keyboardType)
            {
               _loc1_.setAttribute("keyboardType",this._keyboardType);
            }
            if(this._password)
            {
               _loc1_.setAttribute("password",true);
            }
         }
         if(this._font)
         {
            _loc1_.setAttribute("font",this._font);
         }
         _loc1_.setAttribute("fontSize",this._fontSize);
         if(this._color != 0)
         {
            _loc1_.setAttribute("color",UtilsStr.convertToHtmlColor(this._color));
         }
         if(this._align != "left")
         {
            _loc1_.setAttribute("align",this._align);
         }
         if(this._verticalAlign != "top")
         {
            _loc1_.setAttribute("vAlign",this._verticalAlign);
         }
         if(this._leading != 3)
         {
            _loc1_.setAttribute("leading",this._leading);
         }
         if(this._letterSpacing != 0)
         {
            _loc1_.setAttribute("letterSpacing",this._letterSpacing);
         }
         if(this._ubbEnabled)
         {
            _loc1_.setAttribute("ubb",true);
         }
         if(this._varsEnabled)
         {
            _loc1_.setAttribute("vars",true);
         }
         if(this._autoSize != "both")
         {
            _loc1_.setAttribute("autoSize",this._autoSize);
         }
         if(this._underline)
         {
            _loc1_.setAttribute("underline",true);
         }
         if(this._bold)
         {
            _loc1_.setAttribute("bold",true);
         }
         if(this._italic)
         {
            _loc1_.setAttribute("italic",true);
         }
         if(this._stroke)
         {
            _loc1_.setAttribute("strokeColor",UtilsStr.convertToHtmlColor(this._strokeColor));
            if(this._strokeSize != 1)
            {
               _loc1_.setAttribute("strokeSize",this._strokeSize);
            }
         }
         if(this._shadow)
         {
            _loc1_.setAttribute("shadowColor",UtilsStr.convertToHtmlColor(this._strokeColor));
            _loc1_.setAttribute("shadowOffset",this._shadowX + "," + this._shadowY);
         }
         if(this._singleLine)
         {
            _loc1_.setAttribute("singleLine",true);
         }
         if(this.clearOnPublish)
         {
            _loc1_.setAttribute("autoClearText",true);
         }
         _loc1_.setAttribute("text",this._text);
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
            this._textField.htmlText = UBBParser.inst.parse(ToolSet.encodeHTML(this._promptText));
         }
      }
   }
}

class LineInfo#1187
{
    
   
   public var width:int;
   
   public var height:int;
   
   public var textHeight:int;
   
   public var text:String;
   
   public var y:int;
   
   function LineInfo#1187()
   {
      super();
   }
}

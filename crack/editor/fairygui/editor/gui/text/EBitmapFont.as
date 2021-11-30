package fairygui.editor.gui.text
{
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class EBitmapFont
   {
      
      private static var sHelperRect:Rectangle = new Rectangle();
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sPoint0:Point = new Point();
      
      private static var sHelperTransform:ColorTransform = new ColorTransform();
      
      private static var sHelperMatrix:Matrix = new Matrix();
       
      
      public var packageItem:EPackageItem;
      
      public var atlasItem:EPackageItem;
      
      public var xadvance:int;
      
      public var base:int;
      
      public var size:int;
      
      public var resizable:Boolean;
      
      public var colored:Boolean;
      
      public var lineHeight:int;
      
      private var _dict:Object;
      
      private var _srcId:String;
      
      private var _loading:int;
      
      private var _packed:Boolean;
      
      private var _outlineChannel:int;
      
      private var _ttf:Boolean;
      
      private var _previewChars:String;
      
      public function EBitmapFont()
      {
         super();
      }
      
      public function load() : void
      {
         var _loc8_:String = null;
         var _loc11_:Array = null;
         var _loc10_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:* = false;
         var _loc3_:Object = null;
         var _loc9_:String = null;
         var _loc1_:Array = null;
         var _loc6_:int = 0;
         var _loc12_:Array = null;
         var _loc2_:String = null;
         var _loc4_:EBMGlyph = null;
         var _loc13_:EPackageItem = null;
         this._dict = {};
         this.xadvance = 0;
         this.base = 0;
         this.size = 0;
         this.lineHeight = 0;
         this.resizable = false;
         this.colored = false;
         this._previewChars = "";
         try
         {
            _loc8_ = UtilsFile.loadString(this.packageItem.file);
            if(_loc8_ == null)
            {
               return;
            }
            _loc11_ = _loc8_.split("\n");
            _loc10_ = _loc11_.length;
            _loc3_ = {};
            _loc7_ = 0;
            while(_loc7_ < _loc10_)
            {
               _loc9_ = _loc11_[_loc7_];
               if(_loc9_)
               {
                  _loc9_ = UtilsStr.trim(_loc9_);
                  _loc1_ = _loc9_.split(" ");
                  _loc6_ = 1;
                  while(_loc6_ < _loc1_.length)
                  {
                     _loc12_ = _loc1_[_loc6_].split("=");
                     _loc3_[_loc12_[0]] = _loc12_[1];
                     _loc6_++;
                  }
                  _loc9_ = _loc1_[0];
                  if(_loc9_ == "char")
                  {
                     _loc2_ = String.fromCharCode(_loc3_.id);
                     if(this._previewChars.length < 20)
                     {
                        this._previewChars = this._previewChars + _loc2_;
                     }
                     if(this._ttf)
                     {
                        _loc4_ = new EBMGlyph();
                        _loc4_.imgId = _loc3_.img;
                        _loc4_.x = _loc3_.x;
                        _loc4_.y = _loc3_.y;
                        _loc4_.offsetX = _loc3_.xoffset;
                        _loc4_.offsetY = _loc3_.yoffset;
                        _loc4_.width = _loc3_.width;
                        _loc4_.height = _loc3_.height;
                        _loc4_.advance = _loc3_.xadvance;
                        _loc4_.channel = this.translateChannel(_loc3_.chnl);
                        _loc4_.lineHeight = this.lineHeight;
                        this._dict[_loc2_] = _loc4_;
                     }
                     else
                     {
                        _loc13_ = this.packageItem.owner.getItem(_loc3_.img);
                        if(_loc13_ && _loc13_.imageInfo != null)
                        {
                           _loc4_ = new EBMGlyph();
                           _loc4_.imgId = _loc3_.img;
                           _loc4_.offsetX = _loc3_.xoffset;
                           _loc4_.offsetY = _loc3_.yoffset;
                           _loc4_.width = _loc13_.width;
                           _loc4_.height = _loc13_.height;
                           _loc4_.advance = _loc3_.xadvance;
                           if(_loc4_.advance == 0)
                           {
                              if(this.xadvance == 0)
                              {
                                 _loc4_.advance = _loc4_.width + _loc4_.offsetX;
                              }
                              else
                              {
                                 _loc4_.advance = this.xadvance;
                              }
                           }
                           _loc4_.lineHeight = _loc4_.offsetY < 0?int(_loc4_.height):int(_loc4_.offsetY + _loc4_.height);
                           if(this.size > 0 && _loc4_.lineHeight < this.size)
                           {
                              _loc4_.lineHeight = this.size;
                           }
                           this._dict[_loc2_] = _loc4_;
                        }
                     }
                  }
                  else if(_loc9_ == "info")
                  {
                     this._ttf = _loc3_.face != null;
                     this.colored = this._ttf;
                     _loc5_ = int(_loc3_.outline) > 0;
                     this.size = int(_loc3_.size);
                     this.resizable = _loc3_.resizable == "true";
                     if(_loc3_.colored != undefined)
                     {
                        this.colored = _loc3_.colored == "true";
                     }
                  }
                  else if(_loc9_ == "common")
                  {
                     this.lineHeight = _loc3_.lineHeight;
                     if(this.size == 0)
                     {
                        this.size = this.lineHeight;
                     }
                     else if(this.lineHeight == 0)
                     {
                        this.lineHeight = this.size;
                     }
                     this.xadvance = _loc3_.xadvance;
                     this.base = _loc3_.base;
                     this._packed = _loc3_.packed == "1";
                     if(_loc5_)
                     {
                        if(_loc3_.alphaChnl == 1)
                        {
                           this._outlineChannel = 8;
                        }
                        else if(_loc3_.redChnl == 1)
                        {
                           this._outlineChannel = 1;
                        }
                        else if(_loc3_.greenChnl == 1)
                        {
                           this._outlineChannel = 2;
                        }
                        else if(_loc3_.blueChnl == 1)
                        {
                           this._outlineChannel = 4;
                        }
                        else
                        {
                           this._outlineChannel = -1;
                        }
                     }
                     else
                     {
                        this._outlineChannel = -1;
                     }
                  }
               }
               _loc7_++;
            }
            if(this.size == 0 && _loc4_)
            {
               this.size = _loc4_.height;
            }
            if(this.lineHeight == 0)
            {
               this.lineHeight = this.size;
            }
            return;
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      private function translateChannel(param1:int) : int
      {
         switch(int(param1) - 1)
         {
            case 0:
               return 4;
            case 1:
               return 2;
            default:
               return 0;
            case 3:
            default:
            default:
            default:
               return 1;
            case 7:
               return 8;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:EBMGlyph = null;
         if(this._dict != null)
         {
            var _loc3_:int = 0;
            var _loc2_:* = this._dict;
            for each(_loc1_ in this._dict)
            {
               if(_loc1_.bitmapData != null && _loc1_.item == null)
               {
                  _loc1_.bitmapData.dispose();
               }
               if(_loc1_.outlineBitmapData != null)
               {
                  _loc1_.outlineBitmapData.dispose();
               }
            }
            this._dict = null;
         }
         this._loading = 0;
      }
      
      public function get textReady() : Boolean
      {
         return this._loading == 0;
      }
      
      public function getPreviewURL() : String
      {
         var _loc1_:EBMGlyph = null;
         if(this._previewChars.length > 0)
         {
            if(this._ttf)
            {
               return "ui://" + this.packageItem.owner.id + this.packageItem.fontTexture;
            }
            _loc1_ = this._dict[this._previewChars.charAt(0)];
            if(_loc1_)
            {
               return "ui://" + this.packageItem.owner.id + _loc1_.imgId;
            }
            return null;
         }
         return null;
      }
      
      public function prepareCharacters(param1:String) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc2_:EBMGlyph = null;
         if(this._dict == null)
         {
            return;
         }
         if(this._ttf)
         {
            if(this.atlasItem == null)
            {
               this.atlasItem = this.packageItem.owner.getItem(this.packageItem.fontTexture);
            }
            if(this.atlasItem != null)
            {
               this._loading++;
               this.atlasItem.owner.getImage(this.atlasItem,this.__imageLoaded2);
            }
         }
         else
         {
            _loc5_ = param1.length;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc4_ = param1.charAt(_loc3_);
               _loc2_ = this._dict[_loc4_];
               if(_loc2_)
               {
                  if(_loc2_.imgId && _loc2_.item == null)
                  {
                     _loc2_.item = this.packageItem.owner.getItem(_loc2_.imgId);
                     if(_loc2_.item && !_loc2_.item.data)
                     {
                        this._loading++;
                        _loc2_.item.owner.getImage(_loc2_.item,this.__imageLoaded);
                     }
                  }
               }
               _loc3_++;
            }
         }
      }
      
      private function __imageLoaded(param1:EPackageItem) : void
      {
         this._loading--;
      }
      
      private function __imageLoaded2(param1:EPackageItem) : void
      {
         this._loading--;
      }
      
      public function getGlyph(param1:String) : EBMGlyph
      {
         if(this._dict == null)
         {
            return null;
         }
         return this._dict[param1];
      }
      
      public function draw(param1:BitmapData, param2:EBMGlyph, param3:Point, param4:uint, param5:Number) : void
      {
         var _loc6_:BitmapData = null;
         var _loc8_:BitmapData = null;
         var _loc7_:BitmapData = null;
         param3.x = param3.x + Math.ceil(param2.offsetX * param5);
         param3.y = param3.y + Math.ceil(param2.offsetY * param5);
         param4 = param4 & 16777215;
         if(this._ttf)
         {
            _loc8_ = BitmapData(this.atlasItem.data);
            if(_loc8_ == null)
            {
               return;
            }
            if(param2.bitmapData == null)
            {
               if(param2.width != 0 && param2.height != 0)
               {
                  _loc7_ = new BitmapData(param2.width,param2.height,true,0);
                  sHelperRect.x = param2.x;
                  sHelperRect.y = param2.y;
                  sHelperRect.width = param2.width;
                  sHelperRect.height = param2.height;
                  if(param2.channel == 0)
                  {
                     _loc7_.copyPixels(_loc8_,sHelperRect,sPoint0);
                  }
                  else
                  {
                     _loc7_.fillRect(_loc7_.rect,4294967295);
                     _loc7_.copyChannel(_loc8_,sHelperRect,sPoint0,param2.channel,8);
                  }
                  param2.bitmapData = _loc7_;
               }
               else
               {
                  param2.bitmapData = new BitmapData(1,1,true,0);
               }
            }
         }
         else if(param2.bitmapData == null && param2.item != null)
         {
            param2.bitmapData = BitmapData(param2.item.data);
         }
         if(param2.bitmapData != null)
         {
            sHelperMatrix.identity();
            sHelperMatrix.scale(param5,param5);
            sHelperMatrix.translate(param3.x,param3.y);
            sHelperRect.x = param3.x;
            sHelperRect.y = param3.y;
            sHelperRect.width = Math.ceil(param2.width * param5);
            sHelperRect.height = Math.ceil(param2.height * param5);
            if(this.colored)
            {
               sHelperTransform.redMultiplier = (param4 >> 16 & 255) / 255;
               sHelperTransform.greenMultiplier = (param4 >> 8 & 255) / 255;
               sHelperTransform.blueMultiplier = (param4 & 255) / 255;
               param1.draw(param2.bitmapData,sHelperMatrix,sHelperTransform,null,sHelperRect,true);
            }
            else
            {
               param1.draw(param2.bitmapData,sHelperMatrix,null,null,sHelperRect,true);
            }
         }
      }
   }
}

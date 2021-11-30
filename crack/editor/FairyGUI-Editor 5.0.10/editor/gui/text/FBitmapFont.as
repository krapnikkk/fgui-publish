package fairygui.editor.gui.text
{
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.gui.ResourceRef;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FBitmapFont
   {
      
      private static var sHelperRect:Rectangle = new Rectangle();
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sPoint0:Point = new Point();
      
      private static var sHelperTransform:ColorTransform = new ColorTransform();
      
      private static var sHelperMatrix:Matrix = new Matrix();
       
      
      public var xadvance:int;
      
      public var base:int;
      
      public var size:int;
      
      public var resizable:Boolean;
      
      public var colored:Boolean;
      
      public var lineHeight:int;
      
      private var _packageItem:FPackageItem;
      
      private var _atlasRes:ResourceRef;
      
      private var _scaledAtlasRes:ResourceRef;
      
      private var _dict:Object;
      
      private var _srcId:String;
      
      private var _loading:int;
      
      private var _packed:Boolean;
      
      private var _outlineChannel:int;
      
      private var _ttf:Boolean;
      
      private var _previewChars:String;
      
      private var _loadingChars:Vector.<FPackageItem>;
      
      public function FBitmapFont(param1:FPackageItem)
      {
         super();
         this._packageItem = param1;
         this._loadingChars = new Vector.<FPackageItem>();
      }
      
      public function get packageItem() : FPackageItem
      {
         return this._packageItem;
      }
      
      public function load() : void
      {
         var content:String = null;
         var lines:Array = null;
         var lineCount:int = 0;
         var i:int = 0;
         var outline:Boolean = false;
         var kv:Object = null;
         var str:String = null;
         var arr:Array = null;
         var j:int = 0;
         var arr2:Array = null;
         var char:String = null;
         var glyph:FBMGlyph = null;
         var pi:FPackageItem = null;
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
            content = UtilsFile.loadString(this._packageItem.file);
            if(content == null)
            {
               return;
            }
            lines = content.split("\n");
            lineCount = lines.length;
            kv = {};
            i = 0;
            while(i < lineCount)
            {
               str = lines[i];
               if(str)
               {
                  str = UtilsStr.trim(str);
                  arr = str.split(" ");
                  j = 1;
                  while(j < arr.length)
                  {
                     arr2 = arr[j].split("=");
                     kv[arr2[0]] = arr2[1];
                     j++;
                  }
                  str = arr[0];
                  if(str == "char")
                  {
                     char = String.fromCharCode(kv.id);
                     if(this._previewChars.length < 20)
                     {
                        this._previewChars = this._previewChars + char;
                     }
                     if(this._ttf)
                     {
                        glyph = new FBMGlyph();
                        glyph.imgId = kv.img;
                        glyph.x = kv.x;
                        glyph.y = kv.y;
                        glyph.offsetX = kv.xoffset;
                        glyph.offsetY = kv.yoffset;
                        glyph.width = kv.width;
                        glyph.height = kv.height;
                        glyph.advance = kv.xadvance;
                        glyph.channel = this.translateChannel(kv.chnl);
                        glyph.lineHeight = this.lineHeight;
                        this._dict[char] = glyph;
                     }
                     else
                     {
                        pi = this._packageItem.owner.getItem(kv.img);
                        if(pi && pi.imageSettings)
                        {
                           glyph = new FBMGlyph();
                           glyph.imgId = kv.img;
                           glyph.offsetX = kv.xoffset;
                           glyph.offsetY = kv.yoffset;
                           glyph.width = pi.width;
                           glyph.height = pi.height;
                           glyph.advance = kv.xadvance;
                           if(glyph.advance == 0)
                           {
                              if(this.xadvance == 0)
                              {
                                 glyph.advance = glyph.width + glyph.offsetX;
                              }
                              else
                              {
                                 glyph.advance = this.xadvance;
                              }
                           }
                           glyph.lineHeight = glyph.offsetY < 0?int(glyph.height):int(glyph.offsetY + glyph.height);
                           if(this.size > 0 && glyph.lineHeight < this.size)
                           {
                              glyph.lineHeight = this.size;
                           }
                           this._dict[char] = glyph;
                        }
                     }
                  }
                  else if(str == "info")
                  {
                     this._ttf = kv.face != null;
                     this.colored = this._ttf;
                     outline = int(kv.outline) > 0;
                     this.size = int(kv.size);
                     this.resizable = kv.resizable == "true";
                     if(kv.colored != undefined)
                     {
                        this.colored = kv.colored == "true";
                     }
                  }
                  else if(str == "common")
                  {
                     this.lineHeight = kv.lineHeight;
                     if(this.size == 0)
                     {
                        this.size = this.lineHeight;
                     }
                     else if(this.lineHeight == 0)
                     {
                        this.lineHeight = this.size;
                     }
                     this.xadvance = kv.xadvance;
                     this.base = kv.base;
                     this._packed = kv.packed == "1";
                     if(outline)
                     {
                        if(kv.alphaChnl == 1)
                        {
                           this._outlineChannel = BitmapDataChannel.ALPHA;
                        }
                        else if(kv.redChnl == 1)
                        {
                           this._outlineChannel = BitmapDataChannel.RED;
                        }
                        else if(kv.greenChnl == 1)
                        {
                           this._outlineChannel = BitmapDataChannel.GREEN;
                        }
                        else if(kv.blueChnl == 1)
                        {
                           this._outlineChannel = BitmapDataChannel.BLUE;
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
               i++;
            }
            if(this.size == 0)
            {
               this.resizable = false;
            }
            if(this.lineHeight == 0)
            {
               this.lineHeight = this.size;
            }
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      private function translateChannel(param1:int) : int
      {
         switch(param1)
         {
            case 1:
               return BitmapDataChannel.BLUE;
            case 2:
               return BitmapDataChannel.GREEN;
            case 4:
               return BitmapDataChannel.RED;
            case 8:
               return BitmapDataChannel.ALPHA;
            default:
               return 0;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:FBMGlyph = null;
         if(this._dict != null)
         {
            for each(_loc1_ in this._dict)
            {
               if(_loc1_.res)
               {
                  _loc1_.res.release();
               }
               if(_loc1_.scaledRes)
               {
                  _loc1_.scaledRes.release();
               }
               if(_loc1_.bitmapData != null)
               {
                  _loc1_.bitmapData.dispose();
               }
               if(_loc1_.scaledBitmapData != null)
               {
                  _loc1_.scaledBitmapData.dispose();
               }
            }
            this._dict = null;
         }
         this._loading = 0;
         if(this._atlasRes)
         {
            this._atlasRes.release();
         }
         if(this._scaledAtlasRes)
         {
            this._scaledAtlasRes.release();
         }
      }
      
      public function get textReady() : Boolean
      {
         return this._loading == 0 && this._loadingChars.length == 0;
      }
      
      public function get ttf() : Boolean
      {
         return this._ttf;
      }
      
      public function getPreviewURL() : String
      {
         var _loc1_:FBMGlyph = null;
         if(this._packageItem.fontSettings.texture)
         {
            return "ui://" + this._packageItem.owner.id + this._packageItem.fontSettings.texture;
         }
         if(this._previewChars.length > 0)
         {
            if(this._ttf)
            {
               return "ui://" + this._packageItem.owner.id + this._packageItem.fontSettings.texture;
            }
            _loc1_ = this._dict[this._previewChars.charAt(0)];
            if(_loc1_)
            {
               return "ui://" + this._packageItem.owner.id + _loc1_.imgId;
            }
            return null;
         }
         return null;
      }
      
      public function prepareCharacters(param1:String, param2:int) : void
      {
         var _loc3_:FPackageItem = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:FBMGlyph = null;
         if(this._dict == null)
         {
            return;
         }
         var _loc4_:* = param2 & 15;
         if(this._ttf)
         {
            if(_loc4_ != 0)
            {
               if(!this._scaledAtlasRes)
               {
                  _loc3_ = this._packageItem.owner.getItem(this._packageItem.fontSettings.texture);
                  if(!_loc3_)
                  {
                     return;
                  }
                  this._scaledAtlasRes = new ResourceRef(_loc3_,null,param2);
               }
               if(!this._scaledAtlasRes.displayItem.getImage(this.__imageLoaded2))
               {
                  this._loading = 1;
               }
            }
            else
            {
               if(!this._atlasRes)
               {
                  _loc3_ = this._packageItem.owner.getItem(this._packageItem.fontSettings.texture);
                  if(!_loc3_)
                  {
                     return;
                  }
                  this._atlasRes = new ResourceRef(_loc3_,null,param2);
               }
               if(!this._atlasRes.displayItem.getImage(this.__imageLoaded2))
               {
                  this._loading = 1;
               }
            }
         }
         else
         {
            _loc5_ = param1.length;
            _loc6_ = 0;
            for(; _loc6_ < _loc5_; _loc6_++)
            {
               _loc7_ = param1.charAt(_loc6_);
               _loc8_ = this._dict[_loc7_];
               if(!(!_loc8_ || !_loc8_.imgId))
               {
                  if(_loc4_ != 0)
                  {
                     if(!_loc8_.scaledRes)
                     {
                        _loc3_ = this._packageItem.owner.getItem(_loc8_.imgId);
                        if(!_loc3_)
                        {
                           continue;
                        }
                        _loc8_.scaledRes = new ResourceRef(_loc3_,null,_loc4_);
                        _loc3_ = _loc8_.scaledRes.displayItem;
                        if(!_loc3_.getImage(this.__imageLoaded) && this._loadingChars.indexOf(_loc3_) == -1)
                        {
                           this._loadingChars.push(_loc3_);
                        }
                     }
                  }
                  else if(!_loc8_.res)
                  {
                     _loc3_ = this._packageItem.owner.getItem(_loc8_.imgId);
                     if(_loc3_)
                     {
                        _loc8_.res = new ResourceRef(_loc3_);
                        _loc3_ = _loc8_.res.displayItem;
                        if(!_loc3_.getImage(this.__imageLoaded) && this._loadingChars.indexOf(_loc3_) == -1)
                        {
                           this._loadingChars.push(_loc3_);
                           continue;
                        }
                     }
                     continue;
                  }
               }
            }
         }
      }
      
      private function __imageLoaded(param1:FPackageItem) : void
      {
         var _loc2_:int = this._loadingChars.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._loadingChars.splice(_loc2_,1);
         }
      }
      
      private function __imageLoaded2(param1:FPackageItem) : void
      {
         this._loading = 0;
      }
      
      public function getGlyph(param1:String) : FBMGlyph
      {
         if(this._dict == null)
         {
            return null;
         }
         return this._dict[param1];
      }
      
      public function draw(param1:BitmapData, param2:FBMGlyph, param3:Point, param4:uint, param5:Number, param6:int) : void
      {
         var _loc7_:BitmapData = null;
         var _loc8_:ResourceRef = null;
         var _loc10_:BitmapData = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         param3.x = param3.x + Math.ceil(param2.offsetX * param5);
         param3.y = param3.y + Math.ceil(param2.offsetY * param5);
         param4 = param4 & 16777215;
         var _loc9_:* = (param6 & 15) != 0;
         if(this._ttf)
         {
            _loc8_ = !!_loc9_?this._scaledAtlasRes:this._atlasRes;
            if(!_loc8_)
            {
               return;
            }
            _loc10_ = _loc8_.displayItem.image;
            if(!_loc10_)
            {
               return;
            }
            _loc7_ = !!_loc9_?param2.scaledBitmapData:param2.bitmapData;
            if(!_loc7_)
            {
               if(param2.width != 0 && param2.height != 0)
               {
                  _loc11_ = _loc10_.width / _loc8_.sourceWidth;
                  _loc12_ = _loc10_.height / _loc8_.sourceHeight;
                  _loc7_ = new BitmapData(param2.width * _loc11_,param2.height * _loc12_,true,0);
                  sHelperRect.x = param2.x * _loc11_;
                  sHelperRect.y = param2.y * _loc12_;
                  sHelperRect.width = _loc7_.width;
                  sHelperRect.height = _loc7_.height;
                  if(param2.channel == 0)
                  {
                     _loc7_.copyPixels(_loc10_,sHelperRect,sPoint0);
                  }
                  else
                  {
                     _loc7_.fillRect(_loc7_.rect,4294967295);
                     _loc7_.copyChannel(_loc10_,sHelperRect,sPoint0,param2.channel,BitmapDataChannel.ALPHA);
                  }
               }
               else
               {
                  _loc7_ = new BitmapData(1,1,true,0);
               }
               if(_loc9_)
               {
                  param2.scaledBitmapData = _loc7_;
               }
               else
               {
                  param2.bitmapData = _loc7_;
               }
            }
         }
         else
         {
            _loc8_ = !!_loc9_?param2.scaledRes:param2.res;
            if(!_loc8_)
            {
               return;
            }
            _loc7_ = _loc8_.displayItem.image;
         }
         if(_loc7_)
         {
            sHelperMatrix.identity();
            sHelperMatrix.scale(param5 * param2.width / _loc7_.width,param5 * param2.height / _loc7_.height);
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
               param1.draw(_loc7_,sHelperMatrix,sHelperTransform,null,sHelperRect,true);
            }
            else
            {
               param1.draw(_loc7_,sHelperMatrix,null,null,sHelperRect,true);
            }
         }
      }
   }
}

package fairygui.editor.animation
{
   import dragonBones.flash.FlashFactory;
   import dragonBones.objects.DragonBonesData;
   import fairygui.editor.pack.MaxRects;
   import fairygui.editor.pack.MaxRectsPacker;
   import fairygui.editor.pack.NodeRect;
   import fairygui.editor.pack.Page;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.settings.AtlasSettings;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PNGEncoderOptions;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import spine.atlas.AtlasPage;
   import spine.atlas.AtlasRegion;
   import spine.atlas.Format;
   import spine.atlas.TextureFilter;
   import spine.atlas.TextureWrap;
   
   public class BoneDef
   {
      
      public static const FILE_MARK:String = "fybonetou";
      
      public static const FILE_MARK_SPINE:String = "fyspinetou";
       
      
      public var version:int;
      
      public var boundsRect:Rectangle;
      
      public var fps:int;
      
      public var speed:int;
      
      public var repeatDelay:int;
      
      public var swing:Boolean;
      
      public var ready:Boolean;
      
      public var ref:int;
      
      public var releasedTime:int;
      
      public var decoding:Boolean;
      
      public var queued:Boolean;
      
      public var textureToDecode:int;
      
      public var texture:AniTexture;
      
      public var texJson:String;
      
      public var skeJson:String;
      
      public var c_texture:AniTexture;
      
      public var c_texJson:String;
      
      public var c_skeJson:String;
      
      public var _boneName:String;
      
      public var armatureName:String;
      
      public var fileByt:ByteArray;
      
      public var movieTye:int = 0;
      
      private var settings:AtlasSettings;
      
      public function BoneDef()
      {
         super();
         this.version = 102;
         this.speed = 1;
         this.fps = 24;
         this.boundsRect = new Rectangle();
         this.texture = new AniTexture();
         this.c_texture = new AniTexture();
         this.c_texJson = "";
         this.c_skeJson = "";
         this.texJson = "";
         this.skeJson = "";
         this.boneName = "";
         this.armatureName = "";
         this.fileByt = new ByteArray();
         this.settings = new AtlasSettings();
         settings.extractAlpha = false;
         settings.pot = false;
         settings.maxWidth = 1024;
         settings.maxWidth = 1024;
         settings.multiPage = false;
      }
      
      public function set boneName(param1:String) : void
      {
         this._boneName = param1;
      }
      
      public function get boneName() : String
      {
         return this._boneName;
      }
      
      public function load(param1:ByteArray) : void
      {
         var _loc12_:int = 0;
         var _loc17_:int = 0;
         var _loc8_:int = 0;
         if(param1.length <= 36)
         {
            return;
         }
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc15_:AniFrame = null;
         var _loc16_:ByteArray = null;
         var _loc21_:AniTexture = null;
         var _loc19_:int = 0;
         var _loc20_:Array = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc11_:String = param1.readUTF();
         if(_loc11_ != "fybonetou" && _loc11_ != "fyspinetou")
         {
            throw new Error("wrong jta format");
         }
         if(_loc11_ == "fybonetou")
         {
            this.movieTye = 1;
         }
         else if(_loc11_ == "fyspinetou")
         {
            this.movieTye = 2;
         }
         this.reset();
         this.version = param1.readInt();
         this.fps = param1.readByte();
         if(this.fps == 0)
         {
            this.fps = 24;
         }
         var _loc10_:int = 0;
         var _loc18_:int = 0;
         _loc10_ = param1.readInt();
         this.skeJson = param1.readUTFBytes(_loc10_);
         var _loc22_:Object = JSON.parse(this.skeJson);
         if(this.movieTye == 1)
         {
            _loc12_ = 0;
            while(_loc12_ < _loc22_.armature.length)
            {
               _loc22_.armature[_loc12_].name = _loc22_.name + "_" + _loc12_;
               _loc12_++;
            }
         }
         this.skeJson = JSON.stringify(_loc22_);
         if(this.movieTye == 1)
         {
            this.boneName = _loc22_.name;
            this.armatureName = _loc22_.armature[0].name;
         }
         _loc22_ = null;
         _loc18_ = param1.readInt();
         this.texJson = param1.readUTFBytes(_loc18_);
         var _loc2_:int = param1.readInt();
         var _loc3_:int = param1.readInt();
         var _loc14_:ByteArray = new ByteArray();
         if(this.version == 100)
         {
            param1.readBytes(_loc14_);
         }
         else if(this.version >= 101)
         {
            _loc17_ = param1.readInt();
            param1.readBytes(_loc14_,0,_loc17_);
         }
         var _loc13_:BitmapData = new BitmapData(_loc2_,_loc3_,true,0);
         _loc14_.position = 0;
         _loc13_.setPixels(new Rectangle(0,0,_loc2_,_loc3_),_loc14_);
         this.texture.bitmapData = _loc13_;
         this.texture.raw = texture.bitmapData.encode(texture.bitmapData.rect,new PNGEncoderOptions());
         if(this.version <= 101 && _loc22_)
         {
            this.boneName = _loc22_.name;
         }
         else if(this.version == 102)
         {
            _loc8_ = param1.readInt();
            this.boneName = param1.readUTFBytes(_loc8_);
         }
      }
      
      protected function parseSpineAtlas(param1:String) : Object
      {
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc9_:* = null;
         var _loc14_:int = 0;
         var _loc13_:int = 0;
         var _loc5_:int = 0;
         var _loc10_:int = 0;
         var _loc7_:Array = [];
         var _loc11_:Reader = new Reader#576(param1);
         var _loc3_:Array = [];
         _loc3_.length = 4;
         var _loc12_:AtlasPage = null;
         var _loc8_:Object = {
            "info":{},
            "datas":{}
         };
         while(true)
         {
            _loc6_ = _loc11_.readLine();
            if(_loc6_ != null)
            {
               _loc6_ = _loc11_.trim(_loc6_);
               if(_loc6_.length == 0)
               {
                  _loc12_ = null;
               }
               else if(!_loc12_)
               {
                  _loc12_ = new AtlasPage();
                  _loc12_.name = _loc6_;
                  _loc8_.info.name = _loc6_;
                  if(_loc11_.readTuple(_loc3_) == 2)
                  {
                     _loc12_.width = parseInt(_loc3_[0]);
                     _loc12_.height = parseInt(_loc3_[1]);
                     _loc8_.info.width = parseInt(_loc3_[0]);
                     _loc8_.info.height = parseInt(_loc3_[1]);
                     _loc11_.readTuple(_loc3_);
                  }
                  _loc12_.format = Format[_loc3_[0]];
                  _loc8_.info.format = _loc3_[0];
                  _loc11_.readTuple(_loc3_);
                  _loc12_.minFilter = TextureFilter[_loc3_[0]];
                  _loc12_.magFilter = TextureFilter[_loc3_[1]];
                  _loc8_.info.filter = _loc3_[0] + "," + _loc3_[1];
                  _loc4_ = _loc11_.readValue();
                  _loc8_.info.repeat = _loc4_;
                  _loc12_.uWrap = TextureWrap.clampToEdge;
                  _loc12_.vWrap = TextureWrap.clampToEdge;
                  if(_loc4_ == "x")
                  {
                     _loc12_.uWrap = TextureWrap.repeat;
                  }
                  else if(_loc4_ == "y")
                  {
                     _loc12_.vWrap = TextureWrap.repeat;
                  }
                  else if(_loc4_ == "xy")
                  {
                     var _loc15_:* = TextureWrap.repeat;
                     _loc12_.vWrap = _loc15_;
                     _loc12_.uWrap = _loc15_;
                  }
               }
               else
               {
                  _loc2_ = new AtlasRegion();
                  _loc2_.name = _loc6_;
                  _loc2_.page = _loc12_;
                  _loc8_.datas[_loc6_] = {};
                  _loc9_ = _loc11_.readValue();
                  _loc8_.datas[_loc6_]["rotate"] = _loc9_;
                  if(_loc9_ == "true")
                  {
                     _loc2_.degrees = 90;
                  }
                  else if(_loc9_ == "false")
                  {
                     _loc2_.degrees = 0;
                  }
                  else
                  {
                     _loc2_.degrees = parseInt(_loc9_);
                  }
                  _loc2_.rotate = _loc2_.degrees == 90;
                  _loc11_.readTuple(_loc3_);
                  _loc14_ = parseInt(_loc3_[0]);
                  _loc13_ = parseInt(_loc3_[1]);
                  _loc8_.datas[_loc6_]["xy"] = _loc3_[0] + "," + _loc3_[1];
                  _loc11_.readTuple(_loc3_);
                  _loc5_ = parseInt(_loc3_[0]);
                  _loc10_ = parseInt(_loc3_[1]);
                  _loc8_.datas[_loc6_]["size"] = _loc3_[0] + "," + _loc3_[1];
                  _loc2_.u = _loc14_ / _loc12_.width;
                  _loc2_.v = _loc13_ / _loc12_.height;
                  if(_loc2_.rotate)
                  {
                     _loc2_.u2 = (_loc14_ + _loc10_) / _loc12_.width;
                     _loc2_.v2 = (_loc13_ + _loc5_) / _loc12_.height;
                  }
                  else
                  {
                     _loc2_.u2 = (_loc14_ + _loc5_) / _loc12_.width;
                     _loc2_.v2 = (_loc13_ + _loc10_) / _loc12_.height;
                  }
                  _loc2_.x = _loc14_;
                  _loc2_.y = _loc13_;
                  _loc2_.width = Math.abs(_loc5_);
                  _loc2_.height = Math.abs(_loc10_);
                  if(_loc11_.readTuple(_loc3_) == 4)
                  {
                     _loc2_.splits = new Vector.<int>(parseInt(_loc3_[0]),parseInt(_loc3_[1]),parseInt(_loc3_[2]),parseInt(_loc3_[3]));
                     if(_loc11_.readTuple(_loc3_) == 4)
                     {
                        _loc2_.pads = new Vector.<int>(parseInt(_loc3_[0]),parseInt(_loc3_[1]),parseInt(_loc3_[2]),parseInt(_loc3_[3]));
                        _loc11_.readTuple(_loc3_);
                     }
                  }
                  _loc2_.originalWidth = parseInt(_loc3_[0]);
                  _loc2_.originalHeight = parseInt(_loc3_[1]);
                  _loc8_.datas[_loc6_]["orig"] = _loc3_[0] + "," + _loc3_[1];
                  _loc11_.readTuple(_loc3_);
                  _loc2_.offsetX = parseInt(_loc3_[0]);
                  _loc2_.offsetY = parseInt(_loc3_[1]);
                  _loc8_.datas[_loc6_]["offset"] = _loc3_[0] + "," + _loc3_[1];
                  _loc2_.index = parseInt(_loc11_.readValue());
                  _loc8_.datas[_loc6_]["index"] = _loc2_.index;
                  _loc7_[_loc7_.length] = _loc2_;
               }
               continue;
            }
            break;
         }
         return {
            "spineData":_loc8_,
            "regions":_loc7_
         };
      }
      
      public function scasleBitmap() : void
      {
         var _loc39_:* = null;
         var _loc32_:int = 0;
         var _loc36_:* = null;
         var _loc20_:int = 0;
         var _loc5_:int = 0;
         var _loc37_:* = null;
         var _loc2_:* = null;
         var _loc24_:* = undefined;
         var _loc13_:* = null;
         _loc32_ = 0;
         _loc36_ = null;
         var _loc19_:* = null;
         var _loc16_:* = null;
         var _loc3_:int = 0;
         var _loc30_:int = 0;
         _loc32_ = 0;
         _loc36_ = null;
         var _loc22_:* = null;
         var _loc25_:* = null;
         var _loc21_:* = null;
         var _loc35_:* = null;
         var _loc34_:int = 0;
         var _loc12_:* = null;
         _loc32_ = 0;
         var _loc7_:* = null;
         _loc30_ = 0;
         var _loc18_:* = null;
         var _loc31_:int = 0;
         var _loc26_:* = null;
         var _loc11_:* = null;
         var _loc4_:* = null;
         var _loc28_:int = 0;
         var _loc8_:* = null;
         _loc28_ = 0;
         _loc32_ = 0;
         var _loc23_:* = null;
         _loc30_ = 0;
         var _loc15_:* = null;
         _loc31_ = 0;
         var _loc33_:* = null;
         _loc11_ = null;
         _loc30_ = 0;
         var _loc10_:* = null;
         _loc31_ = 0;
         _loc33_ = null;
         _loc4_ = null;
         _loc28_ = 0;
         _loc30_ = 0;
         _loc15_ = null;
         _loc11_ = null;
         var _loc9_:* = null;
         var _loc6_:* = null;
         var _loc29_:* = null;
         _loc32_ = 0;
         var _loc1_:* = null;
         _loc20_ = 0;
         _loc5_ = 0;
         _loc37_ = null;
         _loc2_ = null;
         _loc24_ = undefined;
         _loc13_ = null;
         var _loc27_:* = null;
         _loc32_ = 0;
         _loc22_ = null;
         _loc25_ = null;
         _loc21_ = null;
         var _loc14_:* = null;
         var _loc17_:MaxRects = new MaxRects();
         _loc17_.init(1024,1024,false);
         var _loc38_:Vector.<NodeRect> = new Vector.<NodeRect>();
         if(this.movieTye == 1)
         {
            _loc39_ = JSON.parse(this.texJson);
            _loc32_ = 0;
            while(_loc32_ < _loc39_.SubTexture.length)
            {
               _loc36_ = _loc39_.SubTexture[_loc32_];
               _loc20_ = PlugInManager.ceil_fy(_loc36_.width * PlugInManager.FYOUT);
               _loc5_ = PlugInManager.ceil_fy(_loc36_.height * PlugInManager.FYOUT);
               _loc37_ = {
                  "name":_loc36_.name,
                  "x":_loc36_.x,
                  "y":_loc36_.y,
                  "width":_loc36_.width,
                  "height":_loc36_.height
               };
               _loc38_.push(new NodeRect(0,0,_loc20_,_loc5_,_loc37_));
               _loc32_++;
            }
            this.settings.compression = PlugInManager.COMPRESS;
            _loc2_ = new MaxRectsPacker(settings);
            _loc24_ = _loc2_.pack(_loc38_);
            _loc13_ = _loc24_[0];
            _loc32_ = 0;
            while(_loc32_ < _loc39_.SubTexture.length)
            {
               _loc36_ = _loc39_.SubTexture[_loc32_];
               if(_loc36_.hasOwnProperty("frameWidth"))
               {
                  _loc36_.frameWidth = PlugInManager.ceil_fy(_loc36_.frameWidth * PlugInManager.FYOUT);
               }
               if(_loc36_.hasOwnProperty("frameHeight"))
               {
                  _loc36_.frameHeight = PlugInManager.ceil_fy(_loc36_.frameHeight * PlugInManager.FYOUT);
               }
               if(_loc36_.hasOwnProperty("frameX"))
               {
                  _loc36_.frameX = PlugInManager.ceil_fy(_loc36_.frameX * PlugInManager.FYOUT);
               }
               if(_loc36_.hasOwnProperty("frameY"))
               {
                  _loc36_.frameY = PlugInManager.ceil_fy(_loc36_.frameY * PlugInManager.FYOUT);
               }
               _loc36_.num = 1;
               _loc32_++;
            }
            _loc19_ = new Bitmap();
            _loc19_.bitmapData = new BitmapData(_loc13_.width,_loc13_.height,true,0);
            _loc16_ = JSON.parse(this.texJson);
            _loc3_ = 0;
            _loc30_ = 0;
            while(_loc30_ < _loc13_.outputRects.length)
            {
               _loc32_ = 0;
               while(_loc32_ < _loc39_.SubTexture.length)
               {
                  _loc36_ = _loc39_.SubTexture[_loc32_];
                  _loc22_ = _loc13_.outputRects[_loc30_];
                  if(_loc22_.srcParams.name == _loc36_.name)
                  {
                     _loc25_ = new Matrix();
                     _loc25_.translate(-_loc22_.srcParams.x,-_loc22_.srcParams.y);
                     _loc25_.scale(PlugInManager.FYOUT,PlugInManager.FYOUT);
                     _loc21_ = new BitmapData(_loc22_.width,_loc22_.height,true,0);
                     _loc21_.draw(this.texture.bitmapData,_loc25_,null,null,new Rectangle(0,0,_loc22_.srcParams.width,_loc22_.srcParams.height),true);
                     _loc19_.bitmapData.copyPixels(_loc21_,new Rectangle(0,0,_loc21_.width,_loc21_.height),new Point(_loc22_.x,_loc22_.y),null,null,true);
                     _loc21_.dispose();
                     _loc21_ = null;
                     _loc36_.x = _loc22_.x;
                     _loc36_.y = _loc22_.y;
                     _loc36_.width = _loc22_.width;
                     _loc36_.height = _loc22_.height;
                  }
                  _loc32_++;
               }
               _loc30_++;
            }
            _loc39_.width = _loc19_.bitmapData.width;
            _loc39_.height = _loc19_.bitmapData.height;
            this.c_texture.bitmapData = _loc19_.bitmapData;
            this.c_texJson = JSON.stringify(_loc39_);
            _loc19_ = null;
            _loc35_ = JSON.parse(this.skeJson);
            _loc34_ = 0;
            while(_loc34_ < _loc35_.armature.length)
            {
               _loc12_ = _loc35_.armature[_loc34_];
               _loc12_.aabb.width = PlugInManager.ceil(_loc12_.aabb.width * PlugInManager.FYOUT);
               _loc12_.aabb.height = PlugInManager.ceil(_loc12_.aabb.height * PlugInManager.FYOUT);
               _loc12_.aabb.x = PlugInManager.ceil(_loc12_.aabb.x * PlugInManager.FYOUT);
               _loc12_.aabb.y = PlugInManager.ceil(_loc12_.aabb.y * PlugInManager.FYOUT);
               _loc32_ = 0;
               while(_loc32_ < _loc12_.skin.length)
               {
                  _loc7_ = _loc12_.skin[_loc32_];
                  _loc30_ = 0;
                  while(_loc30_ < _loc7_.slot.length)
                  {
                     _loc18_ = _loc7_.slot[_loc30_];
                     _loc31_ = 0;
                     while(_loc31_ < _loc18_.display.length)
                     {
                        _loc26_ = _loc18_.display[_loc31_];
                        _loc11_ = _loc26_.transform;
                        if(_loc11_.hasOwnProperty("x"))
                        {
                           _loc11_.x = PlugInManager.ceil(_loc11_.x * PlugInManager.FYOUT);
                        }
                        if(_loc11_.hasOwnProperty("y"))
                        {
                           _loc11_.y = PlugInManager.ceil(_loc11_.y * PlugInManager.FYOUT);
                        }
                        _loc4_ = _loc26_.vertices;
                        if(_loc4_ && _loc4_.length > 0)
                        {
                           _loc28_ = 0;
                           while(_loc28_ < _loc4_.length)
                           {
                              _loc4_[_loc28_] = PlugInManager.ceil(_loc4_[_loc28_] * PlugInManager.FYOUT);
                              _loc28_++;
                           }
                        }
                        _loc8_ = _loc26_.bonePose;
                        if(_loc8_ && _loc8_.length > 0)
                        {
                           this;
                           _loc28_ = 0;
                           while(_loc28_ < _loc8_.length)
                           {
                              if((_loc28_ + 1) % 7 == 6 || (_loc28_ + 1) % 7 == 0)
                              {
                                 _loc8_[_loc28_] = PlugInManager.ceil(_loc8_[_loc28_] * PlugInManager.FYOUT);
                              }
                              _loc28_++;
                           }
                        }
                        if(_loc26_.hasOwnProperty("width"))
                        {
                           _loc26_.width = PlugInManager.floor_fy(_loc26_.width * PlugInManager.FYOUT);
                        }
                        if(_loc26_.hasOwnProperty("height"))
                        {
                           _loc26_.height = PlugInManager.floor_fy(_loc26_.height * PlugInManager.FYOUT);
                        }
                        _loc31_++;
                     }
                     _loc30_++;
                  }
                  _loc32_++;
               }
               _loc32_ = 0;
               while(_loc32_ < _loc12_.animation.length)
               {
                  _loc23_ = _loc12_.animation[_loc32_];
                  _loc30_ = 0;
                  while(_loc30_ < _loc23_.bone.length)
                  {
                     _loc15_ = _loc23_.bone[_loc30_];
                     _loc31_ = 0;
                     while(_loc31_ < _loc15_.frame.length)
                     {
                        _loc33_ = _loc15_.frame[_loc31_];
                        _loc11_ = _loc33_.transform;
                        if(_loc11_.hasOwnProperty("x"))
                        {
                           _loc11_.x = PlugInManager.ceil(_loc11_.x * PlugInManager.FYOUT);
                        }
                        if(_loc11_.hasOwnProperty("y"))
                        {
                           _loc11_.y = PlugInManager.ceil(_loc11_.y * PlugInManager.FYOUT);
                        }
                        _loc31_++;
                     }
                     _loc30_++;
                  }
                  _loc30_ = 0;
                  while(_loc30_ < _loc23_.ffd.length)
                  {
                     _loc10_ = _loc23_.ffd[_loc30_];
                     _loc31_ = 0;
                     while(_loc31_ < _loc10_.frame.length)
                     {
                        _loc33_ = _loc10_.frame[_loc31_];
                        _loc4_ = _loc33_.vertices;
                        if(_loc4_ && _loc4_.length > 0)
                        {
                           _loc28_ = 0;
                           while(_loc28_ < _loc4_.length)
                           {
                              _loc4_[_loc28_] = PlugInManager.ceil(_loc4_[_loc28_] * PlugInManager.FYOUT);
                              _loc28_++;
                           }
                        }
                        _loc31_++;
                     }
                     _loc30_++;
                  }
                  _loc32_++;
               }
               _loc30_ = 0;
               while(_loc30_ < _loc12_.bone.length)
               {
                  _loc15_ = _loc12_.bone[_loc30_];
                  _loc11_ = _loc15_.transform;
                  if(_loc11_.hasOwnProperty("x"))
                  {
                     _loc11_.x = PlugInManager.ceil(_loc11_.x * PlugInManager.FYOUT);
                  }
                  if(_loc11_.hasOwnProperty("y"))
                  {
                     _loc11_.y = PlugInManager.ceil(_loc11_.y * PlugInManager.FYOUT);
                  }
                  if(_loc15_.hasOwnProperty("length"))
                  {
                     _loc15_.length = PlugInManager.ceil(_loc15_.length * PlugInManager.FYOUT);
                  }
                  _loc30_++;
               }
               _loc34_++;
            }
            this.c_skeJson = JSON.stringify(_loc35_);
         }
         else
         {
            _loc9_ = this.parseSpineAtlas(this.texJson);
            _loc6_ = _loc9_.regions;
            _loc29_ = _loc9_.spineData;
            _loc32_ = 0;
            while(_loc32_ < _loc6_.length)
            {
               _loc1_ = _loc6_[_loc32_];
               _loc20_ = PlugInManager.ceil_fy(_loc1_.width * PlugInManager.FYOUT);
               _loc5_ = PlugInManager.ceil_fy(_loc1_.height * PlugInManager.FYOUT);
               _loc37_ = {
                  "name":_loc1_.name,
                  "index":_loc1_.index,
                  "x":_loc1_.x,
                  "y":_loc1_.y,
                  "width":_loc1_.width,
                  "height":_loc1_.height,
                  "originalWidth":_loc1_.originalWidth,
                  "originalHeight":_loc1_.originalHeight
               };
               _loc38_.push(new NodeRect(0,0,_loc20_,_loc5_,_loc37_));
               _loc32_++;
            }
            this.settings.compression = PlugInManager.COMPRESS;
            _loc2_ = new MaxRectsPacker(settings);
            _loc24_ = _loc2_.pack(_loc38_);
            _loc13_ = _loc24_[0];
            _loc29_.info.size = _loc13_.width + "," + _loc13_.height;
            _loc27_ = new Bitmap();
            _loc27_.bitmapData = new BitmapData(_loc13_.width,_loc13_.height,true,0);
            _loc32_ = 0;
            while(_loc32_ < _loc13_.outputRects.length)
            {
               _loc22_ = _loc13_.outputRects[_loc32_];
               _loc29_.datas[_loc22_.srcParams.name].rotate = _loc22_.rotated;
               _loc29_.datas[_loc22_.srcParams.name].xy = _loc22_.x + "," + _loc22_.y;
               _loc29_.datas[_loc22_.srcParams.name].size = _loc22_.width + "," + _loc22_.height;
               _loc29_.datas[_loc22_.srcParams.name].orig = _loc22_.width + "," + _loc22_.height;
               _loc29_.datas[_loc22_.srcParams.name].offset = "0,0";
               _loc29_.datas[_loc22_.srcParams.name].index = _loc22_.srcParams.index;
               _loc25_ = new Matrix();
               _loc25_.translate(-_loc22_.srcParams.x,-_loc22_.srcParams.y);
               _loc25_.scale(PlugInManager.FYOUT,PlugInManager.FYOUT);
               _loc21_ = new BitmapData(_loc22_.width,_loc22_.height,true,0);
               _loc21_.draw(this.texture.bitmapData,_loc25_,null,null,new Rectangle(0,0,_loc22_.srcParams.width,_loc22_.srcParams.height),true);
               _loc27_.bitmapData.copyPixels(_loc21_,new Rectangle(0,0,_loc21_.width,_loc21_.height),new Point(_loc22_.x,_loc22_.y),null,null,true);
               _loc21_.dispose();
               _loc21_ = null;
               _loc32_++;
            }
            this.c_texture.bitmapData = _loc27_.bitmapData;
            this.c_texJson = this.spineObjectToTxt(_loc29_);
            _loc14_ = JSON.parse(this.skeJson);
            _loc14_["bones"][0]["scaleX"] = PlugInManager.FYOUT;
            _loc14_["bones"][0]["scaleY"] = PlugInManager.FYOUT;
            this.c_skeJson = JSON.stringify(_loc14_);
         }
      }
      
      private function spineObjectToTxt(param1:Object) : String
      {
         var _loc2_:String = "\n";
         _loc2_ = _loc2_ + (param1.info.name + "\n");
         _loc2_ = _loc2_ + ("size: " + param1.info.size + "\n");
         _loc2_ = _loc2_ + ("format: " + param1.info.format + "\n");
         _loc2_ = _loc2_ + ("filter: " + param1.info.filter + "\n");
         _loc2_ = _loc2_ + ("repeat: " + param1.info.repeat + "\n");
         var _loc5_:int = 0;
         var _loc4_:* = param1.datas;
         for(var _loc3_ in param1.datas)
         {
            _loc2_ = _loc2_ + (_loc3_ + "\n");
            _loc2_ = _loc2_ + ("  rotate: " + param1.datas[_loc3_].rotate + "\n");
            _loc2_ = _loc2_ + ("  xy: " + param1.datas[_loc3_].xy + "\n");
            _loc2_ = _loc2_ + ("  size: " + param1.datas[_loc3_].size + "\n");
            _loc2_ = _loc2_ + ("  orig: " + param1.datas[_loc3_].orig + "\n");
            _loc2_ = _loc2_ + ("  offset: " + param1.datas[_loc3_].offset + "\n");
            _loc2_ = _loc2_ + ("  index: " + param1.datas[_loc3_].index + "\n");
         }
         return _loc2_;
      }
      
      public function setBoneRes(param1:String, param2:String, param3:BitmapData, param4:ByteArray, param5:int, param6:String) : void
      {
         this.skeJson = param1;
         this.texJson = param2;
         this.texture.bitmapData = param3;
         this.texture.raw = texture.bitmapData.encode(texture.bitmapData.rect,new PNGEncoderOptions());
         this.fileByt = param4;
         this.movieTye = param5;
         var _loc7_:Object = JSON.parse(this.skeJson);
         this.boneName = param6;
         _loc7_ = null;
      }
      
      public function setDef(param1:BoneDef) : void
      {
         var _loc5_:Object = JSON.parse(this.skeJson);
         this.boneName = _loc5_.name;
         this.armatureName = _loc5_.armature[0].name;
         var _loc3_:String = _loc5_.armature[0].name;
         var _loc4_:String = _loc5_.armature[0].animation[0].name;
         var _loc2_:DragonBonesData = FlashFactory.factory.getDragonBonesData(this.boneName);
         _loc2_ = FlashFactory.factory.parseDragonBonesData(JSON.parse(this.skeJson));
         FlashFactory.factory.parseTextureAtlasData(JSON.parse(this.texJson),this.texture.bitmapData);
      }
      
      public function save() : ByteArray
      {
         var _loc7_:AniFrame = null;
         var _loc4_:AniTexture = null;
         var _loc8_:ByteArray = new ByteArray();
         if(this.movieTye == 1)
         {
            _loc8_.writeUTF("fybonetou");
         }
         else if(this.movieTye == 2)
         {
            _loc8_.writeUTF("fyspinetou");
         }
         _loc8_.writeInt(102);
         if(this.fps == 24)
         {
            _loc8_.writeByte(0);
         }
         else
         {
            _loc8_.writeByte(this.fps);
         }
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.clear();
         _loc2_.position = 0;
         _loc2_.writeUTFBytes(this.skeJson);
         var _loc6_:int = _loc2_.length;
         _loc2_.clear();
         _loc2_.position = 0;
         _loc2_.writeUTFBytes(this.texJson);
         var _loc1_:int = _loc2_.length;
         _loc8_.writeInt(_loc6_);
         _loc8_.writeUTFBytes(this.skeJson);
         _loc8_.writeInt(_loc1_);
         _loc8_.writeUTFBytes(this.texJson);
         var _loc5_:ByteArray = new ByteArray();
         if(this.texture.bitmapData)
         {
            _loc5_ = this.texture.bitmapData.getPixels(new Rectangle(0,0,this.texture.bitmapData.width,this.texture.bitmapData.height));
            _loc8_.writeInt(this.texture.bitmapData.width);
            _loc8_.writeInt(this.texture.bitmapData.height);
            _loc8_.writeInt(_loc5_.length);
            _loc5_.position = 0;
            _loc8_.writeBytes(_loc5_);
            _loc5_.position = 0;
            this.texture.raw = _loc5_;
         }
         else
         {
            _loc8_.writeInt(0);
            _loc8_.writeInt(0);
            _loc5_ = new ByteArray();
            _loc8_.writeInt(_loc5_.length);
            _loc8_.writeBytes(_loc5_);
         }
         _loc2_.clear();
         _loc2_.position = 0;
         _loc2_.writeUTFBytes(this.boneName);
         var _loc3_:int = _loc2_.length;
         _loc8_.writeInt(_loc3_);
         _loc8_.writeUTFBytes(this.boneName);
         _loc2_.clear();
         _loc2_ = null;
         return _loc8_;
      }
      
      public function addRef() : void
      {
         this.releasedTime = 0;
         this.ref++;
      }
      
      public function releaseRef() : void
      {
         this.ref--;
         if(this.ref == 0)
         {
            this.releasedTime = new Date().time / 1000;
         }
      }
      
      public function decode() : void
      {
         this.ready = false;
      }
      
      public function setReady() : void
      {
         this.ready = true;
         this.textureToDecode = 0;
      }
      
      public function reset() : void
      {
         var _loc1_:AniTexture = null;
         this.boundsRect.setEmpty();
         this.releasedTime = 0;
         this.ready = false;
         this.decoding = false;
         this.queued = false;
         this.textureToDecode = 0;
         this.texture = new AniTexture();
      }
   }
}

class Reader#576
{
    
   
   private var lines:Array;
   
   private var index:int;
   
   function Reader#576(param1:String)
   {
      super();
      lines = param1.split(/\r\n|\r|\n/);
   }
   
   public function trim(param1:String) : String
   {
      return param1.replace(/^\s+|\s+$/sg,"");
   }
   
   public function readLine() : String
   {
      if(index >= lines.length)
      {
         return null;
      }
      index = Number(index) + 1;
      return lines[Number(index)];
   }
   
   public function readValue() : String
   {
      var _loc1_:String = readLine();
      var _loc2_:int = _loc1_.indexOf(":");
      if(_loc2_ == -1)
      {
         throw new Error("Invalid line: " + _loc1_);
      }
      return trim(_loc1_.substring(_loc2_ + 1));
   }
   
   public function readTuple(param1:Array) : int
   {
      var _loc3_:int = 0;
      var _loc4_:String = readLine();
      var _loc5_:int = _loc4_.indexOf(":");
      if(_loc5_ == -1)
      {
         throw new Error("Invalid line: " + _loc4_);
      }
      var _loc6_:int = 0;
      var _loc2_:int = _loc5_ + 1;
      while(_loc6_ < 3)
      {
         _loc3_ = _loc4_.indexOf(",",_loc2_);
         if(_loc3_ != -1)
         {
            param1[_loc6_] = trim(_loc4_.substr(_loc2_,_loc3_ - _loc2_));
            _loc2_ = _loc3_ + 1;
            _loc6_++;
            continue;
         }
         break;
      }
      param1[_loc6_] = trim(_loc4_.substring(_loc2_));
      return _loc6_ + 1;
   }
}

package fairygui.editor.animation
{
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class AniDef
   {
      
      public static const FILE_MARK:String = "yytou";
       
      
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
      
      public var frameList:Vector.<AniFrame>;
      
      public var textureList:Vector.<AniTexture>;
      
      public function AniDef()
      {
         super();
         this.version = 102;
         this.speed = 1;
         this.fps = 24;
         this.boundsRect = new Rectangle();
         this.textureList = new Vector.<AniTexture>();
         this.frameList = new Vector.<AniFrame>();
      }
      
      public function get frameCount() : int
      {
         return this.frameList.length;
      }
      
      public function load(param1:ByteArray) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:AniFrame = null;
         var _loc5_:ByteArray = null;
         var _loc9_:AniTexture = null;
         var _loc8_:int = 0;
         var _loc7_:Array = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc12_:String = param1.readUTF();
         if(_loc12_ != "yytou")
         {
            throw new Error("wrong jta format");
         }
         this.reset();
         this.version = param1.readInt();
         this.fps = param1.readByte();
         if(this.fps == 0)
         {
            this.fps = 24;
         }
         param1.readByte();
         param1.readByte();
         param1.readByte();
         if(this.version < 100)
         {
            _loc7_ = [];
            _loc4_ = param1.readByte();
            if(_loc4_ == 0)
            {
               return;
            }
            param1.readByte();
            if(param1.readInt() <= 0)
            {
               return;
            }
            _loc11_ = param1.readByte();
            if(_loc11_ <= 0)
            {
               return;
            }
            param1.readShort();
            param1.readShort();
            param1.readShort();
            param1.readShort();
            this.speed = param1.readByte();
            param1.readByte();
            this.repeatDelay = param1.readByte();
            _loc6_ = param1.readByte();
            this.swing = !!(_loc6_ & 1)?true:false;
            _loc7_.length = _loc11_;
            _loc10_ = 0;
            while(_loc10_ < _loc11_)
            {
               _loc7_[_loc10_] = param1.readByte();
               _loc10_++;
            }
            param1.readInt();
            param1.readByte();
            param1.readByte();
            param1.readInt();
            param1.readInt();
            param1.readInt();
            param1.readInt();
            this.frameList.length = _loc11_;
            _loc10_ = 0;
            while(_loc10_ < _loc11_)
            {
               _loc2_ = new AniFrame();
               this.frameList[_loc10_] = _loc2_;
               _loc2_.delay = _loc7_[_loc10_];
               _loc2_.rect = new Rectangle();
               _loc2_.rect.x = param1.readShort();
               _loc2_.rect.y = param1.readShort();
               _loc2_.rect.width = param1.readShort();
               _loc2_.rect.height = param1.readShort();
               _loc8_ = param1.readInt();
               if(_loc8_)
               {
                  _loc2_.textureIndex = this.textureList.length;
                  _loc5_ = new ByteArray();
                  param1.readBytes(_loc5_,0,_loc8_);
                  _loc9_ = new AniTexture();
                  _loc9_.raw = _loc5_;
                  this.textureList.push(_loc9_);
               }
               else
               {
                  _loc2_.textureIndex = -1;
               }
               _loc10_++;
            }
            this.calculateBoundsRect();
         }
         else
         {
            if(this.version >= 102)
            {
               this.boundsRect.x = param1.readUnsignedShort();
               this.boundsRect.y = param1.readUnsignedShort();
               this.boundsRect.width = param1.readUnsignedShort();
               this.boundsRect.height = param1.readUnsignedShort();
            }
            this.speed = param1.readByte();
            this.repeatDelay = param1.readByte();
            this.swing = param1.readByte() == 1;
            _loc11_ = param1.readShort();
            _loc10_ = 0;
            while(_loc10_ < _loc11_)
            {
               _loc2_ = new AniFrame();
               this.frameList[_loc10_] = _loc2_;
               _loc2_.delay = param1.readShort();
               _loc2_.rect.x = param1.readShort();
               _loc2_.rect.y = param1.readShort();
               _loc2_.rect.width = param1.readShort();
               _loc2_.rect.height = param1.readShort();
               _loc2_.textureIndex = param1.readShort();
               _loc10_++;
            }
            _loc3_ = param1.readShort();
            _loc10_ = 0;
            while(_loc10_ < _loc3_)
            {
               _loc8_ = param1.readInt();
               if(_loc8_ > 0)
               {
                  _loc5_ = new ByteArray();
                  param1.readBytes(_loc5_,0,_loc8_);
               }
               _loc9_ = new AniTexture();
               _loc9_.raw = _loc5_;
               this.textureList.push(_loc9_);
               _loc10_++;
            }
            if(this.version == 100)
            {
               this.calculateBoundsRect();
            }
            else if(this.version == 101)
            {
               this.boundsRect.x = param1.readUnsignedShort();
               this.boundsRect.y = param1.readUnsignedShort();
               this.boundsRect.width = param1.readUnsignedShort();
               this.boundsRect.height = param1.readUnsignedShort();
            }
         }
         this.setLoaded();
      }
      
      public function save() : ByteArray
      {
         var _loc2_:AniFrame = null;
         var _loc1_:AniTexture = null;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTF("yytou");
         _loc3_.writeInt(102);
         if(this.fps == 24)
         {
            _loc3_.writeByte(0);
         }
         else
         {
            _loc3_.writeByte(this.fps);
         }
         _loc3_.writeByte(0);
         _loc3_.writeByte(0);
         _loc3_.writeByte(0);
         _loc3_.writeShort(this.boundsRect.x);
         _loc3_.writeShort(this.boundsRect.y);
         _loc3_.writeShort(this.boundsRect.width);
         _loc3_.writeShort(this.boundsRect.height);
         _loc3_.writeByte(this.speed);
         _loc3_.writeByte(this.repeatDelay);
         _loc3_.writeByte(!!this.swing?1:0);
         _loc3_.writeShort(this.frameList.length);
         var _loc5_:int = 0;
         var _loc4_:* = this.frameList;
         for each(_loc2_ in this.frameList)
         {
            _loc3_.writeShort(_loc2_.delay);
            _loc3_.writeShort(_loc2_.rect.x);
            _loc3_.writeShort(_loc2_.rect.y);
            _loc3_.writeShort(_loc2_.rect.width);
            _loc3_.writeShort(_loc2_.rect.height);
            _loc3_.writeShort(_loc2_.textureIndex);
         }
         _loc3_.writeShort(this.textureList.length);
         var _loc7_:int = 0;
         var _loc6_:* = this.textureList;
         for each(_loc1_ in this.textureList)
         {
            if(!_loc1_.raw)
            {
               _loc3_.writeInt(0);
            }
            else
            {
               _loc3_.writeInt(_loc1_.raw.length);
               _loc3_.writeBytes(_loc1_.raw);
            }
         }
         return _loc3_;
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
         if(!this.ready && !this.queued)
         {
            DecodeSupport.inst.add(this);
         }
      }
      
      public function calculateBoundsRect() : void
      {
         var _loc3_:AniFrame = null;
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         this.boundsRect.setEmpty();
         var _loc5_:int = 0;
         var _loc4_:* = this.frameList;
         for each(_loc3_ in this.frameList)
         {
            if(!_loc3_.rect.isEmpty())
            {
               if(this.boundsRect.isEmpty())
               {
                  this.boundsRect = _loc3_.rect.clone();
               }
               else
               {
                  this.boundsRect = this.boundsRect.union(_loc3_.rect);
               }
            }
         }
         _loc2_ = 0;
         _loc1_ = 0;
         if(this.boundsRect.x < 0)
         {
            _loc2_ = -this.boundsRect.x;
         }
         if(this.boundsRect.y < 0)
         {
            _loc1_ = -this.boundsRect.y;
         }
         if(_loc2_ != 0 || _loc1_ != 0)
         {
            this.boundsRect.x = this.boundsRect.x + _loc2_;
            this.boundsRect.y = this.boundsRect.y + _loc1_;
            var _loc7_:int = 0;
            var _loc6_:* = this.frameList;
            for each(_loc3_ in this.frameList)
            {
               _loc3_.rect.x = _loc3_.rect.x + _loc2_;
               _loc3_.rect.y = _loc3_.rect.y + _loc1_;
            }
         }
         this.boundsRect.width = this.boundsRect.width + this.boundsRect.x;
         this.boundsRect.height = this.boundsRect.height + this.boundsRect.y;
         this.boundsRect.x = 0;
         this.boundsRect.y = 0;
      }
      
      public function setLoaded() : void
      {
         this.textureToDecode = this.textureList.length;
         this.ready = !this.textureToDecode;
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
         var _loc3_:int = 0;
         var _loc2_:* = this.textureList;
         for each(_loc1_ in this.textureList)
         {
            if(_loc1_.bitmapData)
            {
               _loc1_.bitmapData.dispose();
            }
            if(_loc1_.raw)
            {
               _loc1_.raw.clear();
            }
            _loc1_.bitmapData = null;
            _loc1_.raw = null;
         }
         this.textureList.length = 0;
         this.frameList.length = 0;
      }
   }
}

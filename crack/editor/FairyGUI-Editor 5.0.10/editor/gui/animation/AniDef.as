package fairygui.editor.gui.animation
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
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:AniFrame = null;
         var _loc6_:ByteArray = null;
         var _loc7_:AniTexture = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc2_:String = param1.readUTF();
         if(_loc2_ != FILE_MARK)
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
            _loc9_ = [];
            _loc10_ = param1.readByte();
            if(_loc10_ == 0)
            {
               return;
            }
            param1.readByte();
            if(param1.readInt() <= 0)
            {
               return;
            }
            _loc4_ = param1.readByte();
            if(_loc4_ <= 0)
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
            _loc11_ = param1.readByte();
            this.swing = !!(_loc11_ & 1)?true:false;
            _loc9_.length = _loc4_;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc9_[_loc3_] = param1.readByte();
               _loc3_++;
            }
            param1.readInt();
            param1.readByte();
            param1.readByte();
            param1.readInt();
            param1.readInt();
            param1.readInt();
            param1.readInt();
            this.frameList.length = _loc4_;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = new AniFrame();
               this.frameList[_loc3_] = _loc5_;
               _loc5_.delay = _loc9_[_loc3_];
               _loc5_.rect = new Rectangle();
               _loc5_.rect.x = param1.readShort();
               _loc5_.rect.y = param1.readShort();
               _loc5_.rect.width = param1.readShort();
               _loc5_.rect.height = param1.readShort();
               _loc8_ = param1.readInt();
               if(_loc8_)
               {
                  _loc5_.textureIndex = this.textureList.length;
                  _loc6_ = new ByteArray();
                  param1.readBytes(_loc6_,0,_loc8_);
                  _loc7_ = new AniTexture();
                  _loc7_.raw = _loc6_;
                  this.textureList.push(_loc7_);
               }
               else
               {
                  _loc5_.textureIndex = -1;
               }
               _loc3_++;
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
            this.speed = param1.readUnsignedByte();
            this.repeatDelay = param1.readUnsignedByte();
            this.swing = param1.readByte() == 1;
            _loc4_ = param1.readShort();
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = new AniFrame();
               this.frameList[_loc3_] = _loc5_;
               _loc5_.delay = param1.readShort();
               _loc5_.rect.x = param1.readShort();
               _loc5_.rect.y = param1.readShort();
               _loc5_.rect.width = param1.readShort();
               _loc5_.rect.height = param1.readShort();
               _loc5_.textureIndex = param1.readShort();
               _loc3_++;
            }
            _loc12_ = param1.readShort();
            _loc3_ = 0;
            while(_loc3_ < _loc12_)
            {
               _loc8_ = param1.readInt();
               if(_loc8_ > 0)
               {
                  _loc6_ = new ByteArray();
                  param1.readBytes(_loc6_,0,_loc8_);
               }
               _loc7_ = new AniTexture();
               _loc7_.raw = _loc6_;
               this.textureList.push(_loc7_);
               _loc3_++;
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
         var _loc3_:AniTexture = null;
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUTF(FILE_MARK);
         _loc1_.writeInt(102);
         if(this.fps == 24)
         {
            _loc1_.writeByte(0);
         }
         else
         {
            _loc1_.writeByte(this.fps);
         }
         _loc1_.writeByte(0);
         _loc1_.writeByte(0);
         _loc1_.writeByte(0);
         _loc1_.writeShort(this.boundsRect.x);
         _loc1_.writeShort(this.boundsRect.y);
         _loc1_.writeShort(this.boundsRect.width);
         _loc1_.writeShort(this.boundsRect.height);
         _loc1_.writeByte(this.speed);
         _loc1_.writeByte(this.repeatDelay);
         _loc1_.writeByte(!!this.swing?1:0);
         _loc1_.writeShort(this.frameList.length);
         for each(_loc2_ in this.frameList)
         {
            _loc1_.writeShort(_loc2_.delay);
            _loc1_.writeShort(_loc2_.rect.x);
            _loc1_.writeShort(_loc2_.rect.y);
            _loc1_.writeShort(_loc2_.rect.width);
            _loc1_.writeShort(_loc2_.rect.height);
            _loc1_.writeShort(_loc2_.textureIndex);
         }
         _loc1_.writeShort(this.textureList.length);
         for each(_loc3_ in this.textureList)
         {
            if(!_loc3_.raw)
            {
               _loc1_.writeInt(0);
            }
            else
            {
               _loc1_.writeInt(_loc3_.raw.length);
               _loc1_.writeBytes(_loc3_.raw);
            }
         }
         return _loc1_;
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
         var _loc1_:AniFrame = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.boundsRect.setEmpty();
         for each(_loc1_ in this.frameList)
         {
            if(!_loc1_.rect.isEmpty())
            {
               if(this.boundsRect.isEmpty())
               {
                  this.boundsRect = _loc1_.rect.clone();
               }
               else
               {
                  this.boundsRect = this.boundsRect.union(_loc1_.rect);
               }
            }
         }
         _loc2_ = 0;
         _loc3_ = 0;
         if(this.boundsRect.x < 0)
         {
            _loc2_ = -this.boundsRect.x;
         }
         if(this.boundsRect.y < 0)
         {
            _loc3_ = -this.boundsRect.y;
         }
         if(_loc2_ != 0 || _loc3_ != 0)
         {
            this.boundsRect.x = this.boundsRect.x + _loc2_;
            this.boundsRect.y = this.boundsRect.y + _loc3_;
            for each(_loc1_ in this.frameList)
            {
               _loc1_.rect.x = _loc1_.rect.x + _loc2_;
               _loc1_.rect.y = _loc1_.rect.y + _loc3_;
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
      
      public function copySettings(param1:AniDef) : void
      {
         this.fps = param1.fps;
         this.speed = param1.speed;
         this.repeatDelay = param1.repeatDelay;
         this.swing = param1.swing;
      }
      
      public function reset() : void
      {
         var _loc1_:AniTexture = null;
         this.boundsRect.setEmpty();
         this.ready = false;
         this.decoding = false;
         this.queued = false;
         this.textureToDecode = 0;
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

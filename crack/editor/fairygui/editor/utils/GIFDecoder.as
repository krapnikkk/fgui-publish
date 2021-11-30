package fairygui.editor.utils
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class GIFDecoder
   {
      
      private static var STATUS_OK:int = 0;
      
      private static var STATUS_FORMAT_ERROR:int = 1;
      
      private static var STATUS_OPEN_ERROR:int = 2;
      
      private static var frameRect:Rectangle = new Rectangle();
      
      private static var MaxStackSize:int = 4096;
      
      private static var prefix:Array;
      
      private static var suffix:Array;
      
      private static var pixelStack:Array;
      
      private static var pixels:Array;
       
      
      private var inStream:ByteArray;
      
      private var status:int;
      
      private var width:int;
      
      private var height:int;
      
      private var gctFlag:Boolean;
      
      private var gctSize:int;
      
      private var loopCount:int = 1;
      
      private var gct:Array;
      
      private var lct:Array;
      
      private var act:Array;
      
      private var bgIndex:int;
      
      private var bgColor:int;
      
      private var lctFlag:Boolean;
      
      private var interlace:Boolean;
      
      private var lctSize:int;
      
      private var ix:int;
      
      private var iy:int;
      
      private var iw:int;
      
      private var ih:int;
      
      private var block:ByteArray;
      
      private var blockSize:int;
      
      private var dispose:int;
      
      private var lastDispose:int;
      
      private var delay:int;
      
      private var transIndex:int;
      
      private var frames:Vector.<GIFFrame>;
      
      private var frameCount:int;
      
      public function GIFDecoder(param1:ByteArray)
      {
         super();
         this.block = new ByteArray();
         this.transIndex = -1;
         this.status = STATUS_OK;
         this.frameCount = 0;
         this.frames = new Vector.<GIFFrame>();
         this.gct = null;
         this.lct = null;
         this.inStream = param1;
         this.readHeader();
         if(!this.hasError())
         {
            this.readContents();
            if(this.frameCount < 0)
            {
               this.status = STATUS_FORMAT_ERROR;
            }
         }
         param1 = null;
      }
      
      public function getDelay(param1:int) : int
      {
         this.delay = -1;
         if(param1 >= 0 && param1 < this.frameCount)
         {
            this.delay = this.frames[param1].delay;
         }
         return this.delay;
      }
      
      public function getFrameCount() : int
      {
         return this.frameCount;
      }
      
      public function getImage() : GIFFrame
      {
         return this.getFrame(0);
      }
      
      public function getLoopCount() : int
      {
         return this.loopCount;
      }
      
      public function getFrame(param1:int) : GIFFrame
      {
         var _loc2_:GIFFrame = null;
         if(param1 >= 0 && param1 < this.frameCount)
         {
            _loc2_ = this.frames[param1];
            return _loc2_;
         }
         throw new RangeError("Wrong frame number passed");
      }
      
      public function getFrameSize() : Rectangle
      {
         var _loc1_:Rectangle = GIFDecoder.frameRect;
         var _loc2_:int = 0;
         _loc1_.y = _loc2_;
         _loc1_.x = _loc2_;
         _loc1_.width = this.width;
         _loc1_.height = this.height;
         return _loc1_;
      }
      
      private function decodeImageData() : void
      {
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         var _loc14_:* = 0;
         var _loc15_:int = 0;
         var _loc18_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:* = 0;
         var _loc2_:int = 0;
         var _loc4_:* = 0;
         var _loc3_:int = 0;
         var _loc6_:* = 0;
         var _loc1_:* = 0;
         var _loc12_:int = 0;
         var _loc13_:* = 0;
         var _loc7_:int = 0;
         var _loc5_:int = 0;
         var _loc19_:int = 0;
         var _loc11_:int = -1;
         var _loc10_:int = this.iw * this.ih;
         if(pixels == null || pixels.length < _loc10_)
         {
            pixels = new Array(_loc10_);
         }
         if(prefix == null)
         {
            prefix = new Array(MaxStackSize);
         }
         if(suffix == null)
         {
            suffix = new Array(MaxStackSize);
         }
         if(pixelStack == null)
         {
            pixelStack = new Array(MaxStackSize + 1);
         }
         _loc12_ = this.readSingleByte();
         _loc9_ = 1 << _loc12_;
         _loc18_ = _loc9_ + 1;
         _loc8_ = _loc9_ + 2;
         _loc17_ = _loc11_;
         _loc15_ = _loc12_ + 1;
         _loc14_ = 1 << _loc15_ - 1;
         _loc4_ = 0;
         while(_loc4_ < _loc9_)
         {
            prefix[int(_loc4_)] = 0;
            suffix[int(_loc4_)] = _loc4_;
            _loc4_++;
         }
         _loc5_ = 0;
         _loc19_ = 0;
         _loc7_ = 0;
         _loc13_ = int(0);
         _loc3_ = _loc13_;
         _loc2_ = _loc13_;
         _loc1_ = int(_loc13_);
         _loc6_ = 0;
         while(_loc6_ < _loc10_)
         {
            if(_loc7_ == 0)
            {
               if(_loc2_ < _loc15_)
               {
                  if(_loc3_ == 0)
                  {
                     _loc3_ = this.readBlock();
                     if(_loc3_ > 0)
                     {
                        _loc5_ = 0;
                     }
                     else
                     {
                        break;
                     }
                  }
                  _loc1_ = int(_loc1_ + ((int(this.block[int(_loc5_)]) & 255) << _loc2_));
                  _loc2_ = _loc2_ + 8;
                  _loc5_++;
                  _loc3_--;
                  continue;
               }
               _loc4_ = _loc1_ & _loc14_;
               _loc1_ = _loc1_ >> _loc15_;
               _loc2_ = _loc2_ - _loc15_;
               if(!(_loc4_ > _loc8_ || _loc4_ == _loc18_))
               {
                  if(_loc4_ == _loc9_)
                  {
                     _loc15_ = _loc12_ + 1;
                     _loc14_ = 1 << _loc15_ - 1;
                     _loc8_ = _loc9_ + 2;
                     _loc17_ = _loc11_;
                     continue;
                  }
                  if(_loc17_ == _loc11_)
                  {
                     _loc7_++;
                     pixelStack[int(_loc7_)] = suffix[int(_loc4_)];
                     _loc17_ = int(_loc4_);
                     _loc13_ = int(_loc4_);
                     continue;
                  }
                  _loc16_ = _loc4_;
                  if(_loc4_ == _loc8_)
                  {
                     _loc7_++;
                     pixelStack[int(_loc7_)] = _loc13_;
                     _loc4_ = int(_loc17_);
                  }
                  while(_loc4_ > _loc9_)
                  {
                     _loc7_++;
                     pixelStack[int(_loc7_)] = suffix[int(_loc4_)];
                     _loc4_ = int(prefix[int(_loc4_)]);
                  }
                  _loc13_ = suffix[int(_loc4_)] & 255;
                  if(_loc8_ < MaxStackSize)
                  {
                     _loc7_++;
                     pixelStack[int(_loc7_)] = _loc13_;
                     prefix[int(_loc8_)] = _loc17_;
                     suffix[int(_loc8_)] = _loc13_;
                     _loc8_++;
                     if((_loc8_ & _loc14_) == 0 && _loc8_ < MaxStackSize)
                     {
                        _loc15_++;
                        _loc14_ = int(_loc14_ + _loc8_);
                     }
                     _loc17_ = _loc16_;
                  }
                  else
                  {
                     break;
                  }
               }
               break;
            }
            _loc7_--;
            _loc19_++;
            pixels[int(_loc19_)] = pixelStack[int(_loc7_)];
            _loc6_++;
         }
         _loc6_ = _loc19_;
         while(_loc6_ < _loc10_)
         {
            pixels[int(_loc6_)] = 0;
            _loc6_++;
         }
      }
      
      public function hasError() : Boolean
      {
         return this.status != STATUS_OK;
      }
      
      private function readSingleByte() : int
      {
         var _loc1_:int = 0;
         try
         {
            _loc1_ = this.inStream.readUnsignedByte();
         }
         catch(e:Error)
         {
            status = STATUS_FORMAT_ERROR;
         }
         return _loc1_;
      }
      
      private function readBlock() : int
      {
         var _loc1_:int = 0;
         this.blockSize = this.readSingleByte();
         var _loc2_:int = 0;
         if(this.blockSize > 0)
         {
            try
            {
               _loc1_ = 0;
               while(_loc2_ < this.blockSize)
               {
                  this.inStream.readBytes(this.block,_loc2_,this.blockSize - _loc2_);
                  if(this.blockSize - _loc2_ != -1)
                  {
                     _loc2_ = _loc2_ + (this.blockSize - _loc2_);
                     continue;
                  }
                  break;
               }
            }
            catch(e:Error)
            {
            }
            if(_loc2_ < this.blockSize)
            {
               this.status = STATUS_FORMAT_ERROR;
            }
         }
         return _loc2_;
      }
      
      private function readColorTable(param1:int) : Array
      {
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         var _loc10_:int = 3 * param1;
         var _loc8_:Array = null;
         var _loc9_:ByteArray = new ByteArray();
         var _loc2_:* = 0;
         try
         {
            this.inStream.readBytes(_loc9_,0,_loc10_);
            _loc2_ = _loc10_;
         }
         catch(e:Error)
         {
         }
         if(_loc2_ < _loc10_)
         {
            this.status = STATUS_FORMAT_ERROR;
         }
         else
         {
            _loc8_ = new Array(256);
            _loc4_ = 0;
            _loc7_ = 0;
            while(_loc4_ < param1)
            {
               _loc7_++;
               _loc6_ = _loc9_[_loc7_] & 255;
               _loc7_++;
               _loc5_ = _loc9_[_loc7_] & 255;
               _loc7_++;
               _loc3_ = _loc9_[_loc7_] & 255;
               _loc4_++;
               _loc8_[_loc4_] = 4278190080 | _loc6_ << 16 | _loc5_ << 8 | _loc3_;
            }
         }
         return _loc8_;
      }
      
      private function readContents() : void
      {
         var _loc3_:int = 0;
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc4_:Boolean = false;
         while(!(_loc4_ || this.hasError()))
         {
            _loc3_ = this.readSingleByte();
            var _loc5_:* = _loc3_;
            if(44 !== _loc5_)
            {
               if(33 !== _loc5_)
               {
                  if(59 !== _loc5_)
                  {
                     if(0 !== _loc5_)
                     {
                        this.status = STATUS_FORMAT_ERROR;
                     }
                  }
                  else
                  {
                     _loc4_ = true;
                  }
               }
               else
               {
                  _loc3_ = this.readSingleByte();
                  switch(int(_loc3_) - 249)
                  {
                     case 0:
                        this.readGraphicControlExt();
                        break;
                     default:
                     default:
                     default:
                     default:
                     default:
                        this.skip();
                        break;
                     case 6:
                        this.readBlock();
                        _loc1_ = "";
                        _loc2_ = 0;
                        while(_loc2_ < 11)
                        {
                           _loc1_ = _loc1_ + this.block[int(_loc2_)];
                           _loc2_++;
                        }
                        if(_loc1_ == "NETSCAPE2.0")
                        {
                           this.readNetscapeExt();
                        }
                        else
                        {
                           this.skip();
                        }
                  }
               }
            }
            else
            {
               this.readImage();
            }
         }
      }
      
      private function readGraphicControlExt() : void
      {
         this.readSingleByte();
         var _loc2_:int = this.readSingleByte();
         this.dispose = (_loc2_ & 28) >> 2;
         var _loc1_:* = (_loc2_ & 1) != 0;
         this.delay = this.readShort() * 10;
         if(_loc1_)
         {
            this.transIndex = this.readSingleByte();
         }
         else
         {
            this.transIndex = -1;
         }
         this.readSingleByte();
      }
      
      private function readHeader() : void
      {
         var _loc2_:String = "";
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = _loc2_ + String.fromCharCode(this.readSingleByte());
            _loc1_++;
         }
         if(_loc2_.indexOf("GIF") != 0)
         {
            this.status = STATUS_FORMAT_ERROR;
            throw new Error("Invalid file type");
         }
         this.readLSD();
         if(this.gctFlag && !this.hasError())
         {
            this.gct = this.readColorTable(this.gctSize);
         }
      }
      
      private function readImage() : void
      {
         this.ix = this.readShort();
         this.iy = this.readShort();
         this.iw = this.readShort();
         this.ih = this.readShort();
         var _loc4_:int = this.readSingleByte();
         this.lctFlag = (_loc4_ & 128) != 0;
         this.interlace = (_loc4_ & 64) != 0;
         this.lctSize = 2 << (_loc4_ & 7);
         if(this.lctFlag)
         {
            this.lct = this.readColorTable(this.lctSize);
            this.act = this.lct;
         }
         else
         {
            this.act = this.gct;
         }
         if(this.act == null)
         {
            this.status = STATUS_FORMAT_ERROR;
         }
         if(this.hasError())
         {
            return;
         }
         this.bgColor = 0;
         this.decodeImageData();
         this.skip();
         if(this.hasError())
         {
            return;
         }
         var _loc3_:BitmapData = new BitmapData(this.width,this.height,true,0);
         var _loc1_:int = -1;
         if(this.frameCount > 0 && this.lastDispose == 0 || this.lastDispose == 1)
         {
            _loc1_ = this.frameCount - 1;
         }
         else if(this.frameCount > 1 && this.lastDispose == 3)
         {
            _loc1_ = this.frameCount - 2;
         }
         else if(this.lastDispose == 2)
         {
         }
         var _loc2_:Rectangle = new Rectangle(this.ix,this.iy,this.iw,this.ih);
         if(_loc1_ >= 0)
         {
            _loc3_.copyPixels(this.frames[_loc1_].bitmapData,_loc3_.rect,new Point(0,0));
         }
         else
         {
            _loc3_.fillRect(_loc3_.rect,this.bgColor);
         }
         this.transferPixels(_loc3_,_loc1_ >= 0);
         this.frameCount++;
         this.frames.push(new GIFFrame(_loc3_,this.delay));
         this.lastDispose = this.dispose;
         this.delay = 0;
         this.transIndex = -1;
      }
      
      private function transferPixels(param1:BitmapData, param2:Boolean) : void
      {
         var _loc13_:* = 0;
         var _loc14_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:* = 0;
         var _loc3_:uint = 0;
         var _loc10_:uint = 0;
         var _loc8_:Vector.<uint> = param1.getVector(param1.rect);
         var _loc9_:int = 1;
         var _loc11_:int = 8;
         var _loc12_:int = 0;
         var _loc15_:int = 0;
         while(_loc15_ < this.ih)
         {
            _loc13_ = _loc15_;
            if(this.interlace)
            {
               if(_loc12_ >= this.ih)
               {
                  _loc9_++;
                  switch(int(_loc9_) - 2)
                  {
                     case 0:
                        _loc12_ = 4;
                        break;
                     case 1:
                        _loc12_ = 2;
                        _loc11_ = 4;
                        break;
                     case 2:
                        _loc12_ = 1;
                        _loc11_ = 2;
                  }
               }
               _loc13_ = _loc12_;
               _loc12_ = _loc12_ + _loc11_;
            }
            _loc13_ = int(_loc13_ + this.iy);
            if(_loc13_ < this.height)
            {
               _loc14_ = _loc13_ * this.width;
               _loc4_ = _loc14_ + this.ix;
               _loc6_ = _loc4_ + this.iw;
               if(_loc14_ + this.width < _loc6_)
               {
                  _loc6_ = _loc14_ + this.width;
               }
               _loc5_ = _loc15_ * this.iw;
               while(_loc4_ < _loc6_)
               {
                  _loc5_++;
                  _loc7_ = pixels[_loc5_] & 255;
                  _loc3_ = this.act[_loc7_];
                  if(_loc3_ != 0)
                  {
                     _loc10_ = this.transIndex >= 0 && this.transIndex == _loc7_?0:255;
                     if(_loc10_ != 0 || param2 == false)
                     {
                        _loc8_[_loc4_] = (_loc3_ & 16777215) + (_loc10_ << 24);
                     }
                  }
                  _loc4_++;
               }
            }
            _loc15_++;
         }
         param1.setVector(param1.rect,_loc8_);
      }
      
      private function readLSD() : void
      {
         this.width = this.readShort();
         this.height = this.readShort();
         var _loc1_:int = this.readSingleByte();
         this.gctFlag = (_loc1_ & 128) != 0;
         this.gctSize = 2 << (_loc1_ & 7);
         this.bgIndex = this.readSingleByte();
         this.readSingleByte();
      }
      
      private function readNetscapeExt() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         do
         {
            this.readBlock();
            if(this.block[0] == 1)
            {
               _loc2_ = this.block[1] & 255;
               _loc1_ = this.block[2] & 255;
               this.loopCount = _loc1_ << 8 | _loc2_;
            }
         }
         while(this.blockSize > 0 && !this.hasError());
         
      }
      
      private function readShort() : int
      {
         return this.readSingleByte() | this.readSingleByte() << 8;
      }
      
      private function skip() : void
      {
         do
         {
            this.readBlock();
         }
         while(this.blockSize > 0 && !this.hasError());
         
      }
   }
}

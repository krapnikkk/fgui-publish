package fairygui.editor.pack
{
   public class MaxRectsPacker
   {
      
      private static var SIZE_SCHEME:Array;
       
      
      private var _maxRects:MaxRects;
      
      private var settings:PackSettings;
      
      public function MaxRectsPacker(param1:PackSettings)
      {
         super();
         this.settings = param1;
         this._maxRects = new MaxRects();
      }
      
      private static function initSizeScheme() : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         SIZE_SCHEME = [];
         var _loc6_:int = 5;
         while(_loc6_ <= 13)
         {
            _loc5_ = 5;
            while(_loc5_ <= 13)
            {
               _loc3_ = Math.pow(2,_loc6_);
               _loc4_ = Math.pow(2,_loc5_);
               _loc1_ = _loc3_ * _loc4_;
               _loc2_ = _loc3_ > _loc4_?Number(_loc3_ / _loc4_):Number(_loc4_ / _loc3_);
               SIZE_SCHEME.push({
                  "width":_loc3_,
                  "height":_loc4_,
                  "area":_loc1_,
                  "aspectRatio":_loc2_,
                  "len":Math.max(_loc3_,_loc4_)
               });
               _loc5_++;
            }
            _loc6_++;
         }
         SIZE_SCHEME.sort(compareSize);
      }
      
      private static function compareSize(param1:Object, param2:Object) : int
      {
         if(param1.len < param2.len)
         {
            return -1;
         }
         if(param1.len > param2.len)
         {
            return 1;
         }
         if(param1.area < param2.area)
         {
            return -1;
         }
         if(param1.area > param2.area)
         {
            return 1;
         }
         if(param1.aspectRatio < param2.aspectRatio)
         {
            return -1;
         }
         if(param1.aspectRatio > param2.aspectRatio)
         {
            return 1;
         }
         if(param1.width > param1.height)
         {
            return -1;
         }
         if(param2.width > param2.height)
         {
            return 1;
         }
         return 0;
      }
      
      public static function getNextPowerOfTwo(param1:Number) : int
      {
         var _loc2_:* = 0;
         if(param1 is int && param1 > 0 && (param1 & param1 - 1) == 0)
         {
            return param1;
         }
         _loc2_ = 1;
         param1 = param1 - 1.0e-9;
         while(_loc2_ < param1)
         {
            _loc2_ = _loc2_ << 1;
         }
         return _loc2_;
      }
      
      public function pack(param1:Vector.<NodeRect>) : Vector.<Page>
      {
         var _loc3_:NodeRect = null;
         var _loc4_:Vector.<Page> = null;
         var _loc2_:Page = null;
         if(this.settings.fast)
         {
            if(this.settings.rotation)
            {
               param1.sort(this.compareNodeRect);
            }
            else
            {
               param1.sort(this.compareNodeRect2);
            }
         }
         var _loc5_:int = this.settings.padding;
         var _loc7_:int = 0;
         var _loc6_:* = param1;
         for each(_loc3_ in param1)
         {
            if(this.settings.maxWidth - _loc3_.width > _loc5_)
            {
               _loc3_.width = _loc3_.width + _loc5_;
            }
            if(this.settings.maxHeight - _loc3_.height > _loc5_)
            {
               _loc3_.height = _loc3_.height + _loc5_;
            }
         }
         _loc4_ = new Vector.<Page>();
         while(param1.length > 0)
         {
            _loc2_ = this.packPage(param1);
            if(_loc2_ == null)
            {
               return null;
            }
            if(this.settings.pot)
            {
               _loc2_.width = getNextPowerOfTwo(_loc2_.width);
               _loc2_.height = getNextPowerOfTwo(_loc2_.height);
            }
            if(this.settings.square)
            {
               _loc2_.width = Math.max(_loc2_.width,_loc2_.height);
               _loc2_.height = Math.max(_loc2_.width,_loc2_.height);
            }
            _loc4_.push(_loc2_);
            param1 = _loc2_.remainingRects;
         }
         _loc4_.sort(this.comparePage);
         var _loc13_:int = 0;
         var _loc12_:* = _loc4_;
         for each(_loc2_ in _loc4_)
         {
            var _loc9_:int = 0;
            var _loc8_:* = _loc2_.outputRects;
            for each(_loc3_ in _loc2_.outputRects)
            {
               if(!_loc3_.rotated)
               {
                  if(this.settings.maxWidth - _loc3_.width > _loc5_)
                  {
                     _loc3_.width = _loc3_.width - _loc5_;
                  }
                  if(this.settings.maxHeight - _loc3_.height > _loc5_)
                  {
                     _loc3_.height = _loc3_.height - _loc5_;
                  }
               }
               else
               {
                  if(this.settings.maxHeight - _loc3_.width > _loc5_)
                  {
                     _loc3_.width = _loc3_.width - _loc5_;
                  }
                  if(this.settings.maxWidth - _loc3_.height > _loc5_)
                  {
                     _loc3_.height = _loc3_.height - _loc5_;
                  }
               }
            }
            var _loc11_:int = 0;
            var _loc10_:* = _loc2_.remainingRects;
            for each(_loc3_ in _loc2_.remainingRects)
            {
               if(!_loc3_.rotated)
               {
                  if(this.settings.maxWidth - _loc3_.width > _loc5_)
                  {
                     _loc3_.width = _loc3_.width - _loc5_;
                  }
                  if(this.settings.maxHeight - _loc3_.height > _loc5_)
                  {
                     _loc3_.height = _loc3_.height - _loc5_;
                  }
               }
               else
               {
                  if(this.settings.maxHeight - _loc3_.width > _loc5_)
                  {
                     _loc3_.width = _loc3_.width - _loc5_;
                  }
                  if(this.settings.maxWidth - _loc3_.height > _loc5_)
                  {
                     _loc3_.height = _loc3_.height - _loc5_;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      private function packPage(param1:Vector.<NodeRect>) : Page
      {
         var _loc19_:Object = null;
         var _loc18_:int = 0;
         var _loc3_:Page = null;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:NodeRect = null;
         var _loc2_:Page = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc10_:BinarySearch = null;
         var _loc7_:int = 0;
         var _loc21_:BinarySearch = null;
         var _loc8_:BinarySearch = null;
         var _loc20_:Page = null;
         if(SIZE_SCHEME == null)
         {
            initSizeScheme();
         }
         var _loc12_:int = 0;
         if(this.settings.edgePadding && !this.settings.duplicatePadding)
         {
            _loc12_ = this.settings.padding;
         }
         var _loc9_:int = 0;
         var _loc11_:int = param1.length;
         var _loc15_:int = 0;
         while(_loc15_ < _loc11_)
         {
            _loc6_ = param1[_loc15_];
            _loc9_ = _loc9_ + _loc6_.width * _loc6_.height;
            _loc15_++;
         }
         var _loc16_:Array = [];
         var _loc23_:int = 0;
         var _loc22_:* = SIZE_SCHEME;
         for each(_loc19_ in SIZE_SCHEME)
         {
            if(_loc19_.area >= _loc9_ && _loc19_.width <= this.settings.maxWidth && _loc19_.height <= this.settings.maxHeight)
            {
               _loc16_.push(_loc19_);
            }
         }
         _loc18_ = _loc16_.length;
         if(_loc18_ == 0)
         {
            _loc16_.push({
               "width":this.settings.maxWidth,
               "height":this.settings.maxHeight
            });
            _loc18_ = 1;
         }
         var _loc17_:* = null;
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc5_ = _loc16_[_loc15_].width;
            _loc4_ = _loc16_[_loc15_].height;
            _loc17_ = this.packAtSize(_loc15_ != _loc18_ - 1,_loc5_ - _loc12_,_loc4_ - _loc12_,param1);
            if(_loc17_ == null)
            {
               _loc15_++;
               continue;
            }
            break;
         }
         if(_loc17_ != null && !this.settings.pot && _loc17_.remainingRects.length == 0)
         {
            if(this.settings.square)
            {
               _loc13_ = Math.min(_loc5_ / 2,_loc4_ / 2);
               _loc14_ = Math.max(_loc5_,_loc4_);
               _loc10_ = new BinarySearch(_loc13_,_loc14_,!!this.settings.fast?25:15,this.settings.pot);
               _loc7_ = _loc10_.reset();
               while(_loc7_ != -1)
               {
                  _loc3_ = this.packAtSize(true,_loc7_ - _loc12_,_loc7_ - _loc12_,param1);
                  _loc2_ = this.getBest(_loc2_,_loc3_);
                  _loc7_ = _loc10_.next(_loc3_ == null);
               }
            }
            else
            {
               _loc21_ = new BinarySearch(_loc5_ / 2,_loc5_,!!this.settings.fast?25:15,this.settings.pot);
               _loc8_ = new BinarySearch(_loc4_ / 2,_loc4_,!!this.settings.fast?25:15,this.settings.pot);
               _loc5_ = _loc21_.reset();
               _loc4_ = _loc8_.reset();
               while(true)
               {
                  _loc20_ = null;
                  while(_loc5_ != -1)
                  {
                     _loc3_ = this.packAtSize(true,_loc5_ - _loc12_,_loc4_ - _loc12_,param1);
                     _loc20_ = this.getBest(_loc20_,_loc3_);
                     _loc5_ = _loc21_.next(_loc3_ == null);
                  }
                  _loc2_ = this.getBest(_loc2_,_loc20_);
                  _loc4_ = _loc8_.next(_loc20_ == null);
                  if(_loc4_ != -1)
                  {
                     _loc5_ = _loc21_.reset();
                     continue;
                  }
                  break;
               }
            }
            if(_loc2_ != null)
            {
               _loc17_ = _loc2_;
            }
         }
         return _loc17_;
      }
      
      private function packAtSize(param1:Boolean, param2:int, param3:int, param4:Vector.<NodeRect>) : Page
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Page = null;
         var _loc8_:Vector.<NodeRect> = null;
         var _loc9_:Page = null;
         var _loc10_:Array = MaxRects.AllMethods;
         var _loc13_:int = _loc10_.length;
         var _loc7_:int = param4.length;
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc11_ = _loc10_[_loc12_];
            this._maxRects.init(param2,param3,this.settings.rotation);
            if(!this.settings.fast)
            {
               _loc6_ = this._maxRects.pack(param4,_loc10_[_loc12_]);
            }
            else
            {
               _loc8_ = new Vector.<NodeRect>();
               _loc5_ = 0;
               while(_loc5_ < _loc7_)
               {
                  if(this._maxRects.insert(param4[_loc5_],_loc11_) == null)
                  {
                     while(_loc5_ < _loc7_)
                     {
                        _loc5_++;
                        _loc8_.push(param4[_loc5_]);
                     }
                  }
                  _loc5_++;
               }
               _loc6_ = this._maxRects.getResult();
               _loc6_.remainingRects = _loc8_;
            }
            if(!(param1 && _loc6_.remainingRects.length > 0))
            {
               if(_loc6_.outputRects.length != 0)
               {
                  _loc9_ = this.getBest(_loc9_,_loc6_);
               }
            }
            _loc12_++;
         }
         return _loc9_;
      }
      
      private function getBest(param1:Page, param2:Page) : Page
      {
         if(param1 == null)
         {
            return param2;
         }
         if(param2 == null)
         {
            return param1;
         }
         return param1.occupancy > param2.occupancy?param1:param2;
      }
      
      private function comparePage(param1:Page, param2:Page) : int
      {
         return param2.outputRects.length - param1.outputRects.length;
      }
      
      private function compareNodeRect(param1:NodeRect, param2:NodeRect) : int
      {
         var _loc3_:int = param1.width > param1.height?int(param1.width):int(param1.height);
         var _loc4_:int = param2.width > param2.height?int(param2.width):int(param2.height);
         return _loc4_ - _loc3_;
      }
      
      private function compareNodeRect2(param1:NodeRect, param2:NodeRect) : int
      {
         return param2.width - param1.width;
      }
   }
}

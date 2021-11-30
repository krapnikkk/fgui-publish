package fairygui.editor.pack
{
   public class MaxRects
   {
      
      public static const BestShortSideFit:int = 0;
      
      public static const BestLongSideFit:int = 1;
      
      public static const BestAreaFit:int = 2;
      
      public static const BottomLeftRule:int = 3;
      
      public static const ContactPointRule:int = 4;
      
      public static const AllMethods:Array = [0,1,2];
      
      private static var helperRect:NodeRect = new NodeRect();
       
      
      private var binWidth:int;
      
      private var binHeight:int;
      
      private var allowRotations:Boolean;
      
      private var usedRectangles:Vector.<NodeRect>;
      
      private var freeRectangles:Vector.<NodeRect>;
      
      public function MaxRects()
      {
         super();
         this.usedRectangles = new Vector.<NodeRect>();
         this.freeRectangles = new Vector.<NodeRect>();
      }
      
      public function init(param1:int, param2:int, param3:Boolean = false) : void
      {
         this.binWidth = param1;
         this.binHeight = param2;
         this.allowRotations = param3;
         var _loc4_:NodeRect = new NodeRect();
         _loc4_.x = 0;
         _loc4_.y = 0;
         _loc4_.width = param1;
         _loc4_.height = param2;
         this.usedRectangles.length = 0;
         this.freeRectangles.length = 0;
         this.freeRectangles.push(_loc4_);
      }
      
      public function insert(param1:NodeRect, param2:int) : NodeRect
      {
         var _loc3_:NodeRect = this.scoreRect(param1,param2);
         if(_loc3_.height == 0)
         {
            return null;
         }
         var _loc4_:NodeRect = new NodeRect();
         _loc4_.copyFrom(_loc3_);
         this.placeRect(_loc4_);
         return _loc4_;
      }
      
      public function pack(param1:Vector.<NodeRect>, param2:int) : Page
      {
         var _loc9_:* = 0;
         var _loc10_:NodeRect = null;
         var _loc3_:NodeRect = null;
         var _loc7_:int = 0;
         var _loc6_:NodeRect = null;
         var _loc5_:Vector.<NodeRect> = param1.concat();
         var _loc8_:int = _loc5_.length;
         while(_loc8_ > 0)
         {
            _loc9_ = -1;
            _loc10_ = new NodeRect();
            _loc10_.score1 = 2147483647;
            _loc10_.score2 = 2147483647;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc6_ = _loc5_[_loc7_];
               _loc3_ = this.scoreRect(_loc6_,param2);
               if(_loc3_.score1 < _loc10_.score1 || _loc3_.score1 == _loc10_.score1 && _loc3_.score2 < _loc10_.score2)
               {
                  _loc10_.copyFrom(_loc3_);
                  _loc9_ = _loc7_;
               }
               _loc7_++;
            }
            if(_loc9_ != -1)
            {
               this.placeRect(_loc10_);
               _loc5_.splice(_loc9_,1);
               _loc8_--;
               continue;
            }
            break;
         }
         var _loc4_:Page = this.getResult();
         _loc4_.remainingRects = _loc5_;
         return _loc4_;
      }
      
      public function getResult() : Page
      {
         var _loc3_:int = 0;
         var _loc2_:NodeRect = null;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = this.usedRectangles.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this.usedRectangles[_loc3_];
            _loc6_ = Math.max(_loc6_,_loc2_.x + _loc2_.width);
            _loc5_ = Math.max(_loc5_,_loc2_.y + _loc2_.height);
            _loc3_++;
         }
         var _loc1_:Page = new Page();
         _loc1_.outputRects = this.usedRectangles.concat();
         _loc1_.occupancy = this.getOccupancy();
         _loc1_.width = _loc6_;
         _loc1_.height = _loc5_;
         return _loc1_;
      }
      
      private function getOccupancy() : Number
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:int = this.usedRectangles.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = _loc3_ + this.usedRectangles[_loc2_].width * this.usedRectangles[_loc2_].height;
            _loc2_++;
         }
         return _loc3_ / (this.binWidth * this.binHeight);
      }
      
      private function placeRect(param1:NodeRect) : void
      {
         var _loc3_:int = this.freeRectangles.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.splitFreeNode(this.freeRectangles[_loc2_],param1))
            {
               this.freeRectangles.splice(_loc2_,1);
               _loc2_--;
               _loc3_--;
            }
            _loc2_++;
         }
         this.pruneFreeList();
         this.usedRectangles.push(param1);
      }
      
      private function scoreRect(param1:NodeRect, param2:int) : NodeRect
      {
         var _loc3_:NodeRect = null;
         var _loc4_:int = param1.width;
         var _loc5_:int = param1.height;
         helperRect.height = 0;
         switch(int(param2))
         {
            case 0:
               _loc3_ = this.findPositionForNewNodeBestShortSideFit(_loc4_,_loc5_);
               break;
            case 1:
               _loc3_ = this.findPositionForNewNodeBestLongSideFit(_loc4_,_loc5_);
               break;
            case 2:
               _loc3_ = this.findPositionForNewNodeBestAreaFit(_loc4_,_loc5_);
               break;
            case 3:
               _loc3_ = this.findPositionForNewNodeBottomLeft(_loc4_,_loc5_);
               break;
            case 4:
               _loc3_ = this.findPositionForNewNodeContactPoint(_loc4_,_loc5_);
               _loc3_.score1 = -_loc3_.score1;
         }
         if(_loc3_.height == 0)
         {
            _loc3_.score1 = 2147483647;
            _loc3_.score2 = 2147483647;
         }
         _loc3_.id = param1.id;
         _loc3_.srcParams = param1.srcParams;
         return _loc3_;
      }
      
      private function occupancy() : Number
      {
         var _loc3_:* = 0;
         var _loc2_:int = this.usedRectangles.length;
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = Number(_loc3_ + this.usedRectangles[_loc1_].width * this.usedRectangles[_loc1_].height);
            _loc1_++;
         }
         return _loc3_ / (this.binWidth * this.binHeight);
      }
      
      private function findPositionForNewNodeBottomLeft(param1:int, param2:int) : NodeRect
      {
         var _loc7_:NodeRect = null;
         var _loc3_:int = 0;
         var _loc6_:NodeRect = helperRect;
         _loc6_.score1 = 2147483647;
         var _loc4_:int = this.freeRectangles.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = this.freeRectangles[_loc5_];
            if(_loc7_.width >= param1 && _loc7_.height >= param2)
            {
               _loc3_ = _loc7_.y + param2;
               if(_loc3_ < _loc6_.score1 || _loc3_ == _loc6_.score1 && _loc7_.x < _loc6_.score2)
               {
                  _loc6_.x = _loc7_.x;
                  _loc6_.y = _loc7_.y;
                  _loc6_.width = param1;
                  _loc6_.height = param2;
                  _loc6_.score1 = _loc3_;
                  _loc6_.score2 = _loc7_.x;
                  _loc6_.rotated = false;
               }
            }
            if(this.allowRotations && _loc7_.width >= param2 && _loc7_.height >= param1)
            {
               _loc3_ = _loc7_.y + param1;
               if(_loc3_ < _loc6_.score1 || _loc3_ == _loc6_.score1 && _loc7_.x < _loc6_.score2)
               {
                  _loc6_.x = _loc7_.x;
                  _loc6_.y = _loc7_.y;
                  _loc6_.width = param2;
                  _loc6_.height = param1;
                  _loc6_.score1 = _loc3_;
                  _loc6_.score2 = _loc7_.x;
                  _loc6_.rotated = true;
               }
            }
            _loc5_++;
         }
         return _loc6_;
      }
      
      private function findPositionForNewNodeBestShortSideFit(param1:int, param2:int) : NodeRect
      {
         var _loc9_:NodeRect = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc14_:int = 0;
         var _loc12_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = 0;
         var _loc8_:NodeRect = helperRect;
         _loc8_.score1 = 2147483647;
         _loc8_.score2 = 0;
         var _loc13_:int = this.freeRectangles.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc13_)
         {
            _loc9_ = this.freeRectangles[_loc4_];
            if(_loc9_.width >= param1 && _loc9_.height >= param2)
            {
               _loc10_ = Math.abs(_loc9_.width - param1);
               _loc11_ = Math.abs(_loc9_.height - param2);
               _loc14_ = Math.min(_loc10_,_loc11_);
               _loc12_ = Math.max(_loc10_,_loc11_);
               if(_loc14_ < _loc8_.score1 || _loc14_ == _loc8_.score1 && _loc12_ < _loc8_.score2)
               {
                  _loc8_.x = _loc9_.x;
                  _loc8_.y = _loc9_.y;
                  _loc8_.width = param1;
                  _loc8_.height = param2;
                  _loc8_.score1 = _loc14_;
                  _loc8_.score2 = _loc12_;
                  _loc8_.rotated = false;
               }
            }
            if(this.allowRotations && _loc9_.width >= param2 && _loc9_.height >= param1)
            {
               _loc6_ = Math.abs(_loc9_.width - param2);
               _loc5_ = Math.abs(_loc9_.height - param1);
               _loc7_ = Math.min(_loc6_,_loc5_);
               _loc3_ = Math.max(_loc6_,_loc5_);
               if(_loc7_ < _loc8_.score1 || _loc7_ == _loc8_.score1 && _loc3_ < _loc8_.score2)
               {
                  _loc8_.x = _loc9_.x;
                  _loc8_.y = _loc9_.y;
                  _loc8_.width = param2;
                  _loc8_.height = param1;
                  _loc8_.score1 = _loc7_;
                  _loc8_.score2 = _loc3_;
                  _loc8_.rotated = true;
               }
            }
            _loc4_++;
         }
         return _loc8_;
      }
      
      private function findPositionForNewNodeBestLongSideFit(param1:int, param2:int) : NodeRect
      {
         var _loc10_:NodeRect = null;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:NodeRect = helperRect;
         _loc9_.score1 = 0;
         _loc9_.score2 = 2147483647;
         var _loc6_:int = this.freeRectangles.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc6_)
         {
            _loc10_ = this.freeRectangles[_loc4_];
            if(_loc10_.width >= param1 && _loc10_.height >= param2)
            {
               _loc3_ = Math.abs(_loc10_.width - param1);
               _loc5_ = Math.abs(_loc10_.height - param2);
               _loc8_ = Math.min(_loc3_,_loc5_);
               _loc7_ = Math.max(_loc3_,_loc5_);
               if(_loc7_ < _loc9_.score2 || _loc7_ == _loc9_.score2 && _loc8_ < _loc9_.score1)
               {
                  _loc9_.x = _loc10_.x;
                  _loc9_.y = _loc10_.y;
                  _loc9_.width = param1;
                  _loc9_.height = param2;
                  _loc9_.score1 = _loc8_;
                  _loc9_.score2 = _loc7_;
                  _loc9_.rotated = false;
               }
            }
            if(this.allowRotations && _loc10_.width >= param2 && _loc10_.height >= param1)
            {
               _loc3_ = Math.abs(_loc10_.width - param2);
               _loc5_ = Math.abs(_loc10_.height - param1);
               _loc8_ = Math.min(_loc3_,_loc5_);
               _loc7_ = Math.max(_loc3_,_loc5_);
               if(_loc7_ < _loc9_.score2 || _loc7_ == _loc9_.score2 && _loc8_ < _loc9_.score1)
               {
                  _loc9_.x = _loc10_.x;
                  _loc9_.y = _loc10_.y;
                  _loc9_.width = param2;
                  _loc9_.height = param1;
                  _loc9_.score1 = _loc8_;
                  _loc9_.score2 = _loc7_;
                  _loc9_.rotated = true;
               }
            }
            _loc4_++;
         }
         return _loc9_;
      }
      
      private function findPositionForNewNodeBestAreaFit(param1:int, param2:int) : NodeRect
      {
         var _loc10_:NodeRect = null;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:NodeRect = helperRect;
         _loc9_.score1 = 2147483647;
         _loc9_.score2 = 0;
         var _loc6_:int = this.freeRectangles.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc6_)
         {
            _loc10_ = this.freeRectangles[_loc4_];
            _loc7_ = _loc10_.width * _loc10_.height - param1 * param2;
            if(_loc10_.width >= param1 && _loc10_.height >= param2)
            {
               _loc3_ = Math.abs(_loc10_.width - param1);
               _loc5_ = Math.abs(_loc10_.height - param2);
               _loc8_ = Math.min(_loc3_,_loc5_);
               if(_loc7_ < _loc9_.score1 || _loc7_ == _loc9_.score1 && _loc8_ < _loc9_.score2)
               {
                  _loc9_.x = _loc10_.x;
                  _loc9_.y = _loc10_.y;
                  _loc9_.width = param1;
                  _loc9_.height = param2;
                  _loc9_.score2 = _loc8_;
                  _loc9_.score1 = _loc7_;
                  _loc9_.rotated = false;
               }
            }
            if(this.allowRotations && _loc10_.width >= param2 && _loc10_.height >= param1)
            {
               _loc3_ = Math.abs(_loc10_.width - param2);
               _loc5_ = Math.abs(_loc10_.height - param1);
               _loc8_ = Math.min(_loc3_,_loc5_);
               if(_loc7_ < _loc9_.score1 || _loc7_ == _loc9_.score1 && _loc8_ < _loc9_.score2)
               {
                  _loc9_.x = _loc10_.x;
                  _loc9_.y = _loc10_.y;
                  _loc9_.width = param2;
                  _loc9_.height = param1;
                  _loc9_.score2 = _loc8_;
                  _loc9_.score1 = _loc7_;
                  _loc9_.rotated = true;
               }
            }
            _loc4_++;
         }
         return _loc9_;
      }
      
      private function commonIntervalLength(param1:int, param2:int, param3:int, param4:int) : int
      {
         if(param2 < param3 || param4 < param1)
         {
            return 0;
         }
         return Math.min(param2,param4) - Math.max(param1,param3);
      }
      
      private function contactPointScoreNode(param1:int, param2:int, param3:int, param4:int) : int
      {
         var _loc6_:NodeRect = null;
         var _loc5_:int = 0;
         if(param1 == 0 || param1 + param3 == this.binWidth)
         {
            _loc5_ = _loc5_ + param4;
         }
         if(param2 == 0 || param2 + param4 == this.binHeight)
         {
            _loc5_ = _loc5_ + param3;
         }
         var _loc8_:int = this.usedRectangles.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = this.usedRectangles[_loc7_];
            if(_loc6_.x == param1 + param3 || _loc6_.x + _loc6_.width == param1)
            {
               _loc5_ = _loc5_ + this.commonIntervalLength(_loc6_.y,_loc6_.y + _loc6_.height,param2,param2 + param4);
            }
            if(_loc6_.y == param2 + param4 || _loc6_.y + _loc6_.height == param2)
            {
               _loc5_ = _loc5_ + this.commonIntervalLength(_loc6_.x,_loc6_.x + _loc6_.width,param1,param1 + param3);
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function findPositionForNewNodeContactPoint(param1:int, param2:int) : NodeRect
      {
         var _loc7_:NodeRect = null;
         var _loc3_:int = 0;
         var _loc6_:NodeRect = helperRect;
         _loc6_.score1 = -1;
         _loc6_.score2 = 0;
         var _loc4_:int = this.freeRectangles.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = this.freeRectangles[_loc5_];
            if(_loc7_.width >= param1 && _loc7_.height >= param2)
            {
               _loc3_ = this.contactPointScoreNode(_loc7_.x,_loc7_.y,param1,param2);
               if(_loc3_ > _loc6_.score1)
               {
                  _loc6_.x = _loc7_.x;
                  _loc6_.y = _loc7_.y;
                  _loc6_.width = param1;
                  _loc6_.height = param2;
                  _loc6_.score1 = _loc3_;
                  _loc6_.rotated = false;
               }
            }
            if(this.allowRotations && _loc7_.width >= param2 && _loc7_.height >= param1)
            {
               _loc3_ = this.contactPointScoreNode(_loc7_.x,_loc7_.y,param2,param1);
               if(_loc3_ > _loc6_.score1)
               {
                  _loc6_.x = _loc7_.x;
                  _loc6_.y = _loc7_.y;
                  _loc6_.width = param2;
                  _loc6_.height = param1;
                  _loc6_.score1 = _loc3_;
                  _loc6_.rotated = true;
               }
            }
            _loc5_++;
         }
         return _loc6_;
      }
      
      private function splitFreeNode(param1:NodeRect, param2:NodeRect) : Boolean
      {
         var _loc3_:NodeRect = null;
         if(param2.x >= param1.x + param1.width || param2.x + param2.width <= param1.x || param2.y >= param1.y + param1.height || param2.y + param2.height <= param1.y)
         {
            return false;
         }
         if(param2.x < param1.x + param1.width && param2.x + param2.width > param1.x)
         {
            if(param2.y > param1.y && param2.y < param1.y + param1.height)
            {
               _loc3_ = param1.clone();
               _loc3_.height = param2.y - _loc3_.y;
               this.freeRectangles.push(_loc3_);
            }
            if(param2.y + param2.height < param1.y + param1.height)
            {
               _loc3_ = param1.clone();
               _loc3_.y = param2.y + param2.height;
               _loc3_.height = param1.y + param1.height - (param2.y + param2.height);
               this.freeRectangles.push(_loc3_);
            }
         }
         if(param2.y < param1.y + param1.height && param2.y + param2.height > param1.y)
         {
            if(param2.x > param1.x && param2.x < param1.x + param1.width)
            {
               _loc3_ = param1.clone();
               _loc3_.width = param2.x - _loc3_.x;
               this.freeRectangles.push(_loc3_);
            }
            if(param2.x + param2.width < param1.x + param1.width)
            {
               _loc3_ = param1.clone();
               _loc3_.x = param2.x + param2.width;
               _loc3_.width = param1.x + param1.width - (param2.x + param2.width);
               this.freeRectangles.push(_loc3_);
            }
         }
         return true;
      }
      
      private function pruneFreeList() : void
      {
         var _loc1_:int = 0;
         var _loc3_:int = this.freeRectangles.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _loc2_ + 1;
            while(_loc1_ < _loc3_)
            {
               if(this.isContainedIn(this.freeRectangles[_loc2_],this.freeRectangles[_loc1_]))
               {
                  this.freeRectangles.splice(_loc2_,1);
                  _loc3_--;
                  break;
               }
               if(this.isContainedIn(this.freeRectangles[_loc1_],this.freeRectangles[_loc2_]))
               {
                  this.freeRectangles.splice(_loc1_,1);
                  _loc3_--;
               }
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      private function isContainedIn(param1:NodeRect, param2:NodeRect) : Boolean
      {
         return param1.x >= param2.x && param1.y >= param2.y && param1.x + param1.width <= param2.x + param2.width && param1.y + param1.height <= param2.y + param2.height;
      }
   }
}

package fairygui.editor.gui
{
   import fairygui.tween.CurveType;
   import fairygui.tween.GPath;
   import fairygui.tween.GPathPoint;
   import fairygui.tween.GTweener;
   
   public class FTransitionItem
   {
       
      
      private var _frame:int;
      
      private var _targetId:String;
      
      private var _type:String;
      
      private var _tween:Boolean;
      
      private var _usePath:Boolean;
      
      private var _pathPoints:Vector.<GPathPoint>;
      
      private var _path:GPath;
      
      private var _pathDirty:Boolean;
      
      public var easeType:String;
      
      public var easeInOutType:String;
      
      public var repeat:int;
      
      public var yoyo:Boolean;
      
      public var label:String;
      
      public var value:FTransitionValue;
      
      public var tweenValue:FTransitionValue;
      
      public var pathOffsetX:Number;
      
      public var pathOffsetY:Number;
      
      public var target:FObject;
      
      public var owner:FTransition;
      
      public var tweener:GTweener;
      
      public var innerTrans:FTransition;
      
      public var nextItem:FTransitionItem;
      
      public var prevItem:FTransitionItem;
      
      public var displayLockToken:uint;
      
      public function FTransitionItem(param1:FTransition)
      {
         super();
         this.owner = param1;
         this.easeType = "Quad";
         this.easeInOutType = "Out";
         this.value = new FTransitionValue();
         this.tweenValue = new FTransitionValue();
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
         this.owner._orderDirty = true;
      }
      
      public function get targetId() : String
      {
         return this._targetId;
      }
      
      public function set targetId(param1:String) : void
      {
         this._targetId = param1;
         this.owner._orderDirty = true;
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set frame(param1:int) : void
      {
         this._frame = param1;
         this.owner._orderDirty = true;
      }
      
      public function get tween() : Boolean
      {
         return this._tween;
      }
      
      public function set tween(param1:Boolean) : void
      {
         this._tween = param1;
         this.owner._orderDirty = true;
      }
      
      public function get easeName() : String
      {
         if(this.easeType == "Linear")
         {
            return this.easeType;
         }
         return this.easeType + "." + this.easeInOutType;
      }
      
      public function get usePath() : Boolean
      {
         return this._usePath;
      }
      
      public function set usePath(param1:Boolean) : void
      {
         this._usePath = param1;
         if(!this._usePath)
         {
            return;
         }
         if(!this._pathPoints)
         {
            this._pathPoints = new Vector.<GPathPoint>();
         }
         if(!this._path)
         {
            this._path = new GPath();
         }
         if(this._pathPoints.length < 2)
         {
            this._pathPoints.push(this.generateOrigin());
            this._pathPoints.push(GPathPoint.newCubicBezierPoint(0,0));
         }
         this._pathDirty = true;
      }
      
      public function get path() : GPath
      {
         return this._path;
      }
      
      public function get pathPoints() : Vector.<GPathPoint>
      {
         return this._pathPoints;
      }
      
      public function set pathPoints(param1:Vector.<GPathPoint>) : void
      {
         this._pathPoints = param1;
         this._pathDirty = true;
      }
      
      public function setPathToTweener() : void
      {
         var _loc1_:GPathPoint = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.pathOffsetX = this.tweener.startValue.x;
         this.pathOffsetY = this.tweener.startValue.y;
         if(this.nextItem)
         {
            _loc1_ = this._pathPoints[this._pathPoints.length - 1];
            if(this.nextItem.value.b1)
            {
               _loc2_ = this.nextItem.value.f1 - this.pathOffsetX;
            }
            else
            {
               _loc2_ = 0;
            }
            if(this.nextItem.value.b2)
            {
               _loc3_ = this.nextItem.value.f2 - this.pathOffsetY;
            }
            else
            {
               _loc3_ = 0;
            }
            if(_loc2_ != _loc1_.x || _loc3_ != _loc1_.y || this._pathDirty)
            {
               _loc1_.x = _loc2_;
               _loc1_.y = _loc3_;
               this._pathDirty = false;
               this._path.create(this._pathPoints);
            }
         }
         this.tweener.setPath(this._path);
      }
      
      private function generateOrigin() : GPathPoint
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:GPathPoint = GPathPoint.newCubicBezierPoint();
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(this.nextItem)
         {
            if(this.nextItem.value.b1)
            {
               _loc2_ = this.nextItem.value.f1 - this.value.f1;
            }
            if(this.nextItem.value.b2)
            {
               _loc3_ = this.nextItem.value.f2 - this.value.f2;
            }
            if(_loc2_ == 0 && _loc3_ == 0)
            {
               _loc4_ = Math.PI / 4;
            }
            else
            {
               _loc4_ = Math.acos(_loc2_ / Math.sqrt(Math.pow(_loc2_,2) + Math.pow(_loc3_,2)));
            }
            _loc5_ = 50;
            _loc6_ = _loc4_ + Math.PI / 6;
            _loc7_ = Math.PI + _loc4_ - Math.PI / 6;
            _loc1_.control1_x = Math.floor(_loc5_ * Math.cos(_loc6_));
            _loc1_.control1_y = Math.floor(_loc5_ * Math.sin(_loc6_));
            _loc1_.control2_x = Math.floor(_loc2_ + _loc5_ * Math.cos(_loc7_));
            _loc1_.control2_y = Math.floor(_loc3_ + _loc5_ * Math.sin(_loc7_));
         }
         else
         {
            _loc1_.control1_x = 50;
            _loc1_.control1_x = 50;
            _loc1_.control2_x = 100;
            _loc1_.control2_y = 100;
         }
         return _loc1_;
      }
      
      public function addPathPoint(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc11_:int = 0;
         var _loc4_:GPathPoint = GPathPoint.newCubicBezierPoint(param1,param2);
         var _loc5_:int = this._pathPoints.length;
         if(param3)
         {
            _loc11_ = this._path.findSegmentNear(param1,param2);
            _loc6_ = _loc11_ + 1;
         }
         else
         {
            _loc6_ = _loc5_ - 1;
         }
         this._pathPoints.splice(_loc6_,0,_loc4_);
         var _loc7_:GPathPoint = this._pathPoints[_loc6_ - 1];
         var _loc8_:GPathPoint = this._pathPoints[_loc6_ + 1];
         var _loc9_:Number = Math.sqrt(Math.pow(_loc8_.x - _loc7_.x,2) + Math.pow(_loc8_.y - _loc7_.y,2));
         if(_loc9_ == 0)
         {
            _loc9_ = 50;
         }
         var _loc10_:Number = 50;
         _loc4_.control2_x = _loc7_.control2_x;
         _loc4_.control2_y = _loc7_.control2_y;
         _loc7_.control2_x = _loc4_.x - _loc10_ * (_loc8_.x - _loc7_.x) / _loc9_;
         _loc7_.control2_y = _loc4_.y + _loc10_ * (_loc7_.y - _loc8_.y) / _loc9_;
         _loc4_.control1_x = _loc4_.x + _loc10_ * (_loc8_.x - _loc7_.x) / _loc9_;
         _loc4_.control1_y = _loc4_.y - _loc10_ * (_loc7_.y - _loc8_.y) / _loc9_;
         this._pathDirty = true;
      }
      
      public function removePathPoint(param1:int) : void
      {
         if(param1 == 0 || param1 == this._pathPoints.length - 1)
         {
            throw new Error("cannot remove end point");
         }
         var _loc2_:GPathPoint = this._pathPoints[param1];
         var _loc3_:GPathPoint = this._pathPoints[param1 - 1];
         if(_loc2_.curveType == CurveType.CubicBezier && _loc3_.curveType == CurveType.CubicBezier)
         {
            _loc3_.control2_x = _loc2_.control2_x;
            _loc3_.control2_y = _loc2_.control2_y;
         }
         this._pathPoints.splice(param1,1);
         this._pathDirty = true;
      }
      
      public function updatePathPoint(param1:int, param2:Number, param3:Number) : void
      {
         var _loc7_:GPathPoint = null;
         var _loc4_:GPathPoint = this._pathPoints[param1];
         var _loc5_:Number = param2 - _loc4_.x;
         var _loc6_:Number = param3 - _loc4_.y;
         _loc4_.x = param2;
         _loc4_.y = param3;
         _loc4_.control1_x = _loc4_.control1_x + _loc5_;
         _loc4_.control1_y = _loc4_.control1_y + _loc6_;
         if(param1 != 0)
         {
            _loc7_ = this._pathPoints[param1 - 1];
            if(_loc7_.curveType == CurveType.CubicBezier)
            {
               _loc7_.control2_x = _loc7_.control2_x + _loc5_;
               _loc7_.control2_y = _loc7_.control2_y + _loc6_;
            }
         }
         this._pathDirty = true;
      }
      
      public function updateControlPoint(param1:int, param2:int, param3:Number, param4:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:GPathPoint = null;
         var _loc9_:GPathPoint = null;
         var _loc5_:GPathPoint = this._pathPoints[param1];
         if(param2 == 0)
         {
            _loc5_.control1_x = param3;
            _loc5_.control1_y = param4;
            if(param1 != 0)
            {
               _loc8_ = this._pathPoints[param1 - 1];
               if(_loc8_.curveType == CurveType.CubicBezier && _loc5_.smooth)
               {
                  _loc6_ = Math.sqrt(Math.pow(_loc8_.control2_x - _loc5_.x,2) + Math.pow(_loc8_.control2_y - _loc5_.y,2));
                  _loc7_ = Math.sqrt(Math.pow(_loc5_.control1_x - _loc5_.x,2) + Math.pow(_loc5_.control1_y - _loc5_.y,2));
                  if(_loc7_ != 0)
                  {
                     _loc8_.control2_x = _loc5_.x - _loc6_ * (_loc5_.control1_x - _loc5_.x) / _loc7_;
                     _loc8_.control2_y = _loc5_.y - _loc6_ * (_loc5_.control1_y - _loc5_.y) / _loc7_;
                  }
               }
            }
         }
         else
         {
            _loc5_.control2_x = param3;
            _loc5_.control2_y = param4;
            if(param1 < this._pathPoints.length - 1)
            {
               _loc9_ = this._pathPoints[param1 + 1];
               if(_loc9_.curveType == CurveType.CubicBezier && _loc9_.smooth)
               {
                  _loc6_ = Math.sqrt(Math.pow(_loc9_.control1_x - _loc9_.x,2) + Math.pow(_loc9_.control1_y - _loc9_.y,2));
                  _loc7_ = Math.sqrt(Math.pow(_loc5_.control2_x - _loc9_.x,2) + Math.pow(_loc5_.control2_y - _loc9_.y,2));
                  if(_loc7_ != 0)
                  {
                     _loc9_.control1_x = _loc9_.x - _loc6_ * (_loc5_.control2_x - _loc9_.x) / _loc7_;
                     _loc9_.control1_y = _loc9_.y - _loc6_ * (_loc5_.control2_y - _loc9_.y) / _loc7_;
                  }
               }
            }
         }
         this._pathDirty = true;
      }
      
      public function get pathData() : String
      {
         var _loc4_:GPathPoint = null;
         var _loc1_:int = this._pathPoints.length;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this._pathPoints[_loc3_];
            if(_loc3_ == _loc1_ - 1)
            {
               if(this.nextItem.value.b1)
               {
                  _loc4_.x = this.nextItem.value.f1 - this.value.f1;
               }
               else
               {
                  _loc4_.x = 0;
               }
               if(this.nextItem.value.b2)
               {
                  _loc4_.y = this.nextItem.value.f2 - this.value.f2;
               }
               else
               {
                  _loc4_.y = 0;
               }
            }
            _loc2_.push(_loc4_.toString());
            _loc3_++;
         }
         return _loc2_.join(",");
      }
      
      public function set pathData(param1:String) : void
      {
         var _loc5_:GPathPoint = null;
         var _loc2_:Array = param1.split(",");
         if(_loc2_.length == 0)
         {
            return;
         }
         this._usePath = true;
         this._pathPoints = new Vector.<GPathPoint>();
         this._path = new GPath();
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new GPathPoint();
            _loc5_.curveType = parseInt(_loc2_[_loc4_++]);
            switch(_loc5_.curveType)
            {
               case CurveType.Bezier:
                  _loc5_.x = parseInt(_loc2_[_loc4_++]);
                  _loc5_.y = parseInt(_loc2_[_loc4_++]);
                  _loc5_.control1_x = parseInt(_loc2_[_loc4_++]);
                  _loc5_.control1_y = parseInt(_loc2_[_loc4_++]);
                  break;
               case CurveType.CubicBezier:
                  _loc5_.x = parseInt(_loc2_[_loc4_++]);
                  _loc5_.y = parseInt(_loc2_[_loc4_++]);
                  _loc5_.control1_x = parseInt(_loc2_[_loc4_++]);
                  _loc5_.control1_y = parseInt(_loc2_[_loc4_++]);
                  _loc5_.control2_x = parseInt(_loc2_[_loc4_++]);
                  _loc5_.control2_y = parseInt(_loc2_[_loc4_++]);
                  _loc5_.smooth = _loc2_[_loc4_++] == "1";
                  break;
               default:
                  _loc5_.x = parseInt(_loc2_[_loc4_++]);
                  _loc5_.y = parseInt(_loc2_[_loc4_++]);
            }
            this._pathPoints.push(_loc5_);
         }
         this._pathDirty = true;
      }
      
      public function get encodedValue() : String
      {
         return this.value.encode(this._type);
      }
      
      public function set encodedValue(param1:String) : void
      {
         this.value.decode(this._type,param1);
      }
   }
}

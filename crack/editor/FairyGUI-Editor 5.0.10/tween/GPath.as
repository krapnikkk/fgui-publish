package fairygui.tween
{
   import fairygui.utils.PointList;
   import fairygui.utils.ToolSet;
   import flash.geom.Point;
   
   public class GPath
   {
      
      private static var helperList:Vector.<GPathPoint> = new Vector.<GPathPoint>();
      
      private static var helperPoints:PointList = new PointList();
      
      private static var helperPoint:Point = new Point();
       
      
      private var _segments:Vector.<Segment>;
      
      private var _points:PointList;
      
      private var _fullLength:Number;
      
      public function GPath()
      {
         super();
         _segments = new Vector.<Segment>();
         _points = new PointList();
      }
      
      public function get length() : Number
      {
         return _fullLength;
      }
      
      public function create2(param1:GPathPoint, param2:GPathPoint, param3:GPathPoint = null, param4:GPathPoint = null) : void
      {
         helperList.length = 0;
         helperList.push(param1);
         helperList.push(param2);
         if(param3)
         {
            helperList.push(param3);
         }
         if(param4)
         {
            helperList.push(param4);
         }
         create(helperList);
      }
      
      public function create(param1:Vector.<GPathPoint>) : void
      {
         var _loc6_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         _segments.length = 0;
         _points.length = 0;
         helperPoints.length = 0;
         _fullLength = 0;
         var _loc5_:int = param1.length;
         if(_loc5_ == 0)
         {
            return;
         }
         var _loc4_:* = param1[0];
         if(_loc4_.curveType == 0)
         {
            helperPoints.push(_loc4_.x,_loc4_.y);
         }
         _loc6_ = 1;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = param1[_loc6_];
            if(_loc4_.curveType != 0)
            {
               _loc3_ = new Segment();
               _loc3_.type = _loc4_.curveType;
               _loc3_.ptStart = _points.length;
               if(_loc4_.curveType == 3)
               {
                  _loc3_.ptCount = 2;
                  _points.push(_loc4_.x,_loc4_.y);
                  _points.push(_loc2_.x,_loc2_.y);
               }
               else if(_loc4_.curveType == 1)
               {
                  _loc3_.ptCount = 3;
                  _points.push(_loc4_.x,_loc4_.y);
                  _points.push(_loc2_.x,_loc2_.y);
                  _points.push(_loc4_.control1_x,_loc4_.control1_y);
               }
               else if(_loc4_.curveType == 2)
               {
                  _loc3_.ptCount = 4;
                  _points.push(_loc4_.x,_loc4_.y);
                  _points.push(_loc2_.x,_loc2_.y);
                  _points.push(_loc4_.control1_x,_loc4_.control1_y);
                  _points.push(_loc4_.control2_x,_loc4_.control2_y);
               }
               _loc3_.length = ToolSet.distance(_loc4_.x,_loc4_.y,_loc2_.x,_loc2_.y);
               _fullLength = _fullLength + _loc3_.length;
               _segments.push(_loc3_);
            }
            if(_loc2_.curveType != 0)
            {
               if(helperPoints.length > 0)
               {
                  helperPoints.push(_loc2_.x,_loc2_.y);
                  createSplineSegment();
               }
            }
            else
            {
               helperPoints.push(_loc2_.x,_loc2_.y);
            }
            _loc4_ = _loc2_;
            _loc6_++;
         }
         if(helperPoints.length > 1)
         {
            createSplineSegment();
         }
      }
      
      private function createSplineSegment() : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = helperPoints.length;
         helperPoints.insert3(0,helperPoints,0);
         helperPoints.push3(helperPoints,_loc2_);
         helperPoints.push3(helperPoints,_loc2_);
         _loc2_ = _loc2_ + 3;
         var _loc1_:Segment = new Segment();
         _loc1_.type = 0;
         _loc1_.ptStart = _points.length;
         _loc1_.ptCount = _loc2_;
         _points.addRange(helperPoints);
         _loc1_.length = 0;
         _loc3_ = 1;
         while(_loc3_ < _loc2_)
         {
            _loc1_.length = _loc1_.length + ToolSet.distance(helperPoints.get_x(_loc3_ - 1),helperPoints.get_y(_loc3_ - 1),helperPoints.get_x(_loc3_),helperPoints.get_y(_loc3_));
            _loc3_++;
         }
         _fullLength = _fullLength + _loc1_.length;
         _segments.push(_loc1_);
         helperPoints.length = 0;
      }
      
      public function clear() : void
      {
         _segments.length = 0;
         _points.length = 0;
      }
      
      public function getPointAt(param1:Number, param2:Point = null) : Point
      {
         var _loc3_:* = null;
         var _loc6_:int = 0;
         if(param2 == null)
         {
            param2 = new Point();
         }
         else
         {
            param2.setTo(0,0);
         }
         param1 = ToolSet.clamp01(param1);
         var _loc5_:int = _segments.length;
         if(_loc5_ == 0)
         {
            return param2;
         }
         if(param1 == 1)
         {
            _loc3_ = _segments[_loc5_ - 1];
            if(_loc3_.type == 3)
            {
               param2.x = ToolSet.lerp(_points.get_x(_loc3_.ptStart),_points.get_x(_loc3_.ptStart + 1),param1);
               param2.y = ToolSet.lerp(_points.get_y(_loc3_.ptStart),_points.get_y(_loc3_.ptStart + 1),param1);
               return param2;
            }
            if(_loc3_.type == 1 || _loc3_.type == 2)
            {
               return onBezierCurve(_loc3_.ptStart,_loc3_.ptCount,param1,param2);
            }
            return onCRSplineCurve(_loc3_.ptStart,_loc3_.ptCount,param1,param2);
         }
         var _loc4_:Number = param1 * _fullLength;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _segments[_loc6_];
            _loc4_ = _loc4_ - _loc3_.length;
            if(_loc4_ < 0)
            {
               param1 = 1 + _loc4_ / _loc3_.length;
               if(_loc3_.type == 3)
               {
                  param2.x = ToolSet.lerp(_points.get_x(_loc3_.ptStart),_points.get_x(_loc3_.ptStart + 1),param1);
                  param2.y = ToolSet.lerp(_points.get_y(_loc3_.ptStart),_points.get_y(_loc3_.ptStart + 1),param1);
               }
               else if(_loc3_.type == 1 || _loc3_.type == 2)
               {
                  param2 = onBezierCurve(_loc3_.ptStart,_loc3_.ptCount,param1,param2);
               }
               else
               {
                  param2 = onCRSplineCurve(_loc3_.ptStart,_loc3_.ptCount,param1,param2);
               }
               break;
            }
            _loc6_++;
         }
         return param2;
      }
      
      public function get segmentCount() : int
      {
         return _segments.length;
      }
      
      public function getSegment(param1:int) : Object
      {
         return _segments[param1];
      }
      
      public function getAnchorsInSegment(param1:int, param2:PointList = null) : PointList
      {
         var _loc4_:int = 0;
         if(param2 == null)
         {
            param2 = new PointList();
         }
         var _loc3_:Segment = _segments[param1];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.ptCount)
         {
            param2.push3(_points,_loc3_.ptStart + _loc4_);
            _loc4_++;
         }
         return param2;
      }
      
      public function getPointsInSegment(param1:int, param2:Number, param3:Number, param4:PointList = null, param5:Vector.<Number> = null, param6:Number = 0.1) : PointList
      {
         var _loc8_:* = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc9_:Number = NaN;
         if(param4 == null)
         {
            param4 = new PointList();
         }
         if(param5 != null)
         {
            param5.push(param2);
         }
         var _loc7_:Segment = _segments[param1];
         if(_loc7_.type == 3)
         {
            param4.push(ToolSet.lerp(_points.get_x(_loc7_.ptStart),_points.get_x(_loc7_.ptStart + 1),param2),ToolSet.lerp(_points.get_y(_loc7_.ptStart),_points.get_y(_loc7_.ptStart + 1),param2));
            param4.push(ToolSet.lerp(_points.get_x(_loc7_.ptStart),_points.get_x(_loc7_.ptStart + 1),param3),ToolSet.lerp(_points.get_y(_loc7_.ptStart),_points.get_y(_loc7_.ptStart + 1),param3));
         }
         else
         {
            if(_loc7_.type == 1 || _loc7_.type == 2)
            {
               _loc8_ = onBezierCurve;
            }
            else
            {
               _loc8_ = onCRSplineCurve;
            }
            param4.push2(_loc8_(_loc7_.ptStart,_loc7_.ptCount,param2,helperPoint));
            _loc10_ = Math.min(_loc7_.length * param6,50);
            _loc11_ = 0;
            while(_loc11_ <= _loc10_)
            {
               _loc9_ = _loc11_ / _loc10_;
               if(_loc9_ > param2 && _loc9_ < param3)
               {
                  param4.push2(_loc8_(_loc7_.ptStart,_loc7_.ptCount,_loc9_,helperPoint));
                  if(param5 != null)
                  {
                     param5.push(_loc9_);
                  }
               }
               _loc11_++;
            }
            param4.push2(_loc8_(_loc7_.ptStart,_loc7_.ptCount,param3,helperPoint));
         }
         if(param5 != null)
         {
            param5.push(param3);
         }
         return param4;
      }
      
      public function getAllPoints(param1:PointList = null, param2:Vector.<Number> = null, param3:Number = 0.1) : PointList
      {
         var _loc5_:int = 0;
         if(param1 == null)
         {
            param1 = new PointList();
         }
         var _loc4_:int = _segments.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            getPointsInSegment(_loc5_,0,1,param1,param2,param3);
            _loc5_++;
         }
         return param1;
      }
      
      public function findSegmentNear(param1:Number, param2:Number) : int
      {
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc12_:* = null;
         var _loc14_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc9_:int = 0;
         var _loc6_:int = _segments.length;
         var _loc11_:* = 2147483647;
         var _loc10_:* = -1;
         _loc8_ = 0;
         while(_loc8_ < _loc6_)
         {
            _loc12_ = _segments[_loc8_];
            if(_loc12_.type == 3)
            {
               _loc14_ = _points.get_x(_loc12_.ptStart);
               _loc13_ = _points.get_y(_loc12_.ptStart);
               _loc16_ = _points.get_x(_loc12_.ptStart + 1);
               _loc15_ = _points.get_y(_loc12_.ptStart + 1);
               _loc3_ = _loc15_ - _loc13_;
               _loc4_ = _loc14_ - _loc16_;
               _loc5_ = _loc16_ * _loc13_ - _loc14_ * _loc15_;
               _loc7_ = ToolSet.pointLineDistance(param1,param2,_loc14_,_loc13_,_loc16_,_loc15_,true);
               if(_loc7_ < _loc11_)
               {
                  _loc11_ = _loc7_;
                  _loc10_ = _loc8_;
               }
            }
            else
            {
               helperPoints.length = 0;
               getPointsInSegment(_loc8_,0,1,helperPoints);
               _loc9_ = 0;
               while(_loc9_ < helperPoints.length)
               {
                  _loc7_ = ToolSet.distance(helperPoints.get_x(_loc9_),helperPoints.get_y(_loc9_),param1,param2);
                  if(_loc7_ < _loc11_)
                  {
                     _loc11_ = _loc7_;
                     _loc10_ = _loc8_;
                  }
                  _loc9_++;
               }
            }
            _loc8_++;
         }
         return _loc10_;
      }
      
      private function onCRSplineCurve(param1:int, param2:int, param3:Number, param4:Point) : Point
      {
         var _loc5_:int = Math.floor(param3 * (param2 - 4)) + param1;
         var _loc13_:Number = _points.get_x(_loc5_);
         var _loc12_:Number = _points.get_y(_loc5_);
         var _loc8_:Number = _points.get_x(_loc5_ + 1);
         var _loc14_:Number = _points.get_y(_loc5_ + 1);
         var _loc10_:Number = _points.get_x(_loc5_ + 2);
         var _loc9_:Number = _points.get_y(_loc5_ + 2);
         var _loc7_:Number = _points.get_x(_loc5_ + 3);
         var _loc11_:Number = _points.get_y(_loc5_ + 3);
         var _loc6_:Number = param3 == 1?1:Number(ToolSet.repeat(param3 * (param2 - 4),1));
         var _loc15_:Number = ((-_loc6_ + 2) * _loc6_ - 1) * _loc6_ * 0.5;
         var _loc16_:Number = ((3 * _loc6_ - 5) * _loc6_ * _loc6_ + 2) * 0.5;
         var _loc17_:Number = ((-3 * _loc6_ + 4) * _loc6_ + 1) * _loc6_ * 0.5;
         var _loc18_:Number = (_loc6_ - 1) * _loc6_ * _loc6_ * 0.5;
         param4.x = _loc13_ * _loc15_ + _loc8_ * _loc16_ + _loc10_ * _loc17_ + _loc7_ * _loc18_;
         param4.y = _loc12_ * _loc15_ + _loc14_ * _loc16_ + _loc9_ * _loc17_ + _loc11_ * _loc18_;
         return param4;
      }
      
      private function onBezierCurve(param1:int, param2:int, param3:Number, param4:Point) : Point
      {
         var _loc10_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = 1 - param3;
         var _loc8_:Number = _points.get_x(param1);
         var _loc6_:Number = _points.get_y(param1);
         var _loc5_:Number = _points.get_x(param1 + 1);
         var _loc9_:Number = _points.get_y(param1 + 1);
         var _loc11_:Number = _points.get_x(param1 + 2);
         var _loc7_:Number = _points.get_y(param1 + 2);
         if(param2 == 4)
         {
            _loc10_ = _points.get_x(param1 + 3);
            _loc12_ = _points.get_y(param1 + 3);
            param4.x = _loc13_ * _loc13_ * _loc13_ * _loc8_ + 3 * _loc13_ * _loc13_ * param3 * _loc11_ + 3 * _loc13_ * param3 * param3 * _loc10_ + param3 * param3 * param3 * _loc5_;
            param4.y = _loc13_ * _loc13_ * _loc13_ * _loc6_ + 3 * _loc13_ * _loc13_ * param3 * _loc7_ + 3 * _loc13_ * param3 * param3 * _loc12_ + param3 * param3 * param3 * _loc9_;
         }
         else
         {
            param4.x = _loc13_ * _loc13_ * _loc8_ + 2 * _loc13_ * param3 * _loc11_ + param3 * param3 * _loc5_;
            param4.y = _loc13_ * _loc13_ * _loc6_ + 2 * _loc13_ * param3 * _loc7_ + param3 * param3 * _loc9_;
         }
         return param4;
      }
   }
}

class Segment
{
    
   
   public var type:int;
   
   public var length:Number;
   
   public var ptStart:int;
   
   public var ptCount:int;
   
   function Segment()
   {
      super();
   }
}

package fairygui.tween
{
   public class GPathPoint
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var control1_x:Number;
      
      public var control1_y:Number;
      
      public var control2_x:Number;
      
      public var control2_y:Number;
      
      public var curveType:int;
      
      public var smooth:Boolean;
      
      public function GPathPoint()
      {
         super();
         x = 0;
         y = 0;
         control1_x = 0;
         control1_y = 0;
         control2_x = 0;
         control2_y = 0;
         curveType = 0;
         smooth = true;
      }
      
      public static function newPoint(param1:Number = 0, param2:Number = 0, param3:int = 0) : GPathPoint
      {
         var _loc4_:GPathPoint = new GPathPoint();
         _loc4_.x = param1;
         _loc4_.y = param2;
         _loc4_.control1_x = 0;
         _loc4_.control1_y = 0;
         _loc4_.control2_x = 0;
         _loc4_.control2_y = 0;
         _loc4_.curveType = param3;
         return _loc4_;
      }
      
      public static function newBezierPoint(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : GPathPoint
      {
         var _loc5_:GPathPoint = new GPathPoint();
         _loc5_.x = param1;
         _loc5_.y = param2;
         _loc5_.control1_x = param3;
         _loc5_.control1_y = param4;
         _loc5_.control2_x = 0;
         _loc5_.control2_y = 0;
         _loc5_.curveType = 1;
         return _loc5_;
      }
      
      public static function newCubicBezierPoint(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0) : GPathPoint
      {
         var _loc7_:GPathPoint = new GPathPoint();
         _loc7_.x = param1;
         _loc7_.y = param2;
         _loc7_.control1_x = param3;
         _loc7_.control1_y = param4;
         _loc7_.control2_x = param5;
         _loc7_.control2_y = param6;
         _loc7_.curveType = 2;
         return _loc7_;
      }
      
      public function clone() : GPathPoint
      {
         var _loc1_:GPathPoint = new GPathPoint();
         _loc1_.x = x;
         _loc1_.y = y;
         _loc1_.control1_x = control1_x;
         _loc1_.control1_y = control1_y;
         _loc1_.control2_x = control2_x;
         _loc1_.control2_y = control2_y;
         _loc1_.curveType = curveType;
         return _loc1_;
      }
      
      public function toString() : String
      {
         switch(int(curveType) - 1)
         {
            case 0:
               return curveType + "," + x + "," + y + "," + control1_x + "," + control1_y;
            case 1:
               return curveType + "," + x + "," + y + "," + control1_x + "," + control1_y + "," + control2_x + "," + control2_y + "," + (!!smooth?1:0);
         }
      }
   }
}

package fairygui.utils
{
   import flash.geom.Point;
   
   public class PointList
   {
       
      
      private var _list:Vector.<Number>;
      
      public function PointList()
      {
         super();
         _list = new Vector.<Number>();
      }
      
      public function get rawList() : Vector.<Number>
      {
         return _list;
      }
      
      public function set rawList(param1:Vector.<Number>) : void
      {
         _list = param1;
      }
      
      public function push(param1:Number, param2:Number) : void
      {
         _list.push(param1);
         _list.push(param2);
      }
      
      public function push2(param1:Point) : void
      {
         _list.push(param1.x);
         _list.push(param1.y);
      }
      
      public function push3(param1:PointList, param2:int) : void
      {
         _list.push(param1._list[param2 * 2]);
         _list.push(param1._list[param2 * 2 + 1]);
      }
      
      public function addRange(param1:PointList) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1._list.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _list.push(param1._list[_loc3_]);
            _loc3_++;
         }
      }
      
      public function insert(param1:int, param2:Number, param3:Number) : void
      {
         _list.splice(param1 * 2,0,param2,param3);
      }
      
      public function insert2(param1:int, param2:Point) : void
      {
         _list.splice(param1 * 2,0,param2.x,param2.y);
      }
      
      public function insert3(param1:int, param2:PointList, param3:int) : void
      {
         _list.splice(param1 * 2,0,param2._list[param3 * 2],param2._list[param3 * 2 + 1]);
      }
      
      public function remove(param1:int) : void
      {
         _list.splice(param1 * 2,2);
      }
      
      public function get_x(param1:int) : Number
      {
         return _list[param1 * 2];
      }
      
      public function get_y(param1:int) : Number
      {
         return _list[param1 * 2 + 1];
      }
      
      public function set(param1:int, param2:Number, param3:Number) : void
      {
         _list[param1 * 2] = param2;
         _list[param1 * 2 + 1] = param3;
      }
      
      public function setBy(param1:int, param2:Number, param3:Number) : void
      {
         var _loc4_:* = param1 * 2;
         var _loc5_:* = _list[_loc4_] + param2;
         _list[_loc4_] = _loc5_;
         _loc5_ = param1 * 2 + 1;
         _loc4_ = _list[_loc5_] + param3;
         _list[_loc5_] = _loc4_;
      }
      
      public function get length() : int
      {
         return _list.length / 2;
      }
      
      public function set length(param1:int) : void
      {
         _list.length = param1 * 2;
      }
      
      public function join(param1:String) : String
      {
         return _list.join(param1);
      }
      
      public function clone() : PointList
      {
         var _loc1_:PointList = new PointList();
         _loc1_.rawList = this.rawList.concat();
         return _loc1_;
      }
   }
}

package fairygui
{
   public class Margin
   {
       
      
      public var left:int;
      
      public var right:int;
      
      public var top:int;
      
      public var bottom:int;
      
      public function Margin()
      {
         super();
      }
      
      public function parse(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = param1.split(",");
         if(_loc2_.length == 1)
         {
            _loc3_ = _loc2_[0];
            top = _loc3_;
            bottom = _loc3_;
            left = _loc3_;
            right = _loc3_;
         }
         else
         {
            top = int(_loc2_[0]);
            bottom = int(_loc2_[1]);
            left = int(_loc2_[2]);
            right = int(_loc2_[3]);
         }
      }
      
      public function copy(param1:Margin) : void
      {
         top = param1.top;
         bottom = param1.bottom;
         left = param1.left;
         right = param1.right;
      }
   }
}

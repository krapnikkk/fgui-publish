package fairygui.utils.pack
{
   public class NodeRect
   {
      
      public static const DUPLICATE_PADDING:int = 1;
      
      public static const NO_ROTATION:int = 2;
       
      
      public var x:int;
      
      public var y:int;
      
      public var width:int;
      
      public var height:int;
      
      public var rotated:Boolean;
      
      public var index:int;
      
      public var subIndex:int;
      
      public var flags:int;
      
      public var score1:int;
      
      public var score2:int;
      
      public function NodeRect(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.width = param3;
         this.height = param4;
         this.subIndex = -1;
      }
      
      public function copyFrom(param1:NodeRect) : void
      {
         this.index = param1.index;
         this.subIndex = param1.subIndex;
         this.x = param1.x;
         this.y = param1.y;
         this.width = param1.width;
         this.height = param1.height;
         this.rotated = param1.rotated;
         this.score1 = param1.score1;
         this.score2 = param1.score2;
         this.flags = param1.flags;
      }
      
      public function clone() : NodeRect
      {
         var _loc1_:NodeRect = new NodeRect();
         _loc1_.index = this.index;
         _loc1_.subIndex = this.subIndex;
         _loc1_.x = this.x;
         _loc1_.y = this.y;
         _loc1_.width = this.width;
         _loc1_.height = this.height;
         _loc1_.rotated = this.rotated;
         _loc1_.score1 = this.score1;
         _loc1_.score2 = this.score2;
         _loc1_.flags = this.flags;
         return _loc1_;
      }
      
      public final function get duplicatePadding() : Boolean
      {
         return (this.flags & DUPLICATE_PADDING) != 0;
      }
      
      public final function get allowRotation() : Boolean
      {
         return (this.flags & NO_ROTATION) == 0;
      }
   }
}

package fairygui.editor.pack
{
   public class NodeRect
   {
       
      
      public var x:int;
      
      public var y:int;
      
      public var width:int;
      
      public var height:int;
      
      public var rotated:Boolean;
      
      public var id:int;
      
      public var score1:int;
      
      public var score2:int;
      
      public var srcParams:Object;
      
      public function NodeRect(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Object = null)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.width = param3;
         this.height = param4;
         this.srcParams = param5;
      }
      
      public function copyFrom(param1:NodeRect) : void
      {
         this.id = param1.id;
         this.x = param1.x;
         this.y = param1.y;
         this.width = param1.width;
         this.height = param1.height;
         this.rotated = param1.rotated;
         this.score1 = param1.score1;
         this.score2 = param1.score2;
         this.srcParams = param1.srcParams;
      }
      
      public function clone() : NodeRect
      {
         var _loc1_:NodeRect = new NodeRect();
         _loc1_.id = this.id;
         _loc1_.x = this.x;
         _loc1_.y = this.y;
         _loc1_.width = this.width;
         _loc1_.height = this.height;
         _loc1_.rotated = this.rotated;
         _loc1_.score1 = this.score1;
         _loc1_.score2 = this.score2;
         _loc1_.srcParams = this.srcParams;
         return _loc1_;
      }
   }
}

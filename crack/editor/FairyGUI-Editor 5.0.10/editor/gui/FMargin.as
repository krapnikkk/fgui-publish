package fairygui.editor.gui
{
   public class FMargin
   {
       
      
      public var left:int;
      
      public var right:int;
      
      public var top:int;
      
      public var bottom:int;
      
      public function FMargin()
      {
         super();
      }
      
      public function parse(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = param1.split(",");
         if(_loc2_.length == 1)
         {
            _loc3_ = int(_loc2_[0]);
            this.top = _loc3_;
            this.bottom = _loc3_;
            this.left = _loc3_;
            this.right = _loc3_;
         }
         else
         {
            this.top = int(_loc2_[0]);
            this.bottom = int(_loc2_[1]);
            this.left = int(_loc2_[2]);
            this.right = int(_loc2_[3]);
         }
      }
      
      public function get empty() : Boolean
      {
         return this.left == 0 && this.right == 0 && this.top == 0 && this.bottom == 0;
      }
      
      public function reset() : void
      {
         this.left = this.right = this.top = this.bottom = 0;
      }
      
      public function copy(param1:FMargin) : void
      {
         this.left = param1.left;
         this.right = param1.right;
         this.top = param1.top;
         this.bottom = param1.bottom;
      }
      
      public function toString() : String
      {
         return this.top + "," + this.bottom + "," + this.left + "," + this.right;
      }
   }
}

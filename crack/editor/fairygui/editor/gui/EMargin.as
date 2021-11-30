package fairygui.editor.gui
{
   public class EMargin
   {
       
      
      public var left:int;
      
      public var right:int;
      
      public var top:int;
      
      public var bottom:int;
      
      public function EMargin()
      {
         super();
      }
      
      public function parse(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = param1.split(",");
         if(_loc3_.length == 1)
         {
            _loc2_ = _loc3_[0];
            this.top = _loc2_;
            this.bottom = _loc2_;
            this.left = _loc2_;
            this.right = _loc2_;
         }
         else
         {
            this.top = int(_loc3_[0]);
            this.bottom = int(_loc3_[1]);
            this.left = int(_loc3_[2]);
            this.right = int(_loc3_[3]);
         }
      }
      
      public function get empty() : Boolean
      {
         return this.left == 0 && this.right == 0 && this.top == 0 && this.bottom == 0;
      }
      
      public function reset() : void
      {
         var _loc1_:* = 0;
         this.bottom = _loc1_;
         _loc1_ = _loc1_;
         this.top = _loc1_;
         _loc1_ = _loc1_;
         this.right = _loc1_;
         this.left = _loc1_;
      }
      
      public function toString() : String
      {
         return this.top + "," + this.bottom + "," + this.left + "," + this.right;
      }
   }
}

package fairygui.editor.gui
{
   public class ERelationDef
   {
       
      
      public var valid:Boolean;
      
      public var selfSide:String;
      
      public var targetSide:String;
      
      public var affectBySelfSizeChanged:Boolean;
      
      public var percent:Boolean;
      
      public var type:int;
      
      public function ERelationDef()
      {
         super();
      }
      
      public function toString() : String
      {
         if(this.valid)
         {
            return this.selfSide + "-" + this.targetSide + (!!this.percent?"%":"");
         }
         return "";
      }
   }
}

package fairygui.editor.gui
{
   public class FRelationDef
   {
       
      
      public var affectBySelfSizeChanged:Boolean;
      
      public var percent:Boolean;
      
      public var type:int;
      
      public function FRelationDef()
      {
         super();
      }
      
      public function toString() : String
      {
         return FRelationType.Names[this.type] + (!!this.percent?"%":"");
      }
   }
}

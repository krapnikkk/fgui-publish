package fairygui.editor.publish
{
   import fairygui.editor.gui.EPackageItem;
   
   public class AtlasItem
   {
       
      
      public var index:int;
      
      public var id:String;
      
      public var alphaChannel:Boolean;
      
      public var items:Vector.<EPackageItem>;
      
      public function AtlasItem()
      {
         super();
         this.items = new Vector.<EPackageItem>();
      }
   }
}

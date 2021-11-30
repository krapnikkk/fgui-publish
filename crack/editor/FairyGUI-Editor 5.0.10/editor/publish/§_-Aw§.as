package fairygui.editor.publish
{
   import fairygui.editor.gui.FPackageItem;
   
   public class AtlasItem
   {
       
      
      public var index:int;
      
      public var id:String;
      
      public var alphaChannel:Boolean;
      
      public var npot:Boolean;
      
      public var mof:Boolean;
      
      public var items:Vector.<FPackageItem>;
      
      public function AtlasItem()
      {
         super();
         this.items = new Vector.<FPackageItem>();
      }
   }
}

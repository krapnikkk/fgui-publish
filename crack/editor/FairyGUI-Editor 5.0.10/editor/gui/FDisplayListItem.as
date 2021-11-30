package fairygui.editor.gui
{
   import fairygui.utils.XData;
   
   public class FDisplayListItem
   {
       
      
      public var packageItem:FPackageItem;
      
      public var pkg:FPackage;
      
      public var type:String;
      
      public var desc:XData;
      
      public var missingInfo:MissingInfo;
      
      public var existingInstance:FObject;
      
      public function FDisplayListItem(param1:FPackageItem, param2:FPackage, param3:String)
      {
         super();
         this.packageItem = param1;
         this.pkg = param2;
         this.type = param3;
      }
   }
}

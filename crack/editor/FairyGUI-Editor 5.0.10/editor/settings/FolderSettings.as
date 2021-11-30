package fairygui.editor.settings
{
   import fairygui.editor.gui.FPackageItem;
   import fairygui.utils.XData;
   
   public class FolderSettings
   {
       
      
      public var atlas:String;
      
      public function FolderSettings()
      {
         super();
      }
      
      public function get empty() : Boolean
      {
         return this.atlas == null;
      }
      
      public function read(param1:FPackageItem, param2:XData) : void
      {
         this.atlas = param2.getAttribute("atlas");
      }
      
      public function write(param1:FPackageItem, param2:XData, param3:Boolean) : void
      {
         if(this.atlas != null && !param3)
         {
            param2.setAttribute("atlas",this.atlas);
         }
      }
   }
}

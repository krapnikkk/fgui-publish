package fairygui.editor.settings
{
   import fairygui.editor.gui.FPackageItem;
   import fairygui.utils.XData;
   
   public class FontSettings
   {
       
      
      public var texture:String;
      
      public function FontSettings()
      {
         super();
      }
      
      public function read(param1:FPackageItem, param2:XData) : void
      {
         this.texture = param2.getAttribute("texture");
      }
      
      public function write(param1:FPackageItem, param2:XData, param3:Boolean) : void
      {
         if(this.texture)
         {
            param2.setAttribute("texture",this.texture);
         }
      }
      
      public function copyFrom(param1:FontSettings) : void
      {
         this.texture = param1.texture;
      }
   }
}

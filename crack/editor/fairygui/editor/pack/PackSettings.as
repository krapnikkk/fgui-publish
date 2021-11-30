package fairygui.editor.pack
{
   import fairygui.editor.settings.AtlasSettings;
   
   public class PackSettings
   {
       
      
      public var pot:Boolean = true;
      
      public var padding:int = 2;
      
      public var rotation:Boolean = false;
      
      public var minWidth:int = 16;
      
      public var minHeight:int = 16;
      
      public var maxWidth:int = 2048;
      
      public var maxHeight:int = 2048;
      
      public var square:Boolean = false;
      
      public var fast:Boolean = true;
      
      public var edgePadding:Boolean = false;
      
      public var duplicatePadding:Boolean = false;
      
      public var multiPage:Boolean = false;
      
      public function PackSettings()
      {
         Page;
         super();
      }
      
      public function copyFrom(param1:AtlasSettings) : void
      {
         this.pot = param1.pot;
         this.padding = param1.padding;
         this.rotation = param1.rotation;
         this.minWidth = param1.minWidth;
         this.minHeight = param1.minHeight;
         this.maxWidth = param1.maxWidth;
         this.maxHeight = param1.maxHeight;
         this.square = param1.square;
         this.fast = param1.fast;
         this.edgePadding = param1.edgePadding;
         this.duplicatePadding = param1.duplicatePadding;
         this.multiPage = param1.multiPage;
      }
   }
}

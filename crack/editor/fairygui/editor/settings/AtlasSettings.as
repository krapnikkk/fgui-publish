package fairygui.editor.settings
{
   import fairygui.editor.pack.PackSettings;
   
   public class AtlasSettings extends PackSettings
   {
       
      
      public var name:String;
      
      public var compression:Boolean;
      
      public var extractAlpha:Boolean;
      
      public function AtlasSettings()
      {
         super();
      }
      
      override public function copyFrom(param1:AtlasSettings) : void
      {
         super.copyFrom(param1);
         this.name = param1.name;
         this.compression = param1.compression;
         this.extractAlpha = param1.extractAlpha;
      }
   }
}

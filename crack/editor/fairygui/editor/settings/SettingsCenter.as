package fairygui.editor.settings
{
   import fairygui.editor.gui.EUIProject;
   
   public class SettingsCenter
   {
       
      
      public var common:CommonSettings;
      
      public var publish:GlobalPublishSettings;
      
      public var customProps:CustomProps;
      
      public var adaptation:AdaptationSettings;
      
      public var workspace:WorkSpace;
      
      public function SettingsCenter(param1:EUIProject)
      {
         super();
         this.common = new CommonSettings();
         this.common.project = param1;
         this.publish = new GlobalPublishSettings();
         this.publish.project = param1;
         this.customProps = new CustomProps();
         this.customProps.project = param1;
         this.adaptation = new AdaptationSettings();
         this.adaptation.project = param1;
         this.workspace = new WorkSpace();
         this.workspace.project = param1;
      }
      
      public function loadAll() : void
      {
         this.common.load();
         this.publish.load();
         this.adaptation.load();
         this.customProps.load();
         this.workspace.load();
      }
   }
}

package fairygui.editor
{
   import fairygui.GComboBox;
   import fairygui.GComponent;
   import fairygui.editor.dialogs.ProjectSettingsDialog;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.settings.AdaptationSettings;
   import flash.events.Event;
   
   public class AdaptationPanel
   {
       
      
      public var self:GComponent;
      
      private var _editorWindow:EditorWindow;
      
      private var _object:EGComponent;
      
      private var _screenSize:GComboBox;
      
      private var _screenMatch:GComboBox;
      
      public function AdaptationPanel(param1:EditorWindow, param2:GComponent)
      {
         super();
         this.self = param2;
         this._editorWindow = param1;
         this._screenSize = this.self.getChild("screenSize").asComboBox;
         this._screenSize.addEventListener("stateChanged",this.__screenSizeChanged);
         this.self.getChild("enabled").asButton.addEventListener("stateChanged",this.__optionChanged);
         this._screenMatch = this.self.getChild("screenMatch").asComboBox;
         this._screenMatch.addEventListener("stateChanged",this.__optionChanged);
         this.self.getChild("contentScaler").addClickListener(this.__clickContentScaler);
      }
      
      public function update(param1:EGComponent) : void
      {
         this._object = param1;
         var _loc2_:AdaptationSettings = this._editorWindow.project.settingsCenter.adaptation;
         if(this._screenSize.items.length == 0)
         {
            _loc2_.fillCombo(this._screenSize);
         }
         if(param1.adaptationTest)
         {
            this.self.getChild("enabled").asButton.selected = true;
            this._screenMatch.value = param1.adaptationTest;
         }
         else
         {
            this.self.getChild("enabled").asButton.selected = false;
            this._screenMatch.value = "FitSize";
         }
         if(this._object.packageItem.testPanelScreenSize)
         {
            this._screenSize.value = this._object.packageItem.testPanelScreenSize;
         }
         else
         {
            this._screenSize.value = _loc2_.defaultResolution;
         }
      }
      
      public function getScreenSize() : Array
      {
         var _loc2_:String = this._screenSize.value;
         var _loc1_:Array = _loc2_.split(",");
         return [parseInt(_loc1_[0]),parseInt(_loc1_[1]),_loc1_[2] == "0"?true:false];
      }
      
      private function __screenSizeChanged(param1:Event) : void
      {
         this._object.packageItem.testPanelScreenSize = this._screenSize.value;
         this._editorWindow.mainPanel.testPanel.applyAdaptation();
      }
      
      private function __clickContentScaler(param1:Event) : void
      {
         ProjectSettingsDialog(this._editorWindow.getDialog(ProjectSettingsDialog)).openAdaptationSettings();
      }
      
      private function __optionChanged(param1:Event) : void
      {
         var _loc2_:ComDocument = this._editorWindow.activeComDocument;
         if(this.self.getChild("enabled").asButton.selected)
         {
            this._object.adaptationTest = this._screenMatch.value;
            _loc2_.editingContent.setProperty("adaptationTest",this._screenMatch.value);
         }
         else
         {
            this._object.adaptationTest = null;
            _loc2_.editingContent.setProperty("adaptationTest",null);
         }
         _loc2_.editingContent.setModified();
         this._editorWindow.mainPanel.testPanel.applyAdaptation();
      }
   }
}

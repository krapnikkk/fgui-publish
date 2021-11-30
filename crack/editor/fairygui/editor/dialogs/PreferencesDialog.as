package fairygui.editor.dialogs
{
   import fairygui.GComboBox;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.settings.Preferences;
   
   public class PreferencesDialog extends WindowBase
   {
       
      
      public function PreferencesDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","PreferencesDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         _loc2_ = contentPane.getChild("crop_resource").asComboBox;
         _loc2_.items = [Consts.g.text88,Consts.g.text89,Consts.g.text90];
         _loc2_.values = ["yes","no","ask"];
         _loc2_ = contentPane.getChild("language").asComboBox;
         _loc2_.items = Consts.supportedLangNames;
         _loc2_.values = Consts.supportedLanaguages;
         _loc2_ = contentPane.getChild("check_new_version").asComboBox;
         _loc2_.items = [Consts.g.text317,Consts.g.text318,Consts.g.text319];
         _loc2_.values = ["auto","ask","disabled"];
         contentPane.getChild("ok").addClickListener(__actionHandler);
         contentPane.getChild("cancel").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         contentPane.getChild("crop_resource").asComboBox.value = Preferences.cropResource;
         contentPane.getChild("language").asComboBox.value = Preferences.language;
         contentPane.getChild("check_new_version").asComboBox.value = Preferences.checkNewVersion;
      }
      
      override public function actionHandler() : void
      {
         Preferences.cropResource = contentPane.getChild("crop_resource").asComboBox.value;
         Preferences.language = contentPane.getChild("language").asComboBox.value;
         Preferences.checkNewVersion = contentPane.getChild("check_new_version").asComboBox.value;
         Preferences.save();
         hide();
      }
   }
}

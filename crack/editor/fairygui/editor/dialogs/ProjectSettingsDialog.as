package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.settings.AdaptationSettings;
   import fairygui.editor.settings.CommonSettings;
   import fairygui.editor.settings.CustomProps;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   
   public class ProjectSettingsDialog extends WindowBase
   {
       
      
      private var _propsList:GList;
      
      public function ProjectSettingsDialog(param1:EditorWindow)
      {
         var _loc4_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ProjectSettingsDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         _loc4_ = contentPane.getChild("scrollBarDisplay").asComboBox;
         _loc4_.items = [Consts.g.text91,Consts.g.text92,Consts.g.text93];
         _loc4_.values = ["visible","auto","hidden"];
         _loc4_ = contentPane.getChild("projectType").asComboBox;
         _loc4_.items = Consts.supportedPlatforms;
         _loc4_.values = Consts.supportedPlatforms;
         this._propsList = contentPane.getChild("customProps").asList;
         var _loc2_:int = 0;
         while(_loc2_ < 20)
         {
            this._propsList.addItemFromPool();
            _loc2_++;
         }
         var _loc3_:AdaptationSettings = _editorWindow.project.settingsCenter.adaptation;
         _loc3_.fillCombo(contentPane.getChild("defaultResolution").asComboBox);
         this.contentPane.getChild("chooseFont").addClickListener(this.__clickChooseFont);
         this.contentPane.getChild("ok").addClickListener(__actionHandler);
         this.contentPane.getChild("apply").addClickListener(this.__apply);
         this.contentPane.getChild("cancel").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         var _loc1_:* = null;
         var _loc3_:GButton = null;
         var _loc7_:EUIProject = _editorWindow.project;
         contentPane.getChild("projectName").text = _loc7_.name;
         contentPane.getChild("projectType").asComboBox.value = _loc7_.type;
         contentPane.getChild("disableFontAdjustment").visible = _loc7_.isH5;
         var _loc6_:CommonSettings = _loc7_.settingsCenter.common;
         contentPane.getChild("fontName").text = _loc6_.font;
         NumericInput(contentPane.getChild("fontSize")).value = _loc6_.fontSize;
         ColorInput(contentPane.getChild("textColor")).colorValue = _loc6_.textColor;
         contentPane.getChild("disableFontAdjustment").asButton.selected = !_loc6_.fontAdjustment;
         contentPane.getChild("vtScrollBarRes").text = _loc6_.verticalScrollBar;
         contentPane.getChild("hzScrollBarRes").text = _loc6_.horizontalScrollBar;
         contentPane.getChild("scrollBarDisplay").asComboBox.value = _loc6_.defaultScrollBarDisplay;
         contentPane.getChild("tipsRes").text = _loc6_.tipsRes;
         contentPane.getChild("buttonClickSound").text = _loc6_.buttonClickSound;
         contentPane.getChild("colorScheme").text = _loc6_.colorScheme.join("\n");
         contentPane.getChild("fontSizeScheme").text = _loc6_.fontSizeScheme.join("\n");
         var _loc4_:CustomProps = _loc7_.settingsCenter.customProps;
         var _loc5_:int = 0;
         var _loc9_:int = 0;
         var _loc8_:* = _loc4_.all;
         for(_loc1_ in _loc4_.all)
         {
            _loc3_ = this._propsList.getChildAt(_loc5_).asButton;
            _loc3_.getChild("text").text = _loc1_;
            _loc3_.getChild("value").text = _loc4_.all[_loc1_];
            _loc5_++;
         }
         while(_loc5_ < 20)
         {
            _loc3_ = this._propsList.getChildAt(_loc5_).asButton;
            _loc3_.getChild("text").text = "";
            _loc3_.getChild("value").text = "";
            _loc5_++;
         }
         var _loc2_:AdaptationSettings = _editorWindow.project.settingsCenter.adaptation;
         contentPane.getChild("scaleMode").asComboBox.value = _loc2_.scaleMode;
         contentPane.getChild("screenMatchMode").asComboBox.value = _loc2_.screenMathMode;
         contentPane.getChild("designResolutionX").text = "" + _loc2_.designResolutionX;
         contentPane.getChild("designResolutionY").text = "" + _loc2_.designResolutionY;
         contentPane.getChild("defaultResolution").asComboBox.value = _loc2_.defaultResolution;
      }
      
      override public function actionHandler() : void
      {
         this.__apply(null);
         hide();
      }
      
      public function openFontSettings() : void
      {
         show();
         contentPane.getController("c1").selectedIndex = 1;
      }
      
      public function openScrollBarSettings() : void
      {
         show();
         contentPane.getController("c1").selectedIndex = 3;
      }
      
      public function openAdaptationSettings() : void
      {
         show();
         contentPane.getController("c1").selectedIndex = 4;
      }
      
      private function __clickChooseFont(param1:Event) : void
      {
         ChooseFontDialog(_editorWindow.getDialog(ChooseFontDialog)).open(this.__selectFont);
      }
      
      private function __selectFont(param1:String) : void
      {
         contentPane.getChild("fontName").text = param1;
      }
      
      private function __apply(param1:Event) : void
      {
         var _loc8_:String = null;
         var _loc12_:* = null;
         var _loc4_:int = 0;
         var _loc6_:GButton = null;
         var _loc2_:String = null;
         var _loc9_:EUIProject = _editorWindow.project;
         var _loc7_:CommonSettings = _loc9_.settingsCenter.common;
         _loc8_ = contentPane.getChild("fontName").text;
         if(_loc8_ != _loc7_.font)
         {
            _loc9_.globalFontVersion = Number(_loc9_.globalFontVersion) + 1;
            _loc7_.font = _loc8_;
         }
         _loc7_.fontSize = NumericInput(contentPane.getChild("fontSize")).value;
         _loc7_.textColor = ColorInput(contentPane.getChild("textColor")).colorValue;
         var _loc10_:* = !contentPane.getChild("disableFontAdjustment").asButton.selected;
         if(_loc10_ != _loc7_.fontAdjustment)
         {
            _loc9_.globalFontVersion = Number(_loc9_.globalFontVersion) + 1;
            _loc7_.fontAdjustment = _loc10_;
         }
         var _loc11_:String = contentPane.getChild("projectType").asComboBox.value;
         var _loc14_:* = _loc9_.type != _loc11_;
         _loc9_.type = _loc11_;
         _loc7_.verticalScrollBar = contentPane.getChild("vtScrollBarRes").text;
         _loc7_.horizontalScrollBar = contentPane.getChild("hzScrollBarRes").text;
         _loc7_.defaultScrollBarDisplay = contentPane.getChild("scrollBarDisplay").asComboBox.value;
         _loc7_.tipsRes = contentPane.getChild("tipsRes").text;
         _loc7_.buttonClickSound = contentPane.getChild("buttonClickSound").text;
         _loc8_ = contentPane.getChild("colorScheme").text;
         _loc8_ = UtilsStr.trim(_loc8_);
         _loc8_ = _loc8_.replace(/\r\n/g,"\n");
         _loc8_ = _loc8_.replace(/\r/g,"\n");
         _loc7_.colorScheme = _loc8_.split("\n");
         _loc8_ = contentPane.getChild("fontSizeScheme").text;
         _loc8_ = UtilsStr.trim(_loc8_);
         _loc8_ = _loc8_.replace(/\r\n/g,"\n");
         _loc8_ = _loc8_.replace(/\r/g,"\n");
         _loc7_.fontSizeScheme = _loc8_.split("\n");
         var _loc13_:CustomProps = _loc9_.settingsCenter.customProps;
         var _loc16_:int = 0;
         var _loc15_:* = _loc13_.all;
         for(_loc12_ in _loc13_.all)
         {
            delete _loc13_.all[_loc12_];
         }
         _loc4_ = 0;
         while(_loc4_ < 20)
         {
            _loc6_ = this._propsList.getChildAt(_loc4_).asButton;
            _loc12_ = _loc6_.getChild("text").text;
            _loc2_ = _loc6_.getChild("value").text;
            _loc12_ = UtilsStr.trim(_loc12_);
            if(_loc12_.length > 0)
            {
               _loc13_.all[_loc12_] = _loc2_;
            }
            _loc4_++;
         }
         var _loc5_:AdaptationSettings = _editorWindow.project.settingsCenter.adaptation;
         _loc5_.scaleMode = contentPane.getChild("scaleMode").asComboBox.value;
         _loc5_.screenMathMode = contentPane.getChild("screenMatchMode").asComboBox.value;
         _loc5_.designResolutionX = parseInt(contentPane.getChild("designResolutionX").text);
         _loc5_.designResolutionY = parseInt(contentPane.getChild("designResolutionY").text);
         _loc5_.defaultResolution = contentPane.getChild("defaultResolution").asComboBox.value;
         _loc7_.save();
         _loc13_.save();
         _loc5_.save();
         var _loc3_:String = UtilsStr.trim(contentPane.getChild("projectName").text);
         if(_loc3_ != _loc9_.name)
         {
            _loc9_.rename(_loc3_);
         }
         _loc9_.save();
         if(_loc14_)
         {
            _editorWindow.plugInManager.load();
            _editorWindow.project.reload();
         }
         _editorWindow.mainPanel.setWindowTitle();
         _editorWindow.mainPanel.editPanel.refreshDocument();
         if(_editorWindow.mainPanel.self.getController("test").selectedIndex == 1)
         {
            _editorWindow.mainPanel.testPanel.applyAdaptation();
         }
      }
   }
}

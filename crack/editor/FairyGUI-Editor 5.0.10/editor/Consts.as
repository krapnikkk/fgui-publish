package fairygui.editor
{
   import fairygui.UIPackage;
   import fairygui.editor.api.ProjectType;
   import fairygui.editor.gui.FObjectType;
   import fairygui.editor.gui.FPackageItemType;
   import fairygui.editor.settings.Preferences;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   import flash.desktop.NativeApplication;
   import flash.filesystem.File;
   import flash.system.Capabilities;
   
   public class Consts
   {
      
      public static var strings:Object = {};
      
      public static var icons:Object = {};
      
      public static var language:String;
      
      public static var isMacOS:Boolean;
      
      public static var AIRVersion:int;
      
      public static var version:String;
      
      public static var versionCode:int;
      
      public static var build:String;
      
      public static var auxLineSize:int;
      
      public static var supportedPlatformIds:Array = [ProjectType.FLASH,ProjectType.UNITY,ProjectType.STARLING,ProjectType.EGRET,ProjectType.LAYABOX,ProjectType.HAXE,ProjectType.PIXI,ProjectType.COCOS2DX,ProjectType.COCOSCREATOR,ProjectType.CRY,ProjectType.VISION,ProjectType.MONOGAME,ProjectType.CORONA];
      
      public static var supportedPlatformNames:Array = [ProjectType.FLASH,ProjectType.UNITY,ProjectType.STARLING,ProjectType.EGRET,ProjectType.LAYABOX,ProjectType.HAXE,ProjectType.PIXI,"Cocos2d-x","Cocos Creator","Cry Engine","Havok Vision(Project Anarchy)","MonoGame","Corona"];
      
      public static const easeType:Array = ["Back","Bounce","Circ","Cubic","Elastic","Expo","Linear","Quad","Quart","Quint","Sine"];
      
      public static const easeInOutType:Array = ["In","Out","InOut"];
      
      public static const supportedLangNames:Array = ["Auto","English","简体中文"];
      
      public static const supportedLanaguages:Array = ["auto","en","zh-CN"];
      
      public static const about:String = "Copyright 2013-2020 FairyGUI.com\n" + "All rights reserved.";
      
      public static const userDirectoryName:String = ".FairyGUI-Editor";
       
      
      public function Consts()
      {
         super();
      }
      
      private static function parseVersion() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Array = _loc1_.namespaceDeclarations();
         _loc2_ = _loc2_[0].uri.split("/");
         Consts.AIRVersion = parseInt(_loc2_[_loc2_.length - 1]);
         var _loc3_:Namespace = _loc1_.namespace("");
         Consts.version = _loc1_._loc3_::versionNumber;
         var _loc4_:String = _loc1_._loc3_::versionLabel;
         _loc2_ = Consts.version.split(".");
         Consts.versionCode = int(_loc2_[0]) * 10000 + int(_loc2_[1]) * 100 + int(_loc2_[2]);
         Consts.build = "";
         if(_loc4_)
         {
            _loc5_ = _loc4_.indexOf("Build ");
            _loc6_ = _loc4_.indexOf(")",_loc5_);
            if(_loc5_ != -1 && _loc6_ != -1)
            {
               Consts.build = _loc4_.substring(_loc5_ + 6,_loc6_);
            }
         }
      }
      
      public static function init() : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         parseVersion();
         isMacOS = Capabilities.os.toLowerCase().indexOf("mac") != -1;
         language = Preferences.language;
         if(language == "auto")
         {
            language = Capabilities.language;
         }
         if(!new File("app:/locales/" + language + "/strings2.xml").exists)
         {
            if(UtilsStr.startsWith(language,"zh-"))
            {
               language = "zh-CN";
            }
            else
            {
               language = "en";
            }
         }
         if(language != "zh-CN")
         {
            _loc3_ = UtilsFile.loadXML(new File("app:/locales/" + language + "/strings1.xml"));
            if(_loc3_)
            {
               UIPackage.setStringsSource(_loc3_);
            }
         }
         var _loc1_:XData = UtilsFile.loadXData(new File("app:/locales/" + language + "/strings2.xml"));
         var _loc2_:XDataEnumerator = _loc1_.getEnumerator("string");
         while(_loc2_.moveNext())
         {
            _loc4_ = _loc2_.current.getAttribute("name");
            _loc5_ = _loc2_.current.getText();
            strings[_loc4_] = _loc5_;
         }
         icons[FObjectType.FOLDER] = UIPackage.getItemURL("Builder","icon_folder");
         icons["folder_open"] = UIPackage.getItemURL("Builder","icon_folder_open");
         icons[FObjectType.PACKAGE] = UIPackage.getItemURL("Builder","icon_package");
         icons["package_open"] = UIPackage.getItemURL("Builder","icon_package_open");
         icons["branch"] = UIPackage.getItemURL("Builder","icon_branch");
         icons[FPackageItemType.SOUND] = UIPackage.getItemURL("Builder","icon_sound");
         icons[FPackageItemType.FONT] = UIPackage.getItemURL("Builder","icon_font");
         icons[FPackageItemType.MISC] = UIPackage.getItemURL("Builder","icon_misc");
         icons[FObjectType.IMAGE] = UIPackage.getItemURL("Builder","icon_image");
         icons[FObjectType.GRAPH] = UIPackage.getItemURL("Builder","icon_graph");
         icons[FObjectType.LIST] = UIPackage.getItemURL("Builder","icon_list");
         icons[FObjectType.LOADER] = UIPackage.getItemURL("Builder","icon_loader");
         icons[FObjectType.TEXT] = UIPackage.getItemURL("Builder","icon_text");
         icons[FObjectType.RICHTEXT] = UIPackage.getItemURL("Builder","icon_richtext");
         icons[FObjectType.COMPONENT] = UIPackage.getItemURL("Builder","icon_component");
         icons[FObjectType.SWF] = UIPackage.getItemURL("Builder","icon_swf");
         icons[FObjectType.MOVIECLIP] = UIPackage.getItemURL("Builder","icon_movieclip");
         icons[FObjectType.GROUP] = UIPackage.getItemURL("Builder","icon_group");
         icons[FObjectType.EXT_BUTTON] = UIPackage.getItemURL("Builder","icon_button");
         icons[FObjectType.EXT_LABEL] = UIPackage.getItemURL("Builder","icon_label");
         icons[FObjectType.EXT_COMBOBOX] = UIPackage.getItemURL("Builder","icon_combobox");
         icons[FObjectType.EXT_SLIDER] = UIPackage.getItemURL("Builder","icon_slider");
         icons[FObjectType.EXT_PROGRESS_BAR] = UIPackage.getItemURL("Builder","icon_progressbar");
         icons[FObjectType.EXT_SCROLLBAR] = UIPackage.getItemURL("Builder","icon_scrollbar");
      }
   }
}

import FPackageItemType from "../gui/FPackageItemType";
import UtilsStr from "../utils/UtilsStr";
import ProjectType from "./api/ProjectType";

export default class Consts {

    public static strings: {[key:string]:string} = {};

    public static icons:{[key:string]:any} = {};

    public static language:string;

    public static isMacOS:boolean;

    public static AIRVersion:number;

    public static version:string;

    public static versionCode:number;

    public static build:string;

    public static auxLineSize:number;

    public static supportedPlatformIds: Array<ProjectType> = [ProjectType.FLASH, ProjectType.UNITY, ProjectType.STARLING, ProjectType.EGRET, ProjectType.LAYABOX, ProjectType.HAXE, ProjectType.PIXI, ProjectType.COCOS2DX, ProjectType.COCOSCREATOR, ProjectType.CRY, ProjectType.VISION, ProjectType.MONOGAME, ProjectType.CORONA];

    public static supportedPlatformNames: Array<ProjectType>  = [ProjectType.FLASH, ProjectType.UNITY, ProjectType.STARLING, ProjectType.EGRET, ProjectType.LAYABOX, ProjectType.HAXE, ProjectType.PIXI, "Cocos2d-x", "Cocos Creator", "Cry Engine", "Havok Vision(Project Anarchy)", "MonoGame", "Corona"];

    public static easeType: Array<string> = ["Back", "Bounce", "Circ", "Cubic", "Elastic", "Expo", "Linear", "Quad", "Quart", "Quint", "Sine"];

    public static easeInOutType: Array<string> = ["In", "Out", "InOut"];

    public static supportedLangNames: Array<string> = ["Auto", "English", "简体中文"];

    public static supportedLanaguages: Array<string> = ["auto", "en", "zh-CN"];

    public static about:string = "Copyright 2013-2020 FairyGUI.com\n" + "All rights reserved.";

    public static userDirectoryName:string = ".FairyGUI-Editor";


    private static parseVersion(): void {
        var _loc5_:number = 0;
        var _loc6_:number = 0;
        // var _loc1_: XML = NativeApplication.nativeApplication.applicationDescriptor;
        // var _loc2_: Array = _loc1_.namespaceDeclarations();
        // _loc2_ = _loc2_[0].uri.split("/");
        // Consts.AIRVersion = parseInt(_loc2_[_loc2_.length - 1]);
        // var _loc3_: Namespace = _loc1_.namespace("");
        // Consts.version = _loc1_._loc3_:: versionNumber;
        // var _loc4_:string = _loc1_._loc3_:: versionLabel;
        // _loc2_ = Consts.version.split(".");
        // Consts.versionCode = int(_loc2_[0]) * 10000 + int(_loc2_[1]) * 100 + int(_loc2_[2]);
        // Consts.build = "";
        // if (_loc4_) {
        //     _loc5_ = _loc4_.indexOf("Build ");
        //     _loc6_ = _loc4_.indexOf(")", _loc5_);
        //     if (_loc5_ != -1 && _loc6_ != -1) {
        //         Consts.build = _loc4_.substring(_loc5_ + 6, _loc6_);
        //     }
        // }
    }

    public static init(): void {
        // var _loc3_: XML ;
        // var _loc4_:string = "";
        // var _loc5_:string = "";
        // parseVersion();
        // isMacOS = Capabilities.os.toLowerCase().indexOf("mac") != -1;
        // language = Preferences.language;
        // if (language == "auto") {
        //     language = Capabilities.language;
        // }
        // if (!new File("app:/locales/" + language + "/strings2.xml").exists) {
        //     if (UtilsStr.startsWith(language, "zh-")) {
        //         language = "zh-CN";
        //     }
        //     else {
        //         language = "en";
        //     }
        // }
        // if (language != "zh-CN") {
        //     _loc3_ = UtilsFile.loadXML(new File("app:/locales/" + language + "/strings1.xml"));
        //     if (_loc3_) {
        //         UIPackage.setStringsSource(_loc3_);
        //     }
        // }
        // var _loc1_: XData = UtilsFile.loadXData(new File("app:/locales/" + language + "/strings2.xml"));
        // var _loc2_: XDataEnumerator = _loc1_.getEnumerator("string");
        // while (_loc2_.moveNext()) {
        //     _loc4_ = _loc2_.current.getAttribute("name");
        //     _loc5_ = _loc2_.current.getText();
        //     strings[_loc4_] = _loc5_;
        // }
        // icons[FObjectType.FOLDER] = UIPackage.getItemURL("Builder", "icon_folder");
        // icons["folder_open"] = UIPackage.getItemURL("Builder", "icon_folder_open");
        // icons[FObjectType.PACKAGE] = UIPackage.getItemURL("Builder", "icon_package");
        // icons["package_open"] = UIPackage.getItemURL("Builder", "icon_package_open");
        // icons["branch"] = UIPackage.getItemURL("Builder", "icon_branch");
        // icons[FPackageItemType.SOUND] = UIPackage.getItemURL("Builder", "icon_sound");
        // icons[FPackageItemType.FONT] = UIPackage.getItemURL("Builder", "icon_font");
        // icons[FPackageItemType.MISC] = UIPackage.getItemURL("Builder", "icon_misc");
        // icons[FObjectType.IMAGE] = UIPackage.getItemURL("Builder", "icon_image");
        // icons[FObjectType.GRAPH] = UIPackage.getItemURL("Builder", "icon_graph");
        // icons[FObjectType.LIST] = UIPackage.getItemURL("Builder", "icon_list");
        // icons[FObjectType.LOADER] = UIPackage.getItemURL("Builder", "icon_loader");
        // icons[FObjectType.TEXT] = UIPackage.getItemURL("Builder", "icon_text");
        // icons[FObjectType.RICHTEXT] = UIPackage.getItemURL("Builder", "icon_richtext");
        // icons[FObjectType.COMPONENT] = UIPackage.getItemURL("Builder", "icon_component");
        // icons[FObjectType.SWF] = UIPackage.getItemURL("Builder", "icon_swf");
        // icons[FObjectType.MOVIECLIP] = UIPackage.getItemURL("Builder", "icon_movieclip");
        // icons[FObjectType.GROUP] = UIPackage.getItemURL("Builder", "icon_group");
        // icons[FObjectType.EXT_BUTTON] = UIPackage.getItemURL("Builder", "icon_button");
        // icons[FObjectType.EXT_LABEL] = UIPackage.getItemURL("Builder", "icon_label");
        // icons[FObjectType.EXT_COMBOBOX] = UIPackage.getItemURL("Builder", "icon_combobox");
        // icons[FObjectType.EXT_SLIDER] = UIPackage.getItemURL("Builder", "icon_slider");
        // icons[FObjectType.EXT_PROGRESS_BAR] = UIPackage.getItemURL("Builder", "icon_progressbar");
        // icons[FObjectType.EXT_SCROLLBAR] = UIPackage.getItemURL("Builder", "icon_scrollbar");
    }
}


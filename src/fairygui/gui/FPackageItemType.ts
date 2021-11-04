import XData from "../utils/XData";

export default class FPackageItemType {

    public static FOLDER:string = "folder";

    public static IMAGE:string = "image";

    public static SWF:string = "swf";

    public static MOVIECLIP:string = "movieclip";

    public static SOUND:string = "sound";

    public static COMPONENT:string = "component";

    public static FONT:string = "font";

    public static MISC:string = "misc";

    public static ATLAS:string = "atlas";

    public static fileExtensionMap: {[key:string]:string} = {
        "jpg": FPackageItemType.IMAGE,
        "jpeg": FPackageItemType.IMAGE,
        "png": FPackageItemType.IMAGE,
        "psd": FPackageItemType.IMAGE,
        "tga": FPackageItemType.IMAGE,
        "svg": FPackageItemType.IMAGE,
        "plist": FPackageItemType.MOVIECLIP,
        "eas": FPackageItemType.MOVIECLIP,
        "jta": FPackageItemType.MOVIECLIP,
        "gif": FPackageItemType.MOVIECLIP,
        "wav": FPackageItemType.SOUND,
        "mp3": FPackageItemType.SOUND,
        "ogg": FPackageItemType.SOUND,
        "fnt": FPackageItemType.FONT,
        "swf": FPackageItemType.SWF,
        "xml": FPackageItemType.COMPONENT
    };


    public constructor() {

    }

    public static getFileType(param1: File):string {
        var _loc3_:string = "";
        // var _loc4_: XData ;
        // if (param1.isHidden || param1.isSymbolicLink || param1.name == "package.xml" || param1.name == "package_branch.xml" || param1.extension == "meta" || param1.name.charAt(0) == ".") {
        //     return null;
        // }
        // var _loc2_:string = param1.extension;
        // if (_loc2_) {
        //     _loc2_ = _loc2_.toLowerCase();
        // }
        // if (_loc2_ == "xml") {
        //     _loc4_ = UtilsFile.loadXMLRoot(param1);
        //     if (_loc4_) {
        //         if (_loc4_.getName() == "component") {
        //             _loc3_ = FPackageItemType.COMPONENT;
        //         }
        //         else {
        //             _loc3_ = FPackageItemType.MISC;
        //         }
        //     }
        //     else {
        //         _loc3_ = FPackageItemType.MISC;
        //     }
        // }
        // else {
        //     _loc3_ = FPackageItemType.fileExtensionMap[_loc2_];
        //     if (!_loc3_) {
        //         _loc3_ = FPackageItemType.MISC;
        //     }
        // }
        return _loc3_;
    }
}


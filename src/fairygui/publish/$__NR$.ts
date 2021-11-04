import ByteArray from "src/utils/ByteArray";
import ProjectType from "../editor/api/ProjectType";
import CommonSettings from "../editor/settings/CommonSettings";
import FPackageItem from "../gui/FPackageItem";
import FPackageItemType from "../gui/FPackageItemType";
import UtilsFile from "../utils/UtilsFile";
import UtilsStr from "../utils/UtilsStr";
import XData from "../utils/XData";
import AtlasOutput from "./AtlasOutput";
import PublishStep from "./PublishStep";

export default class $__NR$ extends PublishStep {


    public constructor() {
        super();
    }

    public run(): void {
        super.run();
        var _loc1_: FPackageItem = null;
        var _loc2_:string = "";
        var _loc3_: ByteArray = null;
        var _loc4_: any[];
        var _loc5_:string = "";
        var _loc12_:string = "";
        var _loc13_:string = "";
        var _loc14_: XData = null;
        var _loc15_: FPackageItem = null;
        var _loc16_: any = false;
        var _loc17_:string = "";
        var _loc18_: any[];
        var _loc19_: number = 0;
        var _loc20_: AtlasOutput = null;
        var _loc21_: XData = null;
        var _loc22_: any[];
        var _loc6_: XData = XData.create("packageDescription");
        _loc6_.setAttribute("id", this.publishData.pkg.id);
        _loc6_.setAttribute("name", this.publishData.pkg.name);
        if (this.publishData.branches > 0) {
            _loc4_ = [];
            for (_loc4_[this.publishData.$_GR$[_loc12_]] in this.publishData.$_GR$) {
            }
            _loc6_.setAttribute("allBranches", _loc4_.join(","));
        }
        var _loc7_: XData = XData.create("resources");
        var _loc8_: CommonSettings = (<CommonSettings>this.publishData.project.getSettings("common"));
        var _loc9_: String = _loc8_.verticalScrollBar;
        var _loc10_: String = _loc8_.horizontalScrollBar;
        if (_loc9_ || _loc10_) {
            _loc6_.setAttribute("scrollBarRes", (!!_loc9_ ? _loc9_ : "") + "," + (!!_loc10_ ? _loc10_ : ""));
        }
        var _loc11_: any = this.publishData.allBranches > 0;
        // for (_loc1_ in this.publishData.items) {
        //     _loc13_ = UtilsStr.getFileExt(_loc1_.fileName);
        //     if (_loc13_) {
        //         if (_loc13_.toLowerCase() == "svg") {
        //             _loc13_ = "png";
        //         }
        //         _loc2_ = _loc1_.$__e$ + "." + _loc13_;
        //     }
        //     else {
        //         _loc2_ = _loc1_.$__e$;
        //     }
        //     _loc14_ = _loc1_.serialize(true);
        //     switch (_loc1_.type) {
        //         case FPackageItemType.COMPONENT:
        //             if (!this.publishData.outputDesc[_loc1_.$__e$ + ".xml"]) {
        //                 _loc14_ = null;
        //             }
        //             break;
        //         case FPackageItemType.IMAGE:
        //             if (!this.publishData.supportAtlas) {
        //                 if (_loc1_.image && (_loc3_ = UtilsFile.loadBytes(_loc1_.imageInfo.file)) != null) {
        //                     _loc15_ = this.publishData.fontTextures[_loc1_.$__e$];
        //                     if (_loc15_) {
        //                         _loc2_ = _loc15_.$__e$ + "." + _loc13_;
        //                         this.publishData.outputRes[_loc2_] = _loc3_;
        //                         _loc14_ = null;
        //                     }
        //                     else {
        //                         this.publishData.outputRes[_loc2_] = _loc3_;
        //                         _loc14_.setAttribute("file", _loc2_);
        //                     }
        //                 }
        //             }
        //             break;
        //         case FPackageItemType.MOVIECLIP:
        //             if (!this.publishData.outputDesc[_loc1_.$__e$ + ".xml"]) {
        //                 _loc14_ = null;
        //             }
        //             break;
        //         case FPackageItemType.SWF:
        //             if (this.publishData.project.type != ProjectType.FLASH) {
        //                 _loc14_ = null;
        //             }
        //             break;
        //         case FPackageItemType.FONT:
        //             _loc5_ = UtilsFile.loadString(_loc1_.file);
        //             if (_loc5_) {
        //                 if (_loc1_.fontSettings.texture) {
        //                     _loc14_.setAttribute("fontTexture", _loc1_.fontSettings.texture);
        //                 }
        //                 this.publishData.outputDesc[_loc2_] = _loc5_;
        //             }
        //             else {
        //                 _loc14_ = null;
        //             }
        //             break;
        //         default:
        //             _loc3_ = UtilsFile.loadBytes(_loc1_.file);
        //             if (_loc3_) {
        //                 this.publishData.outputRes[_loc2_] = _loc3_;
        //                 _loc14_.setAttribute("file", _loc2_);
        //             }
        //             else {
        //                 _loc14_ = null;
        //             }
        //     }
        //     if (_loc14_) {
        //         if (_loc1_.imageInfo) {
        //             _loc17_ = _loc1_.getVar("pubInfo.highRes");
        //             if (_loc17_) {
        //                 _loc14_.setAttribute("highRes", _loc17_);
        //             }
        //         }
        //         _loc16_ = _loc1_.branch.length > 0;
        //         if (_loc11_) {
        //             if (this.publishData.includeBranches) {
        //                 if (_loc1_.branch.length == 0) {
        //                     _loc18_ = _loc1_.getVar("pubInfo.branch");
        //                     if (_loc18_) {
        //                         _loc19_ = 0;
        //                         while (_loc19_ < this.publishData.branches) {
        //                             _loc12_ = _loc18_[_loc19_];
        //                             if (!_loc12_) {
        //                                 _loc18_[_loc19_] = "";
        //                             }
        //                             _loc19_++;
        //                         }
        //                         _loc14_.setAttribute("allBranches", _loc18_.join(","));
        //                     }
        //                 }
        //             }
        //             else if (_loc1_.branch.length > 0 && _loc1_.getVar("pubInfo.branch")) {
        //                 _loc16_ = false;
        //                 _loc14_.setAttribute("allBranches", _loc1_.id);
        //             }
        //         }
        //         if (_loc16_) {
        //             _loc14_.setAttribute("branch", _loc1_.branch);
        //         }
        //         _loc7_.appendChild(_loc14_);
        //     }
        // }
        // if (this.publishData.supportAtlas) {
        //     for (_loc20_ in this.publishData.atlasOutput) {
        //         _loc21_ = XData.create("atlas");
        //         _loc21_.setAttribute("id", _loc20_.id);
        //         _loc21_.setAttribute("size", _loc20_.width + "," + _loc20_.height);
        //         _loc21_.setAttribute("file", _loc20_.fileName);
        //         _loc7_.appendChild(_loc21_);
        //         if (_loc20_.data) {
        //             this.publishData.outputRes[_loc20_.fileName] = _loc20_.data;
        //         }
        //         if (_loc20_.alphaData) {
        //             this.publishData.outputRes[UtilsStr.getFileName(_loc20_.fileName) + "!a.png"] = _loc20_.alphaData;
        //         }
        //     }
        // }
        // _loc6_.appendChild(_loc7_);
        // this.publishData.outputDesc["package.xml"] = _loc6_.toXML();
        // if (this.publishData.supportAtlas) {
        //     _loc4_ = [];
        //     for (_loc22_ in this.publishData.$_Fc$) {
        //         _loc4_.push(_loc22_.join(" "));
        //     }
        //     _loc4_.sort();
        //     this.publishData.sprites = "//FairyGUI atlas sprites.\n" + _loc4_.join("\n");
        // }
        // _stepCallback.callOnSuccess();
    }
}


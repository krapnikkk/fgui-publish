import IUIPackage from "../editor/api/IUIPackage";
import PublishSettings from "../editor/settings/PublishSettings";
import AniDef from "../gui/animation/AniDef";
import AniFrame from "../gui/animation/AniFrame";
import AniTexture from "../gui/animation/AniTexture";
import ComProperty from "../gui/ComProperty";
import FPackageItem from "../gui/FPackageItem";
import FPackageItemType from "../gui/FPackageItemType";
import UtilsFile from "../utils/UtilsFile";
import UtilsStr from "../utils/UtilsStr";
import XData from "../utils/XData";
import XDataEnumerator from "../utils/XDataEnumerator";
import AtlasItem from "./AtlasItem";
import PublishStep from "./PublishStep";

export default class CollectItems extends PublishStep {

    private static $__4G$: Array<string> = [];


    private $__c$: { [key: string]: any };

    private $__Ns$: { [key: string]: any };

    private $__7d$: Array<FPackageItem>;

    public constructor() {
        super();
    }

    public run(): void {
        super.run();
        var _loc3_: FPackageItem = null;
        var _loc4_: string = "";
        this.$__Ns$ = {};
        this.$__7d$ = new Array<FPackageItem>();
        var _loc1_: Array<String> = (<PublishSettings>this.publishData.pkg.publishSettings).excludedList;
        if (_loc1_.length > 0) {
            this.$__c$ = {};
            for (_loc4_ in _loc1_) {
                this.$__c$[_loc4_] = false;
            }
        }
        var _loc2_: Array<FPackageItem> = this.publishData.pkg.items;
        // for (_loc3_ in _loc2_) {
        //     _loc3_.setVar("pubInfo.added", undefined);
        //     _loc3_.setVar("pubInfo.highRes", undefined);
        //     _loc3_.setVar("pubInfo.branch", undefined);
        //     _loc3_.setVar("pubInfo.isFontLetter", undefined);
        //     _loc3_.setVar("pubInfo.keepOriginal", undefined);
        //     _loc3_.$__e$ = _loc3_.id;
        // }
        // for (_loc3_ in _loc2_) {
        //     if (_loc3_.exported) {
        //         this.addItem(_loc3_);
        //     }
        // }
        // while (this.$__7d$.length > 0) {
        //     _loc3_ = this.$__7d$.pop();
        //     this.$__E1$(_loc3_);
        // }
        // this.publishData.items.sort(this.$__NF$);
        // this.publishData.hitTestImages.sort(this.$__NF$);
        // for (_loc3_ in this.publishData.items) {
        //     _loc3_.touch();
        //     if (_loc3_.isError) {
        //         console.log("file not exists, resource=[url=event:open]" + _loc3_.name + "[/url]", _loc3_);
        //     }
        //     _loc3_.addRef();
        // }
        // for (_loc3_ in this.publishData.hitTestImages) {
        //     _loc3_.addRef();
        // }
        // _stepCallback.callOnSuccess();
    }

    private $__NF$(param1: FPackageItem, param2: FPackageItem): number {
        var _loc3_: number = 0;
        if (param1.exported && !param2.exported) {
            return 1;
        }
        if (!param1.exported && param2.exported) {
            return -1;
        }
        _loc3_ = param1.type.localeCompare(param2.type);
        if (_loc3_ == 0) {
            _loc3_ = param1.id.localeCompare(param2.id);
        }
        return _loc3_;
    }

    private addItem(param1: FPackageItem, param2: Boolean = false): void {
        if (param1.getVar("pubInfo.added")) {
            return;
        }
        if (this.$__c$ && this.$__c$[param1.id] != undefined) {
            if (this.$__c$[param1.id] == false) {
                this.$__c$[param1.id] = true;
                this.publishData.$_BH$++;
            }
            return;
        }
        param1.setVar("pubInfo.added", true);
        if (!param2 && this.publishData.allBranches > 0) {
            if (this.publishData.includeBranches) {
                if (param1.branch.length == 0) {
                    this.$__HA$(param1);
                }
            }
            else if (this.mergeBranch(param1)) {
                return;
            }
        }
        this.publishData.items.push(param1);
        if (param1.imageInfo) {
            if (this.publishData.supportAtlas) {
                this.$__Ee$(param1);
            }
            if (param1.type == FPackageItemType.MOVIECLIP) {
                this.$__ED$(param1);
            }
            if (!param2) {
                this.$__Iv$(param1);
            }
        }
        else if (param1.type == FPackageItemType.COMPONENT) {
            this.$__7d$.push(param1);
        }
        else if (param1.type == FPackageItemType.FONT) {
            this.$__Po$(param1);
        }
    }

    private $__Iv$(param1: FPackageItem): void {
        var _loc6_: FPackageItem = null;
        var _loc7_: number = 0;
        var _loc2_: number = this.publishData.includeHighResolution;
        var _loc3_: string = param1.path + param1.name;
        var _loc4_: number = 3;
        var _loc5_: number = 0;
        while (_loc4_ > 0) {
            _loc7_ = _loc4_;
            CollectItems.$__4G$[_loc7_] = "";
            if ((_loc2_ & 1 >> _loc7_) != 0) {
                _loc6_ = param1.owner.getItemByPath(_loc3_ + "@" + (_loc4_ + 1) + "x");
                if (_loc6_ && _loc6_.type == param1.type) {
                    this.addItem(_loc6_, true);
                    CollectItems.$__4G$[_loc7_] = _loc6_.id;
                    _loc5_++;
                    break;
                }
            }
            _loc4_--;
        }
        if (_loc5_ > 0) {
            if (_loc5_ == 1 && CollectItems.$__4G$[0]) {
                param1.setVar("pubInfo.highRes", CollectItems.$__4G$[0]);
            }
            else {
                param1.setVar("pubInfo.highRes", CollectItems.$__4G$.join(","));
            }
        }
    }

    private $__HA$(param1: FPackageItem): void {
        var _loc2_: string = "";
        var _loc3_: FPackageItem = null;
        var _loc4_: { [key: string]: any } = null;
        var _loc8_: string = "";
        var _loc9_: any = undefined;
        var _loc5_: Array<string> = this.publishData.project.allBranches;
        var _loc6_: number = _loc5_.length;
        var _loc7_: number = 0;
        while (_loc7_ < _loc6_) {
            _loc8_ = _loc5_[_loc7_];
            _loc2_ = "/:" + _loc8_ + param1.path + param1.name;
            _loc3_ = param1.owner.getItemByPath(_loc2_);
            if (_loc3_ && _loc3_.type == param1.type) {
                _loc9_ = this.publishData.$_GR$[_loc8_];
                if (_loc9_ == undefined) {
                    _loc9_ = this.publishData.branches;
                    this.publishData.$_GR$[_loc8_] = _loc9_;
                    this.publishData.branches++;
                }
                if (!_loc4_) {
                    _loc4_ = [];
                }
                _loc4_[_loc9_] = _loc3_.id;
                this.addItem(_loc3_);
            }
            _loc7_++;
        }
        if (_loc4_) {
            param1.setVar("pubInfo.branch", _loc4_);
        }
    }

    private mergeBranch(param1: FPackageItem): Boolean {
        var _loc2_: FPackageItem = null;
        if (param1.branch.length == 0) {
            _loc2_ = param1.getVar("pubInfo.branch");
            if (!_loc2_) {
                _loc2_ = this.publishData.pkg.getItemByPath("/:" + this.publishData.branch + param1.path + param1.name);
                if (_loc2_ && _loc2_.type == param1.type) {
                    _loc2_.$__e$ = param1.id;
                    param1.setVar("pubInfo.branch", _loc2_);
                    _loc2_.setVar("pubInfo.branch", param1);
                    this.addItem(_loc2_);
                    return true;
                }
                return false;
            }
            return true;
        }
        _loc2_ = param1.getVar("pubInfo.branch");
        if (!_loc2_) {
            _loc2_ = this.publishData.pkg.getItemByPath(param1.path.substr(param1.branch.length + 2) + param1.name);
            if (_loc2_ && _loc2_.type == param1.type) {
                param1.$__e$ = _loc2_.id;
                param1.setVar("pubInfo.branch", _loc2_);
                _loc2_.setVar("pubInfo.branch", param1);
            }
        }
        return false;
    }

    private $__ED$(param1: FPackageItem): void {
        var _loc3_: number = 0;
        var _loc4_: AniTexture = null;
        var _loc5_: number = 0;
        var _loc6_: AniFrame = null;
        var _loc7_: XData = null;
        var _loc8_: XData = null;
        var _loc9_: XData = null;
        var _loc2_: AniDef = param1.getAnimation();
        if (_loc2_ != null) {
            _loc3_ = _loc2_.frameCount;
            // for (_loc4_ in _loc2_.textureList) {
            //     _loc4_.exportFrame = -1;
            // }
            _loc5_ = 0;
            while (_loc5_ < _loc3_) {
                _loc6_ = _loc2_.frameList[_loc5_];
                if (_loc6_.textureIndex != -1) {
                    _loc4_ = _loc2_.textureList[_loc6_.textureIndex];
                    if (_loc4_.raw != null && _loc4_.exportFrame == -1) {
                        _loc4_.exportFrame = _loc5_;
                    }
                }
                _loc5_++;
            }
            _loc7_ = XData.create("movieclip");
            _loc7_.setAttribute("interval", Number(1000 / _loc2_.fps * (_loc2_.speed != 0 ? _loc2_.speed : 1)));
            if (_loc2_.repeatDelay) {
                _loc7_.setAttribute("repeatDelay", Number(1000 / _loc2_.fps * _loc2_.repeatDelay));
            }
            if (_loc2_.swing) {
                _loc7_.setAttribute("swing", _loc2_.swing);
            }
            _loc7_.setAttribute("frameCount", _loc3_);
            _loc8_ = XData.create("frames");
            _loc7_.appendChild(_loc8_);
            _loc5_ = 0;
            while (_loc5_ < _loc3_) {
                _loc6_ = _loc2_.frameList[_loc5_];
                _loc9_ = XData.create("frame");
                _loc8_.appendChild(_loc9_);
                _loc9_.setAttribute("rect", _loc6_.rect.x + "," + _loc6_.rect.y + "," + _loc6_.rect.width + "," + _loc6_.rect.height);
                if (_loc6_.delay) {
                    _loc9_.setAttribute("addDelay", Number(1000 / _loc2_.fps * _loc6_.delay));
                }
                if (_loc6_.textureIndex != -1) {
                    _loc4_ = _loc2_.textureList[_loc6_.textureIndex];
                    if (_loc4_.exportFrame != -1 && _loc4_.exportFrame != _loc5_) {
                        _loc9_.setAttribute("sprite", _loc4_.exportFrame);
                    }
                }
                _loc5_++;
            }
            // this.publishData.outputDesc[param1.$__e$ + ".xml"] = _loc7_.toXML();
            // if (!this.publishData.supportAtlas) {
            //     for (_loc4_ in _loc2_.textureList) {
            //         if (_loc4_.exportFrame != -1 && _loc4_.raw) {
            //             this.publishData.outputRes[param1.$__e$ + "_" + _loc4_.exportFrame + ".png"] = _loc4_.raw;
            //         }
            //     }
            // }
        }
    }

    private $__Ee$(param1: FPackageItem): void {
        var _loc2_: string = "";
        var _loc3_: number = param1.getAtlasIndex();
        if (_loc3_ < 0) {
            _loc2_ = "atlas_" + param1.$__e$;
        }
        else {
            _loc2_ = "atlas" + _loc3_;
        }
        var _loc4_: AtlasItem = this.$__Ns$[_loc2_];
        if (!_loc4_) {
            _loc4_ = new AtlasItem();
            _loc4_.id = _loc2_;
            _loc4_.index = _loc3_ < 0 ? -1 : Number(_loc3_);
            if (_loc3_ == -2) {
                _loc4_.npot = true;
            }
            else if (_loc3_ == -3) {
                _loc4_.mof = true;
            }
            this.publishData.atlases.push(_loc4_);
            this.$__Ns$[_loc2_] = _loc4_;
        }
        _loc4_.items.push(param1);
        if (param1.imageInfo.format != "jpg") {
            _loc4_.alphaChannel = true;
        }
        if (_loc4_.index == -1 && _loc4_.npot) {
            param1.setVar("pubInfo.keepOriginal", true);
        }
    }

    private $__JW$(param1: string): FPackageItem {
        var _loc2_: number = 0;
        var _loc3_: string = "";
        var _loc4_: IUIPackage = null;
        var _loc5_: string = "";
        var _loc6_: FPackageItem = null;
        if (param1 && UtilsStr.startsWith(param1, "ui://")) {
            _loc2_ = param1.indexOf(",");
            if (_loc2_ != -1) {
                param1 = param1.substr(0, _loc2_);
            }
            _loc3_ = param1.substr(5, 8);
            _loc4_ = this.publishData.project.getPackage(_loc3_);
            if (!_loc4_) {
                return null;
            }
            if (_loc4_ != this.publishData.pkg) {
                this.publishData.$_DJ$[_loc4_.id] = true;
                return null;
            }
            _loc5_ = param1.substr(13);
            _loc6_ = _loc4_.getItem(_loc5_);
            if (_loc6_) {
                this.addItem(_loc6_);
            }
            return _loc6_;
        }
        return null;
    }

    private $__E1$(param1: FPackageItem): void {
        var cxml: XData = null;
        var dxml: XData = null;
        var it: XDataEnumerator = null;
        var ename: string = "";
        var cname: string = "";
        var str: string = "";
        var arr: Array<any> = null;
        var src: string = "";
        var srcItem: FPackageItem = null;
        var hitTestXml: XData = null;
        var pkgId: string = "";
        var xml: XData = null;
        var col: Array<XData> = null;
        var cnt: number = 0;
        var index: number = 0;
        var defaultItem: string = "";
        var url: string = "";
        var listItem: FPackageItem = null;
        var gid: string = "";
        var pgid: string = "";
        var tp: string = "";
        var hitTestItem: FPackageItem = null;
        var pi: FPackageItem = param1;
        // try {
        //     xml = UtilsFile.loadXData(pi.file);
        //     if (!xml) {
        //         return;
        //     }
        // }
        // catch (err: Error) {
        //     console.log("XML format error, resource=[url=event:open]" + pi.name + "[/url]", pi);
        //     return;
        // }
        xml.removeAttribute("resolution");
        xml.removeAttribute("copies");
        xml.removeAttribute("designImage");
        xml.removeAttribute("designImageOffsetX");
        xml.removeAttribute("designImageOffsetY");
        xml.removeAttribute("designImageAlpha");
        xml.removeAttribute("designImageLayer");
        xml.removeAttribute("designImageForTest");
        xml.removeAttribute("initName");
        xml.removeAttribute("bgColor");
        xml.removeAttribute("bgColorEnabled");
        xml.removeChildren("customProperty");
        var toDelete: Array<XData> = [];
        var classInfo: { [key: string]: any } = {};
        classInfo.classId = pi.$__e$;
        classInfo.className = pi.name;
        classInfo.superClassName = "G" + xml.getAttribute("extention", "Component");
        if (str != "ScrollBar") {
            this.publishData.outputClasses[pi.$__e$] = classInfo;
        }
        str = xml.getAttribute("customExtention");
        if (str) {
            classInfo.customSuperClassName = str;
            xml.removeAttribute("customExtention");
        }
        str = xml.getAttribute("remark");
        if (str) {
            classInfo.remark = str;
            xml.removeAttribute("remark");
            xml.setAttribute("customData", str);
        }
        var displayListNode: XData = xml.getChild("displayList");
        str = xml.getAttribute("hitTest");
        if (str && displayListNode) {
            it = displayListNode.getEnumerator();
            while (it.moveNext()) {
                cxml = it.current;
                if (cxml.getAttribute("id") == str) {
                    hitTestXml = cxml;
                    break;
                }
            }
        }
        var members: Array<any> = [];
        classInfo.members = members;
        it = xml.getEnumerator("controller");
        while (it.moveNext()) {
            cxml = it.current;
            cxml.removeAttribute("exported");
            cxml.removeAttribute("alias");
            cxml.removeChildren("remark");
            members.push({
                "name": cxml.getAttribute("name"),
                "type": "Controller",
                "index": it.index
            });
        }
        if (displayListNode) {
            col = displayListNode.getChildren();
            cnt = col.length;
            index = 0;
            while (index < cnt) {
                cxml = col[index];
                cxml.removeAttribute("aspect");
                cxml.removeAttribute("locked");
                cxml.removeAttribute("hideByEditor");
                cxml.removeAttribute("fileName");
                ename = cxml.getName();
                cname = cxml.getAttribute("name");
                src = cxml.getAttribute("src");
                if (src) {
                    pkgId = cxml.getAttribute("pkg");
                    if (pkgId == this.publishData.pkg.id) {
                        cxml.removeAttribute("pkg");
                        pkgId = null;
                    }
                    if (!pkgId) {
                        srcItem = this.publishData.pkg.getItem(src);
                        if (srcItem) {
                            this.addItem(srcItem);
                        }
                        else {
                            console.log("child resource missing: " + src + ", resource=[url=event:open]" + pi.name + "[/url]", pi);
                        }
                    }
                    else {
                        srcItem = this.publishData.project.getItem(pkgId, src);
                        if (srcItem) {
                            this.publishData.$_DJ$[pkgId] = true;
                        }
                        else {
                            console.log("child resource missing: " + src + "@" + pkgId + ", resource=[url=event:open]" + pi.name + "[/url]");
                        }
                    }
                }
                switch (ename) {
                    case "loader":
                        if (cxml.getAttributeBool("clearOnPublish")) {
                            cxml.removeAttribute("clearOnPublish");
                            cxml.removeAttribute("url");
                        }
                        else {
                            this.$__JW$(cxml.getAttribute("url"));
                        }
                        members.push({
                            "name": cname,
                            "type": "GLoader",
                            "index": index
                        });
                        break;
                    case "list":
                        if (cxml.getAttributeBool("treeView")) {
                            members.push({
                                "name": cname,
                                "type": "GTree",
                                "index": index
                            });
                        }
                        else {
                            members.push({
                                "name": cname,
                                "type": "GList",
                                "index": index
                            });
                        }
                        defaultItem = cxml.getAttribute("defaultItem");
                        this.$__JW$(defaultItem);
                        if (cxml.getAttributeBool("autoClearItems")) {
                            cxml.removeAttribute("autoClearItems");
                            cxml.removeChildren("item");
                        }
                        else {
                            it = cxml.getEnumerator("item");
                            while (it.moveNext()) {
                                dxml = it.current;
                                url = dxml.getAttribute("url");
                                if (url) {
                                    this.$__JW$(url);
                                }
                                str = dxml.getAttribute("icon");
                                if (str) {
                                    this.$__JW$(str);
                                }
                                str = dxml.getAttribute("selectedIcon");
                                if (str) {
                                    this.$__JW$(str);
                                }
                                // if (dxml.getChild("property") || dxml.hasAttributes("controllers")) {
                                //     listItem = this.publishData.project.getItemByURL(!!url ? url : defaultItem);
                                //     if (listItem && listItem.type == FPackageItemType.COMPONENT) {
                                //         this.$__5p$(dxml, listItem);
                                //     }
                                //     else {
                                //         dxml.removeChildren("property");
                                //         dxml.removeAttribute("controllers");
                                //     }
                                // }
                            }
                        }
                        str = cxml.getAttribute("scrollBarRes");
                        if (str) {
                            arr = str.split(",");
                            this.$__JW$(arr[0]);
                            this.$__JW$(arr[1]);
                        }
                        str = cxml.getAttribute("ptrRes");
                        if (str) {
                            arr = str.split(",");
                            this.$__JW$(arr[0]);
                            this.$__JW$(arr[1]);
                        }
                        break;
                    case "group":
                        if (!cxml.getAttributeBool("advanced")) {
                            toDelete.push(cxml);
                            gid = cxml.getAttribute("id");
                            pgid = cxml.getAttribute("group");
                            // for (dxml in col) {
                            //     if (dxml.getAttribute("group") == gid) {
                            //         if (pgid) {
                            //             dxml.setAttribute("group", pgid);
                            //         }
                            //         else {
                            //             dxml.removeAttribute("group");
                            //         }
                            //     }
                            // }
                        }
                        else {
                            cxml.removeAttribute("collapsed");
                            members.push({
                                "name": cname,
                                "type": "GGroup",
                                "index": index
                            });
                        }
                        break;
                    case "text":
                    case "richtext":
                        if (ename == "text") {
                            if (cxml.getAttributeBool("input")) {
                                members.push({
                                    "name": cname,
                                    "type": "GTextInput",
                                    "index": index
                                });
                            }
                            else {
                                members.push({
                                    "name": cname,
                                    "type": "GTextField",
                                    "index": index
                                });
                            }
                        }
                        else {
                            members.push({
                                "name": cname,
                                "type": "GRichTextField",
                                "index": index
                            });
                        }
                        if (cxml.getAttributeBool("autoClearText")) {
                            cxml.removeAttribute("autoClearText");
                            cxml.removeAttribute("text");
                        }
                        str = cxml.getAttribute("font");
                        if (str && UtilsStr.startsWith(str, "ui://") && str.length > 13) {
                            pkgId = str.substr(5, 8);
                            this.publishData.$_DJ$[pkgId] = true;
                        }
                        break;
                    case "movieclip":
                        members.push({
                            "name": cname,
                            "type": "GMovieClip",
                            "index": index
                        });
                        break;
                    case "jta":
                        cxml.setName("movieclip");
                        members.push({
                            "name": cname,
                            "type": "GMovieClip",
                            "index": index
                        });
                        break;
                    case "image":
                        if (cxml.getAttributeBool("forHitTest")) {
                            hitTestXml = cxml;
                            cxml.removeAttribute("forHitTest");
                        }
                        if (cxml.getAttributeBool("forMask")) {
                            xml.setAttribute("mask", cxml.getAttribute("id"));
                            cxml.removeAttribute("forMask");
                        }
                        members.push({
                            "name": cname,
                            "type": "GImage",
                            "index": index
                        });
                        break;
                    case "swf":
                        members.push({
                            "name": cname,
                            "type": "GSwfObject",
                            "index": index
                        });
                        break;
                    case "graph":
                        if (cxml.getAttributeBool("forMask")) {
                            xml.setAttribute("mask", cxml.getAttribute("id"));
                            cxml.removeAttribute("forMask");
                        }
                        members.push({
                            "name": cname,
                            "type": "GGraph",
                            "index": index
                        });
                        break;
                    case "component":
                        if (srcItem) {
                            if (srcItem.owner == this.publishData.pkg) {
                                members.push({
                                    "name": cname,
                                    "type": "GComponent",
                                    "index": index,
                                    "src": srcItem.name,
                                    "src_id": src
                                });
                            }
                            else {
                                members.push({
                                    "name": cname,
                                    "type": "GComponent",
                                    "index": index,
                                    "src": srcItem.name,
                                    "src_id": src,
                                    "pkg": srcItem.owner.name,
                                    "pkg_id": srcItem.owner.id
                                });
                            }
                        }
                        else {
                            members.push({
                                "name": cname,
                                "type": "GComponent",
                                "index": index,
                                "src": null,
                                "src_id": src
                            });
                        }
                        dxml = cxml.getChild("Button");
                        if (dxml) {
                            this.$__JW$(dxml.getAttribute("icon"));
                            this.$__JW$(dxml.getAttribute("selectedIcon"));
                            this.$__JW$(dxml.getAttribute("sound"));
                        }
                        dxml = cxml.getChild("Label");
                        if (dxml) {
                            this.$__JW$(dxml.getAttribute("icon"));
                        }
                        dxml = cxml.getChild("ComboBox");
                        if (dxml) {
                            it = dxml.getEnumerator("item");
                            while (it.moveNext()) {
                                this.$__JW$(it.current.getAttribute("icon"));
                            }
                            if (dxml.getAttributeBool("autoClearItems")) {
                                dxml.removeAttribute("autoClearItems");
                                dxml.removeChildren("item");
                            }
                        }
                        break;
                    default:
                        console.log("unknown display list item type: " + ename + ", resource=[url=event:open]" + pi.name + "[/url]");
                }
                if (srcItem && ename == "component") {
                    this.$__5p$(cxml, srcItem);
                }
                dxml = cxml.getChild("gearIcon");
                if (dxml) {
                    str = dxml.getAttribute("values");
                    if (str) {
                        arr = str.split("|");
                        for (str in arr) {
                            this.$__JW$(str);
                        }
                    }
                    this.$__JW$(dxml.getAttribute("default"));
                }
                index++;
            }
            // for (cxml in toDelete) {
            //     displayListNode.removeChild(cxml);
            // }
        }
        cxml = xml.getChild("Button");
        if (cxml) {
            this.$__JW$(cxml.getAttribute("sound"));
        }
        cxml = xml.getChild("ComboBox");
        if (cxml) {
            this.$__JW$(cxml.getAttribute("dropdown"));
        }
        var transIt: XDataEnumerator = xml.getEnumerator("transition");
        while (transIt.moveNext()) {
            cxml = transIt.current;
            cname = cxml.getAttribute("name");
            members.push({
                "name": cname,
                "type": "Transition",
                "index": transIt.index
            });
            it = cxml.getEnumerator("item");
            while (it.moveNext()) {
                tp = it.current.getAttribute("type");
                if (tp == "Sound" || tp == "Icon") {
                    this.$__JW$(it.current.getAttribute("value"));
                }
            }
        }
        str = xml.getAttribute("scrollBarRes");
        if (str) {
            arr = str.split(",");
            this.$__JW$(arr[0]);
            this.$__JW$(arr[1]);
        }
        str = xml.getAttribute("ptrRes");
        if (str) {
            arr = str.split(",");
            this.$__JW$(arr[0]);
            this.$__JW$(arr[1]);
        }
        if (hitTestXml) {
            src = hitTestXml.getAttribute("src");
            if (src) {
                pkgId = hitTestXml.getAttribute("pkg");
                if (!pkgId || pkgId == this.publishData.pkg.id) {
                    xml.setAttribute("hitTest", src + "," + hitTestXml.getAttribute("xy"));
                    hitTestItem = this.publishData.pkg.getItem(src);
                    if (hitTestItem) {
                        if (this.publishData.hitTestImages.indexOf(hitTestItem) == -1) {
                            this.publishData.hitTestImages.push(hitTestItem);
                        }
                    }
                }
                else {
                    console.log("HitTest image in another pakcage! resource=[url=event:open]" + pi.name + "[/url]");
                }
            }
            else {
                xml.setAttribute("hitTest", hitTestXml.getAttribute("id"));
            }
        }
        // this.publishData.outputDesc[pi.$__e$ + ".xml"] = xml.toXML();
    }

    private $__5p$(param1: XData, param2: FPackageItem): void {
        var _loc6_: string = "";
        var _loc7_: XData = null;
        var _loc8_: string = "";
        var _loc9_: number = 0;
        var _loc10_: Array<any> = null;
        var _loc11_: number = 0;
        var _loc12_: number = 0;
        var _loc13_: Boolean = false;
        var _loc3_: Array<ComProperty> = null;
        var _loc4_: XDataEnumerator = param1.getEnumerator("property");
        var _loc5_: string = param1.getName() == "item" ? "controllers" : "controller";
        while (_loc4_.moveNext()) {
            _loc7_ = _loc4_.current;
            if (!_loc3_) {
                _loc3_ = param2.getComponentData().getCustomProperties();
                if (!_loc3_) {
                    param1.removeChildren("property");
                    param1.removeAttribute(_loc5_);
                    break;
                }
            }
            _loc8_ = _loc7_.getAttribute("target");
            _loc9_ = _loc7_.getAttributeInt("propertyId");
            if (this.getCustomProperty(_loc3_, _loc8_, _loc9_)) {
                if (_loc9_ == 1) {
                    _loc6_ = _loc7_.getAttribute("value");
                    if (_loc6_) {
                        this.$__JW$(_loc6_);
                    }
                }
            }
            else {
                _loc4_.erase();
            }
        }
        _loc6_ = param1.getAttribute(_loc5_);
        if (_loc6_) {
            if (!_loc3_) {
                _loc3_ = param2.getComponentData().getCustomProperties();
                if (!_loc3_) {
                    param1.removeAttribute(_loc5_);
                }
            }
            if (_loc3_) {
                _loc10_ = _loc6_.split(",");
                _loc11_ = _loc10_.length;
                _loc12_ = 0;
                _loc13_ = false;
                while (_loc12_ < _loc11_) {
                    if (!this.getCustomProperty(_loc3_, _loc10_[_loc12_], -1)) {
                        _loc10_.splice(_loc12_, 2);
                        _loc11_ = _loc11_ - 2;
                        _loc13_ = true;
                    }
                    else {
                        _loc12_ = _loc12_ + 2;
                    }
                }
                if (_loc13_) {
                    if (_loc11_ == 0) {
                        param1.removeAttribute(_loc5_);
                    }
                    else {
                        param1.setAttribute(_loc5_, _loc10_.join(","));
                    }
                }
            }
        }
    }

    private getCustomProperty(param1: Array<ComProperty>, param2: string, param3: number): ComProperty {
        var _loc6_: ComProperty = null;
        var _loc4_: number = param1.length;
        var _loc5_: number = 0;
        while (_loc5_ < _loc4_) {
            _loc6_ = param1[_loc5_];
            if (_loc6_.target == param2 && _loc6_.propertyId == param3) {
                return _loc6_;
            }
            _loc5_++;
        }
        return null;
    }

    private $__Po$(param1: FPackageItem): void {
        var _loc5_: number = 0;
        var _loc7_: string = "";
        var _loc8_: Array<any> = null;
        var _loc9_: number = 0;
        var _loc10_: Array<any> = null;
        var _loc11_: FPackageItem = null;
        var _loc2_: string = UtilsFile.loadString(param1.file);
        if (!_loc2_) {
            return;
        }
        var _loc3_: Array<any> = _loc2_.split("\n");
        var _loc4_: number = _loc3_.length;
        var _loc6_: { [key: string]: any } = {};
        _loc5_ = 0;
        while (_loc5_ < _loc4_) {
            _loc7_ = _loc3_[_loc5_];
            if (_loc7_) {
                _loc8_ = _loc7_.split(" ");
                _loc9_ = 1;
                while (_loc9_ < _loc8_.length) {
                    _loc10_ = _loc8_[_loc9_].split("=");
                    _loc6_[_loc10_[0]] = _loc10_[1];
                    _loc9_++;
                }
                _loc7_ = _loc8_[0];
                if (_loc7_ == "char") {
                    _loc11_ = this.$__JW$("ui://" + this.publishData.pkg.id + _loc6_.img);
                    if (_loc11_) {
                        _loc11_.setVar("pubInfo.isFontLetter", true);
                    }
                }
                else if (_loc7_ == "info") {
                    if (_loc6_.face != undefined) {
                        break;
                    }
                }
            }
            _loc5_++;
        }
        if (param1.fontSettings.texture) {
            _loc11_ = this.publishData.pkg.getItem(param1.fontSettings.texture);
            if (_loc11_) {
                this.publishData.fontTextures[param1.fontSettings.texture] = param1;
                this.addItem(_loc11_);
                _loc11_.setVar("pubInfo.isFontLetter", true);
            }
        }
    }
}


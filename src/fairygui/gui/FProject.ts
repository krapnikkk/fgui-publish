import FObjectType from "../editor/api/FObjectType";
import IUIPackage from "../editor/api/IUIPackage";
import IUIProject from "../editor/api/IUIProject";
import ProjectType from "../editor/api/ProjectType";
import Consts from "../editor/Consts";
import CommonSettings from "../editor/settings/CommonSettings";
import CustomProps from "../editor/settings/CustomProps";
import { GlobalPublishSettings } from "../editor/settings/GlobalPublishSettings";
import PackageGroupSettings from "../editor/settings/PackageGroupSettings";
import SettingsBase from "../editor/settings/SettingsBase";
import Utils from "../utils/Utils";
import UtilsStr from "../utils/UtilsStr";
import XData from "../utils/XData";
import FPackage from "./FPackage";
import FPackageItem from "./FPackageItem";
import fs from "fs";
import path from "path";
// import { parseStringPromise } from "xml2js";


export default class FProject implements IUIProject {

    public static FILE_EXT: string = "fairy";

    public static ASSETS_PATH: string = "assets";

    public static SETTINGS_PATH: string = "settings";

    public static OBJS_PATH: string = ".objs";


    public _comExtensions: { [key: string]: any };

    public _globalFontVersion: number;

    private _id: string;

    private _name: string;

    private _basePath: string;

    private _assetsPath: string;

    private _objsPath: string;

    private _settingsPath: string;

    private _packages: Array<IUIPackage>;

    private _packageInsts: { [key: string]: any };

    private _type: string;

    private _opened: boolean;

    private _allSettings: { [key: string]: SettingsBase };

    private _vars: { [key: string]: any };

    private _branches: Array<string>;

    private _activeBranch: string;

    // private _editor: IEditor;

    private _versionCode: number;

    private _serialNumberSeed: string;

    private _lastChanged: number;

    _listDirty: boolean;

    // public constructor(editor: IEditor) {
    public constructor(basePath: string, name: string) {
        //  super();
        // this._editor = editor;
        this._basePath = basePath;
        this._name = name;
        this._vars = {};
        this._packages = new Array<IUIPackage>();
        this._packageInsts = {};
        this._branches = new Array<string>();
        this._activeBranch = "";
        this._serialNumberSeed = Utils.genDevCode();
        this._lastChanged = 0;
        this._allSettings = {};
        this._allSettings["common"] = new CommonSettings(this);
        this._allSettings["publish"] = new GlobalPublishSettings(this);
        this._allSettings["customProps"] = new CustomProps(this);
        this._allSettings["packageGroups"] = new PackageGroupSettings(this);
        this._comExtensions = {};
    }

    public static createNew(param1: string, param2: string, param3: string, param4: string = null): void {
        //  var _loc5_:XData = null;
        //  var _loc6_:File = null;
        //  var _loc7_:string = null;
        //  var _loc8_:* = null;
        //  param2 = FProject.validateName(param2);
        //  _loc5_ = XData.create("projectDescription");
        //  _loc5_.setAttribute("id",MD5.hash(param1 + new Date().time + Math.random() * 10000 + param2 + Capabilities.serverstring));
        //  _loc5_.setAttribute("type",param3);
        //  _loc5_.setAttribute("version","5.0");
        //  UtilsFile.saveXData(new File(param1 + File.separator + param2 + "." + FProject.FILE_EXT),_loc5_);
        //  _loc6_ = new File(param1 + File.separator + FProject.ASSETS_PATH);
        //  _loc6_.createDirectory();
        //  _loc6_ = new File(param1 + File.separator + FProject.OBJS_PATH);
        //  _loc6_.createDirectory();
        //  _loc6_ = new File(param1 + File.separator + FProject.SETTINGS_PATH);
        //  _loc6_.createDirectory();
        //  if(param4)
        //  {
        //     _loc7_ = UtilsStr.generateUID();
        //     _loc6_ = new File(param1 + File.separator + FProject.ASSETS_PATH + File.separator + param4);
        //     _loc6_.createDirectory();
        //     _loc8_ = Utils.genDevCode() + "0";
        //     _loc5_ = XData.parse("<packageDescription>" + "\t<resources>" + "\t\t<component id=\"" + _loc8_ + "\" name=\"Component1.xml\" path=\"/\" exported=\"true\"/>" + "\t</resources>" + "</packageDescription>");
        //     _loc5_.setAttribute("id",_loc7_);
        //     UtilsFile.saveXData(new File(_loc6_.nativePath + File.separator + "package.xml"),_loc5_);
        //     _loc5_ = XData.create("component");
        //     _loc5_.setAttribute("size","800,600");
        //     UtilsFile.saveXData(_loc6_.resolvePath("Component1.xml"),_loc5_);
        //  }
    }

    private static comparePackage(param1: FPackage, param2: FPackage): number {
        return param1.rootItem.sortKey.localeCompare(param2.rootItem.sortKey);
    }

    private static compareItem(param1: FPackageItem, param2: FPackageItem): number {
        return param1.sortKey.localeCompare(param2.sortKey);
    }

    public static validateName(param1: string): string {
        param1 = UtilsStr.trim(param1);
        if (param1.length == 0) {
            throw new Error(Consts.strings.text197);
        }
        if (param1.search(/[\:\/\\\*\?<>\|]/) != -1) {
            throw new Error(Consts.strings.text196);
        }
        return param1;
    }

    // public get editor(): IEditor {
    //     return this._editor;
    // }

    public get versionCode(): number {
        return this._versionCode;
    }

    public get serialNumberSeed(): string {
        return this._serialNumberSeed;
    }

    public get lastChanged(): number {
        return this._lastChanged;
    }

    public setChanged(): void {
        this._lastChanged++;
    }

    public get opened(): boolean {
        return this._opened;
    }

    public get id(): string {
        return this._id;
    }

    public get name(): string {
        return this._name;
    }

    public get type(): string {
        return this._type;
    }

    public set type(param1: string) {
        if (this._type != param1) {
            this._type = param1;
            this._lastChanged++;
            this.loadAllSettings();
        }
    }

    public get supportAtlas(): boolean {
        return this._type != ProjectType.FLASH && this._type != ProjectType.HAXE;
    }

    public get isH5(): boolean {
        return this._type == ProjectType.EGRET || this._type == ProjectType.LAYABOX || this._type == ProjectType.PIXI || this._type == ProjectType.COCOSCREATOR;
    }

    public get supportExtractAlpha(): boolean {
        return this._type == ProjectType.UNITY || this._type == ProjectType.COCOS2DX;
    }

    public get supportAlphaMask(): boolean {
        return this.supportAtlas && this._type != ProjectType.EGRET && this._type != ProjectType.STARLING;
    }

    public get zipFormatOption(): boolean {
        return this._type == ProjectType.FLASH || this._type == ProjectType.STARLING || this._type == ProjectType.HAXE;
    }

    public get binaryFormatOption(): boolean {
        return this._type == ProjectType.UNITY || this._type == ProjectType.COCOS2DX || this._type == ProjectType.EGRET || this._type == ProjectType.LAYABOX || this._type == ProjectType.PIXI;
    }

    public get supportCustomFileExtension(): boolean {
        return this.isH5 || this.zipFormatOption;
    }

    public get supportCodeType(): boolean {
        return this._type == ProjectType.LAYABOX;
    }

    public get basePath(): string {
        return this._basePath;
    }

    public get assetsPath(): string {
        return this._assetsPath;
    }

    public get objsPath(): string {
        return this._objsPath;
    }

    public get settingsPath(): string {
        return this._settingsPath;
    }

    public get activeBranch(): string {
        return this._activeBranch;
    }

    public set activeBranch(param1: string) {
        if (this._activeBranch != param1) {
            this._activeBranch = param1;
            this._lastChanged++;
        }
    }

    public async open() {
        // var xml: XData;
        // var arr: Array<string>;
        // let projectDescFile = fs.readFileSync(path.resolve(this._basePath + this.name + ".fairy")).toString(); // 读取.fairy文件信息
        // let xml = await parseStringPromise(projectDescFile);
        // xml = xml['projectDescription']['$'];
        // this._opened = true;
        // var projectFolder: File = projectDescFile.parent;
        // projectFolder.canonicalize();
        // this._basePath = projectFolder.nativePath;
        // try {
        // xml = UtilsFile.loadXData(projectDescFile);
        // }
        // catch (err: Error) {
        //     throw new Error(projectDescFile.name + " is corrupted, please check!");
        // }
        // this._id = xml["id"];
        // this._type = xml["type"];
        // if (!this._type) {
        //     this._type = ProjectType.UNITY;
        // }
        // console.log(this._type);
        // // this._name = UtilsStr.getFileName(projectDescFile.name);
        // var str: string = xml["version"];
        // if (str) {
        //     var arr = str.split(",");
        //     if (arr.length == 1) {
        //         this._versionCode = +(arr[0]) * 100;
        //     }
        //     else {
        //         this._versionCode = +(arr[0]) * 100 + +(arr[1]);
        //     }
        // } else {
        //     this._versionCode = 200;
        // }
        // var assetsFolder: File = projectFolder.resolvePath(FProject.ASSETS_PATH);
        // if (!assetsFolder.exists) {
        //     assetsFolder.createDirectory();
        // }

        // this._assetsPath = this._basePath + "assets/";
        // this._settingsPath = this._basePath + "settings/";
        // this._assetsPath = assetsFolder.nativePath;
        // this._objsPath = projectFolder.resolvePath(FProject.OBJS_PATH).nativePath;
        // this._settingsPath = projectFolder.resolvePath(FProject.SETTINGS_PATH).nativePath;
        // this.listAllPackages(assetsFolder);
        // this.loadAllSettings();
        // this.scanBranches();
    }

    public scanBranches(): boolean {
        var _loc1_: boolean = false;
        // var _loc7_: File = null;
        // var _loc8_: string = null;
        // var _loc2_: number = this._branches.length;
        // var _loc3_: number = 0;
        // var _loc4_: Array = [];
        // while (_loc3_ < _loc2_) {
        //     if (!new File(this._basePath + "/assets_" + this._branches[_loc3_]).exists) {
        //         this._branches.splice(_loc3_, 1);
        //         _loc2_--;
        //         _loc1_ = true;
        //     }
        //     else {
        //         _loc4_.push(this._branches[_loc3_]);
        //         _loc3_++;
        //     }
        // }
        // var _loc5_: File = new File(this._basePath);
        // var _loc6_: Array = _loc5_.getDirectoryListing();
        // for (_loc7_ in _loc6_) {
        //     if (_loc7_.isDirectory && UtilsStr.startsWith(_loc7_.name, "assets_")) {
        //         _loc8_ = _loc7_.name.substring(7);
        //         if (_loc4_.indexOf(_loc8_) == -1) {
        //             this._branches.push(_loc8_);
        //             _loc1_ = true;
        //         }
        //     }
        // }
        // this._branches.sort(0);
        // if (_loc1_) {
        //     this._lastChanged++;
        // }
        return _loc1_;
    }

    private listAllPackages(param1: File): void {
        // var _loc5_: File = null;
        // var _loc6_: File = null;
        // var _loc2_: Array = param1.getDirectoryListing();
        // var _loc3_: number = _loc2_.length;
        // var _loc4_: number = 0;
        // while (_loc4_ < _loc3_) {
        //     _loc5_ = _loc2_[_loc4_];
        //     if (_loc5_.isDirectory) {
        //         _loc6_ = new File(_loc5_.nativePath + File.separator + "package.xml");
        //         if (_loc6_.exists) {
        //             this.addPackage(_loc5_);
        //         }
        //     }
        //     _loc4_++;
        // }
    }

    public close(): void {
        // var _loc1_: FPackage = null;
        // for (_loc1_ in this._packageInsts) {
        //     _loc1_.dispose();
        // }
        // this._opened = false;
        // this._editor = null;
        // WorkerClient.inst.removeRequests(this);
    }

    public getSettings(setting: string): SettingsBase {
        return this._allSettings[setting];
    }

    public saveSettings(param1: string): void {
        // var _loc2_: SettingsBase = SettingsBase(this._allSettings[param1]);
        // _loc2_.save();
    }

    public getSetting(param1: string, param2: string): any {
        // return this._allSettings[param1][param2];
    }

    public setSetting(param1: string, param2: string, param3: any): void {
        // this._allSettings[param1][param2] = param3;
    }

    public loadAllSettings(): void {
        // var _loc1_: SettingsBase = null;
        // for (_loc1_ in this._allSettings) {
        //     _loc1_.touch(true);
        // }
        for(let key in this._allSettings){
            let setting = this._allSettings[key];
            setting.touch();
        }
    }

    public rename(param1: string): void {
        // var _loc2_: File = new File(this._basePath + File.separator + this._name + ".fairy");
        // this._name = param1;
        // _loc2_.moveTo(new File(this._basePath + File.separator + this._name + ".fairy"));
    }

    public getPackage(param1: string): IUIPackage {
        return this._packageInsts[param1];
    }

    public getPackageByName(param1: string): IUIPackage {
        for (let key in this._packageInsts) {
            var _loc2_: FPackage = this._packageInsts[key];
            if (Consts.isMacOS && _loc2_.name == param1 || !Consts.isMacOS && _loc2_.name.toLowerCase() == param1.toLowerCase()) {
                return _loc2_;
            }
        }
        return null;
    }

    public createPackage(param1: string): IUIPackage {
        // var _loc3_: File = null;
        // param1 = validateName(param1);
        // if (this.getPackageByName(param1) != null) {
        //     throw new Error("Package already exists!");
        // }
        // var _loc2_: string = UtilsStr.generateUID();
        // if (this._activeBranch.length == 0) {
        //     _loc3_ = new File(this.assetsPath + File.separator + param1);
        // }
        // else {
        //     _loc3_ = new File(this.assetsPath + "_" + this._activeBranch + File.separator + param1);
        // }
        // _loc3_.createDirectory();
        // var _loc4_: XData = XData.parse("<packageDescription><resources/></packageDescription>");
        // _loc4_.setAttribute("id", _loc2_);
        // UtilsFile.saveXData(new File(_loc3_.nativePath + File.separator + "package.xml"), _loc4_);
        var _loc5_: FPackage = new FPackage(this);
        // this._packageInsts[_loc2_] = _loc5_;
        // this._packages.push(_loc5_);
        // this._listDirty = true;
        // _loc5_.open();
        // if (this._editor) {
        //     this._editor.emit(EditorEvent.PackageListChanged);
        // }
        return _loc5_;
    }

    public addPackage(param1: File): FPackage {
        var _loc2_: FPackage = new FPackage(this);
        var _loc3_: FPackage = this._packageInsts[_loc2_.id];
        if (_loc3_ != null) {
            return _loc3_;
        }
        this._packageInsts[_loc2_.id] = _loc2_;
        this._packages.push(_loc2_);
        this._listDirty = true;
        this._lastChanged++;
        return _loc2_;
    }

    public deletePackage(param1: string): void {
        // var _loc2_: FPackage = this._packageInsts[param1];
        // if (!_loc2_) {
        //     return;
        // }
        // if (this._editor) {
        //     this._editor.docView.closeDocuments(_loc2_);
        // }
        // _loc2_.dispose();
        // var _loc3_: File = new File(this.assetsPath + File.separator + _loc2_.name);
        // if (_loc3_.exists) {
        //     _loc3_.moveToTrash();
        // }
        // _loc3_ = new File(this.objsPath + File.separator + "cache" + File.separator + _loc2_.id);
        // if (_loc3_.exists) {
        //     try {
        //         _loc3_.deleteDirectory(true);
        //     }
        //     catch (err: Error) {
        //     }
        // }
        // delete this._packageInsts[param1];
        // var _loc4_: number = this._packages.indexOf(_loc2_);
        // this._packages.removeAt(_loc4_);
        // this._listDirty = true;
        // this._lastChanged++;
        // if (this._editor) {
        //     this._editor.emit(EditorEvent.PackageListChanged);
        // }
    }

    public get allPackages(): Array<IUIPackage> {
        // if (this._listDirty) {
        //     this._packages.sort(comparePackage);
        //     this._listDirty = false;
        // }
        return this._packages;
    }

    public get allBranches(): Array<string> {
        return this._branches;
    }

    public save(): void {
        // var _loc1_: XData = XData.create("projectDescription");
        // _loc1_.setAttribute("id", this._id);
        // _loc1_.setAttribute("type", this._type);
        // _loc1_.setAttribute("version", Number(this._versionCode / 100) + "." + Number(this._versionCode % 100));
        // UtilsFile.saveXData(new File(this._basePath + File.separator + this._name + ".fairy"), _loc1_);
    }

    public getItemByURL(param1: string): FPackageItem {
        var _loc4_: string = null;
        var _loc5_: IUIPackage = null;
        var _loc6_: string = null;
        var _loc7_: string = null;
        var _loc8_: string = null;
        if (param1 == null) {
            return null;
        }
        var _loc2_: number = param1.indexOf("//");
        if (_loc2_ == -1) {
            return null;
        }
        var _loc3_: number = param1.indexOf("/", _loc2_ + 2);
        if (_loc3_ == -1) {
            if (param1.length > 13) {
                _loc4_ = param1.substr(5, 8);
                _loc5_ = this.getPackage(_loc4_);
                if (_loc5_ != null) {
                    _loc6_ = param1.substr(13);
                    return _loc5_.getItem(_loc6_);
                }
            }
        }
        else {
            _loc7_ = param1.substr(_loc2_ + 2, _loc3_ - _loc2_ - 2);
            _loc5_ = this.getPackageByName(_loc7_);
            if (_loc5_ != null) {
                _loc8_ = param1.substr(_loc3_ + 1);
                return _loc5_.findItemByName(_loc8_);
            }
        }
        return null;
    }

    public getItem(param1: string, param2: string): FPackageItem {
        var _loc3_: IUIPackage = this.getPackage(param1);
        if (_loc3_) {
            return _loc3_.getItem(param2);
        }
        return null;
    }

    public findItemByFile(param1: File): FPackageItem {
        // var _loc5_: string = null;
        // var _loc6_: IUIPackage = null;
        // var _loc7_: FPackageItem = null;
        // param1.canonicalize();
        // if (!UtilsStr.startsWith(param1.nativePath, this._assetsPath, true)) {
        //     return null;
        // }
        // var _loc2_: any = param1.nativePath.substr(this._assetsPath.length);
        // var _loc3_: string = UtilsStr.getFileFullName(_loc2_);
        // _loc2_ = UtilsStr.getFilePath(_loc2_).replace(/\\/g, "/") + "/";
        // var _loc4_: number = _loc2_.indexOf("/", 1);
        // if (_loc4_ != -1) {
        //     _loc5_ = _loc2_.substring(1, _loc4_);
        //     _loc6_ = this.getPackageByName(_loc5_);
        //     if (_loc6_) {
        //         _loc7_ = _loc6_.getItem(_loc2_.substring(_loc4_));
        //         if (_loc7_) {
        //             return _loc6_.getItemByFileName(_loc7_, _loc3_);
        //         }
        //     }
        // }
        return null;
    }

    public getItemNameByURL(param1: string): string {
        var _loc2_: FPackageItem = this.getItemByURL(param1);
        if (_loc2_) {
            return _loc2_.name;
        }
        return "";
    }

    public createBranch(param1: string): void {
        // var _loc2_: File = new File(this._basePath + "/assets_" + param1);
        // if (_loc2_.exists) {
        //     throw new Error(Consts.strings.text447);
        // }
        // _loc2_.createDirectory();
        // this.scanBranches();
        // if (this._editor) {
        //     this._editor.emit(EditorEvent.PackageListChanged);
        // }
    }

    public renameBranch(param1: string, param2: string): void {
        // var _loc5_: FPackage = null;
        // var _loc6_: FPackageItem = null;
        // param2 = validateName(param2);
        // if (param2 == param1) {
        //     return;
        // }
        // var _loc3_: File = new File(this._basePath + "/assets_" + param1);
        // var _loc4_: File = new File(this._basePath + "/assets_" + param2);
        // UtilsFile.renameFile(_loc3_, _loc4_);
        // this.scanBranches();
        // param2 = ":" + param2;
        // for (_loc5_ in this._packageInsts) {
        //     if (_loc5_.opened) {
        //         _loc6_ = _loc5_.getItem("/:" + param1 + "/");
        //         if (_loc6_) {
        //             _loc5_.renameBranchRoot(_loc6_, param2);
        //         }
        //     }
        // }
        // if (this._editor) {
        //     this._editor.emit(EditorEvent.PackageListChanged);
        // }
    }

    public removeBranch(param1: string): void {
        // var _loc2_: File = new File(this._basePath + "/assets_" + param1);
        // UtilsFile.deleteFile(_loc2_, true);
        // this._editor.refreshProject();
    }

    getBranch(param1: FPackageItem): FPackageItem {
        if (this._activeBranch.length == 0) {
            return param1;
        }
        var _loc2_: string = "/:" + this._activeBranch + param1.path + param1.name;
        var _loc3_: FPackageItem = param1.owner.getItemByPath(_loc2_);
        if (_loc3_ && _loc3_.type == param1.type) {
            return _loc3_;
        }
        return param1;
    }

    public setVar(param1: string, param2: any): void {
        if (param2 == undefined) {
            delete this._vars[param1];
        }
        else {
            this._vars[param1] = param2;
        }
    }

    public getVar(param1: string): any {
        return this._vars[param1];
    }

    public registerCustomExtension(param1: string, param2: string, param3: string): void {
        var _loc4_: string;
        var _loc5_: Array<string>;
        if (this._comExtensions[param2]) {
            throw new Error("Component extension \'" + param2 + "\' already exists!");
        }
        if (param3 != null) {
            _loc4_ = param3.substr(1);
        }
        else {
            _loc4_ = null;
        }
        if (_loc4_ != null && FObjectType.NAME_PREFIX[_loc4_] == undefined) {
            throw new Error("Component extension \'" + param3 + "\' does not exist!");
        }
        this._comExtensions[param2] = {
            "name": param1,
            "className": param2,
            "superClassName": _loc4_
        };
        // if (this._editor) {
        //     _loc5_ = this.getVar("CustomExtensionIDs") as Array<string>;
        //     if (!_loc5_) {
        //         _loc5_ = [];
        //     }
        //     _loc5_.push(param2);
        //     this.setVar("CustomExtensionIDs", _loc5_);
        //     this.setVar("CustomExtensionChanged", true);
        // }
    }

    public getCustomExtension(param1: string): {} {
        return this._comExtensions[param1];
    }

    public clearCustomExtensions(): void {
        this._comExtensions = {};
        // if (this._editor) {
        //     this.setVar("CustomExtensionIDs", undefined);
        //     this.setVar("CustomExtensionChanged", true);
        // }
    }

    public alert(param1: string, param2: Error = null): void {
        // if (this._editor) {
        //     this._editor.alert(null, param2);
        // }
        // else if (!param2) {
        // }
    }

    public logError(param1: string, param2: Error = null): void {
        // if (this._editor) {
        //     this._editor.consoleView.logError(param1, param2);
        // }
        // else if (!param2) {
        // }
    }

    public playSound(param1: string, param2: number): void {
        // var _loc3_: FPackageItem = this.getItemByURL(param1);
        // if (_loc3_) {
        //     _loc3_.setVar("volume", param2);
        //     _loc3_.getSound(this.playSound2);
        // }
    }

    private playSound2(param1: FPackageItem): void {
        // var _loc3_:number = NaN;
        // var _loc2_: Sound = param1.sound;
        // if (_loc2_) {
        //     _loc3_ = Number(param1.getVar("volume"));
        //     if (_loc3_ == 0 || isNaN(_loc3_)) {
        //         _loc2_.play();
        //     }
        //     else {
        //         _loc2_.play(0, 0, new SoundTransform(_loc3_));
        //     }
        // }
    }

    public asyncRequest(param1: string, param2: any, param3: any, param4: any): void {
        //     WorkerClient.inst.send(this, param1, param2, param3, param4);
    }
}

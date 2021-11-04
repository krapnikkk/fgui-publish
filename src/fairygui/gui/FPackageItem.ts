import ByteArray from "src/utils/ByteArray";
import IUIPackage from "../editor/api/IUIPackage";
import Consts from "../editor/Consts";
import FolderSettings from "../editor/settings/FolderSettings";
import FontSettings from "../editor/settings/FontSettings";
import { GlobalPublishSettings } from "../editor/settings/GlobalPublishSettings";
import ImageSettings from "../editor/settings/ImageSettings";
import Utils from "../utils/Utils";
import UtilsFile from "../utils/UtilsFile";
import UtilsStr from "../utils/UtilsStr";
import XData from "../utils/XData";
import AniDef from "./animation/AniDef";
import ComponentData from "./ComponentData";
import FPackage from "./FPackage";
import FPackageItemType from "./FPackageItemType";
import FProject from "./FProject";
import ImageInfo from "./ImageInfo";


export default class FPackageItem {


    public exported: boolean;

    public favorite: boolean;

    public reviewed: string;

    // public §_-e§:string; // todo branch?
    $__e$: string;
    public _errorStatus: boolean;

    private _id: string;

    private _type: string;

    private _owner: FPackage;

    private _name: string;

    private _path: string;

    private _fileName: string;

    private _branch: string;

    private _file: File;

    private _width: number;

    private _height: number;

    private _sortKey: string;

    private _quickKey: string;

    private _version: number;

    private _lastTouch: number;

    private _modificationTime: Number;

    private _fileSize: Number;

    private _needReload: boolean;

    private _hash: string;

    private _vars: { [key: string]: any }

    private _loadQueue: Array<Function>;

    private _data: { [key: string]: any }

    private _releasedTime: number;

    private _ref: number;

    private _dataVersion: number;

    private _disposed: boolean;

    private _loading: boolean;

    private _imageSettings: ImageSettings;

    private _folderSettings: FolderSettings;

    private _fontSettings: FontSettings;

    private _imageInfo: ImageInfo;

    private _children: Array<FPackageItem>;

    private _componentExtension: string;

    public constructor(param1: IUIPackage, param2: string, param3: string) {
        this._owner = param1 as FPackage;
        this._type = param2;
        this._id = param3;
        this._vars = {};
        this._needReload = true;
        this._quickKey;
        if (param2 == FPackageItemType.IMAGE || param2 == FPackageItemType.MOVIECLIP) {
            this._imageSettings = new ImageSettings();
            this._imageInfo = new ImageInfo();
        }
        else if (param2 == FPackageItemType.FOLDER) {
            this._folderSettings = new FolderSettings();
            this._children = [];
        }
        else if (param2 == FPackageItemType.FONT) {
            this._fontSettings = new FontSettings();
        }
    }

    // private static __imageLoaded(param1: LoaderExt): void {
    //     var _loc2_: Object = param1.content;
    //     var _loc3_: FPackageItem = FPackageItem(param1.props.pi);
    //     if (_loc3_._disposed) {
    //         return;
    //     }
    //     _loc3_._loading = false;
    //     if (_loc2_ is Bitmap)
    //     {
    //         _loc3_.updateData(_loc2_.bitmapData, param1.props.ver);
    //     }
    //     _loc3_.invokeLoadedCallbacks();
    // }

    public get owner(): FPackage {
        return this._owner;
    }

    public get pkg(): IUIPackage {
        return this._owner;
    }

    public get parent(): FPackageItem {
        if (this == this._owner.rootItem) {
            return null;
        }
        return this._owner.getItem(this._path);
    }

    public get type(): string {
        return this._type;
    }

    public get id(): string {
        return this._id;
    }

    public set id(param1: string) {
        this._id = param1;
    }

    public get path(): string {
        return this._path;
    }

    public get branch(): string {
        return this._branch;
    }

    public get isRoot(): boolean {
        return this._id == "/";
    }

    public get isBranchRoot(): boolean {
        return this._path == "/" && this._branch.length > 0;
    }

    public get name(): string {
        return this._name;
    }

    public get file(): File {
        return this._file;
    }

    public get fileName(): string {
        return this._fileName;
    }

    public get modificationTime(): Number {
        return this._modificationTime;
    }

    public get isError(): boolean {
        return this._errorStatus;
    }

    public matchName(param1: string): boolean {
        // if (this._quickKey == null) {
        //     this._quickKey = PinYinUtil.toPinyin(this._name.substr(0, 5), true, false, false).toLowerCase();
        // }
        // var _loc2_:number = param1.length;
        // if (this._quickKey.length < _loc2_) {
        //     return false;
        // }
        // var _loc3_:number = 0;
        // while (_loc3_ < _loc2_) {
        //     if (param1.charCodeAt(_loc3_) != this._quickKey.charCodeAt(_loc3_)) {
        //         return false;
        //     }
        //     _loc3_++;
        // }
        return true;
    }

    public get sortKey(): string {
        if (this._sortKey == null) {
            this._sortKey = (this._branch.length > 0 ? "A" : "B") + Utils.getStringSortKey(this._name);
        }
        return this._sortKey;
    }

    public getURL(): string {
        return "ui://" + this._owner.id + this._id;
    }

    public get version(): number {
        return this._version;
    }

    public get width(): Number {
        if (this._needReload) {
            this.loadInfo();
        }
        return this._width;
    }

    public get height(): Number {
        if (this._needReload) {
            this.loadInfo();
        }
        return this._height;
    }

    public get children(): Array<FPackageItem> {
        return this._children;
    }

    public get imageInfo(): ImageInfo {
        if (this._needReload) {
            this.loadInfo();
        }
        return this._imageInfo;
    }

    public get componentExtension(): string {
        if (this._needReload) {
            this.loadInfo();
        }
        return this._componentExtension;
    }

    public get imageSettings(): ImageSettings {
        return this._imageSettings;
    }

    public get folderSettings(): FolderSettings {
        return this._folderSettings;
    }

    public get fontSettings(): FontSettings {
        return this._fontSettings;
    }

    public copySettings(param1: FPackageItem): void {
        if (this._type == FPackageItemType.IMAGE || this._type == FPackageItemType.MOVIECLIP) {
            this._imageSettings.copyFrom(param1.imageSettings);
        }
        else if (this._type == FPackageItemType.FONT) {
            this._fontSettings.copyFrom(param1.fontSettings);
        }
    }

    public setFile(param1: string, param2: string): void {
        // var _loc4_:number = 0;
        // this._path = param1;
        // if (this._path.length > 2 && this._path.charCodeAt(1) == 58) {
        //     _loc4_ = this._path.indexOf("/", 2);
        //     this._branch = this._path.substring(2, _loc4_);
        // }
        // else if (this._path.length == 1 && param2.charCodeAt(0) == 58) {
        //     this._branch = param2.substring(1);
        // }
        // else {
        //     this._branch = "";
        // }
        // this._fileName = param2;
        // if (this.type == FPackageItemType.FOLDER) {
        //     this._name = this._fileName;
        // }
        // else {
        //     this._name = UtilsStr.getFileName(this._fileName);
        // }
        // this._sortKey ;
        // this._quickKey ;
        // var _loc3_: File = this._file;
        // if (this._branch.length > 0) {
        //     if (this._path.length == 1) {
        //         this._file = new File(this._owner.project.basePath + "/assets_" + this._branch + "/" + this._owner.name);
        //     }
        //     else {
        //         this._file = new File(this._owner.project.basePath + "/assets_" + this._branch + "/" + this._owner.name + "/" + this._path.substr(this._branch.length + 3) + this._fileName);
        //     }
        // }
        // else if (this._path.length == 0) {
        //     this._file = new File(this._owner.basePath);
        // }
        // else {
        //     this._file = new File(this._owner.basePath + this._path + this._fileName);
        // }
        // if (_loc3_) {
        //     if (this._imageInfo && this._imageInfo.file == _loc3_) {
        //         this._imageInfo.file = this._file;
        //     }
        // }
        // if (this._file.exists) {
        //     this._modificationTime = this._file.modificationDate.time;
        //     this._fileSize = this._file.size;
        //     if (this._errorStatus) {
        //         this._errorStatus = false;
        //         this.setChanged();
        //     }
        // }
        // else {
        //     if (!this._errorStatus) {
        //         this._errorStatus = true;
        //         this.setChanged();
        //     }
        //     this._hash ;
        // }
    }

    public setChanged(): void {
        this._version++;
        this._needReload = true;
    }

    public touch(): void {
        // if (this._lastTouch == GTimers.workCount) {
        //     return;
        // }
        // this._lastTouch = GTimers.workCount;
        // if (this._file.exists) {
        //     if (this._modificationTime != this._file.modificationDate.time || this._fileSize != this._file.size) {
        //         this._version++;
        //         this._modificationTime = this._file.modificationDate.time;
        //         this._fileSize = this._file.size;
        //         this._hash ;
        //         this._needReload = true;
        //     }
        //     if (this._errorStatus) {
        //         this._version++;
        //         this._errorStatus = false;
        //     }
        // }
        // else if (!this._errorStatus) {
        //     this._version++;
        //     this._errorStatus = true;
        // }
    }

    public setUptoDate(): void {
        // if (this._file.exists) {
        //     this._modificationTime = this._file.modificationDate.time;
        //     this._fileSize = this._file.size;
        // }
    }

    public getComponentData(): ComponentData {
        if (this._type != FPackageItemType.COMPONENT) {
            throw new Error("invalid call to get componentData");
        }
        if (this._disposed) {
            return null;
        }
        if (this._needReload) {
            this.loadInfo();
        }
        if (!this._data || this._dataVersion != this._version) {
            this.updateData(new ComponentData(this), this._version);
        }
        return this._data as ComponentData;
    }

    // public get image(): BitmapData {
    //     return BitmapData(this._data);
    // }

    // public getImage(param1: Function = null): BitmapData {
    //     if (this._type != FPackageItemType.IMAGE) {
    //         throw new Error("invalid item status");
    //     }
    //     if (this._disposed) {
    //         return null;
    //     }
    //     if (this._needReload) {
    //         this.loadInfo();
    //     }
    //     if (param1 != null) {
    //         this.addLoadedCallback(param1);
    //     }
    //     if (this._data && this._dataVersion == this._version) {
    //         if (param1 != null) {
    //             GTimers.inst.callLater(this.invokeLoadedCallbacks);
    //         }
    //         return BitmapData(this._data);
    //     }
    //     if (!this._file.exists) {
    //         this.disposeData();
    //         if (param1 != null) {
    //             GTimers.inst.callLater(this.invokeLoadedCallbacks);
    //         }
    //         return null;
    //     }
    //     if (!this._loading) {
    //         this._loading = true;
    //         if (this._imageInfo.needConversion) {
    //             this.convertImage();
    //         }
    //         else {
    //             this._imageInfo.file = this._file;
    //             EasyLoader.load(this._file.url, {
    //                 "type": "image",
    //                 "pi": this,
    //                 "ver": this._version
    //             }, __imageLoaded);
    //         }
    //     }
    //     return null;
    // }

    public getAnimation(): AniDef {
    //     var ani: AniDef ;
    //     var ba: ByteArray ;
    //     if (this._type != FPackageItemType.MOVIECLIP) {
    //         throw new Error("invalid item status");
    //     }
    //     if (this._disposed) {
    //         return null;
    //     }
    //     if (this._needReload) {
    //         this.loadInfo();
    //     }
    //     if (!this._data || this._dataVersion != this._version) {
    //         ba = UtilsFile.loadBytes(this._file);
    //         if (ba != null) {
    //             try {
    //                 ani = new AniDef();
    //                 ani.load(ba);
    //             }
    //             catch (err: Error) {
    //                 owner.project.logError("load movieclip", err);
    //             }
    //         }
    //         this.updateData(ani, this._version);
    //     }
        return (<AniDef>this._data);
    }

    // public getBitmapFont(): FBitmapFont {
    //     var _loc1_: FBitmapFont ;
    //     if (this._type != FPackageItemType.FONT) {
    //         throw new Error("invalid item status");
    //     }
    //     if (this._disposed) {
    //         return null;
    //     }
    //     if (this._needReload) {
    //         this.loadInfo();
    //     }
    //     if (!this._data || this._dataVersion != this._version) {
    //         _loc1_ = new FBitmapFont(this);
    //         this.updateData(_loc1_, this._version);
    //         _loc1_.load();
    //     }
    //     return FBitmapFont(this._data);
    // }

    // public get sound(): Sound {
    //     return Sound(this._data);
    // }

    // public getSound(param1: Function = null): Sound {
    //     if (this._type != FPackageItemType.SOUND) {
    //         throw new Error("invalid item status");
    //     }
    //     if (this._disposed) {
    //         return null;
    //     }
    //     if (this._needReload) {
    //         this.loadInfo();
    //     }
    //     if (param1 != null) {
    //         this.addLoadedCallback(param1);
    //     }
    //     if (this._data && this._dataVersion == this._version) {
    //         if (param1 != null) {
    //             GTimers.inst.callLater(this.invokeLoadedCallbacks);
    //         }
    //         return Sound(this._data);
    //     }
    //     if (!this._file.exists) {
    //         this.disposeData();
    //         if (param1 != null) {
    //             GTimers.inst.callLater(this.invokeLoadedCallbacks);
    //         }
    //         return null;
    //     }
    //     var _loc2_:string = UtilsStr.getFileExt(this._fileName);
    //     if (_loc2_ == "mp3") {
    //         this.updateData(new Sound(new URLRequest(this._file.url)), this._version);
    //         if (param1 != null) {
    //             GTimers.inst.callLater(this.invokeLoadedCallbacks);
    //         }
    //         return Sound(this._data);
    //     }
    //     if (!this._loading) {
    //         this._loading = true;
    //         this.convertSound();
    //     }
    //     return null;
    // }

    public addLoadedCallback(param1: Function): void {
        if (!this._loadQueue) {
            this._loadQueue = [];
        }
        var _loc2_: number = this._loadQueue.indexOf(param1);
        if (_loc2_ == -1) {
            this._loadQueue.push(param1);
        }
    }

    public removeLoadedCallback(param1: Function): void {
        if (!this._loadQueue) {
            return;
        }
        var _loc2_: number = this._loadQueue.indexOf(param1);
        if (_loc2_ != -1) {
            this._loadQueue.splice(_loc2_, 1);
        }
    }

    public get loading(): boolean {
        return this._loading;
    }

    public invokeLoadedCallbacks(): void {
        var _loc3_: Function;
        if (!this._loadQueue || this._loadQueue.length == 0) {
            return;
        }
        var _loc1_: Array<Function> = this._loadQueue.concat();
        this._loadQueue.length = 0;
        var _loc2_: number = 0;
        while (_loc2_ < _loc1_.length) {
            _loc3_ = _loc1_[_loc2_];
            _loc3_(this);
            _loc2_++;
        }
    }

    public openWithDefaultApplication(): void {
        // if (this.isRoot) {
        //     new File(this._owner.basePath + "/package.xml").openWithDefaultApplication();
        // }
        // else if (this.isBranchRoot) {
        //     new File(this._owner.getBranchPath(this._branch) + "/package_branch.xml").openWithDefaultApplication();
        // }
        // else {
        //     this._file.openWithDefaultApplication();
        // }
    }

    private loadInfo(): void {
        // var _loc1_: IDocument ;
        // var _loc2_: XData ;
        // var _loc3_:string = "";
        // var _loc4_: Array ;
        // var _loc5_:string = "";
        // var _loc6_: Object ;
        // var _loc7_: GlobalPublishSettings ;
        // this._needReload = false;
        // this._width = this._height = 0;
        // if (this._type == FPackageItemType.COMPONENT) {
        //     _loc1_ = this._vars.doc;
        //     if (_loc1_ && _loc1_.content) {
        //         this._width = _loc1_.content.width;
        //         this._height = _loc1_.content.height;
        //         this._componentExtension = _loc1_.content.extentionId;
        //     }
        //     else {
        //         _loc2_ = UtilsFile.loadXMLRoot(this._file);
        //         if (_loc2_) {
        //             _loc3_ = _loc2_.getAttribute("size");
        //             if (_loc3_) {
        //                 _loc4_ = _loc3_.split(",");
        //                 this._width = parseInt(_loc4_[0]);
        //                 this._height = parseInt(_loc4_[1]);
        //             }
        //             _loc3_ = _loc2_.getAttribute("extention");
        //             if (_loc3_) {
        //                 this._componentExtension = _loc3_;
        //             }
        //         }
        //     }
        //     if (this._componentExtension == null) {
        //         this._componentExtension = "";
        //     }
        // }
        // else if (this._imageInfo != null) {
        //     _loc5_ = this._file.extension;
        //     if (_loc5_ && _loc5_.toLowerCase() == "svg") {
        //         this._imageInfo.format = "svg";
        //         this._width = this._imageSettings.width;
        //         this._height = this._imageSettings.height;
        //     }
        //     else {
        //         _loc6_ = ResourceSize.getSize(this._file);
        //         if (_loc6_) {
        //             this._imageInfo.format = _loc6_.type;
        //             this._width = _loc6_.width;
        //             this._height = _loc6_.height;
        //         }
        //         else {
        //             this._imageInfo.format = "png";
        //         }
        //     }
        //     switch (this._imageSettings.qualityOption) {
        //         case ImageSettings.QUALITY_DEFAULT:
        //             if (this.owner.project.supportAtlas) {
        //                 this._imageInfo.targetQuality = 100;
        //             }
        //             else {
        //                 _loc7_ = GlobalPublishSettings(this._owner.project.getSettings("publish"));
        //                 if (this._imageInfo.format == "jpg") {
        //                     this._imageInfo.targetQuality = _loc7_.jpegQuality;
        //                 }
        //                 else {
        //                     this._imageInfo.targetQuality = !!_loc7_.compressPNG ? 8 : 100;
        //                 }
        //             }
        //             break;
        //         case ImageSettings.QUALITY_SOURCE:
        //             this._imageInfo.targetQuality = 100;
        //             break;
        //         case ImageSettings.QUALITY_CUSTOM:
        //             if (this._imageInfo.format == "jpg") {
        //                 this._imageInfo.targetQuality = this._imageSettings.quality;
        //             }
        //             else {
        //                 this._imageInfo.targetQuality = this._imageSettings.quality != 100 ? 8 : 100;
        //             }
        //             break;
        //         default:
        //             this._imageInfo.targetQuality = 100;
        //     }
        // }
        // else {
        //     _loc6_ = ResourceSize.getSize(this._file);
        //     if (_loc6_) {
        //         this._width = _loc6_.width;
        //         this._height = _loc6_.height;
        //     }
        // }
    }

    private updateHash(): void {
        // var _loc1_: ByteArray = UtilsFile.loadBytes(this.file);
        // if (_loc1_ != null) {
        //     this._hash = MD5.hashBinary(_loc1_);
        //     _loc1_.clear();
        // }
    }

    public updateReviewStatus(): boolean {
        if (this._hash == null) {
            this.updateHash();
        }
        if (this.reviewed != this._hash) {
            this.reviewed = this._hash;
            return true;
        }
        return false;
    }

    public get isReviewStatusUpdated(): boolean {
        if (this._hash == null) {
            this.updateHash();
        }
        return this.reviewed == this._hash;
    }

    public get title(): string {
        if (this._branch.length > 0 && this._path.length == 1) {
            return this._branch;
        }
        return this._name;
    }

    public getIcon(param1: boolean = false): string {
        var _loc2_: string = "";
        if (this._type == FPackageItemType.FOLDER) {
            if (this._path == "/" && this._branch.length > 0) {
                return Consts.icons.branch;
            }
            if (param1) {
                if (this._id == "/") {
                    return Consts.icons["package_open"];
                }
                return Consts.icons.folder_open;
            }
            if (this._id == "/") {
                return Consts.icons["package"];
            }
            return Consts.icons.folder;
        }
        if (this._type == FPackageItemType.COMPONENT) {
            _loc2_ = Consts.icons[this.componentExtension];
            if (_loc2_) {
                return _loc2_;
            }
            return Consts.icons.component;
        }
        return Consts.icons[this._type];
    }

    public getBranch(): FPackageItem {
        return (<FProject>this._owner.project).getBranch(this);
    }

    public getHighResolution(param1: number): FPackageItem {
        var _loc3_: FPackageItem;
        var _loc2_: string = this._path + this._name;
        while (param1 > 0) {
            _loc3_ = this._owner.getItemByPath(_loc2_ + "@" + (param1 + 1) + "x");
            if (_loc3_ && _loc3_.type == this._type) {
                return _loc3_;
            }
            param1--;
        }
        return this;
    }

    public getAtlasIndex(): number {
        var _loc2_: FPackageItem;
        var _loc1_: string = this._imageSettings.atlas;
        if (_loc1_ == "default") {
            _loc2_ = this.parent;
            while (_loc2_ != this._owner.rootItem) {
                if (!_loc2_.folderSettings.empty && _loc2_.folderSettings.atlas != "default") {
                    _loc1_ = _loc2_.folderSettings.atlas;
                    break;
                }
                _loc2_ = _loc2_.parent;
            }
        }
        switch (_loc1_) {
            case "default":
                return 0;
            case "alone":
                return -1;
            case "alone_npot":
                return -2;
            case "alone_mof":
                return -3;
            default:
                return Number(parseInt(_loc1_));
        }
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

    public toString(): string {
        return this._name;
    }

    public addRef(): void {
        this._ref++;
    }

    public releaseRef(): void {
        // if (this._ref > 0) {
        //     this._ref--;
        // }
        // if (this._ref == 0) {
        //     this._releasedTime = getTimer();
        // }
    }

    public get isDisposed(): boolean {
        return this._disposed;
    }

    private updateData(param1: Object, param2: number): void {
        if (this._data && this._data != param1) {
            this.disposeData();
        }
        this._data = param1;
        this._dataVersion = param2;
    }

    public tryDisposeData(param1: number = 0): boolean {
        if (this._data && this._ref == 0 && (!this._loadQueue || this._loadQueue.length == 0) && (param1 == 0 || param1 - this._releasedTime > 10000)) {
            this.disposeData();
            return true;
        }
        return false;
    }

    public disposeData(): void {
        if (!this._data) {
            return;
        }
        // switch (this._type) {
        //     case FPackageItemType.MOVIECLIP:
        //         AniDef(this._data).reset();
        //         break;
        //     case FPackageItemType.IMAGE:
        //         BitmapData(this._data).dispose();
        //         break;
        //     case FPackageItemType.FONT:
        //         FBitmapFont(this._data).dispose();
        //         break;
        //     case FPackageItemType.COMPONENT:
        //         ComponentData(this._data).dispose();
        //         break;
        //     case FPackageItemType.SOUND:
        //         try {
        //             Sound(this._data).close();
        //         }
        //         catch (err:any) {
        //         }
        // }
        this._data;
    }

    public dispose(): void {
        this.disposeData();
        this._version++;
        this._disposed = true;
    }

    public serialize(param1: boolean = false): XData {
        var _loc2_: XData = XData.create(this._type);
        // if (param1) {
        //     _loc2_.setAttribute("id", this.§_-e§);
        //     _loc2_.setAttribute("name", this._name);
        // }
        // else {
        //     _loc2_.setAttribute("id", this._id);
        //     _loc2_.setAttribute("name", this._fileName);
        // }
        // if (this._branch.length > 0 && this._path.length > 1) {
        //     _loc2_.setAttribute("path", this._path.substr(this._branch.length + 2));
        // }
        // else {
        //     _loc2_.setAttribute("path", this._path);
        // }
        // if (param1) {
        //     _loc2_.setAttribute("size", this.width + "," + this.height);
        // }
        // if (this.exported) {
        //     _loc2_.setAttribute("exported", this.exported);
        // }
        // if (this.favorite && !param1) {
        //     _loc2_.setAttribute("favorite", this.favorite);
        // }
        // if (this._imageSettings) {
        //     this._imageSettings.write(this, _loc2_, param1);
        // }
        // else if (this._fontSettings) {
        //     this._fontSettings.write(this, _loc2_, param1);
        // }
        // else if (this._folderSettings) {
        //     this._folderSettings.write(this, _loc2_, param1);
        // }
        // if (!param1 && this.reviewed) {
        //     _loc2_.setAttribute("reviewed", this.reviewed);
        // }
        return _loc2_;
    }

    private convertImage(): void {
        // var cacheFolder: File ;
        // var file: File ;
        // var info: Object ;
        // try {
        //     cacheFolder = this.owner.cacheFolder;
        //     file = cacheFolder.resolvePath(this._id);
        //     if (file.exists) {
        //         info = UtilsFile.loadJSON(cacheFolder.resolvePath(this._id + ".info"));
        //         if (info) {
        //             if (info.modificationDate == this._modificationTime && info.fileSize == this._fileSize && info.format == this._imageInfo.format && info.quality == this._imageInfo.targetQuality && (info.format != "svg" || info.width == this._imageSettings.width && info.height == this._imageSettings.height)) {
        //                 this._imageInfo.file = file;
        //                 EasyLoader.load(file.url, {
        //                     "type": "image",
        //                     "pi": this,
        //                     "ver": this._version
        //                 }, __imageLoaded);
        //                 return;
        //             }
        //         }
        //         UtilsFile.deleteFile(file);
        //     }
        // }
        // catch (err: Error) {
        //     _owner.project.logError("convertImage", err);
        // }
        // this._vars.converting = true;
        // var vo: ConvertMessage = new ConvertMessage();
        // vo.pkgId = this._owner.id;
        // vo.itemId = this._id;
        // vo.sourceFile = this._file.nativePath;
        // vo.targetFile = file.nativePath;
        // vo.format = this._imageInfo.format;
        // vo.quality = this._imageInfo.targetQuality;
        // vo.width = this._imageSettings.width;
        // vo.height = this._imageSettings.height;
        // vo.version = this._version;
        // this._owner.project.asyncRequest("convert", vo, this.onConverted, this.onConvertFailed);
    }

    private convertSound(): void {
        // var cacheFolder: File ;
        // var file: File ;
        // var info: Object ;
        // try {
        //     cacheFolder = this.owner.cacheFolder;
        //     file = cacheFolder.resolvePath(this._id);
        //     if (file.exists) {
        //         info = UtilsFile.loadJSON(cacheFolder.resolvePath(this._id + ".info"));
        //         if (info) {
        //             if (info.modificationDate == this._modificationTime && info.fileSize == this._fileSize) {
        //                 this.updateData(new Sound(new URLRequest(file.url)), this._version);
        //                 this.invokeLoadedCallbacks();
        //                 return;
        //             }
        //         }
        //     }
        // }
        // catch (err: Error) {
        //     _owner.project.logError("convertSound", err);
        // }
        // this._vars.converting = true;
        // var vo: ConvertMessage = new ConvertMessage();
        // vo.pkgId = this._owner.id;
        // vo.itemId = this._id;
        // vo.sourceFile = this._file.nativePath;
        // vo.targetFile = file.nativePath;
        // vo.format = "sound";
        // vo.version = this._version;
        // this.owner.project.asyncRequest("convert", vo, this.onConverted, this.onConvertFailed);
    }

    // private onConverted(param1: ConvertMessage): void {
    //     if (this._disposed) {
    //         return;
    //     }
    //     this._vars.converting = false;
    //     if (this._type == FPackageItemType.SOUND) {
    //         this._loading = false;
    //         this.updateData(new Sound(new URLRequest(new File(param1.targetFile).url)), param1.version);
    //         this.invokeLoadedCallbacks();
    //     }
    //     else {
    //         this._imageInfo.file = new File(param1.targetFile);
    //         EasyLoader.load(this._imageInfo.file.url, {
    //             "type": "image",
    //             "pi": this,
    //             "ver": param1.version
    //         }, __imageLoaded);
    //     }
    // }

    // private onConvertFailed(param1:string, param2: ConvertMessage): void {
    //     if (this._disposed) {
    //         return;
    //     }
    //     this._vars.converting = false;
    //     this._owner.project.logError("convert-response: " + this._name + "@" + this._owner.name + "(" + param2.itemId + "," + param2.pkgId + ") " + param1);
    //     this._loading = false;
    //     this.invokeLoadedCallbacks();
    // }
}


import ByteArray from "src/utils/ByteArray";
import ProjectType from "../editor/api/ProjectType";
import Consts from "../editor/Consts";
import AtlasSettings from "../editor/settings/AtlasSettings";
import ImageSettings from "../editor/settings/ImageSettings";
import PackSettings from "../utils/pack/PackSettings";
import PublishSettings from "../editor/settings/PublishSettings";
import FPackageItem from "../gui/FPackageItem";
import FPackageItemType from "../gui/FPackageItemType";
import BulkTasks from "../utils/BulkTasks";
import Point from "../utils/Point";
import Rectangle from "../utils/Rectangle";
import Utils from "../utils/Utils";
import UtilsFile from "../utils/UtilsFile";
import UtilsStr from "../utils/UtilsStr";
import PublishStep from "./PublishStep";
import NodeRect from "../utils/pack/NodeRect";
import AniDef from "../gui/animation/AniDef";
import AniTexture from "../gui/animation/AniTexture";
import Page from "../utils/pack/Page";
import AtlasItem from "./AtlasItem";

export default class CreateBins extends PublishStep {


    private _compressTasks: BulkTasks;

    private _packingIndex: number;

    private _additionalAtlasIndex: number;

    private _pages: Array<Page>;

    private _atlasSettings: AtlasSettings;

    public constructor() {
        super();
        this._atlasSettings = new AtlasSettings();
        this._compressTasks = new BulkTasks(1);
    }

    public run(): void {
        super.run();
        if (this.publishData.atlases.length == 0) {
            this.allCompleted();
        }
        else {
            this._packingIndex = 0;
            this.doPack();
        }
    }

    private allCompleted(): void {
        // _stepCallback.callOnSuccessImmediately();
    }

    private packNext(): void {
        this._packingIndex++;
        if (this._packingIndex >= this.publishData.atlases.length) {
            this.allCompleted();
        }
        else {
            this.doPack();
        }
    }

    private doPack(): void {
        var _loc2_: FPackageItem;
        var _loc5_: NodeRect;
        var _loc8_: AniDef;
        var _loc9_: number = 0;
        var _loc10_: AniTexture;
        var _loc11_: Rectangle;
        var _loc1_: AtlasItem = this.publishData.atlases[this._packingIndex];
        if (_loc1_.index == -1) {
            this._atlasSettings.copyFrom((<PublishSettings>this.publishData.pkg.publishSettings).atlasList[0]);
            this._atlasSettings.packSettings.pot = !_loc1_.npot;
            this._atlasSettings.packSettings.mof = _loc1_.mof;
            if (_loc1_.items[0].type == FPackageItemType.MOVIECLIP) {
                this._atlasSettings.packSettings.padding = 1;
                this._atlasSettings.packSettings.duplicatePadding = false;
            }
        } else {
            this._atlasSettings.copyFrom((<PublishSettings>this.publishData.pkg.publishSettings).atlasList[_loc1_.index]);
        }
        var _loc3_: Array<NodeRect> = new Array<NodeRect>();
        var _loc4_: number = 0;
        var _loc6_: Boolean = this._atlasSettings.packSettings.rotation && (this.publishData.project.type == ProjectType.COCOS2DX || this.publishData.project.type == ProjectType.COCOSCREATOR);
        var _loc7_: any = this.publishData.project.type == ProjectType.EGRET;
        // for (_loc2_ in _loc1_.items) {
        //     if (_loc2_.type == FPackageItemType.MOVIECLIP) {
        //         _loc8_ = _loc2_.getAnimation();
        //         if (_loc8_) {
        //             _loc9_ = 0;
        //             for (_loc10_ in _loc8_.textureList) {
        //                 if (_loc10_.exportFrame != _1) {
        //                     _loc11_ = _loc8_.frameList[_loc10_.exportFrame].rect;
        //                     if (_loc11_.width == 0 && _loc11_.height == 0) {
        //                         continue;
        //                     }
        //                     _loc5_ = new NodeRect();
        //                     _loc5_.index = _loc4_;
        //                     _loc5_.subIndex = _loc9_;
        //                     _loc5_.width = _loc11_.width;
        //                     _loc5_.height = _loc11_.height;
        //                     _loc3_.push(_loc5_);
        //                 }
        //                 _loc9_++;
        //             }
        //         }
        //     }else if (_loc2_.width > 0 && _loc2_.height > 0) {
        //         _loc5_ = new NodeRect();
        //         _loc5_.index = _loc4_;
        //         _loc5_.width = _loc2_.imageInfo.trimmedRect.width;
        //         _loc5_.height = _loc2_.imageInfo.trimmedRect.height;
        //         _loc5_.flags = !!_loc2_.imageSettings.duplicatePadding ? int(NodeRect.DUPLICATE_PADDING) : 0;
        //         if (_loc6_ && _loc2_.getVar("pubInfo.isFontLetter") || _loc7_ && _loc2_.imageSettings && _loc2_.imageSettings.scaleOption == ImageSettings.SCALE_9GRID) {
        //             _loc5_.flags = _loc5_.flags | NodeRect.NO_ROTATION;
        //         }
        //         _loc3_.push(_loc5_);
        //     }
        //     _loc4_++;
        // }
        // if (_loc3_.length == 0) {
        //     GTimers.inst.callLater(this.$__JL$, new Array<Page>());
        // }
        // else if (_loc3_.length == 1) {
        //     this.$__PK$(_loc3_[0]);
        // }
        // else {
        //     this.pack(_loc3_);
        // }
    }

    private $__PK$(param1: NodeRect): void {
        var _loc2_: PackSettings = this._atlasSettings.packSettings;
        var _loc3_: Array<Page> = new Array<Page>();
        var _loc4_: number = param1.width;
        var _loc5_: number = param1.height;
        var _loc6_: number = _loc2_.padding;
        if (param1.duplicatePadding) {
            _loc4_ = _loc4_ + _loc6_;
            _loc5_ = _loc5_ + _loc6_;
        }
        if (_loc2_.pot) {
            _loc4_ = Utils.getNextPowerOfTwo(_loc4_);
            _loc5_ = Utils.getNextPowerOfTwo(_loc5_);
        }
        if (_loc2_.square) {
            _loc4_ = _loc5_ = Math.max(_loc4_, _loc5_);
        }
        if (param1.duplicatePadding) {
            if (!_loc2_.pot && !_loc2_.square) {
                _loc4_ = _loc4_ - _loc6_;
                _loc5_ = _loc5_ - _loc6_;
            }
            param1.x = param1.x + Math.floor(_loc6_ / 2);
            param1.y = param1.y + Math.floor(_loc6_ / 2);
        }
        var _loc7_: Page = new Page();
        _loc7_.width = _loc4_;
        _loc7_.height = _loc5_;
        _loc7_.occupancy = 1;
        _loc7_.outputRects.push(param1);
        _loc3_.push(_loc7_);
        // GTimers.inst.callLater(this.$__JL$, _loc3_);
    }

    private $__JL$(param1: Array<Page>): void {
        this._pages = param1;
        // if (param1 == null || param1.length > 1 && !this._atlasSettings.packSettings.multiPage) {
        //     _stepCallback.msgs.length = 0;
        //     _stepCallback.addMsg(UtilsStr.formatString(Consts.strings.text122, this._atlasSettings.packSettings.maxWidth, this._atlasSettings.packSettings.maxHeight));
        //     _stepCallback.callOnFailImmediately();
        //     return;
        // }
        this.createBin();
    }

    private createBin(): void {
        // var pi: FPackageItem = null;
        // var ao: $__4E$ = null;
        // var page: Page = null;
        // var pageIndex: number = 0;
        // var maxQuality: number = 0;
        // var bmd: BitmapData = null;
        // var tmpBmd: BitmapData = null;
        // var binBmd: BitmapData = null;
        // var binIndex: number = 0;
        // var texture: AniTexture = null;
        // var rect: NodeRect = null;
        // var mcPage: Object = null;
        // var mp: any = undefined;
        // var tmp: Number = NaN;
        // var ai: AtlasItem = this.publishData.atlases[this._packingIndex];
        // if (this._pages.length == 0) {
        //     this.packNext();
        //     return;
        // }
        // if (this._pages.length > 1 && this.publishData.project.type == ProjectType.UNITY) {
        //     pageIndex = 0;
        //     mcPage = {};
        //     for (page in this._pages) {
        //         for (rect in page.outputRects) {
        //             pi = ai.items[rect.index];
        //             if (pi.type == FPackageItemType.MOVIECLIP) {
        //                 mp = mcPage[rect.index];
        //                 if (mp == undefined) {
        //                     mcPage[rect.index] = pageIndex;
        //                 }
        //                 else if (mp != pageIndex) {
        //                     _stepCallback.msgs.length = 0;
        //                     _stepCallback.addMsg(UtilsStr.formatString(Consts.strings.text376, pi.name));
        //                     _stepCallback.callOnFailImmediately();
        //                     return;
        //                 }
        //             }
        //         }
        //         pageIndex++;
        //     }
        //     mcPage = null;
        // }
        // var rotateMatrix: Matrix = new Matrix();
        // var extractAlpha: Boolean = ai.alphaChannel && this.publishData.extractAlpha;
        // var rotationDir: number = this.publishData.project.type == ProjectType.COCOS2DX || this.publishData.project.type == ProjectType.COCOSCREATOR || this.publishData.project.type == ProjectType.EGRET ? 1 : 0;
        // if (this.publishData.project.type == ProjectType.UNITY) {
        //     ai.alphaChannel = true;
        // }
        // pageIndex = 0;
        // for (page in this._pages) {
        //     ao = new $__4E$();
        //     this.publishData.$__F8$.push(ao);
        //     binIndex = ai.index;
        //     if (pageIndex == 0) {
        //         binIndex = ai.index;
        //         ao.id = ai.id;
        //         ao.fileName = ai.id + (!!ai.alphaChannel ? ".png" : ".jpg");
        //     }
        //     else {
        //         binIndex = 100 + this._additionalAtlasIndex++;
        //         ao.id = "atlas" + binIndex;
        //         ao.fileName = ai.id + "_" + pageIndex + (!!ai.alphaChannel ? ".png" : ".jpg");
        //     }
        //     ao.width = page.width;
        //     ao.height = page.height;
        //     pageIndex++;
        //     if (page.outputRects.length == 1) {
        //         rect = page.outputRects[0];
        //         pi = ai.items[0];
        //         if (ai.items.length == 1 && pi.type == FPackageItemType.IMAGE && ao.width == pi.width && ao.height == pi.height && (pi.imageInfo.format == "png" || this.publishData.project.type != ProjectType.UNITY) && !extractAlpha) {
        //             if (!this.publishData.exportDescOnly) {
        //                 ao.data = UtilsFile.loadBytes(pi.imageInfo.file);
        //             }
        //             this.$__Ot$(pi.$__e$, ai.index, this._pages[0].outputRects[0], null, null, false);
        //             continue;
        //         }
        //     }
        //     binBmd = new BitmapData(page.width, page.height, true, 0);
        //     for (rect in page.outputRects) {
        //         pi = ai.items[rect.index];
        //         if (pi.type == FPackageItemType.MOVIECLIP) {
        //             texture = pi.getAnimation().textureList[rect.subIndex];
        //             if (texture.bitmapData) {
        //                 if (!this.publishData.exportDescOnly) {
        //                     if (rect.rotated) {
        //                         rotateMatrix.identity();
        //                         if (rotationDir == 0) {
        //                             rotateMatrix.rotate(_90 * Math.PI / 180);
        //                             rotateMatrix.translate(rect.x, rect.y + rect.height);
        //                         }
        //                         else {
        //                             rotateMatrix.rotate(90 * Math.PI / 180);
        //                             rotateMatrix.translate(rect.x + rect.width, rect.y);
        //                         }
        //                         binBmd.draw(texture.bitmapData, rotateMatrix);
        //                     }
        //                     else {
        //                         binBmd.copyPixels(texture.bitmapData, new Rectangle(0, 0, rect.width, rect.height), new Point(rect.x, rect.y));
        //                     }
        //                     if (rect.duplicatePadding) {
        //                         binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y, rect.width, 1), new Point(rect.x, rect.y _1));
        //                         binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y + rect.height _1, rect.width, 1), new Point(rect.x, rect.y + rect.height));
        //                         binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y, 1, rect.height), new Point(rect.x _1, rect.y));
        //                         binBmd.copyPixels(binBmd, new Rectangle(rect.x + rect.width _1, rect.y, 1, rect.height), new Point(rect.x + rect.width, rect.y));
        //                     }
        //                 }
        //                 if (rect.rotated && rotationDir == 1) {
        //                     tmp = rect.width;
        //                     rect.width = rect.height;
        //                     rect.height = tmp;
        //                 }
        //                 this.$__Ot$(pi.$__e$ + "_" + texture.exportFrame, binIndex, rect, null, null, rect.rotated);
        //             }
        //         }
        //         else {
        //             bmd = pi.image;
        //             if (bmd != null) {
        //                 if (!this.publishData.exportDescOnly) {
        //                     if (pi.imageInfo.targetQuality > maxQuality) {
        //                         maxQuality = pi.imageInfo.targetQuality;
        //                     }
        //                     if (rect.rotated) {
        //                         rotateMatrix.identity();
        //                         rotateMatrix.translate(_pi.imageInfo.trimmedRect.x, _pi.imageInfo.trimmedRect.y);
        //                         if (rotationDir == 0) {
        //                             rotateMatrix.rotate(_90 * Math.PI / 180);
        //                             rotateMatrix.translate(rect.x, rect.y + rect.height);
        //                         }
        //                         else {
        //                             rotateMatrix.rotate(90 * Math.PI / 180);
        //                             rotateMatrix.translate(rect.x + rect.width, rect.y);
        //                         }
        //                         binBmd.draw(bmd, rotateMatrix);
        //                     }
        //                     else {
        //                         binBmd.copyPixels(bmd, new Rectangle(pi.imageInfo.trimmedRect.x, pi.imageInfo.trimmedRect.y, rect.width, rect.height), new Point(rect.x, rect.y));
        //                     }
        //                     if (rect.duplicatePadding) {
        //                         binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y, rect.width, 1), new Point(rect.x, rect.y _1));
        //                         binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y + rect.height _1, rect.width, 1), new Point(rect.x, rect.y + rect.height));
        //                         binBmd.copyPixels(binBmd, new Rectangle(rect.x, rect.y, 1, rect.height), new Point(rect.x _1, rect.y));
        //                         binBmd.copyPixels(binBmd, new Rectangle(rect.x + rect.width _1, rect.y, 1, rect.height), new Point(rect.x + rect.width, rect.y));
        //                     }
        //                 }
        //                 if (rect.rotated && rotationDir == 1) {
        //                     tmp = rect.width;
        //                     rect.width = rect.height;
        //                     rect.height = tmp;
        //                 }
        //                 this.$__Ot$(pi.$__e$, binIndex, rect, pi.imageInfo.trimmedRect.topLeft, new Point(pi.width, pi.height), rect.rotated);
        //             }
        //         }
        //     }
        //     if (!this.publishData.exportDescOnly) {
        //         binBmd.threshold(binBmd, binBmd.rect, new Point(0, 0), "<", 50331648, 0, 4278190080, true);
        //         if (extractAlpha) {
        //             tmpBmd = new BitmapData(binBmd.width, binBmd.height, false, 0);
        //             tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
        //             tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
        //             tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);
        //             try {
        //                 ao.$__8I$ = new PNGEncoder().encode(tmpBmd);
        //             }
        //             catch (err: Error) {
        //                 _stepCallback.msgs.length = 0;
        //                 this.publishData.project.editor.consoleView.logError(null, err);
        //                 _stepCallback.addMsg("Create atlas failed");
        //                 _stepCallback.callOnFailImmediately();
        //                 return;
        //             }
        //             tmpBmd.dispose();
        //             tmpBmd = null;
        //         }
        //         if (!ai.alphaChannel || extractAlpha) {
        //             tmpBmd = new BitmapData(binBmd.width, binBmd.height, false, 0);
        //             tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.RED, BitmapDataChannel.RED);
        //             tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
        //             tmpBmd.copyChannel(binBmd, binBmd.rect, new Point(0, 0), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
        //             binBmd.dispose();
        //             binBmd = tmpBmd;
        //             tmpBmd = null;
        //         }
        //         if (ai.alphaChannel) {
        //             if (this._atlasSettings.compression) {
        //                 this._compressTasks.addTask(this.$__C0$, [ao, binBmd]);
        //             }
        //             else {
        //                 try {
        //                     ao.data = new PNGEncoder().encode(binBmd);
        //                 }
        //                 catch (err: Error) {
        //                     _stepCallback.msgs.length = 0;
        //                     this.publishData.project.editor.consoleView.logError(null, err);
        //                     _stepCallback.addMsg("Create atlas failed");
        //                     _stepCallback.callOnFailImmediately();
        //                     return;
        //                 }
        //                 binBmd.dispose();
        //                 binBmd = null;
        //             }
        //         }
        //         else {
        //             if (maxQuality == 0) {
        //                 maxQuality = 80;
        //             }
        //             ao.data = new JPEGEncoder(maxQuality).encode(binBmd);
        //             binBmd.dispose();
        //             binBmd = null;
        //         }
        //     }
        // }
        // if (this._compressTasks.itemCount > 0) {
        //     this._compressTasks.start(this.packNext);
        // }
        // else {
        //     this.packNext();
        // }
    }

    private $__C0$(): void {
        // var ao: $__4E$ = null;
        // var callback: Callback = null;
        // ao = $__4E$(this._compressTasks.taskData[0]);
        // var binBmd: BitmapData = BitmapData(this._compressTasks.taskData[1]);
        // callback = new Callback();
        // callback.success = function (): void {
        //     BitmapData(callback.result[0]).dispose();
        //     ao.data = ByteArray(callback.result[1]);
        //     _compressTasks.finishItem();
        // };
        // callback.failed = function (): void {
        //     _stepCallback.msgs.length = 0;
        //     _stepCallback.addMsgs(callback.msgs);
        //     _compressTasks.clear();
        //     _stepCallback.callOnFailImmediately();
        // };
        // ImageTool.compressBitmapData(binBmd, callback);
    }

    private $__Ot$(param1: string, param2: number, param3: NodeRect, param4: Point, param5: Point, param6: Boolean): void {
        var _loc7_: Array<any>;
        var _loc9_: Array<any>;
        if (this.publishData.trimImage && param4 != null) {
            _loc7_ = [param1, param2, param3.x, param3.y, param3.width, param3.height, !!param6 ? 1 : 0, param4.x, param4.y, param5.x, param5.y];
        }
        else {
            _loc7_ = [param1, param2, param3.x, param3.y, param3.width, param3.height, !!param6 ? 1 : 0];
        }
        this.publishData.$_Fc$.push(_loc7_);
        var _loc8_: FPackageItem = this.publishData.fontTextures[param1];
        if (_loc8_) {
            _loc9_ = _loc7_.concat();
            _loc9_[0] = _loc8_.id;
            this.publishData.$_Fc$.push(_loc9_);
        }
    }

    private pack(param1: Array<NodeRect>): void {
        var _loc2_: NodeRect = null;
        var _loc3_: ByteArray = new ByteArray();
        // _loc3_.shareable = true;
        var _loc4_: number = param1.length;
        _loc3_.writeInt(_loc4_);
        var _loc5_: number = 0;
        while (_loc5_ < _loc4_) {
            _loc2_ = param1[_loc5_];
            _loc3_.writeInt(_loc2_.index);
            _loc3_.writeInt(_loc2_.subIndex);
            _loc3_.writeInt(_loc2_.x);
            _loc3_.writeInt(_loc2_.y);
            _loc3_.writeInt(_loc2_.width);
            _loc3_.writeInt(_loc2_.height);
            _loc3_.writeInt(_loc2_.flags);
            _loc5_++;
        }
        // WorkerClient.inst.setSharedProperty("rects", _loc3_);
        // WorkerClient.inst.setSharedProperty("settings", this._atlasSettings.packSettings);
        this.publishData.project.asyncRequest("pack", null, this.$__A$, this.$__A$);
    }

    private $__A$(): void {
        var _loc3_: Array<Page> = null;
        var _loc4_: number = 0;
        var _loc5_: Page = null;
        var _loc6_: number = 0;
        var _loc7_: number = 0;
        var _loc8_: NodeRect = null;
        if (!this.publishData.project) {
            return;
        }
        // var _loc1_: ByteArray = WorkerClient.inst.getSharedProperty("rects");
        // _loc1_.position = 0;
        // var _loc2_: number = _loc1_.readByte();
        // if (_loc2_ > 0) {
        //     _loc3_ = new Array<Page>();
        //     _loc4_ = 0;
        //     while (_loc4_ < _loc2_) {
        //         _loc5_ = new Page();
        //         _loc5_.width = _loc1_.readInt();
        //         _loc5_.height = _loc1_.readInt();
        //         _loc5_.outputRects = new Array<NodeRect>();
        //         _loc3_.push(_loc5_);
        //         _loc6_ = _loc1_.readInt();
        //         _loc7_ = 0;
        //         while (_loc7_ < _loc6_) {
        //             _loc8_ = new NodeRect();
        //             _loc8_.index = _loc1_.readInt();
        //             _loc8_.subIndex = _loc1_.readInt();
        //             _loc8_.x = _loc1_.readInt();
        //             _loc8_.y = _loc1_.readInt();
        //             _loc8_.width = _loc1_.readInt();
        //             _loc8_.height = _loc1_.readInt();
        //             _loc8_.flags = _loc1_.readInt();
        //             _loc8_.rotated = _loc1_.readByte() == 1;
        //             _loc5_.outputRects.push(_loc8_);
        //             _loc7_++;
        //         }
        //         _loc4_++;
        //     }
        // }
        // _loc1_.clear();
        this.$__JL$(_loc3_);
    }
}
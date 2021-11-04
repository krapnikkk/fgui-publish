import ByteArray from "src/utils/ByteArray";
import FPackageItem from "../gui/FPackageItem";
import FPackageItemType from "../gui/FPackageItemType";
import BulkTasks from "../utils/BulkTasks";
import Rectangle from "../utils/Rectangle";
import UtilsFile from "../utils/UtilsFile";
import UtilsStr from "../utils/UtilsStr";
import PublishStep from "./PublishStep";

export default class CreateOutput extends PublishStep {

    private _loadTasks: BulkTasks;

    public constructor() {
        super();
        this._loadTasks = new BulkTasks(40);
    }

    public run(): void {
        super.run();
        // var pi: FPackageItem = null;
        // var ani: AniDef = null;
        // for (pi in publishData.items) {
        //     if (pi.type == FPackageItemType.MOVIECLIP) {
        //         if (publishData.supportAtlas) {
        //             ani = pi.getAnimation();
        //             if (ani && !ani.ready && !ani.queued) {
        //                 DecodeSupport.inst.add(ani);
        //             }
        //         }
        //     }
        //     else if (pi.type == FPackageItemType.IMAGE && !pi.isError) {
        //         this._loadTasks.addTask(this.loadImage, pi);
        //     }
        // }
        // for (pi in publishData.hitTestImages) {
        //     this._loadTasks.addTask(this.$__LH$, pi);
        // }
        // if (publishData.supportAtlas) {
        //     this._loadTasks.addTask(this.$__Fy$);
        // }
        // this._loadTasks.start(() => {
        //     this.handleHitTestImages();
        //     _stepCallback.callOnSuccessImmediately();
        // });
    }

    private loadImage(): void {
        // var _loc1_: FPackageItem = (<FPackageItem>this._loadTasks.taskData);
        // _loc1_.getImage(this.onLoaded);
    }

    private $__LH$(): void {
        // var _loc1_: FPackageItem = (<FPackageItem>this._loadTasks.taskData);
        // _loc1_.getImage(this.$__5c$);
    }

    private $__Fy$(): void {
        // if (DecodeSupport.inst.busy) {
        //     GTimers.inst.callLater(this.$__Fy$);
        // }
        // else {
        //     this._loadTasks.finishItem();
        // }
    }

    private onLoaded(param1: FPackageItem): void {
        var _loc2_: Rectangle = null;
        // if (publishData.supportAtlas && param1.image) {
        //     if (publishData.trimImage && param1.image.transparent && param1.imageSettings.scaleOption == "none" && !param1.getVar("pubInfo.keepOriginal")) {
        //         _loc2_ = param1.image.getColorBoundsRect(4278190080, 0, false);
        //         param1.imageInfo.trimmedRect.copyFrom(_loc2_);
        //     }
        //     else {
        //         param1.imageInfo.trimmedRect.setTo(0, 0, param1.width, param1.height);
        //     }
        // }
        this._loadTasks.finishItem();
    }

    private $__5c$(param1: FPackageItem): void {
        this._loadTasks.finishItem();
    }

    private handleHitTestImages(): void {
        // var _loc1_: FPackageItem = null;
        // var _loc2_: BitmapData = null;
        // var _loc3_: BitmapData = null;
        // var _loc4_: Matrix = null;
        // var _loc5_: Vector.<uint> = null;
        // var _loc6_: int = 0;
        // var _loc7_: int = 0;
        // var _loc8_: int = 0;
        // var _loc9_: int = 0;
        // for (_loc1_ in publishData.hitTestImages)
        // {
        //     _loc2_ = _loc1_.image;
        //     if (_loc2_) {
        //         _loc3_ = new BitmapData(_loc2_.width / 2, _loc2_.height / 2, true, 0);
        //         _loc4_ = new Matrix();
        //         _loc4_.scale(0.5, 0.5);
        //         _loc3_.draw(_loc2_, _loc4_);
        //         _loc2_ = _loc3_;
        //         _loc5_ = _loc2_.getVector(_loc2_.rect);
        //         _loc6_ = _loc5_.length;
        //          publishData.hitTestData.writeUTF(_loc1_.id);
        //          publishData.hitTestData.writeInt(0);
        //          publishData.hitTestData.writeInt(_loc2_.width);
        //          publishData.hitTestData.writeByte(2);
        //          publishData.hitTestData.writeInt(Math.ceil(_loc6_ / 8));
        //         _loc2_.dispose();
        //         _loc7_ = 0;
        //         _loc8_ = 0;
        //         _loc9_ = 0;
        //         while (_loc9_ < _loc6_) {
        //             if ((_loc5_[_loc9_] >> 24 & 255) > 10) {
        //                 _loc7_ = _loc7_ + (1 << _loc8_);
        //             }
        //             _loc8_++;
        //             if (_loc8_ == 8) {
        //                publishData.hitTestData.writeByte(_loc7_);
        //                 _loc7_ = 0;
        //                 _loc8_ = 0;
        //             }
        //             _loc9_++;
        //         }
        //         if (_loc8_ != 0) {
        //             publishData.hitTestData.writeByte(_loc7_);
        //         }
        //     }
        // }
    }
}

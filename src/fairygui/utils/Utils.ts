import ByteArray from "src/utils/ByteArray";
import Rectangle from "./Rectangle";
import Point from "./Point";

export default class Utils {

    public static RAD_TO_DEG: number = 180 / Math.PI;

    public static DEG_TO_RAD: number = Math.PI / 180;

    private static sHelperByteArray: ByteArray = new ByteArray();

    private static tileIndice: Array<number> = [-1, 0, -1, 2, 4, 3, -1, 1, -1];

    private static helperNumberArray: Array<number> = [];

    public static equalText(param1: any, param2: any):boolean {
        var _loc3_: string;
        var _loc4_: string;
        if (Array.isArray(param1) || Array.isArray(param2))
        {
            return false;
        }
        if (param1 != null) {
            _loc3_ = param1.toString();
        }
        else {
            _loc3_ = "";
        }
        if (param2 != null) {
            _loc4_ = param2.toString();
        }
        else {
            _loc4_ = "";
        }
        return _loc3_ == _loc4_;
    }

    // public static drawDashedRect(param1: Graphics, param2:number, param3:number, param4:number, param5:number, param6:number): void {
    //     drawDashedLine(param1, param2 + 0.5, param3 + 0.5, param2 + param4 - 0.5, param3 + 0.5, param6);
    //     drawDashedLine(param1, param2 + param4 - 0.5, param3 + 0.5, param2 + param4 - 0.5, param3 + param5 - 0.5, param6);
    //     drawDashedLine(param1, param2 + 0.5, param3 + 0.5, param2 + 0.5, param3 + param5 - 0.5, param6);
    //     drawDashedLine(param1, param2 + 0.5, param3 + param5 - 0.5, param2 + param4 - 0.5, param3 + param5 - 0.5, param6);
    // }

    // public static drawDashedLine(param1: Graphics, param2:number, param3:number, param4:number, param5:number, param6:number): void {
    //     var _loc14_:number = NaN;
    //     var _loc15_:number = NaN;
    //     var _loc16_:number = NaN;
    //     var _loc17_:number = NaN;
    //     var _loc7_:number = param4 - param2;
    //     var _loc8_:number = param5 - param3;
    //     var _loc9_:number = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
    //     var _loc10_:number = Math.round((_loc9_ / param6 + 1) / 2);
    //     var _loc11_:number = _loc7_ / (2 * _loc10_ - 1);
    //     var _loc12_:number = _loc8_ / (2 * _loc10_ - 1);
    //     var _loc13_:number = 0;
    //     while (_loc13_ < _loc10_) {
    //         _loc14_ = param2 + 2 * _loc13_ * _loc11_;
    //         _loc15_ = param3 + 2 * _loc13_ * _loc12_;
    //         _loc16_ = _loc14_ + _loc11_;
    //         _loc17_ = _loc15_ + _loc12_;
    //         param1.moveTo(_loc14_, _loc15_);
    //         param1.lineTo(_loc16_, _loc17_);
    //         _loc13_++;
    //     }
    // }

    public static getStringSortKey(param1: string): string {
        var _loc5_: number = 0;
        param1 = param1.toLowerCase();
        Utils.sHelperByteArray.length = 0;
        Utils.sHelperByteArray.writeMultiByte(param1, "gb2312");
        var _loc2_: number = Utils.sHelperByteArray.length;
        Utils.sHelperByteArray.position = 0;
        var _loc3_: string = "";
        var _loc4_: number = 0;
        // while (_loc4_ < _loc2_) {
        //     _loc5_ = Utils.sHelperByteArray[_loc4_];
        //     _loc3_ = _loc3_ + String.fromCharCode(_loc5_);
        //     _loc4_++;
        // }
        return _loc3_;
    }

    // public static scaleBitmapWith9Grid(param1: BitmapData, param2: Rectangle, param3:number, param4:number, param5:boolean = false, param6:number = 0): BitmapData {
    //     var _loc10_: Array;
    //     var _loc11_: Array;
    //     var _loc12_: Rectangle;
    //     var _loc13_: Rectangle;
    //     var _loc16_:number;
    //     var _loc17_:number = 0;
    //     var _loc18_:number = 0;
    //     var _loc19_: BitmapData;
    //     if (param3 == 0 || param4 == 0) {
    //         return new BitmapData(1, 1, param1.transparent, 0);
    //     }
    //     var _loc7_: BitmapData = new BitmapData(param3, param4, param1.transparent, 0);
    //     var _loc8_: Array = [0, param2.top, param2.bottom, param1.height];
    //     var _loc9_: Array = [0, param2.left, param2.right, param1.width];
    //     if (param4 >= param1.height - param2.height) {
    //         _loc10_ = [0, param2.top, param4 - (param1.height - param2.bottom), param4];
    //     }
    //     else {
    //         _loc16_ = param2.top / (param1.height - param2.bottom);
    //         _loc16_ = param4 * _loc16_ / (1 + _loc16_);
    //         _loc10_ = [0, _loc16_, _loc16_, param4];
    //     }
    //     if (param3 >= param1.width - param2.width) {
    //         _loc11_ = [0, param2.left, param3 - (param1.width - param2.right), param3];
    //     }
    //     else {
    //         _loc16_ = param2.left / (param1.width - param2.right);
    //         _loc16_ = param3 * _loc16_ / (1 + _loc16_);
    //         _loc11_ = [0, _loc16_, _loc16_, param3];
    //     }
    //     var _loc14_: Matrix = new Matrix();
    //     var _loc15_:number = 0;
    //     while (_loc15_ < 3) {
    //         _loc17_ = 0;
    //         while (_loc17_ < 3) {
    //             _loc12_ = new Rectangle(_loc9_[_loc15_], _loc8_[_loc17_], _loc9_[_loc15_ + 1] - _loc9_[_loc15_], _loc8_[_loc17_ + 1] - _loc8_[_loc17_]);
    //             _loc13_ = new Rectangle(_loc11_[_loc15_], _loc10_[_loc17_], _loc11_[_loc15_ + 1] - _loc11_[_loc15_], _loc10_[_loc17_ + 1] - _loc10_[_loc17_]);
    //             _loc18_ = tileIndice[_loc17_ * 3 + _loc15_];
    //             if (_loc18_ != -1 && (param6 & 1 << _loc18_) != 0) {
    //                 _loc19_ = Utils.tileBitmap(param1, _loc12_, _loc13_.width, _loc13_.height, param5);
    //                 _loc7_.copyPixels(_loc19_, _loc19_.rect, _loc13_.topLeft);
    //                 _loc19_.dispose();
    //             }
    //             else {
    //                 _loc14_.identity();
    //                 _loc14_.a = _loc13_.width / _loc12_.width;
    //                 _loc14_.d = _loc13_.height / _loc12_.height;
    //                 _loc14_.tx = _loc13_.x - _loc12_.x * _loc14_.a;
    //                 _loc14_.ty = _loc13_.y - _loc12_.y * _loc14_.d;
    //                 _loc7_.draw(param1, _loc14_, null, null, _loc13_, param5);
    //             }
    //             _loc17_++;
    //         }
    //         _loc15_++;
    //     }
    //     return _loc7_;
    // }

    // public static tileBitmap(param1: BitmapData, param2: Rectangle, param3:number, param4:number, param5:boolean = false): BitmapData {
    //     var _loc11_:number = 0;
    //     if (param3 == 0 || param4 == 0) {
    //         return new BitmapData(1, 1, param1.transparent, 0);
    //     }
    //     var _loc6_: BitmapData = new BitmapData(param3, param4, param1.transparent, 0);
    //     var _loc7_:number = Math.ceil(param3 / param2.width);
    //     var _loc8_:number = Math.ceil(param4 / param2.height);
    //     var _loc9_: Point = new Point();
    //     var _loc10_:number = 0;
    //     while (_loc10_ < _loc7_) {
    //         _loc11_ = 0;
    //         while (_loc11_ < _loc8_) {
    //             _loc9_.x = _loc10_ * param2.width;
    //             _loc9_.y = _loc11_ * param2.height;
    //             _loc6_.copyPixels(param1, param2, _loc9_);
    //             _loc11_++;
    //         }
    //         _loc10_++;
    //     }
    //     return _loc6_;
    // }

    // public static skew(param1: Matrix, param2:number, param3:number): void {
    //     param2 = param2 * Utils.DEG_TO_RAD;
    //     param3 = param3 * Utils.DEG_TO_RAD;
    //     var _loc4_:number = Math.sin(param2);
    //     var _loc5_:number = Math.cos(param2);
    //     var _loc6_:number = Math.sin(param3);
    //     var _loc7_:number = Math.cos(param3);
    //     param1.setTo(param1.a * _loc7_ - param1.b * _loc4_, param1.a * _loc6_ + param1.b * _loc5_, param1.c * _loc7_ - param1.d * _loc4_, param1.c * _loc6_ + param1.d * _loc5_, param1.tx * _loc7_ - param1.ty * _loc4_, param1.tx * _loc6_ + param1.ty * _loc5_);
    // }

    // public static prependSkew(param1: Matrix, param2:number, param3:number): void {
    //     param2 = param2 * Utils.DEG_TO_RAD;
    //     param3 = param3 * Utils.DEG_TO_RAD;
    //     var _loc4_:number = Math.sin(param2);
    //     var _loc5_:number = Math.cos(param2);
    //     var _loc6_:number = Math.sin(param3);
    //     var _loc7_:number = Math.cos(param3);
    //     param1.setTo(param1.a * _loc7_ + param1.c * _loc6_, param1.b * _loc7_ + param1.d * _loc6_, param1.c * _loc5_ - param1.a * _loc4_, param1.d * _loc5_ - param1.b * _loc4_, param1.tx, param1.ty);
    // }

    public static genDevCode(): string {
        var _loc3_: number = 0;
        var _loc1_: number = 0;
        var _loc2_: number = 0;
        while (_loc2_ < 4) {
            _loc3_ = Math.random() * 26;
            _loc1_ = _loc1_ + Math.pow(26, _loc2_) * (_loc3_ + 10);
            _loc2_++;
        }
        _loc1_ = _loc1_ + (Number(Math.random() * 1000000) + Number(Math.random() * 222640));
        return _loc1_.toString(36);
    }

    public static getBoundsRect(param1: Array<Point>, param2: Rectangle): Rectangle {
        if (!param2) {
            param2 = new Rectangle();
        }
        Utils.helperNumberArray[0] = Utils.helperNumberArray[2] = Number.MAX_VALUE;
        Utils.helperNumberArray[1] = Utils.helperNumberArray[3] = Number.MIN_VALUE;
        var _loc3_: number = 0;
        while (_loc3_ < param1.length) {
            Utils._getBoundsRect(param1[_loc3_]);
            _loc3_++;
        }
        // param2.setTo(Utils.helperNumberArray[0], Utils.helperNumberArray[2], Utils.helperNumberArray[1] - Utils.helperNumberArray[0], Utils.helperNumberArray[3] - Utils.helperNumberArray[2]);
        return param2;
    }

    private static _getBoundsRect(param1: Point): void {
        if (param1.x < Utils.helperNumberArray[0]) {
            Utils.helperNumberArray[0] = param1.x;
        }
        if (param1.x > Utils.helperNumberArray[1]) {
            Utils.helperNumberArray[1] = param1.x;
        }
        if (param1.y < Utils.helperNumberArray[2]) {
            Utils.helperNumberArray[2] = param1.y;
        }
        if (param1.y > Utils.helperNumberArray[3]) {
            Utils.helperNumberArray[3] = param1.y;
        }
    }

    public static clamp(param1: number, param2: number, param3: number): number {
        if (param1 < param2) {
            param1 = param2;
        }
        else if (param1 > param3) {
            param1 = param3;
        }
        return param1;
    }

    public static clamp01(param1: number): number {
        if (param1 > 1) {
            param1 = 1;
        }
        else if (param1 < 0) {
            param1 = 0;
        }
        return param1;
    }

    public static getNextPowerOfTwo(param1: number): number {
        var _loc2_: any = 0;
        if (param1 > 0 && (param1 & param1 - 1) == 0) {
            return param1;
        }
        _loc2_ = 1;
        param1 = param1 - 1.0e-9;
        while (_loc2_ < param1) {
            _loc2_ = _loc2_ << 1;
        }
        return _loc2_;
    }

    public static transformColor(param1: number, param2: number, param3: number, param4: number): number {
        return (Number(((param1 & 16711680) >> 16) * param2) << 16) + (Number(((param1 & 65280) >> 8) * param3) << 8) + Number((param1 & 255) * param4);
    }
}


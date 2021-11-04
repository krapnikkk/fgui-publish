export default class NodeRect {

    public static DUPLICATE_PADDING: number = 1;

    public static NO_ROTATION: number = 2;


    public x: number;

    public y: number;

    public width: number;

    public height: number;

    public rotated: Boolean;

    public index: number;

    public subIndex: number;

    public flags: number;

    public score1: number;

    public score2: number;

    public constructor(param1: number = 0, param2: number = 0, param3: number = 0, param4: number = 0) {
        this.x = param1;
        this.y = param2;
        this.width = param3;
        this.height = param4;
        this.subIndex = -1;
    }

    public copyFrom(param1: NodeRect): void {
        this.index = param1.index;
        this.subIndex = param1.subIndex;
        this.x = param1.x;
        this.y = param1.y;
        this.width = param1.width;
        this.height = param1.height;
        this.rotated = param1.rotated;
        this.score1 = param1.score1;
        this.score2 = param1.score2;
        this.flags = param1.flags;
    }

    public clone(): NodeRect {
        var _loc1_: NodeRect = new NodeRect();
        _loc1_.index = this.index;
        _loc1_.subIndex = this.subIndex;
        _loc1_.x = this.x;
        _loc1_.y = this.y;
        _loc1_.width = this.width;
        _loc1_.height = this.height;
        _loc1_.rotated = this.rotated;
        _loc1_.score1 = this.score1;
        _loc1_.score2 = this.score2;
        _loc1_.flags = this.flags;
        return _loc1_;
    }

    public get duplicatePadding(): Boolean {
        return (this.flags & NodeRect.DUPLICATE_PADDING) != 0;
    }

    public get allowRotation(): Boolean {
        return (this.flags & NodeRect.NO_ROTATION) == 0;
    }
}

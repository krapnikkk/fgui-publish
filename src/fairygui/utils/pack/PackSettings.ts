export default class PackSettings {


    private _pot:boolean;

    private _mof:boolean;

    private _padding: number;

    private _rotation:boolean;

    private _minWidth: number;

    private _minHeight: number;

    private _maxWidth: number;

    private _maxHeight: number;

    private _square:boolean;

    private _fast:boolean;

    private _edgePadding:boolean;

    private _duplicatePadding:boolean;

    private _multiPage:boolean;

    public constructor() {
        this._pot = true;
        this._mof = true;
        this._padding = 2;
        this._rotation = false;
        this._minWidth = 16;
        this._minHeight = 16;
        this._maxWidth = 2048;
        this._maxHeight = 2048;
        this._square = false;
        this._fast = true;
        this._edgePadding = false;
        this._duplicatePadding = false;
        this._multiPage = false;
    }

    public get pot():boolean {
        return this._pot;
    }

    public set pot(param1:boolean) {
        this._pot = param1;
    }

    public get mof():boolean {
        return this._mof;
    }

    public set mof(param1:boolean) {
        this._mof = param1;
    }

    public get padding(): number {
        return this._padding;
    }

    public set padding(param1: number) {
        this._padding = param1;
    }

    public get rotation():boolean {
        return this._rotation;
    }

    public set rotation(param1:boolean) {
        this._rotation = param1;
    }

    public get minWidth(): number {
        return this._minWidth;
    }

    public set minWidth(param1: number) {
        this._minWidth = param1;
    }

    public get minHeight(): number {
        return this._minHeight;
    }

    public set minHeight(param1: number) {
        this._minHeight = param1;
    }

    public get maxWidth(): number {
        return this._maxWidth;
    }

    public set maxWidth(param1: number) {
        this._maxWidth = param1;
    }

    public get maxHeight(): number {
        return this._maxHeight;
    }

    public set maxHeight(param1: number) {
        this._maxHeight = param1;
    }

    public get square():boolean {
        return this._square;
    }

    public set square(param1:boolean) {
        this._square = param1;
    }

    public get fast():boolean {
        return this._fast;
    }

    public set fast(param1:boolean) {
        this._fast = param1;
    }

    public get edgePadding():boolean {
        return this._edgePadding;
    }

    public set edgePadding(param1:boolean) {
        this._edgePadding = param1;
    }

    public get duplicatePadding():boolean {
        return this._duplicatePadding;
    }

    public set duplicatePadding(param1:boolean) {
        this._duplicatePadding = param1;
    }

    public get multiPage():boolean {
        return this._multiPage;
    }

    public set multiPage(param1:boolean) {
        this._multiPage = param1;
    }

    public copyFrom(packSettings: PackSettings): void {
        this._pot = packSettings.pot;
        this._padding = packSettings.padding;
        this._rotation = packSettings.rotation;
        this._minWidth = packSettings.minWidth;
        this._minHeight = packSettings.minHeight;
        this._maxWidth = packSettings.maxWidth;
        this._maxHeight = packSettings.maxHeight;
        this._square = packSettings.square;
        this._fast = packSettings.fast;
        this._edgePadding = packSettings.edgePadding;
        this._duplicatePadding = packSettings.duplicatePadding;
        this._multiPage = packSettings.multiPage;
    }
}


import XData from "./XData";

export default class XDataEnumerator {
    private _owner: XData;

    private _selector:string;

    private _index:number;

    private _total:number;

    private _current: XData;

    public constructor(owner: XData, selector:string) {
        this._owner = owner;
        this._selector = selector;
        this._index = -1;
        this._total = this._owner.getChildren().length;
    }

    public get current(): XData {
        return this._current;
    }

    public get index():number {
        return this._index;
    }

    public moveNext():boolean {
        while (true) {
            if (++this._index >= this._total) {
                break;
            }
            this._current = this._owner.getChildren()[this._index];
            if (this._selector == null || this._current.getName() == this._selector) {
                return true;
            }
        }
        this._current = null;
        return false;
    }

    public erase(): void {
        if (this._current) {
            this._owner.removeChildAt(this._index);
            this._index--;
            this._total--;
            this._current = null;
        }
    }

    public reset(): void {
        this._index = -1;
    }
}


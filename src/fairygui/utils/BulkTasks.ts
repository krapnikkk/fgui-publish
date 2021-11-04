
export default class BulkTasks {


    private _numConcurrent:number;

    private _items: Array<Function>;

    private _itemDatas: Array<Object>;

    private _runningCount:number;

    private _running: Boolean;

    private _onCompleted: Function;

    private _errorMsgs: Array<String>;

    private _itemData: Object;

    public constructor(param1:number = 2) {
        this._numConcurrent = param1;
        this._items = new Array<Function>();
        this._itemDatas = new Array<Object>();
        this._errorMsgs = new Array<String>();
    }

    public addTask(param1: Function, param2: Object = null): void {
        this._items.push(param1);
        this._itemDatas.push(param2);
    }

    public getRemainingTasks(): Array<Object> {
        return this._itemDatas.concat();
    }

    public get itemCount():number {
        return this._items.length;
    }

    public get taskData(): Object {
        return this._itemData;
    }

    public clear(): void {
        this._items.length = 0;
        this._errorMsgs.length = 0;
        this._runningCount = 0;
        this._running = false;
        this._onCompleted = null;
        this._itemData = null;
        this._itemDatas.length = 0;
        // GTimers.inst.remove(this.run);
    }

    public start(param1: Function): void {
        this._onCompleted = param1;
        this._running = true;
        // GTimers.inst.add(50, 0, this.run);
    }

    public addErrorMsg(param1: String): void {
        if (param1) {
            this._errorMsgs.push(param1);
        }
    }

    public addErrorMsgs(param1: Array<String>): void {
        if (param1.length > 0) {
            this._errorMsgs = this._errorMsgs.concat(param1);
        }
    }

    public get errorMsgs(): Array<String> {
        return this._errorMsgs;
    }

    public finishItem(): void {
        this._runningCount--;
    }

    public get running(): Boolean {
        return this._running;
    }

    private run(): void {
        var _loc1_: Function = null;
        while (this._runningCount < this._numConcurrent && this._items.length > 0) {
            _loc1_ = this._items.pop();
            this._itemData = this._itemDatas.pop();
            this._runningCount++;
            if (_loc1_.length == 1) {
                _loc1_(this);
            }
            else {
                _loc1_();
            }
        }
        if (this._runningCount == 0) {
            this._running = false;
            // GTimers.inst.remove(this.run);
            _loc1_ = this._onCompleted;
            this._onCompleted = null;
            if (_loc1_ != null) {
                if (_loc1_.length == 1) {
                    _loc1_(this);
                }
                else {
                    _loc1_();
                }
            }
        }
    }
}


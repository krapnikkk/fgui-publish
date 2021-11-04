import AtlasSettings from "./AtlasSettings";

export default class PublishSettings {


    private _path: string;

    private _fileName: string;

    private _packageCount: number;

    private _genCode:boolean;

    private _codePath: string;

    //   private §_-LC§:string; // todo
      private _branchPath:string;

    public useGlobalAtlasSettings:boolean;

    private _atlasList: Array<AtlasSettings>;

    private _excludedList: Array<String>;

    public constructor() {
        this._atlasList = [];
        this._excludedList = [];
    }

    public get fileName(): string {
        return this._fileName;
    }

    public set fileName(param1: string) {
        this._fileName = param1;
    }

    public get path(): string {
        return this._path;
    }

    public set path(param1: string) {
        this._path = param1;
    }

      public get branchPath() :string
      {
         return this._branchPath;
      }

      public set branchPath(branch:string)
      {
         this._branchPath = branch;
      }

    public get packageCount(): number {
        return this._packageCount;
    }

    public set packageCount(param1: number) {
        this._packageCount = param1;
    }

    public get genCode():boolean {
        return this._genCode;
    }

    public set genCode(param1:boolean) {
        this._genCode = param1;
    }

    public get codePath(): string {
        return this._codePath;
    }

    public set codePath(param1: string) {
        this._codePath = param1;
    }

    public get excludedList(): Array<String> {
        return this._excludedList;
    }

    public get atlasList(): Array<AtlasSettings> {
        return this._atlasList;
    }

    //   public fillCombo(param1:GComboBox) : void
    //   {
    //  var _loc2_:Array = param1.items;
    //  var _loc3_:Array = param1.values;
    //  _loc2_.length = 0;
    //  _loc3_.length = 0;
    //  _loc2_.push(Consts.strings.text80,Consts.strings.text81,Consts.strings.text81 + "(NPOT)",Consts.strings.text81 + "(" + Consts.strings.text439 + ")");
    //  _loc3_.push("default","alone","alone_npot","alone_mof");
    //  var _loc4_:number = 0;
    //  while(_loc4_ < this._atlasList.length)
    //  {
    //     if(this._atlasList[_loc4_].name)
    //     {
    //        _loc2_.push(_loc4_ + ": " + this._atlasList[_loc4_].name);
    //     }
    //     else
    //     {
    //        _loc2_.push("" + _loc4_);
    //     }
    //     _loc3_.push("" + _loc4_);
    //     _loc4_++;
    //  }
    //  param1.items = _loc2_;
    //  param1.values = _loc3_;
    //  param1.visibleItemCount = 20;
    //   }
}


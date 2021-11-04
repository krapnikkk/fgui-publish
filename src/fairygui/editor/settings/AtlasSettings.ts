import PackSettings from "../../utils/pack/PackSettings";

export default class AtlasSettings {

    private _name:string;

    private _compression:boolean;

    private _extractAlpha:boolean;

    private _packSettings: PackSettings;

    public constructor() {
        this._packSettings = new PackSettings();
    }

    public get name():string {
        return this._name;
    }

    public set name(param1:string) {
        this._name = param1;
    }

    public get compression():boolean {
        return this._compression;
    }

    public set compression(param1:boolean) {
        this._compression = param1;
    }

    public get extractAlpha():boolean {
        return this._extractAlpha;
    }

    public set extractAlpha(param1:boolean) {
        this._extractAlpha = param1;
    }

    public get packSettings(): PackSettings {
        return this._packSettings;
    }

    public copyFrom(param1: AtlasSettings): void {
        this._name = param1.name;
        this._compression = param1.compression;
        this._extractAlpha = param1.extractAlpha;
        this._packSettings.copyFrom(param1.packSettings);
    }
}


import IUIProject from "../api/IUIProject";
import SettingsBase from "./SettingsBase";

export default class PackageGroupSettings extends SettingsBase {


    private _groups: Array<any>;

    public constructor(project: IUIProject) {
        super(project);
        this._fileName = "PackageGroup";
    }

    public get groups(): Array<any> {
        return this._groups;
    }

    protected read(groups: Object): void {
        super.read(groups);
        if (Array.isArray(groups)) {
            this._groups = groups as Array<any>;
        }
        else {
            this._groups = [];
        }
    }

    protected write(): Object {
        super.write();
        return this._groups;
    }
}


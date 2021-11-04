import IUIProject from "../api/IUIProject";
import fs from "fs";
export default class SettingsBase {


    protected _project: IUIProject;

    protected _fileName:string;

    private _file: File;

    private _lastModified: number;

    public constructor(project: IUIProject) {
        this._project = project;
        this._lastModified = 0;
    }

    public touch(param1:boolean = false): void {
        let file = fs.readFileSync(this._project.settingsPath + "/" + this._fileName + ".json").toString();
        let data = JSON.parse(file);
        this.read(data);
        // if (!this._file) {
        //     this._file = new File(this._project.settingsPath + "/" + this._fileName + ".json");
        //     if (this._file.exists) {
        //         this.read(this.loadFile());
        //     }
        //     else {
        //         this.read({});
        //     }
        // }
        // else if (this._file.exists) {
        //     if (param1 || this._file.modificationDate.time != this._lastModified) {
        //         this.read(this.loadFile());
        //     }
        // }
    }

    public save(): void {
        // this.saveFile(this.write());
    }

    protected read(file:{[key:string]:any}): void {

    }

    protected write():{[key:string]:any} | null {
        return null;
    }

    protected saveFile(param1:{[key:string]:any}): void {
        // UtilsFile.saveJSON(this._file, param1, true);
        // this._lastModified = this._file.modificationDate.time;
    }

    protected loadFile():{[key:string]:any} {
        var data:{[key:string]:any} ;
        // try {
        //     data = UtilsFile.loadJSON(this._file);
        //     this._lastModified = this._file.modificationDate.time;
        // }
        // catch (err: Error) {
        //     _project.logError(_fileName + ".json is corrupted!", err);
        // }
        // if (!data) {
        //     data = {};
        // }
        return data;
    }
}


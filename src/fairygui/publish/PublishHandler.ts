import IUIPackage from "../editor/api/IUIPackage";
import ProjectType from "../editor/api/ProjectType";
import Consts from "../editor/Consts";
import CustomProps from "../editor/settings/CustomProps";
import { GlobalPublishSettings } from "../editor/settings/GlobalPublishSettings";
import PublishSettings from "../editor/settings/PublishSettings";
import FPackage from "../gui/FPackage";
import FPackageItem from "../gui/FPackageItem";
import FProject from "../gui/FProject";
import UtilsStr from "../utils/UtilsStr";
import CollectItems from "./CollectItems";
import CreateBins from "./CreateBins";
import CreateOutput from "./CreateOutput";
import PublishData from "./PublishData";
import PublishStep from "./PublishStep";

export default class PublishHandler {


    //   private _data:$__4Z$;
    private _data: PublishData;

    private _Callback: Function;

    //   private $__B3$:PublishStep; // PublishStep
    private _currentStep: PublishStep; // PublishStep

    private _stepCallback: Function;


    public publish(pkg: IUIPackage, branch?: string, targetPath?: string, exportDescOnly?: boolean, callback?: Function): void {
        //  var editor:IEditor = null;
        var path: string;
        var targetFolder: File;
        var targetFile: File;
        var branchPath: string;
        //  editor = IEditor(pkg.project.editor);
        var settings: PublishSettings = pkg.publishSettings as PublishSettings;
        var gsettings: GlobalPublishSettings = pkg.project.getSettings("publish") as GlobalPublishSettings;
        //  if(!settings.path && !gsettings.path && !targetPath)
        //  {
        //    .addMsg(UtilsStr.formatString(Consts.strings.text100,pkg.name));
        //    .callOnFail();
        //     return;
        //  }
        debugger;
        // if (!settings.fileName) {
        //     settings.fileName = pkg.name;
        // }
        // console.log(settings,gsettings);
        //  this._Callback =;
        this._data = new PublishData();
        this._data.pkg = pkg as FPackage;
        this._data.project = pkg.project as FProject;
        this._data.branch = branch;
        var customProps: Object = (<CustomProps>pkg.project.getSettings("customProps")).all;
        // try {
        //     if (targetPath) {
        //         path = targetPath;
        //     }
        //     else if (settings.path) {
        //         path = settings.path;
        //     }
        //     else {
        //         path = gsettings.path;
        //     }
        //     if (gsettings.branchProcessing != 0 && branch) {
        //         if (settings.branchPath) {
        //             branchPath = settings.branchPath;
        //         }
        //         else {
        //             branchPath = gsettings.branchPath;
        //         }
        //         if (branchPath.length > 0) {
        //             path = branchPath;
        //         }
        //         path = path + ("/" + branch);
        //     }
        //     if (path.indexOf("{") != -1) {
        //         path = UtilsStr.formatStringByName(path, { "publish_file_name": settings.fileName });
        //         path = UtilsStr.formatStringByName(path, customProps);
        //     }
        //     targetFolder = new File(pkg.project.basePath).resolvePath(path);
        //     targetFile = targetFolder.resolvePath(settings.fileName);
        //     targetFolder = targetFile.parent;
        //     if (!targetFolder.exists) {
        //         targetFolder.createDirectory();
        //     }
        //     else if (!targetFolder.isDirectory) {
        //         this._Callback.addMsg(Consts.strings.text327);
        //         this._Callback.callOnFail();
        //         return;
        //     }
        //     this._data.path = targetFolder.nativePath;
        // }
        // catch (err: Error) {
        //     editor.consoleView.logError(null, err);
        //     _Callback.addMsg(Consts.strings.text327);
        //     _Callback.callOnFail();
        //     return;
        // }
        // var ext: string = targetFile.extension;
        // this._data.fileName = UtilsStr.getFileName(targetFile.name);
        // if (this._data.project.supportCustomFileExtension && ext) {
        //     this._data.fileExtension = ext;
        // }
        // else {
        //     this._data.fileExtension = gsettings.fileExtension;
        // }
        this._data.exportDescOnly = exportDescOnly;
        this._data.singlePackage = settings.packageCount == 1 || settings.packageCount == 0 && gsettings.packageCount == 1; // todo
        console.log(pkg.project.type);
        if (pkg.project.type == ProjectType.FLASH || pkg.project.type == ProjectType.STARLING || pkg.project.type == ProjectType.HAXE) {
            if (this._data.singlePackage) {
                this._data.exportDescOnly = false;
            }
        }
        this._data.extractAlpha = this._data.project.supportExtractAlpha && settings.atlasList[0].extractAlpha;
        this._data.supportAtlas = this._data.project.supportAtlas;
        // 暂不考虑代码生成
        // this._data.genCode = gsettings.allowGenCode && settings.genCode;
        // if (this._data.genCode) {
        //     if (settings.codePath) {
        //         this._data.codePath = settings.codePath;
        //     }
        //     else {
        //         this._data.codePath = gsettings.codePath;
        //     }
        //     if (this._data.codePath) {
        //         this._data.codePath = UtilsStr.formatStringByName(this._data.codePath, customProps);
        //         this._data.codePath = new File(pkg.project.basePath).resolvePath(this._data.codePath).nativePath;
        //     }
        // }
        this._data.includeHighResolution = gsettings.includeHighResolution;
        this._data.trimImage = gsettings.atlasTrimImage;
        this._data.includeBranches = gsettings.branchProcessing == 0;
        if (this._data.includeBranches) {
            this._data.allBranches = this._data.project.allBranches.length;
        }
        else if (branch) {
            this._data.allBranches = 1;
        }
        else {
            this._data.allBranches = 0;
        }
        // if (!this._data.includeBranches && branch) {
        //     editor.consoleView.log("Publish start: " + pkg.name + "(" + branch + ")");
        // }
        // else {
        //     editor.consoleView.log("Publish start: " + pkg.name);
        // }
        // this._stepCallback = new Function();
        // this._stepCallback.failed = this.handleCallbackErrors;
        // this.runStep(new $__FQ$(), this.$__95$);
        this.runStep(new CollectItems(), this.handleImages);
    }

    private handleImages(): void {
        this.runStep(new CreateOutput(), !!this._data.supportAtlas ? this.createBin : this.createOutput);
    }

    private createBin(): void {
        this.runStep(new CreateBins(), this.createOutput);
    }

    private createOutput(): void {
        // this.runStep(new $__NR$(), this.$__D2$);
    }

    private $__D2$(): void {
        // this.runStep(new $__6y$(), !!this._data.genCode ? this.generateCode : this.export);
    }

    private generateCode(): void {
        var _loc2_: PublishStep = null;
        var _loc1_: GlobalPublishSettings = (<GlobalPublishSettings>this._data.project.getSettings("publish"));
        // if (!this._data.codePath) {
        //     this._data.project.editor.consoleView.logWarning(UtilsStr.formatString(Consts.strings.text273, this._data.pkg.name));
        //     this.export();
        //     return;
        // }
        var _loc3_: string = _loc1_.codeType;
        // switch (this._data.project.type) {
        //     case ProjectType.FLASH:
        //         _loc2_ = new TplAS3Generator();
        //         break;
        //     case ProjectType.STARLING:
        //         _loc2_ = new TplStarlingGenerator();
        //         break;
        //     case ProjectType.LAYABOX:
        //         if (_loc3_ == "TS") {
        //             _loc2_ = new TplLayaTSGenerator();
        //         }
        //         else if (_loc3_ == "TS-2" || _loc3_ == "TS-2.0") {
        //             _loc2_ = new TplLaya2TSGenerator();
        //         }
        //         else {
        //             _loc2_ = new TplLayaGenerator();
        //         }
        //         break;
        //     case ProjectType.EGRET:
        //         _loc2_ = new TplEgretGenerator();
        //         break;
        //     case ProjectType.PIXI:
        //         _loc2_ = new TplPixiGenerator();
        //         break;
        //     case ProjectType.UNITY:
        //     case ProjectType.CRY:
        //     case ProjectType.MONOGAME:
        //         _loc2_ = new TplUnityGenerator();
        //         break;
        //     case ProjectType.HAXE:
        //         _loc2_ = new TplHaxeGenerator();
        //         break;
        //     case ProjectType.COCOS2DX:
        //     case ProjectType.VISION:
        //         _loc2_ = new TplCocos2dxGenerator();
        //         break;
        //     case ProjectType.COCOSCREATOR:
        //         _loc2_ = new TplCocosCreatorGenerator();
        // }
        if (_loc2_) {
            this.runStep(_loc2_, this.export);
        }
        else {
            // if (this._data.project.type != ProjectType.CORONA) {
            //     this._Callback.addMsg("unkown code type");
            // }
            // this.export();
        }
    }

    private export(): void {
        var _loc1_: PublishStep = null;
        if (this._data.defaultPrevented) {
            this.publishCompleted();
            return;
        }
        // switch (this._data.project.type) {
        //     case ProjectType.HAXE:
        //     case ProjectType.FLASH:
        //     case ProjectType.STARLING:
        //         _loc1_ = new FlashExporter();
        //         break;
        //     case ProjectType.EGRET:
        //     case ProjectType.LAYABOX:
        //     case ProjectType.PIXI:
        //         _loc1_ = new LayaExporter();
        //         break;
        //     case ProjectType.UNITY:
        //         _loc1_ = new UnityExporter();
        //         break;
        //     default:
        //         _loc1_ = new GeneralExporter();
        // }
        this.runStep(_loc1_, this.publishCompleted);
    }

    private runStep(param1: PublishStep, param2: Function): void {
        var step: any = param1;
        var next: Function = param2;
        this._currentStep = step;
        // try {
            // this._stepCallback.success = next;
            this._currentStep.publishData = this._data;
            // this._currentStep._stepCallback = this._stepCallback;
            // this._Callback.addMsgs(this._stepCallback.msgs);
            // this._stepCallback.msgs.length = 0;
            this._currentStep.run();
            return;
        // }catch (err: Error) {
        //     this.handleException(err);
        //     return;
        // }
    }

    private publishCompleted(): void {
        // var _loc1_: any = "[url=event:external_open]" + this._data.path + "[/url]";
        // if (!this._data.includeBranches && this._data.branch) {
        //     this._data.project.editor.consoleView.log("Publish completed: " + this._data.pkg.name + "(" + this._data.branch + ")" + " -> " + _loc1_, new File(this._data.path));
        // }
        // else {
        //     this._data.project.editor.consoleView.log("Publish completed: " + this._data.pkg.name + " -> " + _loc1_, new File(this._data.path));
        // }
        // this._data.pkg.setVar("modifiedYetNotPublished", undefined);
        // this.cleanup();
        // this._Callback.callOnSuccess();
    }

    // private handleCallbackErrors(): void
    //       {
    //     this.cleanup();
    //     this._Callback.msgs.length = 0;
    //     this._Callback.addMsgs(this._stepCallback.msgs);
    //     this._Callback.callOnFail();
    // }

    // private handleException(param1: Error): void
    //       {
    //     this._Callback.msgs.length = 0;
    //     if (param1.errorID == 3013) {
    //         this._Callback.addMsg(Consts.strings.text123);
    //     }
    //     else if (param1.errorID == 3003) {
    //         this._Callback.addMsg("target folder not exists!");
    //     }
    //     else {
    //         this._data.project.editor.consoleView.logError("PublishHandler", param1);
    //         this._Callback.addMsg(RuntimeErrorUtil.toString(param1));
    //     }
    //     this.cleanup();
    //     this._Callback.callOnFail();
    // }

    //   private cleanup() : void{
    //      var _loc1_:FPackageItem = null;
    //      var _loc2_:$__4E$ = null;
    //      this._currentStep = null;
    //      for(_loc1_ in this._data.items)
    //      {
    //         _loc1_.releaseRef();
    //      }
    //      for(_loc1_ in this._data.hitTestImages)
    //      {
    //         _loc1_.releaseRef();
    //      }
    //      for(_loc2_ in this._data.$__F8$)
    //      {
    //         if(_loc2_.data)
    //         {
    //            _loc2_.data.clear();
    //         }
    //         if(_loc2_.$__8I$)
    //         {
    //            _loc2_.$__8I$.clear();
    //         }
    //      }
    //      if(this._data.hitTestData)
    //      {
    //         this._data.hitTestData.clear();
    //      }
    //      this._data.project = null;
    //      this._data = null;
    //   }
}
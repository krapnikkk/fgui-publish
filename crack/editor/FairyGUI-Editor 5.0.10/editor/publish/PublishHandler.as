package fairygui.editor.publish
{
   import fairygui.editor.Consts;
   import fairygui.editor.api.IEditor;
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.api.ProjectType;
   import fairygui.editor.gui.FPackage;
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.gui.FProject;
   import fairygui.editor.publish.exporter.FlashExporter;
   import fairygui.editor.publish.exporter.GeneralExporter;
   import fairygui.editor.publish.exporter.LayaExporter;
   import fairygui.editor.publish.exporter.UnityExporter;
   import fairygui.editor.publish.gencode.TplAS3Generator;
   import fairygui.editor.publish.gencode.TplCocos2dxGenerator;
   import fairygui.editor.publish.gencode.TplCocosCreatorGenerator;
   import fairygui.editor.publish.gencode.TplEgretGenerator;
   import fairygui.editor.publish.gencode.TplHaxeGenerator;
   import fairygui.editor.publish.gencode.TplLaya2TSGenerator;
   import fairygui.editor.publish.gencode.TplLayaGenerator;
   import fairygui.editor.publish.gencode.TplLayaTSGenerator;
   import fairygui.editor.publish.gencode.TplPixiGenerator;
   import fairygui.editor.publish.gencode.TplStarlingGenerator;
   import fairygui.editor.publish.gencode.TplUnityGenerator;
   import fairygui.editor.settings.CustomProps;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.utils.Callback;
   import fairygui.utils.RuntimeErrorUtil;
   import fairygui.utils.UtilsStr;
   import flash.filesystem.File;
   
   public class PublishHandler
   {
       
      
      private var _data:§_-4Z§;
      
      private var _callback:Callback;
      
      private var §_-B3§:taskRun;
      
      private var _stepCallback:Callback;
      
      public function PublishHandler()
      {
         super();
      }
      
      public function publish(param1:IUIPackage, param2:String, param3:String, param4:Boolean, param5:Callback) : void
      {
         var editor:IEditor = null;
         var path:String = null;
         var targetFolder:File = null;
         var targetFile:File = null;
         var branchPath:String = null;
         var pkg:IUIPackage = param1;
         var branch:String = param2;
         var targetPath:String = param3;
         var exportDescOnly:Boolean = param4;
         var callback:Callback = param5;
         editor = IEditor(pkg.project.editor);
         var settings:PublishSettings = PublishSettings(pkg.publishSettings);
         var gsettings:GlobalPublishSettings = GlobalPublishSettings(pkg.project.getSettings("publish"));
         if(!settings.path && !gsettings.path && !targetPath)
         {
            callback.addMsg(UtilsStr.formatString(Consts.strings.text100,pkg.name));
            callback.callOnFail();
            return;
         }
         if(!settings.fileName)
         {
            settings.fileName = pkg.name;
         }
         this._callback = callback;
         this._data = new §_-4Z§();
         this._data.pkg = FPackage(pkg);
         this._data.project = FProject(pkg.project);
         this._data.branch = branch;
         var customProps:Object = CustomProps(pkg.project.getSettings("customProps")).all;
         try
         {
            if(targetPath)
            {
               path = targetPath;
            }
            else if(settings.path)
            {
               path = settings.path;
            }
            else
            {
               path = gsettings.path;
            }
            if(gsettings.branchProcessing != 0 && branch)
            {
               if(settings.branchPath)
               {
                  branchPath = settings.branchPath;
               }
               else
               {
                  branchPath = gsettings.branchPath;
               }
               if(branchPath.length > 0)
               {
                  path = branchPath;
               }
               path = path + ("/" + branch);
            }
            if(path.indexOf("{") != -1)
            {
               path = UtilsStr.formatStringByName(path,{"publish_file_name":settings.fileName});
               path = UtilsStr.formatStringByName(path,customProps);
            }
            targetFolder = new File(pkg.project.basePath).resolvePath(path);
            targetFile = targetFolder.resolvePath(settings.fileName);
            targetFolder = targetFile.parent;
            if(!targetFolder.exists)
            {
               targetFolder.createDirectory();
            }
            else if(!targetFolder.isDirectory)
            {
               this._callback.addMsg(Consts.strings.text327);
               this._callback.callOnFail();
               return;
            }
            this._data.path = targetFolder.nativePath;
         }
         catch(err:Error)
         {
            editor.consoleView.logError(null,err);
            _callback.addMsg(Consts.strings.text327);
            _callback.callOnFail();
            return;
         }
         var ext:String = targetFile.extension;
         this._data.fileName = UtilsStr.getFileName(targetFile.name);
         if(this._data.project.supportCustomFileExtension && ext)
         {
            this._data.fileExtension = ext;
         }
         else
         {
            this._data.fileExtension = gsettings.fileExtension;
         }
         this._data.exportDescOnly = exportDescOnly;
         this._data.singlePackage = settings.packageCount == 1 || settings.packageCount == 0 && gsettings.packageCount == 1;
         if(pkg.project.type == ProjectType.FLASH || pkg.project.type == ProjectType.STARLING || pkg.project.type == ProjectType.HAXE)
         {
            if(this._data.singlePackage)
            {
               this._data.exportDescOnly = false;
            }
         }
         this._data.extractAlpha = this._data.project.supportExtractAlpha && settings.atlasList[0].extractAlpha;
         this._data.§_-O4§ = this._data.project.supportAtlas;
         this._data.genCode = gsettings.allowGenCode && settings.genCode;
         if(this._data.genCode)
         {
            if(settings.codePath)
            {
               this._data.codePath = settings.codePath;
            }
            else
            {
               this._data.codePath = gsettings.codePath;
            }
            if(this._data.codePath)
            {
               this._data.codePath = UtilsStr.formatStringByName(this._data.codePath,customProps);
               this._data.codePath = new File(pkg.project.basePath).resolvePath(this._data.codePath).nativePath;
            }
         }
         this._data.includeHighResolution = gsettings.includeHighResolution;
         this._data.trimImage = gsettings.atlasTrimImage;
         this._data.includeBranches = gsettings.branchProcessing == 0;
         if(this._data.includeBranches)
         {
            this._data.allBranches = this._data.project.allBranches.length;
         }
         else if(branch)
         {
            this._data.allBranches = 1;
         }
         else
         {
            this._data.allBranches = 0;
         }
         if(!this._data.includeBranches && branch)
         {
            editor.consoleView.log("Publish start: " + pkg.name + "(" + branch + ")");
         }
         else
         {
            editor.consoleView.log("Publish start: " + pkg.name);
         }
         this._stepCallback = new Callback();
         this._stepCallback.failed = this.§_-9h§;
         this.§_-KZ§(new §_-FQ§(),this.§_-95§);
      }
      
      private function §_-95§() : void
      {
         this.§_-KZ§(new §_-Ac§(),!!this._data.§_-O4§?this.§_-4o§:this.§_-Hn§);
      }
      
      private function §_-4o§() : void
      {
         this.§_-KZ§(new §_-60§(),this.§_-Hn§);
      }
      
      private function §_-Hn§() : void
      {
         this.§_-KZ§(new §_-NR§(),this.§_-D2§);
      }
      
      private function §_-D2§() : void
      {
         this.§_-KZ§(new §_-6y§(),!!this._data.genCode?this.§_-HP§:this.export);
      }
      
      private function §_-HP§() : void
      {
         var _loc2_:taskRun = null;
         var _loc1_:GlobalPublishSettings = GlobalPublishSettings(this._data.project.getSettings("publish"));
         if(!this._data.codePath)
         {
            this._data.project.editor.consoleView.logWarning(UtilsStr.formatString(Consts.strings.text273,this._data.pkg.name));
            this.export();
            return;
         }
         var _loc3_:String = _loc1_.codeType;
         switch(this._data.project.type)
         {
            case ProjectType.FLASH:
               _loc2_ = new TplAS3Generator();
               break;
            case ProjectType.STARLING:
               _loc2_ = new TplStarlingGenerator();
               break;
            case ProjectType.LAYABOX:
               if(_loc3_ == "TS")
               {
                  _loc2_ = new TplLayaTSGenerator();
               }
               else if(_loc3_ == "TS-2" || _loc3_ == "TS-2.0")
               {
                  _loc2_ = new TplLaya2TSGenerator();
               }
               else
               {
                  _loc2_ = new TplLayaGenerator();
               }
               break;
            case ProjectType.EGRET:
               _loc2_ = new TplEgretGenerator();
               break;
            case ProjectType.PIXI:
               _loc2_ = new TplPixiGenerator();
               break;
            case ProjectType.UNITY:
            case ProjectType.CRY:
            case ProjectType.MONOGAME:
               _loc2_ = new TplUnityGenerator();
               break;
            case ProjectType.HAXE:
               _loc2_ = new TplHaxeGenerator();
               break;
            case ProjectType.COCOS2DX:
            case ProjectType.VISION:
               _loc2_ = new TplCocos2dxGenerator();
               break;
            case ProjectType.COCOSCREATOR:
               _loc2_ = new TplCocosCreatorGenerator();
         }
         if(_loc2_)
         {
            this.§_-KZ§(_loc2_,this.export);
         }
         else
         {
            if(this._data.project.type != ProjectType.CORONA)
            {
               this._callback.addMsg("unkown code type");
            }
            this.export();
         }
      }
      
      private function export() : void
      {
         var _loc1_:taskRun = null;
         if(this._data.defaultPrevented)
         {
            this.§_-Bl§();
            return;
         }
         switch(this._data.project.type)
         {
            case ProjectType.HAXE:
            case ProjectType.FLASH:
            case ProjectType.STARLING:
               _loc1_ = new FlashExporter();
               break;
            case ProjectType.EGRET:
            case ProjectType.LAYABOX:
            case ProjectType.PIXI:
               _loc1_ = new LayaExporter();
               break;
            case ProjectType.UNITY:
               _loc1_ = new UnityExporter();
               break;
            default:
               _loc1_ = new GeneralExporter();
         }
         this.§_-KZ§(_loc1_,this.§_-Bl§);
      }
      
      private function §_-KZ§(param1:taskRun, param2:Function) : void
      {
         var step:taskRun = param1;
         var next:Function = param2;
         this.§_-B3§ = step;
         try
         {
            this._stepCallback.success = next;
            this.§_-B3§.publishData = this._data;
            this.§_-B3§._stepCallback = this._stepCallback;
            this._callback.addMsgs(this._stepCallback.msgs);
            this._stepCallback.msgs.length = 0;
            this.§_-B3§.run();
            return;
         }
         catch(err:Error)
         {
            §_-Ou§(err);
            return;
         }
      }
      
      private function §_-Bl§() : void
      {
         var _loc1_:* = "[url=event:external_open]" + this._data.path + "[/url]";
         if(!this._data.includeBranches && this._data.branch)
         {
            this._data.project.editor.consoleView.log("Publish completed: " + this._data.pkg.name + "(" + this._data.branch + ")" + " -> " + _loc1_,new File(this._data.path));
         }
         else
         {
            this._data.project.editor.consoleView.log("Publish completed: " + this._data.pkg.name + " -> " + _loc1_,new File(this._data.path));
         }
         this._data.pkg.setVar("modifiedYetNotPublished",undefined);
         this.cleanup();
         this._callback.callOnSuccess();
      }
      
      private function §_-9h§() : void
      {
         this.cleanup();
         this._callback.msgs.length = 0;
         this._callback.addMsgs(this._stepCallback.msgs);
         this._callback.callOnFail();
      }
      
      private function §_-Ou§(param1:Error) : void
      {
         this._callback.msgs.length = 0;
         if(param1.errorID == 3013)
         {
            this._callback.addMsg(Consts.strings.text123);
         }
         else if(param1.errorID == 3003)
         {
            this._callback.addMsg("target folder not exists!");
         }
         else
         {
            this._data.project.editor.consoleView.logError("PublishHandler",param1);
            this._callback.addMsg(RuntimeErrorUtil.toString(param1));
         }
         this.cleanup();
         this._callback.callOnFail();
      }
      
      private function cleanup() : void
      {
         var _loc1_:FPackageItem = null;
         var _loc2_:§_-4E§ = null;
         this.§_-B3§ = null;
         for each(_loc1_ in this._data.items)
         {
            _loc1_.releaseRef();
         }
         for each(_loc1_ in this._data.hitTestImages)
         {
            _loc1_.releaseRef();
         }
         for each(_loc2_ in this._data.§_-F8§)
         {
            if(_loc2_.data)
            {
               _loc2_.data.clear();
            }
            if(_loc2_.§_-8I§)
            {
               _loc2_.§_-8I§.clear();
            }
         }
         if(this._data.hitTestData)
         {
            this._data.hitTestData.clear();
         }
         this._data.project = null;
         this._data = null;
      }
   }
}

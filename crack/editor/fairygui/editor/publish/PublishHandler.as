package fairygui.editor.publish
{
   import fairygui.editor.Consts;
   import fairygui.editor.PackagesPanel;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.publish.exporter.FlashExporter;
   import fairygui.editor.publish.exporter.LayaExporter;
   import fairygui.editor.publish.exporter.StarlingExporter;
   import fairygui.editor.publish.exporter.UnityExporter;
   import fairygui.editor.publish.gencode.GenAS3;
   import fairygui.editor.publish.gencode.GenCSharp;
   import fairygui.editor.publish.gencode.GenHaxe;
   import fairygui.editor.publish.gencode.GenTypeScript;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.RuntimeErrorUtil;
   import fairygui.editor.utils.UtilsStr;
   import flash.filesystem.File;
   
   public class PublishHandler
   {
       
      
      private var _data:PublishData;
      
      private var _callback:Callback;
      
      private var _currentStep:PublishStep;
      
      private var _stepCallback:Callback;
      
      public function PublishHandler()
      {
         super();
      }
      
      public function publish(param1:EUIPackage, param2:Boolean, param3:String, param4:Callback) : void
      {
         var _loc13_:* = null;
         var _loc9_:File = null;
         var _loc7_:File = null;
         var _loc6_:* = param1;
         var _loc11_:* = param2;
         var _loc10_:* = param3;
         var _loc14_:* = param4;
         _loc6_.ensureOpen();
         var _loc5_:PublishSettings = _loc6_.publishSettings;
         var _loc12_:GlobalPublishSettings = _loc6_.project.settingsCenter.publish;
         if(!_loc5_.filePath && !_loc6_.project.settingsCenter.publish.filePath && !_loc10_)
         {
            _loc14_.addMsg(UtilsStr.formatString(Consts.g.text100,_loc6_.name));
            _loc14_.callOnFail();
            return;
         }
         if(!_loc5_.fileName)
         {
            _loc14_.addMsg(UtilsStr.formatString(Consts.g.text101,_loc6_.name));
            _loc14_.callOnFail();
            return;
         }
         this._callback = _loc14_;
         this._data = new PublishData();
         this._data.pkg = _loc6_;
         this._data._project = _loc6_.project;
         try
         {
            if(_loc10_)
            {
               _loc13_ = _loc10_;
            }
            else if(_loc5_.filePath)
            {
               _loc13_ = _loc5_.filePath;
            }
            else
            {
               _loc13_ = this._data._project.settingsCenter.publish.filePath;
            }
            if(_loc13_.indexOf("{") != -1)
            {
               _loc13_ = UtilsStr.formatStringByName(_loc13_,{"publish_file_name":_loc5_.fileName});
               _loc13_ = UtilsStr.formatStringByName(_loc13_,_loc6_.project.customProperties);
            }
            _loc9_ = new File(_loc6_.project.basePath).resolvePath(_loc13_);
            _loc7_ = _loc9_.resolvePath(_loc5_.fileName);
            _loc9_ = _loc7_.parent;
            if(!_loc9_.exists)
            {
               _loc9_.createDirectory();
            }
            else if(!_loc9_.isDirectory)
            {
               this._callback.addMsg(Consts.g.text327);
               this._callback.callOnFail();
               return;
            }
            this._data._filePath = _loc9_.nativePath;
            this._callback.result = this._data._filePath;
         }
         catch(err:Error)
         {
            _callback.addMsg(Consts.g.text327);
            _callback.callOnFail();
            return;
         }
         var _loc8_:String = _loc7_.extension;
         this._data.fileName = UtilsStr.getFileName(_loc7_.name);
         if(this._data._project.type == "Unity")
         {
            this._data._fileExtension = "bytes";
         }
         else if(_loc8_)
         {
            this._data._fileExtension = _loc8_;
         }
         else if(!_loc12_.fileExtension)
         {
            if(this._data._project.isH5)
            {
               this._data._fileExtension = "fui";
            }
            else
            {
               this._data._fileExtension = "zip";
            }
         }
         else
         {
            this._data._fileExtension = _loc12_.fileExtension;
         }
         this._data._exportDescOnly = _loc11_;
         this._data._singlePackage = _loc5_.packageCount == 1 || _loc5_.packageCount == 0 && _loc12_.packageCount == 1;
         if(_loc6_.project.type == "Flash" || _loc6_.project.type == "Starling" || "Haxe")
         {
            if(this._data._singlePackage)
            {
               this._data._exportDescOnly = false;
            }
         }
         this._data._extractAlpha = _loc6_.project.type == "Unity" && _loc5_.atlasList[0].extractAlpha;
         this._data.usingAtlas = _loc6_.project.usingAtlas;
         this._data._genCode = _loc5_.genCode;
         this._stepCallback = new Callback();
         this._stepCallback.failed = this.handleCallbackErrors;
         this.runStep(new CollectItems(),this.handleImages);
      }
      
      private function handleImages() : void
      {
         this._data.pkg.publishing = true;
         this._callback.result2 = CollectItems(this._currentStep).excludedCount;
         if(this._data.usingAtlas)
         {
            this.runStep(new CreateBins(),this.createOutput);
         }
         else
         {
            this.runStep(new HandleImages(),this.createOutput);
         }
      }
      
      private function createOutput() : void
      {
         this.runStep(new CreateOutput(),this.callPlugins);
      }
      
      private function callPlugins() : void
      {
         this.runStep(new CallPlugins(),!!this._data._genCode?this.generateCode:this.export);
      }
      
      private function generateCode() : void
      {
         var _loc1_:PublishStep = null;
         if(!this._data._project.settingsCenter.publish.codePath)
         {
            this._callback.addMsg(Consts.g.text273);
            this.export();
            return;
         }
         if(this._data._project.settingsCenter.publish.codeType)
         {
            var _loc2_:* = this._data._project.settingsCenter.publish.codeType;
            if("AS3" !== _loc2_)
            {
               if("TS" !== _loc2_)
               {
                  if("C#" !== _loc2_)
                  {
                     if("HAXE" === _loc2_)
                     {
                        _loc1_ = new GenHaxe();
                     }
                  }
                  else
                  {
                     _loc1_ = new GenCSharp();
                  }
               }
               else
               {
                  _loc1_ = new GenTypeScript();
               }
            }
            else
            {
               _loc1_ = new GenAS3();
            }
         }
         else
         {
            _loc2_ = this._data._project.type;
            if("Flash" !== _loc2_)
            {
               if("Starling" !== _loc2_)
               {
                  if("Layabox" !== _loc2_)
                  {
                     if("Egret" !== _loc2_)
                     {
                        if("Pixi" !== _loc2_)
                        {
                           if("Unity" !== _loc2_)
                           {
                              if("Haxe" === _loc2_)
                              {
                                 _loc1_ = new GenHaxe();
                              }
                           }
                           else
                           {
                              _loc1_ = new GenCSharp();
                           }
                        }
                     }
                     _loc1_ = new GenTypeScript();
                  }
               }
               addr81:
               _loc1_ = new GenAS3();
            }
            §§goto(addr81);
         }
         if(_loc1_)
         {
            this.runStep(_loc1_,this.export);
         }
         else
         {
            this._callback.addMsg("unkown code type");
            this.export();
         }
      }
      
      private function export() : void
      {
         var _loc1_:PublishStep = null;
         var _loc2_:* = this._data._project.type;
         if("Haxe" !== _loc2_)
         {
            if("Flash" !== _loc2_)
            {
               if("Starling" !== _loc2_)
               {
                  if("Egret" !== _loc2_)
                  {
                     if("Layabox" !== _loc2_)
                     {
                        if("Pixi" !== _loc2_)
                        {
                           if("Unity" === _loc2_)
                           {
                              _loc1_ = new UnityExporter();
                           }
                        }
                     }
                     addr26:
                     _loc1_ = new LayaExporter();
                  }
                  §§goto(addr26);
               }
               else
               {
                  _loc1_ = new StarlingExporter();
               }
            }
            addr59:
            this.runStep(_loc1_,this.publishCompleted);
            return;
         }
         _loc1_ = new FlashExporter();
         §§goto(addr59);
      }
      
      private function runStep(param1:PublishStep, param2:Function) : void
      {
         var _loc4_:* = param1;
         var _loc3_:* = param2;
         this._currentStep = _loc4_;
         try
         {
            this._stepCallback.success = _loc3_;
            this._currentStep.publishData = this._data;
            this._currentStep.stepCallback = this._stepCallback;
            this._callback.addMsgs(this._stepCallback.msgs);
            this._stepCallback.msgs.length = 0;
            this._currentStep.run();
            if(this._data._defaultPrevented)
            {
               this.publishCompleted();
            }
            return;
         }
         catch(err:Error)
         {
            handleException(err);
            return;
         }
      }
      
      private function publishCompleted() : void
      {
         this._data.pkg.publishing = false;
         this._currentStep = null;
         this._callback.callOnSuccess();
      }
      
      private function handleCallbackErrors() : void
      {
         PackagesPanel.PUBLIC_OK = false;
         this._data.pkg.publishing = false;
         this._currentStep = null;
         this._callback.msgs.length = 0;
         this._callback.addMsgs(this._stepCallback.msgs);
         this._callback.callOnFail();
      }
      
      private function handleException(param1:Error) : void
      {
         PackagesPanel.PUBLIC_OK = false;
         this._data.pkg.publishing = false;
         this._currentStep = null;
         this._callback.msgs.length = 0;
         if(param1.errorID == 3013)
         {
            this._callback.addMsg(Consts.g.text123);
         }
         else if(param1.errorID == 3003)
         {
            this._callback.addMsg("target folder not exists!");
         }
         else
         {
            this._callback.addMsg(RuntimeErrorUtil.toString(param1));
         }
         this._callback.callOnFail();
      }
   }
}

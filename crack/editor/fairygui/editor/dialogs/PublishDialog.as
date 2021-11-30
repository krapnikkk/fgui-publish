package fairygui.editor.dialogs
{
   import fairygui.Controller;
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.publish.PublishHandler;
   import fairygui.editor.settings.AtlasSettings;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   import flash.filesystem.File;
   
   public class PublishDialog extends WindowBase
   {
       
      
      private var _pkgList:GList;
      
      private var _selectedPkg:EUIPackage;
      
      private var _global:Controller;
      
      public function PublishDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","PublishDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._pkgList = contentPane.getChild("pkgs").asList;
         this._pkgList.addEventListener("itemClick",this.__packageChanged);
         this._global = contentPane.getController("global");
         _loc2_ = contentPane.getChild("codeType").asComboBox;
         _loc2_.items = [Consts.g.text138,"C#","AS3","TypeScript","Haxe"];
         _loc2_.values = ["","C#","AS3","TS","HAXE"];
         contentPane.getChild("useGlobalPath").addEventListener("stateChanged",this.__pathOptionChanged);
         contentPane.getChild("useGlobalPkgCount").addEventListener("stateChanged",this.__pkgCountOptionChanged);
         contentPane.getChild("browse1").addClickListener(this.__browse);
         contentPane.getChild("browse2").addClickListener(this.__browse);
         contentPane.getChild("browse3").addClickListener(this.__browse);
         contentPane.getChild("atlasSettings").addClickListener(this.__openAtlasSettings);
         contentPane.getChild("excludedSettings").addClickListener(this.__openExcludedSettings);
         contentPane.getChild("globalSettings").addClickListener(this.__openGlobalSettings);
         contentPane.getChild("publish").addClickListener(this.__publish);
         contentPane.getChild("publishDesc").addClickListener(this.__publishDesc);
         contentPane.getChild("publishAll").addClickListener(this.__publishAll);
         contentPane.getChild("close").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         var _loc3_:EUIPackage = null;
         var _loc1_:GButton = null;
         var _loc5_:EUIPackage = _editorWindow.mainPanel.getActivePackage();
         this._pkgList.removeChildrenToPool();
         var _loc4_:Vector.<EUIPackage> = _editorWindow.project.getPackageListChoosePackges();
         var _loc2_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:* = _loc4_;
         for each(_loc3_ in _loc4_)
         {
            _loc1_ = this._pkgList.addItemFromPool().asButton;
            _loc1_.name = _loc3_.id;
            _loc1_.title = _loc3_.name;
            _loc1_.icon = Icons.all["package"];
            if(_loc5_ == _loc3_)
            {
               this._pkgList.selectedIndex = _loc2_;
            }
            _loc2_++;
         }
         if(this._pkgList.selectedIndex == -1)
         {
            this._pkgList.selectedIndex = 0;
         }
         if(this._pkgList.selectedIndex != -1)
         {
            this._selectedPkg = _editorWindow.project.getPackage(this._pkgList.getChildAt(this._pkgList.selectedIndex).name);
         }
         else
         {
            this._selectedPkg = null;
         }
         this.setToUI();
      }
      
      override protected function onHide() : void
      {
         this.save();
         super.onHide();
      }
      
      public function openOrPublish(param1:Boolean = false, param2:Number = 0) : void
      {
         if(param2 == 0)
         {
            PlugInManager.FYOUT = PlugInManager.FYOUT1;
         }
         else
         {
            PlugInManager.FYOUT = param2;
         }
         var _loc5_:EUIPackage = _editorWindow.mainPanel.getActivePackage();
         var _loc4_:PublishSettings = _loc5_.publishSettings;
         var _loc3_:AtlasSettings = _loc4_.atlasList[0];
         if(PlugInManager.EX1024)
         {
            if(_loc3_.maxWidth > PlugInManager.RES_SIZE || _loc3_.maxHeight > PlugInManager.RES_SIZE)
            {
               _editorWindow.alert("输出的图片尺寸超出了" + PlugInManager.RES_SIZE + "！");
               return;
            }
         }
         if(this.isReadyToPublish(_loc5_))
         {
            this.publish(_loc5_,param1);
         }
         else
         {
            show();
         }
      }
      
      private function isReadyToPublish(param1:EUIPackage) : Boolean
      {
         var _loc2_:PublishSettings = param1.publishSettings;
         if(!_loc2_.fileName || !_loc2_.filePath && !param1.project.settingsCenter.publish.filePath)
         {
            return false;
         }
         return true;
      }
      
      public function __publish(param1:Event) : void
      {
         this.save();
         this.publish(this._selectedPkg,false);
      }
      
      private function __publishDesc(param1:Event) : void
      {
         this.save();
         this.publish(this._selectedPkg,true);
      }
      
      private function publish(param1:EUIPackage, param2:Boolean) : void
      {
         param1 = param1;
         param2 = param2;
         var pkg:EUIPackage = param1;
         var onlyDesc:Boolean = param2;
         _editorWindow.mainPanel.editPanel.queryToSaveAllDocuments(function(param1:int):void
         {
            if(param1 != 2)
            {
               publish2(pkg,onlyDesc);
            }
         });
      }
      
      private function publish2(param1:EUIPackage, param2:Boolean) : void
      {
         param1 = param1;
         param2 = param2;
         var _loc21_:PublishSettings = param1.publishSettings;
         var _loc3_:AtlasSettings = _loc21_.atlasList[0];
         if(PlugInManager.EX1024)
         {
            if(_loc3_.maxWidth > PlugInManager.RES_SIZE || _loc3_.maxHeight > PlugInManager.RES_SIZE)
            {
               _editorWindow.alert("输出的图片尺寸超出了" + PlugInManager.RES_SIZE + "！");
               return;
            }
         }
         var callback:Callback = null;
         var pkg:EUIPackage = param1;
         var onlyDesc:Boolean = param2;
         var handler:PublishHandler = new PublishHandler();
         var realThis:PublishDialog = this;
         callback = new Callback();
         callback.success = function():void
         {
            _editorWindow.closeWaiting();
            var _loc1_:String = "\'" + pkg.name + "\' " + Consts.g.text96;
            _loc1_ = _loc1_ + ("\n" + callback.result);
            if(callback.result2 != null && callback.result2 > 0)
            {
               _loc1_ = _loc1_ + ("\n" + UtilsStr.formatString(Consts.g.text297,callback.result2));
            }
            if(callback.msgs.length > 0)
            {
               _loc1_ = _loc1_ + ("\n\n" + Consts.g.text97 + "\n" + callback.msgs.join("\n"));
               _editorWindow.alert(_loc1_);
            }
            else
            {
               PromptDialog(_editorWindow.getDialog(PromptDialog)).open(_loc1_);
            }
         };
         callback.failed = function():void
         {
            _editorWindow.closeWaiting();
            _editorWindow.alert("\'" + pkg.name + "\' " + Consts.g.text98 + "\n" + callback.msgs.join("\n"));
         };
         _editorWindow.showWaiting(Consts.g.text99 + " \'" + pkg.name + "\'...");
         try
         {
            handler.publish(pkg,onlyDesc,null,callback);
            return;
         }
         catch(err:Error)
         {
            _editorWindow.closeWaiting();
            _editorWindow.alert("\'" + pkg.name + "\' " + Consts.g.text98 + "\nPlease check the path!");
            return;
         }
      }
      
      private function __publishAll(param1:Event) : void
      {
         param1 = param1;
         var handler:PublishHandler = null;
         var bt:BulkTasks = null;
         var callback:Callback = null;
         var cancel:Function = null;
         var evt:Event = param1;
         this.save();
         var pkg:EUIPackage = _editorWindow.project.getPackage(this._pkgList.getChildAt(this._pkgList.selectedIndex).name);
         handler = new PublishHandler();
         var realThis:PublishDialog = this;
         bt = new BulkTasks(1);
         callback = new Callback();
         callback.success = function():void
         {
            bt.finishItem();
            bt.addErrorMsgs(callback.msgs);
            callback.msgs.length = 0;
         };
         callback.failed = function():void
         {
            bt.clear();
            _editorWindow.closeWaiting();
            _editorWindow.alert(Consts.g.text98 + "\n\n" + callback.msgs.join("\n"));
         };
         cancel = function():void
         {
            bt.clear();
         };
         var task:Function = function():void
         {
            var _loc2_:EUIPackage = null;
            var _loc1_:Boolean = false;
            _loc2_ = EUIPackage(bt.taskData);
            try
            {
               handler.publish(_loc2_,false,null,callback);
               _editorWindow.showWaiting(Consts.g.text99 + " \'" + _loc2_.name + "\'...",cancel);
               return;
            }
            catch(err:Error)
            {
               bt.finishItem();
               bt.addErrorMsg(_loc2_.name + Consts.g.text98 + ":please check the path!");
               return;
            }
         };
         var arr:Vector.<EUIPackage> = _editorWindow.project.getPackageListChoosePackges();
         var publicClassContent:String = "class FyPublicClass{ \r\n\tpublic static allClasses:Array<string> = [";
         var index:int = 0;
         var _loc4_:int = 0;
         var _loc3_:* = arr;
         for each(pkg in arr)
         {
            if(pkg.publishSettings.genCode)
            {
               publicClassContent = publicClassContent + (index == 0?"\'" + pkg.name + "\'":",\'" + pkg.name + "\'");
            }
            index = Number(index) + 1;
         }
         publicClassContent = publicClassContent + "];";
         publicClassContent = publicClassContent + "\r\n\tpublic static initClass(className:string):void{\r\n\t\t switch (className){";
         var _loc6_:int = 0;
         var _loc5_:* = arr;
         for each(pkg in arr)
         {
            if(pkg.publishSettings.genCode)
            {
               publicClassContent = publicClassContent + ("\r\n\t\t\tcase \'" + pkg.name + "\':");
               publicClassContent = publicClassContent + ("\r\n\t\t\t\t" + pkg.name + "." + pkg.name + "Binder.bindAll();");
               publicClassContent = publicClassContent + "\r\n\t\t\tbreak;";
            }
         }
         publicClassContent = publicClassContent + "\r\n\t\t}";
         publicClassContent = publicClassContent + "\r\n\t}\r\n}";
         var ss:String = UtilsStr.formatStringByName(_editorWindow.project.settingsCenter.publish.codePath,_editorWindow.project.customProperties);
         var tfolder:File = new File(_editorWindow.project.basePath).resolvePath(ss);
         ss = tfolder.nativePath;
         tfolder = null;
         UtilsFile.saveString(new File(ss + File.separator + "FyPublicClass.ts"),"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/\n\n" + publicClassContent);
         var _loc8_:int = 0;
         var _loc7_:* = arr;
         for each(pkg in arr)
         {
            bt.addTask(task,pkg);
         }
         bt.start(function():void
         {
            __publishAll11();
            _editorWindow.closeWaiting();
            if(bt.errorMsgs.length > 0)
            {
               _editorWindow.alert(Consts.g.text96 + "\n\n" + Consts.g.text97 + "\n" + bt.errorMsgs.join("\n"));
            }
            else
            {
               _editorWindow.alert(Consts.g.text96);
            }
         });
      }
      
      public function __publishAll11() : void
      {
         var _loc2_:int = 0;
         var _loc5_:EUIPackage = null;
         var _loc4_:Vector.<EUIPackage> = _editorWindow.project.getPackageList();
         var _loc7_:String = "";
         var _loc3_:String = "";
         if(_editorWindow.project.type == "Layabox" || _editorWindow.project.type == "Egret")
         {
            _loc3_ = "FyPublicClass.ts";
            _loc7_ = _loc7_ + "class FyPublicClass{ \r\n\tpublic static allClasses:Array<string> = [";
            _loc2_ = 0;
            var _loc9_:int = 0;
            var _loc8_:* = _loc4_;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.publishSettings.genCode)
               {
                  _loc7_ = _loc7_ + (_loc2_ == 0?"\'" + _loc5_.name + "\'":",\'" + _loc5_.name + "\'");
               }
               _loc2_++;
            }
            _loc7_ = _loc7_ + "];";
            _loc7_ = _loc7_ + "\r\n\tpublic static initClass(className:string):void{\r\n\t\t switch (className){";
            var _loc11_:int = 0;
            var _loc10_:* = _loc4_;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.publishSettings.genCode)
               {
                  _loc7_ = _loc7_ + ("\r\n\t\t\tcase \'" + _loc5_.name + "\':");
                  _loc7_ = _loc7_ + ("\r\n\t\t\t\t" + _loc5_.name + "." + _loc5_.name + "Binder.bindAll();");
                  _loc7_ = _loc7_ + "\r\n\t\t\tbreak;";
               }
            }
            _loc7_ = _loc7_ + "\r\n\t\t}";
            _loc7_ = _loc7_ + "\r\n\t}\r\n}";
         }
         else if(_editorWindow.project.type == "Unity")
         {
            _loc3_ = "FyPublicClass.cs";
            var _loc13_:int = 0;
            var _loc12_:* = _loc4_;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.publishSettings.genCode)
               {
                  _loc7_ = _loc7_ + ("using " + _loc5_.name + ";\r\n");
               }
            }
            _loc7_ = _loc7_ + "public class FyPublicClass";
            _loc7_ = _loc7_ + "\r\n{";
            _loc7_ = _loc7_ + "\r\n\tpublic static void initClass(string className){\r\n\t\t switch (className){";
            var _loc15_:int = 0;
            var _loc14_:* = _loc4_;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.publishSettings.genCode)
               {
                  _loc7_ = _loc7_ + ("\r\n\t\t\tcase \"" + _loc5_.name + "\":");
                  _loc7_ = _loc7_ + ("\r\n\t\t\t\t" + _loc5_.name + "Binder.BindAll();");
                  _loc7_ = _loc7_ + "\r\n\t\t\tbreak;";
               }
            }
            _loc7_ = _loc7_ + "\r\n\t\t}";
            _loc7_ = _loc7_ + "\r\n\t}";
            _loc7_ = _loc7_ + "\r\n}";
         }
         var _loc6_:String = UtilsStr.formatStringByName(_editorWindow.project.settingsCenter.publish.codePath,_editorWindow.project.customProperties);
         var _loc1_:File = new File(_editorWindow.project.basePath).resolvePath(_loc6_);
         _loc6_ = _loc1_.nativePath;
         _loc1_ = null;
         UtilsFile.saveString(new File(_loc6_ + File.separator + _loc3_),"/** This is an automatically generated class by FairyGUI. Please do not modify it. **/\n\n" + _loc7_);
         _editorWindow.alert(Consts.g.text909);
      }
      
      private function save() : void
      {
         var _loc1_:PublishSettings = null;
         if(this._selectedPkg != null)
         {
            _loc1_ = this._selectedPkg.publishSettings;
            if(!contentPane.getChild("useGlobalPath").asButton.selected)
            {
               _loc1_.filePath = contentPane.getChild("path").text;
            }
            else
            {
               _loc1_.filePath = null;
            }
            _loc1_.fileName = contentPane.getChild("fileName").text;
            if(!contentPane.getChild("useGlobalPkgCount").asButton.selected)
            {
               _loc1_.packageCount = int(contentPane.getChild("packageCount").asComboBox.value);
            }
            else
            {
               _loc1_.packageCount = 0;
            }
            _loc1_.genCode = contentPane.getChild("genCode").asButton.selected;
            this._selectedPkg.save();
         }
         var _loc2_:GlobalPublishSettings = _editorWindow.project.settingsCenter.publish;
         _loc2_.filePath = contentPane.getChild("globalPath").text;
         _loc2_.fileExtension = contentPane.getChild("globalZipExt").text;
         _loc2_.packageCount = contentPane.getController("global_package_count").selectedIndex + 1;
         _loc2_.codePath = contentPane.getChild("codePath").text;
         _loc2_.classNamePrefix = contentPane.getChild("classNamePrefix").text;
         _loc2_.memberNamePrefix = contentPane.getChild("memberNamePrefix").text;
         _loc2_.packageName = contentPane.getChild("codePackageName").text;
         _loc2_.ignoreNoname = contentPane.getChild("ignoreNoname").asButton.selected;
         _loc2_.getMemberByName = contentPane.getChild("getMemberByName").asButton.selected;
         _loc2_.codeType = contentPane.getChild("codeType").asComboBox.value;
         _loc2_.save();
      }
      
      private function __browse(param1:Event) : void
      {
         param1 = param1;
         var btn:String = null;
         var evt:Event = param1;
         btn = evt.currentTarget.name;
         UtilsFile.browseForDirectory("Select Path",function(param1:File):void
         {
            if(btn == "browse1")
            {
               contentPane.getChild("path").text = param1.nativePath;
            }
            else if(btn == "browse2")
            {
               contentPane.getChild("globalPath").text = param1.nativePath;
            }
            else
            {
               contentPane.getChild("codePath").text = param1.nativePath;
            }
         });
      }
      
      private function __packageChanged(param1:Event) : void
      {
         if(this._selectedPkg != null)
         {
            this.save();
            this._selectedPkg = _editorWindow.project.getPackage(this._pkgList.getChildAt(this._pkgList.selectedIndex).name);
         }
         this.setToUI();
      }
      
      private function setToUI() : void
      {
         var _loc1_:PublishSettings = null;
         var _loc2_:GlobalPublishSettings = _editorWindow.project.settingsCenter.publish;
         if(this._selectedPkg != null)
         {
            _loc1_ = this._selectedPkg.publishSettings;
            if(_loc1_.filePath)
            {
               contentPane.getChild("path").text = _loc1_.filePath;
               contentPane.getChild("useGlobalPath").asButton.selected = false;
            }
            else
            {
               contentPane.getChild("path").text = _loc2_.filePath;
               contentPane.getChild("useGlobalPath").asButton.selected = true;
            }
            if(!_loc1_.fileName)
            {
               contentPane.getChild("fileName").text = this._selectedPkg.name;
            }
            else
            {
               contentPane.getChild("fileName").text = _loc1_.fileName;
            }
            contentPane.getController("project_type").selectedPage = this._selectedPkg.project.type;
            if(_loc1_.packageCount == 0)
            {
               contentPane.getChild("packageCount").asComboBox.value = "" + _loc2_.packageCount;
               contentPane.getChild("useGlobalPkgCount").asButton.selected = true;
            }
            else
            {
               contentPane.getChild("packageCount").asComboBox.value = "" + _loc1_.packageCount;
               contentPane.getChild("useGlobalPkgCount").asButton.selected = false;
            }
            contentPane.getChild("genCode").asButton.selected = _loc1_.genCode;
         }
         contentPane.getChild("globalPath").text = _loc2_.filePath;
         contentPane.getChild("globalZipExt").text = _loc2_.fileExtension;
         contentPane.getController("global_package_count").selectedIndex = _loc2_.packageCount - 1;
         contentPane.getChild("codePath").text = _loc2_.codePath;
         contentPane.getChild("classNamePrefix").text = _loc2_.classNamePrefix;
         contentPane.getChild("memberNamePrefix").text = _loc2_.memberNamePrefix;
         contentPane.getChild("codePackageName").text = _loc2_.packageName;
         contentPane.getChild("ignoreNoname").asButton.selected = _loc2_.ignoreNoname;
         contentPane.getChild("getMemberByName").asButton.selected = _loc2_.getMemberByName;
         contentPane.getChild("codeType").asComboBox.value = _loc2_.codeType;
         this.__pathOptionChanged(null);
         this.__pkgCountOptionChanged(null);
      }
      
      private function __pathOptionChanged(param1:Event) : void
      {
         if(contentPane.getChild("useGlobalPath").asButton.selected)
         {
            contentPane.getChild("path").enabled = false;
            contentPane.getChild("browse1").enabled = false;
            contentPane.getChild("path").text = _editorWindow.project.settingsCenter.publish.filePath;
         }
         else
         {
            contentPane.getChild("path").enabled = true;
            contentPane.getChild("browse1").enabled = true;
         }
      }
      
      private function __pkgCountOptionChanged(param1:Event) : void
      {
         if(contentPane.getChild("useGlobalPkgCount").asButton.selected)
         {
            contentPane.getChild("packageCount").enabled = false;
            contentPane.getChild("packageCount").asComboBox.value = "" + _editorWindow.project.settingsCenter.publish.packageCount;
         }
         else
         {
            contentPane.getChild("packageCount").enabled = true;
         }
      }
      
      private function __openGlobalSettings(param1:Event) : void
      {
         this.save();
         this._global.selectedIndex = this._global.selectedIndex == 1?0:1;
         if(this._global.selectedIndex == 0)
         {
            this.setToUI();
         }
      }
      
      private function __openAtlasSettings(param1:Event) : void
      {
         AtlasSettingsDialog(_editorWindow.getDialog(AtlasSettingsDialog)).open(this._selectedPkg);
      }
      
      private function __openExcludedSettings(param1:Event) : void
      {
         ExcludedResoucesEditDialog(_editorWindow.getDialog(ExcludedResoucesEditDialog)).open(this._selectedPkg);
      }
   }
}

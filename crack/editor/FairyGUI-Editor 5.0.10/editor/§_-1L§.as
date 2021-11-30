package fairygui.editor
{
   import §_-2F§.ConsoleView;
   import §_-2F§.FavoritesView;
   import §_-2F§.HierarchyView;
   import §_-2F§.InspectorView;
   import §_-2F§.LibraryView;
   import §_-2F§.MainView;
   import §_-2F§.PreviewView;
   import §_-2F§.ReferenceView;
   import §_-2F§.SearchView;
   import §_-2F§.TestView;
   import §_-2F§.TransitionListView;
   import §_-2F§.§_-Lm§;
   import §_-6v§.TimelineView;
   import §_-An§.DocumentView;
   import §_-Ds§.AlertDialog;
   import §_-Ds§.ConfirmDialog;
   import §_-Ds§.InputDialog;
   import §_-Ds§.PreferencesDialog;
   import §_-Ds§.RegisterNoticeDialog;
   import §_-Ds§.UpgradeDialog;
   import §_-Ds§.WaitingDialog;
   import §_-Gs§.ViewGrid;
   import §_-Gs§.§_-2t§;
   import §_-Gs§.§_-44§;
   import §_-Gs§.§_-4U§;
   import §_-Gs§.§_-6j§;
   import §_-Gs§.§_-Al§;
   import §_-Gs§.§_-Fl§;
   import §_-Gs§.§_-LG§;
   import §_-Gs§.§_-OH§;
   import §_-NY§.ProjectRefreshHandler;
   import §_-NY§.§_-8G§;
   import §_-NY§.§_-PC§;
   import §_-Pz§.§_-JP§;
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.GRoot;
   import fairygui.RelationType;
   import fairygui.TextInputHistory;
   import fairygui.Window;
   import fairygui.editor.api.EditorEvent;
   import fairygui.editor.api.IConsoleView;
   import fairygui.editor.api.ICursorManager;
   import fairygui.editor.api.IDocument;
   import fairygui.editor.api.IDocumentView;
   import fairygui.editor.api.IDragManager;
   import fairygui.editor.api.IEditor;
   import fairygui.editor.api.IInspectorView;
   import fairygui.editor.api.ILibraryView;
   import fairygui.editor.api.IMenu;
   import fairygui.editor.api.IResourceImportQueue;
   import fairygui.editor.api.ITestView;
   import fairygui.editor.api.ITimelineView;
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.api.IUIProject;
   import fairygui.editor.api.IViewManager;
   import fairygui.editor.api.IWorkspaceSettings;
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.gui.FProject;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.settings.LocalStore;
   import fairygui.editor.settings.WorkspaceSettings;
   import fairygui.event.FocusChangeEvent;
   import fairygui.utils.CombineKeyHelper;
   import fairygui.utils.GTimers;
   import fairygui.utils.RuntimeErrorUtil;
   import fairygui.utils.SEventDispatcher;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import flash.desktop.NativeApplication;
   import flash.display.NativeWindow;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class §_-1L§ extends Sprite implements IEditor
   {
       
      
      private var _docView:DocumentView;
      
      private var §_-Bd§:LibraryView;
      
      private var §_-NL§:InspectorView;
      
      private var §_-3o§:TestView;
      
      private var §_-Bt§:PreviewView;
      
      private var §_-2P§:TimelineView;
      
      private var §_-IR§:ConsoleView;
      
      private var §_-8L§:ReferenceView;
      
      private var §_-G8§:MainView;
      
      private var §_-4S§:§_-2t§;
      
      private var §_-N9§:§_-OH§;
      
      private var §_-K8§:§_-LG§;
      
      private var §_-Kz§:§_-Lm§;
      
      private var §_-JN§:PlugInManager;
      
      private var §_-PT§:§_-PC§;
      
      private var §_-Cv§:ProjectRefreshHandler;
      
      private var §_-C6§:NativeWindow;
      
      private var §_-8P§:GRoot;
      
      private var _project:FProject;
      
      private var §_-EN§:§_-Al§;
      
      private var §_-1p§:Dictionary;
      
      private var §_-7n§:Boolean;
      
      private var §_-PZ§:Boolean;
      
      private var §_-KP§:WorkspaceSettings;
      
      private var _dispatcher:SEventDispatcher;
      
      private var §_-OD§:CombineKeyHelper;
      
      private var _focusedObject:GComponent;
      
      private var §_-I7§:GComponent;
      
      private var §_-7P§:Boolean;
      
      private var §_-8v§:int;
      
      private var §_-9V§:String;
      
      private var §_-Mt§:int;
      
      private var §_-Mj§:int;
      
      private var §_-2G§:int;
      
      public function §_-1L§()
      {
         super();
      }
      
      public function get nativeWindow() : NativeWindow
      {
         return this.§_-C6§;
      }
      
      public function get groot() : GRoot
      {
         return this.§_-8P§;
      }
      
      public function get mainPanel() : GComponent
      {
         return this.§_-G8§.panel;
      }
      
      public function get project() : IUIProject
      {
         return this._project;
      }
      
      public function get workspaceSettings() : IWorkspaceSettings
      {
         return this.§_-KP§;
      }
      
      public function get focusedView() : GComponent
      {
         return this._focusedObject;
      }
      
      public function get active() : Boolean
      {
         return this.§_-7n§;
      }
      
      public function get mainView() : MainView
      {
         return this.§_-G8§;
      }
      
      public function get docView() : IDocumentView
      {
         return this._docView;
      }
      
      public function get libView() : ILibraryView
      {
         return this.§_-Bd§;
      }
      
      public function get inspectorView() : IInspectorView
      {
         return this.§_-NL§;
      }
      
      public function get testView() : ITestView
      {
         return this.§_-3o§;
      }
      
      public function get timelineView() : ITimelineView
      {
         return this.§_-2P§;
      }
      
      public function get consoleView() : IConsoleView
      {
         return this.§_-IR§;
      }
      
      public function get menu() : IMenu
      {
         return this.§_-Kz§.root;
      }
      
      public function get viewManager() : IViewManager
      {
         return this.§_-4S§;
      }
      
      public function get dragManager() : IDragManager
      {
         return this.§_-N9§;
      }
      
      public function get cursorManager() : ICursorManager
      {
         return this.§_-K8§;
      }
      
      public function get plugInManager() : PlugInManager
      {
         return this.§_-JN§;
      }
      
      public function get isInputing() : Boolean
      {
         return this.§_-8P§.buttonDown || this.§_-OD§.keyCode != 0;
      }
      
      public function get forPublish() : Boolean
      {
         return this.§_-PZ§;
      }
      
      public function set forPublish(param1:Boolean) : void
      {
         this.§_-PZ§ = param1;
      }
      
      public function create(param1:String, param2:Boolean = false) : void
      {
         var projectPath:String = param1;
         var forPublish:Boolean = param2;
         var stage:Stage = this.stage;
         this.§_-C6§ = stage.nativeWindow;
         stage.frameRate = 24;
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.color = 3684408;
         this.§_-C6§.addEventListener(Event.CLOSING,this.§_-F0§);
         this.§_-C6§.addEventListener(Event.ACTIVATE,this.§_-AK§);
         this.§_-C6§.addEventListener(Event.DEACTIVATE,this.§_-33§);
         this.§_-7n§ = true;
         this.§_-PZ§ = forPublish;
         this.§_-Mj§ = -10000000;
         this.§_-OD§ = new CombineKeyHelper();
         this.§_-OD§.defineKey(38,0,1);
         this.§_-OD§.defineKey(38,39,2);
         this.§_-OD§.defineKey(39,0,3);
         this.§_-OD§.defineKey(39,40,4);
         this.§_-OD§.defineKey(40,0,5);
         this.§_-OD§.defineKey(40,37,6);
         this.§_-OD§.defineKey(37,0,7);
         this.§_-OD§.defineKey(37,38,8);
         this.§_-8P§ = new GRoot();
         addChild(this.§_-8P§.displayObject);
         this.§_-N9§ = new §_-OH§(this);
         this.§_-K8§ = new §_-LG§(this);
         this.§_-EN§ = new §_-Al§(stage);
         if(!this.§_-PZ§)
         {
            this.§_-EN§.§_-D8§(function():void
            {
               start(projectPath);
            });
         }
         else
         {
            this.start(projectPath);
         }
      }
      
      private function start(param1:String) : void
      {
         var projectPath:String = param1;
         this.§_-1p§ = new Dictionary();
         this._dispatcher = new SEventDispatcher();
         this._dispatcher.errorHandler = function(param1:Error):void
         {
            if(§_-IR§)
            {
               §_-IR§.logError(null,param1);
            }
         };
         stage.nativeWindow.title = Consts.strings.text84;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.§_-FA§);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.§_-HF§);
         this.§_-8P§.addEventListener(FocusChangeEvent.CHANGED,this.§_-AB§);
         this.§_-G8§ = new MainView(this);
         this.§_-8P§.addChild(this.§_-G8§.panel);
         this.§_-G8§.panel.setSize(this.§_-8P§.width,this.§_-8P§.height);
         this.§_-G8§.panel.addRelation(this.§_-8P§,RelationType.Size);
         this.§_-J7§();
         this.§_-G8§.§_-Hb§();
         if(projectPath)
         {
            this.openProject(projectPath);
         }
      }
      
      public function openProject(param1:String) : void
      {
         var files:Array = null;
         var i:int = 0;
         var path:String = param1;
         var projectDescFile:File = null;
         var file:File = new File(path);
         if(!file.exists)
         {
            this.alert(Consts.strings.text117);
            return;
         }
         var ew:§_-1L§ = FairyGUIEditor.§_-C§(path);
         if(ew && !this.§_-PZ§)
         {
            ew.nativeWindow.activate();
            NativeApplication.nativeApplication.activate(ew.nativeWindow);
            return;
         }
         if(file.isDirectory)
         {
            files = file.getDirectoryListing();
            i = 0;
            while(i < files.length)
            {
               if(File(files[i]).extension == FProject.FILE_EXT)
               {
                  projectDescFile = files[i];
                  break;
               }
               i++;
            }
            if(!projectDescFile)
            {
               i = 0;
               while(i < files.length)
               {
                  if(files[i].name == "project.xml")
                  {
                     this.confirm(Consts.strings.text312,function():void
                     {
                        UtilsFile.browseForDirectory(Consts.strings.text313,function(param1:File):void
                        {
                           UpgradeDialog(getDialog(UpgradeDialog)).open(File(files[i]).parent,param1);
                        });
                     });
                     return;
                  }
                  i++;
               }
               this.alert(Consts.strings.text117);
               return;
            }
         }
         else
         {
            projectDescFile = file;
         }
         if(this._project)
         {
            this.closeProject();
         }
         this.cursorManager.setWaitCursor(true);
         try
         {
            this._project = new FProject(this);
            this._project.open(projectDescFile);
         }
         catch(err:Error)
         {
            cursorManager.setWaitCursor(false);
            _project = null;
            alert("openProject failed: ",err);
            return;
         }
         this.§_-FR§();
         if(this._project.type == "Flash")
         {
            stage.frameRate = 24;
         }
         else
         {
            stage.frameRate = 60;
         }
         stage.nativeWindow.title = this.project.name;
         this.§_-JN§ = new PlugInManager(this);
         this.§_-4S§ = new §_-2t§(this);
         this.§_-KP§ = new WorkspaceSettings(this);
         this.§_-PT§ = new §_-PC§(this);
         this.§_-Cv§ = new ProjectRefreshHandler(this);
         this.§_-Et§();
         §_-JP§.§_-7g§(this);
         this.§_-G8§.panel.getChild("holder").asGraph.replaceMe(GComponent(this.§_-4S§));
         this.§_-G8§.panel.getController("start").selectedIndex = 0;
         this.§_-Kz§.§_-Jp§();
         try
         {
            this.§_-KP§.load();
            this.§_-4S§.§_-9§();
         }
         catch(err:Error)
         {
            §_-IR§.logError(null,err);
         }
         GTimers.inst.step();
         if(Capabilities.isDebugger)
         {
            this.§_-4S§.showView("fairygui.DebugView");
         }
         this.§_-JN§.load(this.§_-8m§);
      }
      
      private function §_-8m§() : void
      {
         this.§_-8v§ = this._project.lastChanged;
         addEventListener(Event.ENTER_FRAME,this.§_-2v§);
         try
         {
            this.emit(EditorEvent.ProjectOpened);
            GTimers.inst.step();
         }
         catch(err:Error)
         {
            §_-IR§.logError(null,err);
         }
         this.cursorManager.setWaitCursor(false);
      }
      
      public function closeProject() : void
      {
         var k:Object = null;
         if(!this._project)
         {
            return;
         }
         try
         {
            this.emit(EditorEvent.ProjectClosed);
         }
         catch(err:Error)
         {
         }
         removeEventListener(Event.ENTER_FRAME,this.§_-2v§);
         for(k in this.§_-1p§)
         {
            this.§_-1p§[k].dispose();
         }
         this._project.close();
         if(!this.§_-PZ§)
         {
            this.§_-4S§.§_-U§();
         }
         this.§_-JN§.dispose();
         this.§_-PT§.dispose();
         this.§_-Cv§.dispose();
         this.§_-4S§.dispose();
         this.§_-8P§.closeAllWindows();
         this.§_-8P§.hidePopup();
         this.§_-8P§.hideTooltips();
         this.§_-8P§.removeChildren(0,-1,true);
         if(!this.§_-PZ§)
         {
            try
            {
               this.§_-KP§.save();
            }
            catch(err:Error)
            {
            }
         }
         this._project = null;
         this.§_-1p§ = null;
         this.§_-KP§ = null;
         this.§_-JN§ = null;
         this.§_-4S§ = null;
         if(!this.§_-7P§)
         {
            this.start(null);
         }
      }
      
      public function refreshProject() : void
      {
         this.§_-Cv§.run();
      }
      
      public function showPreview(param1:FPackageItem) : void
      {
         if(param1 && param1.owner.project != this._project)
         {
            return;
         }
         this.§_-Bt§.show(param1);
      }
      
      public function findReference(param1:String) : void
      {
         this.§_-4S§.showView("fairygui.ReferenceView");
         this.§_-8L§.open(param1);
      }
      
      public function importResource(param1:IUIPackage) : IResourceImportQueue
      {
         return new §_-8G§(param1);
      }
      
      public function getActiveFolder() : FPackageItem
      {
         var _loc1_:FPackageItem = this.§_-Bd§.getSelectedFolder();
         if(this.§_-Bd§ == this.§_-I7§)
         {
            if(_loc1_ != null)
            {
               return _loc1_;
            }
         }
         var _loc2_:IDocument = this._docView.activeDocument;
         if(_loc2_)
         {
            return _loc2_.packageItem.parent;
         }
         if(_loc1_)
         {
            return _loc1_;
         }
         if(this._project.allPackages.length > 0)
         {
            return this._project.allPackages[0].rootItem;
         }
         return null;
      }
      
      public function queryToClose() : void
      {
         if(this._project)
         {
            this.docView.queryToSaveAllDocuments(function(param1:String):void
            {
               if(param1 != "cancel")
               {
                  close();
               }
               else
               {
                  FairyGUIEditor.§_-PI§ = false;
               }
            });
         }
         else
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         this.§_-7P§ = true;
         this.closeProject();
         this.§_-EN§.dispose();
         stage.nativeWindow.close();
      }
      
      public function emit(param1:String, param2:* = undefined) : void
      {
         this._dispatcher.emit(param1,param2);
      }
      
      public function on(param1:String, param2:Function) : void
      {
         this._dispatcher.on(param1,param2);
      }
      
      public function off(param1:String, param2:Function) : void
      {
         this._dispatcher.off(param1,param2);
      }
      
      public function alert(param1:String, param2:Error = null, param3:Function = null) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         if(param2)
         {
            if(param2.errorID != 0)
            {
               if(this.§_-IR§)
               {
                  this.§_-IR§.logError(param1,param2);
               }
            }
            if(param1)
            {
               param1 = param1 + "\n";
            }
            if(param2.errorID == 0)
            {
               param1 = param1 + param2.message;
            }
            else
            {
               param1 = param1 + RuntimeErrorUtil.toString(param2);
            }
         }
         AlertDialog(this.getDialog(AlertDialog)).open(param1,param3);
      }
      
      public function confirm(param1:String, param2:Function) : void
      {
         ConfirmDialog(this.getDialog(ConfirmDialog)).open(param1,param2);
      }
      
      public function input(param1:String, param2:String, param3:Function) : void
      {
         InputDialog(this.getDialog(InputDialog)).open(param1,param2,param3);
      }
      
      public function showWaiting(param1:String = null, param2:Function = null) : void
      {
         WaitingDialog(this.getDialog(WaitingDialog)).open(param1,param2);
      }
      
      public function closeWaiting() : void
      {
         WaitingDialog(this.getDialog(WaitingDialog)).hide();
      }
      
      private function §_-F0§(param1:Event) : void
      {
         param1.preventDefault();
         this.queryToClose();
      }
      
      private function §_-AK§(param1:Event) : void
      {
         this.§_-7n§ = true;
         this.§_-8v§ = 0;
         if(Consts.isMacOS && this.§_-Kz§)
         {
            NativeApplication.nativeApplication.menu = §_-6j§(this.§_-Kz§.root).realMenu;
         }
      }
      
      private function §_-33§(param1:Event) : void
      {
         this.§_-7n§ = false;
      }
      
      public function getDialog(param1:Object) : Window
      {
         var _loc2_:Window = this.§_-1p§[param1] as Window;
         if(!_loc2_)
         {
            _loc2_ = new param1(this);
            this.§_-1p§[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      private function §_-FR§() : void
      {
         var _loc1_:Array = LocalStore.data.recent_project;
         if(!_loc1_)
         {
            _loc1_ = [];
         }
         if(_loc1_.length % 2 != 0)
         {
            _loc1_.length = 0;
            delete LocalStore.data.recent_project;
         }
         var _loc2_:int = _loc1_.indexOf(this._project.basePath);
         if(_loc2_ != -1)
         {
            _loc1_.splice(_loc2_ - 1,2);
         }
         _loc1_.push(this._project.name,this._project.basePath);
         if(_loc1_.length > 40)
         {
            _loc1_.splice(0,_loc1_.length - 40);
         }
         LocalStore.data.recent_project = _loc1_;
         LocalStore.setDirty("recent_project");
      }
      
      private function §_-2v§(param1:Event) : void
      {
         if(this.§_-8v§ != this._project.lastChanged)
         {
            this.§_-8v§ = this._project.lastChanged;
            this.emit(EditorEvent.Validate);
         }
         this.emit(EditorEvent.OnUpdate);
         this.emit(EditorEvent.OnLateUpdate);
      }
      
      private function §_-FA§(param1:KeyboardEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:§_-4U§ = null;
         var _loc2_:String = §_-44§.§_-Pb§(param1);
         if(param1.target is TextField && TextField(param1.target).type == TextFieldType.INPUT)
         {
            if(_loc2_ == "0007")
            {
               TextInputHistory.inst.undo(TextField(param1.target));
               param1.preventDefault();
            }
            else if(_loc2_ == "0008")
            {
               TextInputHistory.inst.redo(TextField(param1.target));
               param1.preventDefault();
            }
            else if(_loc2_ == "0112")
            {
               param1.preventDefault();
            }
            else if(param1.keyCode == Keyboard.ESCAPE)
            {
               this.§_-8P§.nativeStage.focus = null;
            }
            return;
         }
         param1.preventDefault();
         this.§_-OD§.onKeyDown(param1);
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            if(this.§_-8P§.hasAnyPopup)
            {
               this.§_-8P§.hidePopup();
               return;
            }
            if(this.§_-N9§.dragging)
            {
               this.§_-N9§.cancel();
               return;
            }
            if(this.§_-3o§ && this.§_-3o§.running)
            {
               this.§_-3o§.stop();
               return;
            }
         }
         if(PreferencesDialog(this.getDialog(PreferencesDialog)).swallowKeyEvent(param1))
         {
            return;
         }
         if(_loc2_ != null)
         {
            if(this.§_-G8§.§_-L4§(_loc2_))
            {
               _loc2_ = null;
            }
            this.§_-9V§ = null;
         }
         else if(!param1.ctrlKey && !param1.commandKey && !param1.altKey && param1.charCode >= 48 && param1.charCode <= 122)
         {
            _loc3_ = getTimer();
            if(this.§_-9V§ != null && _loc3_ - this.§_-Mt§ < 600)
            {
               this.§_-9V§ = this.§_-9V§ + String.fromCharCode(param1.charCode).toLowerCase();
            }
            else
            {
               this.§_-9V§ = String.fromCharCode(param1.charCode).toLowerCase();
            }
            this.§_-Mt§ = _loc3_;
         }
         else
         {
            this.§_-9V§ = null;
         }
         if(this._focusedObject)
         {
            _loc4_ = new §_-4U§(§_-4U§.§_-76§,param1,this.§_-OD§.keyCode,_loc2_,this.§_-9V§);
            this._focusedObject.dispatchEvent(_loc4_);
            if(_loc4_.isDefaultPrevented())
            {
               param1.preventDefault();
            }
         }
      }
      
      private function §_-HF§(param1:KeyboardEvent) : void
      {
         this.§_-OD§.onKeyUp(param1);
      }
      
      private function §_-AB§(param1:FocusChangeEvent) : void
      {
         var _loc6_:GComponent = null;
         var _loc7_:FocusChangeEvent = null;
         var _loc2_:GObject = param1.newFocusedObject;
         var _loc3_:GComponent = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         while(_loc2_ != null && _loc2_ != this.§_-8P§)
         {
            if(_loc2_ is ViewGrid)
            {
               _loc3_ = ViewGrid(_loc2_).selectedView;
               _loc4_ = true;
               break;
            }
            if(_loc2_ is Window)
            {
               _loc3_ = Window(_loc2_);
               _loc5_ = true;
               break;
            }
            if(_loc2_ == this.§_-G8§.panel)
            {
               if(this._focusedObject is Window)
               {
                  _loc3_ = this.§_-G8§.panel;
                  break;
               }
            }
            _loc2_ = _loc2_.parent;
         }
         if(_loc3_ != null)
         {
            if(this._focusedObject != _loc3_)
            {
               _loc6_ = this._focusedObject;
               this._focusedObject = _loc3_;
               if(_loc4_)
               {
                  this.§_-I7§ = _loc3_;
               }
               Sprite(this.§_-G8§.panel.displayObject).tabChildren = !_loc5_;
               Sprite(this._focusedObject.displayObject).tabChildren = true;
               if(_loc6_)
               {
                  Sprite(_loc6_.displayObject).tabChildren = false;
               }
               _loc7_ = new FocusChangeEvent(FocusChangeEvent.CHANGED,_loc6_,_loc3_);
               if(_loc6_ && !_loc6_.isDisposed)
               {
                  _loc6_.dispatchEvent(_loc7_);
               }
               _loc3_.dispatchEvent(_loc7_);
            }
         }
      }
      
      private function §_-J7§() : void
      {
         var _loc1_:IMenu = null;
         if(Consts.isMacOS)
         {
            _loc1_ = new §_-6j§();
            NativeApplication.nativeApplication.menu = §_-6j§(_loc1_).realMenu;
            this.§_-G8§.panel.getController("menu").selectedIndex = 1;
         }
         else
         {
            _loc1_ = new §_-Fl§(this.§_-G8§.panel.getChild("menuBar").asCom);
         }
         this.§_-Kz§ = new §_-Lm§(this,_loc1_);
         this.§_-Kz§.§_-Jm§();
      }
      
      public function checkRegisterStatus() : void
      {
         if(UtilsStr.startsWith(this._project.name,"FairyGUI"))
         {
            return;
         }
         if(this._project.allPackages.length <= 2)
         {
            return;
         }
         this.§_-2G§++;
         var now:int = getTimer();
         if(this.§_-2G§ > 10 && now - this.§_-Mj§ > 180000)
         {
            this.§_-Mj§ = now;
            this.§_-2G§ = 0;
            try
            {
               this.getDialog(RegisterNoticeDialog).show();
               return;
            }
            catch(err:Error)
            {
               nativeWindow.close();
               return;
            }
         }
      }
      
      private function §_-Et§() : void
      {
         this.§_-Bd§ = LibraryView(this.§_-4S§.addView(LibraryView,"fairygui.LibraryView",Consts.strings.text409,"ui://Builder/panel_lib",{
            "vResizePiority":200,
            "location":"left"
         }));
         this.§_-NL§ = InspectorView(this.§_-4S§.addView(InspectorView,"fairygui.InspectorView",Consts.strings.text410,"ui://Builder/panel_inspector",{"location":"right"}));
         this.§_-4S§.addView(HierarchyView,"fairygui.HierarchyView",Consts.strings.text412,"ui://Builder/panel_hierarchy",{
            "vResizePiority":150,
            "location":"left"
         });
         this.§_-Bt§ = PreviewView(this.§_-4S§.addView(PreviewView,"fairygui.PreviewView",Consts.strings.text413,"ui://Builder/panel_preview",{"location":"left"}));
         this.§_-2P§ = TimelineView(this.§_-4S§.addView(TimelineView,"fairygui.TimelineView",Consts.strings.text411,"ui://Builder/panel_timeline",{
            "vResizePiority":300,
            "location":"bottom"
         }));
         this.§_-4S§.addView(TransitionListView,"fairygui.TransitionListView",Consts.strings.text322,"ui://Builder/panel_transitions",{"location":"left"});
         this.§_-4S§.addView(FavoritesView,"fairygui.FavoritesView",Consts.strings.text424,"ui://Builder/panel_favorite",{
            "vResizePiority":200,
            "location":"left"
         });
         this.§_-4S§.addView(SearchView,"fairygui.SearchView",Consts.strings.text425,"ui://Builder/panel_search",{
            "vResizePiority":100,
            "location":"left"
         });
         this.§_-IR§ = ConsoleView(this.§_-4S§.addView(ConsoleView,"fairygui.ConsoleView",Consts.strings.text426,"ui://Builder/panel_console",{
            "vResizePiority":100,
            "location":"right"
         }));
         this.§_-8L§ = ReferenceView(this.§_-4S§.addView(ReferenceView,"fairygui.ReferenceView",Consts.strings.text434,"ui://Builder/panel_reference",{
            "vResizePiority":100,
            "location":"right"
         }));
         this._docView = DocumentView(this.§_-4S§.addView(DocumentView,"fairygui.DocumentView",null,null,{
            "hResizePiority":int.MAX_VALUE,
            "vResizePiority":int.MAX_VALUE
         }));
         this.§_-3o§ = TestView(this.§_-4S§.addView(TestView,"fairygui.TestView",null,null,{
            "hResizePiority":int.MAX_VALUE,
            "vResizePiority":int.MAX_VALUE
         }));
      }
   }
}

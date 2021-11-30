package fairygui.editor
{
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.GRoot;
   import fairygui.Window;
   import fairygui.editor.cache.CacheManager;
   import fairygui.editor.dialogs.AlertDialog;
   import fairygui.editor.dialogs.ConfirmDialog;
   import fairygui.editor.dialogs.WaitingDialog;
   import fairygui.editor.extui.ColorPicker;
   import fairygui.editor.extui.ColorPresetMenu;
   import fairygui.editor.extui.CursorManager;
   import fairygui.editor.extui.DragManager;
   import fairygui.editor.extui.FontSizePresetMenu;
   import fairygui.editor.extui.ResourceInputMenu;
   import fairygui.editor.extui.ScreenColorPickerManager;
   import fairygui.editor.extui.SelectControllerMenu;
   import fairygui.editor.extui.SelectMultiplePageMenu;
   import fairygui.editor.extui.SelectPageMenu;
   import fairygui.editor.extui.SelectTransitionMenu;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.pack.BinPackManager;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.utils.RuntimeErrorUtil;
   import fairygui.utils.GTimers;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   
   public class EditorWindow extends Sprite
   {
      
      private static var _instances:Dictionary = new Dictionary();
       
      
      public var project:EUIProject;
      
      public var mainPanel:MainPanel;
      
      public var groot:GRoot;
      
      public var windowState:WindowState;
      
      public var dragManager:DragManager;
      
      public var cursorManager:CursorManager;
      
      public var screenColorPickerManager:ScreenColorPickerManager;
      
      public var plugInManager:PlugInManager;
      
      public var binPackManager:BinPackManager;
      
      public var cacheManager:CacheManager;
      
      public var resourceInputMenu:ResourceInputMenu;
      
      public var colorPresetMenu:ColorPresetMenu;
      
      public var fontSizePresetMenu:FontSizePresetMenu;
      
      public var selectMultiplePageMenu:SelectMultiplePageMenu;
      
      public var selectPageMenu:SelectPageMenu;
      
      public var selectTransitionMenu:SelectTransitionMenu;
      
      public var selectControllerMenu:SelectControllerMenu;
      
      public var colorPicker:ColorPicker;
      
      public var active:Boolean;
      
      public var onlyForPublish:Boolean;
      
      private var _dialogs:Dictionary;
      
      private var _alertDialog:AlertDialog;
      
      private var _confirmDialog:ConfirmDialog;
      
      public function EditorWindow()
      {
         super();
         this._dialogs = new Dictionary();
      }
      
      public static function getInstance(param1:GObject) : EditorWindow
      {
         return _instances[GComponent(param1).root.nativeStage];
      }
      
      public function getDialog(param1:Object) : Window
      {
         var _loc2_:Window = this._dialogs[param1];
         if(!_loc2_)
         {
            _loc2_ = new param1(this);
            this._dialogs[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function init(param1:File) : void
      {
         param1 = param1;
         var projectDescFile:File = param1;
         stage.frameRate = 24;
         stage.align = "TL";
         stage.scaleMode = "noScale";
         stage.color = 3684408;
         this.active = true;
         _instances[stage] = this;
         this.windowState = new WindowState(stage);
         if(!this.onlyForPublish)
         {
            this.windowState.initAndRestore(function():void
            {
               onWindowReady(projectDescFile);
            });
         }
         else
         {
            this.onWindowReady(projectDescFile);
         }
      }
      
      private function onWindowReady(param1:File) : void
      {
         this.project = new EUIProject(this);
         this._alertDialog = new AlertDialog();
         this._confirmDialog = new ConfirmDialog();
         this.groot = new GRoot();
         addChild(this.groot.displayObject);
         this.dragManager = new DragManager(this);
         this.cursorManager = new CursorManager(this);
         this.screenColorPickerManager = new ScreenColorPickerManager(this);
         this.plugInManager = new PlugInManager(this);
         this.cacheManager = new CacheManager(this);
         this.binPackManager = new BinPackManager(this);
         this.resourceInputMenu = new ResourceInputMenu(this);
         this.colorPresetMenu = new ColorPresetMenu(this);
         this.fontSizePresetMenu = new FontSizePresetMenu(this);
         this.selectTransitionMenu = new SelectTransitionMenu(this);
         this.selectControllerMenu = new SelectControllerMenu(this);
         this.selectPageMenu = new SelectPageMenu(this);
         this.selectMultiplePageMenu = new SelectMultiplePageMenu(this);
         this.colorPicker = new ColorPicker(this);
         this.mainPanel = new MainPanel(this);
         this.groot.addChild(this.mainPanel.self);
         this.mainPanel.create(param1);
         if(this.project.type == "Flash")
         {
            stage.frameRate = 24;
         }
         else
         {
            stage.frameRate = 60;
         }
         if(!this.onlyForPublish)
         {
            stage.nativeWindow.addEventListener("closing",this.onClosingWin);
            stage.nativeWindow.addEventListener("activate",this.onActivate);
            stage.nativeWindow.addEventListener("deactivate",this.onDeactivate);
            if(ClassEditor.newVersionPrompt)
            {
               GTimers.inst.add(3000,1,this.showNewVersionPrompt);
            }
         }
      }
      
      public function close() : void
      {
         this.mainPanel.editPanel.saveAllDocuments();
         this.mainPanel.closeProject();
      }
      
      public function alert(param1:String, param2:Function = null) : void
      {
         this._alertDialog.open(this.groot,param1,param2);
      }
      
      public function alertError(param1:Error, param2:Function = null) : void
      {
         this._alertDialog.open(this.groot,RuntimeErrorUtil.toString(param1),param2);
      }
      
      public function confirm(param1:String, param2:Function) : void
      {
         this._confirmDialog.open(this.groot,param1,param2);
      }
      
      public function showWaiting(param1:String = null, param2:Function = null) : void
      {
         WaitingDialog(this.getDialog(WaitingDialog)).open(param1,param2);
      }
      
      public function closeWaiting() : void
      {
         WaitingDialog(this.getDialog(WaitingDialog)).hide();
      }
      
      public function get activeComDocument() : ComDocument
      {
         return this.mainPanel.editPanel.activeDocument as ComDocument;
      }
      
      public function playSound(param1:String, param2:int) : void
      {
         var _loc3_:EPackageItem = this.project.getItemByURL(param1);
         if(_loc3_)
         {
            _loc3_.callbackParam = param2;
            _loc3_.owner.getSound(_loc3_,this.playSound2);
         }
      }
      
      private function playSound2(param1:EPackageItem) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sound = Sound(param1.data);
         if(_loc3_)
         {
            _loc2_ = param1.callbackParam;
            if(_loc2_ == 0)
            {
               _loc3_.play();
            }
            else
            {
               _loc3_.play(0,0,new SoundTransform(_loc2_ / 100));
            }
         }
      }
      
      public function showNewVersionPrompt() : void
      {
         if(ClassEditor.newVersionPrompt)
         {
            ClassEditor.newVersionPrompt = false;
            this.mainPanel.showNewVersionPrompt();
         }
      }
      
      private function onClosingWin(param1:Event) : void
      {
         param1.preventDefault();
         if(this.project.opened)
         {
            this.mainPanel.checkBeforeQuit();
         }
         else
         {
            stage.nativeWindow.close();
         }
      }
      
      private function onActivate(param1:Event) : void
      {
         this.active = true;
         this.mainPanel.editPanel.refreshDocument();
      }
      
      private function onDeactivate(param1:Event) : void
      {
         this.active = false;
      }
   }
}

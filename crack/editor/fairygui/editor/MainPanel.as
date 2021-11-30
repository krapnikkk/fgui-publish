package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.TextInputHistory;
   import fairygui.UIPackage;
   import fairygui.Window;
   import fairygui.display.UISprite;
   import fairygui.editor.dialogs.AboutDialog;
   import fairygui.editor.dialogs.CreatePackageDialog;
   import fairygui.editor.dialogs.CropQueryDialog;
   import fairygui.editor.dialogs.DragonBoneClipEditDialog;
   import fairygui.editor.dialogs.ExportPackageDialog;
   import fairygui.editor.dialogs.FindReferenceDialog;
   import fairygui.editor.dialogs.FontEditDialog;
   import fairygui.editor.dialogs.ImageEditDialog;
   import fairygui.editor.dialogs.ImportPackageDialog;
   import fairygui.editor.dialogs.ImportProgressDialog;
   import fairygui.editor.dialogs.MovieClipEditDialog;
   import fairygui.editor.dialogs.MultiImageEditDialog;
   import fairygui.editor.dialogs.PackageSettingsDialog;
   import fairygui.editor.dialogs.PlugInManageDialog;
   import fairygui.editor.dialogs.PreferencesDialog;
   import fairygui.editor.dialogs.ProjectSettingsDialog;
   import fairygui.editor.dialogs.PublishDialog;
   import fairygui.editor.dialogs.StringsFunctionDialog;
   import fairygui.editor.dialogs.insert.CreateButtonDialog;
   import fairygui.editor.dialogs.insert.CreateComDialog;
   import fairygui.editor.dialogs.insert.CreateComboBoxDialog;
   import fairygui.editor.dialogs.insert.CreateFontDialog;
   import fairygui.editor.dialogs.insert.CreateFyMoiveDialog;
   import fairygui.editor.dialogs.insert.CreateLabelDialog;
   import fairygui.editor.dialogs.insert.CreateMovieClipDialog;
   import fairygui.editor.dialogs.insert.CreatePopupMenuDialog;
   import fairygui.editor.dialogs.insert.CreateProgressBarDialog;
   import fairygui.editor.dialogs.insert.CreateScrollBarDialog;
   import fairygui.editor.dialogs.insert.CreateSliderDialog;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.CursorManager;
   import fairygui.editor.extui.MenuBar;
   import fairygui.editor.extui.ResourceInput;
   import fairygui.editor.extui.SubmitEvent;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.props.PropsPanelList;
   import fairygui.editor.settings.Preferences;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.editor.settings.WorkSpace;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.RuntimeErrorUtil;
   import fairygui.editor.utils.UploadPPT;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.FocusChangeEvent;
   import fairygui.utils.GTimers;
   import flash.desktop.NativeDragManager;
   import flash.desktop.NativeProcess;
   import flash.desktop.NativeProcessStartupInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.NativeDragEvent;
   import flash.filesystem.File;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.FileFilter;
   import flash.text.TextField;
   
   public class MainPanel
   {
       
      
      public var self:GComponent;
      
      public var libPanel:LibPanel;
      
      public var previewPanel:PreviewPanel;
      
      public var editPanel:EditPanel;
      
      public var testPanel:TestPanel;
      
      public var propsPanelList:PropsPanelList;
      
      public var childrenPanel:ChildrenPanel;
      
      public var menuBar:MenuBar;
      
      public var libPanelResizer:GObject;
      
      public var libPanelResizerV:GObject;
      
      public var newVersionPrompt:GComponent;
      
      public var toolbox:GObject;
      
      private var _fileMenu:PopupMenu;
      
      private var _editMenu:PopupMenu;
      
      private var _assetsMenu:PopupMenu;
      
      private var _toolMenu:PopupMenu;
      
      private var _helpMenu:PopupMenu;
      
      private var _pubMenu:PopupMenu;
      
      private var _bgColorInput:ColorInput;
      
      private var _bgColorInput2:ColorInput;
      
      private var _viewScaleCombo:GComboBox;
      
      private var _viewScale:Number;
      
      private var _warningsButton:GButton;
      
      private var _libPanelActive:Boolean;
      
      private var _editPanelActive:Boolean;
      
      private var _selfActive:Boolean;
      
      private var _keyStatus:int;
      
      private var _arrowKeyCodes:Array;
      
      private var _keysCount:int;
      
      private var _keyMapping:Object;
      
      private var _editorWindow:EditorWindow;
      
      private var _publicEgretBtn:GButton;
      
      private var _publicEgretBtn1:GButton;
      
      public function MainPanel(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this.self = UIPackage.createObject("Builder","MainPanel").asCom;
         this.self.setSize(this._editorWindow.groot.width,this._editorWindow.groot.height);
         this.self.addRelation(this._editorWindow.groot,24);
      }
      
      public function create(param1:File) : void
      {
         param1 = param1;
         var newY:Number = NaN;
         var newHeight:Number = NaN;
         var projectDescFile:File = param1;
         this.menuBar = new MenuBar(this.self.getChild("menuBar").asCom.getChild("list").asList);
         this.setupMenuBar();
         this.setupArrowKeys();
         this.libPanel = new LibPanel(this._editorWindow,this.self.getChild("libPanel").asCom);
         this.previewPanel = new PreviewPanel(this._editorWindow,this.self.getChild("previewPanel").asCom);
         this.editPanel = new EditPanel(this._editorWindow,this.self.getChild("editPanel").asCom);
         this.propsPanelList = new PropsPanelList(this._editorWindow,this.self.getChild("propPanelList").asList);
         this.testPanel = new TestPanel(this._editorWindow,this.self.getChild("testPanel").asCom);
         this.childrenPanel = new ChildrenPanel(this._editorWindow,this.self.getChild("childrenPanel").asCom);
         this.libPanel.self.focusable = true;
         this.editPanel.self.focusable = true;
         this.propsPanelList.self.focusable = true;
         this.childrenPanel.self.focusable = true;
         this._editorWindow.groot.addEventListener("focusChanged",this.__focusChanged);
         this.libPanelResizer = this.self.getChild("libPanelResizer");
         this.libPanelResizer.draggable = true;
         this._editorWindow.cursorManager.setCursorForObject(this.libPanelResizer.displayObject,CursorManager.H_RESIZE);
         var pt:Point = this.libPanelResizer.localToGlobal();
         var rect:Rectangle = new Rectangle(pt.x,pt.y,pt.x + this.libPanel.self.initWidth,pt.y);
         this.libPanelResizer.dragBounds = rect;
         var libPanelWidth:int = LocalStore.data.libPanelWidth;
         if(libPanelWidth > 0)
         {
            this.libPanelResizer.x = this.libPanelResizer.x + (libPanelWidth - this.libPanel.self.initWidth);
         }
         this.libPanelResizerV = this.self.getChild("libPanelResizerV");
         this.libPanelResizerV.draggable = true;
         this._editorWindow.cursorManager.setCursorForObject(this.libPanelResizerV.displayObject,CursorManager.V_RESIZE);
         var libPanelResizerY:int = LocalStore.data.libPanelResizerY;
         if(libPanelResizerY < this.previewPanel.self.height + 100)
         {
            libPanelResizerY = this.previewPanel.self.height + 100;
         }
         if(libPanelResizerY > 0)
         {
            newY = this.self.height - libPanelResizerY + 4;
            if(newY < 100)
            {
               newY = 100;
            }
            newHeight = this.childrenPanel.self.height + this.childrenPanel.self.y - newY;
            if(newHeight > 100)
            {
               this.childrenPanel.self.y = newY;
               this.childrenPanel.self.height = newHeight;
            }
         }
         var recalculateDragBounds:Function = function():void
         {
            libPanelResizerV.dragBounds.y = libPanel.self.localToGlobal(0,0).y + 100;
            libPanelResizerV.dragBounds.bottom = childrenPanel.self.localToGlobal(0,childrenPanel.self.height).y - 100;
         };
         var vResizerMoved:Function = function():void
         {
            if(libPanelResizerV.relations.handling != null)
            {
               return;
            }
            var _loc1_:Number = childrenPanel.self.y;
            childrenPanel.self.y = libPanelResizerV.y + libPanelResizerV.height;
            childrenPanel.self.height = childrenPanel.self.height + (_loc1_ - childrenPanel.self.y);
         };
         pt = this.libPanelResizerV.localToGlobal();
         rect = new Rectangle(pt.x,pt.y,pt.x,pt.y);
         this.libPanelResizerV.dragBounds = rect;
         recalculateDragBounds();
         this.childrenPanel.self.addSizeChangeCallback(recalculateDragBounds);
         this.childrenPanel.self.addXYChangeCallback(recalculateDragBounds);
         this.libPanelResizerV.addXYChangeCallback(vResizerMoved);
         this.propsPanelList.refresh();
         this._bgColorInput = ColorInput(this.self.getChild("bgColor"));
         this._bgColorInput.showAlpha = false;
         this._bgColorInput.addEventListener("__submit",this.__bgColorChanged);
         this._bgColorInput2 = ColorInput(this.self.getChild("bgColor2"));
         this._bgColorInput2.showAlpha = false;
         this._bgColorInput2.addEventListener("__submit",this.__bgColorChanged);
         this._viewScaleCombo = this.self.getChild("viewScale").asComboBox;
         this._viewScaleCombo.items = ["25%","50%","100%","150%","200%","300%","400%","800%"];
         this._viewScaleCombo.selectedIndex = 2;
         this._viewScaleCombo.visibleItemCount = 20;
         this._viewScaleCombo.addEventListener("stateChanged",this.__viewScaleChanged);
         this.newVersionPrompt = this.self.getChild("newVersionPrompt").asCom;
         this.newVersionPrompt.getChild("upgrade").addClickListener(this.__upgradeNow);
         this.newVersionPrompt.getChild("later").addClickListener(this.__upgradeLater);
         this.newVersionPrompt.getChild("notes").addClickListener(this.__upgradeNotes);
         this.self.getChild("n45").addClickListener(function(param1:Event):void
         {
            _editorWindow.getDialog(CreateComDialog).show();
         });
         this.self.getChild("n46").addClickListener(function(param1:Event):void
         {
            _editorWindow.getDialog(CreateButtonDialog).show();
         });
         this.self.getChild("n74").addClickListener(function(param1:Event):void
         {
            _editorWindow.getDialog(CreateFontDialog).show();
         });
         this.self.getChild("n75").addClickListener(this.__importResource);
         this.self.getChild("n47").addClickListener(function(param1:Event):void
         {
            editPanel.saveDocument();
         });
         this.self.getChild("n48").addClickListener(function(param1:Event):void
         {
            editPanel.saveAllDocuments();
         });
         this._publicEgretBtn = UIPackage.createObject("Fysheji","PublicIconButon").asButton;
         this._publicEgretBtn.tooltips = "预览白鹭资源";
         this._publicEgretBtn.y = 23;
         this._publicEgretBtn.x = 1130;
         this.self.addChild(this._publicEgretBtn);
         this._publicEgretBtn.addClickListener(this.__runTest_egret);
         this._publicEgretBtn1 = UIPackage.createObject("Fysheji","PublicIconButon").asButton;
         this._publicEgretBtn1.tooltips = "预览横版资源";
         this._publicEgretBtn1.y = 23;
         this._publicEgretBtn1.x = 1165;
         this.self.addChild(this._publicEgretBtn1);
         this._publicEgretBtn1.addClickListener(this.__runTest_egret1);
         var a:* = this.self.getChild("n85");
         this.self.getChild("n85").addClickListener(this.__runTest);
         this.self.getChild("n84").addClickListener(function(param1:Event):void
         {
            PublishDialog(_editorWindow.getDialog(PublishDialog)).openOrPublish();
         });
         this.self.getChild("n87").addClickListener(function(param1:Event):void
         {
            _editorWindow.getDialog(CreateMovieClipDialog).show();
         });
         this.self.getChild("n88").addClickListener(function(param1:Event):void
         {
            _pubMenu.show(self.getChild("n88"));
         });
         this.toolbox = this.self.getChild("toolbox");
         this.toolbox.visible = false;
         this._warningsButton = this.self.getChild("btnWarning").asButton;
         this._warningsButton.changeStateOnClick = false;
         this._warningsButton.addClickListener(function(param1:Event):void
         {
            if(_warningsButton.selected)
            {
               ComDocument(editPanel.activeDocument).clearSelection();
               ComDocument(editPanel.activeDocument).addSelectionByName(ComDocument(editPanel.activeDocument).editingContent.nameConflicts[0]);
            }
         });
         this.self.getChild("btnRelationDisabled").asButton.addEventListener("stateChanged",function(param1:Event):void
         {
            if(editPanel.activeDocument is ComDocument)
            {
               ComDocument(editPanel.activeDocument).editingContent.disabled_relations = GButton(param1.currentTarget).selected;
            }
         });
         this.self.getChild("btnControllerDisabled").asButton.addEventListener("stateChanged",function(param1:Event):void
         {
            if(editPanel.activeDocument is ComDocument)
            {
               ComDocument(editPanel.activeDocument).editingContent.disabled_displayController = GButton(param1.currentTarget).selected;
               ComDocument(editPanel.activeDocument).editingContent.applyAllControllers();
            }
         });
         this.self.getChild("btnLocate").addClickListener(function(param1:Event):void
         {
            if(editPanel.activeDocument is ComDocument)
            {
               _editorWindow.mainPanel.libPanel.highlightItem(ComDocument(editPanel.activeDocument).editingTarget);
            }
         });
         var color:* = LocalStore.data.editor_color;
         if(color == undefined)
         {
            color = 6710886;
         }
         this._bgColorInput.colorValue = color;
         color = LocalStore.data.editor_color2;
         if(color == undefined)
         {
            color = 10066329;
         }
         this._bgColorInput2.colorValue = color;
         this.__bgColorChanged(null);
         this._viewScale = 1;
         this._editorWindow.groot.nativeStage.addEventListener("keyDown",this.__keydown);
         this._editorWindow.groot.nativeStage.addEventListener("keyUp",this.__keyup);
         this._editorWindow.groot.nativeStage.addEventListener("nativeDragEnter",this.__nativeDragEnter);
         this._editorWindow.groot.nativeStage.addEventListener("nativeDragDrop",this.__nativeDragDrop);
         this.openProject(projectDescFile);
      }
      
      public function setupMenuBar() : void
      {
         var btn:GButton = null;
         this._fileMenu = new PopupMenu();
         this._fileMenu.contentPane.width = 280;
         this._fileMenu.addItem(Consts.g.text34 + "...",function():void
         {
            editPanel.queryToSaveAllDocuments(function(param1:int):void
            {
               if(param1 != 2)
               {
                  ClassEditor.createOpenProjectWindow(_editorWindow,true);
               }
            });
         });
         this._fileMenu.addItem(Consts.g.text35 + "...",function():void
         {
            editPanel.queryToSaveAllDocuments(function(param1:int):void
            {
               if(param1 != 2)
               {
                  ClassEditor.createOpenProjectWindow(_editorWindow,false);
               }
            });
         });
         this._fileMenu.addItem(Consts.g.text311 + "...",function():void
         {
            ClassEditor.createOpenProjectWindow(null,false);
         });
         this._fileMenu.addItem(Consts.g.text37 + "...",function():void
         {
            _editorWindow.getDialog(ProjectSettingsDialog).show();
         }).name = "projectSettings";
         this._fileMenu.addSeperator();
         this._fileMenu.addItem(Consts.g.text38 + "..",function():void
         {
            _editorWindow.getDialog(CreatePackageDialog).show();
         }).name = "createPackage";
         this._fileMenu.addItem(Consts.g.text40 + "...",function():void
         {
            _editorWindow.getDialog(PackageSettingsDialog).show();
         }).name = "packageSettings";
         this._fileMenu.addItem(Consts.g.text41 + "...",function():void
         {
            _editorWindow.getDialog(PublishDialog).show();
         }).name = "publish";
         this._fileMenu.addSeperator();
         this._fileMenu.addItem(Consts.g.text226,function():void
         {
            editPanel.queryToSaveAllDocuments(function(param1:int):void
            {
               if(param1 != 2)
               {
                  _editorWindow.stage.nativeWindow.close();
               }
            });
         });
         this.menuBar.addMenu("file",Consts.g.text43,this._fileMenu);
         this._editMenu = new PopupMenu();
         this._editMenu.contentPane.addEventListener("addedToStage",this.__beforeEditMenuPopup);
         this._editMenu.contentPane.width = 280;
         btn = this._editMenu.addItem(Consts.g.text107,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.undo();
            }
         });
         btn.name = "undo";
         btn.getChild("shortcut").text = "Ctrl+Z";
         btn = this._editMenu.addItem(Consts.g.text108,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.redo();
            }
         });
         btn.name = "redo";
         btn.getChild("shortcut").text = "Ctrl+Y";
         this._editMenu.addSeperator();
         btn = this._editMenu.addItem(Consts.g.text1,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.doCut();
            }
         });
         btn.name = "cut";
         btn.getChild("shortcut").text = "Ctrl+X";
         btn = this._editMenu.addItem(Consts.g.text2,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.doCopy();
            }
         });
         btn.name = "copy";
         btn.getChild("shortcut").text = "Ctrl+C";
         btn = this._editMenu.addItem(Consts.g.text104,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.doPaste(null,true);
            }
         });
         btn.name = "paste";
         btn.getChild("shortcut").text = "Ctrl+V";
         btn = this._editMenu.addItem(Consts.g.text105,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.doPaste(null,false);
            }
         });
         btn.name = "paste2";
         btn.getChild("shortcut").text = "Ctrl+Shift+V";
         btn = this._editMenu.addItem(Consts.g.text4,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.doDelete();
            }
         });
         btn.name = "delete";
         btn.getChild("shortcut").text = "Backspace";
         this._editMenu.addSeperator();
         btn = this._editMenu.addItem(Consts.g.text5,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.doSelectAll();
            }
         });
         btn.name = "selectAll";
         btn.getChild("shortcut").text = "Ctrl+A";
         btn = this._editMenu.addItem(Consts.g.text23,function():void
         {
            var _loc1_:* = editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               _loc1_.doUnselectAll();
            }
         });
         btn.name = "unselectAll";
         btn.getChild("shortcut").text = "Ctrl+Shift+A";
         this._editMenu.addSeperator();
         this._editMenu.addItem(Consts.g.text42 + "...",function():void
         {
            _editorWindow.getDialog(PreferencesDialog).show();
         }).name = "preferences";
         this.menuBar.addMenu("edit",Consts.g.text173,this._editMenu);
         this._assetsMenu = new PopupMenu();
         this._assetsMenu.contentPane.width = 280;
         btn = this._assetsMenu.addItem(Consts.g.text174 + "...",function():void
         {
            _editorWindow.getDialog(CreateComDialog).show();
         });
         btn.name = "createCom";
         btn.getChild("shortcut").text = "Ctrl+F8";
         this._assetsMenu.addItem(Consts.g.text175 + "...",function():void
         {
            _editorWindow.getDialog(CreateButtonDialog).show();
         }).name = "createButton";
         this._assetsMenu.addItem(Consts.g.text176 + "...",function():void
         {
            _editorWindow.getDialog(CreateLabelDialog).show();
         }).name = "createLabel";
         this._assetsMenu.addItem(Consts.g.text177 + "...",function():void
         {
            _editorWindow.getDialog(CreateComboBoxDialog).show();
         }).name = "createComboBox";
         this._assetsMenu.addItem(Consts.g.text178 + "...",function():void
         {
            _editorWindow.getDialog(CreateScrollBarDialog).show();
         }).name = "createScrollBar";
         this._assetsMenu.addItem(Consts.g.text179 + "...",function():void
         {
            _editorWindow.getDialog(CreateProgressBarDialog).show();
         }).name = "createProgressBar";
         this._assetsMenu.addItem(Consts.g.text180 + "...",function():void
         {
            _editorWindow.getDialog(CreateSliderDialog).show();
         }).name = "createSlider";
         this._assetsMenu.addItem(Consts.g.text240 + "...",function():void
         {
            _editorWindow.getDialog(CreatePopupMenuDialog).show();
         }).name = "createPopupMenu";
         this._assetsMenu.addItem(Consts.g.text244 + "...",function():void
         {
            _editorWindow.getDialog(CreateMovieClipDialog).show();
         }).name = "createMovieClip";
         this._assetsMenu.addItem(Consts.g.text10001 + "...",function():void
         {
            _editorWindow.getDialog(CreateFyMoiveDialog).show();
         }).name = "createDragonbone";
         this._assetsMenu.addItem(Consts.g.text19 + "...",function():void
         {
            _editorWindow.getDialog(CreateFontDialog).show();
         }).name = "createFont";
         this._assetsMenu.addSeperator();
         this._assetsMenu.addItem(Consts.g.text320 + "...",this.__importPackage);
         this._assetsMenu.addItem(Consts.g.text339 + "...",this.__importStdPackage);
         this._assetsMenu.addItem(Consts.g.text321 + "...",this.__exportPackage);
         this._assetsMenu.addSeperator();
         btn = this._assetsMenu.addItem(Consts.g.text181 + "...",this.__importResource);
         btn.name = "import";
         btn.getChild("shortcut").text = "Ctrl+R";
         this.menuBar.addMenu("assets",Consts.g.text106,this._assetsMenu);
         this._assetsMenu.addSeperator();
         this._assetsMenu.addItem(Consts.g.text900 + "...",this.__publishClassToServer);
         this._toolMenu = new PopupMenu();
         this._toolMenu.contentPane.width = 280;
         this._toolMenu.addItem(Consts.g.text182 + "...",function():void
         {
            FindReferenceDialog(_editorWindow.getDialog(FindReferenceDialog)).open(null);
         }).name = "findRef";
         this._toolMenu.addItem(Consts.g.text183 + "...",function():void
         {
            _editorWindow.getDialog(StringsFunctionDialog).show();
         }).name = "strings";
         this._toolMenu.addSeperator();
         this._toolMenu.addItem(Consts.g.text195 + "...",function():void
         {
            _editorWindow.getDialog(PlugInManageDialog).show();
         }).name = "plugins";
         this._helpMenu = new PopupMenu();
         this._helpMenu.addItem(Consts.g.text44 + "...",function():void
         {
            _editorWindow.getDialog(AboutDialog).show();
         });
         this._helpMenu.addItem(Consts.g.text67 + "...",function():void
         {
            VersionCheck.inst.start(_editorWindow);
         });
         this._pubMenu = new PopupMenu();
         this._pubMenu.contentPane.width = 200;
         this._pubMenu.addItem(Consts.g.text28,function():void
         {
            PublishDialog(_editorWindow.getDialog(PublishDialog)).openOrPublish();
         }).getChild("shortcut").text = "F9";
         this._pubMenu.addItem(Consts.g.text910,function():void
         {
            PublishDialog(_editorWindow.getDialog(PublishDialog)).openOrPublish(false,1);
         });
         this._pubMenu.addItem(Consts.g.text911,function():void
         {
            PublishDialog(_editorWindow.getDialog(PublishDialog)).openOrPublish(false,0.5);
         });
         this._pubMenu.addItem(Consts.g.text912,function():void
         {
            PublishDialog(_editorWindow.getDialog(PublishDialog)).openOrPublish(false,0.3);
         });
         this._pubMenu.addItem(Consts.g.text41 + "...",function():void
         {
            PublishDialog(_editorWindow.getDialog(PublishDialog)).show();
         });
      }
      
      private function __beforeEditMenuPopup(param1:Event) : void
      {
         var _loc2_:* = false;
         var _loc3_:Boolean = false;
         var _loc4_:ComDocument = this.editPanel.activeDocument as ComDocument;
         if(_loc4_ != null)
         {
            _loc2_ = !_loc4_.hasSelection();
            _loc3_ = _loc4_.hasClipboardData();
            this._editMenu.setItemGrayed("undo",!_loc4_.canUndo());
            this._editMenu.setItemGrayed("redo",!_loc4_.canRedo());
            this._editMenu.setItemGrayed("copy",_loc2_);
            this._editMenu.setItemGrayed("cut",_loc2_);
            this._editMenu.setItemGrayed("paste",!_loc3_);
            this._editMenu.setItemGrayed("paste2",!_loc3_);
            this._editMenu.setItemGrayed("delete",_loc2_);
            this._editMenu.setItemGrayed("selectAll",false);
            this._editMenu.setItemGrayed("unselectAll",_loc2_);
         }
         else
         {
            this._editMenu.setItemGrayed("undo",true);
            this._editMenu.setItemGrayed("redo",true);
            this._editMenu.setItemGrayed("copy",true);
            this._editMenu.setItemGrayed("cut",true);
            this._editMenu.setItemGrayed("paste",true);
            this._editMenu.setItemGrayed("paste2",true);
            this._editMenu.setItemGrayed("delete",true);
            this._editMenu.setItemGrayed("selectAll",true);
            this._editMenu.setItemGrayed("unselectAll",true);
         }
      }
      
      private function setupArrowKeys() : void
      {
         this._arrowKeyCodes = [];
         this._keyMapping = {};
         this.defineArrowKey(38,0,1);
         this.defineArrowKey(38,39,2);
         this.defineArrowKey(39,0,3);
         this.defineArrowKey(39,40,4);
         this.defineArrowKey(40,0,5);
         this.defineArrowKey(40,37,6);
         this.defineArrowKey(37,0,7);
         this.defineArrowKey(37,38,8);
      }
      
      private function defineArrowKey(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:* = 0;
         var _loc4_:* = 0;
         _loc5_ = int(this._arrowKeyCodes[param1]);
         if(!_loc5_)
         {
            _loc5_ = 1 << this._keysCount;
            this._keysCount++;
            this._arrowKeyCodes[param1] = _loc5_;
         }
         if(param2)
         {
            _loc4_ = int(this._arrowKeyCodes[param2]);
            if(!_loc4_)
            {
               _loc4_ = 1 << this._keysCount;
               this._keysCount++;
               this._arrowKeyCodes[param2] = _loc4_;
            }
         }
         this._keyMapping[_loc5_ + _loc4_] = param3;
      }
      
      public function openProject(param1:File) : void
      {
         var _loc2_:* = param1;
         var _loc3_:* = 0;
         try
         {
            this._editorWindow.project.open(_loc2_);
         }
         catch(err:Error)
         {
            _editorWindow.alert("openProject failed: " + RuntimeErrorUtil.toString(err),_editorWindow.stage.nativeWindow.close);
            _loc3_ = 1;
         }
         switch(int(_loc3_))
         {
            case 0:
               try
               {
                  this.initProjectUI();
                  return;
               }
               catch(err:Error)
               {
                  _editorWindow.alert("initProjectUI failed: " + err.message,_editorWindow.stage.nativeWindow.close);
                  return;
               }
               return;
            case 1:
               return;
         }
      }
      
      public function saveWorkspace() : void
      {
         LocalStore.data.libPanelWidth = this.libPanel.self.width;
         LocalStore.data.libPanelResizerY = this.self.height - this.childrenPanel.getCorrectResizerPos();
         var _loc1_:WorkSpace = this._editorWindow.project.settingsCenter.workspace;
         this.editPanel.saveState(_loc1_);
         this.libPanel.saveState(_loc1_);
         _loc1_.save();
      }
      
      public function closeProject() : void
      {
         this.saveWorkspace();
         this.editPanel.closeAllDocuments();
         this._editorWindow.project.close();
         this._editorWindow.groot.closeAllWindows();
         this._editorWindow.stage.nativeWindow.close();
      }
      
      private function initProjectUI() : void
      {
         this.setWindowTitle();
         this.libPanel.updatePackages();
         this.addRecent();
         this._editorWindow.plugInManager.load(this.__plugInLoaded);
      }
      
      private function __plugInLoaded() : void
      {
         var _loc1_:WorkSpace = this._editorWindow.project.settingsCenter.workspace;
         this.editPanel.restoreState(_loc1_);
         this.libPanel.restoreState(_loc1_);
      }
      
      public function setWindowTitle() : void
      {
         this._editorWindow.groot.nativeStage.nativeWindow.title = this._editorWindow.project.name + " - " + ClassEditor.defaultWindowTitle;
      }
      
      public function getActivePackage() : EUIPackage
      {
         var _loc1_:ComDocument = null;
         if(!this._libPanelActive)
         {
            _loc1_ = this.editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               return _loc1_.editingTarget.owner;
            }
         }
         var _loc2_:EUIPackage = this.libPanel.pkgsPanel.getSelectedPackage();
         if(_loc2_ == null)
         {
            _loc1_ = this.editPanel.activeDocument as ComDocument;
            if(_loc1_ != null)
            {
               return _loc1_.editingTarget.owner;
            }
            return this._editorWindow.project.getPackageList()[0];
         }
         return _loc2_;
      }
      
      private function addRecent() : void
      {
         var _loc2_:Array = LocalStore.data.recent_project;
         if(!_loc2_)
         {
            _loc2_ = [];
         }
         if(_loc2_.length % 2 != 0)
         {
            _loc2_.length = 0;
            delete LocalStore.data.recent_project;
         }
         var _loc1_:int = _loc2_.indexOf(this._editorWindow.project.basePath);
         if(_loc1_ != -1)
         {
            _loc2_.splice(_loc1_ - 1,2);
         }
         _loc2_.push(this._editorWindow.project.name,this._editorWindow.project.basePath);
         LocalStore.data.recent_project = _loc2_;
         LocalStore.setDirty("recent_project");
      }
      
      public function openItem(param1:EPackageItem) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.type == "component")
         {
            this.editPanel.openDocument(param1);
            if(this.self.getController("test").selectedIndex == 1)
            {
               this.testPanel.open(param1);
            }
         }
         else if(param1.type != "video")
         {
            if(param1.type == "image")
            {
               ImageEditDialog(this._editorWindow.getDialog(ImageEditDialog)).open(param1);
            }
            else if(param1.type == "font")
            {
               FontEditDialog(this._editorWindow.getDialog(FontEditDialog)).open(param1);
            }
            else if(param1.type == "movieclip")
            {
               MovieClipEditDialog(this._editorWindow.getDialog(MovieClipEditDialog)).open(param1);
            }
            else if(param1.type == "dragonbone")
            {
               DragonBoneClipEditDialog(this._editorWindow.getDialog(DragonBoneClipEditDialog)).open(param1);
            }
            else
            {
               param1.file.openWithDefaultApplication();
            }
         }
      }
      
      public function openItems(param1:Vector.<EPackageItem>) : void
      {
         var _loc2_:EPackageItem = null;
         var _loc5_:int = param1.length;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = param1[_loc4_];
            if(_loc2_.type == "image" || _loc2_.type == "movieclip")
            {
               _loc3_++;
            }
            _loc4_++;
         }
         if(_loc3_ == _loc5_)
         {
            MultiImageEditDialog(this._editorWindow.getDialog(MultiImageEditDialog)).open(param1);
         }
         else
         {
            this.openItem(param1[0]);
         }
      }
      
      public function openItemInExplorer(param1:EPackageItem) : void
      {
         var _loc3_:NativeProcessStartupInfo = new NativeProcessStartupInfo();
         var _loc4_:Vector.<String> = new Vector.<String>();
         if(!ClassEditor.os_mac)
         {
            _loc3_.executable = new File("c:\\windows\\explorer.exe");
            _loc4_.push("/select," + param1.file.nativePath);
         }
         else
         {
            _loc3_.executable = new File("/usr/bin/open");
            _loc4_.push("-R");
            _loc4_.push(param1.file.nativePath);
         }
         _loc3_.arguments = _loc4_;
         var _loc2_:NativeProcess = new NativeProcess();
         _loc2_.start(_loc3_);
      }
      
      private function __publishClassToServer(param1:Event) : void
      {
         UploadPPT.getInstance()._editorWindow = this._editorWindow;
         UploadPPT.getInstance().selectFiles();
      }
      
      private function __importPackage(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         UtilsFile.browseForOpen("FairyGUI package",[new FileFilter("FairyGUI package","*.fairypackage")],function(param1:File):void
         {
            ImportPackageDialog(_editorWindow.getDialog(ImportPackageDialog)).open(param1);
         });
      }
      
      private function __importStdPackage(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         UtilsFile.browseForOpen("FairyGUI package",[new FileFilter("FairyGUI package","*.fairypackage")],function(param1:File):void
         {
            ImportPackageDialog(_editorWindow.getDialog(ImportPackageDialog)).open(param1);
         },File.applicationDirectory.resolvePath("standard assets"));
      }
      
      private function __exportPackage(param1:Event) : void
      {
         ExportPackageDialog(this._editorWindow.getDialog(ExportPackageDialog)).show();
      }
      
      private function __importResource(param1:Event) : void
      {
         param1 = param1;
         var pkg:EUIPackage = null;
         var toPath:String = null;
         var evt:Event = param1;
         pkg = this.getActivePackage();
         if(pkg == null)
         {
            return;
         }
         toPath = this.libPanel.pkgsPanel.getSelectedFolderInPackage(pkg).id;
         UtilsFile.browseForOpenMultiple(Consts.g.text46 + ":" + pkg.name,[new FileFilter(Consts.g.text47,"*.jpg;*.png;*.gif;*.plist;*.eas;*.jta;*.jtb;*.swf;*.wav;*.mp3;*.ogg;*.fnt;*.xml"),new FileFilter(Consts.g.text48,"*.*"),new FileFilter(Consts.g.text49,"*.jpg;*.png"),new FileFilter(Consts.g.text50,"*.swf"),new FileFilter(Consts.g.text51,"*.gif;*.plist;*.eas;*.jta"),new FileFilter(Consts.g.text52,"*.fnt"),new FileFilter(Consts.g.text53,"*.mp3;*.wav;*.ogg"),new FileFilter(Consts.g.text316,"*.xml"),new FileFilter(Consts.g.text341,"*.zip")],function(param1:Array):void
         {
            var _loc2_:File = null;
            var _loc3_:* = null;
            var _loc6_:int = File(param1[0]).parent.nativePath.length;
            var _loc4_:Array = [];
            var _loc5_:int = 0;
            while(_loc5_ < param1.length)
            {
               _loc2_ = param1[_loc5_];
               _loc3_ = _loc2_.parent.nativePath.substr(_loc6_).replace(/\\/g,"/");
               if(_loc3_.length == 0)
               {
                  _loc3_ = toPath;
               }
               else
               {
                  _loc3_ = toPath + _loc3_.substr(1) + "/";
               }
               _loc4_.push(_loc3_);
               _loc5_++;
            }
            importResources(param1,pkg,_loc4_);
         });
      }
      
      public function importBone() : void
      {
      }
      
      public function importResources(param1:Array, param2:EUIPackage, param3:Array, param4:Object = null, param5:Callback = null) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         param5 = param5;
         var hasPNG:Boolean = false;
         var file:File = null;
         var str:String = null;
         var files:Array = param1;
         var pkg:EUIPackage = param2;
         var toPaths:Array = param3;
         var options:Object = param4;
         var callback:Callback = param5;
         if(!options)
         {
            options = {};
         }
         var i:int = 0;
         while(i < files.length)
         {
            file = files[i];
            if(file.extension.toLowerCase() == "png")
            {
               hasPNG = true;
            }
            i = Number(i) + 1;
         }
         if(hasPNG)
         {
            str = Preferences.cropResource;
            if(str == "ask")
            {
               CropQueryDialog(this._editorWindow.getDialog(CropQueryDialog)).open(function(param1:*):void
               {
                  if(param1 == null)
                  {
                     callback.callOnFailImmediately();
                  }
                  else
                  {
                     options.crop = param1;
                     importResources2(files,pkg,toPaths,options,callback);
                  }
               });
               return;
            }
            if(str == "yes")
            {
               options.crop = true;
            }
         }
         this.importResources2(files,pkg,toPaths,options,callback);
      }
      
      private function importResources2(param1:Array, param2:EUIPackage, param3:Array, param4:Object, param5:Callback = null) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         param5 = param5;
         var importedItems:Array = null;
         var jj:int = 0;
         var total:int = 0;
         var progressDlg:ImportProgressDialog = null;
         var stepCallback:Callback = null;
         var files:Array = param1;
         var pkg:EUIPackage = param2;
         var toPaths:Array = param3;
         var options:Object = param4;
         var callback:Callback = param5;
         importedItems = [];
         jj = 0;
         total = files.length;
         progressDlg = ImportProgressDialog(this._editorWindow.getDialog(ImportProgressDialog));
         var fileCount:int = files.length;
         progressDlg.progressBar.value = 0;
         progressDlg.progressBar.max = fileCount;
         progressDlg.messageText.text = UtilsStr.formatString(Consts.g.text199,1,fileCount);
         progressDlg.show();
         stepCallback = new Callback();
         var fun:Function = function():void
         {
            var _loc4_:ComDocument = null;
            var _loc1_:Array = null;
            var _loc2_:String = null;
            var _loc6_:EPackageItem = EPackageItem(stepCallback.result);
            if(_loc6_)
            {
               importedItems.push(_loc6_);
               progressDlg.progressBar.value++;
            }
            if(jj >= total || !progressDlg.onStage)
            {
               if(importedItems.length > 0)
               {
                  pkg.save();
               }
               progressDlg.hide();
               if(options.dropTarget == "document")
               {
                  _loc4_ = editPanel.activeDocument as ComDocument;
                  _loc4_.dropObjects(importedItems,options);
                  editPanel.self.requestFocus();
               }
               else
               {
                  libPanel.self.requestFocus();
               }
               previewPanel.refresh();
               if(callback != null)
               {
                  _loc1_ = [];
                  var _loc8_:int = 0;
                  var _loc7_:* = importedItems;
                  for each(_loc6_ in importedItems)
                  {
                     _loc1_.push(_loc6_.id);
                  }
                  callback.result = _loc1_;
                  callback.callOnSuccess();
               }
               if(stepCallback.msgs.length)
               {
                  _editorWindow.alert(stepCallback.msgs.join("\n"));
               }
               return;
            }
            stepCallback.result = null;
            var _loc5_:File = files[jj];
            var _loc3_:String = toPaths[jj];
            if(_loc3_ == null)
            {
               _loc3_ = toPaths[0];
            }
            if(options.basePath)
            {
               _loc2_ = options.basePath.getRelativePath(_loc5_.parent);
               if(_loc2_ != null && _loc2_.length > 0)
               {
                  _loc3_ = _loc3_ + (_loc2_ + "/");
               }
            }
            jj = Number(jj) + 1;
            pkg.importResource(_loc5_,_loc3_,options.crop,stepCallback,false);
            progressDlg.messageText.text = UtilsStr.formatString(Consts.g.text199,progressDlg.progressBar.value + 1,progressDlg.progressBar.max);
         };
         stepCallback.success = fun;
         stepCallback.failed = fun;
         GTimers.inst.callLater(fun);
      }
      
      public function selectForUpdateResource(param1:EPackageItem) : void
      {
         param1 = param1;
         var ff:Array = null;
         var pi:EPackageItem = param1;
         var pkg:EUIPackage = pi.owner;
         if(pi.type == "image")
         {
            ff = [new FileFilter(Consts.g.text49,"*.jpg;*.png")];
         }
         else if(pi.type == "swf")
         {
            ff = [new FileFilter(Consts.g.text50,"*.swf")];
         }
         else if(pi.type == "movieclip")
         {
            ff = [new FileFilter(Consts.g.text51,"*.gif;*.plist;*.eas;*.jta;*.jtb")];
         }
         else if(pi.type == "sound")
         {
            ff = [new FileFilter(Consts.g.text53,"*.mp3;*.wav;*.ogg")];
         }
         else if(pi.type == "font")
         {
            ff = [new FileFilter(Consts.g.text52,"*.fnt")];
         }
         else if(pi.type == "component")
         {
            ff = [new FileFilter(Consts.g.text316,"*.xml")];
         }
         else
         {
            return;
         }
         UtilsFile.browseForOpen(Consts.g.text54 + ":" + pi.name,ff,function(param1:File):void
         {
            updateResource(pi,param1);
         });
      }
      
      public function updateResource(param1:EPackageItem, param2:File, param3:Callback = null) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var str:String = null;
         var pi:EPackageItem = param1;
         var file:File = param2;
         var callback:Callback = param3;
         if(file.extension.toLowerCase() == "png")
         {
            str = Preferences.cropResource;
            if(str == "ask")
            {
               CropQueryDialog(this._editorWindow.getDialog(CropQueryDialog)).open(function(param1:*):void
               {
                  if(param1 == null)
                  {
                     callback.callOnFailImmediately();
                  }
                  else
                  {
                     updateResource2(pi,file,param1,callback);
                  }
               });
            }
            else
            {
               this.updateResource2(pi,file,str == "yes",callback);
            }
         }
         else
         {
            this.updateResource2(pi,file,false,callback);
         }
      }
      
      private function updateResource2(param1:EPackageItem, param2:File, param3:Boolean, param4:Callback = null) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         var callback2:Callback = null;
         var pi:EPackageItem = param1;
         var file:File = param2;
         var crop:Boolean = param3;
         var callback:Callback = param4;
         this._editorWindow.showWaiting();
         callback2 = new Callback();
         callback2.success = function():void
         {
            _editorWindow.closeWaiting();
            editPanel.refreshDocument();
            previewPanel.refresh(true);
            var _loc1_:ImageEditDialog = ImageEditDialog(_editorWindow.getDialog(ImageEditDialog));
            if(_loc1_.isShowing && _loc1_.imageItem == pi)
            {
               _loc1_.open(pi);
            }
            if(callback != null)
            {
               callback.callOnSuccess();
            }
         };
         callback2.failed = function():void
         {
            _editorWindow.closeWaiting();
            if(callback != null)
            {
               callback.addMsgs(callback2.msgs);
               callback.callOnFail();
            }
            _editorWindow.alert(Consts.g.text55 + ": " + callback2.msgs.join("\n"));
         };
         pi.owner.updateResource(pi,file,crop,callback2,true);
      }
      
      public function checkBeforeQuit() : void
      {
         this.editPanel.queryToSaveAllDocuments(function(param1:int):void
         {
            if(param1 != 2)
            {
               closeProject();
            }
         });
      }
      
      public function get bgColor() : int
      {
         return this._bgColorInput.colorValue;
      }
      
      public function get bgColor2() : int
      {
         return 419430;
      }
      
      public function get viewScale() : Number
      {
         return this._viewScale;
      }
      
      private function __bgColorChanged(param1:Event) : void
      {
         LocalStore.data.editor_color = this._bgColorInput.colorValue;
         LocalStore.data.editor_color2 = this._bgColorInput2.colorValue;
         LocalStore.setDirty("editor_color");
         LocalStore.setDirty("editor_color2");
         this.editPanel.onBgColorChanged();
      }
      
      public function changeViewScale(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            if(param2)
            {
               this._viewScale = this._viewScale * 2;
            }
            else
            {
               this._viewScale = this._viewScale * 1.25;
            }
            if(this._viewScale > 16)
            {
               this._viewScale = 16;
            }
         }
         else
         {
            if(param2)
            {
               this._viewScale = this._viewScale / 2;
            }
            else
            {
               this._viewScale = this._viewScale / 1.25;
            }
            if(this._viewScale < 0.25)
            {
               this._viewScale = 0.25;
            }
         }
         this._viewScaleCombo.text = (this._viewScale * 100).toFixed(0) + "%";
         this.editPanel.onViewScaleChanged();
      }
      
      public function changeViewScale2(param1:Number) : void
      {
         this._viewScale = param1;
         this._viewScaleCombo.text = (this._viewScale * 100).toFixed(0) + "%";
         this.editPanel.onViewScaleChanged();
      }
      
      private function __viewScaleChanged(param1:Event) : void
      {
         this._viewScale = parseInt(this._viewScaleCombo.text) / 100;
         this.editPanel.onViewScaleChanged();
      }
      
      private function __focusChanged(param1:FocusChangeEvent) : void
      {
         if(param1.newFocusedObject == this.libPanel.self)
         {
            this._selfActive = true;
            this._libPanelActive = true;
            this._editPanelActive = false;
         }
         else if(param1.newFocusedObject == this.editPanel.self || param1.newFocusedObject == this.propsPanelList.self || param1.newFocusedObject == this.childrenPanel.self)
         {
            this._selfActive = true;
            this._libPanelActive = false;
            this._editPanelActive = true;
         }
         else if(param1.newFocusedObject == this.self)
         {
            this._selfActive = true;
         }
         else
         {
            this._selfActive = false;
         }
         this.libPanel.setActive(this._selfActive && this._libPanelActive);
      }
      
      public function get arrowKeyDown() : Boolean
      {
         return this._keyStatus != 0;
      }
      
      private function __keydown(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ComDocument = null;
         var _loc4_:Window = null;
         var _loc7_:String = String.fromCharCode(param1.charCode).toLowerCase();
         var _loc5_:Boolean = false;
         if(param1.target is TextField && TextField(param1.target).type == "input")
         {
            if(param1.ctrlKey && _loc7_ == "s")
            {
               param1.preventDefault();
            }
            else if(param1.ctrlKey && _loc7_ == "z")
            {
               TextInputHistory.inst.undo(TextField(param1.target));
               param1.preventDefault();
            }
            else if(param1.ctrlKey && _loc7_ == "y")
            {
               TextInputHistory.inst.redo(TextField(param1.target));
               param1.preventDefault();
            }
            else
            {
               _loc5_ = true;
               if(TextField(param1.target).multiline || param1.keyCode != 13)
               {
                  return;
               }
            }
         }
         var _loc6_:int = this._arrowKeyCodes[param1.keyCode];
         if(_loc6_)
         {
            this._keyStatus = this._keyStatus | _loc6_;
            if(this._keyStatus)
            {
               _loc2_ = this._keyMapping[this._keyStatus];
               if(this._selfActive)
               {
                  if(this._libPanelActive)
                  {
                     this.libPanel.handleArrowKey(_loc2_,param1.ctrlKey,param1.shiftKey);
                  }
                  else if(this._editPanelActive)
                  {
                     _loc3_ = this.editPanel.activeDocument as ComDocument;
                     if(_loc3_ != null)
                     {
                        _loc3_.handleArrowKey(_loc2_,param1.ctrlKey,param1.shiftKey);
                     }
                  }
               }
               else
               {
                  _loc4_ = this._editorWindow.groot.getTopWindow();
                  if(_loc4_ != null)
                  {
                     if("handleArrowKey" in _loc4_)
                     {
                        _loc4_["handleArrowKey"](_loc2_,param1.ctrlKey,param1.shiftKey);
                     }
                  }
               }
            }
            return;
         }
         var _loc8_:* = param1.keyCode;
         if(27 !== _loc8_)
         {
            if(33 !== _loc8_)
            {
               if(115 !== _loc8_)
               {
                  if(116 !== _loc8_)
                  {
                     if(119 !== _loc8_)
                     {
                        if(120 !== _loc8_)
                        {
                           if(121 === _loc8_)
                           {
                              PublishDialog(this._editorWindow.getDialog(PublishDialog)).openOrPublish(true);
                              return;
                           }
                        }
                        else
                        {
                           PublishDialog(this._editorWindow.getDialog(PublishDialog)).openOrPublish();
                           return;
                        }
                     }
                     else if(param1.ctrlKey)
                     {
                        this._editorWindow.getDialog(CreateComDialog).show();
                        return;
                     }
                  }
                  else
                  {
                     if(this.self.getController("test").selectedIndex == 1)
                     {
                        this.testPanel.play();
                     }
                     else
                     {
                        this.__runTest(null);
                     }
                     return;
                  }
               }
               else
               {
                  _loc3_ = this.editPanel.activeDocument as ComDocument;
                  if(_loc3_ != null)
                  {
                     _loc3_.editingContent.setProperty("designImageLayer",_loc3_.editingContent.designImageLayer == 0?1:0);
                     _loc3_.setUpdateFlag();
                  }
                  return;
               }
            }
            else if(param1.ctrlKey)
            {
               this.editPanel.tabView.activateLatest();
               return;
            }
            if(param1.ctrlKey || param1.commandKey)
            {
               _loc8_ = _loc7_;
               if("s" !== _loc8_)
               {
                  if("w" !== _loc8_)
                  {
                     if("n" !== _loc8_)
                     {
                        if("r" !== _loc8_)
                        {
                           if("=" !== _loc8_)
                           {
                              if("+" !== _loc8_)
                              {
                                 if("-" !== _loc8_)
                                 {
                                    if("1" === _loc8_)
                                    {
                                       if(this.testPanel.self.onStage)
                                       {
                                          this.testPanel.changeViewScale2(1);
                                       }
                                       else
                                       {
                                          this.changeViewScale2(1);
                                       }
                                    }
                                 }
                                 else if(this.testPanel.self.onStage)
                                 {
                                    this.testPanel.changeViewScale(false,true);
                                 }
                                 else
                                 {
                                    this.changeViewScale(false,true);
                                 }
                              }
                           }
                           if(this.testPanel.self.onStage)
                           {
                              this.testPanel.changeViewScale(true,true);
                           }
                           else
                           {
                              this.changeViewScale(true,true);
                           }
                        }
                        else
                        {
                           this.__importResource(null);
                        }
                     }
                     else
                     {
                        CreateComDialog(this._editorWindow.getDialog(CreateComDialog)).show();
                     }
                  }
                  else
                  {
                     this.editPanel.queryToCloseDocument();
                  }
               }
               else
               {
                  this.editPanel.saveDocument();
                  return;
               }
            }
            if(this._selfActive)
            {
               if(this._libPanelActive)
               {
                  if(!_loc5_)
                  {
                     this.libPanel.handleKeyDownEvent(param1);
                  }
               }
               else if(this._editPanelActive)
               {
                  _loc3_ = this.editPanel.activeDocument as ComDocument;
                  if(_loc3_ != null)
                  {
                     _loc3_.handleKeyDownEvent(param1);
                  }
               }
            }
            else
            {
               _loc4_ = this._editorWindow.groot.getTopWindow();
               if(_loc4_ != null)
               {
                  if(param1.keyCode == 13 && _loc4_ is WindowBase)
                  {
                     WindowBase(_loc4_).actionHandler();
                  }
                  if("handleKeyDownEvent" in _loc4_)
                  {
                     _loc4_["handleKeyDownEvent"](param1);
                  }
               }
            }
            return;
         }
         if(this._editorWindow.colorPicker.isShowing)
         {
            this._editorWindow.colorPicker.hide();
         }
         else if(this._editorWindow.dragManager.dragging)
         {
            this._editorWindow.dragManager.cancel();
         }
         else
         {
            _loc4_ = this._editorWindow.groot.getTopWindow();
            if(_loc4_ != null)
            {
               if(_loc4_ is WindowBase)
               {
                  WindowBase(_loc4_).cancelHandler();
               }
               else
               {
                  _loc4_.hide();
               }
            }
            else if(this.self.getController("test").selectedIndex == 1)
            {
               this.testPanel.close();
            }
         }
      }
      
      private function __keyup(param1:KeyboardEvent) : void
      {
         var _loc2_:ComDocument = null;
         if(this._editorWindow.groot.nativeStage.focus is TextField && TextField(this._editorWindow.groot.nativeStage.focus).type == "input")
         {
            return;
         }
         var _loc3_:int = this._arrowKeyCodes[param1.keyCode];
         if(_loc3_)
         {
            this._keyStatus = this._keyStatus & ~_loc3_;
         }
         if(this._selfActive)
         {
            if(this._libPanelActive)
            {
               this.libPanel.handleKeyUpEvent(param1);
            }
            else if(this._editPanelActive)
            {
               _loc2_ = this.editPanel.activeDocument as ComDocument;
               if(_loc2_ != null)
               {
                  _loc2_.handleKeyUpEvent(param1);
               }
            }
         }
      }
      
      private function __runTest_egret1(param1:Event) : void
      {
         var _loc5_:String = null;
         var _loc6_:EUIPackage = _editorWindow.mainPanel.getActivePackage();
         var _loc4_:PublishSettings = _loc6_.publishSettings;
         if(_loc4_.filePath)
         {
            _loc5_ = _loc4_.filePath;
         }
         else
         {
            _loc5_ = _loc6_.project.settingsCenter.publish.filePath;
         }
         var _loc7_:File = null;
         _loc7_ = new File(_loc6_.project.basePath).resolvePath(_loc5_);
         var _loc3_:File = File.applicationDirectory;
         var _loc2_:String = _loc3_.nativePath;
         _loc2_ = "file:///" + _loc2_.replace(/\\/g,"/");
         UploadPPT.getInstance()._editorWindow = this._editorWindow;
         UploadPPT.getInstance().callChromeExe(_loc2_ + "/fydingdongh5/index_scene.html?classname=" + _loc6_.name + "&pptPath=" + _loc7_.url + "/" + "&svType=1&isTest=true&paint=true");
      }
      
      private function __runTest_egret(param1:Event) : void
      {
         var _loc5_:String = null;
         var _loc6_:EUIPackage = _editorWindow.mainPanel.getActivePackage();
         var _loc4_:PublishSettings = _loc6_.publishSettings;
         if(_loc4_.filePath)
         {
            _loc5_ = _loc4_.filePath;
         }
         else
         {
            _loc5_ = _loc6_.project.settingsCenter.publish.filePath;
         }
         var _loc7_:File = null;
         _loc7_ = new File(_loc6_.project.basePath).resolvePath(_loc5_);
         var _loc3_:File = File.applicationDirectory;
         var _loc2_:String = _loc3_.nativePath;
         _loc2_ = "file:///" + _loc2_.replace(/\\/g,"/");
         UploadPPT.getInstance()._editorWindow = this._editorWindow;
         UploadPPT.getInstance().callChromeExe(_loc2_ + "/fydingdongh5/index_egret.html?classname=" + _loc6_.name + "&pptPath=" + _loc7_.url + "/" + "&svType=1&isTest=true&paint=true");
      }
      
      private function __runTest(param1:Event) : void
      {
         var _loc5_:String = null;
         var _loc6_:EUIPackage = _editorWindow.mainPanel.getActivePackage();
         var _loc4_:PublishSettings = _loc6_.publishSettings;
         if(_loc4_.filePath)
         {
            _loc5_ = _loc4_.filePath;
         }
         else
         {
            _loc5_ = _loc6_.project.settingsCenter.publish.filePath;
         }
         var _loc7_:File = null;
         _loc7_ = new File(_loc6_.project.basePath).resolvePath(_loc5_);
         var _loc3_:File = File.applicationDirectory;
         var _loc2_:String = _loc3_.nativePath;
         _loc2_ = "file:///" + _loc2_.replace(/\\/g,"/");
         UploadPPT.getInstance()._editorWindow = this._editorWindow;
         UploadPPT.getInstance().callChromeExe(_loc2_ + "/fydingdongh5/indexv2.html?classname=" + _loc6_.name + "&pptPath=" + _loc7_.url + "/" + "&svType=1&isTest=true&paint=true");
      }
      
      private function __nativeDragEnter(param1:NativeDragEvent) : void
      {
         if(!param1.clipboard.hasFormat("air:file list"))
         {
            return;
         }
         var _loc4_:DisplayObject = DisplayObject(param1.target);
         var _loc2_:* = _loc4_;
         var _loc3_:Stage = _loc4_.stage;
         while(_loc2_ && _loc2_ != _loc3_)
         {
            if(_loc2_ == this.editPanel.self.displayObject && this.editPanel.activeDocument != null || _loc2_ == this.libPanel.self.displayObject || _loc2_ is UISprite && UISprite(_loc2_).owner is ResourceInput)
            {
               NativeDragManager.acceptDragDrop(Sprite(_loc2_));
               break;
            }
            _loc2_ = _loc2_.parent;
         }
      }
      
      private function __nativeDragDrop(param1:NativeDragEvent) : void
      {
         var _loc12_:int = 0;
         var _loc14_:EUIPackage = null;
         var _loc3_:String = null;
         var _loc5_:Vector.<EPackageItem> = null;
         var _loc4_:File = null;
         var _loc6_:String = null;
         var _loc2_:EPackageItem = null;
         var _loc10_:EPackageItem = null;
         if(!param1.clipboard.hasFormat("air:file list"))
         {
            return;
         }
         var _loc9_:Stage = this.self.displayObject.stage;
         _loc9_.nativeWindow.activate();
         var _loc7_:Array = param1.clipboard.getData("air:file list") as Array;
         var _loc8_:int = _loc7_.length;
         if(_loc8_ == 0)
         {
            return;
         }
         var _loc11_:File = _loc7_[0].parent;
         while(_loc12_ < _loc8_)
         {
            _loc4_ = _loc7_[_loc12_];
            if(_loc4_.isDirectory)
            {
               _loc7_.splice(_loc12_,1);
               UtilsFile.listAllFiles(_loc4_,_loc7_);
               _loc8_ = _loc7_.length;
            }
            else
            {
               _loc6_ = _loc4_.extension.toLowerCase();
               if(_loc6_ != "jpg" && _loc6_ != "png" && _loc6_ != "jpeg" && _loc6_ != "gif" && _loc6_ != "swf" && _loc6_ != "eas" && _loc6_ != "plist" && _loc6_ != "jta" && _loc6_ != "fnt" && _loc6_ != "wav" && _loc6_ != "mp3" && _loc6_ != "ogg" && _loc6_ != "xml")
               {
                  _loc7_.splice(_loc12_,1);
                  _loc8_--;
               }
               else
               {
                  _loc12_++;
               }
            }
         }
         if(_loc7_.length == 0)
         {
            return;
         }
         var _loc15_:ComDocument = this.editPanel.activeDocument as ComDocument;
         var _loc13_:Object = {};
         if(param1.target is UISprite && UISprite(param1.target).owner is ResourceInput)
         {
            _loc13_.dropTarget = UISprite(param1.target).owner;
         }
         else if(param1.target != this.libPanel.self.displayObject)
         {
            _loc13_.dropTarget = "document";
            _loc13_.dropPos = _loc15_.getMousePos();
         }
         else
         {
            _loc13_.dropTarget = "lib";
         }
         _loc13_.basePath = _loc11_;
         if(_loc13_.dropTarget == "lib")
         {
            _loc2_ = this.libPanel.pkgsPanel.getFolderItemUnderPoint(param1.stageX,param1.stageY);
            if(_loc2_ == null)
            {
               return;
            }
            _loc14_ = _loc2_.owner;
            _loc3_ = _loc2_.id;
         }
         else
         {
            _loc14_ = _loc15_.editingTarget.owner;
            _loc3_ = this.libPanel.pkgsPanel.getSelectedFolderInPackage(_loc14_).id;
         }
         _loc8_ = _loc7_.length;
         _loc12_ = 0;
         while(_loc12_ < _loc8_)
         {
            _loc4_ = _loc7_[_loc12_];
            _loc10_ = this._editorWindow.project.getItemByFile(_loc4_);
            if(_loc10_)
            {
               if(_loc5_ == null)
               {
                  _loc5_ = new Vector.<EPackageItem>();
               }
               _loc5_.push(_loc10_);
               _loc7_.splice(_loc12_);
               _loc8_--;
            }
            else
            {
               _loc12_++;
            }
         }
         if(_loc5_)
         {
            if(_loc13_.dropTarget == "document")
            {
               _loc15_.dropObjects(_loc5_,_loc13_);
               this.editPanel.self.requestFocus();
            }
            else if(_loc13_.dropTarget is ResourceInput)
            {
               ResourceInput(_loc13_.dropTarget).text = _loc5_[0].getURL();
               ResourceInput(_loc13_.dropTarget).dispatchEvent(new SubmitEvent("__submit"));
            }
         }
         if(_loc7_.length > 0)
         {
            this.importResources(_loc7_,_loc14_,[_loc3_],_loc13_);
         }
      }
      
      public function showNewVersionPrompt() : void
      {
         this.newVersionPrompt.getController("c1").selectedIndex = 0;
         this.newVersionPrompt.text = UtilsStr.formatString(Consts.g.text228,ClassEditor.newVersionData.version_name);
         this.self.getTransition("newVersionShow").play();
      }
      
      public function showRestartPrompt() : void
      {
         this.newVersionPrompt.getController("c1").selectedIndex = 1;
         this.newVersionPrompt.text = Consts.g.text229;
         this.self.getTransition("newVersionShow").play();
      }
      
      public function showAlreadyUpdatedPrompt() : void
      {
         this.newVersionPrompt.getController("c1").selectedIndex = 2;
         this.newVersionPrompt.text = Consts.g.text68;
         this.self.getTransition("newVersionShow").play();
         GTimers.inst.add(2000,1,this.self.getTransition("newVersionHide").play);
      }
      
      private function __upgradeNow(param1:Event) : void
      {
         if(this.newVersionPrompt.getController("c1").selectedIndex == 1)
         {
            ClassEditor.saveAllAndExit();
            return;
         }
         this.newVersionPrompt.visible = false;
         GTimers.inst.add(200,1,ClassEditor.installUpdate,this._editorWindow);
      }
      
      private function __upgradeLater(param1:Event) : void
      {
         this.self.getTransition("newVersionHide").play();
      }
      
      private function __upgradeNotes(param1:Event) : void
      {
      }
      
      public function updateToolbox() : void
      {
         var _loc1_:String = null;
         this.toolbox.visible = true;
         var _loc2_:EGComponent = ComDocument(this.editPanel.activeDocument).editingContent;
         this.self.getChild("btnRelationDisabled").asButton.selected = _loc2_.disabled_relations != 0;
         this.self.getChild("btnControllerDisabled").asButton.selected = _loc2_.disabled_displayController;
         if(_loc2_.nameConflicts && _loc2_.nameConflicts.length > 0)
         {
            _loc1_ = UtilsStr.formatString(Consts.g.text323,_loc2_.nameConflicts.join(", "));
            this._warningsButton.tooltips = UtilsStr.formatString(Consts.g.text322 + "\n" + _loc1_,1);
            this._warningsButton.selected = true;
         }
         else
         {
            this._warningsButton.tooltips = Consts.g.text324;
            this._warningsButton.selected = false;
         }
      }
   }
}

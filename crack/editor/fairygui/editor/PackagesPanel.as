package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GLoader;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.dialogs.ChooseFolderDialog;
   import fairygui.editor.dialogs.FindReferenceDialog;
   import fairygui.editor.dialogs.FixConflictedNameDialog;
   import fairygui.editor.dialogs.PackageSettingsDialog;
   import fairygui.editor.dialogs.PasteOptionDialog;
   import fairygui.editor.dialogs.PublishDialog;
   import fairygui.editor.dialogs.insert.CreateComDialog;
   import fairygui.editor.extui.DropEvent;
   import fairygui.editor.extui.EditableTreeItem;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.handlers.CopyHandler;
   import fairygui.editor.settings.WorkSpace;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.DragEvent;
   import fairygui.event.ItemEvent;
   import fairygui.tree.ITreeListener;
   import fairygui.tree.TreeNode;
   import fairygui.tree.TreeView;
   import fairygui.utils.GTimers;
   import flash.desktop.Clipboard;
   import flash.display.BitmapData;
   import flash.display.PNGEncoderOptions;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   
   public class PackagesPanel implements ITreeListener
   {
      
      private static var _copiedItems:Vector.<EPackageItem>;
      
      public static var PUBLIC_COMPONENT_OBJECT:Object = null;
      
      public static var PUBLIC_OK:Boolean = false;
       
      
      private var _editorWindow:EditorWindow;
      
      private var _parentPanel:GComponent;
      
      private var _treeView:TreeView;
      
      private var _menu:PopupMenu;
      
      private var _pkgMenu:PopupMenu;
      
      private var _active:Boolean;
      
      private var _updating:Boolean;
      
      private var _changedNodes:Vector.<TreeNode>;
      
      private var _helperList:Vector.<EPackageItem>;
      
      private var _disableSelectionChange:Boolean;
      
      public function PackagesPanel(param1:EditorWindow, param2:GComponent)
      {
         this._changedNodes = new Vector.<TreeNode>();
         this._helperList = new Vector.<EPackageItem>();
         super();
         this._editorWindow = param1;
         this._parentPanel = param2;
         this._treeView = new TreeView(this._parentPanel.getChild("treeView").asList);
         this._treeView.listener = this;
         this._treeView.list.addEventListener("__drop",this.__drop);
         this._treeView.list.selectionMode = 1;
         this.createMenu();
      }
      
      private function createMenu() : void
      {
         var btn:GButton = null;
         this._menu = new PopupMenu();
         this._menu.contentPane.width = 210;
         btn = this._menu.addItem(Consts.g.text236 + "...",this.__menuProperty);
         btn.name = "property";
         btn.getChild("shortcut").text = "Enter";
         btn = this._menu.addItem(Consts.g.text17,this.__menuRename);
         btn.name = "rename";
         btn.getChild("shortcut").text = "F2";
         this._menu.addItem(Consts.g.text174 + "...",this.__menuNewCom).name = "newCom";
         this._menu.addItem(Consts.g.text18,this.__menuNewFolder).name = "newFolder";
         this._menu.addSeperator();
         this._menu.addItem(Consts.g.text2,this.__menuCopy).name = "copy";
         this._menu.addItem(Consts.g.text246 + "...",this.__menuDuplicate).name = "duplicate";
         this._menu.addItem(Consts.g.text245 + "...",this.__menuMove).name = "move";
         this._menu.addItem(Consts.g.text3,this.__menuPaste).name = "paste";
         this._menu.addItem(Consts.g.text336,this.__menuPasteAll).name = "pasteAll";
         this._menu.addItem(Consts.g.text25,this.__menuDelete).name = "delete";
         this._menu.addSeperator();
         this._menu.addItem(Consts.g.text16,this.__menuCopyLink).name = "copyLink";
         this._menu.addItem(Consts.g.text194,this.__menuCopyName).name = "copyName";
         this._menu.addItem(Consts.g.text171 + "...",this.__menuFindRef).name = "findRef";
         this._menu.addSeperator();
         this._menu.addItem(Consts.g.text20,this.__menuSetExport).name = "setExport";
         this._menu.addItem(Consts.g.text21,this.__menuSetNotExport).name = "setNotExport";
         this._menu.addSeperator();
         this._menu.addItem(Consts.g.text334,this.__menuAddFavorite).name = "addFavorite";
         this._menu.addSeperator();
         this._menu.addItem(Consts.g.text22 + "...",this.__menuUpdate).name = "update";
         this._menu.addItem(Consts.g.text192,this.__menuOpenWithExternal).name = "openWithExternal";
         this._menu.addItem(Consts.g.text24,this.__menuOpenInExplorer).name = "openInExplorer";
         this._menu.addSeperator();
         this._menu.addItem("只发布该组件[Main]",this.__menuPublishComponet).name = "publishComponet";
         this._pkgMenu = new PopupMenu();
         this._pkgMenu.addItem(Consts.g.text174 + "...",this.__menuNewCom).name = "newCom";
         this._pkgMenu.addItem(Consts.g.text18,this.__menuNewFolder).name = "newFolder";
         this._pkgMenu.addSeperator();
         this._pkgMenu.addItem(Consts.g.text3,this.__menuPaste).name = "paste";
         this._pkgMenu.addItem(Consts.g.text336,this.__menuPasteAll).name = "pasteAll";
         this._pkgMenu.addSeperator();
         btn = this._pkgMenu.addItem(Consts.g.text17,this.__menuRename);
         btn.name = "rename";
         btn.getChild("shortcut").text = "F2";
         this._pkgMenu.addItem(Consts.g.text27 + "...",function():void
         {
            _editorWindow.getDialog(PackageSettingsDialog).show();
         });
         this._pkgMenu.addItem(Consts.g.text28 + "...",function():void
         {
            _editorWindow.getDialog(PublishDialog).show();
         });
         this._pkgMenu.addSeperator();
         this._pkgMenu.addItem(Consts.g.text29 + "...",this.__menuDeletePkg).name = "deletePkg";
         this._pkgMenu.addSeperator();
         this._pkgMenu.addItem(Consts.g.text24,this.__menuOpenInExplorer).name = "openInExplorer";
      }
      
      public function setActive(param1:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:EditableTreeItem = null;
         if(this._active != param1)
         {
            this._active = param1;
            _loc4_ = this._treeView.list.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               _loc3_ = EditableTreeItem(this._treeView.list.getChildAt(_loc2_));
               _loc3_.setActive(this._active);
               _loc2_++;
            }
         }
      }
      
      public function getSelectedPackage() : EUIPackage
      {
         var _loc1_:EPackageItem = null;
         var _loc2_:TreeNode = this._treeView.getSelectedNode();
         if(_loc2_ != null)
         {
            _loc1_ = EPackageItem(_loc2_.data);
            return _loc1_.owner;
         }
         return null;
      }
      
      public function getSelectedItem() : EPackageItem
      {
         var _loc1_:EPackageItem = null;
         var _loc2_:TreeNode = this._treeView.getSelectedNode();
         if(_loc2_ != null)
         {
            _loc1_ = EPackageItem(_loc2_.data);
            return _loc1_;
         }
         return null;
      }
      
      public function getSelectedItems(param1:Boolean) : Vector.<EPackageItem>
      {
         var _loc5_:TreeNode = null;
         var _loc4_:EPackageItem = null;
         var _loc9_:Vector.<TreeNode> = this._treeView.getSelection();
         var _loc7_:Vector.<EPackageItem> = new Vector.<EPackageItem>();
         var _loc8_:int = _loc9_.length;
         if(_loc8_ == 0)
         {
            return _loc7_;
         }
         var _loc2_:EUIPackage = _loc9_[0].data.owner;
         var _loc3_:Vector.<TreeNode> = new Vector.<TreeNode>();
         var _loc6_:int = 0;
         while(_loc6_ < _loc8_)
         {
            _loc5_ = _loc9_[_loc6_];
            if(_loc3_.indexOf(_loc5_.parent) != -1)
            {
               if(_loc5_.isFolder)
               {
                  _loc3_.push(_loc5_);
               }
            }
            else
            {
               _loc4_ = EPackageItem(_loc5_.data);
               if(_loc4_.owner == _loc2_)
               {
                  _loc7_.push(_loc4_);
                  if(param1 && _loc4_.type == "folder")
                  {
                     _loc2_.getFolderContent(_loc4_,null,false,_loc7_,true);
                     _loc3_.push(_loc5_);
                  }
               }
            }
            _loc6_++;
         }
         return _loc7_;
      }
      
      public function getSelectedFolderInPackage(param1:EUIPackage) : EPackageItem
      {
         var _loc3_:TreeNode = this._treeView.getSelectedNode();
         if(_loc3_ == null)
         {
            _loc3_ = this._treeView.root.getChildAt(0);
         }
         var _loc2_:EPackageItem = EPackageItem(_loc3_.data);
         if(_loc2_.owner == param1)
         {
            if(_loc2_.type == "folder")
            {
               return _loc2_;
            }
            return _loc2_.owner.getItem(_loc2_.path);
         }
         return _loc2_.owner.rootItem;
      }
      
      public function updatePackages() : void
      {
         this.notifyRootChanged();
         this._disableSelectionChange = true;
         this.handleChanges();
      }
      
      public function updateItem(param1:EPackageItem) : void
      {
         this._treeView.updateNode(param1.treeNode);
      }
      
      public function collapseAll() : void
      {
         this._treeView.collapseAll(this._treeView.root);
      }
      
      private function addFolderContent(param1:TreeNode) : void
      {
         var _loc4_:EPackageItem = null;
         var _loc2_:TreeNode = null;
         var _loc5_:EPackageItem = EPackageItem(param1.data);
         var _loc3_:Vector.<EPackageItem> = _loc5_.owner.getFolderContent(_loc5_);
         var _loc7_:int = 0;
         var _loc6_:* = _loc3_;
         for each(_loc4_ in _loc3_)
         {
            _loc2_ = new TreeNode(_loc4_.type == "folder");
            _loc2_.data = _loc4_;
            _loc4_.treeNode = _loc2_;
            _loc4_.nodeStatus = _loc4_.errorStatus;
            param1.addChild(_loc2_);
            if(_loc4_.type == "folder")
            {
               this.addFolderContent(_loc2_);
            }
         }
      }
      
      public function saveState(param1:WorkSpace) : void
      {
         var _loc2_:TreeNode = null;
         var _loc3_:EPackageItem = null;
         var _loc6_:Array = [];
         var _loc4_:int = this._treeView.root.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this._treeView.root.getChildAt(_loc5_);
            _loc3_ = EPackageItem(_loc2_.data);
            if(_loc2_.isFolder && _loc2_.expanded)
            {
               _loc6_.push(_loc3_.owner.id,_loc3_.id);
            }
            _loc5_++;
         }
         param1.expanded_nodes = _loc6_;
      }
      
      public function restoreState(param1:WorkSpace) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:EUIPackage = null;
         var _loc7_:Array = param1.expanded_nodes;
         var _loc5_:int = _loc7_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = _loc7_[_loc6_];
            _loc3_ = _loc7_[_loc6_ + 1];
            _loc4_ = this._editorWindow.project.getPackage(_loc2_);
            if(_loc4_ && _loc4_.rootItem.treeNode)
            {
               _loc4_.rootItem.treeNode.expanded = true;
            }
            _loc6_ = _loc6_ + 2;
         }
      }
      
      public function highlightItem(param1:EPackageItem) : void
      {
         this._treeView.clearSelection();
         if(param1.owner.rootItem.treeNode == null)
         {
            return;
         }
         param1.owner.rootItem.treeNode.expanded = true;
         if(param1.treeNode)
         {
            this._treeView.addSelection(param1.treeNode);
            this._treeView.list.scrollPane.scrollToView(param1.treeNode.cell);
            this._editorWindow.mainPanel.previewPanel.refresh();
            this._parentPanel.requestFocus();
         }
      }
      
      public function treeNodeCreateCell(param1:TreeNode) : GComponent
      {
         var _loc2_:EditableTreeItem = EditableTreeItem(this._treeView.list.getFromPool());
         _loc2_.draggable = true;
         _loc2_.toggleClickCount = 0;
         _loc2_.setActive(this._active);
         _loc2_.addEventListener("startDrag",this.__dragNodeStart);
         _loc2_.addEventListener("__submit",this.__treeNodeEdited);
         return _loc2_;
      }
      
      public function treeNodeRender(param1:TreeNode, param2:GComponent) : void
      {
         var _loc4_:GButton = param2.asButton;
         var _loc5_:EPackageItem = param1.data as EPackageItem;
         if(_loc5_.errorStatus)
         {
            _loc4_.getTextField().ubbEnabled = true;
            _loc4_.title = "[color=#ff7272]" + _loc5_.name + "[/color]";
         }
         else
         {
            _loc4_.getTextField().ubbEnabled = false;
            _loc4_.title = _loc5_.name;
         }
         var _loc3_:GLoader = param2.getChild("sign") as GLoader;
         if(param1.isFolder)
         {
            if(_loc5_.id == "/")
            {
               _loc4_.icon = Icons.all["package"];
            }
            else
            {
               _loc4_.icon = Icons.all.folder;
            }
            _loc3_.url = null;
         }
         else
         {
            _loc4_.icon = Icons.all[_loc5_.type];
            if(_loc5_.exported)
            {
               _loc3_.url = "ui://Builder/bullet_red";
            }
            else
            {
               _loc3_.url = null;
            }
         }
      }
      
      public function treeNodeWillExpand(param1:TreeNode, param2:Boolean) : void
      {
         if(!param2 || this._updating)
         {
            return;
         }
         var _loc3_:EPackageItem = param1.data as EPackageItem;
         if(_loc3_.id == "/")
         {
            if(!_loc3_.exported)
            {
               _loc3_.exported = true;
               _loc3_.owner.ensureOpen();
               this.addFolderContent(param1);
            }
         }
      }
      
      public function treeNodeClick(param1:TreeNode, param2:ItemEvent) : void
      {
         var _loc5_:* = null;
         var _loc4_:EPackageItem = param1.data as EPackageItem;
         var _loc6_:* = _loc4_.type == "folder";
         var _loc3_:Boolean = this.hasClipboardData();
         if(param2.rightButton)
         {
            if(_loc4_.id == "/")
            {
               this._pkgMenu.setItemGrayed("paste",!_loc3_);
               this._pkgMenu.setItemGrayed("pasteAll",!_loc3_);
               this._pkgMenu.show(this._editorWindow.groot);
            }
            else
            {
               if(_loc4_.name != "Main" || _loc4_.type != "component")
               {
                  this._menu.setItemGrayed("publishComponet",true);
               }
               else
               {
                  _loc5_ = _loc4_.path;
                  _loc5_ = _loc5_.substr(1,_loc5_.length - 2);
                  PackagesPanel.PUBLIC_COMPONENT_OBJECT = {
                     "pacakgeName":_loc5_,
                     "componentID":_loc4_.id
                  };
                  this._menu.setItemGrayed("publishComponet",false);
               }
               this._menu.setItemGrayed("property",_loc6_);
               this._menu.setItemGrayed("update",_loc6_ || _loc4_.type == "component");
               this._menu.setItemGrayed("copyLink",_loc6_);
               this._menu.setItemGrayed("findRef",_loc6_);
               this._menu.setItemGrayed("paste",!_loc3_);
               this._menu.setItemGrayed("pasteAll",!_loc3_);
               this._menu.setItemGrayed("duplicate",_loc4_.type != "component");
               this._menu.show(this._editorWindow.groot);
            }
         }
         else if(!_loc6_)
         {
            if(param2.clickCount == 2)
            {
               this._editorWindow.mainPanel.openItem(_loc4_);
            }
         }
         else if(param2.clickCount == 2)
         {
            param1.expanded = !param1.expanded;
         }
         this._editorWindow.mainPanel.previewPanel.refresh();
      }
      
      private function getSelectionForDragging() : Array
      {
         var _loc4_:TreeNode = null;
         var _loc3_:EPackageItem = null;
         var _loc9_:Vector.<TreeNode> = this._treeView.getSelection();
         var _loc8_:int = _loc9_.length;
         var _loc6_:Array = [];
         var _loc7_:int = _loc9_[0].level;
         var _loc1_:EUIPackage = _loc9_[0].data.owner;
         var _loc2_:int = 2147483647;
         var _loc5_:int = 0;
         while(_loc5_ < _loc8_)
         {
            _loc4_ = _loc9_[_loc5_];
            if(_loc4_.level <= _loc2_)
            {
               _loc2_ = _loc4_.level;
               if(!(_loc4_.level < _loc7_ || _loc4_.data.owner != _loc1_))
               {
                  _loc3_ = EPackageItem(_loc4_.data);
                  _loc6_.push(_loc3_);
               }
            }
            _loc5_++;
         }
         return _loc6_;
      }
      
      private function __dragNodeStart(param1:DragEvent) : void
      {
         param1.preventDefault();
         var _loc2_:GButton = GButton(param1.currentTarget);
         if(!_loc2_.selected)
         {
            this._treeView.clearSelection();
            this._treeView.addSelection(TreeNode(_loc2_.data));
         }
         this._editorWindow.dragManager.startDrag(this._editorWindow.mainPanel.libPanel,this.getSelectionForDragging());
      }
      
      private function __treeNodeEdited(param1:Event) : void
      {
         var _loc2_:TreeNode = null;
         var _loc4_:EPackageItem = null;
         var _loc3_:* = param1;
         _loc2_ = TreeNode(_loc3_.currentTarget.data);
         _loc4_ = _loc2_.data as EPackageItem;
         try
         {
            _loc4_.owner.renameItem(_loc4_,_loc2_.text,true);
            return;
         }
         catch(err:Error)
         {
            _loc2_.cell.asButton.title = _loc4_.name;
            _editorWindow.alertError(err);
            return;
         }
      }
      
      private function __menuRename(param1:Event) : void
      {
         var _loc2_:TreeNode = this._treeView.getSelectedNode();
         EditableTreeItem(_loc2_.cell).startEditing();
      }
      
      private function __menuOpenInExplorer(param1:Event) : void
      {
         var _loc3_:TreeNode = this._treeView.getSelectedNode();
         var _loc2_:EPackageItem = EPackageItem(_loc3_.data);
         this._editorWindow.mainPanel.openItemInExplorer(_loc2_);
      }
      
      private function __menuPublishComponet(param1:Event) : void
      {
         PackagesPanel.PUBLIC_OK = true;
         PublishDialog(_editorWindow.getDialog(PublishDialog)).openOrPublish();
      }
      
      private function __menuOpenWithExternal(param1:Event) : void
      {
         var _loc3_:TreeNode = this._treeView.getSelectedNode();
         var _loc2_:EPackageItem = EPackageItem(_loc3_.data);
         _loc2_.file.openWithDefaultApplication();
      }
      
      private function __menuCopyLink(param1:Event) : void
      {
         var _loc3_:TreeNode = this._treeView.getSelectedNode();
         var _loc2_:EPackageItem = EPackageItem(_loc3_.data);
         Clipboard.generalClipboard.setData("air:text","ui://" + _loc2_.owner.id + _loc2_.id);
      }
      
      private function __menuCopyName(param1:Event) : void
      {
         var _loc3_:TreeNode = this._treeView.getSelectedNode();
         var _loc2_:EPackageItem = EPackageItem(_loc3_.data);
         Clipboard.generalClipboard.setData("air:text",_loc2_.name);
      }
      
      private function __menuSetExport(param1:Event) : void
      {
         this.setSelectionFlag("exported",true);
      }
      
      private function __menuSetNotExport(param1:Event) : void
      {
         this.setSelectionFlag("exported",false);
      }
      
      private function __menuAddFavorite(param1:Event) : void
      {
         this.setSelectionFlag("favorite",true);
      }
      
      private function setSelectionFlag(param1:String, param2:Boolean) : void
      {
         var _loc3_:EUIPackage = null;
         var _loc4_:Boolean = false;
         var _loc6_:TreeNode = null;
         var _loc5_:EPackageItem = null;
         var _loc8_:Vector.<TreeNode> = this._treeView.getSelection();
         if(_loc8_.length == 0)
         {
            return;
         }
         var _loc9_:int = _loc8_.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc9_)
         {
            _loc6_ = _loc8_[_loc7_];
            _loc5_ = EPackageItem(_loc6_.data);
            if(_loc5_.id != "/")
            {
               if(!_loc3_)
               {
                  _loc3_ = _loc5_.owner;
               }
               else if(_loc3_ != _loc5_.owner)
               {
                  break;
               }
               if(_loc5_.type == "folder")
               {
                  if(this.setChildrenFlag(_loc6_,param1,param2))
                  {
                     _loc4_ = true;
                  }
               }
               else if(_loc5_[param1] != param2)
               {
                  _loc5_[param1] = param2;
                  _loc4_ = true;
                  this._treeView.updateNode(_loc6_);
               }
            }
            _loc7_++;
         }
         if(_loc4_)
         {
            _loc3_.save();
            if(param1 == "favorite")
            {
               this._editorWindow.mainPanel.libPanel.favoritesPanel.updatePackage(_loc3_);
            }
         }
      }
      
      private function setChildrenFlag(param1:TreeNode, param2:String, param3:Boolean) : Boolean
      {
         var _loc7_:TreeNode = null;
         var _loc6_:EPackageItem = null;
         var _loc8_:Boolean = false;
         var _loc4_:int = param1.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = param1.getChildAt(_loc5_);
            _loc6_ = EPackageItem(_loc7_.data);
            if(_loc6_.type == "folder")
            {
               if(this.setChildrenFlag(_loc7_,param2,param3))
               {
                  _loc8_ = true;
               }
            }
            else if(_loc6_[param2] != param3)
            {
               _loc6_[param2] = param3;
               _loc8_ = true;
               this._treeView.updateNode(_loc7_);
            }
            _loc5_++;
         }
         return _loc8_;
      }
      
      private function __menuUpdate(param1:Event) : void
      {
         var _loc3_:TreeNode = this._treeView.getSelectedNode();
         var _loc2_:EPackageItem = EPackageItem(_loc3_.data);
         this._editorWindow.mainPanel.selectForUpdateResource(_loc2_);
      }
      
      private function __menuDelete(param1:Event) : void
      {
         var _loc6_:String = null;
         var _loc5_:TreeNode = null;
         var _loc4_:EPackageItem = null;
         var _loc9_:Vector.<TreeNode> = this._treeView.getSelection();
         if(_loc9_.length == 0)
         {
            return;
         }
         var _loc7_:* = "";
         var _loc8_:int = _loc9_.length;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc8_)
         {
            _loc5_ = _loc9_[_loc3_];
            _loc4_ = EPackageItem(_loc5_.data);
            if(_loc4_.id != "/")
            {
               if(_loc2_ < 2)
               {
                  if(_loc7_)
                  {
                     _loc7_ = _loc7_ + ",";
                  }
                  _loc7_ = _loc7_ + _loc4_.name;
               }
               _loc2_++;
            }
            _loc3_++;
         }
         if(_loc2_ > 1)
         {
            _loc6_ = UtilsStr.formatString(Consts.g.text30,_loc7_,_loc2_);
         }
         else
         {
            _loc6_ = UtilsStr.formatString(Consts.g.text31,_loc7_);
         }
         this._editorWindow.confirm(_loc6_,this.deleteSelection);
      }
      
      private function deleteSelection() : void
      {
         var _loc1_:TreeNode = null;
         var _loc2_:EPackageItem = null;
         var _loc3_:TreeNode = null;
         var _loc7_:Vector.<TreeNode> = this._treeView.getSelection();
         if(_loc7_.length == 0)
         {
            return;
         }
         var _loc6_:Vector.<EPackageItem> = new Vector.<EPackageItem>();
         var _loc4_:int = _loc7_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_ = _loc7_[_loc5_];
            _loc2_ = EPackageItem(_loc1_.data);
            _loc6_.push(_loc2_);
            if(_loc5_ == _loc4_ - 1)
            {
               _loc3_ = _loc1_.getNextSibling();
               if(_loc3_ == null)
               {
                  _loc3_ = _loc1_.parent.getNextSibling();
               }
               if(_loc3_)
               {
                  this._treeView.addSelection(_loc3_);
               }
            }
            _loc1_.parent.removeChild(_loc1_);
            _loc5_++;
         }
         _loc6_[0].owner.deleteItems(_loc6_);
         this._parentPanel.requestFocus();
         this._editorWindow.mainPanel.editPanel.refreshDocument();
         this._editorWindow.mainPanel.previewPanel.refresh();
      }
      
      private function __menuDeletePkg(param1:Event) : void
      {
         var _loc4_:TreeNode = this._treeView.getSelectedNode();
         var _loc2_:EPackageItem = EPackageItem(_loc4_.data);
         var _loc3_:String = UtilsStr.formatString(Consts.g.text32,_loc2_.name);
         this._editorWindow.confirm(_loc3_,this.confirmDeletePackage);
      }
      
      private function confirmDeletePackage() : void
      {
         var _loc2_:TreeNode = this._treeView.getSelectedNode();
         var _loc1_:EPackageItem = EPackageItem(_loc2_.data);
         this._editorWindow.project.deletePackage(_loc1_.owner.id);
         this._parentPanel.requestFocus();
      }
      
      private function __menuNewFolder(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc5_:TreeNode = this._treeView.getSelectedNode();
         var _loc4_:EPackageItem = EPackageItem(_loc5_.data);
         if(_loc4_.type == "folder")
         {
            _loc3_ = _loc4_;
         }
         else
         {
            _loc3_ = _loc4_.owner.getItem(_loc4_.path);
            _loc5_ = _loc5_.parent;
         }
         _loc5_.expanded = true;
         var _loc2_:EPackageItem = _loc4_.owner.createFolder2(_loc3_,null);
         this.handleChanges();
         EditableTreeItem(_loc2_.treeNode.cell).startEditing();
      }
      
      private function __menuProperty(param1:Event) : void
      {
         var _loc4_:Vector.<EPackageItem> = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:EPackageItem = null;
         var _loc6_:Vector.<TreeNode> = this._treeView.getSelection();
         if(_loc6_.length > 1)
         {
            _loc4_ = new Vector.<EPackageItem>();
            _loc5_ = _loc6_.length;
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               _loc4_.push(_loc6_[_loc2_].data);
               _loc2_++;
            }
            this._editorWindow.mainPanel.openItems(_loc4_);
         }
         else
         {
            _loc3_ = EPackageItem(_loc6_[0].data);
            this._editorWindow.mainPanel.openItem(_loc3_);
         }
      }
      
      public function doCopy() : void
      {
         var _loc1_:Vector.<EPackageItem> = this.getSelectedItems(true);
         if(_loc1_.length > 0)
         {
            _copiedItems = _loc1_;
            Clipboard.generalClipboard.setData("fairygui.PackageItem","fairygui.PackageItem");
         }
      }
      
      public function doPaste(param1:Boolean) : void
      {
         var _loc6_:BitmapData = null;
         var _loc2_:ByteArray = null;
         var _loc3_:File = null;
         var _loc4_:File = null;
         var _loc7_:TreeNode = this._treeView.getSelectedNode();
         if(_loc7_ == null)
         {
            return;
         }
         var _loc5_:EPackageItem = EPackageItem(_loc7_.data);
         if(Clipboard.generalClipboard.hasFormat("air:bitmap"))
         {
            _loc6_ = Clipboard.generalClipboard.getData("air:bitmap") as BitmapData;
            _loc2_ = _loc6_.encode(_loc6_.rect,new PNGEncoderOptions());
            _loc3_ = new File(this._editorWindow.project.objsPath + "/temp");
            if(!_loc3_.exists)
            {
               _loc3_.createDirectory();
            }
            _loc4_ = _loc3_.resolvePath("Bitmap.png");
            UtilsFile.saveBytes(_loc4_,_loc2_);
            this._editorWindow.mainPanel.importResources([_loc4_],_loc5_.owner,[_loc5_.type == "folder"?_loc5_.id:_loc5_.path]);
         }
         else
         {
            if(!Clipboard.generalClipboard.hasFormat("fairygui.PackageItem") || _copiedItems == null)
            {
               return;
            }
            this.doPasteItems(_copiedItems,_loc7_,param1);
         }
      }
      
      private function doPasteItems(param1:Vector.<EPackageItem>, param2:TreeNode, param3:Boolean) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var dropTarget:EPackageItem = null;
         var copyHandler:CopyHandler = null;
         var items:Vector.<EPackageItem> = param1;
         var targetNode:TreeNode = param2;
         var ignoreExported:Boolean = param3;
         dropTarget = EPackageItem(targetNode.data);
         if(dropTarget.type != "folder" || items[0].id == dropTarget.id)
         {
            targetNode = targetNode.parent;
            dropTarget = EPackageItem(targetNode.data);
         }
         targetNode.expanded = true;
         copyHandler = new CopyHandler();
         copyHandler.copy(items,dropTarget.owner,dropTarget.id,ignoreExported);
         if(copyHandler.existsItemCount > 0)
         {
            PasteOptionDialog(this._editorWindow.getDialog(PasteOptionDialog)).open(function(param1:int):void
            {
               copyHandler.paste(dropTarget.owner,param1);
               _parentPanel.requestFocus();
               _editorWindow.mainPanel.editPanel.refreshDocument();
            });
         }
         else
         {
            copyHandler.paste(dropTarget.owner,0);
            this._parentPanel.requestFocus();
            this._editorWindow.mainPanel.editPanel.refreshDocument();
         }
      }
      
      public function hasClipboardData() : Boolean
      {
         return Clipboard.generalClipboard.hasFormat("air:bitmap") || Clipboard.generalClipboard.hasFormat("fairygui.PackageItem") && _copiedItems != null;
      }
      
      private function __menuCopy(param1:Event) : void
      {
         this.doCopy();
      }
      
      private function __menuPaste(param1:Event) : void
      {
         this.doPaste(true);
      }
      
      private function __menuPasteAll(param1:Event) : void
      {
         this.doPaste(false);
      }
      
      private function __menuMove(param1:Event) : void
      {
         param1 = param1;
         var pkg:EUIPackage = null;
         var evt:Event = param1;
         var node:TreeNode = this._treeView.getSelectedNode();
         pkg = EPackageItem(node.data).owner;
         ChooseFolderDialog(this._editorWindow.getDialog(ChooseFolderDialog)).open(pkg,"",function(param1:String):void
         {
            var _loc2_:Array = getSelectionForDragging();
            doDrop(pkg.getItem(param1).treeNode,_loc2_);
         });
      }
      
      private function __menuDuplicate(param1:Event) : void
      {
         var _loc3_:TreeNode = this._treeView.getSelectedNode();
         var _loc2_:Vector.<EPackageItem> = new Vector.<EPackageItem>();
         _loc2_.push(EPackageItem(_loc3_.data));
         FixConflictedNameDialog(this._editorWindow.getDialog(FixConflictedNameDialog)).open(_loc2_,_loc2_[0].path,this.doDuplicateAfterRename);
      }
      
      private function doDuplicateAfterRename(param1:Vector.<EPackageItem>, param2:Vector.<String>) : void
      {
         var _loc6_:EPackageItem = null;
         var _loc3_:EPackageItem = null;
         var _loc5_:* = param1;
         var _loc4_:* = param2;
         try
         {
            _loc6_ = _loc5_[0];
            _loc3_ = _loc6_.owner.duplicateItem(_loc6_,_loc4_[0]);
            this._editorWindow.mainPanel.openItem(_loc3_);
            return;
         }
         catch(err:Error)
         {
            _editorWindow.alertError(err);
            return;
         }
      }
      
      private function __menuNewCom(param1:Event) : void
      {
         this._editorWindow.getDialog(CreateComDialog).show();
      }
      
      public function handleKeyDownEvent(param1:KeyboardEvent) : void
      {
         var _loc7_:TreeNode = null;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:EPackageItem = null;
         var _loc6_:* = null;
         var _loc5_:int = 0;
         var _loc4_:TreeNode = null;
         var _loc9_:String = String.fromCharCode(param1.charCode).toLowerCase();
         var _loc10_:* = param1.keyCode;
         if(46 !== _loc10_)
         {
            if(13 !== _loc10_)
            {
               if(113 !== _loc10_)
               {
                  if(param1.ctrlKey && !param1.altKey)
                  {
                     _loc10_ = _loc9_;
                     if("c" !== _loc10_)
                     {
                        if("v" === _loc10_)
                        {
                           this.doPaste(true);
                           return;
                        }
                     }
                     else
                     {
                        this.doCopy();
                        return;
                     }
                  }
                  if(!param1.ctrlKey && !param1.altKey && param1.charCode >= 48 && param1.charCode <= 122)
                  {
                     _loc7_ = this._treeView.getSelectedNode();
                     if(!_loc7_)
                     {
                        _loc7_ = this._treeView.root.getChildAt(0);
                     }
                     if(_loc7_)
                     {
                        _loc8_ = _loc7_.parent.getChildIndex(_loc7_);
                        _loc2_ = _loc7_.parent.numChildren;
                        if(_loc2_ == 0)
                        {
                           return;
                        }
                        _loc5_ = _loc8_ + 1;
                        while(_loc5_ < _loc2_)
                        {
                           _loc4_ = _loc7_.parent.getChildAt(_loc5_);
                           _loc3_ = EPackageItem(_loc4_.data);
                           if(_loc3_.firstLetter == _loc9_)
                           {
                              _loc6_ = _loc4_;
                              break;
                           }
                           _loc5_++;
                        }
                        if(!_loc6_)
                        {
                           _loc5_ = 0;
                           while(_loc5_ < _loc8_)
                           {
                              _loc4_ = _loc7_.parent.getChildAt(_loc5_);
                              _loc3_ = EPackageItem(_loc4_.data);
                              if(_loc3_.firstLetter == _loc9_)
                              {
                                 _loc6_ = _loc4_;
                                 break;
                              }
                              _loc5_++;
                           }
                        }
                        if(_loc6_)
                        {
                           this._treeView.clearSelection();
                           this._treeView.addSelection(_loc6_,true);
                           this._editorWindow.mainPanel.previewPanel.refresh();
                        }
                     }
                  }
                  return;
               }
               _loc7_ = this._treeView.getSelectedNode();
               if(_loc7_ != null)
               {
                  EditableTreeItem(_loc7_.cell).startEditing();
               }
               return;
            }
            this.__menuProperty(null);
            return;
         }
         _loc7_ = this._treeView.getSelectedNode();
         if(_loc7_ != null)
         {
            if(EPackageItem(_loc7_.data).id == "/")
            {
               this.__menuDeletePkg(null);
            }
            else
            {
               this.__menuDelete(null);
            }
         }
      }
      
      public function handleKeyUpEvent(param1:KeyboardEvent) : void
      {
      }
      
      public function handleArrowKey(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this._treeView.list.handleArrowKey(param1);
         this._editorWindow.mainPanel.previewPanel.refresh();
      }
      
      private function getPackageNodeUnderPoint(param1:Number, param2:Number) : TreeNode
      {
         var _loc4_:* = null;
         var _loc6_:TreeNode = null;
         var _loc5_:* = 0;
         var _loc8_:* = param2;
         var _loc9_:int = this._treeView.root.numChildren;
         var _loc3_:int = 2147483647;
         var _loc7_:int = 0;
         while(_loc7_ < _loc9_)
         {
            _loc6_ = this._treeView.root.getChildAt(_loc7_);
            _loc5_ = int(_loc6_.cell.y + _loc6_.cell.height / 2 - _loc8_);
            if(_loc5_ < _loc3_)
            {
               _loc5_ = _loc3_;
               _loc4_ = _loc6_;
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      public function getFolderItemUnderPoint(param1:Number, param2:Number) : EPackageItem
      {
         var _loc4_:TreeNode = null;
         var _loc5_:GObject = this._treeView.list.getItemNear(param1,param2);
         if(_loc5_ != null)
         {
            _loc4_ = TreeNode(_loc5_.data);
         }
         else
         {
            _loc4_ = this.getPackageNodeUnderPoint(param1,param2);
            if(_loc4_ == null)
            {
               return null;
            }
         }
         var _loc3_:EPackageItem = EPackageItem(_loc4_.data);
         if(_loc3_.type != "folder")
         {
            _loc3_ = _loc3_.owner.getItem(_loc3_.path);
         }
         return _loc3_;
      }
      
      private function __drop(param1:DropEvent) : void
      {
         var _loc5_:TreeNode = null;
         if(!(param1.source is LibPanel))
         {
            return;
         }
         var _loc3_:Number = this._editorWindow.groot.nativeStage.mouseX;
         var _loc4_:Number = this._editorWindow.groot.nativeStage.mouseY;
         var _loc2_:GObject = this._treeView.list.getItemNear(_loc3_,_loc4_);
         if(_loc2_ != null)
         {
            _loc5_ = TreeNode(_loc2_.data);
         }
         else
         {
            _loc5_ = this.getPackageNodeUnderPoint(_loc3_,_loc4_);
            if(_loc5_ == null)
            {
               return;
            }
         }
         this.doDrop(_loc5_,param1.sourceData);
      }
      
      private function doDrop(param1:TreeNode, param2:Object) : void
      {
         var _loc10_:String = null;
         var _loc9_:int = 0;
         var _loc8_:int = 0;
         var _loc5_:EPackageItem = null;
         var _loc6_:TreeNode = null;
         var _loc11_:EPackageItem = EPackageItem(param1.data);
         var _loc3_:EUIPackage = _loc11_.owner;
         if(_loc11_.type != "folder")
         {
            _loc10_ = _loc11_.path;
            param1 = param1.parent;
            _loc11_ = EPackageItem(param1.data);
         }
         else
         {
            _loc10_ = _loc11_.id;
         }
         _loc11_.treeNode.expanded = true;
         var _loc4_:int = param2.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = EPackageItem(param2[_loc7_]);
            if(_loc5_.owner != _loc11_.owner)
            {
               this._editorWindow.alert(Consts.g.text33);
               return;
            }
            _loc6_ = _loc5_.treeNode;
            if(!_loc5_.owner.moveItem(_loc5_,_loc10_))
            {
            }
            _loc7_++;
         }
      }
      
      private function __menuFindRef(param1:Event) : void
      {
         var _loc3_:TreeNode = this._treeView.getSelectedNode();
         var _loc2_:EPackageItem = EPackageItem(_loc3_.data);
         FindReferenceDialog(this._editorWindow.getDialog(FindReferenceDialog)).open(_loc2_);
      }
      
      public function notifyRootChanged() : void
      {
         this.notifyChanged(this._treeView.root);
      }
      
      public function notifyChanged(param1:TreeNode) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!param1.isFolder)
         {
            param1 = param1.parent;
         }
         if(this._changedNodes.indexOf(param1) == -1)
         {
            this._changedNodes.push(param1);
            GTimers.inst.callLater(this.handleChanges);
         }
      }
      
      private function handleChanges() : void
      {
         var _loc8_:EPackageItem = null;
         var _loc7_:TreeNode = null;
         var _loc5_:EPackageItem = null;
         var _loc6_:TreeNode = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:* = null;
         var _loc3_:Boolean = false;
         this._updating = true;
         var _loc12_:int = 0;
         var _loc11_:* = this._changedNodes;
         for each(_loc7_ in this._changedNodes)
         {
            if(_loc7_.tree)
            {
               this._helperList.length = 0;
               _loc8_ = EPackageItem(_loc7_.data);
               if(_loc8_ == null)
               {
                  this._editorWindow.project.getPackageRootItems(this._helperList);
               }
               else
               {
                  _loc8_.owner.getFolderContent(_loc8_,null,true,this._helperList);
               }
               _loc2_ = 0;
               var _loc10_:int = 0;
               var _loc9_:* = this._helperList;
               for each(_loc5_ in this._helperList)
               {
                  _loc6_ = _loc5_.treeNode;
                  if(_loc6_)
                  {
                     if(_loc6_.parent == _loc7_)
                     {
                        _loc2_++;
                        _loc7_.setChildIndex(_loc6_,_loc2_);
                        _loc3_ = false;
                     }
                     else
                     {
                        _loc2_++;
                        _loc7_.addChildAt(_loc6_,_loc2_);
                        _loc3_ = true;
                     }
                  }
                  else
                  {
                     _loc3_ = true;
                     _loc6_ = new TreeNode(_loc5_.type == "folder");
                     _loc6_.data = _loc5_;
                     _loc5_.treeNode = _loc6_;
                     _loc5_.nodeStatus = _loc5_.errorStatus;
                     _loc2_++;
                     _loc7_.addChildAt(_loc6_,_loc2_);
                     if(_loc6_.isFolder)
                     {
                        if(_loc5_.id != "/" || _loc5_.exported)
                        {
                           this.addFolderContent(_loc6_);
                        }
                     }
                  }
                  if(_loc3_)
                  {
                     if(!_loc4_ && !this._disableSelectionChange)
                     {
                        this._treeView.clearSelection();
                     }
                     _loc4_ = _loc6_;
                     if(!this._disableSelectionChange)
                     {
                        this._treeView.addSelection(_loc6_);
                     }
                  }
               }
               _loc7_.removeChildren(_loc2_,_loc7_.numChildren);
            }
         }
         this._changedNodes.length = 0;
         this._helperList.length = 0;
         if(_loc4_ && !this._disableSelectionChange)
         {
            if(_loc4_.cell)
            {
               this._treeView.list.scrollPane.scrollToView(_loc4_.cell);
            }
            this._editorWindow.mainPanel.previewPanel.refresh();
         }
         this._disableSelectionChange = false;
         this._updating = false;
      }
   }
}

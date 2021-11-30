package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GLoader;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.handlers.CopyHandler;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   import fairygui.tree.ITreeListener;
   import fairygui.tree.TreeNode;
   import fairygui.tree.TreeView;
   import fairygui.utils.ZipReader;
   import flash.events.Event;
   import flash.filesystem.File;
   
   public class ImportPackageDialog extends WindowBase implements ITreeListener
   {
       
      
      private var _treeView:TreeView;
      
      private var _treeItemUrl:String;
      
      private var _exportedSignUrl:String;
      
      private var _sourcePkg:EUIPackage;
      
      private var _targetPkg:EUIPackage;
      
      private var _path:String;
      
      private var _copyHandler:CopyHandler;
      
      public function ImportPackageDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ImportPackageDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._treeItemUrl = UIPackage.getItemURL("Basic","TreeItem");
         this._exportedSignUrl = UIPackage.getItemURL("Builder","bullet_red");
         this._treeView = new TreeView(contentPane.getChild("list").asList);
         this._treeView.listener = this;
         this.contentPane.getChild("browse").addClickListener(this.__browse);
         contentPane.getChild("ok").addClickListener(__actionHandler);
         contentPane.getChild("cancel").addClickListener(closeEventHandler);
      }
      
      override protected function onHide() : void
      {
         var _loc1_:File = null;
         super.onHide();
         if(this._sourcePkg)
         {
            try
            {
               _loc1_ = new File(this._sourcePkg.project.basePath);
               if(_loc1_.exists)
               {
                  _loc1_.deleteDirectory(true);
               }
            }
            catch(err:Error)
            {
            }
            this._sourcePkg.project.close();
            this._sourcePkg = null;
         }
      }
      
      public function open(param1:File) : void
      {
         var _loc3_:Object = null;
         var _loc6_:TreeNode = null;
         var _loc5_:File = null;
         var _loc4_:File = null;
         var _loc9_:File = File.createTempDirectory();
         EUIProject.createNew(_loc9_.nativePath,"tempProject",_editorWindow.project.type);
         var _loc7_:EUIProject = new EUIProject(null);
         _loc7_.open(_loc9_.resolvePath("tempProject.fairy"));
         var _loc8_:File = new File(_loc7_.assetsPath).resolvePath("Assets");
         _loc8_.createDirectory();
         var _loc2_:ZipReader = new ZipReader(UtilsFile.loadBytes(param1));
         var _loc11_:int = 0;
         var _loc10_:* = _loc2_.entries;
         for each(_loc3_ in _loc2_.entries)
         {
            _loc5_ = _loc8_.resolvePath(_loc3_.name);
            _loc4_ = _loc5_.parent;
            if(!_loc4_.exists)
            {
               _loc4_.createDirectory();
            }
            UtilsFile.saveBytes(_loc5_,_loc2_.getEntryData(_loc3_.name));
         }
         this._sourcePkg = _loc7_.addPackage(_loc8_);
         this._sourcePkg.ensureOpen();
         this._treeView.root.removeChildren();
         _loc6_ = new TreeNode(true);
         _loc6_.data = this._sourcePkg.rootItem;
         this._treeView.root.addChild(_loc6_);
         this.addFolder(_loc6_,this._sourcePkg.rootItem);
         this._treeView.expandAll(this._treeView.root);
         this._treeView.list.scrollPane.scrollTop();
         contentPane.getController("c1").selectedIndex = 0;
         contentPane.getChild("targetPackage").text = UtilsStr.getFileName(param1.name);
         this._targetPkg = _editorWindow.mainPanel.getActivePackage();
         this._path = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedFolderInPackage(this._targetPkg).id;
         this.__selectFolder(this._path);
         show();
      }
      
      override public function actionHandler() : void
      {
         var pkg:EUIPackage = null;
         var path:String = null;
         var toNew:Boolean = contentPane.getController("c1").selectedIndex == 0;
         if(toNew)
         {
            try
            {
               pkg = _editorWindow.project.createPackage(contentPane.getChild("targetPackage").text);
            }
            catch(err:Error)
            {
               _editorWindow.alertError(err);
               return;
            }
            _editorWindow.mainPanel.libPanel.updatePackages();
            path = "/";
         }
         else
         {
            pkg = this._targetPkg;
            path = this._path;
         }
         this._copyHandler = new CopyHandler();
         this._copyHandler.copy(this._sourcePkg.resources,pkg,path);
         if(this._copyHandler.existsItemCount > 0)
         {
            PasteOptionDialog(_editorWindow.getDialog(PasteOptionDialog)).open(function(param1:int):void
            {
               _editorWindow.cursorManager.setWaitCursor(true);
               _copyHandler.paste(pkg,param1);
               _editorWindow.cursorManager.setWaitCursor(false);
               _editorWindow.mainPanel.libPanel.favoritesPanel.updatePackages();
               _editorWindow.mainPanel.editPanel.refreshDocument();
               hide();
            });
         }
         else
         {
            _editorWindow.cursorManager.setWaitCursor(true);
            this._copyHandler.paste(pkg,0);
            _editorWindow.cursorManager.setWaitCursor(false);
            if(toNew)
            {
               _editorWindow.mainPanel.libPanel.pkgsPanel.highlightItem(pkg.rootItem);
               pkg.rootItem.treeNode.expanded = false;
            }
            _editorWindow.mainPanel.libPanel.favoritesPanel.updatePackages();
            _editorWindow.mainPanel.editPanel.refreshDocument();
            hide();
         }
      }
      
      private function addFolder(param1:TreeNode, param2:EPackageItem) : void
      {
         var _loc5_:EPackageItem = null;
         var _loc3_:TreeNode = null;
         var _loc4_:Vector.<EPackageItem> = param2.owner.getFolderContent(param2);
         var _loc7_:int = 0;
         var _loc6_:* = _loc4_;
         for each(_loc5_ in _loc4_)
         {
            _loc3_ = new TreeNode(_loc5_.type == "folder");
            _loc3_.data = _loc5_;
            param1.addChild(_loc3_);
            if(_loc5_.type == "folder")
            {
               this.addFolder(_loc3_,_loc5_);
            }
         }
      }
      
      public function treeNodeCreateCell(param1:TreeNode) : GComponent
      {
         return this._treeView.list.getFromPool(this._treeItemUrl).asCom;
      }
      
      public function treeNodeRender(param1:TreeNode, param2:GComponent) : void
      {
         var _loc4_:GButton = param2.asButton;
         var _loc5_:EPackageItem = param1.data as EPackageItem;
         _loc4_.title = _loc5_.name;
         var _loc3_:GLoader = param2.getChild("sign") as GLoader;
         if(param1.isFolder)
         {
            _loc4_.icon = Icons.all.folder;
            _loc3_.url = null;
         }
         else
         {
            _loc4_.icon = Icons.all[_loc5_.type];
            if(_loc5_.exported)
            {
               _loc3_.url = this._exportedSignUrl;
            }
            else
            {
               _loc3_.url = null;
            }
         }
      }
      
      public function treeNodeWillExpand(param1:TreeNode, param2:Boolean) : void
      {
      }
      
      public function treeNodeClick(param1:TreeNode, param2:ItemEvent) : void
      {
         if(param2.clickCount == 2)
         {
            param1.expanded = !param1.expanded;
         }
      }
      
      private function __browse(param1:Event) : void
      {
         ChooseFolderDialog(_editorWindow.getDialog(ChooseFolderDialog)).open(this._targetPkg,this._path,this.__selectFolder);
      }
      
      private function __selectFolder(param1:String) : void
      {
         this._path = param1;
         contentPane.getChild("targetLocation").text = "/" + this._targetPkg.name + this._path;
      }
   }
}

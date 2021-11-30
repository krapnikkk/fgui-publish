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
   import fairygui.editor.utils.zip.ZipArchive;
   import fairygui.editor.utils.zip.ZipFile;
   import fairygui.event.ItemEvent;
   import fairygui.tree.ITreeListener;
   import fairygui.tree.TreeNode;
   import fairygui.tree.TreeView;
   import flash.filesystem.File;
   
   public class ExportPackageDialog extends WindowBase implements ITreeListener
   {
       
      
      private var _treeView:TreeView;
      
      private var _treeItemUrl:String;
      
      private var _exportedSignUrl:String;
      
      private var _copyHandler:CopyHandler;
      
      public function ExportPackageDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ExportPackageDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._treeItemUrl = UIPackage.getItemURL("Basic","TreeItem");
         this._exportedSignUrl = UIPackage.getItemURL("Builder","bullet_red");
         this._treeView = new TreeView(contentPane.getChild("list").asList);
         this._treeView.listener = this;
         contentPane.getChild("ok").addClickListener(__actionHandler);
         contentPane.getChild("cancel").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         var _loc6_:* = null;
         var _loc10_:int = 0;
         var _loc13_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc1_:int = 0;
         var _loc3_:String = null;
         var _loc2_:TreeNode = null;
         var _loc4_:EPackageItem = null;
         var _loc8_:Vector.<EPackageItem> = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedItems(true);
         this._copyHandler = new CopyHandler();
         this._copyHandler.copy(_loc8_,null,"/");
         var _loc7_:Object = {};
         var _loc5_:TreeNode = new TreeNode(true);
         _loc5_.data = "Assets";
         _loc7_["/"] = _loc5_;
         var _loc9_:Vector.<String> = this._copyHandler.targetPaths;
         var _loc15_:int = 0;
         var _loc14_:* = _loc9_;
         for each(_loc13_ in _loc9_)
         {
            if(!_loc7_[_loc13_])
            {
               _loc6_ = _loc5_;
               _loc12_ = _loc13_.length;
               _loc1_ = 1;
               _loc10_ = 1;
               while(_loc10_ < _loc12_)
               {
                  if(_loc13_.charAt(_loc10_) == "/")
                  {
                     _loc3_ = _loc13_.substring(0,_loc10_ + 1);
                     _loc2_ = _loc7_[_loc3_];
                     if(!_loc2_)
                     {
                        _loc2_ = new TreeNode(true);
                        _loc2_.data = _loc3_.substring(_loc1_,_loc10_);
                        _loc7_[_loc3_] = _loc2_;
                        _loc6_.addChild(_loc2_);
                     }
                     _loc6_ = _loc2_;
                     _loc1_ = _loc10_ + 1;
                  }
                  _loc10_++;
               }
               continue;
            }
         }
         _loc8_ = this._copyHandler.sourceItems;
         _loc11_ = _loc8_.length;
         _loc10_ = 0;
         while(_loc10_ < _loc11_)
         {
            _loc4_ = _loc8_[_loc10_];
            if(_loc4_.type != "folder")
            {
               _loc6_ = _loc7_[_loc9_[_loc10_]];
               _loc2_ = new TreeNode(false);
               _loc2_.data = _loc4_;
               _loc6_.addChild(_loc2_);
            }
            _loc10_++;
         }
         this._treeView.root.removeChildren();
         this._treeView.root.addChild(_loc5_);
         this._treeView.expandAll(this._treeView.root);
      }
      
      override public function actionHandler() : void
      {
         UtilsFile.browseForSave("FairyGUI package",function(param1:File):void
         {
            if(!param1.exists && (!param1.extension || param1.extension.toLowerCase() != "fairypackage"))
            {
               doExport(new File(param1.nativePath + ".fairypackage"));
            }
            else
            {
               doExport(param1);
            }
         });
      }
      
      private function doExport(param1:File) : void
      {
         var _loc4_:EUIProject = null;
         var _loc5_:EUIPackage = null;
         var _loc3_:ZipArchive = null;
         var _loc2_:File = null;
         var _loc6_:* = param1;
         var _loc7_:File = File.createTempDirectory();
         var _loc8_:* = 0;
         EUIProject.createNew(_loc7_.nativePath,"tempProject",_editorWindow.project.type);
         _loc4_ = new EUIProject(null);
         _loc4_.open(_loc7_.resolvePath("tempProject.fairy"));
         _loc5_ = _loc4_.createPackage("Dummy");
         _editorWindow.cursorManager.setWaitCursor(true);
         this._copyHandler.paste(_loc5_,1);
         _editorWindow.cursorManager.setWaitCursor(false);
         _loc3_ = new ZipArchive(null,"GBK");
         _loc2_ = new File(_loc5_.basePath);
         this.addToZip(_loc3_,_loc2_,"");
         UtilsFile.saveBytes(_loc6_,_loc3_.output());
         _loc4_.close();
         this.hide();
         _loc8_ = 1;
         _loc7_.deleteDirectory(true);
         switch(int(_loc8_))
         {
            case 0:
               return;
            case 1:
               return;
            case 2:
               return;
         }
      }
      
      private function addToZip(param1:ZipArchive, param2:File, param3:String) : void
      {
         var _loc4_:File = null;
         var _loc5_:ZipFile = null;
         var _loc6_:Array = param2.getDirectoryListing();
         var _loc8_:int = 0;
         var _loc7_:* = _loc6_;
         for each(_loc4_ in _loc6_)
         {
            if(_loc4_.isDirectory)
            {
               _loc5_ = new ZipFile(param3 + _loc4_.name + "/");
               param1.addFile(_loc5_);
               this.addToZip(param1,_loc4_,_loc5_.name);
            }
            else
            {
               param1.addFileFromBytes(param3 + _loc4_.name,UtilsFile.loadBytes(_loc4_));
            }
         }
      }
      
      public function treeNodeCreateCell(param1:TreeNode) : GComponent
      {
         return this._treeView.list.getFromPool(this._treeItemUrl).asCom;
      }
      
      public function treeNodeRender(param1:TreeNode, param2:GComponent) : void
      {
         var _loc3_:EPackageItem = null;
         var _loc4_:GButton = param2.asButton;
         var _loc5_:GLoader = param2.getChild("sign") as GLoader;
         if(param1.isFolder)
         {
            _loc4_.title = String(param1.data);
            _loc4_.icon = Icons.all.folder;
            _loc5_.url = null;
         }
         else
         {
            _loc3_ = param1.data as EPackageItem;
            _loc4_.title = _loc3_.name;
            _loc4_.icon = Icons.all[_loc3_.type];
            if(_loc3_.exported)
            {
               _loc5_.url = this._exportedSignUrl;
            }
            else
            {
               _loc5_.url = null;
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
   }
}

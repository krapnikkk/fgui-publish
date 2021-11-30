package fairygui.editor.handlers
{
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.FileListEvent;
   import flash.filesystem.File;
   
   public class PackageRefreshHandler
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _allFiles:Vector.<File>;
      
      private var _newAddedFiles:Array;
      
      private var _newAddedFilePaths:Array;
      
      private var _listingTasks:BulkTasks;
      
      public function PackageRefreshHandler(param1:EUIPackage)
      {
         super();
         this._pkg = param1;
         this._allFiles = new Vector.<File>();
         this._newAddedFiles = [];
         this._newAddedFilePaths = [];
         this._listingTasks = new BulkTasks();
      }
      
      public function run() : void
      {
         this._allFiles.length = 0;
         this._newAddedFiles.length = 0;
         this._newAddedFilePaths.length = 0;
         this._listingTasks.clear();
         this._pkg.ensureOpen();
         var _loc1_:File = new File(this._pkg.basePath + "/package.xml");
         if(!_loc1_.exists || this._pkg.descModification != _loc1_.modificationDate.time || this._pkg.descFileSize != _loc1_.size)
         {
            this._pkg.open();
            this._pkg.project.editorWindow.mainPanel.libPanel.pkgsPanel.notifyChanged(this._pkg.rootItem.treeNode);
         }
         this._listingTasks.addTask(this.runListingTask,new File(this._pkg.basePath));
         this._listingTasks.start(this.checkAllFiles);
      }
      
      private function checkAllFiles() : void
      {
         var pi:EPackageItem = null;
         var oldStatus:int = 0;
         var toDeleteFolder:Vector.<EPackageItem> = null;
         var file:File = null;
         var path:String = null;
         var callback:Callback = null;
         var cnt:int = this._allFiles.length;
         var baseLen:int = this._pkg.basePath.length;
         var i:int = 0;
         while(i < cnt)
         {
            file = this._allFiles[i];
            path = UtilsStr.getFilePath(file.nativePath.substr(baseLen)).replace(/\\/g,"/") + "/";
            pi = this._pkg.getItem(path);
            if(!pi)
            {
               pi = this._pkg.ensurePathExists(path,false,false);
            }
            if(!file.isDirectory)
            {
               pi = this._pkg.getItemByFileName(pi,file.name);
               if(!pi)
               {
                  this._newAddedFiles.push(file);
                  this._newAddedFilePaths.push(path);
               }
            }
            i = Number(i) + 1;
         }
         var itemList:Vector.<EPackageItem> = this._pkg.resources;
         cnt = itemList.length;
         i = 0;
         toDeleteFolder = new Vector.<EPackageItem>();
         while(i < cnt)
         {
            i = Number(i) + 1;
            pi = itemList[Number(i)];
            file = pi.file;
            oldStatus = pi.errorStatus;
            if(!file.exists)
            {
               if(pi.type == "folder")
               {
                  toDeleteFolder.push(pi);
               }
               else if(!this.findInNewAdded(pi))
               {
                  pi.touch();
               }
            }
            else
            {
               pi.touch();
            }
            if(pi.nodeStatus != pi.errorStatus && pi.treeNode != null)
            {
               pi.nodeStatus = pi.errorStatus;
               this._pkg.project.editorWindow.mainPanel.libPanel.updateItem(pi);
            }
         }
         if(this._pkg.needSave)
         {
            this._pkg.save(true);
         }
         var func:Function = function():void
         {
            var _loc2_:int = 0;
            var _loc1_:* = toDeleteFolder;
            for each(pi in toDeleteFolder)
            {
               if(pi.children.length == 0)
               {
                  _pkg.deleteItem(pi,false);
               }
            }
            _allFiles.length = 0;
            _newAddedFiles.length = 0;
            _newAddedFilePaths.length = 0;
            _pkg.project.refreshRunnning = false;
            _pkg.project.editorWindow.mainPanel.editPanel.refreshDocument();
         };
         if(this._newAddedFiles.length > 0)
         {
            callback = new Callback();
            var _loc2_:* = func;
            callback.failed = _loc2_;
            callback.success = _loc2_;
            this._pkg.project.editorWindow.mainPanel.importResources(this._newAddedFiles,this._pkg,this._newAddedFilePaths,null,callback);
         }
         else
         {
            func();
         }
      }
      
      private function findInNewAdded(param1:EPackageItem) : Boolean
      {
         var _loc3_:File = null;
         var _loc4_:int = this._newAddedFiles.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._newAddedFiles[_loc2_];
            if(_loc3_.name == param1.fileName)
            {
               this._pkg.moveItem(param1,this._newAddedFilePaths[_loc2_],false);
               this._newAddedFiles.splice(_loc2_,1);
               this._newAddedFilePaths.splice(_loc2_,1);
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function runListingTask() : void
      {
         var _loc1_:File = File(this._listingTasks.taskData);
         _loc1_.addEventListener("directoryListing",this.onPackageListing);
         _loc1_.getDirectoryListingAsync();
      }
      
      private function onPackageListing(param1:FileListEvent) : void
      {
         var _loc2_:File = null;
         this._listingTasks.finishItem();
         var _loc3_:Array = param1.files;
         var _loc5_:int = 0;
         var _loc4_:* = _loc3_;
         for each(_loc2_ in _loc3_)
         {
            if(!(_loc2_.isHidden || _loc2_.isSymbolicLink || _loc2_.name == "package.xml" || _loc2_.extension == "meta" || _loc2_.name.charAt(0) == "."))
            {
               this._allFiles.push(_loc2_);
               if(_loc2_.isDirectory)
               {
                  this._listingTasks.addTask(this.runListingTask,_loc2_);
               }
            }
         }
      }
   }
}

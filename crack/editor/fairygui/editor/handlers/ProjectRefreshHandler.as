package fairygui.editor.handlers
{
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.utils.Logger;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.FileListEvent;
   import flash.filesystem.File;
   
   public class ProjectRefreshHandler
   {
       
      
      private var _project:EUIProject;
      
      public function ProjectRefreshHandler(param1:EUIProject)
      {
         super();
         this._project = param1;
      }
      
      public function run() : void
      {
         if(this._project.refreshRunnning)
         {
            return;
         }
         this._project.refreshRunnning = true;
         var _loc1_:File = new File(this._project.assetsPath);
         _loc1_.addEventListener("directoryListing",this.onProjectListing);
         _loc1_.getDirectoryListingAsync();
      }
      
      private function onProjectListing(param1:FileListEvent) : void
      {
         var _loc6_:EUIPackage = null;
         var _loc2_:String = null;
         var _loc8_:Boolean = false;
         var _loc4_:File = null;
         var _loc7_:Vector.<EUIPackage> = null;
         var _loc5_:* = param1;
         var _loc3_:Array = _loc5_.files;
         var _loc12_:int = 0;
         var _loc11_:* = _loc3_;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.isDirectory)
            {
               _loc6_ = this._project.getPackageByName(_loc4_.name);
               if(!_loc6_)
               {
                  _loc2_ = this.getPackageId(_loc4_);
                  if(_loc2_)
                  {
                     _loc6_ = this._project.getPackage(_loc2_);
                     if(_loc6_)
                     {
                        if(!new File(_loc6_.basePath).exists)
                        {
                           try
                           {
                              _loc6_.renameItem(_loc6_.rootItem,_loc4_.name);
                           }
                           catch(err:Error)
                           {
                              Logger.print("refresh error " + err.getStackTrace());
                           }
                        }
                        else
                        {
                           continue;
                        }
                     }
                     else
                     {
                        this._project.addPackage(_loc4_);
                     }
                     _loc8_ = true;
                  }
               }
            }
         }
         _loc7_ = this._project.getPackageList();
         var _loc14_:int = 0;
         var _loc13_:* = _loc7_;
         for each(_loc6_ in _loc7_)
         {
            if(!new File(_loc6_.basePath).exists)
            {
               this._project.deletePackage(_loc6_.id);
               _loc8_ = true;
            }
         }
         if(_loc8_)
         {
            this._project.editorWindow.mainPanel.libPanel.updatePackages();
         }
         _loc6_ = this._project.editorWindow.mainPanel.getActivePackage();
         if(_loc6_)
         {
            _loc6_.refresh();
         }
         else
         {
            this._project.refreshRunnning = false;
         }
      }
      
      private function getPackageId(param1:File) : String
      {
         var _loc3_:File = param1.resolvePath("package.xml");
         if(!_loc3_.exists)
         {
            return null;
         }
         var _loc2_:String = UtilsFile.loadString(_loc3_,null,200);
         return UtilsStr.getBetweenSymbol(_loc2_,"id=\"","\"");
      }
   }
}

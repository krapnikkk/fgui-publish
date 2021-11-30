package fairygui.editor.plugin
{
   import §_-Gs§.§_-Eg§;
   import fairygui.GRoot;
   import fairygui.PopupMenu;
   import fairygui.editor.Consts;
   import fairygui.editor.api.IEditor;
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.settings.§_-D§;
   
   public class LegacyPlugInProxy implements IFairyGUIEditor, IMenuBar
   {
       
      
      private var _editor:IEditor;
      
      private var _project:PlugIn_UIProject;
      
      private var _publishHandlers:Vector.<IPublishHandler>;
      
      private var _dummyMenu:PopupMenu;
      
      private var _prompted:Boolean = false;
      
      public function LegacyPlugInProxy(param1:IEditor)
      {
         super();
         this._editor = param1;
         this._project = new PlugIn_UIProject(this._editor.project);
         this._publishHandlers = new Vector.<IPublishHandler>();
         this._editor.project.setVar("PublishPlugins",this._publishHandlers);
      }
      
      public function dispose() : void
      {
         this._publishHandlers.length = 0;
         this._editor.project.clearCustomExtensions();
         if(this._dummyMenu)
         {
            this._dummyMenu.dispose();
         }
      }
      
      public function get v5() : IEditor
      {
         if(§_-D§.§_-8J§)
         {
            return this._editor;
         }
         if(!this._prompted)
         {
            this._prompted = true;
            this._editor.consoleView.logWarning("interface editorV5 is only available for pro version");
         }
         return null;
      }
      
      public function get menuBar() : IMenuBar
      {
         return this;
      }
      
      public function addMenu(param1:String, param2:String, param3:PopupMenu, param4:String = null) : void
      {
         if(Consts.isMacOS)
         {
            this._editor.consoleView.logWarning("addMenu not supported in mac os");
            return;
         }
         this._editor.menu.addItem(param2,param1,null,null,-1,new §_-Eg§(param3));
      }
      
      public function getMenu(param1:String) : PopupMenu
      {
         if(Consts.isMacOS)
         {
            this._editor.consoleView.logWarning("PlugIn error: getMenu not supported in mac os");
            if(!this._dummyMenu)
            {
               this._dummyMenu = new PopupMenu();
            }
            return this._dummyMenu;
         }
         return §_-Eg§(this._editor.menu.getSubMenu(param1)).menu;
      }
      
      public function removeMenu(param1:String) : void
      {
         this._editor.menu.removeItem(param1);
      }
      
      public function getPackage(param1:String) : IEditorUIPackage
      {
         var _loc2_:IUIPackage = this._editor.project.getPackageByName(param1);
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:IEditorUIPackage = _loc2_.getVar("pluginInst");
         if(!_loc3_)
         {
            _loc3_ = new PlugIn_UIPackage(_loc2_);
            _loc2_.setVar("pluginInst",_loc3_);
         }
         return _loc3_;
      }
      
      public function alert(param1:String) : void
      {
         this._editor.alert(param1);
      }
      
      public function log(param1:String) : void
      {
         this._editor.consoleView.log(param1);
      }
      
      public function logError(param1:String, param2:Error = null) : void
      {
         this._editor.consoleView.logError(param1,param2);
      }
      
      public function logWarning(param1:String) : void
      {
         this._editor.consoleView.logWarning(param1);
      }
      
      public function get project() : IEditorUIProject
      {
         return this._project;
      }
      
      public function get groot() : GRoot
      {
         return this._editor.groot;
      }
      
      public function get language() : String
      {
         return Consts.language;
      }
      
      public function registerComponentExtension(param1:String, param2:String, param3:String) : void
      {
         this._editor.project.registerCustomExtension(param1,param2,param3);
      }
      
      public function registerPublishHandler(param1:IPublishHandler) : void
      {
         if(this._publishHandlers.indexOf(param1) == -1)
         {
            this._publishHandlers.push(param1);
         }
      }
   }
}

import fairygui.editor.api.IUIProject;
import fairygui.editor.plugin.IEditorUIProject;
import fairygui.editor.settings.CustomProps;

class PlugIn_UIProject implements IEditorUIProject
{
    
   
   private var _project:IUIProject;
   
   function PlugIn_UIProject(param1:IUIProject)
   {
      super();
      this._project = param1;
   }
   
   public function get basePath() : String
   {
      return this._project.basePath;
   }
   
   public function get id() : String
   {
      return this._project.id;
   }
   
   public function get name() : String
   {
      return this._project.name;
   }
   
   public function get type() : String
   {
      return this._project.type;
   }
   
   public function get customProperties() : Object
   {
      return CustomProps(this._project.getSettings("customProps")).all;
   }
   
   public function getSettings(param1:String) : Object
   {
      return this._project.getSettings(param1);
   }
   
   public function save() : void
   {
   }
}

import fairygui.editor.api.IResourceImportQueue;
import fairygui.editor.api.IUIPackage;
import fairygui.editor.gui.FPackageItem;
import fairygui.editor.gui.animation.AniDef;
import fairygui.editor.gui.animation.AniImporter;
import fairygui.editor.plugin.IEditorUIPackage;
import fairygui.utils.Callback;
import fairygui.utils.UtilsFile;
import flash.filesystem.File;

class PlugIn_UIPackage implements IEditorUIPackage
{
    
   
   private var _pkg:IUIPackage;
   
   function PlugIn_UIPackage(param1:IUIPackage)
   {
      super();
      this._pkg = param1;
   }
   
   public function setExported(param1:Array, param2:Boolean) : void
   {
      var id:String = null;
      var pi:FPackageItem = null;
      var ids:Array = param1;
      var exported:Boolean = param2;
      this._pkg.beginBatch();
      try
      {
         for each(id in ids)
         {
            pi = this._pkg.getItem(id);
            if(pi)
            {
               this._pkg.setItemProperty(pi,"exported",exported);
            }
         }
      }
      finally
      {
         this._pkg.endBatch();
      }
      this._pkg.endBatch();
   }
   
   public function get basePath() : String
   {
      return this._pkg.basePath;
   }
   
   public function getResourceId(param1:String) : String
   {
      var _loc2_:FPackageItem = this._pkg.findItemByName(param1);
      if(_loc2_)
      {
         return _loc2_.id;
      }
      return null;
   }
   
   public function importResources(param1:String, param2:Array, param3:Array, param4:Function) : void
   {
      var _loc5_:IResourceImportQueue = this._pkg.project.editor.importResource(this._pkg);
      var _loc6_:int = param2.length;
      var _loc7_:int = 0;
      while(_loc7_ < _loc6_)
      {
         _loc5_.add(param2[_loc7_],param1,!!param3?param3[_loc7_]:null);
         _loc7_++;
      }
      _loc5_.process(param4);
   }
   
   public function get name() : String
   {
      return this._pkg.name;
   }
   
   public function createMovieClip(param1:String, param2:String, param3:Array, param4:Object, param5:Function, param6:Function) : void
   {
      var pi:FPackageItem = null;
      var cb:Callback = null;
      var name:String = param1;
      var path:String = param2;
      var files:Array = param3;
      var options:Object = param4;
      var onSuccess:Function = param5;
      var onFail:Function = param6;
      pi = this._pkg.createMovieClipItem(name,path,true);
      cb = new Callback();
      cb.success = function():void
      {
         var _loc2_:int = 0;
         var _loc1_:AniDef = AniDef(cb.result);
         if(options)
         {
            if(options.speed != undefined)
            {
               _loc1_.speed = options.speed;
            }
            if(options.swing != undefined)
            {
               _loc1_.swing = options.swing;
            }
            if(options.repeatDelay != undefined)
            {
               _loc1_.repeatDelay = options.repeatDelay;
            }
            if(options.frameDelays != undefined)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.frameList.length)
               {
                  if(options.frameDelays[_loc2_] != undefined)
                  {
                     _loc1_.frameList[_loc2_].delay = options.frameDelays[_loc2_];
                  }
                  _loc2_++;
               }
            }
         }
         UtilsFile.saveBytes(pi.file,_loc1_.save());
         pi.setChanged();
         pi.owner.setChanged();
      };
      cb.failed = onFail;
      AniImporter.importImages(files,false,cb);
   }
   
   public function get id() : String
   {
      return this._pkg.id;
   }
   
   public function createFolder(param1:String, param2:String) : void
   {
      this._pkg.createFolder(param2,param1);
   }
   
   public function createComponent(param1:String, param2:int, param3:int, param4:String, param5:XML) : String
   {
      var _loc6_:FPackageItem = this._pkg.createComponentItem(param1,param2,param3,param4,null,false,true);
      if(param5 != null)
      {
         UtilsFile.saveXML(_loc6_.file,param5);
         _loc6_.setChanged();
      }
      return _loc6_.id;
   }
   
   public function renameResources(param1:Array, param2:Array) : void
   {
      var cnt:int = 0;
      var i:int = 0;
      var pi:FPackageItem = null;
      var ids:Array = param1;
      var names:Array = param2;
      this._pkg.beginBatch();
      try
      {
         cnt = ids[i];
         i = 0;
         while(i < cnt)
         {
            pi = this._pkg.getItem(ids[i]);
            if(pi)
            {
               this._pkg.renameItem(pi,names[i]);
            }
            i++;
         }
         return;
      }
      finally
      {
         this._pkg.endBatch();
      }
   }
   
   public function updateResource(param1:String, param2:File, param3:Function, param4:Function) : void
   {
      var _loc5_:FPackageItem = this._pkg.getItem(param1);
      if(!_loc5_)
      {
         throw new Error("Resource not found - " + param1);
      }
      var _loc6_:Callback = new Callback();
      _loc6_.success = param3;
      _loc6_.failed = param4;
      this._pkg.updateResource(_loc5_,param2,_loc6_);
   }
}

package fairygui.editor.settings
{
   import §_-NY§.§_-3O§;
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.api.IUIProject;
   import flash.filesystem.File;
   
   public class I18nSettings extends SettingsBase
   {
       
      
      private var _langFiles:Array;
      
      private var _langFileName:String;
      
      private var _langFile:File;
      
      private var _lastModified:Number;
      
      private var _strings:Object;
      
      public function I18nSettings(param1:IUIProject)
      {
         super(param1);
         _fileName = "i18n";
      }
      
      public function get langFiles() : Array
      {
         return this._langFiles;
      }
      
      public function set langFiles(param1:Array) : void
      {
         this._langFiles = param1;
      }
      
      public function get langFileName() : String
      {
         return this._langFileName;
      }
      
      public function set langFileName(param1:String) : void
      {
         this._langFileName = param1;
         if(this._langFileName)
         {
            this._langFile = new File(_project.basePath).resolvePath(this._langFileName);
         }
         else
         {
            this._langFile = null;
         }
      }
      
      public function get langFile() : File
      {
         return this._langFile;
      }
      
      public function loadStrings() : void
      {
         var _loc1_:Vector.<IUIPackage> = null;
         var _loc2_:IUIPackage = null;
         if(this.loadStrings2())
         {
            _loc1_ = _project.allPackages;
            for each(_loc2_ in _loc1_)
            {
               if(this._strings)
               {
                  _loc2_.strings = this._strings[_loc2_.id];
               }
               else
               {
                  _loc2_.strings = null;
               }
            }
         }
      }
      
      private function loadStrings2() : Boolean
      {
         var m:Object = null;
         var handler:§_-3O§ = null;
         var found:Boolean = false;
         for each(m in this._langFiles)
         {
            if(m.path == this._langFileName)
            {
               found = true;
               break;
            }
         }
         if(found && this._langFile)
         {
            if(this._langFile.exists && !this._langFile.isDirectory)
            {
               if(this._strings && this._lastModified == this._langFile.modificationDate.time)
               {
                  return false;
               }
               handler = new §_-3O§(_project.editor);
               try
               {
                  handler.parse(this._langFile);
                  this._strings = handler.strings;
                  this._lastModified = this._langFile.modificationDate.time;
               }
               catch(err:Error)
               {
                  _project.logError("load language file",err);
               }
               return true;
            }
         }
         if(this._strings)
         {
            this._strings = null;
            return true;
         }
         return false;
      }
      
      override protected function read(param1:Object) : void
      {
         this._langFiles = param1.langFiles as Array;
         if(!this._langFiles)
         {
            this._langFiles = [];
         }
      }
      
      override protected function write() : Object
      {
         return {"langFiles":this._langFiles};
      }
      
      public function fillCombo(param1:GComboBox) : void
      {
         var _loc7_:Object = null;
         var _loc2_:Array = param1.items;
         var _loc3_:Array = param1.values;
         var _loc4_:int = this._langFiles.length;
         _loc2_.length = _loc4_ + 1;
         _loc3_.length = _loc4_ + 1;
         _loc2_[0] = Consts.strings.text331;
         _loc3_[0] = "";
         var _loc5_:String = "";
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = this._langFiles[_loc6_];
            _loc2_[_loc6_ + 1] = _loc7_.name;
            _loc3_[_loc6_ + 1] = _loc7_.path;
            if(_loc7_.path == this._langFileName)
            {
               _loc5_ = _loc7_.path;
            }
            _loc6_++;
         }
         param1.items = _loc2_;
         param1.values = _loc3_;
         param1.value = _loc5_;
         this._langFileName = _loc5_;
      }
   }
}

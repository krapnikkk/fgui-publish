package fairygui.editor.settings
{
   import fairygui.editor.api.IUIProject;
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class SettingsBase
   {
       
      
      protected var _project:IUIProject;
      
      protected var _fileName:String;
      
      private var _file:File;
      
      private var _lastModified:Number;
      
      public function SettingsBase(param1:IUIProject)
      {
         super();
         this._project = param1;
         this._lastModified = 0;
      }
      
      public function touch(param1:Boolean = false) : void
      {
         if(!this._file)
         {
            this._file = new File(this._project.settingsPath + "/" + this._fileName + ".json");
            if(this._file.exists)
            {
               this.read(this.loadFile());
            }
            else
            {
               this.read({});
            }
         }
         else if(this._file.exists)
         {
            if(param1 || this._file.modificationDate.time != this._lastModified)
            {
               this.read(this.loadFile());
            }
         }
      }
      
      public function save() : void
      {
         this.saveFile(this.write());
      }
      
      protected function read(param1:Object) : void
      {
      }
      
      protected function write() : Object
      {
         return null;
      }
      
      protected function saveFile(param1:Object) : void
      {
         UtilsFile.saveJSON(this._file,param1,true);
         this._lastModified = this._file.modificationDate.time;
      }
      
      protected function loadFile() : Object
      {
         var data:Object = null;
         try
         {
            data = UtilsFile.loadJSON(this._file);
            this._lastModified = this._file.modificationDate.time;
         }
         catch(err:Error)
         {
            _project.logError(_fileName + ".json is corrupted!",err);
         }
         if(!data)
         {
            data = {};
         }
         return data;
      }
   }
}

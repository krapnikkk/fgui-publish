package fairygui.editor.settings
{
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class ISerializedSettings
   {
       
      
      protected var _project:EUIProject;
      
      protected var _fileName:String;
      
      public function ISerializedSettings()
      {
         super();
      }
      
      public function load() : void
      {
      }
      
      public function save() : void
      {
      }
      
      public function get project() : EUIProject
      {
         return this._project;
      }
      
      public function set project(param1:EUIProject) : void
      {
         this._project = param1;
      }
      
      protected function saveFile(param1:Object) : void
      {
         UtilsFile.saveJSON(new File(this._project.settingsPath + "/" + this._fileName + ".json"),param1,true);
      }
      
      protected function loadFile() : Object
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = UtilsFile.loadJSON(new File(this._project.settingsPath + "/" + this._fileName + ".json"));
            if(!_loc1_)
            {
               _loc1_ = {};
            }
         }
         catch(err:Error)
         {
            throw new Error(_fileName + ".json is corrupted!");
         }
         return _loc1_;
      }
   }
}

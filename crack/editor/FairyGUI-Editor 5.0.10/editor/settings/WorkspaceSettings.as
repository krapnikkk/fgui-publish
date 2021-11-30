package fairygui.editor.settings
{
   import fairygui.editor.api.IEditor;
   import fairygui.editor.api.IWorkspaceSettings;
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class WorkspaceSettings implements IWorkspaceSettings
   {
       
      
      private var _editor:IEditor;
      
      private var _data:Object;
      
      public function WorkspaceSettings(param1:IEditor)
      {
         super();
         this._editor = param1;
      }
      
      public function get(param1:String) : *
      {
         return this._data[param1];
      }
      
      public function set(param1:String, param2:*) : void
      {
         if(param2 == undefined)
         {
            delete this._data[param1];
         }
         else
         {
            this._data[param1] = param2;
         }
      }
      
      public function load() : void
      {
         this._data = UtilsFile.loadJSON(new File(this._editor.project.objsPath + "/workspace.json"));
         if(!this._data)
         {
            this._data = {};
         }
         delete this._data.docs;
         delete this._data.active_doc;
         if(this._data.backgroundColor == undefined)
         {
            this._data.backgroundColor = 6710886;
         }
         if(this._data.canvasColor == undefined)
         {
            this._data.canvasColor = 10066329;
         }
         if(this._data.auxline1 == undefined)
         {
            this._data.auxline1 = true;
         }
         if(this._data.auxline2 == undefined)
         {
            this._data.auxline2 = true;
         }
      }
      
      public function save() : void
      {
         UtilsFile.saveJSON(new File(this._editor.project.objsPath + "/workspace.json"),this._data);
      }
   }
}

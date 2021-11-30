package fairygui.editor.settings
{
   import fairygui.editor.api.IUIProject;
   
   public class PackageGroupSettings extends SettingsBase
   {
       
      
      private var _groups:Array;
      
      public function PackageGroupSettings(param1:IUIProject)
      {
         super(param1);
         _fileName = "PackageGroup";
      }
      
      public function get groups() : Array
      {
         return this._groups;
      }
      
      override protected function read(param1:Object) : void
      {
         if(param1 is Array)
         {
            this._groups = param1 as Array;
         }
         else
         {
            this._groups = [];
         }
      }
      
      override protected function write() : Object
      {
         return this._groups;
      }
   }
}

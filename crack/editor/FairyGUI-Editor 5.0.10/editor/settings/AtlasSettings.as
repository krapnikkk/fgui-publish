package fairygui.editor.settings
{
   import fairygui.utils.pack.PackSettings;
   
   public class AtlasSettings
   {
       
      
      private var _name:String;
      
      private var _compression:Boolean;
      
      private var _extractAlpha:Boolean;
      
      private var _packSettings:PackSettings;
      
      public function AtlasSettings()
      {
         super();
         this._packSettings = new PackSettings();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get compression() : Boolean
      {
         return this._compression;
      }
      
      public function set compression(param1:Boolean) : void
      {
         this._compression = param1;
      }
      
      public function get extractAlpha() : Boolean
      {
         return this._extractAlpha;
      }
      
      public function set extractAlpha(param1:Boolean) : void
      {
         this._extractAlpha = param1;
      }
      
      public function get packSettings() : PackSettings
      {
         return this._packSettings;
      }
      
      public function copyFrom(param1:AtlasSettings) : void
      {
         this._name = param1.name;
         this._compression = param1.compression;
         this._extractAlpha = param1.extractAlpha;
         this._packSettings.copyFrom(param1.packSettings);
      }
   }
}

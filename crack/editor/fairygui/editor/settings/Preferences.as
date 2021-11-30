package fairygui.editor.settings
{
   import fairygui.editor.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class Preferences
   {
      
      public static var cropResource:String;
      
      public static var language:String;
      
      public static var checkNewVersion:String;
       
      
      public function Preferences()
      {
         super();
      }
      
      public static function load() : void
      {
         var _loc2_:File = new File(new File(File.applicationDirectory.url).nativePath);
         var _loc1_:Object = UtilsFile.loadJSON(_loc2_.resolvePath("settings/default.json"));
         if(!_loc1_)
         {
            _loc1_ = {};
         }
         cropResource = _loc1_.cropResource;
         if(!cropResource)
         {
            cropResource = "no";
         }
         language = _loc1_.language;
         if(!language)
         {
            language = "auto";
         }
         checkNewVersion = _loc1_.checkNewVersion;
         if(!checkNewVersion)
         {
            checkNewVersion = "ask";
         }
      }
      
      public static function save() : void
      {
         var _loc4_:Object = {};
         _loc4_.cropResource = cropResource;
         _loc4_.language = language;
         _loc4_.checkNewVersion = checkNewVersion;
         var _loc3_:File = new File(new File(File.applicationDirectory.url).nativePath);
         var _loc1_:File = _loc3_.resolvePath("settings");
         if(!_loc1_.exists)
         {
            _loc1_.createDirectory();
         }
         var _loc2_:File = _loc1_.resolvePath("default.json");
         UtilsFile.saveJSON(_loc2_,_loc4_,true);
      }
   }
}

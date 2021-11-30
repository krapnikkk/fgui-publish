package fairygui.editor.settings
{
   import fairygui.editor.Consts;
   import fairygui.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class Preferences
   {
      
      public static var language:String;
      
      public static var checkNewVersion:String;
      
      public static var genComPreview:Boolean;
      
      public static var meaningfullChildName:Boolean;
      
      public static var hideInvisibleChild:Boolean;
      
      public static var customUBBEditor:Boolean;
      
      public static var publishAction:String;
      
      public static var saveBeforePublish:Boolean;
      
      public static var hotkeys:Object;
       
      
      public function Preferences()
      {
         super();
      }
      
      public static function load() : void
      {
         var _loc1_:Object = null;
         var _loc2_:File = File.userDirectory.resolvePath(Consts.userDirectoryName);
         if(_loc2_.exists)
         {
            _loc1_ = UtilsFile.loadJSON(_loc2_.resolvePath("preference.json"));
         }
         if(!_loc1_)
         {
            _loc1_ = {};
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
         if(_loc1_.genComPreview == undefined)
         {
            genComPreview = true;
         }
         else
         {
            genComPreview = _loc1_.genComPreview;
         }
         publishAction = _loc1_.publishAction;
         if(publishAction == null)
         {
            publishAction = "active";
         }
         saveBeforePublish = _loc1_.saveBeforePublish;
         hotkeys = _loc1_.hotkeys;
         if(!hotkeys)
         {
            hotkeys = {};
         }
      }
      
      public static function save() : void
      {
         var _loc1_:Object = {};
         _loc1_.language = language;
         _loc1_.checkNewVersion = checkNewVersion;
         _loc1_.hotkeys = hotkeys;
         _loc1_.genComPreview = genComPreview;
         _loc1_.publishAction = publishAction;
         _loc1_.saveBeforePublish = saveBeforePublish;
         var _loc2_:File = File.userDirectory.resolvePath(Consts.userDirectoryName);
         if(!_loc2_.exists)
         {
            _loc2_.createDirectory();
         }
         var _loc3_:File = _loc2_.resolvePath("preference.json");
         UtilsFile.saveJSON(_loc3_,_loc1_,true);
      }
   }
}

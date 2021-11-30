package fairygui.editor.gui
{
   import fairygui.utils.UtilsFile;
   import fairygui.utils.XData;
   import flash.filesystem.File;
   
   public class FPackageItemType
   {
      
      public static const FOLDER:String = "folder";
      
      public static const IMAGE:String = "image";
      
      public static const SWF:String = "swf";
      
      public static const MOVIECLIP:String = "movieclip";
      
      public static const SOUND:String = "sound";
      
      public static const COMPONENT:String = "component";
      
      public static const FONT:String = "font";
      
      public static const MISC:String = "misc";
      
      public static const ATLAS:String = "atlas";
      
      public static const fileExtensionMap:Object = {
         "jpg":IMAGE,
         "jpeg":IMAGE,
         "png":IMAGE,
         "psd":IMAGE,
         "tga":IMAGE,
         "svg":IMAGE,
         "plist":MOVIECLIP,
         "eas":MOVIECLIP,
         "jta":MOVIECLIP,
         "gif":MOVIECLIP,
         "wav":SOUND,
         "mp3":SOUND,
         "ogg":SOUND,
         "fnt":FONT,
         "swf":SWF,
         "xml":COMPONENT
      };
       
      
      public function FPackageItemType()
      {
         super();
      }
      
      public static function getFileType(param1:File) : String
      {
         var _loc3_:String = null;
         var _loc4_:XData = null;
         if(param1.isHidden || param1.isSymbolicLink || param1.name == "package.xml" || param1.name == "package_branch.xml" || param1.extension == "meta" || param1.name.charAt(0) == ".")
         {
            return null;
         }
         var _loc2_:String = param1.extension;
         if(_loc2_)
         {
            _loc2_ = _loc2_.toLowerCase();
         }
         if(_loc2_ == "xml")
         {
            _loc4_ = UtilsFile.loadXMLRoot(param1);
            if(_loc4_)
            {
               if(_loc4_.getName() == "component")
               {
                  _loc3_ = FPackageItemType.COMPONENT;
               }
               else
               {
                  _loc3_ = FPackageItemType.MISC;
               }
            }
            else
            {
               _loc3_ = FPackageItemType.MISC;
            }
         }
         else
         {
            _loc3_ = FPackageItemType.fileExtensionMap[_loc2_];
            if(!_loc3_)
            {
               _loc3_ = FPackageItemType.MISC;
            }
         }
         return _loc3_;
      }
   }
}

package fairygui.editor.extui
{
   import fairygui.UIPackage;
   import flash.utils.Dictionary;
   
   public class Icons
   {
      
      private static var _icons:Dictionary;
       
      
      public function Icons()
      {
         super();
      }
      
      public static function get all() : Object
      {
         if(!_icons)
         {
            init();
         }
         return _icons;
      }
      
      public static function init() : void
      {
         _icons = new Dictionary();
         _icons["folder"] = UIPackage.getItemURL("Builder","icon_folder");
         _icons["package"] = UIPackage.getItemURL("Builder","icon_package");
         _icons["image"] = UIPackage.getItemURL("Builder","icon_image");
         _icons["video"] = UIPackage.getItemURL("Builder","icon_movieclip");
         _icons["graph"] = UIPackage.getItemURL("Builder","icon_graph");
         _icons["list"] = UIPackage.getItemURL("Builder","icon_list");
         _icons["loader"] = UIPackage.getItemURL("Builder","icon_loader");
         _icons["text"] = UIPackage.getItemURL("Builder","icon_text");
         _icons["richtext"] = UIPackage.getItemURL("Builder","icon_richtext");
         _icons["component"] = UIPackage.getItemURL("Builder","icon_component");
         _icons["swf"] = UIPackage.getItemURL("Builder","icon_swf");
         _icons["movieclip"] = UIPackage.getItemURL("Builder","icon_movieclip");
         _icons["dragonbone"] = UIPackage.getItemURL("Builder","icon_group");
         _icons["sound"] = UIPackage.getItemURL("Builder","icon_sound");
         _icons["font"] = UIPackage.getItemURL("Builder","icon_font");
         _icons["group"] = UIPackage.getItemURL("Builder","icon_group");
      }
   }
}

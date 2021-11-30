package fairygui.display
{
   import fairygui.GObject;
   import flash.display.Bitmap;
   
   public class UIImage extends Bitmap implements UIDisplayObject
   {
       
      
      private var _owner:GObject;
      
      public function UIImage(param1:GObject)
      {
         super();
         _owner = param1;
      }
      
      public function get owner() : GObject
      {
         return _owner;
      }
   }
}

package fairygui.display
{
   import fairygui.GObject;
   
   public class UIMovieClip extends MovieClip implements UIDisplayObject
   {
       
      
      private var _owner:GObject;
      
      public function UIMovieClip(param1:GObject)
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

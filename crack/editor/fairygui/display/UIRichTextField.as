package fairygui.display
{
   import fairygui.GObject;
   import fairygui.text.RichTextField;
   
   public class UIRichTextField extends RichTextField implements UIDisplayObject
   {
       
      
      private var _owner:GObject;
      
      public function UIRichTextField(param1:GObject)
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

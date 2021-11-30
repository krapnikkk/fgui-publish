package fairygui.display
{
   import fairygui.GObject;
   import flash.text.TextField;
   
   public class UITextField extends TextField implements UIDisplayObject
   {
       
      
      private var _owner:GObject;
      
      public function UITextField(param1:GObject)
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

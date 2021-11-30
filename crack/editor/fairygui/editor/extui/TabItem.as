package fairygui.editor.extui
{
   import fairygui.GButton;
   
   public class TabItem
   {
       
      
      public var id:String;
      
      public var title:String;
      
      public var modified:Boolean;
      
      public var button:GButton;
      
      public var data:Object;
      
      var width:int;
      
      var visitTime:int;
      
      public function TabItem()
      {
         super();
      }
   }
}

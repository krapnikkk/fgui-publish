package fairygui
{
   public interface IUISource
   {
       
      
      function get fileName() : String;
      
      function set fileName(param1:String) : void;
      
      function get loaded() : Boolean;
      
      function load(param1:Function) : void;
   }
}

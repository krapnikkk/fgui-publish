package fairygui.editor.api
{
   public interface IConsoleView
   {
       
      
      function log(param1:String, param2:Object = null) : void;
      
      function logError(param1:String, param2:Error = null, param3:Object = null) : void;
      
      function logWarning(param1:String, param2:Object = null) : void;
      
      function clear() : void;
   }
}

package fairygui.editor.plugin
{
   import fairygui.GRoot;
   
   public interface IFairyGUIEditor
   {
       
      
      function get project() : IEditorUIProject;
      
      function getPackage(param1:String) : IEditorUIPackage;
      
      function get language() : String;
      
      function get groot() : GRoot;
      
      function get menuBar() : IMenuBar;
      
      function alert(param1:String) : void;
      
      function registerPublishHandler(param1:IPublishHandler) : void;
      
      function registerComponentExtension(param1:String, param2:String, param3:String) : void;
      
      function registerEventExtension(param1:String, param2:String, param3:String = "") : void;
   }
}

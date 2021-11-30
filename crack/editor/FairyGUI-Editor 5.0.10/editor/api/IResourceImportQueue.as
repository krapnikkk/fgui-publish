package fairygui.editor.api
{
   import flash.filesystem.File;
   import flash.geom.Point;
   
   public interface IResourceImportQueue
   {
       
      
      function add(param1:File, param2:String = null, param3:String = null) : IResourceImportQueue;
      
      function addRelative(param1:File, param2:String = null, param3:File = null, param4:String = null) : IResourceImportQueue;
      
      function process(param1:Function = null, param2:Boolean = false, param3:Point = null) : void;
   }
}

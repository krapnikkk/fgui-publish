package fairygui.editor.gui
{
   import flash.filesystem.File;
   
   public class ImageInfo
   {
       
      
      public var targetQuality:int;
      
      public var format:String;
      
      public var file:File;
      
      public var loadingToMemory:Boolean;
      
      public function ImageInfo()
      {
         super();
      }
   }
}

package fairygui.editor.gui
{
   import flash.filesystem.File;
   import flash.geom.Rectangle;
   
   public class ImageInfo
   {
       
      
      public var targetQuality:int;
      
      public var format:String;
      
      public var file:File;
      
      public var trimmedRect:Rectangle;
      
      public function ImageInfo()
      {
         super();
         this.trimmedRect = new Rectangle();
      }
      
      public function get needConversion() : Boolean
      {
         return this.format == "psd" || this.format == "tga" || this.format == "svg" || this.targetQuality != 100;
      }
   }
}

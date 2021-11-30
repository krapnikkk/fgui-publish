package fairygui.editor.animation
{
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   public class AniTexture
   {
       
      
      public var bitmapData:BitmapData;
      
      private var _raw:ByteArray;
      
      public var exportFrame:int;
      
      public function AniTexture()
      {
         super();
      }
      
      public function set raw(param1:ByteArray) : void
      {
         this._raw = param1;
      }
      
      public function get raw() : ByteArray
      {
         return this._raw;
      }
   }
}

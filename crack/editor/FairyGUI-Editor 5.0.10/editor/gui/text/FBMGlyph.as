package fairygui.editor.gui.text
{
   import fairygui.editor.gui.ResourceRef;
   import flash.display.BitmapData;
   
   public class FBMGlyph
   {
       
      
      public var x:int;
      
      public var y:int;
      
      public var offsetX:int;
      
      public var offsetY:int;
      
      public var width:int;
      
      public var height:int;
      
      public var advance:int;
      
      public var lineHeight:int;
      
      public var imgId:String;
      
      public var channel:int;
      
      public var res:ResourceRef;
      
      public var scaledRes:ResourceRef;
      
      public var bitmapData:BitmapData;
      
      public var scaledBitmapData:BitmapData;
      
      public function FBMGlyph()
      {
         super();
      }
   }
}

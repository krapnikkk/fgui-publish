package fairygui.editor.gui.text
{
   import fairygui.editor.gui.EPackageItem;
   import flash.display.BitmapData;
   
   public class EBMGlyph
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
      
      public var item:EPackageItem;
      
      public var bitmapData:BitmapData;
      
      public var outlineBitmapData:BitmapData;
      
      public function EBMGlyph()
      {
         super();
      }
   }
}

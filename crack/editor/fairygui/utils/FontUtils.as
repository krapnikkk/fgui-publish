package fairygui.utils
{
   import flash.text.Font;
   import flash.text.TextFormat;
   
   public class FontUtils
   {
      
      private static var sEmbeddedFonts:Array = null;
       
      
      public function FontUtils()
      {
         super();
      }
      
      public static function updateEmbeddedFonts() : void
      {
         sEmbeddedFonts = null;
      }
      
      public static function isEmbeddedFont(param1:TextFormat) : Boolean
      {
         var _loc4_:* = null;
         var _loc7_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc2_:Boolean = false;
         if(sEmbeddedFonts == null)
         {
            sEmbeddedFonts = Font.enumerateFonts(false);
         }
         var _loc9_:int = 0;
         var _loc8_:* = sEmbeddedFonts;
         for each(var _loc5_ in sEmbeddedFonts)
         {
            _loc4_ = _loc5_.fontStyle;
            _loc7_ = _loc4_ == "bold" || _loc4_ == "boldItalic";
            _loc3_ = _loc4_ == "italic" || _loc4_ == "boldItalic";
            _loc6_ = param1.bold == null?false:param1.bold;
            _loc2_ = param1.italic == null?false:param1.italic;
            if(param1.font == _loc5_.fontName && _loc2_ == _loc3_ && _loc6_ == _loc7_)
            {
               return true;
            }
         }
         return false;
      }
   }
}

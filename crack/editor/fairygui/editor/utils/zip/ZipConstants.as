package fairygui.editor.utils.zip
{
   public class ZipConstants
   {
      
      static const LOCSIG:uint = 67324752;
      
      static const EXTSIG:uint = 134695760;
      
      static const CENSIG:uint = 33639248;
      
      static const ENDSIG:uint = 101010256;
      
      static const LOCHDR:int = 30;
      
      static const EXTHDR:int = 16;
      
      static const CENHDR:int = 46;
      
      static const ENDHDR:int = 22;
      
      static const LOCVER:int = 4;
      
      static const LOCFLG:int = 6;
      
      static const LOCHOW:int = 8;
      
      static const LOCTIM:int = 10;
      
      static const LOCCRC:int = 14;
      
      static const LOCSIZ:int = 18;
      
      static const LOCLEN:int = 22;
      
      static const LOCNAM:int = 26;
      
      static const LOCEXT:int = 28;
      
      static const EXTCRC:int = 4;
      
      static const EXTSIZ:int = 8;
      
      static const EXTLEN:int = 12;
      
      static const CENVEM:int = 4;
      
      static const CENVER:int = 6;
      
      static const CENFLG:int = 8;
      
      static const CENHOW:int = 10;
      
      static const CENTIM:int = 12;
      
      static const CENCRC:int = 16;
      
      static const CENSIZ:int = 20;
      
      static const CENLEN:int = 24;
      
      static const CENNAM:int = 28;
      
      static const CENEXT:int = 30;
      
      static const CENCOM:int = 32;
      
      static const CENDSK:int = 34;
      
      static const CENATT:int = 36;
      
      static const CENATX:int = 38;
      
      static const CENOFF:int = 42;
      
      static const ENDSUB:int = 8;
      
      static const ENDTOT:int = 10;
      
      static const ENDSIZ:int = 12;
      
      static const ENDOFF:int = 16;
      
      static const ENDCOM:int = 20;
      
      public static const STORED:int = 0;
      
      public static const DEFLATED:int = 8;
       
      
      public function ZipConstants()
      {
         super();
      }
   }
}

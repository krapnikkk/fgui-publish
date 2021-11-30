package fairygui.text
{
   import flash.text.TextFormat;
   
   class HtmlElement
   {
      
      public static const LINK:int = 1;
      
      public static const IMAGE:int = 2;
       
      
      public var type:int;
      
      public var start:int;
      
      public var end:int;
      
      public var textformat:TextFormat;
      
      public var id:String;
      
      public var width:int;
      
      public var height:int;
      
      public var href:String;
      
      public var target:String;
      
      public var src:String;
      
      public var realWidth:int;
      
      public var realHeight:int;
      
      function HtmlElement()
      {
         super();
      }
   }
}

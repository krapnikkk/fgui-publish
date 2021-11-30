package fairygui.text
{
   import flash.display.DisplayObject;
   
   class HtmlNode
   {
       
      
      public var charStart:int;
      
      public var charEnd:int;
      
      public var lineIndex:int;
      
      public var nodeIndex:int;
      
      public var element:HtmlElement;
      
      public var displayObject:DisplayObject;
      
      public var topY:Number;
      
      public var posUpdated:Boolean;
      
      function HtmlNode()
      {
         super();
      }
      
      public function reset() : void
      {
         charStart = -1;
         charEnd = -1;
         lineIndex = -1;
         nodeIndex = -1;
         displayObject = null;
         posUpdated = false;
      }
   }
}

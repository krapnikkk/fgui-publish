package fairygui.editor.gui.text
{
   import flash.display.DisplayObject;
   
   public class FHtmlNode
   {
       
      
      public var charStart:int;
      
      public var charEnd:int;
      
      public var element:FHtmlElement;
      
      public var displayObject:DisplayObject;
      
      public var topY:Number;
      
      public function FHtmlNode()
      {
         super();
      }
      
      public function reset() : void
      {
         this.charStart = -1;
         this.charEnd = -1;
         this.displayObject = null;
      }
   }
}

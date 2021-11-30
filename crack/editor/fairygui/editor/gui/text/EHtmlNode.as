package fairygui.editor.gui.text
{
   import flash.display.DisplayObject;
   
   public class EHtmlNode
   {
       
      
      public var charStart:int;
      
      public var charEnd:int;
      
      public var lineIndex:int;
      
      public var nodeIndex:int;
      
      public var element:EHtmlElement;
      
      public var displayObject:DisplayObject;
      
      public var topY:Number;
      
      public var posUpdated:Boolean;
      
      public function EHtmlNode()
      {
         super();
      }
      
      public function reset() : void
      {
         this.charStart = -1;
         this.charEnd = -1;
         this.lineIndex = -1;
         this.nodeIndex = -1;
         this.displayObject = null;
         this.posUpdated = false;
      }
   }
}

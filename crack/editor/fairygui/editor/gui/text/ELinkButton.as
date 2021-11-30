package fairygui.editor.gui.text
{
   import flash.display.Sprite;
   
   public class ELinkButton extends Sprite
   {
       
      
      public var owner:EHtmlNode;
      
      public function ELinkButton()
      {
         super();
         buttonMode = true;
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,10,10);
         graphics.endFill();
      }
   }
}

package fairygui.text
{
   import flash.display.Sprite;
   
   public class LinkButton extends Sprite
   {
       
      
      public var owner:HtmlNode;
      
      public function LinkButton()
      {
         super();
         buttonMode = true;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         graphics.clear();
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
   }
}

package fairygui.utils.pack
{
   public class Page
   {
       
      
      public var outputRects:Vector.<NodeRect>;
      
      public var remainingRects:Vector.<NodeRect>;
      
      public var occupancy:Number;
      
      public var width:int;
      
      public var height:int;
      
      public function Page()
      {
         super();
         this.occupancy = 0;
         this.outputRects = new Vector.<NodeRect>();
      }
   }
}

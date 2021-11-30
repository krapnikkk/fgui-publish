package fairygui.text
{
   import fairygui.GLoader;
   import fairygui.display.UIDisplayObject;
   import flash.display.DisplayObject;
   
   public class RichTextObjectFactory implements IRichTextObjectFactory
   {
       
      
      public var pool:Array;
      
      public function RichTextObjectFactory()
      {
         super();
         pool = [];
      }
      
      public function createObject(param1:String, param2:int, param3:int) : DisplayObject
      {
         var _loc4_:* = null;
         if(pool.length > 0)
         {
            _loc4_ = pool.pop();
         }
         else
         {
            _loc4_ = new GLoader();
            _loc4_.fill = 4;
         }
         _loc4_.url = param1;
         _loc4_.setSize(param2,param3);
         return _loc4_.displayObject;
      }
      
      public function freeObject(param1:DisplayObject) : void
      {
         var _loc2_:GLoader = GLoader(UIDisplayObject(param1).owner);
         _loc2_.url = null;
         pool.push(_loc2_);
      }
   }
}

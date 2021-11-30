package fairygui.text
{
   import fairygui.GLoader;
   import fairygui.PackageItem;
   import fairygui.UIPackage;
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
         var _loc5_:PackageItem = UIPackage.getItemByURL(param1);
         if(param2 != 0)
         {
            _loc4_.width = param2;
         }
         else
         {
            if(_loc5_ != null)
            {
               param2 = _loc5_.width;
            }
            else
            {
               param2 = 20;
            }
            _loc4_.width = param2;
         }
         if(param3 != 0)
         {
            _loc4_.height = param3;
         }
         else
         {
            if(_loc5_ != null)
            {
               param3 = _loc5_.height;
            }
            else
            {
               param3 = 20;
            }
            _loc4_.height = param3;
         }
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

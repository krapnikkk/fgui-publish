package fairygui.editor.gui
{
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.api.IUIProject;
   
   public class MissingInfo
   {
       
      
      public var project:IUIProject;
      
      public var pkg:IUIPackage;
      
      public var pkgId:String;
      
      public var itemId:String;
      
      public var fileName:String;
      
      public function MissingInfo()
      {
         super();
      }
      
      public static function create(param1:IUIPackage, param2:String, param3:String, param4:String) : MissingInfo
      {
         var _loc5_:MissingInfo = new MissingInfo();
         _loc5_.project = param1.project;
         _loc5_.pkgId = param2;
         _loc5_.itemId = param3;
         _loc5_.fileName = param4;
         if(param2)
         {
            _loc5_.pkg = _loc5_.project.getPackage(param2);
         }
         return _loc5_;
      }
      
      public static function create2(param1:IUIPackage, param2:String) : MissingInfo
      {
         var _loc3_:MissingInfo = new MissingInfo();
         _loc3_.project = param1.project;
         if(param2)
         {
            _loc3_.pkgId = param2.substr(5,8);
            _loc3_.itemId = param2.substr(13);
         }
         else
         {
            _loc3_.pkgId = _loc3_.itemId = "";
         }
         if(_loc3_.pkgId)
         {
            _loc3_.pkg = _loc3_.project.getPackage(_loc3_.pkgId);
         }
         return _loc3_;
      }
   }
}

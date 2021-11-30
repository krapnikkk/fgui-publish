package fairygui.editor.gui
{
   import fairygui.editor.api.IUIPackage;
   
   public class FObjectFactory
   {
      
      public static var constructingDepth:int;
       
      
      public function FObjectFactory()
      {
         super();
      }
      
      public static function createObject(param1:FPackageItem, param2:int = 0) : FObject
      {
         var pi:FPackageItem = param1;
         var flags:int = param2;
         var g:FObject = newObject(pi,flags);
         g._underConstruct = true;
         constructingDepth++;
         try
         {
            g.create();
         }
         finally
         {
            constructingDepth--;
            g._underConstruct = false;
         }
         return g;
      }
      
      public static function createObject2(param1:IUIPackage, param2:String, param3:MissingInfo = null, param4:int = 0) : FObject
      {
         var pkg:IUIPackage = param1;
         var type:String = param2;
         var missingInfo:MissingInfo = param3;
         var flags:int = param4;
         var g:FObject = newObject2(pkg,type,missingInfo,flags);
         g._underConstruct = true;
         constructingDepth++;
         try
         {
            g.create();
         }
         finally
         {
            constructingDepth--;
            g._underConstruct = false;
         }
         return g;
      }
      
      public static function createObject3(param1:FDisplayListItem, param2:int = 0) : FObject
      {
         var di:FDisplayListItem = param1;
         var flags:int = param2;
         var g:FObject = newObject3(di,flags);
         g._underConstruct = true;
         constructingDepth++;
         try
         {
            g.create();
         }
         finally
         {
            constructingDepth--;
            g._underConstruct = false;
         }
         return g;
      }
      
      static function newObject(param1:FPackageItem, param2:int = 0) : FObject
      {
         var _loc3_:Object = getClassByType(param1.type);
         var _loc4_:FObject = new _loc3_();
         _loc4_._pkg = param1.owner;
         _loc4_._flags = param2;
         _loc4_._res = new ResourceRef(param1,null,param2);
         return _loc4_;
      }
      
      static function newObject2(param1:IUIPackage, param2:String, param3:MissingInfo = null, param4:int = 0) : FObject
      {
         var _loc5_:Object = getClassByType(param2);
         var _loc6_:FObject = new _loc5_();
         _loc6_._pkg = FPackage(param1);
         _loc6_._flags = param4;
         if(param3)
         {
            _loc6_._res = new ResourceRef(null,param3,param4);
         }
         return _loc6_;
      }
      
      static function newObject3(param1:FDisplayListItem, param2:int = 0) : FObject
      {
         if(param1.packageItem)
         {
            return newObject(param1.packageItem,param2);
         }
         return newObject2(param1.pkg,param1.type,param1.missingInfo,param2);
      }
      
      public static function newExtention(param1:IUIPackage, param2:String) : ComExtention
      {
         var _loc3_:ComExtention = null;
         var _loc4_:Object = null;
         switch(param2)
         {
            case "Label":
               _loc3_ = new FLabel();
               break;
            case "Button":
               _loc3_ = new FButton();
               break;
            case "ProgressBar":
               _loc3_ = new FProgressBar();
               break;
            case "ScrollBar":
               _loc3_ = new FScrollBar();
               break;
            case "Slider":
               _loc3_ = new FSlider();
               break;
            case "ComboBox":
               _loc3_ = new FComboBox();
               break;
            default:
               _loc4_ = param1.project.getCustomExtension(param2);
               if(_loc4_)
               {
                  return newExtention(param1,_loc4_.superClassName);
               }
               break;
         }
         if(_loc3_)
         {
            _loc3_._type = param2;
         }
         return _loc3_;
      }
      
      public static function getClassByType(param1:String) : Object
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case FObjectType.IMAGE:
               _loc2_ = FImage;
               break;
            case FObjectType.SWF:
               _loc2_ = FSwfObject;
               break;
            case FObjectType.MOVIECLIP:
            case "jta":
               _loc2_ = FMovieClip;
               break;
            case FObjectType.COMPONENT:
               _loc2_ = FComponent;
               break;
            case FObjectType.TEXT:
               _loc2_ = FTextField;
               break;
            case FObjectType.RICHTEXT:
               _loc2_ = FRichTextField;
               break;
            case FObjectType.GROUP:
               _loc2_ = FGroup;
               break;
            case FObjectType.LIST:
               _loc2_ = FList;
               break;
            case FObjectType.GRAPH:
               _loc2_ = FGraph;
               break;
            case FObjectType.LOADER:
               _loc2_ = FLoader;
               break;
            default:
               _loc2_ = FGraph;
         }
         return _loc2_;
      }
   }
}

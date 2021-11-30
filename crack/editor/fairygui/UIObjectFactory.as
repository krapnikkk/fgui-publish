package fairygui
{
   public class UIObjectFactory
   {
      
      static var packageItemExtensions:Object = {};
      
      private static var loaderType:Class;
       
      
      public function UIObjectFactory()
      {
         super();
      }
      
      public static function setPackageItemExtension(param1:String, param2:Class) : void
      {
         if(param1 == null)
         {
            throw new Error("Invaild url: " + param1);
         }
         var _loc3_:PackageItem = UIPackage.getItemByURL(param1);
         if(_loc3_ != null)
         {
            _loc3_.extensionType = param2;
         }
         packageItemExtensions[param1] = param2;
      }
      
      public static function setLoaderExtension(param1:Class) : void
      {
         loaderType = param1;
      }
      
      static function resolvePackageItemExtension(param1:PackageItem) : void
      {
         param1.extensionType = packageItemExtensions["ui://" + param1.owner.id + param1.id];
         if(!param1.extensionType)
         {
            param1.extensionType = packageItemExtensions["ui://" + param1.owner.name + "/" + param1.name];
         }
      }
      
      public static function newObject(param1:PackageItem) : GObject
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         switch(int(param1.type))
         {
            case 0:
               return new GImage();
            case 1:
               return new GSwfObject();
            case 2:
               return new GMovieClip();
            default:
               return null;
            case 4:
               _loc2_ = param1.extensionType;
               if(_loc2_)
               {
                  return new _loc2_();
               }
               _loc4_ = param1.owner.getComponentData(param1);
               _loc3_ = _loc4_.@extention;
               if(_loc3_ != null)
               {
                  var _loc5_:* = _loc3_;
                  if("Button" !== _loc5_)
                  {
                     if("Label" !== _loc5_)
                     {
                        if("ProgressBar" !== _loc5_)
                        {
                           if("Slider" !== _loc5_)
                           {
                              if("ScrollBar" !== _loc5_)
                              {
                                 if("ComboBox" !== _loc5_)
                                 {
                                    return new GComponent();
                                 }
                                 return new GComboBox();
                              }
                              return new GScrollBar();
                           }
                           return new GSlider();
                        }
                        return new GProgressBar();
                     }
                     return new GLabel();
                  }
                  return new GButton();
               }
               return new GComponent();
         }
      }
      
      public static function newObject2(param1:String) : GObject
      {
         var _loc2_:* = param1;
         if("image" !== _loc2_)
         {
            if("video" !== _loc2_)
            {
               if("movieclip" !== _loc2_)
               {
                  if("swf" !== _loc2_)
                  {
                     if("component" !== _loc2_)
                     {
                        if("text" !== _loc2_)
                        {
                           if("richtext" !== _loc2_)
                           {
                              if("inputtext" !== _loc2_)
                              {
                                 if("group" !== _loc2_)
                                 {
                                    if("list" !== _loc2_)
                                    {
                                       if("graph" !== _loc2_)
                                       {
                                          if("loader" !== _loc2_)
                                          {
                                             return null;
                                          }
                                          if(loaderType != null)
                                          {
                                             return new loaderType();
                                          }
                                          return new GLoader();
                                       }
                                       return new GGraph();
                                    }
                                    return new GList();
                                 }
                                 return new GGroup();
                              }
                              return new GTextInput();
                           }
                           return new GRichTextField();
                        }
                        return new GTextField();
                     }
                     return new GComponent();
                  }
                  return new GSwfObject();
               }
               return new GMovieClip();
            }
            return new GImage();
         }
         return new GGraph();
      }
   }
}

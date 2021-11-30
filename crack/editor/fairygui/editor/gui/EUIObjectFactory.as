package fairygui.editor.gui
{
   import fairygui.fysheji.EGDragonBone;
   
   public class EUIObjectFactory
   {
      
      public static var constructingDepth:int;
       
      
      public function EUIObjectFactory()
      {
         super();
      }
      
      public static function createObject(param1:EPackageItem, param2:int = 0) : EGObject
      {
         var _loc6_:* = param1;
         var _loc5_:* = param2;
         var _loc4_:Object = getClassByType(_loc6_.type);
         if(_loc4_ == null)
         {
            return null;
         }
         var _loc3_:EGObject = new _loc4_();
         _loc3_.pkg = _loc6_.owner;
         _loc3_.editMode = _loc5_;
         _loc3_.underConstruct = true;
         _loc3_.packageItem = _loc6_;
         _loc3_.packageItemVersion = _loc6_.version;
         constructingDepth = Number(constructingDepth) + 1;
         _loc3_.create();
         return _loc3_;
      }
      
      public static function createObject2(param1:EUIPackage, param2:String, param3:int = 0) : EGObject
      {
         var _loc6_:* = param1;
         var _loc8_:* = param2;
         var _loc7_:* = param3;
         var _loc5_:Object = getClassByType(_loc8_);
         if(_loc5_ == null)
         {
            return null;
         }
         var _loc4_:EGObject = new _loc5_();
         _loc4_.pkg = _loc6_;
         _loc4_.editMode = _loc7_;
         _loc4_.underConstruct = true;
         constructingDepth = Number(constructingDepth) + 1;
         var _loc9_:int = 0;
         try
         {
            _loc4_.create();
         }
         catch(_loc10_:*)
         {
            _loc9_ = 1;
         }
         constructingDepth = Number(constructingDepth) - 1;
         _loc4_.underConstruct = false;
         if(!int(_loc9_))
         {
            return _loc4_;
         }
         throw _loc10_;
      }
      
      public static function createExtention(param1:EUIPackage, param2:String) : ComExtention
      {
         var _loc3_:ComExtention = null;
         var _loc4_:Object = null;
         var _loc5_:* = param2;
         if("Label" !== _loc5_)
         {
            if("Button" !== _loc5_)
            {
               if("ProgressBar" !== _loc5_)
               {
                  if("ScrollBar" !== _loc5_)
                  {
                     if("Slider" !== _loc5_)
                     {
                        if("ComboBox" !== _loc5_)
                        {
                           _loc4_ = param1.project.plugInManager1.comExtensions[param2];
                           if(_loc4_)
                           {
                              return createExtention(param1,_loc4_.superClassName);
                           }
                        }
                        else
                        {
                           _loc3_ = new EGComboBox();
                        }
                     }
                     else
                     {
                        _loc3_ = new EGSlider();
                     }
                  }
                  else
                  {
                     _loc3_ = new EGScrollBar();
                  }
               }
               else
               {
                  _loc3_ = new EGProgressBar();
               }
            }
            else
            {
               _loc3_ = new EGButton();
            }
         }
         else
         {
            _loc3_ = new EGLabel();
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
         var _loc3_:* = param1;
         if("image" !== _loc3_)
         {
            if("swf" !== _loc3_)
            {
               if("movieclip" !== _loc3_)
               {
                  if("jta" !== _loc3_)
                  {
                     if("component" !== _loc3_)
                     {
                        if("video" !== _loc3_)
                        {
                           if("dragonbone" !== _loc3_)
                           {
                              if("text" !== _loc3_)
                              {
                                 if("richtext" !== _loc3_)
                                 {
                                    if("group" !== _loc3_)
                                    {
                                       if("list" !== _loc3_)
                                       {
                                          if("graph" !== _loc3_)
                                          {
                                             if("loader" === _loc3_)
                                             {
                                                _loc2_ = EGLoader;
                                             }
                                          }
                                          else
                                          {
                                             _loc2_ = EGGraph;
                                          }
                                       }
                                       else
                                       {
                                          _loc2_ = EGList;
                                       }
                                    }
                                    else
                                    {
                                       _loc2_ = EGGroup;
                                    }
                                 }
                                 else
                                 {
                                    _loc2_ = EGRichTextField;
                                 }
                              }
                              else
                              {
                                 _loc2_ = EGTextField;
                              }
                           }
                           else
                           {
                              _loc2_ = EGDragonBone;
                           }
                        }
                        else
                        {
                           _loc2_ = EGVideo;
                        }
                     }
                     else
                     {
                        _loc2_ = EGComponent;
                     }
                  }
               }
               _loc2_ = EGMovieClip;
            }
            else
            {
               _loc2_ = EGSwfObject;
            }
         }
         else
         {
            _loc2_ = EGImage;
         }
         return _loc2_;
      }
   }
}

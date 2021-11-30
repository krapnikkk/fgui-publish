package fairygui.editor.publish.gencode
{
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.publish.PublishData;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.utils.PinYinUtil;
   
   public class GenCodeUtils
   {
      
      public static const FILE_MARK:String = "/** This is an automatically generated class by FairyGUI. Please do not modify it. **/";
       
      
      public function GenCodeUtils()
      {
         super();
      }
      
      public static function checkIsUseDefaultName(param1:String, param2:String, param3:String) : Boolean
      {
         var _loc4_:int = 0;
         if(param2 == "Controller")
         {
            if((param1 == "GButton" || param1 == "GComboBox") && param3 == "button")
            {
               return true;
            }
         }
         else if(param2 != "Transition")
         {
            var _loc5_:* = param1;
            if("GButton" !== _loc5_)
            {
               if("GLabel" !== _loc5_)
               {
                  if("GComboBox" !== _loc5_)
                  {
                     if("GProgressBar" !== _loc5_)
                     {
                        if("GSlider" === _loc5_)
                        {
                           if(param3 == "bar" || param3 == "bar_v" || param3 == "grip" || param3 == "title" || param3 == "ani")
                           {
                              return true;
                           }
                        }
                     }
                     else if(param3 == "bar" || param3 == "bar_v" || param3 == "title" || param3 == "ani")
                     {
                        return true;
                     }
                  }
                  addr121:
                  if(param3.charAt(0) == "n")
                  {
                     _loc4_ = param3.indexOf("_");
                     if(_loc4_ != -1)
                     {
                        if(!isNaN(parseInt(param3.substring(1,_loc4_))))
                        {
                           return true;
                        }
                     }
                     else if(!isNaN(parseInt(param3.substring(1))))
                     {
                        return true;
                     }
                  }
               }
               addr34:
               if(param3 == "title" || param3 == "icon")
               {
                  return true;
               }
               §§goto(addr121);
            }
            §§goto(addr34);
         }
         return false;
      }
      
      public static function prepare(param1:PublishData) : void
      {
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc2_:int = 0;
         var _loc4_:Object = null;
         var _loc8_:* = undefined;
         var _loc7_:Object = null;
         var _loc6_:EPackageItem = null;
         var _loc3_:XML = null;
         var _loc5_:String = null;
         var _loc11_:GlobalPublishSettings = param1._project.settingsCenter.publish;
         var _loc15_:int = 0;
         var _loc14_:* = param1.outputClasses;
         for each(_loc10_ in param1.outputClasses)
         {
            _loc10_.encodedClassName = _loc11_.classNamePrefix + PinYinUtil.toPinyin(_loc10_.className);
            _loc9_ = {};
            _loc2_ = 0;
            var _loc13_:int = 0;
            var _loc12_:* = _loc10_.members;
            for each(_loc4_ in _loc10_.members)
            {
               _loc4_.originalName = _loc4_.name;
               if(_loc11_.ignoreNoname && checkIsUseDefaultName(_loc10_.superClassName,_loc4_.type,_loc4_.name))
               {
                  _loc4_.ignored = true;
               }
               else
               {
                  _loc8_ = _loc9_[_loc4_.name];
                  if(_loc8_ != undefined)
                  {
                     _loc8_++;
                     _loc9_[_loc4_.name] = _loc8_;
                     _loc4_.name = _loc4_.name + "_" + _loc8_;
                  }
                  _loc9_[_loc4_.name] = 1;
                  _loc2_++;
               }
            }
            if(_loc2_ == 0)
            {
               _loc10_.ignored = true;
            }
         }
         var _loc19_:int = 0;
         var _loc18_:* = param1.outputClasses;
         for each(_loc10_ in param1.outputClasses)
         {
            if(!_loc10_.ignored)
            {
               var _loc17_:int = 0;
               var _loc16_:* = _loc10_.members;
               for each(_loc4_ in _loc10_.members)
               {
                  if(_loc4_.src)
                  {
                     if(!_loc4_.pkg_id)
                     {
                        _loc7_ = param1.outputClasses[_loc4_.src_id];
                        if(_loc7_)
                        {
                           if(!_loc7_.ignored)
                           {
                              _loc4_.type = _loc7_.encodedClassName;
                           }
                           else
                           {
                              _loc4_.type = _loc7_.superClassName;
                           }
                        }
                        else
                        {
                           _loc4_.type = "GComponent";
                        }
                     }
                     else
                     {
                        _loc6_ = param1._project.getPackage(_loc4_.pkg_id).getItem(_loc4_.src_id);
                        if(_loc6_)
                        {
                           _loc3_ = _loc6_.owner.getComponentXML(_loc6_,false);
                           _loc5_ = _loc3_.@extention;
                           if(_loc5_)
                           {
                              _loc4_.type = "G" + _loc5_;
                           }
                        }
                     }
                  }
                  if(!_loc11_.memberNamePrefix)
                  {
                     _loc4_.name = PinYinUtil.toPinyin(_loc4_.name);
                  }
                  else
                  {
                     _loc4_.name = _loc11_.memberNamePrefix + PinYinUtil.toPinyin(_loc4_.name);
                  }
               }
               continue;
            }
         }
      }
      
      public static function translateClassName(param1:String) : String
      {
         var _loc2_:* = param1;
         if("GImage" !== _loc2_)
         {
            if("GMovieClip" !== _loc2_)
            {
               if("GSwfObject" !== _loc2_)
               {
                  if("GLoader" !== _loc2_)
                  {
                     if("GTextField" !== _loc2_)
                     {
                        if("GRichTextField" !== _loc2_)
                        {
                           if("GTextInput" !== _loc2_)
                           {
                              if("GGraph" !== _loc2_)
                              {
                                 if("GVideo" !== _loc2_)
                                 {
                                    if("GGroup" !== _loc2_)
                                    {
                                       if("GComponent" !== _loc2_)
                                       {
                                          if("GList" !== _loc2_)
                                          {
                                             if("GLabel" !== _loc2_)
                                             {
                                                if("GButton" !== _loc2_)
                                                {
                                                   if("GComboBox" !== _loc2_)
                                                   {
                                                      if("GSlider" !== _loc2_)
                                                      {
                                                         if("GProgressBar" !== _loc2_)
                                                         {
                                                            if("GScrollBar" !== _loc2_)
                                                            {
                                                               if("Controller" !== _loc2_)
                                                               {
                                                                  if("Transition" !== _loc2_)
                                                                  {
                                                                     return param1;
                                                                  }
                                                               }
                                                               addr24:
                                                               return "fairygui." + param1;
                                                            }
                                                            addr23:
                                                            §§goto(addr24);
                                                         }
                                                         addr22:
                                                         §§goto(addr23);
                                                      }
                                                      addr21:
                                                      §§goto(addr22);
                                                   }
                                                   addr20:
                                                   §§goto(addr21);
                                                }
                                                addr19:
                                                §§goto(addr20);
                                             }
                                             addr18:
                                             §§goto(addr19);
                                          }
                                          addr17:
                                          §§goto(addr18);
                                       }
                                       addr16:
                                       §§goto(addr17);
                                    }
                                    addr15:
                                    §§goto(addr16);
                                 }
                                 addr14:
                                 §§goto(addr15);
                              }
                              addr13:
                              §§goto(addr14);
                           }
                           addr12:
                           §§goto(addr13);
                        }
                        addr11:
                        §§goto(addr12);
                     }
                     addr10:
                     §§goto(addr11);
                  }
                  addr9:
                  §§goto(addr10);
               }
               addr8:
               §§goto(addr9);
            }
            addr7:
            §§goto(addr8);
         }
         §§goto(addr7);
      }
   }
}

package fairygui.editor.publish
{
   import fairygui.editor.api.ProjectType;
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.gui.FPackageItemType;
   import fairygui.editor.settings.CommonSettings;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import flash.utils.ByteArray;
   
   public class §_-NR§ extends taskRun
   {
       
      
      public function §_-NR§()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc1_:FPackageItem = null;
         var _loc2_:String = null;
         var _loc3_:ByteArray = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:XData = null;
         var _loc15_:FPackageItem = null;
         var _loc16_:* = false;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:§_-4E§ = null;
         var _loc21_:XData = null;
         var _loc22_:Array = null;
         var _loc6_:XData = XData.create("packageDescription");
         _loc6_.setAttribute("id",publishData.pkg.id);
         _loc6_.setAttribute("name",publishData.pkg.name);
         if(publishData.§_-1e§ > 0)
         {
            _loc4_ = [];
            for(_loc4_[publishData.§_-GR§[_loc12_]] in publishData.§_-GR§)
            {
            }
            _loc6_.setAttribute("branches",_loc4_.join(","));
         }
         var _loc7_:XData = XData.create("resources");
         var _loc8_:CommonSettings = CommonSettings(publishData.project.getSettings("common"));
         var _loc9_:String = _loc8_.verticalScrollBar;
         var _loc10_:String = _loc8_.horizontalScrollBar;
         if(_loc9_ || _loc10_)
         {
            _loc6_.setAttribute("scrollBarRes",(!!_loc9_?_loc9_:"") + "," + (!!_loc10_?_loc10_:""));
         }
         var _loc11_:* = publishData.allBranches > 0;
         for each(_loc1_ in publishData.items)
         {
            _loc13_ = UtilsStr.getFileExt(_loc1_.fileName);
            if(_loc13_)
            {
               if(_loc13_.toLowerCase() == "svg")
               {
                  _loc13_ = "png";
               }
               _loc2_ = _loc1_.§_-e§ + "." + _loc13_;
            }
            else
            {
               _loc2_ = _loc1_.§_-e§;
            }
            _loc14_ = _loc1_.serialize(true);
            switch(_loc1_.type)
            {
               case FPackageItemType.COMPONENT:
                  if(!publishData.outputDesc[_loc1_.§_-e§ + ".xml"])
                  {
                     _loc14_ = null;
                  }
                  break;
               case FPackageItemType.IMAGE:
                  if(!publishData.§_-O4§)
                  {
                     if(_loc1_.image && (_loc3_ = UtilsFile.loadBytes(_loc1_.imageInfo.file)) != null)
                     {
                        _loc15_ = publishData.§_-BD§[_loc1_.§_-e§];
                        if(_loc15_)
                        {
                           _loc2_ = _loc15_.§_-e§ + "." + _loc13_;
                           publishData.outputRes[_loc2_] = _loc3_;
                           _loc14_ = null;
                        }
                        else
                        {
                           publishData.outputRes[_loc2_] = _loc3_;
                           _loc14_.setAttribute("file",_loc2_);
                        }
                     }
                  }
                  break;
               case FPackageItemType.MOVIECLIP:
                  if(!publishData.outputDesc[_loc1_.§_-e§ + ".xml"])
                  {
                     _loc14_ = null;
                  }
                  break;
               case FPackageItemType.SWF:
                  if(publishData.project.type != ProjectType.FLASH)
                  {
                     _loc14_ = null;
                  }
                  break;
               case FPackageItemType.FONT:
                  _loc5_ = UtilsFile.loadString(_loc1_.file);
                  if(_loc5_)
                  {
                     if(_loc1_.fontSettings.texture)
                     {
                        _loc14_.setAttribute("fontTexture",_loc1_.fontSettings.texture);
                     }
                     publishData.outputDesc[_loc2_] = _loc5_;
                  }
                  else
                  {
                     _loc14_ = null;
                  }
                  break;
               default:
                  _loc3_ = UtilsFile.loadBytes(_loc1_.file);
                  if(_loc3_)
                  {
                     publishData.outputRes[_loc2_] = _loc3_;
                     _loc14_.setAttribute("file",_loc2_);
                  }
                  else
                  {
                     _loc14_ = null;
                  }
            }
            if(_loc14_)
            {
               if(_loc1_.imageInfo)
               {
                  _loc17_ = _loc1_.getVar("pubInfo.highRes");
                  if(_loc17_)
                  {
                     _loc14_.setAttribute("highRes",_loc17_);
                  }
               }
               _loc16_ = _loc1_.branch.length > 0;
               if(_loc11_)
               {
                  if(publishData.includeBranches)
                  {
                     if(_loc1_.branch.length == 0)
                     {
                        _loc18_ = _loc1_.getVar("pubInfo.branch");
                        if(_loc18_)
                        {
                           _loc19_ = 0;
                           while(_loc19_ < publishData.§_-1e§)
                           {
                              _loc12_ = _loc18_[_loc19_];
                              if(!_loc12_)
                              {
                                 _loc18_[_loc19_] = "";
                              }
                              _loc19_++;
                           }
                           _loc14_.setAttribute("branches",_loc18_.join(","));
                        }
                     }
                  }
                  else if(_loc1_.branch.length > 0 && _loc1_.getVar("pubInfo.branch"))
                  {
                     _loc16_ = false;
                     _loc14_.setAttribute("branches",_loc1_.id);
                  }
               }
               if(_loc16_)
               {
                  _loc14_.setAttribute("branch",_loc1_.branch);
               }
               _loc7_.appendChild(_loc14_);
            }
         }
         if(publishData.§_-O4§)
         {
            for each(_loc20_ in publishData.§_-F8§)
            {
               _loc21_ = XData.create("atlas");
               _loc21_.setAttribute("id",_loc20_.id);
               _loc21_.setAttribute("size",_loc20_.width + "," + _loc20_.height);
               _loc21_.setAttribute("file",_loc20_.fileName);
               _loc7_.appendChild(_loc21_);
               if(_loc20_.data)
               {
                  publishData.outputRes[_loc20_.fileName] = _loc20_.data;
               }
               if(_loc20_.§_-8I§)
               {
                  publishData.outputRes[UtilsStr.getFileName(_loc20_.fileName) + "!a.png"] = _loc20_.§_-8I§;
               }
            }
         }
         _loc6_.appendChild(_loc7_);
         publishData.outputDesc["package.xml"] = _loc6_.toXML();
         if(publishData.§_-O4§)
         {
            _loc4_ = [];
            for each(_loc22_ in publishData.§_-Fc§)
            {
               _loc4_.push(_loc22_.join(" "));
            }
            _loc4_.sort();
            publishData.sprites = "//FairyGUI atlas sprites.\n" + _loc4_.join("\n");
         }
         _stepCallback.callOnSuccess();
      }
   }
}

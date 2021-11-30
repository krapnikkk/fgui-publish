package fairygui.editor.publish.exporter
{
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.publish.PublishStep;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.editor.utils.zip.ZipArchive;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   
   public class UnityExporter extends PublishStep
   {
       
      
      public function UnityExporter()
      {
         super();
      }
      
      private static function checkUnityVersion55(param1:File) : Boolean
      {
         var _loc2_:* = null;
         var _loc5_:File = null;
         var _loc7_:String = null;
         var _loc4_:Array = null;
         var _loc3_:String = null;
         var _loc6_:* = param1;
         var _loc8_:Boolean = false;
         try
         {
            _loc2_ = _loc6_;
            while(_loc2_.exists)
            {
               if(_loc2_.name == "Assets")
               {
                  _loc2_ = _loc2_.parent.resolvePath("ProjectSettings");
                  if(_loc2_ != null)
                  {
                     _loc5_ = _loc2_.resolvePath("ProjectVersion.txt");
                     if(_loc5_.exists)
                     {
                        _loc7_ = UtilsFile.loadString(_loc5_);
                        _loc4_ = _loc7_.split("\n");
                        var _loc11_:int = 0;
                        var _loc10_:* = _loc4_;
                        for each(_loc3_ in _loc4_)
                        {
                           if(UtilsStr.startsWith(_loc3_,"m_EditorVersion"))
                           {
                              _loc3_ = _loc3_.substr(17);
                              _loc4_ = _loc3_.split(".");
                              if(int(_loc4_[0]) >= 5 && int(_loc4_[1]) >= 5)
                              {
                                 _loc8_ = true;
                              }
                              break;
                           }
                        }
                     }
                     break;
                  }
                  break;
               }
               _loc2_ = _loc2_.parent;
               if(_loc2_ != null)
               {
                  continue;
               }
               break;
            }
         }
         catch(err:Error)
         {
         }
         return _loc8_;
      }
      
      override public function run() : void
      {
         var _loc1_:* = null;
         var _loc30_:* = null;
         var _loc5_:Boolean = false;
         var _loc19_:* = null;
         var _loc10_:* = null;
         var _loc21_:* = null;
         var _loc20_:* = null;
         var _loc12_:* = null;
         _loc1_ = null;
         _loc30_ = null;
         var _loc23_:* = null;
         _loc1_ = null;
         _loc30_ = null;
         _loc23_ = null;
         var _loc11_:* = null;
         var _loc13_:* = null;
         var _loc18_:* = undefined;
         var _loc27_:String = null;
         var _loc17_:ByteArray = null;
         var _loc28_:GlobalPublishSettings = null;
         var _loc16_:ZipArchive = null;
         var _loc15_:Array = null;
         var _loc25_:String = null;
         var _loc24_:int = 0;
         var _loc14_:int = 0;
         var _loc8_:String = null;
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc7_:int = 0;
         var _loc9_:File = null;
         var _loc26_:File = null;
         var _loc6_:File = new File(publishData.filePath + "/" + publishData.fileName + "." + publishData.fileExtention);
         var _loc3_:String = publishData.filePath + "/" + publishData.fileName + "@";
         var _loc29_:Array = [];
         var _loc22_:Array = [];
         var _loc33_:int = 0;
         for(_loc13_ in publishData.outputDesc)
         {
            _loc22_.push(_loc13_);
         }
         _loc22_.sort();
         _loc28_ = publishData._project.settingsCenter.publish;
         if(_loc28_.unityDataFormat == 1)
         {
            _loc16_ = new ZipArchive();
            var _loc43_:int = 0;
            var _loc42_:* = _loc22_;
            for each(_loc13_ in _loc22_)
            {
               _loc18_ = publishData.outputDesc[_loc13_];
               if(_loc18_ is XML)
               {
                  if((_loc18_ as XML).displayList != undefined)
                  {
                     _loc1_ = null;
                     _loc1_ = (_loc18_ as XML).displayList.elements();
                     var _loc37_:int = 0;
                     var _loc36_:* = _loc1_;
                     for each(_loc30_ in _loc1_)
                     {
                        if(_loc30_.name() == "dragonbone")
                        {
                           _loc5_ = false;
                           _loc19_ = "";
                           _loc10_ = null;
                           _loc20_ = publishData.outputDesc["package.xml"];
                           _loc10_ = (_loc20_ as XML).resources.elements();
                           _loc12_ = _loc30_.@src;
                           var _loc35_:int = 0;
                           for each(_loc21_ in _loc10_)
                           {
                              if(_loc21_.name() == "dragonbone" && _loc21_.@id == _loc30_.@src)
                              {
                                 if(_loc21_.@boneName != undefined && _loc21_.@boneName != "")
                                 {
                                    _loc5_ = true;
                                    _loc19_ = _loc21_.@armatureName;
                                 }
                              }
                           }
                           if(_loc5_)
                           {
                              _loc30_.@armatureName = _loc19_;
                              _loc30_.@resName = _loc30_.@boneName;
                              delete _loc30_.@boneName;
                           }
                           else
                           {
                              _loc30_.@resName = _loc30_.@boneName;
                           }
                        }
                     }
                  }
                  if((_loc18_ as XML).transition != undefined)
                  {
                     _loc1_ = null;
                     _loc1_ = (_loc18_ as XML).transition.elements();
                     var _loc39_:int = 0;
                     var _loc38_:* = _loc1_;
                     for each(_loc30_ in _loc1_)
                     {
                        _loc23_ = _loc30_.@xy;
                        if(_loc30_.@type == "XY" || _loc30_.@type == "XYV" || _loc30_.@type == "Size")
                        {
                           if(_loc30_.@value != undefined && _loc30_.@value != "")
                           {
                              _loc30_.@value = PlugInManager.scaseXY(_loc30_.@value);
                           }
                           if(_loc30_.@startValue != undefined && _loc30_.@startValue != "")
                           {
                              _loc30_.@startValue = PlugInManager.scaseXY(_loc30_.@startValue);
                           }
                           if(_loc30_.@endValue != undefined && _loc30_.@endValue != "")
                           {
                              _loc30_.@endValue = PlugInManager.scaseXY(_loc30_.@endValue);
                           }
                        }
                     }
                  }
                  if((_loc18_ as XML).frames != undefined)
                  {
                     _loc1_ = null;
                     _loc1_ = (_loc18_ as XML).frames.elements();
                     var _loc41_:int = 0;
                     var _loc40_:* = _loc1_;
                     for each(_loc30_ in _loc1_)
                     {
                        _loc23_ = _loc30_.@rect;
                        _loc30_.@rect = this.floor_scaseScale9grid(_loc30_.@rect);
                     }
                  }
                  _loc27_ = (_loc18_ as XML).toXMLString();
               }
               else
               {
                  _loc27_ = String(_loc18_);
               }
               _loc16_.addFileFromString(_loc13_,_loc27_);
            }
            UtilsFile.saveBytes(_loc6_,_loc16_.output(0));
         }
         else
         {
            var _loc45_:int = 0;
            var _loc44_:* = _loc22_;
            for each(_loc13_ in _loc22_)
            {
               _loc18_ = publishData.outputDesc[_loc13_];
               if(_loc18_ is XML)
               {
                  _loc27_ = (_loc18_ as XML).toXMLString();
               }
               else
               {
                  _loc27_ = String(_loc18_);
               }
               _loc29_.push(_loc13_);
               _loc29_.push("|");
               _loc29_.push("" + _loc27_.length);
               _loc29_.push("|");
               _loc29_.push(_loc27_);
            }
            _loc17_ = new ByteArray();
            _loc11_ = _loc29_.join("");
            _loc17_.writeUTFBytes(_loc11_);
            UtilsFile.saveBytes(_loc6_,_loc17_);
         }
         var _loc31_:String = publishData.filePath + "/";
         if(!publishData.exportDescOnly)
         {
            _loc15_ = _loc6_.parent.getDirectoryListing();
            _loc25_ = publishData.fileName + "@";
            _loc24_ = 0;
            for(; _loc24_ < _loc15_.length; _loc24_++)
            {
               _loc2_ = _loc15_[_loc24_].name;
               if(UtilsStr.startsWith(_loc2_,_loc25_))
               {
                  if(UtilsStr.endsWith(_loc2_,".meta"))
                  {
                     _loc4_ = _loc2_.substr(0,_loc2_.length - 5);
                     _loc7_ = _loc4_.indexOf("@");
                     if(_loc7_ != -1)
                     {
                        _loc4_ = _loc4_.substr(_loc7_ + 1);
                     }
                     if(publishData.outputRes[_loc4_] || _loc4_ == "sprites.bytes" || _loc4_ == "hittest.bytes" && publishData.hitTestData.length > 0)
                     {
                     }
                     continue;
                  }
                  try
                  {
                     _loc15_[_loc24_].deleteFile();
                  }
                  catch(err:Error)
                  {
                     stepCallback.msgs.length = 0;
                     stepCallback.addMsg("Unable to delete file \'" + _loc2_ + "\'");
                     stepCallback.callOnFailImmediately();
                     return;
                  }
                  continue;
               }
            }
            _loc14_ = !!publishData.extractAlpha?-1:-3;
            _loc8_ = "TextureImporter:\n  mipmaps:\n    enableMipMap: 0\n  textureFormat: " + _loc14_ + "\n" + "  maxTextureSize: 2048\n" + "  nPOTScale: 0";
            if(checkUnityVersion55(_loc6_))
            {
               _loc8_ = _loc8_ + "\n  textureType: 0\n  textureShape: 1";
            }
            var _loc47_:int = 0;
            var _loc46_:* = publishData.outputRes;
            for(_loc13_ in publishData.outputRes)
            {
               _loc9_ = new File(_loc3_ + _loc13_);
               _loc17_ = publishData.outputRes[_loc13_];
               UtilsFile.saveBytes(_loc9_,_loc17_);
               if(_loc9_.extension == "jpg" || _loc9_.extension == "png")
               {
                  _loc26_ = new File(_loc9_.nativePath + ".meta");
                  if(!_loc26_.exists)
                  {
                     try
                     {
                        UtilsFile.saveString(_loc26_,_loc8_,"UTF-8");
                     }
                     catch(err:Error)
                     {
                        continue;
                     }
                  }
               }
            }
            _loc9_ = new File(_loc3_ + "sprites.bytes");
            _loc17_ = new ByteArray();
            _loc17_.writeUTFBytes(publishData.sprites);
            UtilsFile.saveBytes(_loc9_,_loc17_);
            if(publishData.hitTestData.length > 0)
            {
               _loc9_ = new File(_loc3_ + "hittest.bytes");
               UtilsFile.saveBytes(_loc9_,publishData.hitTestData);
            }
            var _loc49_:int = 0;
            var _loc48_:* = publishData.outputFyDataBy;
            for(_loc13_ in publishData.outputFyDataBy)
            {
               _loc9_ = new File(_loc31_ + _loc13_);
               UtilsFile.saveBytes(_loc9_,publishData.outputFyDataBy[_loc13_]);
            }
            var _loc51_:int = 0;
            var _loc50_:* = publishData.outputFyData;
            for(_loc13_ in publishData.outputFyData)
            {
               _loc9_ = new File(_loc31_ + _loc13_);
               UtilsFile.saveString(_loc9_,publishData.outputFyData[_loc13_],"UTF-8");
            }
         }
         stepCallback.callOnSuccess();
      }
      
      private function floor_scaseScale9grid(param1:String) : String
      {
         var _loc3_:Array = param1.split(",");
         var _loc4_:Number = PlugInManager.FYOUT * _loc3_[2];
         _loc4_ = _loc4_ - Math.floor(_loc4_);
         var _loc2_:Number = PlugInManager.FYOUT * _loc3_[3];
         _loc2_ = _loc2_ - Math.floor(_loc2_);
         var _loc5_:String = PlugInManager.FYOUT * int(_loc3_[0]) + _loc4_ + "," + (PlugInManager.FYOUT * int(_loc3_[1]) + _loc2_) + "," + Math.floor(PlugInManager.FYOUT * int(_loc3_[2])) + "," + Math.floor(PlugInManager.FYOUT * int(_loc3_[3]));
         return _loc5_;
      }
   }
}

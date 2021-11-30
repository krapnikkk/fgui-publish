package fairygui.editor.publish.exporter
{
   import fairygui.editor.PackagesPanel;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.settings.GlobalPublishSettings;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   import mx.utils.Base64Encoder;
   
   public class LayaExporter extends ExporterBase
   {
       
      
      public function LayaExporter()
      {
         super();
      }
      
      public static function scaseScale9grid(param1:String) : String
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = PlugInManager.ceil(PlugInManager.FYOUT * int(_loc2_[0])) + "," + PlugInManager.ceil(PlugInManager.FYOUT * int(_loc2_[1])) + "," + PlugInManager.ceil(PlugInManager.FYOUT * int(_loc2_[2])) + "," + PlugInManager.ceil(PlugInManager.FYOUT * int(_loc2_[3]));
         return _loc3_;
      }
      
      public static function floor_scaseScale9grid(param1:String) : String
      {
         var _loc3_:Array = param1.split(",");
         var _loc4_:Number = PlugInManager.FYOUT * _loc3_[2];
         _loc4_ = _loc4_ - Math.floor(_loc4_);
         var _loc2_:Number = PlugInManager.FYOUT * _loc3_[3];
         _loc2_ = _loc2_ - Math.floor(_loc2_);
         var _loc5_:String = PlugInManager.FYOUT * int(_loc3_[0]) + _loc4_ + "," + (PlugInManager.FYOUT * int(_loc3_[1]) + _loc2_) + "," + Math.floor(PlugInManager.FYOUT * int(_loc3_[2])) + "," + Math.floor(PlugInManager.FYOUT * int(_loc3_[3]));
         return _loc5_;
      }
      
      override public function run() : void
      {
         var _loc27_:* = null;
         var _loc29_:* = null;
         var _loc21_:* = null;
         var _loc2_:* = null;
         var _loc30_:* = null;
         _loc2_ = null;
         _loc30_ = null;
         var _loc5_:Boolean = false;
         var _loc10_:* = null;
         var _loc20_:* = null;
         var _loc19_:* = null;
         var _loc13_:* = null;
         _loc2_ = null;
         _loc30_ = null;
         var _loc22_:* = null;
         _loc2_ = null;
         _loc30_ = null;
         _loc22_ = null;
         var _loc8_:* = null;
         var _loc12_:* = null;
         var _loc18_:ByteArray = null;
         var _loc11_:int = 0;
         var _loc25_:int = 0;
         var _loc7_:int = 0;
         var _loc14_:* = null;
         var _loc16_:Array = null;
         var _loc24_:String = null;
         var _loc23_:int = 0;
         var _loc3_:String = null;
         var _loc9_:File = null;
         var _loc17_:* = undefined;
         var _loc26_:String = null;
         var _loc15_:Base64Encoder = null;
         var _loc6_:File = new File(publishData.filePath + "/" + publishData.fileNameEtx + "." + publishData.fileExtention);
         var _loc4_:String = publishData.filePath + "/" + publishData.fileNameEtx + "@";
         var _loc31_:String = publishData.filePath + "/";
         if(PlugInManager.ISBINARY)
         {
            _loc27_ = publishData._project.settingsCenter.publish;
            exportBinaryDesc(_loc6_,false);
         }
         else if(publishData.sprites == null)
         {
            try
            {
               _loc18_ = UtilsFile.loadBytes(_loc6_);
               _loc18_.inflate();
               _loc26_ = _loc18_.readUTFBytes(_loc18_.length);
               _loc11_ = 0;
               while(true)
               {
                  _loc7_ = _loc26_.indexOf("|",_loc11_);
                  if(_loc7_ != -1)
                  {
                     _loc14_ = _loc26_.substring(_loc11_,_loc7_);
                     _loc11_ = _loc7_ + 1;
                     _loc7_ = _loc26_.indexOf("|",_loc11_);
                     _loc25_ = parseInt(_loc26_.substring(_loc11_,_loc7_));
                     _loc11_ = _loc7_ + 1;
                     if(_loc14_ == "sprites.bytes")
                     {
                        publishData.sprites = _loc26_.substr(_loc11_,_loc25_);
                        break;
                     }
                     _loc11_ = _loc11_ + _loc25_;
                     continue;
                  }
                  break;
               }
            }
            catch(err:Error)
            {
               stepCallback.addMsg("Unable to publish desc only, try publish all!");
               stepCallback.callOnFail();
               return;
            }
         }
         if(!publishData.exportDescOnly)
         {
            _loc16_ = _loc6_.parent.getDirectoryListing();
            _loc24_ = publishData.fileNameEtx + "@";
            _loc23_ = 0;
            while(_loc23_ < _loc16_.length)
            {
               _loc3_ = _loc16_[_loc23_].name;
               if(UtilsStr.startsWith(_loc3_,_loc24_))
               {
                  try
                  {
                     _loc16_[_loc23_].deleteFile();
                  }
                  catch(err:Error)
                  {
                     stepCallback.addMsg("Unable to delete file \'" + _loc3_ + "\'");
                     stepCallback.callOnFailImmediately();
                     return;
                  }
               }
               _loc23_++;
            }
            var _loc37_:int = 0;
            var _loc36_:* = publishData.outputRes;
            for(_loc14_ in publishData.outputRes)
            {
               _loc9_ = new File(_loc4_ + _loc14_);
               UtilsFile.saveBytes(_loc9_,publishData.outputRes[_loc14_]);
            }
            var _loc39_:int = 0;
            var _loc38_:* = publishData.outputFyDataBy;
            for(_loc14_ in publishData.outputFyDataBy)
            {
               _loc9_ = new File(_loc31_ + _loc14_);
               UtilsFile.saveBytes(_loc9_,publishData.outputFyDataBy[_loc14_]);
            }
            UtilsFile.deleteFile;
            var _loc41_:int = 0;
            var _loc40_:* = publishData.outputFyData;
            for(_loc14_ in publishData.outputFyData)
            {
               _loc9_ = new File(_loc31_ + _loc14_);
               UtilsFile.saveString(_loc9_,publishData.outputFyData[_loc14_],"UTF-8");
            }
         }
         if(!PlugInManager.ISBINARY)
         {
            _loc29_ = [];
            _loc21_ = [];
            var _loc43_:int = 0;
            var _loc42_:* = publishData.outputDesc;
            for(_loc14_ in publishData.outputDesc)
            {
               _loc21_.push(_loc14_);
            }
            _loc21_.sort();
            var _loc53_:int = 0;
            var _loc52_:* = _loc21_;
            for each(_loc14_ in _loc21_)
            {
               _loc17_ = publishData.outputDesc[_loc14_];
               if(_loc17_ is XML)
               {
                  trace((_loc17_ as XML).@name);
                  if((_loc17_ as XML).@name == publishData.fileName)
                  {
                     (_loc17_ as XML).@name = publishData.fileNameEtx;
                  }
                  if((_loc17_ as XML).name() == "packageDescription")
                  {
                     _loc2_ = null;
                     _loc2_ = (_loc17_ as XML).resources.elements();
                  }
                  if((_loc17_ as XML).displayList != undefined)
                  {
                     _loc2_ = null;
                     _loc2_ = (_loc17_ as XML).displayList.elements();
                     var _loc47_:int = 0;
                     var _loc46_:* = _loc2_;
                     for each(_loc30_ in _loc2_)
                     {
                        if(_loc30_.name() == "dragonbone")
                        {
                           _loc5_ = false;
                           _loc10_ = null;
                           _loc19_ = publishData.outputDesc["package.xml"];
                           _loc10_ = (_loc19_ as XML).resources.elements();
                           _loc13_ = _loc30_.@src;
                           var _loc45_:int = 0;
                           var _loc44_:* = _loc10_;
                           for each(_loc20_ in _loc10_)
                           {
                              if(_loc20_.name() == "dragonbone" && _loc20_.@id == _loc30_.@src)
                              {
                                 if(_loc20_.@boneName != undefined && _loc20_.@boneName != "")
                                 {
                                    _loc5_ = true;
                                 }
                              }
                           }
                           if(_loc5_)
                           {
                              delete _loc30_.@boneName;
                           }
                           else
                           {
                              _loc30_.@resName = _loc30_.@boneName;
                           }
                        }
                     }
                  }
                  if((_loc17_ as XML).transition != undefined)
                  {
                     _loc2_ = null;
                     _loc2_ = (_loc17_ as XML).transition.elements();
                     var _loc49_:int = 0;
                     var _loc48_:* = _loc2_;
                     for each(_loc30_ in _loc2_)
                     {
                        _loc22_ = _loc30_.@xy;
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
                  if((_loc17_ as XML).frames != undefined)
                  {
                     _loc2_ = null;
                     _loc2_ = (_loc17_ as XML).frames.elements();
                     var _loc51_:int = 0;
                     var _loc50_:* = _loc2_;
                     for each(_loc30_ in _loc2_)
                     {
                        _loc22_ = _loc30_.@rect;
                        _loc30_.@rect = LayaExporter.floor_scaseScale9grid(_loc30_.@rect);
                     }
                  }
                  _loc26_ = (_loc17_ as XML).toXMLString();
               }
               else
               {
                  _loc26_ = String(_loc17_);
               }
               _loc29_.push(_loc14_);
               _loc29_.push("|");
               _loc29_.push("" + _loc26_.length);
               _loc29_.push("|");
               _loc29_.push(_loc26_);
            }
            _loc29_.push("sprites.bytes");
            _loc29_.push("|");
            _loc29_.push("" + publishData.sprites.length);
            _loc29_.push("|");
            _loc29_.push(publishData.sprites);
            if(publishData.hitTestData.length > 0)
            {
               _loc15_ = new Base64Encoder();
               publishData.hitTestData.position = 0;
               _loc8_ = publishData.hitTestData.readUTF();
               _loc15_.encodeBytes(publishData.hitTestData);
               _loc26_ = _loc15_.toString().replace(/[\r\n]/g,"");
               _loc29_.push("hittest.bytes");
               _loc29_.push("|");
               _loc29_.push("" + _loc26_.length);
               _loc29_.push("|");
               _loc29_.push(_loc26_);
            }
            _loc18_ = new ByteArray();
            _loc12_ = _loc29_.join("");
            _loc18_.writeUTFBytes(_loc12_);
            _loc18_.deflate();
            UtilsFile.saveBytes(_loc6_,_loc18_);
         }
         var _loc1_:* = 382.9845;
         var _loc28_:Number = _loc1_ / 2;
         PackagesPanel.PUBLIC_OK = false;
         stepCallback.callOnSuccess();
      }
   }
}

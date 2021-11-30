package fairygui.editor.publish
{
   import fairygui.editor.animation.AniDef;
   import fairygui.editor.animation.AniFrame;
   import fairygui.editor.animation.AniTexture;
   import fairygui.editor.animation.BoneDef;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.ImageTool;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.display.BitmapData;
   import flash.display.PNGEncoderOptions;
   import flash.geom.Matrix;
   import flash.utils.ByteArray;
   
   public class CreateOutput extends PublishStep
   {
       
      
      private var _tasks:BulkTasks;
      
      private var donghuaResCount:int = 0;
      
      private var donghuaSusCount:int = 0;
      
      private var _taskDonghua:Array;
      
      public function CreateOutput()
      {
         _taskDonghua = [];
         super();
      }
      
      override public function run() : void
      {
         var _loc26_:* = null;
         var _loc14_:* = null;
         var _loc27_:* = null;
         var _loc29_:* = null;
         var _loc7_:* = null;
         var _loc28_:Number = NaN;
         var _loc20_:* = null;
         var _loc4_:* = null;
         var _loc23_:EPackageItem = null;
         var _loc9_:String = null;
         var _loc25_:ByteArray = null;
         var _loc10_:String = null;
         var _loc24_:XML = null;
         var _loc16_:EPackageItem = null;
         var _loc1_:AniDef = null;
         var _loc11_:BoneDef = null;
         var _loc15_:int = 0;
         var _loc2_:XML = null;
         var _loc13_:XML = null;
         var _loc8_:int = 0;
         var _loc22_:AniFrame = null;
         var _loc3_:XML = null;
         var _loc17_:AniTexture = null;
         var _loc12_:AtlasOutput = null;
         var _loc18_:XML = null;
         var _loc21_:XML = <packageDescription/>;
         _loc21_.@id = publishData.pkg.id;
         _loc21_.@name = publishData.pkg.name;
         var _loc6_:XML = <resources/>;
         var _loc19_:String = publishData._project.settingsCenter.common.verticalScrollBar;
         var _loc5_:String = publishData._project.settingsCenter.common.horizontalScrollBar;
         if(_loc19_ || _loc5_)
         {
            _loc21_.@scrollBarRes = (!!_loc19_?_loc19_:"") + "," + (!!_loc5_?_loc5_:"");
         }
         donghuaResCount = 0;
         donghuaSusCount = 0;
         var _loc33_:int = 0;
         var _loc32_:* = publishData.items;
         for each(_loc23_ in publishData.items)
         {
            _loc10_ = UtilsStr.getFileExt(_loc23_.fileName);
            if(_loc10_)
            {
               _loc9_ = _loc23_.id + "." + _loc10_;
            }
            else
            {
               _loc9_ = _loc23_.id;
            }
            _loc24_ = _loc23_.serialize(true);
            if(_loc23_.type == "component")
            {
               _loc26_ = publishData.pkg.getItem(_loc23_.id);
               if(_loc26_ && _loc26_.data && _loc26_.data.@customExtention)
               {
                  _loc24_.@customExtention = _loc26_.data.@customExtention;
               }
               if(!publishData.outputDesc[_loc23_.id + ".xml"])
               {
                  _loc24_ = null;
               }
            }
            else if(_loc23_.type == "image")
            {
               if(!publishData.usingAtlas)
               {
                  if(_loc23_.imageInfo.file && UtilsFile.loadBytes(_loc23_.imageInfo.file))
                  {
                     _loc16_ = publishData._fontTextures[_loc23_.id];
                     if(_loc16_)
                     {
                        _loc9_ = _loc16_.id + "." + _loc10_;
                        publishData.outputRes[_loc9_] = _loc25_;
                        _loc24_ = null;
                     }
                     else
                     {
                        publishData.outputRes[_loc9_] = _loc25_;
                        _loc24_.@file = _loc9_;
                     }
                  }
               }
               if(_loc24_.@scale9grid != undefined)
               {
                  _loc24_.@scale9grid = this.scaseScale9grid(_loc24_.@scale9grid);
               }
            }
            else if(_loc23_.type == "movieclip")
            {
               _loc1_ = AniDef(_loc23_.data);
               _loc15_ = _loc1_.frameCount;
               _loc2_ = <movieclip/>;
               _loc2_.@interval = int(1000 / _loc1_.fps * (_loc1_.speed != 0?_loc1_.speed:1));
               if(_loc1_.repeatDelay)
               {
                  _loc2_.@repeatDelay = int(1000 / _loc1_.fps * _loc1_.repeatDelay);
               }
               if(_loc1_.swing)
               {
                  _loc2_.@swing = _loc1_.swing;
               }
               _loc2_.@frameCount = _loc15_;
               _loc13_ = <frames/>;
               _loc2_.appendChild(_loc13_);
               _loc8_ = 0;
               while(_loc8_ < _loc15_)
               {
                  _loc22_ = _loc1_.frameList[_loc8_];
                  _loc3_ = <frame/>;
                  _loc13_.appendChild(_loc3_);
                  _loc3_.@rect = _loc22_.rect.x + "," + _loc22_.rect.y + "," + _loc22_.rect.width + "," + _loc22_.rect.height;
                  if(_loc22_.delay)
                  {
                     _loc3_.@addDelay = int(1000 / _loc1_.fps * _loc22_.delay);
                  }
                  if(_loc22_.textureIndex != -1)
                  {
                     _loc17_ = _loc1_.textureList[_loc22_.textureIndex];
                     if(_loc17_.exportFrame != -1 && _loc17_.exportFrame != _loc8_)
                     {
                        _loc3_.@sprite = _loc17_.exportFrame;
                     }
                  }
                  _loc8_++;
               }
               publishData.outputDesc[_loc23_.id + ".xml"] = _loc2_;
               if(!publishData.usingAtlas)
               {
                  var _loc31_:int = 0;
                  var _loc30_:* = _loc1_.textureList;
                  for each(_loc17_ in _loc1_.textureList)
                  {
                     if(_loc17_.exportFrame != -1 && _loc17_.raw)
                     {
                        publishData.outputRes[_loc23_.id + "_" + _loc17_.exportFrame + ".png"] = _loc17_.raw;
                     }
                  }
               }
            }
            else if(_loc23_.type == "swf" && publishData._project.type != "Flash")
            {
               _loc24_ = null;
            }
            else if(_loc23_.type == "dragonbone")
            {
               _loc14_ = publishData.pkg.getItem(_loc23_.id);
               if(_loc14_ && _loc14_.data && _loc14_.data.boneName)
               {
                  _loc24_.@boneName = _loc14_.data.boneName;
               }
               if(_loc14_ && _loc14_.data && _loc14_.data.armatureName)
               {
                  _loc24_.@armatureName = _loc14_.data.armatureName;
               }
               _loc11_ = BoneDef(_loc23_.data);
               _loc11_.scasleBitmap();
               donghuaResCount = Number(donghuaResCount) + 1;
               _loc27_ = new Callback();
               _loc27_.param = _loc11_;
               this._taskDonghua.push(_loc27_);
               if(_loc11_ && _loc11_.texJson)
               {
                  if(_loc14_ && _loc14_.data)
                  {
                     _loc24_.@boneType = _loc11_.movieTye;
                  }
                  if(_loc11_.movieTye == 1)
                  {
                     publishData.outputFyData[_loc11_.boneName + "_ske" + PlugInManager.fileNameEtx + ".json"] = _loc11_.c_skeJson;
                  }
                  else
                  {
                     publishData.outputFyData[_loc11_.boneName + PlugInManager.fileNameEtx + ".json"] = _loc11_.c_skeJson;
                  }
               }
               if(_loc11_ && _loc11_.skeJson)
               {
                  if(_loc11_.movieTye == 1)
                  {
                     _loc29_ = JSON.parse(_loc11_.c_texJson);
                     _loc29_.imagePath = _loc11_.boneName + "_tex" + PlugInManager.fileNameEtx + ".png";
                     publishData.outputFyData[_loc11_.boneName + "_tex" + PlugInManager.fileNameEtx + ".json"] = JSON.stringify(_loc29_);
                  }
                  else
                  {
                     _loc7_ = _loc11_.c_texJson;
                     _loc7_ = _loc7_.replace(_loc11_.boneName + ".png",_loc11_.boneName + PlugInManager.fileNameEtx + ".png");
                     publishData.outputFyData[_loc11_.boneName + PlugInManager.fileNameEtx + ".atlas"] = _loc7_;
                  }
               }
            }
            else
            {
               _loc25_ = UtilsFile.loadBytes(_loc23_.file);
               if(_loc25_)
               {
                  if(_loc23_.type == "font")
                  {
                     publishData.outputDesc[_loc9_] = _loc25_;
                  }
                  else
                  {
                     publishData.outputRes[_loc9_] = _loc25_;
                  }
                  _loc24_.@file = _loc9_;
               }
               else
               {
                  _loc24_ = null;
               }
            }
            if(_loc24_)
            {
               _loc24_.@size = this.scaseXY(_loc24_.@size);
               if(_loc24_.name() == "atlas")
               {
               }
               _loc6_.appendChild(_loc24_);
            }
         }
         if(publishData.usingAtlas)
         {
            var _loc35_:int = 0;
            var _loc34_:* = publishData.atlasOutput;
            for each(_loc12_ in publishData.atlasOutput)
            {
               if(PlugInManager.FYOUT * _loc12_.width > PlugInManager.RES_SIZE || PlugInManager.FYOUT * _loc12_.height > PlugInManager.RES_SIZE)
               {
                  stepCallback.addMsg("输出的图片尺寸超出了" + PlugInManager.RES_SIZE + "！");
                  stepCallback.callOnFail();
                  return;
               }
               _loc18_ = <atlas/>;
               _loc18_.@id = _loc12_.id;
               _loc18_.@size = Math.floor(PlugInManager.FYOUT * _loc12_.width) + "," + Math.floor(PlugInManager.FYOUT * _loc12_.height);
               _loc18_.@file = _loc12_.fileName;
               _loc6_.appendChild(_loc18_);
               if(_loc12_.data)
               {
                  publishData.outputRes[_loc12_.fileName] = _loc12_.data;
               }
               if(_loc12_.alphaData)
               {
                  publishData.outputRes[UtilsStr.getFileName(_loc12_.fileName) + "!a.png"] = _loc12_.alphaData;
               }
            }
            _loc21_.appendChild(_loc6_);
            publishData.outputDesc["package.xml"] = _loc21_;
            _loc28_ = !!publishData.atlasOutput?publishData.atlasOutput.length:0;
            _loc20_ = [];
            _loc4_ = null;
            var _loc37_:int = 0;
            var _loc36_:* = publishData._spritesInfo;
            for each(_loc4_ in publishData._spritesInfo)
            {
               _loc20_.push(_loc4_.join(" "));
            }
            _loc20_.sort();
            publishData.sprites = "//FairyGUI atlas sprites.\n" + _loc20_.join("\n");
         }
         doTask();
      }
      
      private function doTask() : void
      {
         if(this._taskDonghua.length > 0)
         {
            var callback:Callback = this._taskDonghua.shift();
            if(PlugInManager.COMPRESS)
            {
               callback.success = function():void
               {
                  var _loc3_:* = null;
                  var _loc2_:* = null;
                  var _loc1_:Number = NaN;
                  callback.param.c_texture.raw = ByteArray(callback.result2);
                  if(callback.param && callback.param.texJson)
                  {
                     if(callback.param.movieTye == 1)
                     {
                        publishData.outputFyData[callback.param.boneName + "_ske" + PlugInManager.fileNameEtx + ".json"] = callback.param.c_skeJson;
                     }
                     else
                     {
                        publishData.outputFyData[callback.param.boneName + PlugInManager.fileNameEtx + ".json"] = callback.param.c_skeJson;
                     }
                  }
                  if(callback.param && callback.param.skeJson)
                  {
                     if(callback.param.movieTye == 1)
                     {
                        _loc3_ = JSON.parse(callback.param.c_texJson);
                        _loc3_.imagePath = callback.param.boneName + "_tex" + PlugInManager.fileNameEtx + ".png";
                        publishData.outputFyData[callback.param.boneName + "_tex" + PlugInManager.fileNameEtx + ".json"] = JSON.stringify(_loc3_);
                     }
                     else
                     {
                        _loc2_ = callback.param.c_texJson;
                        _loc2_ = _loc2_.replace(callback.param.boneName + ".png",callback.param.boneName + PlugInManager.fileNameEtx + ".png");
                        publishData.outputFyData[callback.param.boneName + PlugInManager.fileNameEtx + ".atlas"] = _loc2_;
                     }
                  }
                  if(callback.param.movieTye == 1)
                  {
                     if(callback.param && callback.param.texture.raw)
                     {
                        publishData._outputFyDataBy[callback.param.boneName + "_tex" + PlugInManager.fileNameEtx + ".png"] = callback.param.c_texture.raw;
                     }
                  }
                  else if(callback.param && callback.param.texture.bitmapData)
                  {
                     publishData._outputFyDataBy[callback.param.boneName + PlugInManager.fileNameEtx + ".png"] = callback.param.c_texture.raw;
                  }
                  donghuaSusCount = Number(donghuaSusCount) + 1;
                  if(donghuaResCount <= donghuaSusCount)
                  {
                     if(publishData.usingAtlas)
                     {
                        _loc1_ = !!publishData.atlasOutput?publishData.atlasOutput.length:0;
                        if(publishData._hitTestImages.length > 0 && !publishData.exportDescOnly)
                        {
                           this.handleHitTestImages();
                        }
                        else if(_loc1_ > PlugInManager.TuextureCount)
                        {
                           stepCallback.addMsg("发布1024*1024贴图数量不能超过" + PlugInManager.TuextureCount + "张");
                           stepCallback.callOnFail();
                        }
                        else
                        {
                           stepCallback.callOnSuccess();
                        }
                     }
                  }
                  doTask();
               };
               callback.failed = function():void
               {
                  stepCallback.addMsg("发布失败");
                  stepCallback.callOnFail();
               };
               ImageTool.compressBitmapData(callback.param.c_texture.bitmapData,callback,true);
            }
            else
            {
               if(callback.param.movieTye == 1)
               {
                  if(callback.param && callback.param.texture.raw)
                  {
                     publishData._outputFyDataBy[callback.param.boneName + "_tex" + PlugInManager.fileNameEtx + ".png"] = callback.param.c_texture.bitmapData.encode(callback.param.c_texture.bitmapData.rect,new PNGEncoderOptions());
                  }
               }
               else if(callback.param && callback.param.texture.bitmapData)
               {
                  publishData._outputFyDataBy[callback.param.boneName + PlugInManager.fileNameEtx + ".png"] = callback.param.c_texture.bitmapData.encode(callback.param.c_texture.bitmapData.rect,new PNGEncoderOptions());
               }
               donghuaSusCount = Number(donghuaSusCount) + 1;
               if(donghuaResCount <= donghuaSusCount)
               {
                  this.publishAtlas();
               }
               else
               {
                  doTask();
               }
            }
         }
         else
         {
            this.publishAtlas();
         }
      }
      
      private function publishAtlas() : void
      {
         var _loc1_:Number = NaN;
         if(publishData.usingAtlas)
         {
            _loc1_ = !!publishData.atlasOutput?publishData.atlasOutput.length:0;
            if(publishData._hitTestImages.length > 0 && !publishData.exportDescOnly)
            {
               this.handleHitTestImages();
            }
            else if(_loc1_ > PlugInManager.TuextureCount)
            {
               stepCallback.addMsg("发布1024*1024贴图数量不能超过" + PlugInManager.TuextureCount + "张");
               stepCallback.callOnFail();
            }
            else
            {
               stepCallback.callOnSuccess();
            }
         }
         else
         {
            stepCallback.callOnSuccess();
         }
      }
      
      private function scaseXY(param1:String) : String
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = Math.ceil(PlugInManager.FYOUT * int(_loc2_[0])) + "," + Math.ceil(PlugInManager.FYOUT * int(_loc2_[1]));
         return _loc3_;
      }
      
      private function scaseScale9grid(param1:String) : String
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = Math.ceil(PlugInManager.FYOUT * int(_loc2_[0])) + "," + Math.ceil(PlugInManager.FYOUT * int(_loc2_[1])) + "," + Math.ceil(PlugInManager.FYOUT * int(_loc2_[2])) + "," + Math.ceil(PlugInManager.FYOUT * int(_loc2_[3]));
         return _loc3_;
      }
      
      private function handleHitTestImages() : void
      {
         var _loc1_:String = null;
         this._tasks = new BulkTasks(10);
         var _loc3_:int = 0;
         var _loc2_:* = publishData._hitTestImages;
         for each(_loc1_ in publishData._hitTestImages)
         {
            this._tasks.addTask(this.taskHandler,_loc1_);
         }
         this._tasks.start(stepCallback.callOnSuccess);
      }
      
      private function taskHandler() : void
      {
         var _loc2_:String = String(this._tasks.taskData);
         var _loc1_:EPackageItem = publishData.pkg.getItem(_loc2_);
         if(_loc1_)
         {
            publishData.pkg.getImage(_loc1_,this.onLoaded,true);
         }
         else
         {
            stepCallback.addMsg("cannot load hit test image: " + _loc2_);
            this._tasks.finishItem();
         }
      }
      
      private function onLoaded(param1:EPackageItem) : void
      {
         var _loc9_:* = BitmapData(param1.data);
         if(_loc9_ == null)
         {
            this._tasks.finishItem();
            return;
         }
         var _loc7_:BitmapData = new BitmapData(_loc9_.width / 2,_loc9_.height / 2,true,0);
         var _loc8_:Matrix = new Matrix();
         _loc8_.scale(0.5,0.5);
         _loc7_.draw(_loc9_,_loc8_);
         _loc9_ = _loc7_;
         var _loc2_:Vector.<uint> = _loc9_.getVector(_loc9_.rect);
         var _loc3_:int = _loc2_.length;
         publishData._hitTestData.writeUTF(param1.id);
         publishData._hitTestData.writeInt(0);
         publishData._hitTestData.writeInt(_loc9_.width);
         publishData._hitTestData.writeByte(2);
         publishData._hitTestData.writeInt(Math.ceil(_loc3_ / 8));
         _loc9_.dispose();
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if((_loc2_[_loc4_] >> 24 & 255) > 10)
            {
               _loc6_ = _loc6_ + (1 << _loc5_);
            }
            _loc5_++;
            if(_loc5_ == 8)
            {
               publishData._hitTestData.writeByte(_loc6_);
               _loc6_ = 0;
               _loc5_ = 0;
            }
            _loc4_++;
         }
         if(_loc5_ != 0)
         {
            publishData._hitTestData.writeByte(_loc6_);
         }
         this._tasks.finishItem();
      }
   }
}

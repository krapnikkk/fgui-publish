package fairygui.editor.publish
{
   import fairygui.editor.Consts;
   import fairygui.editor.api.ProjectType;
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.gui.FPackageItemType;
   import fairygui.editor.gui.animation.AniDef;
   import fairygui.editor.gui.animation.AniTexture;
   import fairygui.editor.settings.AtlasSettings;
   import fairygui.editor.settings.ImageSettings;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.editor.worker.WorkerClient;
   import fairygui.utils.BulkTasks;
   import fairygui.utils.Callback;
   import fairygui.utils.GTimers;
   import fairygui.utils.ImageTool;
   import fairygui.utils.Utils;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.pack.NodeRect;
   import fairygui.utils.pack.PackSettings;
   import fairygui.utils.pack.Page;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import mx.graphics.codec.JPEGEncoder;
   import mx.graphics.codec.PNGEncoder;
   
   public class §_-60§ extends taskRun
   {
       
      
      private var _compressTasks:BulkTasks;
      
      private var §_-8j§:int;
      
      private var §_-Je§:int;
      
      private var _pages:Vector.<Page>;
      
      private var §_-N3§:AtlasSettings;
      
      public function §_-60§()
      {
         super();
         this.§_-N3§ = new AtlasSettings();
         this._compressTasks = new BulkTasks(1);
      }
      
      override public function run() : void
      {
         if(publishData.atlases.length == 0)
         {
            this.allCompleted();
         }
         else
         {
            this.§_-8j§ = 0;
            this.§_-HL§();
         }
      }
      
      private function allCompleted() : void
      {
         _stepCallback.callOnSuccessImmediately();
      }
      
      private function §_-3i§() : void
      {
         this.§_-8j§++;
         if(this.§_-8j§ >= publishData.atlases.length)
         {
            this.allCompleted();
         }
         else
         {
            this.§_-HL§();
         }
      }
      
      private function §_-HL§() : void
      {
         var _loc2_:FPackageItem = null;
         var _loc5_:NodeRect = null;
         var _loc8_:AniDef = null;
         var _loc9_:int = 0;
         var _loc10_:AniTexture = null;
         var _loc11_:Rectangle = null;
         var _loc1_:AtlasItem = publishData.atlases[this.§_-8j§];
         if(_loc1_.index == -1)
         {
            this.§_-N3§.copyFrom(PublishSettings(publishData.pkg.publishSettings).atlasList[0]);
            this.§_-N3§.packSettings.pot = !_loc1_.npot;
            this.§_-N3§.packSettings.mof = _loc1_.mof;
            if(_loc1_.items[0].type == FPackageItemType.MOVIECLIP)
            {
               this.§_-N3§.packSettings.padding = 1;
               this.§_-N3§.packSettings.duplicatePadding = false;
            }
         }
         else
         {
            this.§_-N3§.copyFrom(PublishSettings(publishData.pkg.publishSettings).atlasList[_loc1_.index]);
         }
         var _loc3_:Vector.<NodeRect> = new Vector.<NodeRect>();
         var _loc4_:int = 0;
         var _loc6_:Boolean = this.§_-N3§.packSettings.rotation && (publishData.project.type == ProjectType.COCOS2DX || publishData.project.type == ProjectType.COCOSCREATOR);
         var _loc7_:* = publishData.project.type == ProjectType.EGRET;
         for each(_loc2_ in _loc1_.items)
         {
            if(_loc2_.type == FPackageItemType.MOVIECLIP)
            {
               _loc8_ = _loc2_.getAnimation();
               if(_loc8_)
               {
                  _loc9_ = 0;
                  for each(_loc10_ in _loc8_.textureList)
                  {
                     if(_loc10_.exportFrame != -1)
                     {
                        _loc11_ = _loc8_.frameList[_loc10_.exportFrame].rect;
                        if(_loc11_.width == 0 && _loc11_.height == 0)
                        {
                           continue;
                        }
                        _loc5_ = new NodeRect();
                        _loc5_.index = _loc4_;
                        _loc5_.subIndex = _loc9_;
                        _loc5_.width = _loc11_.width;
                        _loc5_.height = _loc11_.height;
                        _loc3_.push(_loc5_);
                     }
                     _loc9_++;
                  }
               }
            }
            else if(_loc2_.width > 0 && _loc2_.height > 0)
            {
               _loc5_ = new NodeRect();
               _loc5_.index = _loc4_;
               _loc5_.width = _loc2_.imageInfo.trimmedRect.width;
               _loc5_.height = _loc2_.imageInfo.trimmedRect.height;
               _loc5_.flags = !!_loc2_.imageSettings.duplicatePadding?int(NodeRect.DUPLICATE_PADDING):0;
               if(_loc6_ && _loc2_.getVar("pubInfo.isFontLetter") || _loc7_ && _loc2_.imageSettings && _loc2_.imageSettings.scaleOption == ImageSettings.SCALE_9GRID)
               {
                  _loc5_.flags = _loc5_.flags | NodeRect.NO_ROTATION;
               }
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         if(_loc3_.length == 0)
         {
            GTimers.inst.callLater(this.§_-JL§,new Vector.<Page>());
         }
         else if(_loc3_.length == 1)
         {
            this.§_-PK§(_loc3_[0]);
         }
         else
         {
            this.pack(_loc3_);
         }
      }
      
      private function §_-PK§(param1:NodeRect) : void
      {
         var _loc2_:PackSettings = this.§_-N3§.packSettings;
         var _loc3_:Vector.<Page> = new Vector.<Page>();
         var _loc4_:int = param1.width;
         var _loc5_:int = param1.height;
         var _loc6_:int = _loc2_.padding;
         if(param1.duplicatePadding)
         {
            _loc4_ = _loc4_ + _loc6_;
            _loc5_ = _loc5_ + _loc6_;
         }
         if(_loc2_.pot)
         {
            _loc4_ = Utils.getNextPowerOfTwo(_loc4_);
            _loc5_ = Utils.getNextPowerOfTwo(_loc5_);
         }
         if(_loc2_.square)
         {
            _loc4_ = _loc5_ = Math.max(_loc4_,_loc5_);
         }
         if(param1.duplicatePadding)
         {
            if(!_loc2_.pot && !_loc2_.square)
            {
               _loc4_ = _loc4_ - _loc6_;
               _loc5_ = _loc5_ - _loc6_;
            }
            param1.x = param1.x + Math.floor(_loc6_ / 2);
            param1.y = param1.y + Math.floor(_loc6_ / 2);
         }
         var _loc7_:Page = new Page();
         _loc7_.width = _loc4_;
         _loc7_.height = _loc5_;
         _loc7_.occupancy = 1;
         _loc7_.outputRects.push(param1);
         _loc3_.push(_loc7_);
         GTimers.inst.callLater(this.§_-JL§,_loc3_);
      }
      
      private function §_-JL§(param1:Vector.<Page>) : void
      {
         this._pages = param1;
         if(param1 == null || param1.length > 1 && !this.§_-N3§.packSettings.multiPage)
         {
            _stepCallback.msgs.length = 0;
            _stepCallback.addMsg(UtilsStr.formatString(Consts.strings.text122,this.§_-N3§.packSettings.maxWidth,this.§_-N3§.packSettings.maxHeight));
            _stepCallback.callOnFailImmediately();
            return;
         }
         this.§_-4W§();
      }
      
      private function §_-4W§() : void
      {
         var pi:FPackageItem = null;
         var ao:§_-4E§ = null;
         var page:Page = null;
         var pageIndex:int = 0;
         var maxQuality:int = 0;
         var bmd:BitmapData = null;
         var tmpBmd:BitmapData = null;
         var binBmd:BitmapData = null;
         var binIndex:int = 0;
         var texture:AniTexture = null;
         var rect:NodeRect = null;
         var mcPage:Object = null;
         var mp:* = undefined;
         var tmp:Number = NaN;
         var ai:AtlasItem = publishData.atlases[this.§_-8j§];
         if(this._pages.length == 0)
         {
            this.§_-3i§();
            return;
         }
         if(this._pages.length > 1 && publishData.project.type == ProjectType.UNITY)
         {
            pageIndex = 0;
            mcPage = {};
            for each(page in this._pages)
            {
               for each(rect in page.outputRects)
               {
                  pi = ai.items[rect.index];
                  if(pi.type == FPackageItemType.MOVIECLIP)
                  {
                     mp = mcPage[rect.index];
                     if(mp == undefined)
                     {
                        mcPage[rect.index] = pageIndex;
                     }
                     else if(mp != pageIndex)
                     {
                        _stepCallback.msgs.length = 0;
                        _stepCallback.addMsg(UtilsStr.formatString(Consts.strings.text376,pi.name));
                        _stepCallback.callOnFailImmediately();
                        return;
                     }
                  }
               }
               pageIndex++;
            }
            mcPage = null;
         }
         var rotateMatrix:Matrix = new Matrix();
         var extractAlpha:Boolean = ai.alphaChannel && publishData.extractAlpha;
         var rotationDir:int = publishData.project.type == ProjectType.COCOS2DX || publishData.project.type == ProjectType.COCOSCREATOR || publishData.project.type == ProjectType.EGRET?1:0;
         if(publishData.project.type == ProjectType.UNITY)
         {
            ai.alphaChannel = true;
         }
         pageIndex = 0;
         for each(page in this._pages)
         {
            ao = new §_-4E§();
            publishData.§_-F8§.push(ao);
            binIndex = ai.index;
            if(pageIndex == 0)
            {
               binIndex = ai.index;
               ao.id = ai.id;
               ao.fileName = ai.id + (!!ai.alphaChannel?".png":".jpg");
            }
            else
            {
               binIndex = 100 + this.§_-Je§++;
               ao.id = "atlas" + binIndex;
               ao.fileName = ai.id + "_" + pageIndex + (!!ai.alphaChannel?".png":".jpg");
            }
            ao.width = page.width;
            ao.height = page.height;
            pageIndex++;
            if(page.outputRects.length == 1)
            {
               rect = page.outputRects[0];
               pi = ai.items[0];
               if(ai.items.length == 1 && pi.type == FPackageItemType.IMAGE && ao.width == pi.width && ao.height == pi.height && (pi.imageInfo.format == "png" || publishData.project.type != ProjectType.UNITY) && !extractAlpha)
               {
                  if(!publishData.exportDescOnly)
                  {
                     ao.data = UtilsFile.loadBytes(pi.imageInfo.file);
                  }
                  this.§_-Ot§(pi.§_-e§,ai.index,this._pages[0].outputRects[0],null,null,false);
                  continue;
               }
            }
            binBmd = new BitmapData(page.width,page.height,true,0);
            for each(rect in page.outputRects)
            {
               pi = ai.items[rect.index];
               if(pi.type == FPackageItemType.MOVIECLIP)
               {
                  texture = pi.getAnimation().textureList[rect.subIndex];
                  if(texture.bitmapData)
                  {
                     if(!publishData.exportDescOnly)
                     {
                        if(rect.rotated)
                        {
                           rotateMatrix.identity();
                           if(rotationDir == 0)
                           {
                              rotateMatrix.rotate(-90 * Math.PI / 180);
                              rotateMatrix.translate(rect.x,rect.y + rect.height);
                           }
                           else
                           {
                              rotateMatrix.rotate(90 * Math.PI / 180);
                              rotateMatrix.translate(rect.x + rect.width,rect.y);
                           }
                           binBmd.draw(texture.bitmapData,rotateMatrix);
                        }
                        else
                        {
                           binBmd.copyPixels(texture.bitmapData,new Rectangle(0,0,rect.width,rect.height),new Point(rect.x,rect.y));
                        }
                        if(rect.duplicatePadding)
                        {
                           binBmd.copyPixels(binBmd,new Rectangle(rect.x,rect.y,rect.width,1),new Point(rect.x,rect.y - 1));
                           binBmd.copyPixels(binBmd,new Rectangle(rect.x,rect.y + rect.height - 1,rect.width,1),new Point(rect.x,rect.y + rect.height));
                           binBmd.copyPixels(binBmd,new Rectangle(rect.x,rect.y,1,rect.height),new Point(rect.x - 1,rect.y));
                           binBmd.copyPixels(binBmd,new Rectangle(rect.x + rect.width - 1,rect.y,1,rect.height),new Point(rect.x + rect.width,rect.y));
                        }
                     }
                     if(rect.rotated && rotationDir == 1)
                     {
                        tmp = rect.width;
                        rect.width = rect.height;
                        rect.height = tmp;
                     }
                     this.§_-Ot§(pi.§_-e§ + "_" + texture.exportFrame,binIndex,rect,null,null,rect.rotated);
                  }
               }
               else
               {
                  bmd = pi.image;
                  if(bmd != null)
                  {
                     if(!publishData.exportDescOnly)
                     {
                        if(pi.imageInfo.targetQuality > maxQuality)
                        {
                           maxQuality = pi.imageInfo.targetQuality;
                        }
                        if(rect.rotated)
                        {
                           rotateMatrix.identity();
                           rotateMatrix.translate(-pi.imageInfo.trimmedRect.x,-pi.imageInfo.trimmedRect.y);
                           if(rotationDir == 0)
                           {
                              rotateMatrix.rotate(-90 * Math.PI / 180);
                              rotateMatrix.translate(rect.x,rect.y + rect.height);
                           }
                           else
                           {
                              rotateMatrix.rotate(90 * Math.PI / 180);
                              rotateMatrix.translate(rect.x + rect.width,rect.y);
                           }
                           binBmd.draw(bmd,rotateMatrix);
                        }
                        else
                        {
                           binBmd.copyPixels(bmd,new Rectangle(pi.imageInfo.trimmedRect.x,pi.imageInfo.trimmedRect.y,rect.width,rect.height),new Point(rect.x,rect.y));
                        }
                        if(rect.duplicatePadding)
                        {
                           binBmd.copyPixels(binBmd,new Rectangle(rect.x,rect.y,rect.width,1),new Point(rect.x,rect.y - 1));
                           binBmd.copyPixels(binBmd,new Rectangle(rect.x,rect.y + rect.height - 1,rect.width,1),new Point(rect.x,rect.y + rect.height));
                           binBmd.copyPixels(binBmd,new Rectangle(rect.x,rect.y,1,rect.height),new Point(rect.x - 1,rect.y));
                           binBmd.copyPixels(binBmd,new Rectangle(rect.x + rect.width - 1,rect.y,1,rect.height),new Point(rect.x + rect.width,rect.y));
                        }
                     }
                     if(rect.rotated && rotationDir == 1)
                     {
                        tmp = rect.width;
                        rect.width = rect.height;
                        rect.height = tmp;
                     }
                     this.§_-Ot§(pi.§_-e§,binIndex,rect,pi.imageInfo.trimmedRect.topLeft,new Point(pi.width,pi.height),rect.rotated);
                  }
               }
            }
            if(!publishData.exportDescOnly)
            {
               binBmd.threshold(binBmd,binBmd.rect,new Point(0,0),"<",50331648,0,4278190080,true);
               if(extractAlpha)
               {
                  tmpBmd = new BitmapData(binBmd.width,binBmd.height,false,0);
                  tmpBmd.copyChannel(binBmd,binBmd.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
                  tmpBmd.copyChannel(binBmd,binBmd.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.GREEN);
                  tmpBmd.copyChannel(binBmd,binBmd.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.BLUE);
                  try
                  {
                     ao.§_-8I§ = new PNGEncoder().encode(tmpBmd);
                  }
                  catch(err:Error)
                  {
                     _stepCallback.msgs.length = 0;
                     publishData.project.editor.consoleView.logError(null,err);
                     _stepCallback.addMsg("Create atlas failed");
                     _stepCallback.callOnFailImmediately();
                     return;
                  }
                  tmpBmd.dispose();
                  tmpBmd = null;
               }
               if(!ai.alphaChannel || extractAlpha)
               {
                  tmpBmd = new BitmapData(binBmd.width,binBmd.height,false,0);
                  tmpBmd.copyChannel(binBmd,binBmd.rect,new Point(0,0),BitmapDataChannel.RED,BitmapDataChannel.RED);
                  tmpBmd.copyChannel(binBmd,binBmd.rect,new Point(0,0),BitmapDataChannel.GREEN,BitmapDataChannel.GREEN);
                  tmpBmd.copyChannel(binBmd,binBmd.rect,new Point(0,0),BitmapDataChannel.BLUE,BitmapDataChannel.BLUE);
                  binBmd.dispose();
                  binBmd = tmpBmd;
                  tmpBmd = null;
               }
               if(ai.alphaChannel)
               {
                  if(this.§_-N3§.compression)
                  {
                     this._compressTasks.addTask(this.§_-C0§,[ao,binBmd]);
                  }
                  else
                  {
                     try
                     {
                        ao.data = new PNGEncoder().encode(binBmd);
                     }
                     catch(err:Error)
                     {
                        _stepCallback.msgs.length = 0;
                        publishData.project.editor.consoleView.logError(null,err);
                        _stepCallback.addMsg("Create atlas failed");
                        _stepCallback.callOnFailImmediately();
                        return;
                     }
                     binBmd.dispose();
                     binBmd = null;
                  }
               }
               else
               {
                  if(maxQuality == 0)
                  {
                     maxQuality = 80;
                  }
                  ao.data = new JPEGEncoder(maxQuality).encode(binBmd);
                  binBmd.dispose();
                  binBmd = null;
               }
            }
         }
         if(this._compressTasks.itemCount > 0)
         {
            this._compressTasks.start(this.§_-3i§);
         }
         else
         {
            this.§_-3i§();
         }
      }
      
      private function §_-C0§() : void
      {
         var ao:§_-4E§ = null;
         var callback:Callback = null;
         ao = §_-4E§(this._compressTasks.taskData[0]);
         var binBmd:BitmapData = BitmapData(this._compressTasks.taskData[1]);
         callback = new Callback();
         callback.success = function():void
         {
            BitmapData(callback.result[0]).dispose();
            ao.data = ByteArray(callback.result[1]);
            _compressTasks.finishItem();
         };
         callback.failed = function():void
         {
            _stepCallback.msgs.length = 0;
            _stepCallback.addMsgs(callback.msgs);
            _compressTasks.clear();
            _stepCallback.callOnFailImmediately();
         };
         ImageTool.compressBitmapData(binBmd,callback);
      }
      
      private function §_-Ot§(param1:String, param2:int, param3:NodeRect, param4:Point, param5:Point, param6:Boolean) : void
      {
         var _loc7_:Array = null;
         var _loc9_:Array = null;
         if(publishData.trimImage && param4 != null)
         {
            _loc7_ = [param1,param2,param3.x,param3.y,param3.width,param3.height,!!param6?1:0,param4.x,param4.y,param5.x,param5.y];
         }
         else
         {
            _loc7_ = [param1,param2,param3.x,param3.y,param3.width,param3.height,!!param6?1:0];
         }
         publishData.§_-Fc§.push(_loc7_);
         var _loc8_:FPackageItem = publishData.§_-BD§[param1];
         if(_loc8_)
         {
            _loc9_ = _loc7_.concat();
            _loc9_[0] = _loc8_.id;
            publishData.§_-Fc§.push(_loc9_);
         }
      }
      
      private function pack(param1:Vector.<NodeRect>) : void
      {
         var _loc2_:NodeRect = null;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.shareable = true;
         var _loc4_:int = param1.length;
         _loc3_.writeInt(_loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1[_loc5_];
            _loc3_.writeInt(_loc2_.index);
            _loc3_.writeInt(_loc2_.subIndex);
            _loc3_.writeInt(_loc2_.x);
            _loc3_.writeInt(_loc2_.y);
            _loc3_.writeInt(_loc2_.width);
            _loc3_.writeInt(_loc2_.height);
            _loc3_.writeInt(_loc2_.flags);
            _loc5_++;
         }
         WorkerClient.inst.setSharedProperty("rects",_loc3_);
         WorkerClient.inst.setSharedProperty("settings",this.§_-N3§.packSettings);
         publishData.project.asyncRequest("pack",null,this.§_-A§,this.§_-A§);
      }
      
      private function §_-A§() : void
      {
         var _loc3_:Vector.<Page> = null;
         var _loc4_:int = 0;
         var _loc5_:Page = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:NodeRect = null;
         if(!publishData.project)
         {
            return;
         }
         var _loc1_:ByteArray = WorkerClient.inst.getSharedProperty("rects");
         _loc1_.position = 0;
         var _loc2_:int = _loc1_.readByte();
         if(_loc2_ > 0)
         {
            _loc3_ = new Vector.<Page>();
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = new Page();
               _loc5_.width = _loc1_.readInt();
               _loc5_.height = _loc1_.readInt();
               _loc5_.outputRects = new Vector.<NodeRect>();
               _loc3_.push(_loc5_);
               _loc6_ = _loc1_.readInt();
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc8_ = new NodeRect();
                  _loc8_.index = _loc1_.readInt();
                  _loc8_.subIndex = _loc1_.readInt();
                  _loc8_.x = _loc1_.readInt();
                  _loc8_.y = _loc1_.readInt();
                  _loc8_.width = _loc1_.readInt();
                  _loc8_.height = _loc1_.readInt();
                  _loc8_.flags = _loc1_.readInt();
                  _loc8_.rotated = _loc1_.readByte() == 1;
                  _loc5_.outputRects.push(_loc8_);
                  _loc7_++;
               }
               _loc4_++;
            }
         }
         _loc1_.clear();
         this.§_-JL§(_loc3_);
      }
   }
}

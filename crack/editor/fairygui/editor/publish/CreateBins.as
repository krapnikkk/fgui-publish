package fairygui.editor.publish
{
   import fairygui.editor.Consts;
   import fairygui.editor.animation.AniDef;
   import fairygui.editor.animation.AniFrame;
   import fairygui.editor.animation.AniTexture;
   import fairygui.editor.animation.DecodeSupport;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.pack.NodeRect;
   import fairygui.editor.pack.Page;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.settings.AtlasSettings;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.ImageTool;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.GTimers;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import mx.graphics.codec.JPEGEncoder;
   import mx.graphics.codec.PNGEncoder;
   
   public class CreateBins extends PublishStep
   {
       
      
      private var _loadTasks:BulkTasks;
      
      private var _compressTasks:BulkTasks;
      
      private var _atlasSprites:Array;
      
      private var _packing:Boolean;
      
      private var _packingIndex:int;
      
      private var _additionalAtlasIndex:int;
      
      private var _pages:Vector.<Page>;
      
      private var _atlasSettings:AtlasSettings;
      
      public function CreateBins()
      {
         super();
         this._atlasSettings = new AtlasSettings();
         this._atlasSprites = [];
         this._loadTasks = new BulkTasks(40);
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
            this._packingIndex = 0;
            this.doPack();
         }
      }
      
      private function allCompleted() : void
      {
         if(!publishData.exportDescOnly)
         {
            this._atlasSprites.sort();
            publishData.sprites = "//FairyGUI atlas sprites.\n" + this._atlasSprites.join("\n");
         }
         stepCallback.callOnSuccessImmediately();
      }
      
      private function packNext() : void
      {
         this._packingIndex++;
         if(this._packingIndex >= publishData.atlases.length)
         {
            this.allCompleted();
         }
         else
         {
            this.doPack();
         }
      }
      
      private function doPack() : void
      {
         var _loc8_:EPackageItem = null;
         var _loc1_:NodeRect = null;
         var _loc2_:AniDef = null;
         var _loc5_:int = 0;
         var _loc4_:AniTexture = null;
         var _loc3_:Rectangle = null;
         var _loc9_:AtlasItem = publishData.atlases[this._packingIndex];
         var _loc6_:Vector.<NodeRect> = new Vector.<NodeRect>();
         var _loc7_:int = 0;
         var _loc13_:int = 0;
         var _loc12_:* = _loc9_.items;
         for each(_loc8_ in _loc9_.items)
         {
            if(_loc8_.type == "movieclip")
            {
               _loc2_ = AniDef(_loc8_.data);
               _loc5_ = 0;
               var _loc11_:int = 0;
               var _loc10_:* = _loc2_.textureList;
               for each(_loc4_ in _loc2_.textureList)
               {
                  if(_loc4_.exportFrame != -1)
                  {
                     _loc3_ = _loc2_.frameList[_loc4_.exportFrame].rect;
                     if(!(_loc3_.width == 0 && _loc3_.height == 0))
                     {
                        _loc1_ = new NodeRect();
                        _loc1_.id = _loc7_ * 10000 + _loc5_;
                        _loc1_.width = _loc3_.width * PlugInManager.FYOUT;
                        _loc1_.height = _loc3_.height * PlugInManager.FYOUT;
                        _loc6_.push(_loc1_);
                     }
                     else
                     {
                        continue;
                     }
                  }
                  _loc5_++;
               }
               if(!_loc2_.ready && !_loc2_.queued && !publishData.exportDescOnly)
               {
                  DecodeSupport.inst.add(_loc2_);
               }
            }
            else
            {
               if(_loc8_.width > 0 && _loc8_.height > 0)
               {
                  _loc1_ = new NodeRect();
                  _loc1_.id = _loc7_ * 10000;
                  _loc1_.width = _loc8_.width * PlugInManager.FYOUT;
                  _loc1_.height = _loc8_.height * PlugInManager.FYOUT;
                  _loc6_.push(_loc1_);
               }
               if(!publishData.exportDescOnly)
               {
                  this._loadTasks.addTask(this.doLoad,_loc8_);
               }
            }
            _loc7_++;
         }
         if(!publishData.exportDescOnly)
         {
            this._loadTasks.addTask(this.doLoad2);
            this._loadTasks.start(this.onLoadCompleted);
         }
         this._packing = true;
         if(_loc9_.index == -1)
         {
            this._atlasSettings.copyFrom(publishData.pkg.publishSettings.atlasList[0]);
            if(_loc9_.items[0].imageSetting.atlas == "alone_npot")
            {
               this._atlasSettings.pot = false;
            }
            else
            {
               this._atlasSettings.pot = true;
            }
         }
         else
         {
            this._atlasSettings.copyFrom(publishData.pkg.publishSettings.atlasList[_loc9_.index]);
         }
         publishData._project.binPackManager1.pack(_loc6_,this._atlasSettings,this.onPackCompleted);
      }
      
      private function onPackCompleted(param1:Vector.<Page>) : void
      {
         this._packing = false;
         this._pages = param1;
         if(param1 == null || param1.length > 1 && !this._atlasSettings.multiPage)
         {
            this._loadTasks.clear();
            stepCallback.msgs.length = 0;
            stepCallback.addMsg(UtilsStr.formatString(Consts.g.text122,this._atlasSettings.maxWidth,this._atlasSettings.maxHeight));
            stepCallback.callOnFailImmediately();
            return;
         }
         if(!this._loadTasks.running)
         {
            this.createBin();
         }
      }
      
      private function onLoadCompleted() : void
      {
         if(!this._packing)
         {
            this.createBin();
         }
      }
      
      private function createBin() : void
      {
         var _loc9_:* = null;
         var _loc6_:* = null;
         _loc6_ = null;
         var _loc10_:EPackageItem = null;
         var _loc7_:AtlasOutput = null;
         var _loc12_:int = 0;
         var _loc13_:BitmapData = null;
         var _loc16_:BitmapData = null;
         var _loc14_:* = null;
         var _loc15_:int = 0;
         var _loc2_:AniTexture = null;
         var _loc4_:NodeRect = null;
         var _loc1_:Page = null;
         if(this._pages.length == 0)
         {
            this.packNext();
            return;
         }
         var _loc11_:AtlasItem = publishData.atlases[this._packingIndex];
         var _loc8_:Matrix = new Matrix();
         var _loc3_:Boolean = _loc11_.alphaChannel && publishData.extractAlpha;
         if(publishData._project.type == "Unity")
         {
            _loc11_.alphaChannel = true;
         }
         var _loc5_:int = 0;
         var _loc21_:int = 0;
         var _loc20_:* = this._pages;
         for each(_loc1_ in this._pages)
         {
            _loc7_ = new AtlasOutput();
            publishData.atlasOutput.push(_loc7_);
            _loc15_ = _loc11_.index;
            if(_loc5_ == 0)
            {
               _loc15_ = _loc11_.index;
               _loc7_.id = _loc11_.id;
               _loc7_.fileName = _loc11_.id + (!!_loc11_.alphaChannel?".png":".jpg");
            }
            else
            {
               var _loc17_:Number = this._additionalAtlasIndex;
               this._additionalAtlasIndex++;
               _loc15_ = 100 + _loc17_;
               _loc7_.id = "atlas" + _loc15_;
               _loc7_.fileName = _loc11_.id + "_" + _loc5_ + (!!_loc11_.alphaChannel?".png":".jpg");
            }
            _loc7_.width = _loc1_.width;
            _loc7_.height = _loc1_.height;
            _loc5_++;
            if(!publishData.exportDescOnly)
            {
               if(_loc1_.outputRects.length == 1)
               {
                  _loc4_ = _loc1_.outputRects[0];
                  _loc10_ = _loc11_.items[0];
                  if(_loc11_.items.length == 1 && _loc10_.type == "image" && _loc7_.width == _loc10_.width && _loc7_.height == _loc10_.height && (_loc10_.imageInfo.format == "png" || publishData._project.type != "Unity") && !_loc3_)
                  {
                     _loc7_.data = UtilsFile.loadBytes(_loc10_.imageInfo.file);
                     this.addSprite(_loc10_.id,_loc11_.index,this._pages[0].outputRects[0],false);
                     continue;
                  }
               }
               _loc14_ = new BitmapData(_loc1_.width,_loc1_.height,true,0);
               var _loc19_:int = 0;
               var _loc18_:* = _loc1_.outputRects;
               for each(_loc4_ in _loc1_.outputRects)
               {
                  _loc10_ = _loc11_.items[int(_loc4_.id / 10000)];
                  if(_loc10_.type == "movieclip")
                  {
                     _loc2_ = AniDef(_loc10_.data).textureList[_loc4_.id % 10000];
                     _loc9_ = AniDef(_loc10_.data).frameList[_loc4_.id % 10000];
                     if(_loc2_.bitmapData)
                     {
                        if(_loc4_.rotated)
                        {
                           _loc8_.identity();
                           _loc8_.rotate(-1.5707963267949);
                           _loc8_.translate(_loc4_.x,_loc4_.y + _loc4_.height);
                           _loc14_.draw(_loc2_.bitmapData,_loc8_,null,null,null,true);
                        }
                        else if(PlugInManager.FYOUT != 1)
                        {
                           _loc6_ = new Matrix();
                           _loc6_.scale(PlugInManager.FYOUT,PlugInManager.FYOUT);
                           _loc6_.translate(_loc4_.x,_loc4_.y);
                           _loc14_.draw(_loc2_.bitmapData,_loc6_,null,null,null,true);
                           _loc6_ = null;
                        }
                        else
                        {
                           _loc14_.copyPixels(_loc2_.bitmapData,new Rectangle(0,0,_loc4_.width,_loc4_.height),new Point(_loc4_.x,_loc4_.y));
                        }
                        this.addSprite(_loc10_.id + "_" + _loc2_.exportFrame,_loc15_,_loc4_,_loc4_.rotated);
                     }
                  }
                  else
                  {
                     _loc13_ = BitmapData(_loc10_.data);
                     if(_loc13_ != null)
                     {
                        if(_loc10_.imageInfo.targetQuality > _loc12_)
                        {
                           _loc12_ = _loc10_.imageInfo.targetQuality;
                        }
                        if(_loc4_.rotated)
                        {
                           _loc8_.identity();
                           _loc8_.rotate(-1.5707963267949);
                           _loc8_.translate(_loc4_.x,_loc4_.y + _loc4_.height);
                           _loc14_.draw(_loc13_,_loc8_,null,null,null,true);
                        }
                        else if(PlugInManager.FYOUT != 1)
                        {
                           _loc6_ = new Matrix();
                           _loc6_.scale(PlugInManager.FYOUT,PlugInManager.FYOUT);
                           _loc6_.translate(_loc4_.x,_loc4_.y);
                           _loc14_.draw(_loc13_,_loc6_,null,null,null,true);
                           _loc6_ = null;
                        }
                        else
                        {
                           _loc14_.copyPixels(_loc13_,new Rectangle(0,0,_loc4_.width,_loc4_.height),new Point(_loc4_.x,_loc4_.y));
                        }
                        this.addSprite(_loc10_.id,_loc15_,_loc4_,_loc4_.rotated);
                     }
                  }
               }
               if(_loc3_)
               {
                  _loc16_ = new BitmapData(_loc14_.width,_loc14_.height,false,0);
                  _loc16_.copyChannel(_loc14_,_loc14_.rect,new Point(0,0),8,1);
                  _loc16_.copyChannel(_loc14_,_loc14_.rect,new Point(0,0),8,2);
                  _loc16_.copyChannel(_loc14_,_loc14_.rect,new Point(0,0),8,4);
                  _loc7_.alphaData = new PNGEncoder().encode(_loc16_);
                  _loc16_.dispose();
               }
               if(!_loc11_.alphaChannel || _loc3_)
               {
                  _loc16_ = new BitmapData(_loc14_.width,_loc14_.height,false,0);
                  _loc16_.copyChannel(_loc14_,_loc14_.rect,new Point(0,0),1,1);
                  _loc16_.copyChannel(_loc14_,_loc14_.rect,new Point(0,0),2,2);
                  _loc16_.copyChannel(_loc14_,_loc14_.rect,new Point(0,0),4,4);
                  _loc14_.dispose();
                  _loc14_ = _loc16_;
               }
               if(_loc11_.alphaChannel)
               {
                  if(PlugInManager.COMPRESS)
                  {
                     this._compressTasks.addTask(this.doCompress,[_loc7_,_loc14_]);
                  }
                  else
                  {
                     _loc7_.data = new PNGEncoder().encode(_loc14_);
                  }
               }
               else
               {
                  if(_loc12_ == 0)
                  {
                     _loc12_ = publishData.pkg.jpegQuality;
                  }
                  if(_loc12_ == 0)
                  {
                     _loc12_ = 80;
                  }
                  _loc7_.data = new JPEGEncoder(_loc12_).encode(_loc14_);
                  _loc14_.dispose();
               }
            }
         }
         if(this._compressTasks.itemCount > 0)
         {
            this._compressTasks.start(this.packNext);
         }
         else
         {
            this.packNext();
         }
      }
      
      private function doCompress() : void
      {
         var ao:AtlasOutput = null;
         var callback:Callback = null;
         ao = AtlasOutput(this._compressTasks.taskData[0]);
         var binBmd:BitmapData = BitmapData(this._compressTasks.taskData[1]);
         callback = new Callback();
         callback.success = function():void
         {
            BitmapData(callback.result).dispose();
            ao.data = ByteArray(callback.result2);
            _compressTasks.finishItem();
         };
         callback.failed = function():void
         {
            stepCallback.msgs.length = 0;
            stepCallback.addMsgs(callback.msgs);
            _compressTasks.clear();
            stepCallback.callOnFailImmediately();
         };
         callback.param = ao;
         ImageTool.compressBitmapData(binBmd,callback);
         if(binBmd)
         {
            binBmd.dispose();
         }
         binBmd = null;
      }
      
      private function addSprite(param1:String, param2:int, param3:NodeRect, param4:Boolean) : void
      {
         var _loc5_:String = param2 + " " + param3.x + " " + param3.y + " " + param3.width + " " + param3.height + " " + (!!param4?1:0);
         this._atlasSprites.push(param1 + " " + _loc5_);
         publishData._spritesInfo.push([param1,param2,param3.x,param3.y,param3.width,param3.height,!!param4?1:0]);
         var _loc6_:EPackageItem = publishData._fontTextures[param1];
         if(_loc6_)
         {
            this._atlasSprites.push(_loc6_.id + " " + _loc5_);
            publishData._spritesInfo.push([_loc6_.id,param2,param3.x,param3.y,param3.width,param3.height,!!param4?1:0]);
         }
      }
      
      private function doLoad() : void
      {
         var _loc1_:EPackageItem = EPackageItem(this._loadTasks.taskData);
         publishData.pkg.getImage(_loc1_,this.__loaded);
      }
      
      private function __loaded(param1:Object) : void
      {
         this._loadTasks.finishItem();
      }
      
      private function doLoad2() : void
      {
         if(DecodeSupport.inst.busy)
         {
            GTimers.inst.callLater(this.doLoad2);
         }
         else
         {
            this._loadTasks.finishItem();
         }
      }
   }
}

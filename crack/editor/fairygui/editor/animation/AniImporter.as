package fairygui.editor.animation
{
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.ImageTool;
   import fairygui.editor.utils.RuntimeErrorUtil;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PNGEncoderOptions;
   import flash.filesystem.File;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import net.tautausan.plist.Plist10;
   
   public class AniImporter
   {
       
      
      public function AniImporter()
      {
         super();
      }
      
      public static function importImages(param1:Array, param2:AniDef, param3:Boolean, param4:Callback) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         var i:int = 0;
         var frameDelays:Array = null;
         var frame:AniFrame = null;
         var bt:BulkTasks = null;
         var unionRect:Rectangle = null;
         var file:File = null;
         var ext:String = null;
         var texture:AniTexture = null;
         var ii:ImportTask = null;
         var images:Array = param1;
         var target:AniDef = param2;
         var compressPNG:Boolean = param3;
         var callback:Callback = param4;
         i = 0;
         frameDelays = [];
         var _loc7_:int = 0;
         var _loc6_:* = target.frameList;
         for each(frame in target.frameList)
         {
            i = Number(i) + 1;
            frameDelays[Number(i)] = frame.delay;
         }
         target.reset();
         bt = new BulkTasks();
         unionRect = new Rectangle();
         var _loc9_:int = 0;
         var _loc8_:* = images;
         for each(file in images)
         {
            ext = file.extension.toLowerCase();
            if(!(ext != "png" && ext != "jpg"))
            {
               frame = new AniFrame();
               frame.textureIndex = target.textureList.length;
               target.frameList.push(frame);
               texture = new AniTexture();
               target.textureList.push(texture);
               ii = new ImportTask();
               ii.source = file.url;
               ii.texture = texture;
               ii.frame = frame;
               ii.compressPNG = compressPNG;
               ii.unionRect = unionRect;
               bt.addTask(ii.handle);
            }
         }
         if(bt.itemCount == 0)
         {
            if(callback != null)
            {
               callback.callOnSuccess();
            }
            return;
         }
         bt.start(function():void
         {
            var _loc1_:int = 0;
            i = 0;
            var _loc3_:int = 0;
            var _loc2_:* = target.frameList;
            for each(frame in target.frameList)
            {
               i = Number(i) + 1;
               frame.delay = frameDelays[Number(i)];
               frame.rect.x = frame.rect.x + unionRect.width / 2;
               frame.rect.y = frame.rect.y + unionRect.height / 2;
            }
            target.boundsRect = unionRect;
            i = 0;
            _loc1_ = target.textureList.length;
            i = 0;
            while(i < _loc1_)
            {
               if(target.textureList[i].bitmapData == null)
               {
                  var _loc5_:int = 0;
                  var _loc4_:* = target.frameList;
                  for each(frame in target.frameList)
                  {
                     if(frame.textureIndex == i)
                     {
                        frame.textureIndex = -1;
                     }
                  }
               }
               i = Number(i) + 1;
            }
            target.setLoaded();
            target.setReady();
            if(callback != null)
            {
               callback.addMsgs(bt.errorMsgs);
               callback.callOnSuccessImmediately();
            }
         });
      }
      
      private static function dictToArray(param1:Object) : Array
      {
         var _loc3_:* = null;
         var _loc4_:Array = null;
         var _loc2_:Object = null;
         var _loc5_:Array = [];
         var _loc7_:int = 0;
         var _loc6_:* = param1;
         for(_loc3_ in param1)
         {
            _loc5_.push(_loc3_);
         }
         _loc5_.sort();
         _loc4_ = [];
         var _loc9_:int = 0;
         var _loc8_:* = _loc5_;
         for each(_loc3_ in _loc5_)
         {
            _loc2_ = param1[_loc3_];
            _loc2_.filename = _loc3_;
            _loc4_.push(_loc2_);
         }
         return _loc4_;
      }
      
      private static function splitValue(param1:String) : Array
      {
         return param1.replace(/[{}]/g,"").split(",");
      }
      
      public static function importSpriteSheet(param1:File, param2:AniDef, param3:Boolean, param4:Callback) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         param4 = param4;
         var path:String = null;
         var desc:String = null;
         var imageFile:File = null;
         var descFile:File = param1;
         var target:AniDef = param2;
         var compressPNG:Boolean = param3;
         var callback:Callback = param4;
         path = descFile.nativePath;
         desc = UtilsFile.loadString(descFile);
         imageFile = new File(UtilsStr.removeFileExt(path) + ".png");
         EasyLoader.load(imageFile.url,null,function(param1:LoaderExt):void
         {
            param1 = param1;
            var allFrames:Array = null;
            var frame:AniFrame = null;
            var texture:AniTexture = null;
            var compressTask:Function = null;
            var sourceFrame:Object = null;
            var finish:Function = null;
            var ext:String = null;
            var dict:Object = null;
            var xml:XML = null;
            var col:Object = null;
            var cxml:XML = null;
            var plist:Plist10 = null;
            var arr1:Array = null;
            var arr2:Array = null;
            var dd:Object = null;
            var ii:String = null;
            var frameName:String = null;
            var key:String = null;
            var imageIndex:* = undefined;
            var mat:Matrix = null;
            var l:LoaderExt = param1;
            if(l.content == null)
            {
               callback.addMsg(imageFile.nativePath + " not found!");
               callback.callOnFail();
               return;
            }
            var atlas:BitmapData = Bitmap(l.content).bitmapData;
            try
            {
               ext = UtilsStr.getFileExt(path);
               if(ext == "eas" || ext == "json")
               {
                  dict = JSON.parse(desc).frames;
                  if(dict is Array)
                  {
                     allFrames = dict as Array;
                  }
                  else
                  {
                     allFrames = dictToArray(dict);
                  }
               }
               else if(ext == "xml")
               {
                  xml = new XML(desc);
                  col = xml.SubTexture;
                  allFrames = [];
                  var _loc4_:* = col;
                  for each(cxml in col)
                  {
                     allFrames.push({
                        "filename":cxml.@name,
                        "frame":{
                           "x":cxml.@x,
                           "y":cxml.@y,
                           "w":cxml.@width,
                           "h":cxml.@height
                        },
                        "spriteSourceSize":{
                           "x":cxml.@frameX,
                           "y":cxml.@frameY
                        }
                     });
                  }
               }
               else if(ext == "plist")
               {
                  allFrames = [];
                  plist = new Plist10();
                  plist.parse(desc);
                  dict = plist.root.frames;
                  if(dict != null)
                  {
                     var _loc7_:int = 0;
                     var _loc6_:* = dict.keys;
                     for each(ii in dict.keys)
                     {
                        dd = dict[ii];
                        if(dd.frame)
                        {
                           arr1 = splitValue(dd.frame);
                           if(dd.sourceColorRect)
                           {
                              arr2 = splitValue(dd.sourceColorRect);
                           }
                           else
                           {
                              arr2 = splitValue(dd.offset);
                           }
                           allFrames.push({
                              "frame":{
                                 "x":parseInt(arr1[0]),
                                 "y":parseInt(arr1[1]),
                                 "w":parseInt(arr1[2]),
                                 "h":parseInt(arr1[3])
                              },
                              "rotated":dd.rotated.object,
                              "spriteSourceSize":{
                                 "x":parseInt(arr2[0]),
                                 "y":parseInt(arr2[1])
                              }
                           });
                        }
                        else if(dd.textureRect)
                        {
                           arr1 = splitValue(dd.textureRect);
                           arr2 = splitValue(dd.spriteOffset);
                           allFrames.push({
                              "frame":{
                                 "x":parseInt(arr1[0]),
                                 "y":parseInt(arr1[1]),
                                 "w":parseInt(arr1[2]),
                                 "h":parseInt(arr1[3])
                              },
                              "rotated":dd.rotated.object,
                              "spriteSourceSize":{
                                 "x":parseInt(arr2[0]),
                                 "y":parseInt(arr2[1])
                              }
                           });
                        }
                        else if(dd.x)
                        {
                           allFrames.push({
                              "frame":{
                                 "x":dd.x.object,
                                 "y":dd.y.object,
                                 "w":dd.width.object,
                                 "h":dd.height.object
                              },
                              "rotated":(!!dd.textureRotated?dd.textureRotated.object:dd.rotated.object),
                              "spriteSourceSize":{
                                 "x":-dd.width.object / 2 + dd.offsetX.object,
                                 "y":-dd.height.object / 2 + dd.offsetY.object
                              }
                           });
                        }
                     }
                  }
               }
            }
            catch(err:Error)
            {
               callback.addMsg(RuntimeErrorUtil.toString(err));
               callback.callOnFail();
               return;
            }
            target.reset();
            var layerIndex:int = 0;
            var textures:Object = {};
            var bt:BulkTasks = new BulkTasks();
            if(compressPNG)
            {
               compressTask = function(param1:BulkTasks):void
               {
                  param1 = param1;
                  var texture:AniTexture = null;
                  var bt:BulkTasks = param1;
                  texture = AniTexture(bt.taskData);
                  var callback2:Callback = new Callback();
                  callback2.success = function(param1:Callback):void
                  {
                     texture.bitmapData = BitmapData(param1.result);
                     texture.raw = ByteArray(param1.result2);
                     bt.finishItem();
                  };
                  callback2.failed = function(param1:Callback):void
                  {
                     bt.addErrorMsgs(param1.msgs);
                     texture.raw = null;
                     texture.bitmapData = null;
                     bt.finishItem();
                  };
                  ImageTool.compressBitmapData(texture.bitmapData,callback2);
                  texture.bitmapData.dispose();
               };
            }
            var _loc9_:int = 0;
            var _loc8_:* = allFrames;
            for each(sourceFrame in allFrames)
            {
               frameName = sourceFrame.filename;
               frame = new AniFrame();
               target.frameList.push(frame);
               frame.rect = new Rectangle();
               frame.rect.x = sourceFrame.spriteSourceSize.x;
               frame.rect.y = sourceFrame.spriteSourceSize.y;
               frame.rect.width = sourceFrame.frame.w;
               frame.rect.height = sourceFrame.frame.h;
               if(frame.rect.width == 0 || frame.rect.height == 0)
               {
                  frame.textureIndex = -1;
               }
               else
               {
                  key = sourceFrame.frame.x + "," + sourceFrame.frame.y + "," + sourceFrame.frame.w + "," + sourceFrame.frame.h;
                  imageIndex = textures[key];
                  if(imageIndex != undefined)
                  {
                     frame.textureIndex = imageIndex;
                  }
                  else
                  {
                     frame.textureIndex = target.textureList.length;
                     textures[key] = frame.textureIndex;
                     texture = new AniTexture();
                     target.textureList.push(texture);
                     texture.bitmapData = new BitmapData(frame.rect.width,frame.rect.height,true,0);
                     if(sourceFrame.rotated)
                     {
                        mat = new Matrix();
                        mat.rotate(-1.5707963267949);
                        mat.translate(-sourceFrame.frame.y,sourceFrame.frame.x + frame.rect.height);
                        texture.bitmapData.draw(atlas,mat,null,null,new Rectangle(0,0,frame.rect.width,frame.rect.height),true);
                     }
                     else
                     {
                        texture.bitmapData.copyPixels(atlas,new Rectangle(sourceFrame.frame.x,sourceFrame.frame.y,frame.rect.width,frame.rect.height),new Point(0,0));
                     }
                     if(compressPNG)
                     {
                        bt.addTask(compressTask,texture);
                     }
                     else
                     {
                        texture.raw = texture.bitmapData.encode(texture.bitmapData.rect,new PNGEncoderOptions());
                     }
                  }
               }
            }
            finish = function():void
            {
               target.speed = 1;
               target.repeatDelay = 0;
               target.swing = false;
               target.calculateBoundsRect();
               target.setLoaded();
               target.setReady();
               if(callback != null)
               {
                  callback.callOnSuccessImmediately();
               }
            };
            if(compressPNG)
            {
               bt.start(finish);
            }
            else
            {
               finish();
            }
         });
      }
   }
}

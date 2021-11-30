package fairygui.editor.gui.animation
{
   import fairygui.utils.BulkTasks;
   import fairygui.utils.Callback;
   import fairygui.utils.ImageTool;
   import fairygui.utils.RuntimeErrorUtil;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   import fairygui.utils.loader.EasyLoader;
   import fairygui.utils.loader.LoaderExt;
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
      
      public static function importImages(param1:Array, param2:Boolean, param3:Callback) : void
      {
         var i:int = 0;
         var target:AniDef = null;
         var bt:BulkTasks = null;
         var unionRect:Rectangle = null;
         var file:File = null;
         var ext:String = null;
         var frame:AniFrame = null;
         var texture:AniTexture = null;
         var ii:ImportTask = null;
         var images:Array = param1;
         var compressPNG:Boolean = param2;
         var callback:Callback = param3;
         i = 0;
         target = new AniDef();
         bt = new BulkTasks();
         unionRect = new Rectangle();
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
            for each(frame in target.frameList)
            {
               frame.rect.x = frame.rect.x + unionRect.width / 2;
               frame.rect.y = frame.rect.y + unionRect.height / 2;
            }
            target.boundsRect = unionRect;
            target.setLoaded();
            target.setReady();
            i = 0;
            _loc1_ = target.textureList.length;
            i = 0;
            while(i < _loc1_)
            {
               if(target.textureList[i].bitmapData == null)
               {
                  for each(frame in target.frameList)
                  {
                     if(frame.textureIndex == i)
                     {
                        frame.textureIndex = -1;
                     }
                  }
               }
               i++;
            }
            if(callback != null)
            {
               callback.addMsgs(bt.errorMsgs);
               callback.result = target;
               callback.callOnSuccessImmediately();
            }
         });
      }
      
      private static function dictToArray(param1:Object) : Array
      {
         var _loc3_:* = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         _loc2_.sort();
         _loc4_ = [];
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = param1[_loc3_];
            _loc5_.filename = _loc3_;
            _loc4_.push(_loc5_);
         }
         return _loc4_;
      }
      
      private static function splitValue(param1:String) : Array
      {
         return param1.replace(/[{}]/g,"").split(",");
      }
      
      public static function importSpriteSheet(param1:File, param2:Boolean, param3:Callback) : void
      {
         var target:AniDef = null;
         var path:String = null;
         var desc:String = null;
         var imageFile:File = null;
         var descFile:File = param1;
         var compressPNG:Boolean = param2;
         var callback:Callback = param3;
         target = new AniDef();
         path = descFile.nativePath;
         desc = UtilsFile.loadString(descFile);
         imageFile = new File(UtilsStr.removeFileExt(path) + ".png");
         EasyLoader.load(imageFile.url,null,function(param1:LoaderExt):void
         {
            var allFrames:Array = null;
            var frame:AniFrame = null;
            var texture:AniTexture = null;
            var compressTask:Function = null;
            var sourceFrame:Object = null;
            var finish:Function = null;
            var ext:String = null;
            var dict:Object = null;
            var xml:XData = null;
            var it:XDataEnumerator = null;
            var cxml:XData = null;
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
                  xml = XData.parse(desc);
                  it = xml.getEnumerator("SubTexture");
                  allFrames = [];
                  while(it.moveNext())
                  {
                     cxml = it.current;
                     allFrames.push({
                        "filename":cxml.getAttribute("name",""),
                        "frame":{
                           "x":cxml.getAttribute("x"),
                           "y":cxml.getAttribute("y"),
                           "w":cxml.getAttribute("width"),
                           "h":cxml.getAttribute("height")
                        },
                        "spriteSourceSize":{
                           "x":cxml.getAttribute("frameX"),
                           "y":cxml.getAttribute("frameY")
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
                              "rotated":(!!dd.rotated?dd.rotated.object:false),
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
                              "rotated":(!!dd.rotated?dd.rotated.object:false),
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
                              "rotated":(!!dd.textureRotated?dd.textureRotated.object:!!dd.rotated?dd.rotated.object:false),
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
            var layerIndex:int = 0;
            var textures:Object = {};
            var bt:BulkTasks = new BulkTasks();
            if(compressPNG)
            {
               compressTask = function(param1:BulkTasks):void
               {
                  var texture:AniTexture = null;
                  var bt:BulkTasks = param1;
                  texture = AniTexture(bt.taskData);
                  var callback2:Callback = new Callback();
                  callback2.success = function(param1:Callback):void
                  {
                     texture.bitmapData = BitmapData(param1.result[0]);
                     texture.raw = ByteArray(param1.result[1]);
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
                        mat.rotate(-Math.PI / 2);
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
                  callback.result = target;
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

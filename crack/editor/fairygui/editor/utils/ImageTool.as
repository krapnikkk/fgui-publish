package fairygui.editor.utils
{
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import flash.desktop.NativeProcess;
   import flash.desktop.NativeProcessStartupInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PNGEncoderOptions;
   import flash.events.NativeProcessExitEvent;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import mx.graphics.codec.JPEGEncoder;
   import mx.graphics.codec.PNGEncoder;
   
   public class ImageTool
   {
      
      public static var TOOL_PATH:String = "pngquant" + File.separator + "pngquant";
      
      public static var APP_DIRECTORY:File;
      
      private static var _toolExe:File;
       
      
      public function ImageTool()
      {
         super();
      }
      
      private static function get toolExe() : File
      {
         if(_toolExe != null)
         {
            return _toolExe;
         }
         if(APP_DIRECTORY == null)
         {
            APP_DIRECTORY = File.applicationDirectory;
         }
         var _loc2_:* = TOOL_PATH;
         var _loc1_:* = Capabilities.os.toLowerCase().indexOf("mac") != -1;
         if(!_loc1_)
         {
            _loc2_ = _loc2_ + ".exe";
         }
         _toolExe = APP_DIRECTORY.resolvePath(_loc2_);
         if(!_toolExe.exists)
         {
            _loc2_ = "tools" + File.separator + _loc2_;
            _toolExe = APP_DIRECTORY.resolvePath(_loc2_);
         }
         return _toolExe;
      }
      
      public static function get toolInstalled() : Boolean
      {
         return toolExe.exists;
      }
      
      public static function compressFile(param1:File, param2:File, param3:Callback) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var si:NativeProcessStartupInfo = null;
         var args:Vector.<String> = null;
         var tempFile:File = null;
         var process:NativeProcess = null;
         var output:String = null;
         var pngFile:File = param1;
         var targetFile:File = param2;
         var callback:Callback = param3;
         if(!toolInstalled)
         {
            callback.addMsg("Image tool not available.");
            callback.callOnFail();
            return;
         }
         try
         {
            si = new NativeProcessStartupInfo();
            si.executable = toolExe;
            args = new Vector.<String>();
            args.push("--force");
            args.push("--speed");
            args.push("1");
            args.push("--ext");
            args.push("~q.png");
            tempFile = File.createTempFile();
            UtilsFile.copyFile(pngFile,tempFile);
            args.push(tempFile.nativePath);
            trace(tempFile.nativePath);
            si.arguments = args;
            process = new NativeProcess();
            output = "";
            process.addEventListener("standardOutputData",function(param1:ProgressEvent):void
            {
               output = output + process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
            });
            process.addEventListener("standardErrorData",function(param1:ProgressEvent):void
            {
               output = output + process.standardError.readUTFBytes(process.standardError.bytesAvailable);
            });
            process.addEventListener("exit",function(param1:NativeProcessExitEvent):void
            {
               var _loc2_:File = null;
               if(param1.exitCode == 0)
               {
                  _loc2_ = new File(UtilsStr.removeFileExt(tempFile.nativePath) + "~q.png");
                  if(!_loc2_.exists)
                  {
                     _loc2_ = new File(tempFile.nativePath + "~q.png");
                  }
                  _loc2_.copyTo(targetFile,true);
                  try
                  {
                     _loc2_.deleteFile();
                     tempFile.deleteFile();
                  }
                  catch(err:Error)
                  {
                  }
                  callback.callOnSuccessImmediately();
               }
               else
               {
                  if(!output)
                  {
                     output = "exit:" + param1.exitCode;
                  }
                  callback.addMsg(output);
                  callback.callOnFailImmediately();
               }
            });
            process.start(si);
            return;
         }
         catch(err:Error)
         {
            callback.addMsg(RuntimeErrorUtil.toString(err));
            callback.callOnFail();
            return;
         }
      }
      
      public static function compressBitmapData(param1:BitmapData, param2:Callback, param3:Boolean = true) : void
      {
         param1 = param1;
         param2 = param2;
         isDispose = param3;
         var ba:ByteArray = null;
         var tempFile:File = null;
         var onLoaded:Function = null;
         var callback2:Callback = null;
         var bmd:BitmapData = param1;
         var callback:Callback = param2;
         var isPNG:Boolean = bmd.transparent;
         if(isPNG)
         {
            ba = new PNGEncoder().encode(bmd);
         }
         else
         {
            ba = new JPEGEncoder(80).encode(bmd);
         }
         tempFile = File.createTempFile();
         UtilsFile.saveBytes(tempFile,ba);
         if(isDispose)
         {
            bmd.dispose();
         }
         onLoaded = function(param1:LoaderExt):void
         {
            var _loc3_:BitmapData = Bitmap(param1.content).bitmapData;
            var _loc2_:ByteArray = UtilsFile.loadBytes(tempFile);
            try
            {
               tempFile.deleteFile();
            }
            catch(err:Error)
            {
            }
            if(_loc3_ != null)
            {
               callback.result = _loc3_;
               callback.result2 = _loc2_;
               callback.callOnSuccessImmediately();
            }
            else
            {
               callback.addMsg(param1.error);
               callback.callOnFailImmediately();
            }
         };
         if(isPNG)
         {
            callback2 = new Callback();
            callback2.success = function():void
            {
               EasyLoader.load(tempFile.url,{"type":"image"},onLoaded);
            };
            callback2.failed = function():void
            {
               callback.addMsgs(callback2.msgs);
               callback.callOnFailImmediately();
            };
            compressFile(tempFile,tempFile,callback2);
         }
         else
         {
            EasyLoader.load(tempFile.url,{"type":"image"},onLoaded);
         }
      }
      
      public static function cropImage(param1:File, param2:File, param3:Callback) : void
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var pngFile:File = param1;
         var targetFile:File = param2;
         var callback:Callback = param3;
         EasyLoader.load(pngFile.url,{"type":"image"},function(param1:LoaderExt):void
         {
            var _loc3_:Rectangle = null;
            var _loc4_:BitmapData = null;
            var _loc2_:ByteArray = null;
            if(!param1.content)
            {
               callback.addMsg(param1.error);
               callback.callOnFailImmediately();
               return;
            }
            var _loc5_:* = Bitmap(param1.content).bitmapData;
            if(_loc5_.transparent)
            {
               _loc3_ = _loc5_.getColorBoundsRect(4278190080,0,false);
               if(!_loc3_.isEmpty() && !_loc3_.equals(_loc5_.rect))
               {
                  _loc4_ = new BitmapData(_loc3_.width,_loc3_.height,true,0);
                  _loc4_.copyPixels(_loc5_,_loc3_,new Point(0,0));
                  _loc5_.dispose();
                  _loc5_ = _loc4_;
                  _loc2_ = _loc5_.encode(_loc5_.rect,new PNGEncoderOptions());
                  UtilsFile.saveBytes(targetFile,_loc2_);
                  callback.callOnSuccessImmediately();
                  return;
               }
            }
            UtilsFile.copyFile(pngFile,targetFile);
            callback.callOnSuccessImmediately();
         });
      }
   }
}

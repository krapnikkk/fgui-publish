package fairygui.utils
{
   import fairygui.utils.loader.EasyLoader;
   import fairygui.utils.loader.LoaderExt;
   import flash.desktop.NativeProcess;
   import flash.desktop.NativeProcessStartupInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.JPEGEncoderOptions;
   import flash.display.PNGEncoderOptions;
   import flash.events.NativeProcessExitEvent;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class ImageTool
   {
      
      public static var TOOL_PATH:String = "pngquant" + File.separator + "pngquant";
      
      public static var TOOL_PATH_MAGICK:String = "ImageMagick" + File.separator + "magick";
      
      public static var APP_DIRECTORY:File;
      
      private static var _mac = undefined;
      
      private static var _runningTasks:Dictionary = new Dictionary();
      
      private static var _toolExe:File;
      
      private static var _magickExe:File;
       
      
      public function ImageTool()
      {
         super();
      }
      
      public static function get isMac() : Boolean
      {
         if(_mac == undefined)
         {
            _mac = Capabilities.os.toLowerCase().indexOf("mac") != -1;
         }
         return _mac;
      }
      
      public static function get toolExe() : File
      {
         if(_toolExe != null)
         {
            return _toolExe;
         }
         if(APP_DIRECTORY == null)
         {
            APP_DIRECTORY = File.applicationDirectory;
         }
         var _loc1_:* = TOOL_PATH;
         if(!isMac)
         {
            _loc1_ = _loc1_ + ".exe";
         }
         _toolExe = APP_DIRECTORY.resolvePath(_loc1_);
         if(!_toolExe.exists)
         {
            _loc1_ = "tools" + File.separator + _loc1_;
            _toolExe = APP_DIRECTORY.resolvePath(_loc1_);
         }
         return _toolExe;
      }
      
      public static function get magickExe() : File
      {
         if(_magickExe != null)
         {
            return _magickExe;
         }
         if(APP_DIRECTORY == null)
         {
            APP_DIRECTORY = File.applicationDirectory;
         }
         var _loc1_:* = TOOL_PATH_MAGICK;
         if(isMac)
         {
            _loc1_ = _loc1_ + ".sh";
         }
         else
         {
            _loc1_ = _loc1_ + ".exe";
         }
         _magickExe = APP_DIRECTORY.resolvePath(_loc1_);
         if(!_magickExe.exists)
         {
            _loc1_ = "tools" + File.separator + _loc1_;
            _magickExe = APP_DIRECTORY.resolvePath(_loc1_);
         }
         return _magickExe;
      }
      
      public static function compressFile(param1:File, param2:File, param3:Callback) : void
      {
         var si:NativeProcessStartupInfo = null;
         var args:Vector.<String> = null;
         var tempFile:File = null;
         var process:NativeProcess = null;
         var output:String = null;
         var pngFile:File = param1;
         var targetFile:File = param2;
         var callback:Callback = param3;
         if(!toolExe.exists)
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
            args.push("--ext");
            args.push("~q.png");
            tempFile = File.createTempFile();
            UtilsFile.copyFile(pngFile,tempFile);
            args.push(tempFile.nativePath);
            si.arguments = args;
            process = new NativeProcess();
            _runningTasks[process] = true;
            output = "";
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,function(param1:ProgressEvent):void
            {
               output = output + process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
            });
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,function(param1:ProgressEvent):void
            {
               output = output + process.standardError.readUTFBytes(process.standardError.bytesAvailable);
            });
            process.addEventListener(NativeProcessExitEvent.EXIT,function(param1:NativeProcessExitEvent):void
            {
               var _loc2_:File = null;
               delete _runningTasks[process];
               if(param1.exitCode == 0)
               {
                  _loc2_ = new File(UtilsStr.removeFileExt(tempFile.nativePath) + "~q.png");
                  if(!_loc2_.exists)
                  {
                     _loc2_ = new File(tempFile.nativePath + "~q.png");
                  }
                  if(_loc2_.size > pngFile.size)
                  {
                     UtilsFile.copyFile(pngFile,targetFile);
                  }
                  else
                  {
                     UtilsFile.copyFile(_loc2_,targetFile);
                  }
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
            callback.addMsg(err.message);
            callback.callOnFail();
            return;
         }
      }
      
      public static function compressBitmapData(param1:BitmapData, param2:Callback) : void
      {
         var ba:ByteArray = null;
         var tempFile:File = null;
         var onLoaded:Function = null;
         var callback2:Callback = null;
         var bmd:BitmapData = param1;
         var callback:Callback = param2;
         var isPNG:Boolean = bmd.transparent;
         if(isPNG)
         {
            ba = bmd.encode(bmd.rect,new PNGEncoderOptions());
         }
         else
         {
            ba = bmd.encode(bmd.rect,new JPEGEncoderOptions(80));
         }
         tempFile = File.createTempFile();
         UtilsFile.saveBytes(tempFile,ba);
         onLoaded = function(param1:LoaderExt):void
         {
            var _loc2_:BitmapData = Bitmap(param1.content).bitmapData;
            var _loc3_:ByteArray = UtilsFile.loadBytes(tempFile);
            try
            {
               tempFile.deleteFile();
            }
            catch(err:Error)
            {
            }
            if(_loc2_ != null)
            {
               callback.result = [_loc2_,_loc3_];
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
         var pngFile:File = param1;
         var targetFile:File = param2;
         var callback:Callback = param3;
         EasyLoader.load(pngFile.url,{"type":"image"},function(param1:LoaderExt):void
         {
            var _loc3_:Rectangle = null;
            var _loc4_:BitmapData = null;
            var _loc5_:ByteArray = null;
            if(!param1.content)
            {
               callback.addMsg(param1.error);
               callback.callOnFailImmediately();
               return;
            }
            var _loc2_:BitmapData = Bitmap(param1.content).bitmapData;
            if(_loc2_.transparent)
            {
               _loc3_ = _loc2_.getColorBoundsRect(4278190080,0,false);
               if(!_loc3_.isEmpty() && !_loc3_.equals(_loc2_.rect))
               {
                  _loc4_ = new BitmapData(_loc3_.width,_loc3_.height,true,0);
                  _loc4_.copyPixels(_loc2_,_loc3_,new Point(0,0));
                  _loc2_.dispose();
                  _loc2_ = _loc4_;
                  _loc5_ = _loc2_.encode(_loc2_.rect,new PNGEncoderOptions());
                  UtilsFile.saveBytes(targetFile,_loc5_);
                  callback.callOnSuccessImmediately();
                  return;
               }
            }
            UtilsFile.copyFile(pngFile,targetFile);
            callback.callOnSuccessImmediately();
         });
      }
      
      public static function magick(param1:Vector.<String>, param2:Callback) : void
      {
         var si:NativeProcessStartupInfo = null;
         var process:NativeProcess = null;
         var output:String = null;
         var args:Vector.<String> = param1;
         var callback:Callback = param2;
         if(!magickExe.exists)
         {
            callback.addMsg("Magick tool not available.");
            callback.callOnFail();
            return;
         }
         try
         {
            si = new NativeProcessStartupInfo();
            if(isMac)
            {
               args.insertAt(0,"magick.sh");
               si.executable = new File("/bin/bash");
               si.workingDirectory = magickExe.parent;
            }
            else
            {
               si.executable = magickExe;
            }
            si.arguments = args;
            process = new NativeProcess();
            _runningTasks[process] = true;
            output = "";
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,function(param1:ProgressEvent):void
            {
               output = output + process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
            });
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,function(param1:ProgressEvent):void
            {
               output = output + process.standardError.readUTFBytes(process.standardError.bytesAvailable);
            });
            process.addEventListener(NativeProcessExitEvent.EXIT,function(param1:NativeProcessExitEvent):void
            {
               delete _runningTasks[process];
               if(param1.exitCode == 0)
               {
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
            callback.addMsg(err.message);
            callback.callOnFail();
            return;
         }
      }
   }
}

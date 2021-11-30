package fairygui.editor.utils
{
   import fairygui.editor.EditorWindow;
   import flash.desktop.NativeApplication;
   import flash.desktop.NativeProcess;
   import flash.desktop.NativeProcessStartupInfo;
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   import flash.net.FileFilter;
   import flash.net.FileReference;
   import flash.net.FileReferenceList;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   
   public class UploadPPT
   {
      
      private static var _instance:UploadPPT;
       
      
      public var _editorWindow:EditorWindow;
      
      private var fileRefs:FileReferenceList;
      
      private var selectedFiles:Array;
      
      private var defaultRequestUrl:String = "http://118.126.91.194/subjectphp/home/commonapi/uploadFile";
      
      private var currentFr:FileReference;
      
      private var file:File;
      
      private var nativeProcessStartupInfo:NativeProcessStartupInfo;
      
      private var chromeUrl:String = "";
      
      public function UploadPPT()
      {
         selectedFiles = [];
         file = new File();
         super();
      }
      
      public static function getInstance() : UploadPPT
      {
         if(_instance == null)
         {
            _instance = new UploadPPT();
         }
         return _instance;
      }
      
      public function deleteFiles() : void
      {
      }
      
      public function selectFiles() : void
      {
         if(fileRefs == null)
         {
            fileRefs = new FileReferenceList();
            fileRefs.addEventListener("select",onFileSelect);
         }
         fileRefs.browse(getTypeFilter());
      }
      
      private function getTypeFilter() : Array
      {
         var _loc1_:FileFilter = new FileFilter("推送文件 (*.png;*.fui;*.jpg)","*.png;*.fui;*.jpg");
         return [_loc1_];
      }
      
      private function onFileSelect(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc3_:* = fileRefs.fileList;
         for each(var _loc2_ in fileRefs.fileList)
         {
            selectedFiles.push(_loc2_);
         }
         this.doUploadTask();
      }
      
      public function loadFiles(param1:Array) : void
      {
      }
      
      private function doUploadTask() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(selectedFiles.length > 0)
         {
            currentFr = selectedFiles.shift();
            try
            {
               _loc2_ = new URLRequest(defaultRequestUrl);
               _loc1_ = new URLVariables();
               _loc1_.path = "designRes";
               _loc1_.userId = "100001";
               _loc2_.data = _loc1_;
               _loc2_.method = "POST";
               currentFr.upload(_loc2_,"file",true);
               currentFr.addEventListener("progress",progressHandle);
               currentFr.addEventListener("uploadCompleteData",completeHandle);
               currentFr.addEventListener("ioError",ioErrorHandler);
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            if(_editorWindow)
            {
               _editorWindow.alert("文件上传完毕！");
            }
            currentFr = null;
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      private function progressHandle(param1:ProgressEvent) : void
      {
         var _loc2_:uint = param1.bytesLoaded / param1.bytesTotal * 100;
      }
      
      private function completeHandle(param1:DataEvent) : void
      {
         this.doUploadTask();
      }
      
      public function callChromeExe(param1:*) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         NativeApplication.nativeApplication.autoExit = true;
         try
         {
            _loc4_ = SharedObject.getLocal("chromePath");
            if(_loc4_.data["chromePath"] != null)
            {
               file = file.resolvePath(_loc4_.data["chromePath"]);
            }
            else
            {
               file = file.resolvePath("C:/Program Files (x86)/Google/Chrome/Application/chrome.exe");
            }
            nativeProcessStartupInfo = new NativeProcessStartupInfo();
            nativeProcessStartupInfo.executable = file;
            _loc2_ = new NativeProcess();
            _loc3_ = new Vector.<String>();
            _loc3_.push(param1);
            _loc3_.push("--allow-file-access-from-files");
            _loc3_.push("--allow-file-access-frome-files");
            _loc3_.push(" --disable-web-security");
            nativeProcessStartupInfo.arguments = _loc3_;
            _loc2_.start(nativeProcessStartupInfo);
            return;
         }
         catch(err:Error)
         {
            this.chromeUrl = param1;
            _editorWindow.alert("Please check the chrome.exe path!",this.onCompi);
            return;
         }
      }
      
      public function onCompi() : void
      {
         this.selectChromeExe();
      }
      
      public function selectChromeExe() : void
      {
         var _loc1_:File = new File();
         _loc1_.browseForOpen("Select a text file",[new FileFilter("chrome exe(*.exe;)","*.exe")]);
         _loc1_.addEventListener("select",onChromeSelect);
      }
      
      private function onChromeSelect(param1:Event) : void
      {
         var _loc2_:SharedObject = SharedObject.getLocal("chromePath");
         _loc2_.data["chromePath"] = param1.target.url;
         this.callChromeExe(this.chromeUrl);
      }
   }
}

package fairygui.editor.handlers
{
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.OpenProjectWindow;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.publish.PublishHandler;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.editor.utils.Callback;
   import fairygui.utils.GTimers;
   import flash.desktop.NativeApplication;
   import flash.desktop.NativeProcess;
   import flash.desktop.NativeProcessStartupInfo;
   import flash.events.InvokeEvent;
   import flash.filesystem.File;
   
   public class NativeInvokeHandler
   {
       
      
      private var _editorWindow:EditorWindow;
      
      private var _callbackProg:String;
      
      public function NativeInvokeHandler()
      {
         super();
      }
      
      public function run(param1:InvokeEvent) : Boolean
      {
         param1 = param1;
         var projectDescFilePath:String = null;
         var pkgName:String = null;
         var targetPath:String = null;
         var error:Boolean = false;
         var pkgs:Vector.<EUIPackage> = null;
         var handler:PublishHandler = null;
         var bt:BulkTasks = null;
         var callback:Callback = null;
         var arg:String = null;
         var arr:Array = null;
         var pkg:EUIPackage = null;
         var evt:InvokeEvent = param1;
         var args:Array = evt.arguments;
         var cnt:int = args.length;
         var i:int = 0;
         while(i < cnt)
         {
            i = Number(i) + 1;
            arg = args[Number(i)];
            if(arg == "-p")
            {
               i = Number(i) + 1;
               projectDescFilePath = args[Number(i)];
               continue;
            }
            if(arg == "-b")
            {
               i = Number(i) + 1;
               pkgName = args[Number(i)];
               continue;
            }
            if(arg == "-x")
            {
               i = Number(i) + 1;
               this._callbackProg = args[Number(i)];
               continue;
            }
            if(arg == "-o")
            {
               i = Number(i) + 1;
               targetPath = args[Number(i)];
               continue;
            }
            error = true;
            break;
         }
         if(error || !projectDescFilePath)
         {
            return false;
         }
         var projectDescFile:File = new File(projectDescFilePath);
         if(!projectDescFile.exists)
         {
            return false;
         }
         var openProjectWindow:OpenProjectWindow = ClassEditor.findOpenProjectWindow();
         if(openProjectWindow)
         {
            openProjectWindow.stage.nativeWindow.visible = false;
         }
         this._editorWindow = ClassEditor.createEditorWindow(projectDescFile,true);
         var proj:EUIProject = this._editorWindow.project;
         if(pkgName)
         {
            arr = pkgName.split(",");
            cnt = arr.length;
            pkgs = new Vector.<EUIPackage>();
            i = 0;
            while(i < cnt)
            {
               pkg = proj.getPackageByName(arr[i]);
               if(!pkg)
               {
                  pkg = proj.getPackage(arr[i]);
                  if(!pkg)
                  {
                     return false;
                  }
               }
               pkgs.push(pkg);
               i = Number(i) + 1;
            }
         }
         else
         {
            pkgs = proj.getPackageList();
         }
         handler = new PublishHandler();
         bt = new BulkTasks(1);
         callback = new Callback();
         callback.success = function():void
         {
            bt.finishItem();
            bt.addErrorMsgs(callback.msgs);
         };
         callback.failed = function():void
         {
            bt.clear();
            exit(Consts.g.text98 + "\n" + callback.msgs.join("\n"));
         };
         var task:Function = function():void
         {
            var _loc1_:EUIPackage = EUIPackage(bt.taskData);
            handler.publish(_loc1_,false,targetPath,callback);
         };
         var _loc4_:int = 0;
         var _loc3_:* = pkgs;
         for each(pkg in pkgs)
         {
            bt.addTask(task,pkg);
         }
         bt.start(function():void
         {
            _editorWindow.closeWaiting();
            if(bt.errorMsgs.length > 0)
            {
               exit(Consts.g.text96 + "\n" + Consts.g.text97 + "\n" + bt.errorMsgs.join("\n"));
            }
            exit(null);
         });
         return true;
      }
      
      public function exit(param1:String) : void
      {
         param1 = param1;
         var si:NativeProcessStartupInfo = null;
         var st:File = null;
         var process:NativeProcess = null;
         var args:Vector.<String> = null;
         var msg:String = param1;
         if(this._callbackProg)
         {
            try
            {
               si = new NativeProcessStartupInfo();
               st = File.applicationDirectory.resolvePath(this._callbackProg);
               si.executable = st;
               if(msg)
               {
                  args = new Vector.<String>();
                  args.push(msg);
                  si.arguments = args;
               }
               process = new NativeProcess();
               process.start(si);
            }
            catch(err:Error)
            {
            }
         }
         GTimers.inst.add(1000,1,function():void
         {
            if(_editorWindow != null)
            {
               _editorWindow.stage.nativeWindow.close();
            }
            if(NativeApplication.nativeApplication.openedWindows.length == 1)
            {
               NativeApplication.nativeApplication.exit(msg != null?1:0);
            }
         });
      }
   }
}

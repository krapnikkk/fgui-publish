package fairygui.editor.dialogs.insert
{
   import fairygui.GLabel;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.dialogs.ChooseFolderDialog;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import flash.events.Event;
   import flash.events.FileListEvent;
   import flash.filesystem.File;
   import flash.net.FileFilter;
   
   public class CreateFyMoiveDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      private var _name:GLabel;
      
      private var importResBtn;
      
      private var fileRefs:File;
      
      private var selectedFiles:Array;
      
      private var srcFile:File;
      
      public function CreateFyMoiveDialog(param1:EditorWindow)
      {
         selectedFiles = [];
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateMovieClipDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.contentPane.getChild("frame").text = "创建骨骼动画";
         this._name = this.contentPane.getChild("n3").asLabel;
         this.contentPane.getChild("btnCreate").addClickListener(__actionHandler);
         this.contentPane.getChild("n10").addClickListener(this.__browse);
         this.contentPane.getChild("btnCancel").addClickListener(closeEventHandler);
      }
      
      override protected function onShown() : void
      {
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         this._name.text = this._pkg.getSequenceName("FyMovie");
         this._path = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedFolderInPackage(this._pkg).id;
         this.__selectFolder(this._path);
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.libPanel.self.requestFocus();
      }
      
      override public function actionHandler() : void
      {
         var _loc1_:EPackageItem = null;
         try
         {
            _loc1_ = this._pkg.createNewFyMovie(this._name.text,this._path);
            _editorWindow.mainPanel.openItem(_loc1_);
            this.hide();
            return;
         }
         catch(err:Error)
         {
            _editorWindow.alertError(err);
            return;
         }
      }
      
      private function __browse(param1:Event) : void
      {
         this.selectFiles();
      }
      
      private function __selectFolder(param1:String) : void
      {
         this._path = param1;
         contentPane.getChild("n9").text = "/" + this._pkg.name + this._path;
      }
      
      private function __importRes(param1:Event) : void
      {
         ChooseFolderDialog(_editorWindow.getDialog(ChooseFolderDialog)).open(this._pkg,this._path,this.__selectFolder);
      }
      
      public function selectFiles() : void
      {
         if(fileRefs == null)
         {
            fileRefs = new File();
            fileRefs.addEventListener("selectMultiple",onFileSelect);
         }
         fileRefs.browseForOpenMultiple("选择要导入的龙骨文件",getTypeFilter());
         fileRefs.addEventListener("select",this.onFileSelect);
      }
      
      private function getTypeFilter() : Array
      {
         var _loc1_:FileFilter = new FileFilter("推送文件 (*.png;*.json;*.sk;)","*.png;*.json;*.sk");
         return [_loc1_];
      }
      
      private function onFileSelect(param1:FileListEvent) : void
      {
         selectedFiles.length = 0;
         var _loc4_:int = 0;
         var _loc3_:* = param1.files;
         for each(var _loc2_ in param1.files)
         {
            selectedFiles.push(_loc2_);
         }
         this.doUploadTask();
      }
      
      private function doUploadTask() : void
      {
         var _loc1_:* = null;
         if(selectedFiles.length > 0)
         {
            srcFile = selectedFiles.shift();
            _loc1_ = File.createTempFile();
         }
         else if(_editorWindow)
         {
            _editorWindow.alert("文件上传完毕！");
         }
      }
   }
}

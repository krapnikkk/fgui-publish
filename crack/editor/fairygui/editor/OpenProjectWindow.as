package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GComponent;
   import fairygui.GLabel;
   import fairygui.GList;
   import fairygui.GRoot;
   import fairygui.UIPackage;
   import fairygui.editor.dialogs.AlertDialog;
   import fairygui.editor.dialogs.ConfirmDialog;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.handlers.UpgradeHandler;
   import fairygui.editor.utils.RuntimeErrorUtil;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.event.ItemEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.net.FileFilter;
   
   public class OpenProjectWindow extends Sprite
   {
       
      
      public var owner:EditorWindow;
      
      public var groot:GRoot;
      
      public var view:GComponent;
      
      private var _path:GLabel;
      
      private var _name:GLabel;
      
      private var _type:GComboBox;
      
      private var _list:GList;
      
      private var _alertDialog:AlertDialog;
      
      private var _confirmDialog:ConfirmDialog;
      
      public function OpenProjectWindow()
      {
         super();
      }
      
      public function init(param1:EditorWindow, param2:Boolean) : void
      {
         var _loc7_:String = null;
         var _loc5_:GButton = null;
         var _loc6_:* = param1;
         var _loc3_:* = param2;
         stage.frameRate = 24;
         stage.align = "TL";
         stage.scaleMode = "noScale";
         stage.color = 3684408;
         this.owner = _loc6_;
         this.groot = new GRoot();
         addChild(this.groot.displayObject);
         this.view = UIPackage.createObject("Builder","OpenProjectWindow").asCom;
         this.view.setSize(this.groot.width,this.groot.height);
         this.groot.addChild(this.view);
         this._name = this.view.getChild("name").asLabel;
         this._path = this.view.getChild("path").asLabel;
         this._type = this.view.getChild("type").asComboBox;
         this._type.items = Consts.supportedPlatforms;
         this._type.values = Consts.supportedPlatforms;
         this._type.value = "Unity";
         this._list = this.view.getChild("list").asList;
         this._list.addEventListener("itemClick",this.__clickItem);
         this.view.getChild("btnOpen").addClickListener(this.__open);
         this.view.getChild("btnOpenOther").addClickListener(this.__openOther);
         this.view.getChild("btnOpenFolder").addClickListener(this.__openFolder);
         this.view.getChild("btnCreate").addClickListener(this.__create);
         this.view.getChild("btnBrowse").addClickListener(this.__browse);
         this.view.getChild("btnDelete").addClickListener(this.__delete);
         var _loc8_:Array = LocalStore.data.recent_project;
         if(!_loc8_)
         {
            _loc8_ = [];
         }
         if(_loc8_.length % 2 != 0)
         {
            _loc8_.length = 0;
            delete LocalStore.data.recent_project;
         }
         var _loc4_:int = _loc8_.length / 2;
         this._list.removeChildrenToPool();
         var _loc9_:int = _loc4_ - 1;
         while(_loc9_ >= 0)
         {
            _loc7_ = _loc8_[_loc9_ * 2 + 1];
            try
            {
               if(!new File(_loc7_).exists)
               {
               }
               _loc9_--;
               continue;
            }
            catch(err:Error)
            {
               _loc9_--;
               continue;
            }
            _loc5_ = this._list.addItemFromPool().asButton;
            _loc5_.title = _loc8_[_loc9_ * 2] + " - " + _loc7_;
            _loc5_.data = _loc7_;
            _loc9_--;
         }
         this._list.selectedIndex = 0;
         this.view.getChild("btnOpen").enabled = this._list.numChildren > 0;
         this.view.getChild("btnDelete").enabled = this._list.numChildren > 0;
         this.view.getController("c1").selectedIndex = !!_loc3_?1:0;
         this._alertDialog = new AlertDialog();
      }
      
      public function openProject(param1:String) : void
      {
         param1 = param1;
         var files:Array = null;
         var i:int = 0;
         var ow:OpenProjectWindow = null;
         var path:String = param1;
         var projectDescFile:File = null;
         var file:File = new File(path);
         if(!file.exists)
         {
            this._alertDialog.open(this.groot,Consts.g.text117);
            return;
         }
         if(file.isDirectory)
         {
            files = file.getDirectoryListing();
            i = 0;
            while(i < files.length)
            {
               if(File(files[i]).extension == "fairy")
               {
                  projectDescFile = files[i];
                  break;
               }
               i = Number(i) + 1;
            }
            if(!projectDescFile)
            {
               i = 0;
               while(i < files.length)
               {
                  if(files[i].name == "project.xml")
                  {
                     if(this._confirmDialog == null)
                     {
                        this._confirmDialog = new ConfirmDialog();
                     }
                     ow = this;
                     this._confirmDialog.open(this.groot,Consts.g.text312,function():void
                     {
                        new UpgradeHandler().open(ow,File(files[i]).parent);
                     });
                     return;
                  }
                  i = Number(i) + 1;
               }
               this._alertDialog.open(this.groot,Consts.g.text117);
               return;
            }
         }
         else
         {
            projectDescFile = file;
         }
         var ew:EditorWindow = ClassEditor.createEditorWindow(projectDescFile);
         if(this.owner != null && this.owner != ew)
         {
            this.owner.mainPanel.saveWorkspace();
            this.owner.stage.nativeWindow.close();
         }
         stage.nativeWindow.close();
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc2_:String = null;
         if(param1.clickCount == 2)
         {
            _loc2_ = String(param1.itemObject.data);
            this.openProject(_loc2_);
         }
      }
      
      private function __open(param1:Event) : void
      {
         var _loc2_:String = String(this._list.getChildAt(this._list.selectedIndex).data);
         this.openProject(_loc2_);
      }
      
      private function __openOther(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         UtilsFile.browseForOpen(Consts.g.text35,[new FileFilter(Consts.g.text314,"*.fairy")],function(param1:File):void
         {
            openProject(param1.nativePath);
         });
      }
      
      private function __openFolder(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         UtilsFile.browseForDirectory(Consts.g.text35,function(param1:File):void
         {
            openProject(param1.nativePath);
         });
      }
      
      private function __create(param1:Event) : void
      {
         var _loc2_:* = param1;
         try
         {
            EUIProject.createNew(this._path.text,this._name.text,this._type.value,"Package1");
            this.openProject(new File(this._path.text).nativePath);
            return;
         }
         catch(err:Error)
         {
            _alertDialog.open(groot,Consts.g.text73 + ": " + RuntimeErrorUtil.toString(err));
            return;
         }
      }
      
      private function __browse(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         UtilsFile.browseForDirectory(Consts.g.text74,function(param1:File):void
         {
            _path.text = param1.nativePath;
         });
      }
      
      private function __delete(param1:Event) : void
      {
         var _loc5_:int = this._list.selectedIndex;
         var _loc3_:String = String(this._list.getChildAt(_loc5_).data);
         var _loc4_:Array = LocalStore.data.recent_project;
         if(!_loc4_)
         {
            _loc4_ = [];
         }
         var _loc2_:int = _loc4_.indexOf(_loc3_);
         if(_loc2_ != -1)
         {
            _loc4_.splice(_loc2_ - 1,2);
         }
         LocalStore.data.recent_project = _loc4_;
         LocalStore.setDirty("recent_project");
         this._list.removeChildToPoolAt(_loc5_);
         if(_loc5_ >= 1)
         {
            this._list.selectedIndex = _loc5_ - 1;
         }
         else
         {
            this._list.selectedIndex = 0;
         }
         this.view.getChild("btnOpen").enabled = this._list.numChildren > 0;
         this.view.getChild("btnDelete").enabled = this._list.numChildren > 0;
      }
   }
}

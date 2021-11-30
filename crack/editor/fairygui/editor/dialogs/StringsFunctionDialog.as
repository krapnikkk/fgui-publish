package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.handlers.StringsHandler;
   import fairygui.editor.utils.UtilsFile;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.net.FileFilter;
   
   public class StringsFunctionDialog extends WindowBase
   {
       
      
      private var _exportPkgList:GList;
      
      private var _importPkgList:GList;
      
      public function StringsFunctionDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","StringsFunctionDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._exportPkgList = contentPane.getChild("exportPkgList").asList;
         this._exportPkgList.selectionMode = 2;
         this._importPkgList = contentPane.getChild("importPkgList").asList;
         this._importPkgList.selectionMode = 3;
         contentPane.getChild("n14").addClickListener(closeEventHandler);
         contentPane.getChild("n40").addClickListener(this.__selectAll);
         contentPane.getChild("n41").addClickListener(this.__selectNone);
         contentPane.getChild("n43").addClickListener(this.__nextStep);
         contentPane.getChild("n53").addClickListener(this.__browse);
         contentPane.getChild("n51").addClickListener(this.__export);
         contentPane.getChild("n61").addClickListener(this.__import);
      }
      
      override protected function onShown() : void
      {
         contentPane.getController("c1").selectedIndex = 0;
         contentPane.getChild("n52").text = "";
      }
      
      private function __selectAll(param1:Event) : void
      {
         this._exportPkgList.selectAll();
      }
      
      private function __selectNone(param1:Event) : void
      {
         this._exportPkgList.selectNone();
      }
      
      private function __nextStep(param1:Event) : void
      {
         var _loc5_:Vector.<EUIPackage> = null;
         var _loc3_:EUIPackage = null;
         var _loc4_:GButton = null;
         var _loc2_:String = null;
         if(contentPane.getController("c2").selectedIndex == 0)
         {
            this._exportPkgList.removeChildrenToPool();
            _loc5_ = _editorWindow.project.getPackageList();
            var _loc7_:int = 0;
            var _loc6_:* = _loc5_;
            for each(_loc3_ in _loc5_)
            {
               _loc4_ = this._exportPkgList.addItemFromPool().asButton;
               _loc4_.icon = Icons.all["package"];
               _loc4_.title = _loc3_.name;
               _loc4_.name = _loc3_.id;
               _loc4_.selected = true;
            }
            contentPane.getController("c1").selectedIndex = 1;
         }
         else
         {
            _loc2_ = contentPane.getChild("n52").text;
            if(_loc2_.length == 0)
            {
               _editorWindow.alert(Consts.g.text184);
               return;
            }
            contentPane.getController("c1").selectedIndex = 2;
            this.parseImportFile();
         }
      }
      
      private function __browse(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         UtilsFile.browseForOpen("Open",[new FileFilter(Consts.g.text186,"*.xml")],function(param1:File):void
         {
            contentPane.getChild("n52").text = param1.nativePath;
         });
      }
      
      private function __export(param1:Event) : void
      {
         UtilsFile.browseForSave("Save",this.__doExport);
      }
      
      private function __doExport(param1:File) : void
      {
         var _loc3_:GButton = null;
         if(!param1.extension)
         {
            param1 = new File(param1.nativePath + ".xml");
         }
         var _loc6_:Vector.<EUIPackage> = new Vector.<EUIPackage>();
         var _loc4_:int = this._exportPkgList.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this._exportPkgList.getChildAt(_loc5_).asButton;
            if(_loc3_.selected)
            {
               _loc6_.push(_editorWindow.project.getPackage(_loc3_.name));
            }
            _loc5_++;
         }
         _editorWindow.cursorManager.setWaitCursor(true);
         var _loc2_:StringsHandler = new StringsHandler();
         _loc2_.exportStrings(_loc6_,param1,contentPane.getChild("merge").asButton.selected);
         _editorWindow.cursorManager.setWaitCursor(false);
         PromptDialog(_editorWindow.getDialog(PromptDialog)).open(Consts.g.text185);
         contentPane.getController("c1").selectedIndex = 0;
      }
      
      private function parseImportFile() : void
      {
         var _loc1_:String = null;
         var _loc2_:GButton = null;
         var _loc6_:String = contentPane.getChild("n52").text;
         var _loc5_:File = new File(_loc6_);
         var _loc3_:StringsHandler = new StringsHandler();
         var _loc4_:Vector.<String> = _loc3_.parseImport(_loc5_,_editorWindow.project);
         this._importPkgList.removeChildrenToPool();
         var _loc8_:int = 0;
         var _loc7_:* = _loc4_;
         for each(_loc1_ in _loc4_)
         {
            _loc2_ = this._importPkgList.addItemFromPool().asButton;
            _loc2_.icon = Icons.all["package"];
            _loc2_.title = _loc1_;
         }
      }
      
      private function __import(param1:Event) : void
      {
         _editorWindow.mainPanel.editPanel.queryToSaveAllDocuments(this.doImport);
      }
      
      private function doImport(param1:int) : void
      {
         if(param1 != 0)
         {
            _editorWindow.alert(Consts.g.text187);
            return;
         }
         var _loc5_:String = contentPane.getChild("n52").text;
         var _loc3_:File = new File(_loc5_);
         var _loc4_:Vector.<String> = new Vector.<String>();
         var _loc2_:StringsHandler = new StringsHandler();
         _editorWindow.cursorManager.setWaitCursor(true);
         _loc2_.importStrings(_loc3_,_loc4_,_editorWindow.project);
         _editorWindow.cursorManager.setWaitCursor(false);
         if(_loc4_.length > 100)
         {
            _loc4_ = _loc4_.slice(0,100);
         }
         if(_loc4_.length > 0)
         {
            _editorWindow.alert(Consts.g.text190 + "\n" + _loc4_.join("\n"));
         }
         else
         {
            PromptDialog(_editorWindow.getDialog(PromptDialog)).open(Consts.g.text189);
         }
         _editorWindow.project.reload();
         _editorWindow.mainPanel.editPanel.refreshDocument();
         contentPane.getController("c1").selectedIndex = 0;
      }
   }
}

package fairygui.editor.dialogs
{
   import fairygui.Controller;
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.handlers.FindReferenceHandler;
   import fairygui.event.DragEvent;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class FindReferenceDialog extends WindowBase
   {
       
      
      private var _list:GList;
      
      private var _source:String;
      
      private var _findRefHandler:FindReferenceHandler;
      
      private var _c1:Controller;
      
      public function FindReferenceDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","FindReferenceDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._list = contentPane.getChild("n19").asList;
         this._list.addEventListener("itemClick",this.__clickItem);
         this._c1 = contentPane.getController("c1");
         this._findRefHandler = new FindReferenceHandler();
         contentPane.getChild("n14").addClickListener(closeEventHandler);
         contentPane.getChild("n28").addClickListener(this.__find);
         contentPane.getChild("n42").addClickListener(this.__replace);
      }
      
      public function open(param1:EPackageItem) : void
      {
         show();
         if(param1 != null)
         {
            this._source = "ui://" + param1.owner.id + param1.id;
         }
         else
         {
            this._source = null;
         }
         contentPane.getChild("n39").text = this._source;
         this._list.removeChildrenToPool();
      }
      
      private function __find(param1:Event) : void
      {
         var _loc2_:EPackageItem = null;
         var _loc3_:GButton = null;
         this._source = contentPane.getChild("n39").text;
         if(!this._source)
         {
            return;
         }
         var _loc6_:EUIProject = _editorWindow.project;
         _editorWindow.cursorManager.setWaitCursor(true);
         this._findRefHandler.find(this._source,this._c1.selectedIndex,_loc6_);
         _editorWindow.cursorManager.setWaitCursor(false);
         var _loc4_:int = this._findRefHandler.results.length;
         this._list.removeChildrenToPool();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this._findRefHandler.results[_loc5_];
            _loc3_ = this._list.addItemFromPool().asButton;
            _loc3_.draggable = true;
            _loc3_.icon = Icons.all[_loc2_.type];
            _loc3_.title = _loc2_.name + " @" + _loc2_.owner.name;
            _loc3_.data = _loc2_;
            _loc3_.addEventListener("startDrag",this.__dragItemStart);
            _loc5_++;
         }
      }
      
      private function __replace(param1:Event) : void
      {
         ReplaceRefDialog(_editorWindow.getDialog(ReplaceRefDialog)).open(this.doRepace);
      }
      
      private function doRepace(param1:String) : void
      {
         param1 = param1;
         var target:String = param1;
         var pi1:EPackageItem = _editorWindow.project.getItemByURL(this._source);
         var pi2:EPackageItem = _editorWindow.project.getItemByURL(target);
         if(pi1 != null && pi1.type != pi2.type)
         {
            _editorWindow.alert(Consts.g.text267);
            return;
         }
         _editorWindow.mainPanel.editPanel.queryToSaveAllDocuments(function(param1:int):void
         {
            if(param1 != 0)
            {
               return;
            }
            _editorWindow.cursorManager.setWaitCursor(true);
            _findRefHandler.replaceAll(_source,target,_editorWindow.project);
            _editorWindow.cursorManager.setWaitCursor(false);
            __find(null);
            _editorWindow.mainPanel.editPanel.refreshDocument();
         });
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc2_:EPackageItem = null;
         if(param1.clickCount == 2)
         {
            _loc2_ = EPackageItem(param1.itemObject.data);
            _editorWindow.mainPanel.libPanel.highlightItem(_loc2_);
         }
      }
      
      private function __dragItemStart(param1:DragEvent) : void
      {
         param1.preventDefault();
         var _loc2_:GButton = GButton(param1.currentTarget);
         if(!_loc2_.selected)
         {
            this._list.clearSelection();
            this._list.addSelection(this._list.getChildIndex(_loc2_));
         }
         _editorWindow.dragManager.startDrag(_editorWindow.mainPanel.libPanel,[_loc2_.data]);
      }
   }
}

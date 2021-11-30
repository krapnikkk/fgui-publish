package fairygui.editor
{
   import fairygui.Controller;
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GLabel;
   import fairygui.GTextField;
   import fairygui.editor.dialogs.ChoosePackagesDialog;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.handlers.SearchHandler;
   import fairygui.editor.settings.WorkSpace;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class LibPanel
   {
       
      
      public var self:GComponent;
      
      public var pkgsPanel:PackagesPanel;
      
      public var favoritesPanel:FavortiesPanel;
      
      private var _editorWindow:EditorWindow;
      
      private var _viewController:Controller;
      
      private var _filterButton:GButton;
      
      private var _findInput:GLabel;
      
      private var _findMsg:GTextField;
      
      private var _searchHandler:SearchHandler;
      
      public function LibPanel(param1:EditorWindow, param2:GComponent)
      {
         super();
         this.self = param2;
         this._editorWindow = param1;
         this.pkgsPanel = new PackagesPanel(param1,param2);
         this.favoritesPanel = new FavortiesPanel(param1,param2);
         this._viewController = this.self.getController("library");
         this._viewController.addEventListener("stateChanged",this.__viewChanged);
         this._filterButton = this.self.getChild("btnSettings").asButton;
         this._filterButton.linkedPopup = this._editorWindow.getDialog(ChoosePackagesDialog);
         this._filterButton.visible = false;
         this.self.getChild("btnCollapseAll").addClickListener(this.__collapseAll);
         this.self.getChild("btnFind").addEventListener("stateChanged",this.__switchFind);
         this.self.getChild("btnRefresh").addClickListener(this.__refresh);
         var _loc3_:GComponent = this.self.getChild("find").asCom;
         this._findInput = _loc3_.getChild("findInput").asLabel;
         this._findInput.getChild("title").addEventListener("keyDown",this.__findKeydown);
         _loc3_.getChild("btnFind").addClickListener(this.__doFind);
         _loc3_.getChild("btnPrev").addClickListener(this.__findPrev);
         _loc3_.getChild("btnNext").addClickListener(this.__findNext);
         this._findMsg = _loc3_.getChild("msg").asTextField;
         this._searchHandler = new SearchHandler();
      }
      
      public function setActive(param1:Boolean) : void
      {
         this.pkgsPanel.setActive(param1);
         this.favoritesPanel.setActive(param1);
      }
      
      public function updatePackages() : void
      {
         this.pkgsPanel.updatePackages();
         this.favoritesPanel.updatePackages();
         this._filterButton.visible = true;
      }
      
      public function getSelectedItem() : EPackageItem
      {
         if(this._viewController.selectedIndex == 0)
         {
            return this.pkgsPanel.getSelectedItem();
         }
         return this.favoritesPanel.getSelectedItem();
      }
      
      public function saveState(param1:WorkSpace) : void
      {
         this.pkgsPanel.saveState(param1);
      }
      
      public function restoreState(param1:WorkSpace) : void
      {
         this.pkgsPanel.restoreState(param1);
      }
      
      public function highlightItem(param1:EPackageItem) : void
      {
         this.pkgsPanel.highlightItem(param1);
         this._viewController.selectedIndex = 0;
      }
      
      public function updateItem(param1:EPackageItem) : void
      {
         if(param1.treeNode && param1.treeNode.tree)
         {
            this.pkgsPanel.updateItem(param1);
            if(param1.favorite)
            {
               this.favoritesPanel.updateItem(param1);
            }
         }
      }
      
      public function handleKeyDownEvent(param1:KeyboardEvent) : void
      {
         if(this._viewController.selectedIndex == 0)
         {
            this.pkgsPanel.handleKeyDownEvent(param1);
         }
         else
         {
            this.favoritesPanel.handleKeyDownEvent(param1);
         }
      }
      
      public function handleKeyUpEvent(param1:KeyboardEvent) : void
      {
      }
      
      public function handleArrowKey(param1:int, param2:Boolean, param3:Boolean) : void
      {
         if(this._viewController.selectedIndex == 0)
         {
            this.pkgsPanel.handleArrowKey(param1,param2,param3);
         }
         else
         {
            this.favoritesPanel.handleArrowKey(param1,param2,param3);
         }
      }
      
      private function __refresh(param1:Event) : void
      {
         this._editorWindow.project.refresh();
      }
      
      private function __collapseAll(param1:Event) : void
      {
         if(this._viewController.selectedIndex == 0)
         {
            this.pkgsPanel.collapseAll();
         }
         else
         {
            this.favoritesPanel.collapseAll();
         }
      }
      
      private function __switchFind(param1:Event) : void
      {
         if(this.self.getChild("btnFind").asButton.selected)
         {
            this.self.getController("search").selectedIndex = 1;
            this.self.displayObject.stage.focus = TextField(this._findInput.getChild("title").displayObject);
         }
         else
         {
            this.self.getController("search").selectedIndex = 0;
         }
      }
      
      private function __doFind(param1:Event) : void
      {
         var _loc2_:String = this._findInput.text;
         if(UtilsStr.trim(_loc2_).length == 0)
         {
            return;
         }
         this._searchHandler.search(this._editorWindow.project,_loc2_);
         this._findMsg.text = UtilsStr.formatString(Consts.g.text243,this._searchHandler.resultCount);
         if(this._searchHandler.resultCount > 0)
         {
            this.highlightItem(this._searchHandler.nextResult);
         }
      }
      
      private function __findNext(param1:Event) : void
      {
         if(this._searchHandler.resultCount == 0)
         {
            return;
         }
         this.highlightItem(this._searchHandler.nextResult);
      }
      
      private function __findPrev(param1:Event) : void
      {
         if(this._searchHandler.resultCount == 0)
         {
            return;
         }
         this.highlightItem(this._searchHandler.prevResult);
      }
      
      private function __findKeydown(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 13)
         {
            if(this._searchHandler.resultCount == 0 || this._searchHandler.key != this._findInput.text)
            {
               this.__doFind(null);
            }
            else
            {
               this.__findNext(null);
            }
         }
      }
      
      private function __viewChanged(param1:Event) : void
      {
         if(this._viewController.selectedIndex == 1)
         {
            this.favoritesPanel.onShown();
         }
         this._editorWindow.mainPanel.previewPanel.refresh();
      }
   }
}

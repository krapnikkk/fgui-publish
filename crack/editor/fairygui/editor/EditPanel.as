package fairygui.editor
{
   import fairygui.Controller;
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.dialogs.CustomArrangeDialog;
   import fairygui.editor.dialogs.SaveConfirmDialog;
   import fairygui.editor.extui.CursorManager;
   import fairygui.editor.extui.ITabViewListener;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.extui.TabItem;
   import fairygui.editor.extui.TabView;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EGGroup;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.settings.WorkSpace;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EditPanel implements ITabViewListener
   {
       
      
      public var self:GComponent;
      
      public var timelinePanel:TimelinePanel;
      
      public var tabView:TabView;
      
      public var docContainer:GComponent;
      
      public var controllerPanel:ControllerPanel;
      
      public var transitionListPanel:TransitionListPanel;
      
      private var _groupPathList:GList;
      
      private var _groupPathBar:GObject;
      
      private var _editTypeCtrller:Controller;
      
      private var _docCache:Vector.<ComDocument>;
      
      private var _activeDoc:IDocument;
      
      private var _closingAll:Boolean;
      
      private var _openingAll:Boolean;
      
      private var _tabMenu:PopupMenu;
      
      private var _editorWindow:EditorWindow;
      
      public function EditPanel(param1:EditorWindow, param2:GComponent)
      {
         param1 = param1;
         param2 = param2;
         var btn:GButton = null;
         var win:EditorWindow = param1;
         var panel:GComponent = param2;
         super();
         this.self = panel;
         this._editorWindow = win;
         this.tabView = new TabView(this.self.getChild("tabs").asList,this.self.getChild("moreBtn").asButton);
         this.tabView.listener = this;
         this.self.getChild("tabs").addEventListener("rightClick",this.__rightClickTabs);
         this.self.getChild("tabBar").addEventListener("rightClick",this.__rightClickTabs);
         this.docContainer = this.self.getChild("docContainer").asCom;
         this.docContainer.displayObject.addEventListener("mouseWheel",this.__mouseWheel,false,1);
         this._docCache = new Vector.<ComDocument>();
         this.controllerPanel = new ControllerPanel(this._editorWindow,this.self.getChild("controllerPanel").asCom,true);
         this.transitionListPanel = new TransitionListPanel(this._editorWindow,this.self.getChild("transitionListPanel").asCom,true);
         this.timelinePanel = new TimelinePanel(this._editorWindow,this.self.getChild("timelinePanel").asCom,this.self.getChild("timelinePanelResizer"));
         this.timelinePanel.hide();
         this._groupPathBar = this.self.getChild("groupPathBar");
         this._groupPathBar.visible = false;
         this._groupPathList = this.self.getChild("groupPathList").asList;
         this._groupPathList.addEventListener("itemClick",this.__clickGroupBtn);
         this._editTypeCtrller = this.self.getController("editType");
         this._editTypeCtrller.addEventListener("stateChanged",this.__editTypeChanged);
         this.self.getChild("n57").icon = "ui://2pshu6oiau3n1e";
         this.self.getChild("n26").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               _editorWindow.dragManager.startDrag(_activeDoc,["text"]);
            }
         });
         this.self.getChild("n49").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               _editorWindow.dragManager.startDrag(_activeDoc,["richtext"]);
            }
         });
         this.self.getChild("n27").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               _editorWindow.dragManager.startDrag(_activeDoc,["graph"]);
            }
         });
         this.self.getChild("n57").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               _editorWindow.dragManager.startDrag(_activeDoc,["video"]);
            }
         });
         this.self.getChild("n28").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               _editorWindow.dragManager.startDrag(_activeDoc,["list"]);
            }
         });
         this.self.getChild("n29").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               _editorWindow.dragManager.startDrag(_activeDoc,["loader"]);
            }
         });
         this.self.getChild("n31").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).makeGroup();
            }
         });
         this.self.getChild("n32").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).ungroup();
            }
         });
         this.self.getChild("n33").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).arrangeLeft();
            }
         });
         this.self.getChild("n34").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).arrangeCenter();
            }
         });
         this.self.getChild("n35").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).arrangeRight();
            }
         });
         this.self.getChild("n36").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).arrangeTop();
            }
         });
         this.self.getChild("n37").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).arrangeMiddle();
            }
         });
         this.self.getChild("n38").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).arrangeBottom();
            }
         });
         this.self.getChild("n39").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).arrangeSameWidth();
            }
         });
         this.self.getChild("n40").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               ComDocument(_activeDoc).arrangeSameHeight();
            }
         });
         this.self.getChild("n41").addClickListener(function(param1:Event):void
         {
            if(_activeDoc is ComDocument)
            {
               CustomArrangeDialog(_editorWindow.getDialog(CustomArrangeDialog)).show();
            }
         });
         this._tabMenu = new PopupMenu();
         this._tabMenu.contentPane.width = 220;
         btn = this._tabMenu.addItem(Consts.g.text13,function():void
         {
            queryToCloseDocument(_activeDoc);
         });
         btn.name = "close";
         btn.getChild("shortcut").text = "Ctrl+W";
         this._tabMenu.addItem(Consts.g.text14,function():void
         {
            queryToCloseOtherDocuments(_activeDoc);
         }).name = "closeOthers";
         this._tabMenu.addItem(Consts.g.text15,function():void
         {
            queryToSaveAllDocuments(function(param1:int):void
            {
               if(param1 != 2)
               {
                  closeAllDocuments();
               }
            });
         }).name = "closeAll";
      }
      
      public function set activeDocument(param1:IDocument) : void
      {
         this.tabView.activateTab(param1.uid);
      }
      
      public function get activeDocument() : IDocument
      {
         return this._activeDoc;
      }
      
      public function get editType() : int
      {
         return this._editTypeCtrller.selectedIndex;
      }
      
      public function set editType(param1:int) : void
      {
         this._editTypeCtrller.selectedIndex = param1;
      }
      
      public function findDocument(param1:String) : IDocument
      {
         var _loc3_:TabItem = null;
         var _loc4_:int = this.tabView.tabCount;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this.tabView.getTabAt(_loc2_);
            if(IDocument(_loc3_.data).uid == param1)
            {
               return IDocument(_loc3_.data);
            }
            _loc2_++;
         }
         return null;
      }
      
      public function findComDocument(param1:EUIPackage, param2:String) : ComDocument
      {
         return this.findDocument(param1.id + param2) as ComDocument;
      }
      
      public function findComDocuments(param1:EUIPackage) : Vector.<ComDocument>
      {
         var _loc2_:TabItem = null;
         var _loc5_:Vector.<ComDocument> = new Vector.<ComDocument>();
         var _loc3_:int = this.tabView.tabCount;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.tabView.getTabAt(_loc4_);
            if(_loc2_.data is ComDocument && ComDocument(_loc2_.data).editingTarget.owner == param1)
            {
               _loc5_.push(ComDocument(_loc2_.data));
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      public function openDocument(param1:EPackageItem, param2:Boolean = true) : ComDocument
      {
         var _loc3_:ComDocument = this.findComDocument(param1.owner,param1.id);
         if(_loc3_ != null)
         {
            this.tabView.activateTab(_loc3_.uid);
            return _loc3_;
         }
         if(this._docCache.length)
         {
            _loc3_ = this._docCache.pop();
         }
         else
         {
            _loc3_ = new ComDocument();
         }
         _loc3_.open(param1);
         this.tabView.addTab(param1.owner.id + param1.id,param1.name,Icons.all.component,_loc3_,param2);
         return _loc3_;
      }
      
      public function saveDocument(param1:IDocument = null) : void
      {
         if(param1 == null)
         {
            param1 = this._activeDoc;
         }
         if(param1 != null)
         {
            param1.save();
         }
      }
      
      public function saveAllDocuments() : void
      {
         var _loc1_:IDocument = null;
         var _loc3_:int = this.tabView.tabCount;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = IDocument(this.tabView.getTabAt(_loc2_).data);
            _loc1_.save();
            _loc2_++;
         }
      }
      
      public function closeDocument(param1:IDocument = null) : void
      {
         if(param1 == null)
         {
            param1 = this._activeDoc;
         }
         if(param1 != null)
         {
            this.tabView.closeTab(param1.uid);
         }
      }
      
      public function closeAllDocuments() : void
      {
         var _loc1_:IDocument = null;
         this._closingAll = true;
         var _loc3_:int = this.tabView.tabCount;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = IDocument(this.tabView.getTabAt(_loc2_).data);
            _loc1_.release();
            this._docCache.push(_loc1_);
            _loc2_++;
         }
         this.tabView.clearAllTabs();
         this._activeDoc = null;
         this.docContainer.removeChildren();
         this.cleanupRelatedPanels();
         this._editorWindow.mainPanel.propsPanelList.refresh();
         this._groupPathBar.visible = false;
         this._editorWindow.mainPanel.toolbox.visible = false;
         this._closingAll = false;
      }
      
      public function queryToCloseDocument(param1:IDocument = null) : void
      {
         param1 = param1;
         var doc:IDocument = param1;
         if(doc == null)
         {
            doc = this._activeDoc;
         }
         if(doc == null)
         {
            return;
         }
         if(!doc.isModified)
         {
            this.tabView.closeTab(doc.uid);
            return;
         }
         var tab:TabItem = this.tabView.getTabById(doc.uid);
         SaveConfirmDialog(this._editorWindow.getDialog(SaveConfirmDialog)).open([tab.title],function(param1:int):void
         {
            if(param1 == 0)
            {
               saveDocument(doc);
               tabView.closeTab(doc.uid);
            }
            else if(param1 == 1)
            {
               tabView.closeTab(doc.uid);
            }
         });
      }
      
      private function queryToCloseOtherDocuments(param1:IDocument) : void
      {
         param1 = param1;
         var cnt:int = 0;
         var ti:TabItem = null;
         var doc2:IDocument = null;
         var doc:IDocument = param1;
         var docs:Array = [];
         cnt = this.tabView.tabCount;
         var i:int = 0;
         while(i < cnt)
         {
            ti = this.tabView.getTabAt(i);
            doc2 = IDocument(ti.data);
            if(doc2.isModified && doc2 != doc)
            {
               docs.push(ti.title);
            }
            i = Number(i) + 1;
         }
         if(docs.length == 0)
         {
            this.closeDocumentsExcept(doc);
            return;
         }
         SaveConfirmDialog(this._editorWindow.getDialog(SaveConfirmDialog)).open(docs,function(param1:int):void
         {
            var _loc4_:int = 0;
            var _loc2_:TabItem = null;
            var _loc3_:IDocument = null;
            if(param1 == 0)
            {
               _loc4_ = 0;
               while(_loc4_ < cnt)
               {
                  _loc2_ = tabView.getTabAt(_loc4_);
                  _loc3_ = IDocument(_loc2_.data);
                  if(_loc3_ != doc && _loc3_.isModified)
                  {
                     saveDocument(_loc3_);
                  }
                  _loc4_++;
               }
               closeDocumentsExcept(doc);
            }
            else if(param1 == 1)
            {
               closeDocumentsExcept(doc);
            }
         });
      }
      
      private function closeDocumentsExcept(param1:IDocument) : void
      {
         var _loc4_:TabItem = null;
         var _loc2_:IDocument = null;
         var _loc5_:int = this.tabView.tabCount;
         var _loc3_:int = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this.tabView.getTabAt(_loc3_);
            _loc2_ = IDocument(_loc4_.data);
            if(_loc2_ != param1)
            {
               if(_loc2_.isModified)
               {
                  this.saveDocument(param1);
               }
               this.tabView.closeTabAt(_loc3_);
               _loc5_--;
            }
            else
            {
               _loc3_++;
            }
         }
      }
      
      public function queryToSaveAllDocuments(param1:Function) : void
      {
         param1 = param1;
         var cnt:int = 0;
         var i:int = 0;
         var ti:TabItem = null;
         var doc:IDocument = null;
         var callback:Function = param1;
         var docs:Array = [];
         cnt = this.tabView.tabCount;
         i = 0;
         while(i < cnt)
         {
            ti = this.tabView.getTabAt(i);
            doc = IDocument(ti.data);
            if(doc.isModified)
            {
               docs.push(ti.title);
            }
            i = Number(i) + 1;
         }
         if(docs.length == 0)
         {
            if(callback != null)
            {
               callback(0);
            }
            return;
         }
         SaveConfirmDialog(this._editorWindow.getDialog(SaveConfirmDialog)).open(docs,function(param1:int):void
         {
            var _loc3_:TabItem = null;
            var _loc2_:IDocument = null;
            if(param1 == 0)
            {
               i = 0;
               while(i < cnt)
               {
                  _loc3_ = tabView.getTabAt(i);
                  _loc2_ = IDocument(_loc3_.data);
                  if(_loc2_.isModified)
                  {
                     saveDocument(_loc2_);
                  }
                  i = Number(i) + 1;
               }
               if(callback != null)
               {
                  callback(param1);
               }
            }
            else if(param1 == 1)
            {
               if(callback != null)
               {
                  callback(param1);
               }
            }
            else if(callback != null)
            {
               callback(param1);
            }
         });
      }
      
      public function hasUnsavedDocuments() : Boolean
      {
         var _loc1_:TabItem = null;
         var _loc2_:IDocument = null;
         var _loc4_:int = this.tabView.tabCount;
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = this.tabView.getTabAt(_loc3_);
            _loc2_ = IDocument(_loc1_.data);
            if(_loc2_.isModified)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function updateTab(param1:String, param2:String, param3:String, param4:Boolean) : void
      {
         this.tabView.updateTab(param1,param2,param3,param4);
      }
      
      public function saveState(param1:Object) : void
      {
         var _loc2_:TabItem = null;
         var _loc3_:ComDocument = null;
         var _loc6_:Array = [];
         var _loc4_:int = this.tabView.tabCount;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = this.tabView.getTabAt(_loc5_);
            _loc3_ = _loc2_.data as ComDocument;
            if(_loc3_ != null)
            {
               _loc6_.push(_loc3_.editingTarget.owner.id);
               _loc6_.push(_loc3_.editingTarget.id);
            }
            _loc5_++;
         }
         param1.docs = _loc6_;
         if(this._activeDoc != null && this._activeDoc is ComDocument)
         {
            param1.active_doc = [ComDocument(this._activeDoc).editingTarget.owner.id,ComDocument(this._activeDoc).editingTarget.id];
         }
         else
         {
            param1.active_doc = null;
         }
      }
      
      public function restoreState(param1:WorkSpace) : void
      {
         var _loc7_:int = 0;
         var _loc2_:ComDocument = null;
         var _loc3_:EUIPackage = null;
         var _loc5_:EPackageItem = null;
         var _loc4_:ComDocument = null;
         this._openingAll = true;
         var _loc8_:Array = param1.docs;
         var _loc6_:int = _loc8_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = this._editorWindow.project.getPackage(_loc8_[_loc7_]);
            if(_loc3_)
            {
               _loc5_ = _loc3_.getItem(_loc8_[_loc7_ + 1]);
               if(_loc5_)
               {
                  _loc2_ = this.openDocument(_loc5_,false);
               }
            }
            _loc7_ = _loc7_ + 2;
         }
         this._openingAll = false;
         _loc8_ = param1.active_doc;
         if(_loc8_)
         {
            _loc3_ = this._editorWindow.project.getPackage(_loc8_[0]);
            if(_loc3_)
            {
               _loc4_ = this.findComDocument(_loc3_,_loc8_[1]);
               if(_loc4_)
               {
                  _loc2_ = null;
                  this.activeDocument = _loc4_;
               }
            }
         }
         if(_loc2_)
         {
            this.activeDocument = _loc2_;
         }
      }
      
      public function tabChanged(param1:TabItem) : void
      {
         var _loc2_:IDocument = IDocument(param1.data);
         if(_loc2_ != this._activeDoc)
         {
            if(this._activeDoc)
            {
               this._activeDoc.deactivate();
            }
            this._activeDoc = _loc2_;
            this.docContainer.removeChildren();
            if(this._activeDoc)
            {
               this.docContainer.addChild(this._activeDoc as GComponent);
               this._activeDoc.activate();
            }
            else
            {
               this.cleanupRelatedPanels();
               this._groupPathBar.visible = false;
            }
         }
      }
      
      public function tabWillClose(param1:TabItem) : Boolean
      {
         var _loc2_:IDocument = IDocument(param1.data);
         if(_loc2_.isModified)
         {
            this.queryToCloseDocument(_loc2_);
            return false;
         }
         return true;
      }
      
      public function tabClosed(param1:TabItem) : void
      {
         var _loc2_:IDocument = IDocument(param1.data);
         this.doCloseDocument(_loc2_);
      }
      
      private function doCloseDocument(param1:IDocument) : void
      {
         if(param1 == this._activeDoc)
         {
            this._activeDoc.deactivate();
            this._activeDoc = null;
            this.docContainer.removeChildren();
            this.cleanupRelatedPanels();
         }
         param1.release();
         this._docCache.push(param1);
         if(this.tabView.tabCount == 0)
         {
            this._editorWindow.mainPanel.propsPanelList.refresh();
            this._groupPathBar.visible = false;
            this._editorWindow.mainPanel.toolbox.visible = false;
         }
      }
      
      public function cleanupRelatedPanels() : void
      {
         this.controllerPanel.clear();
         this.transitionListPanel.clear();
         this._editorWindow.mainPanel.childrenPanel.update(null);
      }
      
      public function updateControllerPanel(param1:EController = null) : void
      {
         if(this._activeDoc != null)
         {
            if(param1 != null)
            {
               this.controllerPanel.refresh(param1);
            }
            else
            {
               this.controllerPanel.update(ComDocument(this._activeDoc).editingContent);
            }
         }
      }
      
      public function updateControllerSelection(param1:EController) : void
      {
         this.controllerPanel.updateSelection(param1);
      }
      
      public function updateTransitionListPanel() : void
      {
         if(this._activeDoc != null)
         {
            this.transitionListPanel.update(ComDocument(this._activeDoc).editingContent);
         }
      }
      
      public function updateGroupPathList(param1:EGGroup) : void
      {
         var _loc2_:GButton = null;
         if(!(this._activeDoc is ComDocument))
         {
            this._groupPathBar.visible = false;
            return;
         }
         var _loc5_:int = 0;
         var _loc3_:* = param1;
         while(_loc3_ != null)
         {
            _loc5_++;
            _loc3_ = _loc3_.groupInst;
         }
         if(_loc5_ == 0)
         {
            this._groupPathBar.visible = false;
            return;
         }
         this._groupPathBar.visible = true;
         this._groupPathList.removeChildrenToPool();
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = this._groupPathList.addItemFromPool().asButton;
            _loc2_.icon = Icons.all.group;
            _loc2_.name = "" + (_loc5_ - _loc4_);
            _loc4_++;
         }
         this._groupPathList.resizeToFit();
      }
      
      public function enterEditingTrans() : void
      {
         this.self.getController("trans").selectedIndex = 1;
      }
      
      public function leaveEditingTrans() : void
      {
         this.self.getController("trans").selectedIndex = 0;
      }
      
      public function refreshDocument() : void
      {
         if(this._activeDoc)
         {
            this._activeDoc.refresh();
         }
      }
      
      private function __clickGroupBtn(param1:ItemEvent) : void
      {
         var _loc2_:int = param1.itemObject.name;
         ComDocument(this._activeDoc).closeGroup(_loc2_);
      }
      
      private function __editTypeChanged(param1:Event) : void
      {
         if(this._editTypeCtrller.selectedIndex == 1)
         {
            this._editorWindow.cursorManager.setCursorForObject(this.docContainer.displayObject,CursorManager.HAND,this.__docContainerRangeDetector,true);
         }
         else
         {
            this._editorWindow.cursorManager.setCursorForObject(this.docContainer.displayObject,null,null,true);
         }
      }
      
      public function onBgColorChanged() : void
      {
         var _loc1_:TabItem = null;
         this.self.getChild("docBg").asGraph.drawRect(0,0,0,this._editorWindow.mainPanel.bgColor,1);
         var _loc3_:int = this.tabView.tabCount;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.tabView.getTabAt(_loc2_);
            if(_loc1_.data is ComDocument)
            {
               ComDocument(_loc1_.data).onBgColorChanged();
            }
            _loc2_++;
         }
      }
      
      public function onViewScaleChanged() : void
      {
         if(this._activeDoc is ComDocument)
         {
            ComDocument(this._activeDoc).onViewScaleChanged();
         }
      }
      
      private function __docContainerRangeDetector() : Boolean
      {
         if(this.docContainer.displayObject.mouseX < this.docContainer.viewWidth && this.docContainer.displayObject.mouseY < this.docContainer.viewHeight)
         {
            return true;
         }
         return false;
      }
      
      private function __rightClickTabs(param1:Event) : void
      {
         this._tabMenu.setItemGrayed("close",this.tabView.tabCount == 0);
         this._tabMenu.setItemGrayed("closeOthers",this.tabView.tabCount < 2);
         this._tabMenu.setItemGrayed("closeAll",this.tabView.tabCount == 0);
         this._tabMenu.show(this._editorWindow.groot,true);
      }
      
      private function __mouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(param1.ctrlKey)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.delta;
            if(_loc2_ < 0)
            {
               this._editorWindow.mainPanel.changeViewScale(false,false);
            }
            else
            {
               this._editorWindow.mainPanel.changeViewScale(true,false);
            }
         }
      }
   }
}

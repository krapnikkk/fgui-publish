package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ChildObjectInput;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.ERelationDef;
   import fairygui.editor.gui.ERelationItem;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class RelationPropsPanel extends PropsPanel
   {
      
      private static var SIDE_NAMES:Object;
      
      private static var SIDE_PAIRS:Array;
       
      
      private var _list:GList;
      
      private var _menu:GComponent;
      
      private var _activeButton:GButton;
      
      public function RelationPropsPanel(param1:EditorWindow, param2:String)
      {
         if(SIDE_NAMES == null)
         {
            SIDE_NAMES = {
               "left":Consts.g.text247,
               "center":Consts.g.text248,
               "right":Consts.g.text249,
               "top":Consts.g.text250,
               "middle":Consts.g.text251,
               "bottom":Consts.g.text252,
               "width":Consts.g.text253,
               "height":Consts.g.text254,
               "leftext":Consts.g.text255,
               "rightext":Consts.g.text256,
               "topext":Consts.g.text257,
               "bottomext":Consts.g.text258,
               "center2":Consts.g.text259,
               "middle2":Consts.g.text260
            };
            SIDE_PAIRS = ["left-left","left-center","left-right","center-center","right-left","right-center","right-right","leftext-left","leftext-right","rightext-left","rightext-right","width-width","top-top","top-middle","top-bottom","middle-middle","bottom-top","bottom-middle","bottom-bottom","topext-top","topext-bottom","bottomext-top","bottomext-bottom","height-height"];
         }
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this._list = getChild("list").asList;
         this._list.removeChildrenToPool();
         this._menu = UIPackage.createObject("Builder","RelationTypePopup").asCom;
         this._menu.getChild("list").addEventListener("itemClick",this.__clickSide);
         this._menu.getChild("percent").addClickListener(this.__clickPercent);
         this._menu.getChild("clear").addClickListener(this.__clickClear);
         this.setupMenu();
      }
      
      private function setupMenu() : void
      {
         var _loc4_:String = null;
         var _loc1_:int = 0;
         var _loc2_:GButton = null;
         var _loc6_:GList = this._menu.getChild("list").asList;
         var _loc5_:int = SIDE_PAIRS.length;
         var _loc3_:int = 0;
         while(_loc3_ < SIDE_PAIRS.length)
         {
            _loc4_ = SIDE_PAIRS[_loc3_];
            _loc1_ = _loc4_.indexOf("-");
            _loc2_ = _loc6_.addItemFromPool().asButton;
            _loc2_.data = _loc4_;
            if(_loc4_ == "center-center")
            {
               _loc2_.text = SIDE_NAMES.center2;
            }
            else if(_loc4_ == "middle-middle")
            {
               _loc2_.text = SIDE_NAMES.middle2;
            }
            else
            {
               _loc2_.text = SIDE_NAMES[_loc4_.substr(0,_loc1_)] + "->" + SIDE_NAMES[_loc4_.substr(_loc1_ + 1)];
            }
            _loc3_++;
         }
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc2_:ERelationItem = null;
         this._list.removeChildrenToPool();
         var _loc4_:Vector.<ERelationItem> = _object.relations.items;
         var _loc3_:int = _loc4_.length;
         var _loc1_:int = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = _loc4_[_loc1_];
            if(!_loc2_.readOnly)
            {
               this.addItem(_loc2_);
            }
            _loc1_++;
         }
         this.addItem(null);
         this._list.resizeToFit();
         if(this.expanded)
         {
            this.height = this._list.height + 32;
         }
         else
         {
            _savedHeight = this._list.height + 32;
         }
      }
      
      private function addItem(param1:ERelationItem) : void
      {
         var _loc6_:String = null;
         var _loc5_:int = 0;
         var _loc2_:ERelationDef = null;
         var _loc3_:GButton = null;
         var _loc4_:GButton = this._list.addItemFromPool().asButton;
         if(param1 != null)
         {
            ChildObjectInput(_loc4_.getChild("target")).value = param1.target;
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
               _loc2_ = param1.defs[_loc5_];
               _loc3_ = _loc4_.getChild("r" + _loc5_).asButton;
               _loc3_.data = _loc2_.toString();
               if(_loc2_.valid)
               {
                  if(_loc2_.selfSide == "center" && _loc2_.targetSide == "center")
                  {
                     _loc3_.title = SIDE_NAMES.center2 + (!!_loc2_.percent?" %":"");
                  }
                  else if(_loc2_.selfSide == "middle" && _loc2_.targetSide == "middle")
                  {
                     _loc3_.title = SIDE_NAMES.middle2 + (!!_loc2_.percent?" %":"");
                  }
                  else
                  {
                     _loc3_.title = SIDE_NAMES[_loc2_.selfSide] + "->" + SIDE_NAMES[_loc2_.targetSide] + (!!_loc2_.percent?" %":"");
                  }
               }
               else
               {
                  _loc3_.title = Consts.g.text26;
               }
               _loc5_++;
            }
            _loc4_.getChild("r0").enabled = true;
            _loc4_.getChild("r1").enabled = true;
         }
         else
         {
            ChildObjectInput(_loc4_.getChild("target")).value = null;
            _loc4_.getChild("r0").data = "";
            _loc4_.getChild("r1").data = "";
            _loc4_.getChild("r0").text = Consts.g.text26;
            _loc4_.getChild("r1").text = Consts.g.text26;
            _loc4_.getChild("r0").enabled = false;
            _loc4_.getChild("r1").enabled = false;
         }
         _loc4_.getChild("target").addEventListener("__submit",this.__targetChanged);
         _loc4_.getChild("clear").addClickListener(this.__clearObject);
         _loc4_.getChild("setToParent").addClickListener(this.__clickSetToParent);
         _loc4_.getChild("r0").addClickListener(this.__clickSidePair);
         _loc4_.getChild("r1").addClickListener(this.__clickSidePair);
         _loc4_.data = param1;
      }
      
      private function __targetChanged(param1:Event) : void
      {
         var _loc5_:GButton = GButton(param1.currentTarget.parent);
         var _loc3_:ERelationItem = ERelationItem(_loc5_.data);
         var _loc4_:EGObject = ChildObjectInput(param1.currentTarget).value;
         var _loc2_:String = _loc5_.getChild("r0").data + "," + _loc5_.getChild("r1").data;
         this.updateRelationItem(_loc3_,_loc4_,_loc2_);
      }
      
      private function __clearObject(param1:Event) : void
      {
         var _loc3_:GButton = GButton(param1.currentTarget.parent);
         var _loc2_:ERelationItem = ERelationItem(_loc3_.data);
         if(_loc2_ != null)
         {
            this.updateRelationItem(_loc2_,null,null);
         }
      }
      
      private function updateRelationItem(param1:ERelationItem, param2:EGObject, param3:String) : void
      {
         var _loc5_:XML = _object.relations.toXML();
         if(param2 == null)
         {
            _object.relations.removeItem(param1);
         }
         else if(param1 == null)
         {
            _object.relations.addItem(param2,param3);
         }
         else
         {
            param1.set(param2,param3);
         }
         var _loc4_:XML = _object.relations.toXML();
         _editorWindow.activeComDocument.actionHistory.action_relationSet(_object,_loc5_,_loc4_);
         this.setObjectToUI();
      }
      
      private function __clickSidePair(param1:Event) : void
      {
         var _loc3_:GButton = null;
         this._activeButton = GButton(param1.currentTarget);
         var _loc6_:GList = this._menu.getChild("list").asList;
         this._menu.getChild("percent").asButton.selected = UtilsStr.endsWith(String(this._activeButton.data),"%");
         _loc6_.selectedIndex = -1;
         this.root.showPopup(this._menu);
         var _loc4_:* = _object.parent == null;
         var _loc5_:int = _loc6_.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = _loc6_.getChildAt(_loc2_).asButton;
            if(_loc2_ >= 10 && _loc2_ <= 11 || _loc2_ >= 22 && _loc2_ <= 23)
            {
               _loc3_.grayed = false;
            }
            else
            {
               _loc3_.grayed = _loc4_;
            }
            _loc2_++;
         }
      }
      
      private function __clickSide(param1:ItemEvent) : void
      {
         if(param1.itemObject.grayed)
         {
            return;
         }
         this.root.hidePopup(this._menu);
         var _loc3_:String = String(param1.itemObject.data);
         var _loc2_:Boolean = this._menu.getChild("percent").asButton.selected;
         _loc3_ = _loc3_ + (!!_loc2_?"%":"");
         if(_loc3_ == this._activeButton.data)
         {
            return;
         }
         this._activeButton.title = param1.itemObject.text + (!!_loc2_?" %":"");
         this._activeButton.data = _loc3_;
         this.submit(this._activeButton.parent);
      }
      
      private function __clickPercent(param1:Event) : void
      {
         this.root.hidePopup(this._menu);
         var _loc3_:String = String(this._activeButton.data);
         if(!_loc3_)
         {
            return;
         }
         var _loc2_:Boolean = this._menu.getChild("percent").asButton.selected;
         if(_loc2_)
         {
            this._activeButton.data = _loc3_ + "%";
            _loc3_ = this._activeButton.title;
            this._activeButton.title = _loc3_ + " %";
         }
         else
         {
            this._activeButton.data = _loc3_.substr(0,_loc3_.length - 1);
            _loc3_ = this._activeButton.title;
            this._activeButton.title = _loc3_.substr(0,_loc3_.length - 2);
         }
         this.submit(this._activeButton.parent);
      }
      
      private function __clickClear(param1:Event) : void
      {
         this.root.hidePopup(this._menu);
         var _loc2_:String = String(this._activeButton.data);
         if(!_loc2_)
         {
            return;
         }
         this._activeButton.data = "";
         this.submit(this._activeButton.parent);
      }
      
      private function __clickSetToParent(param1:Event) : void
      {
         if(_object.parent == null)
         {
            return;
         }
         var _loc2_:ERelationItem = ERelationItem(GComponent(param1.currentTarget.parent).data);
         this.updateRelationItem(_loc2_,_object.parent,!!_loc2_?_loc2_.sidePair:"");
      }
      
      private function submit(param1:GComponent) : void
      {
         var _loc5_:ERelationItem = ERelationItem(param1.data);
         var _loc3_:String = param1.getChild("r0").data + "," + param1.getChild("r1").data;
         var _loc4_:XML = _object.relations.toXML();
         _loc5_.set(_loc5_.target,_loc3_);
         var _loc2_:XML = _object.relations.toXML();
         _editorWindow.activeComDocument.actionHistory.action_relationSet(_object,_loc4_,_loc2_);
         this.setObjectToUI();
      }
   }
}

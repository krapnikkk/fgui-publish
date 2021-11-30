package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.GObjectPool;
   import fairygui.PopupMenu;
   import fairygui.UIPackage;
   import fairygui.editor.extui.CursorManager;
   import fairygui.editor.extui.DropEvent;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.ETransition;
   import fairygui.editor.gui.ETransitionItem;
   import fairygui.editor.gui.ETransitionValue;
   import fairygui.editor.props.SelectObjectPanel;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.DragEvent;
   import fairygui.event.GTouchEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TimelinePanel extends EventDispatcher
   {
      
      private static var _copiedTimeline:XML;
      
      private static var _copiedFrame:ETransitionValue;
      
      public static var headBitmapDatas:Array;
      
      public static var frameBitmapDatas:Array;
      
      public static const FRAME_RATE:Number = 24;
      
      public static const INIT_WIDTH:int = 8000;
      
      public static const MAX_WIDTH:int = 16000;
      
      public static const EACH_WIDTH:int = 2000;
       
      
      public var self:GComponent;
      
      private var _inner:GComponent;
      
      private var _list:GList;
      
      private var _nameList:GList;
      
      private var _head:GObject;
      
      private var _frameMenu:PopupMenu;
      
      private var _timelineMenu:PopupMenu;
      
      private var _frameNumText:GObject;
      
      private var _timeText:GObject;
      
      private var _resizer:GObject;
      
      private var _prompt:GObject;
      
      private var _editorWindow:EditorWindow;
      
      private var _curWidth:int;
      
      private var _selections:Vector.<TimelineSelection>;
      
      private var _selectionContainer:GComponent;
      
      private var _selectionObjPool:GObjectPool;
      
      private var _firstSelection:TimelineSelection;
      
      private var _handlingSelection:Boolean;
      
      private var _draggingIndicator:GObject;
      
      private var _draggingSelection:Boolean;
      
      private var _dragStartPos:int;
      
      private var _syncingScrollPos:Boolean;
      
      public function TimelinePanel(param1:EditorWindow, param2:GComponent, param3:GObject)
      {
         param1 = param1;
         param2 = param2;
         param3 = param3;
         var btn:GButton = null;
         var win:EditorWindow = param1;
         var panel:GComponent = param2;
         var resizer:GObject = param3;
         super();
         if(headBitmapDatas == null)
         {
            createBitmaps();
         }
         this.self = panel;
         this._resizer = resizer;
         this._editorWindow = win;
         this._curWidth = 8000;
         this._selections = new Vector.<TimelineSelection>();
         this._inner = this.self.getChild("inner").asCom;
         this._list = this.self.getChild("list").asList;
         this._list.autoResizeItem = false;
         this._list.draggable = true;
         this._list.addEventListener("clickGTouch",this.__clickList);
         this._list.addEventListener("startDrag",this.__dragStart);
         this._list.addEventListener("rightClick",this.__rightClickList);
         this._list.scrollPane.addEventListener("scroll",this.__onListScroll);
         this._nameList = this.self.getChild("nameList").asList;
         this._nameList.addClickListener(this.__clickNameList);
         this._nameList.addEventListener("rightClick",this.__rightClickNameList);
         this._nameList.scrollPane.addEventListener("scroll",this.__onNameListScroll);
         var gcom:GComponent = this.self.getChild("selContainer").asCom;
         this._selectionContainer = new GComponent();
         gcom.addChild(this._selectionContainer);
         this._selectionObjPool = new GObjectPool();
         this._firstSelection = new TimelineSelection();
         this._draggingIndicator = UIPackage.createObject("Builder","TimelineSelection2");
         this._head = this._inner.getChild("head");
         this._head.touchable = false;
         this._frameNumText = this.self.getChild("frame");
         this._timeText = this.self.getChild("time");
         this.drawNums();
         this._frameMenu = new PopupMenu();
         this._frameMenu.contentPane.width = 210;
         btn = this._frameMenu.addItem(Consts.g.text217,this.__menuSetKeyFrame);
         btn.name = "setKeyFrame";
         btn.getChild("shortcut").text = "Ctrl+K";
         btn = this._frameMenu.addItem(Consts.g.text227,this.__menuClearKeyFrame);
         btn.name = "clearKeyFrame";
         btn = this._frameMenu.addItem(Consts.g.text298,this.__menuAddFrame);
         btn.name = "addFrame";
         btn.getChild("shortcut").text = "Ctrl+I";
         btn = this._frameMenu.addItem(Consts.g.text218,this.__menuRemoveFrame);
         btn.name = "removeFrame";
         btn.getChild("shortcut").text = "Ctrl+D";
         this._frameMenu.addSeperator();
         this._frameMenu.addItem(Consts.g.text265,this.__menuAddTween).name = "addTween";
         this._frameMenu.addItem(Consts.g.text266,this.__menuRemoveTween).name = "removeTween";
         this._timelineMenu = new PopupMenu();
         this._timelineMenu.contentPane.width = 210;
         this._timelineMenu.addItem(Consts.g.text299,this.__menuCopyTimeline);
         this._timelineMenu.addItem(Consts.g.text300,this.__menuPasteTimeline).name = "paste";
         this._timelineMenu.addItem(Consts.g.text219,this.__menuDeleteTimeline);
         this._timelineMenu.addItem(Consts.g.text340,this.__menuChangeTimelineTarget).name = "changeTarget";
         this.self.getChild("numBar").addClickListener(this.__clickNumBar);
         this.self.getChild("numBar").addEventListener("dragGTouch",this.__clickNumBar);
         this.self.addEventListener("__drop",this.__drop);
         this._resizer.draggable = true;
         this._editorWindow.cursorManager.setCursorForObject(this._resizer.displayObject,CursorManager.V_RESIZE);
         var pt:Point = this.self.localToGlobal(0,100);
         var pt2:Point = this.self.parent.localToGlobal(0,this.self.parent.height);
         var rect:Rectangle = new Rectangle(pt.x,pt.y,pt.x,pt2.y - 100);
         this._resizer.dragBounds = rect;
         this.self.parent.addSizeChangeCallback(function():void
         {
            _resizer.dragBounds.height = self.parent.localToGlobal(0,self.parent.height).y - _resizer.dragBounds.y - 100;
            if(_resizer.visible)
            {
               if(_resizer.y > self.parent.height - 100)
               {
                  _resizer.y = self.parent.height - 100;
               }
               if(_resizer.y < self.y + 100)
               {
                  _resizer.y = self.y + 100;
               }
            }
         });
         this._prompt = this.self.getChild("prompt");
      }
      
      public static function createBitmaps() : void
      {
         var _loc10_:int = 0;
         var _loc9_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:BitmapData = null;
         var _loc8_:Matrix = new Matrix();
         var _loc3_:BitmapData = new BitmapData(1,3,false,0);
         _loc3_.setPixel(0,0,8421248);
         _loc3_.setPixel(0,1,8421248);
         _loc3_.setPixel(0,2,8421248);
         var _loc6_:int = 8;
         headBitmapDatas = new Array(_loc6_);
         _loc7_ = Math.ceil(2000 / 10);
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            _loc1_ = new BitmapData(2000,18,true,0);
            headBitmapDatas[_loc10_] = _loc1_;
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc8_.identity();
               _loc8_.translate(_loc9_ * 10 - 1,15);
               _loc1_.draw(_loc3_,_loc8_);
               _loc9_++;
            }
            _loc10_++;
         }
         var _loc5_:BitmapData = new BitmapData(11,19,false,4802889);
         _loc10_ = 0;
         while(_loc10_ < _loc5_.height)
         {
            _loc5_.setPixel(0,_loc10_,5592405);
            _loc5_.setPixel(10,_loc10_,5592405);
            _loc10_++;
         }
         var _loc4_:BitmapData = new BitmapData(11,19,false,4539717);
         _loc10_ = 0;
         while(_loc10_ < _loc4_.height)
         {
            _loc4_.setPixel(0,_loc10_,5592405);
            _loc4_.setPixel(10,_loc10_,5592405);
            _loc10_++;
         }
         frameBitmapDatas = new Array(_loc6_);
         var _loc2_:int = 6;
         _loc7_ = Math.ceil(2000 / 10);
         _loc10_ = 0;
         while(_loc10_ < 10)
         {
            _loc1_ = new BitmapData(2000,19,true,0);
            frameBitmapDatas[_loc10_] = _loc1_;
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc8_.identity();
               _loc8_.translate(_loc9_ * 10 - 1,0);
               if(_loc9_ % _loc2_ == 0)
               {
                  _loc1_.draw(_loc4_,_loc8_);
               }
               else
               {
                  _loc1_.draw(_loc5_,_loc8_);
               }
               _loc9_++;
            }
            _loc10_++;
         }
      }
      
      public function show(param1:ComDocument) : void
      {
         if(isNaN(param1.editingTransition.timelinePanelHeight))
         {
            param1.editingTransition.timelinePanelHeight = 150;
         }
         this._resizer.y = this.self.y + param1.editingTransition.timelinePanelHeight;
         if(this._resizer.y > this.self.parent.height - 100)
         {
            this._resizer.y = this.self.parent.height - 100;
         }
         if(this._resizer.y < this.self.y + 100)
         {
            this._resizer.y = this.self.y + 100;
         }
         this._resizer.height = 4;
         this._resizer.visible = true;
         this.self.visible = true;
         this._list.scrollPane.percX = 0;
         this._list.scrollPane.percY = 0;
         this.head = 0;
         this.refreshTimelines();
      }
      
      public function hide(param1:ComDocument = null) : void
      {
         if(param1 != null)
         {
            param1.editingTransition.timelinePanelHeight = this._resizer.y - this.self.y;
         }
         this._resizer.y = this.self.y;
         this._resizer.height = 0;
         this._resizer.visible = false;
         this.self.visible = false;
      }
      
      public function get head() : int
      {
         return this._head.x / 10;
      }
      
      public function set head(param1:int) : void
      {
         this._head.x = param1 * 10;
         this._frameNumText.text = "" + param1;
         this._timeText.text = UtilsStr.toFixed(param1 / 24) + "s";
      }
      
      public function onSelectObject(param1:EGObject) : void
      {
         var _loc5_:int = 0;
         var _loc3_:ETransitionItem = null;
         var _loc4_:TimelineSelection = null;
         var _loc2_:TimelineComponent = null;
         if(this._handlingSelection)
         {
            return;
         }
         if(param1 != null)
         {
            _loc5_ = this.head;
            var _loc7_:int = 0;
            var _loc6_:* = this._selections;
            for each(_loc4_ in this._selections)
            {
               if(_loc4_.timeline.targetId == param1.id)
               {
                  return;
               }
            }
            _loc2_ = this.getTimeline(param1.id,"*");
            if(_loc2_ != null)
            {
               this.addSelection(_loc2_,_loc5_,0,true);
            }
         }
         else
         {
            this.clearSelection(true);
         }
      }
      
      public function get onKeyFrame() : Boolean
      {
         return this._selections.length > 0 && this._selections[this._selections.length - 1].timeline.hasKeyFrame(this.head);
      }
      
      public function createTimeline(param1:String, param2:String) : void
      {
         var _loc6_:ComDocument = null;
         var _loc3_:ETransition = null;
         var _loc4_:ETransitionItem = null;
         var _loc5_:TimelineComponent = this.getTimeline(param1,param2);
         if(_loc5_ == null)
         {
            _loc5_ = this.addTimeline(param1,param2);
            this.sortTimelines();
         }
         if(!_loc5_.hasKeyFrame(this.head))
         {
            _loc6_ = this._editorWindow.activeComDocument;
            _loc3_ = _loc6_.editingTransition;
            _loc4_ = _loc3_.createItem(param1,param2,this.head);
            _loc6_.actionHistory.action_transItemAdd(_loc4_);
            this.refreshTimeline(_loc5_);
            this.addSelection(_loc5_,this.head);
            _loc6_.setModified();
            _loc6_.setTimelineUpdateFlag();
         }
      }
      
      public function createTimelines(param1:Vector.<String>, param2:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:TimelineComponent = null;
         var _loc5_:ETransitionItem = null;
         var _loc6_:ComDocument = this._editorWindow.activeComDocument;
         var _loc7_:ETransition = _loc6_.editingTransition;
         var _loc9_:int = 0;
         var _loc8_:* = param1;
         for each(_loc3_ in param1)
         {
            _loc4_ = this.getTimeline(_loc3_,param2);
            if(_loc4_ == null)
            {
               _loc4_ = this.addTimeline(_loc3_,param2);
            }
            if(!_loc4_.hasKeyFrame(this.head))
            {
               _loc5_ = _loc7_.createItem(_loc3_,param2,this.head);
               _loc6_.actionHistory.action_transItemAdd(_loc5_);
               this.refreshTimeline(_loc4_);
               this.addSelection(_loc4_,this.head);
            }
         }
         _loc6_.setModified();
         _loc6_.setTimelineUpdateFlag();
      }
      
      public function refreshTimeline(param1:TimelineComponent) : void
      {
         var _loc2_:ETransitionItem = null;
         param1.reset();
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         var _loc3_:ETransition = _loc5_.editingTransition;
         var _loc4_:Vector.<ETransitionItem> = _loc3_.items;
         var _loc7_:int = 0;
         var _loc6_:* = _loc4_;
         for each(_loc2_ in _loc4_)
         {
            if(param1.targetId == _loc2_.targetId && param1.type == _loc2_.type)
            {
               param1.setKeyFrame(_loc2_.frame,_loc2_);
               if(_loc2_.nextItem)
               {
                  param1.setTween(_loc2_.frame,_loc2_.nextItem.frame);
               }
            }
         }
      }
      
      public function refreshTimeline2(param1:String, param2:String) : void
      {
         var _loc3_:TimelineComponent = this.getTimeline(param1,param2);
         if(_loc3_)
         {
            this.refreshTimeline(_loc3_);
         }
      }
      
      public function getTimeline(param1:String, param2:String) : TimelineComponent
      {
         var _loc3_:TimelineComponent = null;
         var _loc4_:int = this._list.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = TimelineComponent(this._list.getChildAt(_loc5_));
            if(_loc3_.targetId == param1 && (_loc3_.type == param2 || param2 == "*"))
            {
               return _loc3_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function get selectedTimeline() : TimelineComponent
      {
         if(this._selections.length > 0)
         {
            return this._selections[this._selections.length - 1].timeline;
         }
         return null;
      }
      
      private function addTimeline(param1:String, param2:String) : TimelineComponent
      {
         var _loc7_:String = null;
         var _loc8_:* = null;
         var _loc6_:EGObject = null;
         var _loc3_:ComDocument = this._editorWindow.activeComDocument;
         var _loc4_:GButton = this._nameList.addItemFromPool().asButton;
         if(param1)
         {
            _loc6_ = _loc3_.editingContent.getChildById(param1);
            _loc4_.title = _loc6_.toString();
            _loc4_.icon = Icons.all[_loc6_.objectType];
         }
         else
         {
            _loc4_.title = Consts.g.text170;
            _loc4_.icon = Icons.all[_loc3_.editingContent.objectType];
         }
         if(param2 == "Rotation")
         {
            _loc8_ = "Rot";
         }
         else if(param2 == "Animation")
         {
            _loc8_ = "Ani";
         }
         else if(param2 == "Transition")
         {
            _loc8_ = "Trans";
         }
         else if(param2 == "Controller")
         {
            _loc8_ = "Ctrl";
         }
         else if(param2 == "Visible")
         {
            _loc8_ = "Vis";
         }
         else if(param2 == "ColorFilter")
         {
            _loc8_ = "Filter";
         }
         else
         {
            _loc8_ = param2;
         }
         _loc4_.getChild("type").text = _loc8_;
         this._prompt.visible = false;
         var _loc5_:TimelineComponent = TimelineComponent(this._list.addItemFromPool());
         _loc5_.targetId = param1;
         _loc5_.type = param2;
         _loc5_.width = this._curWidth;
         _loc5_.reset();
         return _loc5_;
      }
      
      public function refreshTimelines() : void
      {
         var _loc3_:TimelineComponent = null;
         var _loc1_:ETransitionItem = null;
         this.clearSelection(false,true);
         this._list.removeChildrenToPool();
         this._nameList.removeChildrenToPool();
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         var _loc4_:ETransition = _loc5_.editingTransition;
         var _loc2_:Vector.<ETransitionItem> = _loc4_.items;
         var _loc7_:int = 0;
         var _loc6_:* = _loc2_;
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.valid)
            {
               _loc3_ = this.getTimeline(_loc1_.targetId,_loc1_.type);
               if(_loc3_ == null)
               {
                  _loc3_ = this.addTimeline(_loc1_.targetId,_loc1_.type);
               }
               _loc3_.setKeyFrame(_loc1_.frame,_loc1_);
               if(_loc1_.nextItem)
               {
                  _loc3_.setTween(_loc1_.frame,_loc1_.nextItem.frame);
               }
            }
         }
         this.sortTimelines();
         _loc5_.setTimelineUpdateFlag();
         this._prompt.visible = this._list.numChildren == 0;
      }
      
      private function sortTimelines() : void
      {
         var _loc2_:TimelineComponent = null;
         var _loc4_:Array = [];
         var _loc3_:int = this._list.numChildren;
         var _loc1_:int = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = TimelineComponent(this._list.getChildAt(_loc1_));
            _loc2_.data = _loc1_;
            _loc4_.push(_loc2_);
            _loc1_++;
         }
         _loc4_.sortOn(["targetId","type"]);
         this._list.removeChildren();
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this._list.addChild(_loc4_[_loc1_]);
            _loc1_++;
         }
         this._list.setBoundsChangedFlag();
         _loc3_ = this._nameList.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc4_[_loc1_] = this._nameList.getChildAt(_loc1_);
            _loc1_++;
         }
         this._nameList.removeChildren();
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this._nameList.addChild(_loc4_[int(this._list.getChildAt(_loc1_).data)]);
            _loc1_++;
         }
         this._nameList.setBoundsChangedFlag();
      }
      
      public function removeTimeline(param1:String, param2:String) : void
      {
         var _loc4_:TimelineComponent = this.getTimeline(param1,param2);
         this.removeSelection(_loc4_);
         this._nameList.selectedIndex = -1;
         var _loc5_:int = this._list.getChildIndex(_loc4_);
         this._list.removeChildToPool(_loc4_);
         this._nameList.removeChildToPoolAt(_loc5_);
         this._prompt.visible = this._list.numChildren == 0;
         var _loc3_:ComDocument = this._editorWindow.activeComDocument;
         _loc3_.setTimelineUpdateFlag();
      }
      
      public function setKeyFrame() : void
      {
         var _loc2_:TimelineSelection = null;
         var _loc3_:int = 0;
         var _loc1_:ETransitionItem = null;
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         var _loc4_:ETransition = _loc5_.editingTransition;
         var _loc7_:int = 0;
         var _loc6_:* = this._selections;
         for each(_loc2_ in this._selections)
         {
            _loc3_ = _loc2_.start;
            while(_loc3_ <= _loc2_.end)
            {
               if(!_loc2_.timeline.hasKeyFrame(_loc3_))
               {
                  _loc1_ = _loc4_.createItem(_loc2_.timeline.targetId,_loc2_.timeline.type,_loc3_);
                  _loc5_.actionHistory.action_transItemAdd(_loc1_);
               }
               _loc3_++;
            }
         }
         _loc4_.arrangeItems();
         var _loc9_:int = 0;
         var _loc8_:* = this._selections;
         for each(_loc2_ in this._selections)
         {
            this.refreshTimeline(_loc2_.timeline);
         }
         _loc5_.setModified();
         _loc5_.setTimelineUpdateFlag();
      }
      
      public function clearKeyFrame() : void
      {
         var _loc2_:TimelineSelection = null;
         var _loc3_:int = 0;
         var _loc1_:ETransitionItem = null;
         var _loc5_:ComDocument = this._editorWindow.activeComDocument;
         var _loc4_:ETransition = _loc5_.editingTransition;
         var _loc7_:int = 0;
         var _loc6_:* = this._selections;
         for each(_loc2_ in this._selections)
         {
            _loc3_ = _loc2_.start;
            while(_loc3_ <= _loc2_.end)
            {
               if(_loc2_.timeline.hasKeyFrame(_loc3_))
               {
                  _loc1_ = ETransitionItem(_loc2_.timeline.getKeyFrameData(_loc3_));
                  _loc2_.timeline.removeKeyFrame(_loc3_);
                  _loc4_.deleteItem(_loc1_);
                  _loc5_.actionHistory.action_transItemDelete(_loc1_);
               }
               _loc3_++;
            }
         }
         _loc4_.arrangeItems();
         var _loc9_:int = 0;
         var _loc8_:* = this._selections;
         for each(_loc2_ in this._selections)
         {
            this.refreshTimeline(_loc2_.timeline);
         }
         _loc5_.setModified();
         _loc5_.setTimelineUpdateFlag();
      }
      
      public function insertFrame() : void
      {
         var _loc6_:* = 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:ETransitionItem = null;
         var _loc3_:TimelineSelection = null;
         var _loc8_:ComDocument = this._editorWindow.activeComDocument;
         var _loc7_:ETransition = _loc8_.editingTransition;
         var _loc5_:int = _loc7_.items.length;
         var _loc10_:int = 0;
         var _loc9_:* = this._selections;
         for each(_loc3_ in this._selections)
         {
            _loc2_ = _loc3_.timeline.findKeyFrame(_loc3_.start);
            if(_loc2_ >= 0)
            {
               _loc4_ = ETransitionItem(_loc3_.timeline.getKeyFrameData(_loc2_));
               _loc1_ = _loc7_.items.indexOf(_loc4_);
               _loc6_ = _loc1_;
               while(_loc6_ < _loc5_)
               {
                  _loc4_ = _loc7_.items[_loc6_];
                  if(_loc4_.type == _loc3_.timeline.type && _loc4_.targetId == _loc3_.timeline.targetId)
                  {
                     _loc7_.setItemProperty(_loc4_,"frame",_loc4_.frame + 1);
                  }
                  _loc6_++;
               }
               continue;
            }
         }
         _loc7_.arrangeItems();
         var _loc12_:int = 0;
         var _loc11_:* = this._selections;
         for each(_loc3_ in this._selections)
         {
            this.refreshTimeline(_loc3_.timeline);
         }
         _loc8_.setModified();
         _loc8_.setTimelineUpdateFlag();
      }
      
      public function removeFrame() : void
      {
         var _loc6_:TimelineSelection = null;
         var _loc7_:* = 0;
         var _loc1_:ETransitionItem = null;
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc9_:ComDocument = this._editorWindow.activeComDocument;
         var _loc8_:ETransition = _loc9_.editingTransition;
         var _loc11_:int = 0;
         var _loc10_:* = this._selections;
         for each(_loc6_ in this._selections)
         {
            _loc7_ = int(_loc6_.start);
            while(_loc7_ <= _loc6_.end)
            {
               if(_loc6_.timeline.hasKeyFrame(_loc7_))
               {
                  _loc1_ = ETransitionItem(_loc6_.timeline.getKeyFrameData(_loc7_));
                  _loc6_.timeline.removeKeyFrame(_loc7_);
                  _loc8_.deleteItem(_loc1_);
                  _loc9_.actionHistory.action_transItemDelete(_loc1_);
               }
               _loc7_++;
            }
            _loc2_ = _loc6_.timeline.findKeyFrame(_loc6_.start);
            if(_loc2_ >= 0)
            {
               _loc1_ = ETransitionItem(_loc6_.timeline.getKeyFrameData(_loc2_));
               _loc5_ = _loc8_.items.indexOf(_loc1_);
               _loc4_ = _loc6_.end - _loc6_.start + 1;
               _loc3_ = _loc8_.items.length;
               _loc7_ = _loc5_;
               while(_loc7_ < _loc3_)
               {
                  _loc1_ = _loc8_.items[_loc7_];
                  if(_loc1_.type == _loc6_.timeline.type && _loc1_.targetId == _loc6_.timeline.targetId)
                  {
                     _loc8_.setItemProperty(_loc1_,"frame",_loc1_.frame - _loc4_);
                  }
                  _loc7_++;
               }
               continue;
            }
         }
         _loc8_.arrangeItems();
         var _loc13_:int = 0;
         var _loc12_:* = this._selections;
         for each(_loc6_ in this._selections)
         {
            this.refreshTimeline(_loc6_.timeline);
         }
         _loc9_.setModified();
         _loc9_.setTimelineUpdateFlag();
      }
      
      private function drawNums() : void
      {
         var _loc5_:BitmapData = null;
         var _loc4_:Bitmap = null;
         var _loc3_:TextField = null;
         var _loc9_:Sprite = new Sprite();
         _loc9_.mouseEnabled = false;
         _loc9_.mouseChildren = false;
         var _loc8_:GGraph = new GGraph();
         _loc8_.width = 16000;
         _loc8_.setNativeObject(_loc9_);
         _loc8_.height = this.self.getChild("numBar").height;
         this._inner.addChild(_loc8_);
         var _loc6_:int = 8;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = headBitmapDatas[_loc7_];
            _loc4_ = new Bitmap(_loc5_);
            _loc4_.x = _loc7_ * _loc5_.width;
            _loc4_.y = 2;
            _loc9_.addChild(_loc4_);
            _loc7_++;
         }
         var _loc1_:int = 6;
         var _loc2_:int = Math.ceil(_loc8_.width / _loc1_ / 10);
         _loc7_ = 0;
         while(_loc7_ <= _loc2_)
         {
            _loc3_ = new TextField();
            _loc3_.defaultTextFormat = new TextFormat("Tahoma,Arial",10,12105912,null,null,null,null,null,"center");
            _loc3_.width = 40;
            _loc3_.text = "" + _loc7_ * 0.25;
            _loc3_.x = _loc7_ * _loc1_ * 10 + 5 - _loc3_.width / 2;
            _loc9_.addChild(_loc3_);
            _loc7_++;
         }
      }
      
      public function selectKeyFrame(param1:String, param2:String, param3:int) : void
      {
         this.clearSelection();
         var _loc4_:TimelineComponent = this.getTimeline(param1,param2);
         if(_loc4_)
         {
            this.addSelection(_loc4_,param3);
         }
      }
      
      public function addSelection(param1:TimelineComponent, param2:int, param3:int = 0, param4:Boolean = false) : void
      {
         var _loc11_:* = 0;
         var _loc14_:* = 0;
         var _loc12_:* = 0;
         var _loc13_:* = 0;
         var _loc6_:* = 0;
         var _loc8_:* = 0;
         var _loc7_:TimelineSelection = null;
         var _loc9_:EGObject = null;
         var _loc5_:int = 0;
         this._list.ensureBoundsCorrect();
         this.head = param2;
         var _loc10_:ComDocument = this._editorWindow.activeComDocument;
         if(param3 == 2 && this._selections.length > 0)
         {
            _loc12_ = int(this._list.getChildIndex(this._firstSelection.timeline));
            _loc13_ = int(this._list.getChildIndex(param1));
            if(this._firstSelection.start < param2)
            {
               _loc11_ = int(this._firstSelection.start);
               _loc14_ = param2;
            }
            else
            {
               _loc11_ = param2;
               _loc14_ = int(this._firstSelection.start);
            }
            this.clearSelection(param4);
            if(_loc12_ > _loc13_)
            {
               _loc8_ = _loc12_;
               _loc12_ = _loc13_;
               _loc13_ = _loc8_;
            }
            _loc6_ = _loc12_;
            while(_loc6_ <= _loc13_)
            {
               _loc7_ = new TimelineSelection();
               _loc7_.timeline = TimelineComponent(this._list.getChildAt(_loc6_));
               _loc7_.start = _loc11_;
               _loc7_.end = _loc14_;
               _loc7_.obj = this._selectionObjPool.getObject("ui://Builder/TimelineSelection");
               _loc7_.obj.setXY(_loc7_.start * 10,_loc7_.timeline.y);
               _loc7_.obj.width = (_loc7_.end - _loc7_.start + 1) * _loc7_.obj.sourceWidth;
               this._selectionContainer.addChild(_loc7_.obj);
               this._selections.push(_loc7_);
               this._nameList.addSelection(_loc6_);
               if(!param4)
               {
                  this._handlingSelection = true;
                  _loc9_ = _loc10_.editingContent.getChildById(_loc7_.timeline.targetId);
                  _loc10_.addSelection(_loc9_);
                  this._handlingSelection = false;
               }
               _loc6_++;
            }
         }
         else
         {
            _loc14_ = param2;
            _loc11_ = int(_loc14_);
            if(param3 == 0)
            {
               this.clearSelection(param4);
            }
            else
            {
               _loc5_ = this._selections.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc7_ = this._selections[_loc6_];
                  if(_loc7_.timeline == param1)
                  {
                     if(_loc7_.start <= param2 && _loc7_.end >= param2)
                     {
                        _loc11_ = -1;
                        if(param3 == 1)
                        {
                           if(_loc7_.start == param2)
                           {
                              if(_loc7_.end == param2)
                              {
                                 this._selections.splice(_loc6_,1);
                                 this._selectionObjPool.returnObject(_loc7_.obj);
                                 this._selectionContainer.removeChild(_loc7_.obj);
                              }
                              else
                              {
                                 _loc7_.start = param2 + 1;
                                 _loc7_.obj.x = _loc7_.obj.x + _loc7_.obj.sourceWidth;
                                 _loc7_.obj.width = _loc7_.obj.width - _loc7_.obj.sourceWidth;
                              }
                           }
                           else if(_loc7_.end == param2)
                           {
                              _loc7_.start = param2 - 1;
                              _loc7_.obj.width = _loc7_.obj.width - _loc7_.obj.sourceWidth;
                           }
                           else
                           {
                              _loc11_ = int(param2 + 1);
                              _loc14_ = int(_loc7_.end);
                              _loc7_.end = param2 - 1;
                              _loc7_.obj.width = (_loc7_.end - _loc7_.start + 1) * _loc7_.obj.sourceWidth;
                           }
                        }
                        break;
                     }
                  }
                  _loc6_++;
               }
            }
            if(_loc11_ != -1)
            {
               if(param3 != 1)
               {
                  this.clearSelection(param4);
               }
               _loc7_ = new TimelineSelection();
               _loc7_.timeline = param1;
               _loc7_.start = _loc11_;
               _loc7_.end = _loc14_;
               _loc7_.obj = this._selectionObjPool.getObject("ui://Builder/TimelineSelection");
               _loc7_.obj.setXY(_loc7_.start * 10,_loc7_.timeline.y);
               _loc7_.obj.width = (_loc7_.end - _loc7_.start + 1) * _loc7_.obj.sourceWidth;
               this._selectionContainer.addChild(_loc7_.obj);
               this._selections.push(_loc7_);
               this._nameList.addSelection(this._list.getChildIndex(param1));
               if(!param4)
               {
                  this._handlingSelection = true;
                  _loc9_ = _loc10_.editingContent.getChildById(_loc7_.timeline.targetId);
                  _loc10_.addSelection(_loc9_);
                  this._handlingSelection = false;
               }
               if(this._selections.length == 1)
               {
                  this._firstSelection.start = _loc7_.start;
                  this._firstSelection.end = _loc7_.end;
                  this._firstSelection.timeline = _loc7_.timeline;
               }
            }
         }
         _loc10_.setTimelineUpdateFlag();
      }
      
      public function clearSelection(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:TimelineSelection = null;
         var _loc4_:ComDocument = null;
         var _loc6_:int = 0;
         var _loc5_:* = this._selections;
         for each(_loc3_ in this._selections)
         {
            this._selectionObjPool.returnObject(_loc3_.obj);
         }
         this._selectionContainer.removeChildren();
         this._selections.length = 0;
         this._nameList.selectedIndex = -1;
         if(!param1)
         {
            this._handlingSelection = true;
            _loc4_ = this._editorWindow.activeComDocument;
            _loc4_.clearSelection(param2);
            this._handlingSelection = false;
         }
      }
      
      public function removeSelection(param1:TimelineComponent) : void
      {
         var _loc3_:TimelineSelection = null;
         var _loc4_:int = this._selections.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._selections[_loc2_];
            if(_loc3_.timeline == param1)
            {
               this._selectionObjPool.returnObject(_loc3_.obj);
               this._selectionContainer.removeChild(_loc3_.obj);
               this._selections.splice(_loc2_,1);
               this._nameList.removeSelection(this._list.getChildIndex(param1));
               _loc4_--;
            }
            else
            {
               _loc2_++;
            }
         }
      }
      
      public function mergeSelections() : Boolean
      {
         var _loc1_:TimelineSelection = null;
         this._list.ensureBoundsCorrect();
         this._selections.sort(this.compareSelection);
         var _loc5_:int = this._selections.length;
         var _loc4_:* = null;
         var _loc2_:int = 0;
         var _loc3_:Boolean = true;
         while(_loc2_ < _loc5_)
         {
            _loc1_ = this._selections[_loc2_];
            if(_loc4_ == null)
            {
               _loc4_ = _loc1_;
               _loc2_++;
            }
            else
            {
               if(_loc1_.timeline == _loc4_.timeline)
               {
                  if(_loc1_.start == _loc4_.end + 1)
                  {
                     _loc4_.end = _loc1_.end;
                     _loc4_.obj.width = (_loc4_.end - _loc4_.start) * _loc4_.obj.sourceWidth;
                     this._selectionObjPool.returnObject(_loc1_.obj);
                     this._selections.splice(_loc2_,1);
                     _loc5_--;
                     _loc2_--;
                  }
                  else
                  {
                     _loc3_ = false;
                  }
               }
               else if(_loc1_.timeline.y - _loc4_.timeline.y >= _loc1_.timeline.height * 2)
               {
                  _loc3_ = false;
               }
               _loc4_ = _loc1_;
               _loc2_++;
            }
         }
         if(_loc3_)
         {
            _loc5_ = this._selections.length;
            _loc4_ = this._selections[0];
            _loc2_ = 1;
            while(_loc2_ < _loc5_)
            {
               _loc1_ = this._selections[_loc2_];
               if(_loc1_.start != _loc4_.start || _loc1_.end != _loc4_.end)
               {
                  _loc3_ = false;
                  break;
               }
               _loc2_++;
            }
         }
         return _loc3_;
      }
      
      private function compareSelection(param1:TimelineSelection, param2:TimelineSelection) : int
      {
         if(param1.timeline == param2.timeline)
         {
            return param1.start - param2.start;
         }
         return param1.timeline.y - param2.timeline.y;
      }
      
      private function getTimelineOnY(param1:Number) : TimelineComponent
      {
         var _loc2_:Point = this._list.localToGlobal(1,1);
         return TimelineComponent(this._list.getItemNear(_loc2_.x,param1));
      }
      
      private function __clickNumBar(param1:GTouchEvent) : void
      {
         var _loc4_:Point = this._inner.globalToLocal(param1.stageX,param1.stageY);
         _loc4_.x = _loc4_.x + this._inner.scrollPane.posX;
         var _loc2_:int = _loc4_.x / 10;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         this.head = _loc2_;
         this.clearSelection();
         this._nameList.selectedIndex = -1;
         var _loc3_:ComDocument = this._editorWindow.activeComDocument;
         _loc3_.setTimelineUpdateFlag();
      }
      
      private function __clickList(param1:GTouchEvent) : void
      {
         var _loc4_:TimelineComponent = TimelineComponent(this._list.getItemNear(param1.stageX,param1.stageY));
         if(_loc4_ == null)
         {
            return;
         }
         var _loc2_:Point = this._inner.globalToLocal(param1.stageX,param1.stageY);
         _loc2_.x = _loc2_.x + this._inner.scrollPane.posX;
         var _loc3_:int = _loc2_.x / 10;
         if(param1.ctrlKey)
         {
            this.addSelection(_loc4_,_loc3_,1);
         }
         else if(param1.shiftKey)
         {
            this.addSelection(_loc4_,_loc3_,2);
         }
         else
         {
            this.addSelection(_loc4_,_loc3_,0);
         }
      }
      
      private function __rightClickList(param1:MouseEvent) : void
      {
         var _loc6_:TimelineSelection = null;
         var _loc5_:int = 0;
         var _loc12_:Number = this._editorWindow.groot.nativeStage.mouseX;
         var _loc10_:Number = this._editorWindow.groot.nativeStage.mouseY;
         var _loc11_:TimelineComponent = TimelineComponent(this._list.getItemNear(_loc12_,_loc10_));
         if(_loc11_ == null)
         {
            return;
         }
         var _loc2_:Point = this._inner.globalToLocal(_loc12_,_loc10_);
         _loc2_.x = _loc2_.x + this._inner.scrollPane.posX;
         var _loc4_:int = _loc2_.x / 10;
         this.addSelection(_loc11_,_loc4_,3);
         var _loc9_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc14_:int = 0;
         var _loc13_:* = this._selections;
         for each(_loc6_ in this._selections)
         {
            _loc11_ = _loc6_.timeline;
            if(_loc11_.maxFrame > 0)
            {
               _loc8_ = true;
            }
            _loc5_ = _loc6_.start;
            while(_loc5_ <= _loc6_.end)
            {
               if(_loc11_.hasKeyFrame(_loc5_))
               {
                  _loc9_ = true;
               }
               if(_loc5_ < _loc11_.maxFrame || _loc5_ == _loc11_.maxFrame && _loc11_.maxFrame > 0)
               {
                  _loc7_ = true;
                  if(_loc11_.getTweenStart(_loc5_) != -1)
                  {
                     _loc3_ = true;
                  }
               }
               _loc5_++;
            }
         }
         this._frameMenu.setItemGrayed("setKeyFrame",false);
         this._frameMenu.setItemGrayed("removeFrame",!_loc8_);
         this._frameMenu.setItemGrayed("addFrame",false);
         if(_loc7_)
         {
            if(_loc3_)
            {
               this._frameMenu.setItemGrayed("addTween",true);
               this._frameMenu.setItemGrayed("removeTween",false);
            }
            else
            {
               this._frameMenu.setItemGrayed("addTween",false);
               this._frameMenu.setItemGrayed("removeTween",true);
            }
         }
         else
         {
            this._frameMenu.setItemGrayed("addTween",true);
            this._frameMenu.setItemGrayed("removeTween",true);
         }
         this._frameMenu.show(this.self.root);
      }
      
      private function __clickNameList(param1:GTouchEvent) : void
      {
         var _loc2_:TimelineComponent = this.getTimelineOnY(this._editorWindow.groot.nativeStage.mouseY);
         if(_loc2_ == null)
         {
            return;
         }
         if(param1.ctrlKey)
         {
            this.addSelection(_loc2_,this.head,1);
         }
         else if(param1.shiftKey)
         {
            this.addSelection(_loc2_,this.head,2);
         }
         else
         {
            this.addSelection(_loc2_,this.head,0);
         }
      }
      
      private function __rightClickNameList(param1:MouseEvent) : void
      {
         var _loc3_:TimelineComponent = this.getTimelineOnY(this._editorWindow.groot.nativeStage.mouseY);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc2_:int = this._list.getChildIndex(_loc3_);
         if(!this._nameList.getChildAt(_loc2_).asButton.selected)
         {
            this.addSelection(_loc3_,this.head);
         }
         this._timelineMenu.setItemGrayed("paste",_copiedTimeline == null);
         this._timelineMenu.setItemGrayed("changeTarget",_loc3_.type == "Sound");
         this._timelineMenu.show(this.self.root);
      }
      
      private function __dragStart(param1:DragEvent) : void
      {
         var _loc3_:TimelineSelection = null;
         param1.preventDefault();
         this._list.cancelClick();
         var _loc6_:TimelineComponent = TimelineComponent(this._list.getItemNear(param1.stageX,param1.stageY));
         if(_loc6_ == null)
         {
            return;
         }
         var _loc4_:Point = this._inner.globalToLocal(param1.stageX,param1.stageY);
         _loc4_.x = _loc4_.x + this._inner.scrollPane.posX;
         this._dragStartPos = _loc4_.x / 10;
         var _loc5_:Boolean = false;
         var _loc2_:int = this._selections.length;
         var _loc8_:int = 0;
         var _loc7_:* = this._selections;
         for each(_loc3_ in this._selections)
         {
            if(_loc3_.timeline == _loc6_ && _loc3_.start <= this._dragStartPos && _loc3_.end >= this._dragStartPos)
            {
               _loc5_ = true;
               break;
            }
         }
         if(!_loc5_ || !this.mergeSelections())
         {
            this._draggingSelection = false;
            this.addSelection(_loc6_,this._dragStartPos);
         }
         else
         {
            this._draggingSelection = true;
            this._draggingIndicator.setXY(this._selections[0].obj.x,this._selections[0].obj.y);
            this._draggingIndicator.setSize(this._selections[0].obj.width,this._selections[this._selections.length - 1].obj.y + this._selections[this._selections.length - 1].obj.height - this._selections[0].obj.y);
            this._selectionContainer.addChild(this._draggingIndicator);
         }
         this._editorWindow.dragManager.startDrag(this,null,this._list.scrollPane);
         this._editorWindow.dragManager.dragAgent.addEventListener("dragMoving",this.__dragging);
         this._editorWindow.dragManager.dragAgent.addEventListener("removedFromStage",this.__dragEnd);
      }
      
      private function __dragging(param1:DragEvent) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:TimelineComponent = null;
         var _loc6_:Point = this._inner.globalToLocal(param1.stageX,param1.stageY);
         if(_loc6_.x < 1)
         {
            _loc6_.x = 1;
         }
         else if(_loc6_.x > this._inner.width)
         {
            _loc6_.x = this._inner.width;
         }
         if(_loc6_.y < this._list.y + 1)
         {
            _loc6_.y = this._list.y + 1;
         }
         else if(_loc6_.y > this._inner.height)
         {
            _loc6_.y = this._inner.height;
         }
         _loc6_.x = _loc6_.x + this._inner.scrollPane.posX;
         var _loc4_:int = _loc6_.x / 10;
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         var _loc5_:int = _loc4_ - this._dragStartPos;
         _loc6_ = this._inner.localToGlobal(_loc6_.x,_loc6_.y);
         if(this._draggingSelection)
         {
            _loc2_ = Number(this._selections[0].obj.x + _loc5_ * 10);
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            this._draggingIndicator.x = _loc2_;
         }
         else
         {
            _loc3_ = TimelineComponent(this._list.getItemNear(_loc6_.x,_loc6_.y));
            if(!_loc3_)
            {
               _loc3_ = TimelineComponent(this._list.getChildAt(this._list.numChildren - 1));
            }
            this.addSelection(_loc3_,_loc4_,2);
         }
      }
      
      private function __dragEnd(param1:Event) : void
      {
         this._selectionContainer.removeChild(this._draggingIndicator);
         this._editorWindow.dragManager.dragAgent.removeEventListener("dragMoving",this.__dragging);
         this._editorWindow.dragManager.dragAgent.removeEventListener("removedFromStage",this.__dragEnd);
      }
      
      private function __drop(param1:DropEvent) : void
      {
         var _loc8_:* = 0;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:ETransitionItem = null;
         var _loc5_:TimelineSelection = null;
         if(!(param1.source is TimelinePanel) || !this._draggingSelection)
         {
            return;
         }
         var _loc11_:int = this._draggingIndicator.x / 10;
         if(_loc11_ < 0)
         {
            _loc11_ = 0;
         }
         var _loc9_:int = _loc11_ - this._selections[0].start;
         if(_loc9_ == 0)
         {
            return;
         }
         this.head = _loc11_;
         var _loc10_:ComDocument = this._editorWindow.activeComDocument;
         var _loc2_:ETransition = _loc10_.editingTransition;
         var _loc3_:int = _loc2_.items.length;
         var _loc13_:int = 0;
         var _loc12_:* = this._selections;
         for each(_loc5_ in this._selections)
         {
            _loc6_ = _loc5_.timeline.findKeyFrame(_loc5_.start);
            _loc5_.start = _loc5_.start + _loc9_;
            _loc5_.end = _loc5_.end + _loc9_;
            _loc5_.obj.x = _loc5_.obj.x + _loc9_ * 10;
            if(_loc6_ >= 0)
            {
               _loc4_ = ETransitionItem(_loc5_.timeline.getKeyFrameData(_loc6_));
               _loc7_ = _loc2_.items.indexOf(_loc4_);
               _loc8_ = _loc7_;
               while(_loc8_ < _loc3_)
               {
                  _loc4_ = _loc2_.items[_loc8_];
                  if(_loc4_.type == _loc5_.timeline.type && _loc4_.targetId == _loc5_.timeline.targetId)
                  {
                     _loc2_.setItemProperty(_loc4_,"frame",_loc4_.frame + _loc9_);
                  }
                  _loc8_++;
               }
               continue;
            }
         }
         _loc2_.arrangeItems();
         var _loc15_:int = 0;
         var _loc14_:* = this._selections;
         for each(_loc5_ in this._selections)
         {
            this.refreshTimeline(_loc5_.timeline);
         }
         _loc10_.setTimelineUpdateFlag();
      }
      
      private function __menuSetKeyFrame(param1:Event) : void
      {
         this.setKeyFrame();
      }
      
      private function __menuClearKeyFrame(param1:Event) : void
      {
         this.clearKeyFrame();
      }
      
      private function __menuAddFrame(param1:Event) : void
      {
         this.insertFrame();
      }
      
      private function __menuRemoveFrame(param1:Event) : void
      {
         this.removeFrame();
      }
      
      private function __menuAddTween(param1:Event) : void
      {
         var _loc6_:TimelineSelection = null;
         var _loc4_:int = 0;
         var _loc5_:ComDocument = null;
         var _loc2_:ETransition = null;
         var _loc3_:ETransitionItem = null;
         if(this._selections.length == 0)
         {
            return;
         }
         var _loc8_:int = 0;
         var _loc7_:* = this._selections;
         for each(_loc6_ in this._selections)
         {
            _loc4_ = _loc6_.timeline.getPossibleTweenStart(_loc6_.start);
            if(_loc4_ != -1)
            {
               _loc5_ = this._editorWindow.activeComDocument;
               _loc2_ = _loc5_.editingTransition;
               _loc3_ = ETransitionItem(_loc6_.timeline.getKeyFrameData(_loc4_));
               _loc2_.setItemProperty(_loc3_,"tween",true);
               _loc2_.arrangeItems();
               this.refreshTimeline(_loc6_.timeline);
               _loc5_.setTimelineUpdateFlag();
            }
         }
      }
      
      private function __menuRemoveTween(param1:Event) : void
      {
         var _loc6_:TimelineSelection = null;
         var _loc4_:int = 0;
         var _loc5_:ComDocument = null;
         var _loc2_:ETransition = null;
         var _loc3_:ETransitionItem = null;
         if(this._selections.length == 0)
         {
            return;
         }
         var _loc8_:int = 0;
         var _loc7_:* = this._selections;
         for each(_loc6_ in this._selections)
         {
            _loc4_ = _loc6_.timeline.getTweenStart(_loc6_.start);
            if(_loc4_ != -1)
            {
               _loc5_ = this._editorWindow.activeComDocument;
               _loc2_ = _loc5_.editingTransition;
               _loc3_ = ETransitionItem(_loc6_.timeline.getKeyFrameData(_loc4_));
               _loc2_.setItemProperty(_loc3_,"tween",false);
               _loc2_.arrangeItems();
               this.refreshTimeline(_loc6_.timeline);
               _loc5_.setTimelineUpdateFlag();
            }
         }
      }
      
      private function __menuDeleteTimeline(param1:Event) : void
      {
         if(this._nameList.selectedIndex == -1)
         {
            return;
         }
         var _loc5_:TimelineComponent = TimelineComponent(this._list.getChildAt(this._nameList.selectedIndex));
         var _loc3_:ComDocument = this._editorWindow.activeComDocument;
         var _loc4_:ETransition = _loc3_.editingTransition;
         var _loc2_:Array = _loc4_.deleteItems(_loc5_.targetId,_loc5_.type);
         _loc3_.actionHistory.action_transItemsDelete(_loc2_);
         this.removeTimeline(_loc5_.targetId,_loc5_.type);
         _loc3_.setModified();
      }
      
      private function __menuCopyTimeline(param1:Event) : void
      {
         if(this._nameList.selectedIndex == -1)
         {
            return;
         }
         var _loc4_:TimelineComponent = TimelineComponent(this._list.getChildAt(this._nameList.selectedIndex));
         var _loc2_:ComDocument = this._editorWindow.activeComDocument;
         var _loc3_:ETransition = _loc2_.editingTransition;
         _copiedTimeline = _loc3_.copyItems(_loc4_.targetId,_loc4_.type);
      }
      
      private function __menuPasteTimeline(param1:Event) : void
      {
         if(this._nameList.selectedIndex == -1)
         {
            return;
         }
         var _loc6_:TimelineComponent = TimelineComponent(this._list.getChildAt(this._nameList.selectedIndex));
         var _loc4_:ComDocument = this._editorWindow.activeComDocument;
         var _loc5_:ETransition = _loc4_.editingTransition;
         var _loc2_:XML = _loc5_.toXML(false);
         _loc5_.pasteItems(_copiedTimeline,_loc6_.targetId,_loc6_.type);
         var _loc3_:XML = _loc5_.toXML(false);
         _loc4_.actionHistory.action_transitionChanged(_loc2_,_loc3_);
         _loc4_.setModified();
         this.refreshTimeline(_loc6_);
         _loc4_.setTimelineUpdateFlag();
      }
      
      private function __menuChangeTimelineTarget(param1:Event) : void
      {
         if(this._nameList.selectedIndex == -1)
         {
            return;
         }
         var _loc3_:TimelineComponent = TimelineComponent(this._list.getChildAt(this._nameList.selectedIndex));
         var _loc2_:ComDocument = this._editorWindow.activeComDocument;
         _loc2_.startSelectingObject(_loc2_.editingContent.getChildById(_loc3_.targetId));
         SelectObjectPanel.callback = this.__objectSelected;
         SelectObjectPanel.callbackData = _loc3_;
      }
      
      private function __objectSelected(param1:EGObject, param2:TimelineComponent) : void
      {
         var _loc5_:ETransitionItem = null;
         var _loc7_:ComDocument = this._editorWindow.activeComDocument;
         var _loc8_:ETransition = _loc7_.editingTransition;
         var _loc3_:Vector.<ETransitionItem> = _loc8_.items;
         var _loc4_:String = param2.targetId;
         var _loc6_:String = param1.id;
         var _loc10_:int = 0;
         var _loc9_:* = _loc3_;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_.type == param2.type && _loc5_.targetId == param2.targetId)
            {
               _loc5_.targetId = _loc6_;
               _loc7_.actionHistory.action_transItemSet(_loc5_,"targetId",_loc4_,_loc6_);
            }
         }
         _loc7_.setModified();
         _loc8_.arrangeItems();
         this.refreshTimelines();
         _loc7_.setTimelineUpdateFlag();
      }
      
      private function __onListScroll(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TimelineComponent = null;
         if(this._syncingScrollPos)
         {
            return;
         }
         this._syncingScrollPos = true;
         this._nameList.scrollPane.posY = this._list.scrollPane.posY;
         this._inner.scrollPane.posX = this._list.scrollPane.posX;
         this._selectionContainer.setXY(-this._list.scrollPane.posX,-this._list.scrollPane.posY);
         if(this._list.scrollPane.percX == 1)
         {
            if(this._curWidth != 16000)
            {
               this._curWidth = 16000;
               _loc4_ = this._list.numChildren;
               _loc2_ = 0;
               while(_loc2_ < _loc4_)
               {
                  _loc3_ = TimelineComponent(this._list.getChildAt(_loc2_));
                  _loc3_.width = this._curWidth;
                  _loc2_++;
               }
            }
         }
         this._syncingScrollPos = false;
      }
      
      private function __onNameListScroll(param1:Event) : void
      {
         if(this._syncingScrollPos)
         {
            return;
         }
         this._syncingScrollPos = true;
         this._list.scrollPane.posY = this._nameList.scrollPane.posY;
         this._selectionContainer.setXY(-this._list.scrollPane.posX,-this._list.scrollPane.posY);
         this._syncingScrollPos = false;
      }
   }
}

import fairygui.GObject;
import fairygui.editor.TimelineComponent;

class TimelineSelection
{
    
   
   public var timeline:TimelineComponent;
   
   public var obj:GObject;
   
   public var start:int;
   
   public var end:int;
   
   function TimelineSelection()
   {
      super();
   }
}

package fairygui
{
   import fairygui.event.ItemEvent;
   import fairygui.utils.GTimers;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   
   public class PopupMenu
   {
       
      
      protected var _contentPane:GComponent;
      
      protected var _list:GList;
      
      protected var _expandingItem:GObject;
      
      private var _parentMenu:PopupMenu;
      
      public var visibleItemCount:int = 2147483647;
      
      public var hideOnClickItem:Boolean = true;
      
      public function PopupMenu(param1:String = null)
      {
         super();
         if(!param1)
         {
            param1 = UIConfig.popupMenu;
            if(!param1)
            {
               throw new Error("UIConfig.popupMenu not defined");
            }
         }
         _contentPane = GComponent(UIPackage.createObjectFromURL(param1));
         _contentPane.addEventListener("addedToStage",__addedToStage);
         _contentPane.addEventListener("removedFromStage",__removeFromStage);
         _list = GList(_contentPane.getChild("list"));
         _list.removeChildrenToPool();
         _list.addRelation(_contentPane,14);
         _list.removeRelation(_contentPane,15);
         _contentPane.addRelation(_list,15);
         _list.addEventListener("itemClick",__clickItem);
      }
      
      public function dispose() : void
      {
         _contentPane.dispose();
      }
      
      public function addItem(param1:String, param2:* = null) : GButton
      {
         var _loc3_:GButton = _list.addItemFromPool().asButton;
         _loc3_.title = param1;
         _loc3_.data = param2;
         _loc3_.grayed = false;
         _loc3_.useHandCursor = false;
         var _loc4_:Controller = _loc3_.getController("checked");
         if(_loc4_ != null)
         {
            _loc4_.selectedIndex = 0;
         }
         if(Mouse.supportsCursor)
         {
            _loc3_.addEventListener("rollOver",__rollOver);
            _loc3_.addEventListener("rollOut",__rollOut);
         }
         return _loc3_;
      }
      
      public function addItemAt(param1:String, param2:int, param3:* = null) : GButton
      {
         var _loc4_:GButton = _list.getFromPool().asButton;
         _list.addChildAt(_loc4_,param2);
         _loc4_.title = param1;
         _loc4_.data = param3;
         _loc4_.grayed = false;
         _loc4_.useHandCursor = false;
         var _loc5_:Controller = _loc4_.getController("checked");
         if(_loc5_ != null)
         {
            _loc5_.selectedIndex = 0;
         }
         if(Mouse.supportsCursor)
         {
            _loc4_.addEventListener("rollOver",__rollOver);
            _loc4_.addEventListener("rollOut",__rollOut);
         }
         return _loc4_;
      }
      
      public function addSeperator() : void
      {
         if(UIConfig.popupMenu_seperator == null)
         {
            throw new Error("UIConfig.popupMenu_seperator not defined");
         }
         var _loc1_:GObject = list.addItemFromPool(UIConfig.popupMenu_seperator);
         if(Mouse.supportsCursor)
         {
            _loc1_.addEventListener("rollOver",__rollOver);
            _loc1_.addEventListener("rollOut",__rollOut);
         }
      }
      
      public function getItemName(param1:int) : String
      {
         var _loc2_:GButton = GButton(_list.getChildAt(param1));
         return _loc2_.name;
      }
      
      public function setItemText(param1:String, param2:String) : void
      {
         var _loc3_:GButton = _list.getChild(param1).asButton;
         _loc3_.title = param2;
      }
      
      public function setItemVisible(param1:String, param2:Boolean) : void
      {
         var _loc3_:GButton = _list.getChild(param1).asButton;
         if(_loc3_.visible != param2)
         {
            _loc3_.visible = param2;
            _list.setBoundsChangedFlag();
         }
      }
      
      public function setItemGrayed(param1:String, param2:Boolean) : void
      {
         var _loc3_:GButton = _list.getChild(param1).asButton;
         _loc3_.grayed = param2;
      }
      
      public function setItemCheckable(param1:String, param2:Boolean) : void
      {
         var _loc3_:GButton = _list.getChild(param1).asButton;
         var _loc4_:Controller = _loc3_.getController("checked");
         if(_loc4_ != null)
         {
            if(param2)
            {
               if(_loc4_.selectedIndex == 0)
               {
                  _loc4_.selectedIndex = 1;
               }
            }
            else
            {
               _loc4_.selectedIndex = 0;
            }
         }
      }
      
      public function setItemChecked(param1:String, param2:Boolean) : void
      {
         var _loc3_:GButton = _list.getChild(param1).asButton;
         var _loc4_:Controller = _loc3_.getController("checked");
         if(_loc4_ != null)
         {
            _loc4_.selectedIndex = !!param2?2:1;
         }
      }
      
      public function isItemChecked(param1:String) : Boolean
      {
         var _loc2_:GButton = _list.getChild(param1).asButton;
         var _loc3_:Controller = _loc2_.getController("checked");
         if(_loc3_ != null)
         {
            return _loc3_.selectedIndex == 2;
         }
         return false;
      }
      
      public function removeItem(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:GButton = GButton(_list.getChild(param1));
         if(_loc2_ != null)
         {
            _loc3_ = _list.getChildIndex(_loc2_);
            _list.removeChildToPoolAt(_loc3_);
            return true;
         }
         return false;
      }
      
      public function clearItems() : void
      {
         _list.removeChildrenToPool();
      }
      
      public function get itemCount() : int
      {
         return _list.numChildren;
      }
      
      public function get contentPane() : GComponent
      {
         return _contentPane;
      }
      
      public function get list() : GList
      {
         return _list;
      }
      
      public function show(param1:GObject = null, param2:Object = null, param3:PopupMenu = null) : void
      {
         var _loc4_:GRoot = param1 != null?param1.root:GRoot.inst;
         _loc4_.showPopup(this.contentPane,param1 is GRoot?null:param1,param2);
         _parentMenu = param3;
      }
      
      public function hide() : void
      {
         if(contentPane.parent)
         {
            GRoot(contentPane.parent).hidePopup(contentPane);
         }
      }
      
      private function showSecondLevelMenu(param1:GObject) : void
      {
         _expandingItem = param1;
         var _loc2_:PopupMenu = PopupMenu(param1.data);
         if(param1 is GButton)
         {
            GButton(param1).selected = true;
         }
         _loc2_.show(param1,null,this);
         var _loc3_:Point = contentPane.localToRoot(param1.x + param1.width - 5,param1.y - 5);
         _loc2_.contentPane.setXY(_loc3_.x,_loc3_.y);
      }
      
      private function closeSecondLevelMenu() : void
      {
         if(!_expandingItem)
         {
            return;
         }
         if(_expandingItem is GButton)
         {
            GButton(_expandingItem).selected = false;
         }
         var _loc1_:PopupMenu = PopupMenu(_expandingItem.data);
         if(!_loc1_)
         {
            return;
         }
         _expandingItem = null;
         _loc1_.hide();
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc4_:* = null;
         var _loc2_:GButton = param1.itemObject.asButton;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.grayed)
         {
            _list.selectedIndex = -1;
            return;
         }
         var _loc3_:Controller = _loc2_.getController("checked");
         if(_loc3_ != null && _loc3_.selectedIndex != 0)
         {
            if(_loc3_.selectedIndex == 1)
            {
               _loc3_.selectedIndex = 2;
            }
            else
            {
               _loc3_.selectedIndex = 1;
            }
         }
         if(hideOnClickItem)
         {
            if(_parentMenu)
            {
               _parentMenu.hide();
            }
            hide();
         }
         if(_loc2_.data != null && !(_loc2_.data is PopupMenu))
         {
            _loc4_ = _loc2_.data as Function;
            if(_loc4_ != null)
            {
               if(_loc4_.length == 1)
               {
                  _loc4_(param1);
               }
               else
               {
                  _loc4_();
               }
            }
         }
      }
      
      private function __addedToStage(param1:Event) : void
      {
         _list.selectedIndex = -1;
         _list.resizeToFit(visibleItemCount,10);
      }
      
      private function __removeFromStage(param1:Event) : void
      {
         _parentMenu = null;
         if(_expandingItem)
         {
            GTimers.inst.callLater(closeSecondLevelMenu);
         }
      }
      
      private function __rollOver(param1:MouseEvent) : void
      {
         var _loc2_:GObject = GObject(param1.currentTarget);
         if(_loc2_.data is PopupMenu || _expandingItem)
         {
            GTimers.inst.callDelay(100,__showSubMenu,_loc2_);
         }
      }
      
      private function __showSubMenu(param1:GObject) : void
      {
         var _loc2_:GRoot = contentPane.root;
         if(!_loc2_)
         {
            return;
         }
         if(_expandingItem)
         {
            if(_expandingItem == param1)
            {
               return;
            }
            closeSecondLevelMenu();
         }
         var _loc3_:PopupMenu = param1.data as PopupMenu;
         if(!_loc3_)
         {
            return;
         }
         showSecondLevelMenu(param1);
      }
      
      private function __rollOut(param1:MouseEvent) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(!_expandingItem)
         {
            return;
         }
         GTimers.inst.remove(__showSubMenu);
         var _loc2_:GRoot = contentPane.root;
         if(_loc2_)
         {
            _loc3_ = PopupMenu(_expandingItem.data);
            _loc4_ = _loc3_.contentPane.globalToLocal(_loc2_.nativeStage.mouseX,_loc2_.nativeStage.mouseY);
            if(_loc4_.x >= 0 && _loc4_.y >= 0 && _loc4_.x < _loc3_.contentPane.width && _loc4_.y < _loc3_.contentPane.height)
            {
               return;
            }
         }
         closeSecondLevelMenu();
      }
   }
}

package fairygui.editor.extui
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class TabView extends EventDispatcher
   {
       
      
      private var _list:GList;
      
      private var _moreBtn:GButton;
      
      private var _menu:PopupMenu;
      
      private var _tabs:Vector.<TabItem>;
      
      private var _listener:ITabViewListener;
      
      public function TabView(param1:GList, param2:GButton)
      {
         super();
         this._menu = new PopupMenu();
         this._list = param1;
         this._list.addEventListener("itemClick",this.__clickListItem);
         this._list.addSizeChangeCallback(this.__sizeChanged);
         this._moreBtn = param2;
         this._moreBtn.linkedPopup = this._menu.contentPane;
         this._moreBtn.visible = false;
         this._tabs = new Vector.<TabItem>();
      }
      
      public final function get listener() : ITabViewListener
      {
         return this._listener;
      }
      
      public final function set listener(param1:ITabViewListener) : void
      {
         this._listener = param1;
      }
      
      public function addTab(param1:String, param2:String, param3:String, param4:Object = null, param5:Boolean = true) : void
      {
         var _loc6_:GButton = this._list.getFromPool().asButton;
         _loc6_.title = param2;
         _loc6_.name = param1;
         _loc6_.getChild("closeButton").addClickListener(this.__clickCloseButton);
         var _loc7_:TabItem = new TabItem();
         _loc7_.id = param1;
         _loc7_.title = param2;
         _loc7_.width = _loc6_.width;
         _loc7_.visitTime = getTimer();
         _loc7_.button = _loc6_;
         _loc7_.button.icon = param3;
         _loc7_.data = param4;
         this._tabs.push(_loc7_);
         _loc6_.data = _loc7_;
         if(param5)
         {
            this._list.addChildAt(_loc6_,0);
            this._list.selectedIndex = 0;
            this._listener.tabChanged(_loc7_);
         }
         else
         {
            this._list.addChild(_loc6_);
         }
         this.adjustList();
         this._menu.addItem(param2,this.__clickMenu).name = param1;
      }
      
      public function getTabById(param1:String) : TabItem
      {
         var _loc3_:int = this._tabs.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._tabs[_loc2_].id == param1)
            {
               return this._tabs[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function get tabCount() : int
      {
         return this._tabs.length;
      }
      
      public function getTabAt(param1:int) : TabItem
      {
         return this._tabs[param1];
      }
      
      public function activateTab(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TabItem = this.getTabById(param1);
         _loc3_.visitTime = getTimer();
         if(_loc3_.button.parent != null)
         {
            _loc2_ = this._list.getChildIndex(_loc3_.button);
            if(_loc2_ != this._list.selectedIndex)
            {
               this._list.selectedIndex = _loc2_;
               this._listener.tabChanged(_loc3_);
            }
            return;
         }
         this._list.addChild(_loc3_.button);
         this._list.selectedIndex = this._list.getChildIndex(_loc3_.button);
         this._listener.tabChanged(_loc3_);
         this.adjustList();
      }
      
      public function updateTab(param1:String, param2:String, param3:String, param4:Boolean) : void
      {
         var _loc5_:TabItem = this.getTabById(param1);
         _loc5_.title = param2;
         _loc5_.modified = param4;
         _loc5_.visitTime = getTimer();
         if(param4)
         {
            _loc5_.button.title = param2 + "*";
         }
         else
         {
            _loc5_.button.title = param2;
         }
         _loc5_.button.icon = param3;
         _loc5_.width = _loc5_.button.width;
         var _loc6_:GButton = this._list.getChild(param1) as GButton;
         if(_loc6_ != null)
         {
            this.adjustList();
         }
         _loc6_ = this._menu.list.getChild(param1) as GButton;
         if(_loc6_ != null)
         {
            this._menu.setItemText(param1,_loc5_.button.title);
         }
      }
      
      public function closeTabAt(param1:int) : void
      {
         var _loc2_:GButton = null;
         var _loc3_:Boolean = false;
         var _loc4_:TabItem = this.getTabAt(param1);
         this._tabs.splice(param1,1);
         this._menu.removeItem(_loc4_.id);
         if(_loc4_.button.parent != null)
         {
            _loc2_ = this._list.getChild(_loc4_.id).asButton;
            _loc3_ = _loc2_.selected;
            this._list.removeChild(_loc2_);
            this.adjustList();
            this._listener.tabClosed(_loc4_);
            if(_loc3_)
            {
               this.activateLatest();
            }
         }
         this._list.returnToPool(_loc4_.button);
         _loc4_.button.data = null;
         _loc4_.button = null;
      }
      
      public function closeTab(param1:String) : void
      {
         var _loc3_:int = this._tabs.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._tabs[_loc2_].id == param1)
            {
               this.closeTabAt(_loc2_);
               break;
            }
            _loc2_++;
         }
      }
      
      public function clearAllTabs() : void
      {
         var _loc1_:TabItem = null;
         var _loc3_:int = this._tabs.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._tabs[_loc2_];
            this._list.returnToPool(_loc1_.button);
            _loc1_.button.data = null;
            _loc1_.button = null;
            _loc2_++;
         }
         this._tabs.length = 0;
         this._list.removeChildren();
         this._menu.clearItems();
      }
      
      public function activateLatest() : void
      {
         var _loc1_:TabItem = this.findNewestOnlineItem();
         if(_loc1_ != null)
         {
            this.activateTab(_loc1_.id);
         }
      }
      
      private function __clickMenu(param1:ItemEvent) : void
      {
         this.activateTab(param1.itemObject.name);
      }
      
      private function __clickListItem(param1:ItemEvent) : void
      {
         this._listener.tabChanged(TabItem(param1.itemObject.data));
      }
      
      private function __clickCloseButton(param1:Event) : void
      {
         param1.stopPropagation();
         var _loc2_:TabItem = TabItem(GObject(param1.currentTarget.parent).data);
         if(this._listener.tabWillClose(_loc2_))
         {
            this.closeTab(_loc2_.id);
         }
      }
      
      private function __sizeChanged() : void
      {
         this.adjustList();
      }
      
      private function adjustList() : void
      {
         var _loc1_:TabItem = null;
         var _loc2_:int = 0;
         var _loc4_:int = this.calculateItemsWidth();
         if(_loc4_ > this._list.width)
         {
            while(_loc4_ > this._list.width)
            {
               _loc1_ = this.findOldestOnlineItem();
               if(_loc1_ != null)
               {
                  _loc4_ = _loc4_ - _loc1_.width;
                  this._list.removeChild(_loc1_.button);
                  continue;
               }
               break;
            }
         }
         else if(_loc4_ < this._list.width)
         {
            _loc2_ = this._list.width - _loc4_;
            while(_loc2_ > 0)
            {
               _loc1_ = this.findOldestOfflineItem();
               if(_loc1_ != null)
               {
                  if(_loc1_.width < _loc2_)
                  {
                     _loc2_ = _loc2_ - _loc1_.width;
                     this._list.addChild(_loc1_.button);
                     continue;
                  }
                  break;
               }
               break;
            }
         }
         var _loc3_:int = this._tabs.length - this._list.numChildren;
         this._moreBtn.title = "" + _loc3_;
         this._moreBtn.visible = _loc3_ > 0;
      }
      
      private function calculateItemsWidth() : int
      {
         var _loc2_:GObject = null;
         var _loc4_:int = this._list.numChildren;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < _loc4_)
         {
            _loc2_ = this._list.getChildAt(_loc1_);
            _loc3_ = _loc3_ + (_loc2_.width + this._list.columnGap);
            _loc1_++;
         }
         return _loc3_;
      }
      
      private function findOldestOnlineItem() : TabItem
      {
         var _loc1_:GObject = null;
         var _loc2_:TabItem = null;
         var _loc3_:int = 0;
         var _loc7_:* = null;
         var _loc6_:int = this._list.numChildren;
         var _loc4_:* = 2147483647;
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc1_ = this._list.getChildAt(_loc5_);
            _loc2_ = TabItem(_loc1_.data);
            _loc3_ = _loc2_.visitTime;
            if(_loc3_ < _loc4_ && _loc5_ != this._list.selectedIndex)
            {
               _loc4_ = _loc3_;
               _loc7_ = _loc2_;
            }
            _loc5_++;
         }
         return _loc7_;
      }
      
      private function findNewestOnlineItem() : TabItem
      {
         var _loc1_:GObject = null;
         var _loc2_:TabItem = null;
         var _loc3_:int = 0;
         var _loc7_:* = null;
         var _loc6_:int = this._list.numChildren;
         var _loc4_:* = -2147483648;
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc1_ = this._list.getChildAt(_loc5_);
            _loc2_ = TabItem(_loc1_.data);
            _loc3_ = _loc2_.visitTime;
            if(_loc3_ > _loc4_ && _loc5_ != this._list.selectedIndex)
            {
               _loc4_ = _loc3_;
               _loc7_ = _loc2_;
            }
            _loc5_++;
         }
         return _loc7_;
      }
      
      private function findOldestOfflineItem() : TabItem
      {
         var _loc1_:TabItem = null;
         var _loc2_:int = 0;
         var _loc6_:* = null;
         var _loc5_:int = this._tabs.length;
         var _loc3_:* = 2147483647;
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc1_ = this._tabs[_loc4_];
            if(_loc1_.button.parent == null)
            {
               _loc2_ = _loc1_.visitTime;
               if(_loc2_ < _loc3_)
               {
                  _loc3_ = _loc2_;
                  _loc6_ = _loc1_;
               }
            }
            _loc4_++;
         }
         return _loc6_;
      }
   }
}

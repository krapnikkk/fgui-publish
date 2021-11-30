package fairygui.editor.extui
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.plugin.IMenuBar;
   import fairygui.event.GTouchEvent;
   import flash.events.Event;
   
   public class MenuBar implements IMenuBar
   {
       
      
      private var _list:GList;
      
      private var _popup:PopupMenu;
      
      public function MenuBar(param1:GList)
      {
         super();
         this._list = param1;
      }
      
      public function addMenu(param1:String, param2:String, param3:PopupMenu, param4:String = null) : void
      {
         var _loc6_:GObject = null;
         var _loc7_:int = 0;
         var _loc5_:GButton = this._list.getFromPool().asButton;
         _loc5_.name = param1;
         _loc5_.title = param2;
         _loc5_.addEventListener("beginGTouch",this.__mouseDown);
         _loc5_.addEventListener("rollOver",this.__rollOver);
         _loc5_.data = param3;
         if(param4 == null)
         {
            this._list.addChild(_loc5_);
         }
         else
         {
            _loc6_ = this._list.getChild(param4);
            if(_loc6_ != null)
            {
               _loc7_ = this._list.getChildIndex(_loc6_);
               this._list.addChildAt(_loc5_,_loc7_);
            }
            else
            {
               this._list.addChild(_loc5_);
            }
         }
      }
      
      public function getMenu(param1:String) : PopupMenu
      {
         var _loc2_:GButton = this._list.getChild(param1) as GButton;
         if(_loc2_ != null)
         {
            return PopupMenu(_loc2_.data);
         }
         return null;
      }
      
      public function removeMenu(param1:String) : void
      {
         var _loc2_:GButton = this._list.getChild(param1) as GButton;
         if(_loc2_ != null)
         {
            this._list.removeChildToPool(_loc2_);
         }
      }
      
      public function clearAll() : void
      {
         this._list.removeChildrenToPool();
      }
      
      private function popup(param1:GObject) : void
      {
         var _loc2_:PopupMenu = PopupMenu(param1.data);
         _loc2_.show(param1,true);
         this._popup = _loc2_;
         _loc2_.contentPane.addEventListener("removedFromStage",this.__popupWinClosed);
      }
      
      private function __rollOver(param1:Event) : void
      {
         var _loc2_:GObject = null;
         if(this._popup)
         {
            this._list.root.hidePopup(this._popup.contentPane);
            _loc2_ = param1.currentTarget as GObject;
            this.popup(_loc2_);
            this._list.selectedIndex = this._list.getChildIndex(_loc2_);
         }
      }
      
      private function __mouseDown(param1:GTouchEvent) : void
      {
         var _loc2_:GObject = GObject(param1.currentTarget);
         this.popup(_loc2_);
      }
      
      private function __popupWinClosed(param1:Event) : void
      {
         this._list.selectedIndex = -1;
         this._popup = null;
      }
   }
}

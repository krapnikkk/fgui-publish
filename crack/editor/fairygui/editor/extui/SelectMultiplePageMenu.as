package fairygui.editor.extui
{
   import fairygui.Controller;
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EControllerPage;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class SelectMultiplePageMenu
   {
       
      
      private var _menu:PopupMenu;
      
      private var _callback:Function;
      
      private var _controller:EController;
      
      private var _value:Array;
      
      private var _editorWindow:EditorWindow;
      
      public function SelectMultiplePageMenu(param1:EditorWindow)
      {
         param1 = param1;
         var win:EditorWindow = param1;
         super();
         this._editorWindow = win;
         this._menu = new PopupMenu("ui://Basic/PopupMenu_check");
         this._menu.visibleItemCount = 20;
         this._menu.hideOnClickItem = false;
         this._menu.contentPane.getChild("b0").addClickListener(this.__selectAll);
         this._menu.contentPane.getChild("b1").addClickListener(this.__selectReverse);
         this._menu.contentPane.getChild("b2").addClickListener(this.__selectNone);
         this._menu.contentPane.getChild("b3").addClickListener(function():void
         {
            _menu.hide();
         });
      }
      
      public function show(param1:EController, param2:Array, param3:Function, param4:GObject) : void
      {
         var _loc5_:Vector.<EControllerPage> = null;
         var _loc7_:int = 0;
         var _loc10_:int = 0;
         var _loc9_:EControllerPage = null;
         var _loc8_:GComponent = null;
         var _loc6_:Controller = null;
         this._menu.clearItems();
         if(!param2)
         {
            this._value = [];
         }
         else
         {
            this._value = param2;
         }
         this._controller = param1;
         if(this._controller)
         {
            _loc5_ = this._controller.getPages();
            _loc7_ = _loc5_.length;
            _loc10_ = 0;
            while(_loc10_ < _loc7_)
            {
               _loc9_ = _loc5_[_loc10_];
               _loc8_ = this._menu.addItem("" + _loc10_ + (!!_loc9_.name?":" + _loc9_.name:""),this.__selectPage).asCom;
               _loc6_ = _loc8_.getController("checked");
               _loc8_.name = _loc9_.id;
               if(this._value.indexOf(_loc9_.id) != -1)
               {
                  _loc6_.selectedIndex = 2;
               }
               else
               {
                  _loc6_.selectedIndex = 1;
               }
               _loc10_++;
            }
         }
         this._callback = param3;
         this._menu.contentPane.width = param4.width;
         this._menu.show(param4);
      }
      
      private function __selectPage(param1:ItemEvent) : void
      {
         var _loc3_:GButton = null;
         var _loc4_:Controller = null;
         var _loc7_:Array = [];
         var _loc5_:int = this._menu.itemCount;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = this._menu.list.getChildAt(_loc6_).asButton;
            _loc4_ = _loc3_.getController("checked");
            if(_loc4_.selectedIndex == 2)
            {
               _loc7_.push(_loc3_.name);
            }
            _loc6_++;
         }
         var _loc2_:Function = this._callback;
      }
      
      private function __selectAll(param1:Event) : void
      {
         var _loc5_:Vector.<EControllerPage> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:Array = [];
         if(this._controller)
         {
            _loc5_ = this._controller.getPages();
            _loc2_ = _loc5_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc6_.push(_loc5_[_loc3_].id);
               _loc3_++;
            }
         }
         this._menu.hide();
         var _loc4_:Function = this._callback;
         this._callback = null;
      }
      
      private function __selectNone(param1:Event) : void
      {
         this._menu.hide();
         var _loc2_:Function = this._callback;
         this._callback = null;
      }
      
      private function __selectReverse(param1:Event) : void
      {
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:GButton = null;
         var _loc4_:Controller = null;
         var _loc7_:Array = [];
         if(this._controller)
         {
            _loc6_ = this._menu.itemCount;
            _loc2_ = 0;
            while(_loc2_ < _loc6_)
            {
               _loc3_ = this._menu.list.getChildAt(_loc2_).asButton;
               _loc4_ = _loc3_.getController("checked");
               if(_loc4_.selectedIndex != 2)
               {
                  _loc7_.push(_loc3_.name);
               }
               _loc2_++;
            }
         }
         this._menu.hide();
         var _loc5_:Function = this._callback;
         this._callback = null;
      }
   }
}

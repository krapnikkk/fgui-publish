package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GComponent;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.UIObjectFactory;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.gear.EGearDisplay;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class EventPropsPanel extends PropsPanel
   {
       
      
      private var _gear:EGearDisplay;
      
      private var _list:GList;
      
      private var _menu:PopupMenu;
      
      private var eventType:String = "";
      
      public function EventPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2,"Fysheji");
         UIObjectFactory.setPackageItemExtension("ui://fdrdo66zmih4v",EventPropsItem);
      }
      
      override public function update(param1:Vector.<EGObject>) : void
      {
         super.update(param1);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:GComboBox = null;
         super.constructFromXML(param1);
         this._list = getChild("list").asList;
         this._list.removeChildrenToPool();
         getChild("addS").addClickListener(this.__clickAddS);
         getChild("addC").addClickListener(this.__clickAddC);
         getChild("addE").addClickListener(this.__clickAddE);
         getChild("addA").addClickListener(this.__clickAddA);
         GButton(getChild("addC")).tooltips = "添加C事件";
         GButton(getChild("addS")).tooltips = "添加S启动事件";
         GButton(getChild("addE")).tooltips = "添加L事件";
         GButton(getChild("addA")).tooltips = "添加消息监听";
         this._menu = new PopupMenu();
         this._menu.contentPane.width = 250;
      }
      
      private function __clickGroupBtn(param1:ItemEvent) : void
      {
         var _loc2_:int = param1.itemObject.name;
      }
      
      private function setHeight(param1:int) : void
      {
         this.height = 8 + param1;
         GComponent(getChild("bg")).getChild("n9").height = 5 + param1 - GComponent(getChild("bg")).getChild("n9").y;
      }
      
      private function __clickAddS(param1:Event) : void
      {
         var _loc2_:int = 0;
         this._menu.clearItems();
         _loc2_ = 0;
         while(_loc2_ < _editorWindow.plugInManager.eventExtensionIDs.length)
         {
            if(_editorWindow.plugInManager.eventExtensionTyps[_loc2_] == "Nomal")
            {
               this._menu.addItem(_editorWindow.plugInManager.eventExtensionIDs[_loc2_],this.__clickGearType).name = _editorWindow.plugInManager.eventExtensionNames[_loc2_];
            }
            _loc2_++;
         }
         this.eventType = "S";
         this._menu.show(getChild("addS"));
      }
      
      private function __clickAddC(param1:Event) : void
      {
         var _loc2_:int = 0;
         this._menu.clearItems();
         _loc2_ = 0;
         while(_loc2_ < _editorWindow.plugInManager.eventExtensionIDs.length)
         {
            if(_editorWindow.plugInManager.eventExtensionTyps[_loc2_] == "Nomal")
            {
               this._menu.addItem(_editorWindow.plugInManager.eventExtensionIDs[_loc2_],this.__clickGearType).name = _editorWindow.plugInManager.eventExtensionNames[_loc2_];
            }
            _loc2_++;
         }
         this.eventType = "C";
         this._menu.show(getChild("addC"));
      }
      
      private function __clickAddE(param1:Event) : void
      {
         var _loc2_:int = 0;
         this._menu.clearItems();
         _loc2_ = 0;
         while(_loc2_ < _editorWindow.plugInManager.eventExtensionIDs.length)
         {
            if(_editorWindow.plugInManager.eventExtensionTyps[_loc2_] == "Nomal")
            {
               this._menu.addItem(_editorWindow.plugInManager.eventExtensionIDs[_loc2_],this.__clickGearType).name = _editorWindow.plugInManager.eventExtensionNames[_loc2_];
            }
            _loc2_++;
         }
         this.eventType = "E";
         this._menu.show(getChild("addE"));
      }
      
      private function __clickAddA(param1:Event) : void
      {
         var _loc2_:int = 0;
         this._menu.clearItems();
         _loc2_ = 0;
         while(_loc2_ < _editorWindow.plugInManager.eventExtensionIDs.length)
         {
            if(_editorWindow.plugInManager.eventExtensionTyps[_loc2_] == "A")
            {
               this._menu.addItem(_editorWindow.plugInManager.eventExtensionIDs[_loc2_],this.__clickGearType).name = _editorWindow.plugInManager.eventExtensionNames[_loc2_];
            }
            _loc2_++;
         }
         this.eventType = "A";
         this._menu.show(getChild("addA"));
      }
      
      private function __clickAddL(param1:Event) : void
      {
         var _loc2_:int = 0;
         this._menu.clearItems();
         _loc2_ = 0;
         while(_loc2_ < _editorWindow.plugInManager.eventExtensionIDs.length)
         {
            this._menu.addItem(_editorWindow.plugInManager.eventExtensionIDs[_loc2_],this.__clickGearType).name = _editorWindow.plugInManager.eventExtensionNames[_loc2_];
            _loc2_++;
         }
         this.eventType = "L";
         this._menu.show(getChild("addE"));
      }
      
      private function __clickGearType(param1:ItemEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:* = -1;
         _loc3_ = 0;
         while(_loc3_ < _editorWindow.plugInManager.eventExtensionIDs.length)
         {
            if(_editorWindow.plugInManager.eventExtensionNames[_loc3_] == param1.itemObject.name)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(!_object.checkEvent(_editorWindow.plugInManager.eventExtensionIDs[_loc2_] + this.eventType))
         {
            _object.addEvent(_editorWindow.plugInManager.eventExtensionIDs[_loc2_] + this.eventType,{
               "eventName":param1.itemObject.name,
               "type":this.eventType,
               "title":""
            });
         }
         this.setObjectToUI();
         this.eventType = "";
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc2_:* = null;
         this._gear = _object.gearDisplay;
         this._list.removeChildrenToPool();
         var _loc4_:int = 0;
         var _loc3_:* = _object.clcikEvents;
         for(var _loc1_ in _object.clcikEvents)
         {
            _loc2_ = this._list.addItemFromPool("ui://fdrdo66zmih4v");
            EventPropsItem(_loc2_).setObjectToUI(_object,_loc1_);
            GComponent(_loc2_).getChild("title").text = _object.clcikEvents[_loc1_]["eventName"];
            GComponent(_loc2_).getChild("dataText").text = _object.clcikEvents[_loc1_]["title"];
            GComponent(_loc2_).getChild("type").text = _object.clcikEvents[_loc1_]["type"];
         }
         this._list.resizeToFit();
         this.setHeight(this._list.y + this._list.viewHeight);
      }
   }
}

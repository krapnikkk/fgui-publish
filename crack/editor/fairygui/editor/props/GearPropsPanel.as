package fairygui.editor.props
{
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGGroup;
   import fairygui.editor.gui.EGLoader;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EGTextField;
   import fairygui.editor.gui.gear.EGearBase;
   import fairygui.editor.gui.gear.EGearDisplay;
   import fairygui.editor.gui.gear.EIAnimationGear;
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class GearPropsPanel extends PropsPanel
   {
       
      
      private var _gear:EGearDisplay;
      
      private var _list:GList;
      
      private var _menu:PopupMenu;
      
      public function GearPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override public function update(param1:Vector.<EGObject>) : void
      {
         super.update(param1);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this._list = getChild("list").asList;
         this._list.removeChildrenToPool();
         getChild("visController").addClickListener(this.__selectController);
         getChild("visPages").addClickListener(this.__selectPages);
         getChild("visController").addEventListener("__submit",this.__visControllerChanged,false,1);
         getChild("add").addClickListener(this.__clickAdd);
         this._menu = new PopupMenu();
         this._menu.contentPane.width = 250;
         this._menu.addItem(Consts.g.text164,this.__clickGearType).name = "gearXY";
         this._menu.addItem(Consts.g.text165,this.__clickGearType).name = "gearSize";
         this._menu.addItem(Consts.g.text166,this.__clickGearType).name = "gearColor";
         this._menu.addItem(Consts.g.text198,this.__clickGearType).name = "gearLook";
         this._menu.addItem(Consts.g.text301,this.__clickGearType).name = "gearText";
         this._menu.addItem(Consts.g.text302,this.__clickGearType).name = "gearIcon";
         this._menu.addItem(Consts.g.text167,this.__clickGearType).name = "gearAni";
      }
      
      override protected function setObjectToUI() : void
      {
         this._gear = _object.gearDisplay;
         getChild("visController").text = UtilsStr.readableString(this._gear.controller);
         var _loc2_:GObject = getChild("visPages");
         if(this._gear.controllerObject != null)
         {
            _loc2_.visible = true;
            _loc2_.text = this._gear.controllerObject.getNamesByIds(this._gear.pages,Consts.g.text331);
         }
         else
         {
            _loc2_.visible = false;
         }
         this._list.removeChildrenToPool();
         var _loc1_:int = 1;
         while(_loc1_ < 8)
         {
            if(_object.shouldDisplayGear(_loc1_))
            {
               GearPropsItem(this._list.addItemFromPool()).setObjectToUI(_object.getGear(_loc1_));
            }
            _loc1_++;
         }
         this._list.resizeToFit();
      }
      
      private function __clickAdd(param1:Event) : void
      {
         this._menu.setItemGrayed("gearLook",_object is EGGroup);
         this._menu.setItemGrayed("gearColor",!(_object is EIColorGear) || _object is EGComponent && EGComponent(_object).extentionId != "Label");
         this._menu.setItemGrayed("gearAni",!(_object is EIAnimationGear));
         this._menu.setItemGrayed("gearText",!(_object is EGTextField) && !(_object is EGComponent));
         this._menu.setItemGrayed("gearIcon",!(_object is EGLoader) && !(_object is EGComponent));
         this._menu.show(getChild("add"));
      }
      
      private function __clickGearType(param1:ItemEvent) : void
      {
         var _loc3_:int = EGObject.GearXMLKeys[param1.itemObject.name];
         var _loc2_:EGearBase = _object.getGear(_loc3_);
         if(!_loc2_.display)
         {
            _loc2_.setProperty("display",true);
            this.setObjectToUI();
         }
      }
      
      private function __selectController(param1:Event) : void
      {
         _editorWindow.selectControllerMenu.show(GObject(param1.currentTarget),_object.parent);
      }
      
      private function __selectPages(param1:Event) : void
      {
         _editorWindow.selectMultiplePageMenu.show(this._gear.controllerObject,this._gear.pages,this.__visPagesChanged,GObject(param1.currentTarget));
      }
      
      private function __visControllerChanged(param1:Event) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:String = param1.currentTarget.text;
         if(_loc4_ != this._gear.controller)
         {
            _loc2_ = this._gear.toXML();
            this._gear.controller = _loc4_;
            _loc3_ = this._gear.toXML();
            _editorWindow.activeComDocument.actionHistory.action_gearSet(_object,0,"controller",_loc2_,_loc3_);
            this.setObjectToUI();
         }
      }
      
      private function __visPagesChanged(param1:Array) : void
      {
         var _loc3_:String = this._gear.pages.join(",");
         this._gear.pages = param1;
         var _loc2_:String = this._gear.pages.join(",");
         if(_loc3_ != _loc2_)
         {
            _editorWindow.activeComDocument.actionHistory.action_gearSet(_object,0,"pages",_loc3_,_loc2_);
         }
         this.setObjectToUI();
      }
   }
}

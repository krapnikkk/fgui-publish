package fairygui.editor.props
{
   import fairygui.Controller;
   import fairygui.GButton;
   import fairygui.GLabel;
   import fairygui.GObject;
   import fairygui.editor.ComDocument;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.gear.EGearBase;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   
   public class GearPropsItem extends GLabel
   {
      
      private static var gearNames:Array;
       
      
      private var _object:EGObject;
      
      private var _gear:EGearBase;
      
      private var _c1:Controller;
      
      public function GearPropsItem()
      {
         super();
         if(!gearNames)
         {
            gearNames = [Consts.g.text163,Consts.g.text164,Consts.g.text165,Consts.g.text198,Consts.g.text166,Consts.g.text167,Consts.g.text301,Consts.g.text302];
         }
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         getChild("controller").addClickListener(this.__selectController);
         getChild("controller").addEventListener("__submit",this.__controllerChanged);
         getChild("tween").addEventListener("stateChanged",this.__tweenPropChanged);
         getChild("tweenEdit").addClickListener(this.__clickTweenEdit);
         getChild("delete").addClickListener(this.__clickDelete);
         this._c1 = getController("c1");
      }
      
      public function setObjectToUI(param1:EGearBase) : void
      {
         this._object = param1.owner;
         this._gear = param1;
         this.title = gearNames[this._gear.gearIndex];
         getChild("n49").visible = this._gear.gearIndex == 1 || this._gear.gearIndex == 2 || this._gear.gearIndex == 3 || this._gear.gearIndex == 4;
         getChild("tween").asButton.selected = this._gear.tween;
         getChild("n49").visible = false;
         getChild("controller").text = UtilsStr.readableString(this._gear.controller);
         this._c1.selectedIndex = !!this._gear.controller?0:1;
      }
      
      private function __controllerChanged(param1:Event) : void
      {
         var _loc4_:XML = null;
         var _loc2_:XML = null;
         var _loc5_:ComDocument = EditorWindow.getInstance(this).activeComDocument;
         var _loc3_:String = param1.currentTarget.text;
         if(_loc3_ != this._gear.controller)
         {
            _loc4_ = this._gear.toXML();
            this._gear.controller = _loc3_;
            this._c1.selectedIndex = !!this._gear.controller?0:1;
            _loc2_ = this._gear.toXML();
            _loc5_.actionHistory.action_gearSet(this._object,this._gear.gearIndex,"controller",_loc4_,_loc2_);
            this.setObjectToUI(this._gear);
         }
      }
      
      private function __tweenPropChanged(param1:Event) : void
      {
         var _loc2_:GObject = GObject(param1.currentTarget);
         this._gear.setProperty("tween",GButton(_loc2_).selected);
      }
      
      private function __clickTweenEdit(param1:Event) : void
      {
         var _loc2_:TweenPropsPanel = EditorWindow.getInstance(this).mainPanel.propsPanelList.tweenProps;
         EditorWindow.getInstance(this).groot.showPopup(_loc2_,GObject(param1.currentTarget));
         _loc2_.update2(this._gear);
      }
      
      private function __clickDelete(param1:Event) : void
      {
         this._gear.setProperty("display",false);
         var _loc2_:ComDocument = EditorWindow.getInstance(this).activeComDocument;
         _loc2_.setUpdateFlag();
      }
      
      private function __selectController(param1:Event) : void
      {
         EditorWindow.getInstance(this).selectControllerMenu.show(GObject(param1.currentTarget),this._object.parent);
      }
   }
}

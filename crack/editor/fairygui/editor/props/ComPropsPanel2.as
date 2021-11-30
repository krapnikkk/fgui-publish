package fairygui.editor.props
{
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   
   public class ComPropsPanel2 extends PropsPanel
   {
       
      
      public function ComPropsPanel2(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         getChild("pageController").addClickListener(this.__selectController);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc2_:GObject = null;
         _loc2_ = getChild("pageController");
         var _loc1_:EGComponent = EGComponent(_object);
         if(_loc1_.overflow == "scroll" && _loc1_.scrollPageMode)
         {
            _loc2_.enabled = true;
            _loc2_.text = UtilsStr.readableString(_loc1_.pageController);
         }
         else
         {
            _loc2_.enabled = false;
            _loc2_.text = Consts.g.text331;
         }
         fillControllerSettingsList();
      }
      
      private function __selectController(param1:Event) : void
      {
         _editorWindow.selectControllerMenu.show(GObject(param1.currentTarget),_object.parent);
      }
   }
}

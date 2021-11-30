package fairygui.editor.props
{
   import fairygui.GComboBox;
   import fairygui.UIObjectFactory;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGVideo;
   import flash.events.Event;
   
   public class VideoPropsPanel extends PropsPanel
   {
       
      
      public function VideoPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2,"Fysheji");
         UIObjectFactory.setPackageItemExtension("ui://fdrdo66zmih4v",EventPropsItem);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:GComboBox = null;
         super.constructFromXML(param1);
         this.getChild("videSrc").addEventListener("focusOut",this.__focusOut);
      }
      
      private function __focusOut(param1:Event) : void
      {
         this._object.setProperty("videSrc",getChild("videSrc").text);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGVideo = EGVideo(_object);
         getChild("videSrc").text = _loc1_.videSrc;
         getChild("autoPlay").asButton.selected = _loc1_.autoPlay;
         getChild("showCtrol").asButton.selected = _loc1_.showCtrol;
      }
   }
}

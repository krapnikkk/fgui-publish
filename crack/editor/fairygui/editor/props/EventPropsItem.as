package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GImage;
   import fairygui.GTextField;
   import fairygui.UIPackage;
   import fairygui.editor.ComDocument;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGObject;
   import fairygui.event.StateChangeEvent;
   import flash.events.Event;
   
   public class EventPropsItem extends GComponent
   {
      
      public static const URL:String = "ui://fdrdo66zmih4v";
       
      
      public var n9:GImage;
      
      public var title:GTextField;
      
      public var delete1:GButton;
      
      private var _object:EGObject;
      
      private var _key:String;
      
      public function EventPropsItem()
      {
         super();
      }
      
      public static function createInstance() : EventPropsItem
      {
         return EventPropsItem(UIPackage.createObject("Fysheji","EventPropsItem"));
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         n9 = GImage(this.getChildAt(0));
         title = GTextField(this.getChildAt(1));
         delete1 = GButton(this.getChildAt(2));
         this.delete1.addClickListener(this.onDelete);
         this.getChild("dataText").addEventListener("focusOut",this.__focusOut);
      }
      
      public function setObjectToUI(param1:EGObject, param2:String) : void
      {
         this._object = param1;
         this._key = param2;
      }
      
      private function onDelete(param1:Event) : void
      {
         this._object.removeEvent(this._key);
         var _loc2_:ComDocument = EditorWindow.getInstance(this).activeComDocument;
         _loc2_.setUpdateFlag();
         dispatchEvent(new StateChangeEvent("stateChanged"));
      }
      
      private function __focusOut(param1:Event) : void
      {
         this._object.updateEvent(this._key,{
            "eventName":this.getChild("title").text,
            "title":this.getChild("dataText").text,
            "type":this.getChild("type").text
         });
      }
   }
}

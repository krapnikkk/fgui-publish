package fairygui.editor.extui
{
   import fairygui.Controller;
   import fairygui.GComponent;
   import fairygui.GLabel;
   import fairygui.editor.ComDocument;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.props.SelectObjectPanel;
   import flash.events.Event;
   
   public class ChildObjectInput extends GLabel
   {
       
      
      private var _c1:Controller;
      
      private var _value:EGObject;
      
      public var typeFilter:Array;
      
      public function ChildObjectInput()
      {
         super();
      }
      
      public function set value(param1:EGObject) : void
      {
         this._value = param1;
         if(this._value && (this._value.editMode == 3 || this._value.parent))
         {
            this._c1.selectedIndex = 0;
            if(this._value.parent == null)
            {
               this.title = Consts.g.text170;
            }
            else
            {
               this.title = this._value.toString();
            }
            this.icon = Icons.all[this._value.objectType];
         }
         else
         {
            this._c1.selectedIndex = 1;
         }
      }
      
      public function get value() : EGObject
      {
         return this._value;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this._c1 = getController("c1");
         addClickListener(this.__click);
         getChild("clear").addClickListener(this.__clear);
      }
      
      private function __click(param1:Event) : void
      {
         if(!this.enabled)
         {
            return;
         }
         var _loc3_:EditorWindow = EditorWindow.getInstance(this);
         var _loc2_:ComDocument = _loc3_.activeComDocument;
         _loc2_.startSelectingObject(this._value);
         SelectObjectPanel.callback = this.__objectSelected;
         SelectObjectPanel.callbackData = param1.currentTarget.parent;
      }
      
      private function __objectSelected(param1:EGObject, param2:GComponent) : void
      {
         if(this.typeFilter != null)
         {
            if(this.typeFilter.indexOf(param1.objectType) == -1)
            {
               param1.pkg.project.editorWindow.alert(Consts.g.text326);
               return;
            }
         }
         this.value = param1;
         SelectObjectPanel.callback = null;
         SelectObjectPanel.callbackData = null;
         this.dispatchEvent(new SubmitEvent("__submit",false,false));
      }
      
      private function __clear(param1:Event) : void
      {
         if(!this.enabled)
         {
            return;
         }
         param1.stopPropagation();
         this.value = null;
         this.dispatchEvent(new SubmitEvent("__submit",false,false));
      }
   }
}

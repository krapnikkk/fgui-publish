package fairygui.editor.extui
{
   import fairygui.GButton;
   import fairygui.event.GTouchEvent;
   import fairygui.utils.GTimers;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class EditableTreeItem extends GButton
   {
       
      
      private var _toggleClickCount:int;
      
      private var _active:Boolean;
      
      public function EditableTreeItem()
      {
         super();
         this._toggleClickCount = 2;
         this._active = true;
      }
      
      public function get toggleClickCount() : int
      {
         return this._toggleClickCount;
      }
      
      public function set toggleClickCount(param1:int) : void
      {
         this._toggleClickCount = param1;
      }
      
      public function setActive(param1:Boolean) : void
      {
         if(this._active != param1)
         {
            this._active = param1;
            getChild("n1").alpha = !!this._active?1:0.5;
         }
      }
      
      public function set editable(param1:Boolean) : void
      {
         this.getChild("input").asTextInput.editable = param1;
      }
      
      public function get editable() : Boolean
      {
         return this.getChild("input").asTextInput.editable;
      }
      
      public function startEditing() : void
      {
         this.getChild("input").text = this.text;
         getController("c1").selectedIndex = 1;
         var _loc2_:TextField = this.getChild("input").displayObject as TextField;
         this.root.nativeStage.focus = _loc2_;
         var _loc1_:int = _loc2_.text.length;
         _loc2_.setSelection(_loc1_,0);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         getController("c1").selectedIndex = 0;
         this.getChild("input").addEventListener("focusOut",this.__focusOut);
         this.getChild("input").addEventListener("keyDown",this.__keyDown);
         addClickListener(this.__click);
      }
      
      private function __click(param1:GTouchEvent) : void
      {
         if(this._toggleClickCount != 0 && param1.clickCount == this._toggleClickCount && this.getChild("input").asTextInput.editable)
         {
            this.startEditing();
         }
      }
      
      private function __focusOut(param1:Event) : void
      {
         getController("c1").selectedIndex = 0;
         var _loc2_:String = this.getChild("input").text;
         if(_loc2_ != this.text)
         {
            this.text = _loc2_;
            this.dispatchEvent(new SubmitEvent("__submit"));
         }
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            GTimers.inst.callLater(this.__focusOut,null);
         }
         else if(param1.keyCode == 27)
         {
            getController("c1").selectedIndex = 0;
         }
      }
   }
}

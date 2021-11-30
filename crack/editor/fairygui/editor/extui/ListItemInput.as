package fairygui.editor.extui
{
   import fairygui.Controller;
   import fairygui.GLabel;
   import fairygui.GTextInput;
   import fairygui.event.GTouchEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class ListItemInput extends GLabel
   {
       
      
      private var _toggleClickCount:int;
      
      private var _c1:Controller;
      
      private var _input:GTextInput;
      
      public function ListItemInput()
      {
         super();
         this._toggleClickCount = 2;
      }
      
      public function get toggleClickCount() : int
      {
         return this._toggleClickCount;
      }
      
      public function set toggleClickCount(param1:int) : void
      {
         this._toggleClickCount = param1;
      }
      
      override public function set editable(param1:Boolean) : void
      {
         this._input.editable = param1;
      }
      
      override public function get editable() : Boolean
      {
         return this._input.editable;
      }
      
      public function startEditing() : void
      {
         this._input.text = this.text;
         this._c1.selectedIndex = 1;
         var _loc2_:TextField = this._input.displayObject as TextField;
         this.root.nativeStage.focus = _loc2_;
         var _loc1_:int = _loc2_.text.length;
         _loc2_.setSelection(_loc1_,0);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this._c1 = getController("c1");
         this._c1.selectedIndex = 0;
         this._input = this.getChild("input").asTextInput;
         this._input.addEventListener("focusOut",this.__focusOut);
         this._input.addEventListener("keyDown",this.__keyDown);
         addClickListener(this.__click);
      }
      
      private function __click(param1:GTouchEvent) : void
      {
         if(this._toggleClickCount != 0 && param1.clickCount == this._toggleClickCount && this._input.editable && this._c1.selectedIndex == 0)
         {
            this.startEditing();
         }
      }
      
      private function __focusOut(param1:Event) : void
      {
         this._c1.selectedIndex = 0;
         var _loc2_:String = this._input.text;
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
            this.__focusOut(null);
         }
         else if(param1.keyCode == 27)
         {
            this._c1.selectedIndex = 0;
         }
      }
   }
}

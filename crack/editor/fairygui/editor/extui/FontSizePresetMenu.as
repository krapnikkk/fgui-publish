package fairygui.editor.extui
{
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   
   public class FontSizePresetMenu
   {
       
      
      public var needUpdate:Boolean;
      
      private var _menu:PopupMenu;
      
      private var _input:NumericInput;
      
      private var _editorWindow:EditorWindow;
      
      public function FontSizePresetMenu(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this.needUpdate = true;
         this._menu = new PopupMenu();
         this._menu.contentPane.width = 200;
      }
      
      public function show(param1:NumericInput, param2:GObject = null) : void
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         if(this.needUpdate)
         {
            this._menu.clearItems();
            _loc6_ = this._editorWindow.project.settingsCenter.common.fontSizeScheme;
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc3_ = _loc6_[_loc7_];
               UtilsStr.trim(_loc3_);
               _loc4_ = _loc3_;
               _loc5_ = _loc4_.lastIndexOf(" ");
               if(_loc5_ != -1)
               {
                  _loc4_ = _loc4_.substr(_loc5_ + 1);
               }
               this._menu.addItem(_loc3_,this.__selectSize).name = _loc4_;
               _loc7_++;
            }
         }
         if(param2 == null)
         {
            param2 = param1;
         }
         this._input = param1;
         this._menu.show(param2);
      }
      
      private function __selectSize(param1:ItemEvent) : void
      {
         this._input.value = parseInt(param1.itemObject.name);
         this._input.dispatchEvent(new SubmitEvent("__submit"));
      }
   }
}

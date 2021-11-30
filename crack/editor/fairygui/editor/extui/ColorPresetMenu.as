package fairygui.editor.extui
{
   import fairygui.GButton;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   
   public class ColorPresetMenu
   {
       
      
      public var needUpdate:Boolean;
      
      private var _menu:PopupMenu;
      
      private var _input:ColorInput;
      
      private var _editorWindow:EditorWindow;
      
      public function ColorPresetMenu(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this.needUpdate = true;
         this._menu = new PopupMenu();
         this._menu.contentPane.width = 220;
         this._menu.list.defaultItem = "ui://Basic/ColorMenuItem";
      }
      
      public function show(param1:ColorInput, param2:GObject = null) : void
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc6_:int = 0;
         var _loc5_:GButton = null;
         if(this.needUpdate)
         {
            this._menu.clearItems();
            _loc7_ = this._editorWindow.project.settingsCenter.common.colorScheme;
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc3_ = _loc7_[_loc8_];
               UtilsStr.trim(_loc3_);
               _loc4_ = _loc3_;
               _loc6_ = _loc4_.lastIndexOf(" ");
               if(_loc6_ != -1)
               {
                  _loc4_ = _loc4_.substr(_loc6_ + 1);
               }
               _loc5_ = this._menu.addItem(_loc3_,this.__selectColor);
               _loc5_.name = _loc4_;
               _loc5_.getChild("shape").asGraph.color = UtilsStr.convertFromHtmlColor(_loc4_,false);
               _loc8_++;
            }
         }
         if(param2 == null)
         {
            param2 = param1;
         }
         this._input = param1;
         this._menu.show(param2);
      }
      
      private function __selectColor(param1:ItemEvent) : void
      {
         this._input.colorValue = UtilsStr.convertFromHtmlColor(param1.itemObject.name,false);
         this._input.dispatchEvent(new SubmitEvent("__submit"));
      }
   }
}

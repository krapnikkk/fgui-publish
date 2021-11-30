package fairygui.editor.extui
{
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EGComponent;
   import fairygui.event.ItemEvent;
   
   public class SelectControllerMenu
   {
       
      
      private var _menu:PopupMenu;
      
      private var _input:GObject;
      
      private var _editorWindow:EditorWindow;
      
      public function SelectControllerMenu(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this._menu = new PopupMenu("ui://Basic/PopupMenu2");
         this._menu.visibleItemCount = 20;
      }
      
      public function show(param1:GObject, param2:EGComponent, param3:Boolean = false, param4:GObject = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:EGComponent = null;
         this._menu.clearItems();
         this._menu.addItem(Consts.g.text331,this.__selectController).name = "";
         this.addControllers(param2,false);
         if(param3)
         {
            _loc5_ = param2.numChildren;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = param2.getChildAt(_loc6_) as EGComponent;
               if(_loc7_)
               {
                  this.addControllers(_loc7_,true);
               }
               _loc6_++;
            }
         }
         this._input = param1;
         if(param4 == null)
         {
            param4 = param1;
         }
         this._menu.contentPane.width = param4.width;
         this._menu.show(param4);
      }
      
      private function addControllers(param1:EGComponent, param2:Boolean) : void
      {
         var _loc4_:EController = null;
         var _loc6_:String = null;
         var _loc5_:GObject = null;
         var _loc7_:Vector.<EController> = param1.controllers;
         var _loc8_:int = _loc7_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc8_)
         {
            _loc4_ = _loc7_[_loc3_];
            if(_loc4_.exported || !param2)
            {
               if(param2)
               {
                  _loc6_ = param1.name + "." + _loc4_.name;
               }
               else
               {
                  _loc6_ = _loc4_.name;
               }
               _loc5_ = this._menu.addItem(_loc6_,this.__selectController);
               if(param2)
               {
                  _loc5_.name = param1.id + "." + _loc4_.name;
               }
               else
               {
                  _loc5_.name = _loc4_.name;
               }
            }
            _loc3_++;
         }
      }
      
      private function __selectController(param1:ItemEvent) : void
      {
         this._menu.hide();
         this._input.text = param1.itemObject.name;
         this._input.dispatchEvent(new SubmitEvent("__submit"));
      }
   }
}

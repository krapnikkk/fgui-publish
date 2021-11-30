package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.ListItemInput;
   import fairygui.editor.gui.EGComboBox;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   
   public class ComboBoxEditDialog extends WindowBase
   {
       
      
      private var _comboBox:EGComboBox;
      
      private var _itemList:GList;
      
      public function ComboBoxEditDialog(param1:EditorWindow)
      {
         param1 = param1;
         var win:EditorWindow = param1;
         super();
         _editorWindow = win;
         this.contentPane = UIPackage.createObject("Builder","ComboBoxEditDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._itemList = contentPane.getChild("n19").asList;
         contentPane.getChild("n13").addClickListener(this.__save);
         contentPane.getChild("n14").addClickListener(closeEventHandler);
         contentPane.getChild("n28").addClickListener(function():void
         {
            addItem("","","");
         });
         contentPane.getChild("n29").addClickListener(function():void
         {
            var _loc1_:int = _itemList.selectedIndex;
            if(_loc1_ != -1)
            {
               _itemList.removeChildToPoolAt(_loc1_);
               if(_loc1_ >= _itemList.numChildren)
               {
                  _loc1_ = _itemList.numChildren - 1;
               }
               _itemList.selectedIndex = _loc1_;
            }
         });
         contentPane.getChild("n31").addClickListener(function():void
         {
            var _loc2_:GButton = null;
            var _loc1_:GButton = null;
            var _loc3_:int = _itemList.selectedIndex;
            if(_loc3_ > 0)
            {
               _loc2_ = _itemList.getChildAt(_loc3_).asButton;
               _loc1_ = _itemList.getChildAt(_loc3_ - 1).asButton;
               swapItem(_loc2_,_loc1_);
               _itemList.selectedIndex = _loc3_ - 1;
            }
         });
         contentPane.getChild("n32").addClickListener(function():void
         {
            var _loc2_:GButton = null;
            var _loc1_:GButton = null;
            var _loc3_:int = _itemList.selectedIndex;
            if(_loc3_ < _itemList.numChildren - 1)
            {
               _loc2_ = _itemList.getChildAt(_loc3_).asButton;
               _loc1_ = _itemList.getChildAt(_loc3_ + 1).asButton;
               swapItem(_loc2_,_loc1_);
               _itemList.selectedIndex = _loc3_ + 1;
            }
         });
      }
      
      private function addItem(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:GButton = this._itemList.addItemFromPool().asButton;
         _loc4_.getChild("text").text = param1;
         _loc4_.getChild("value").text = param2;
         _loc4_.getChild("icon").text = param3;
      }
      
      private function swapItem(param1:GButton, param2:GButton) : void
      {
         var _loc3_:String = null;
         _loc3_ = param1.getChild("text").text;
         param1.getChild("text").text = param2.getChild("text").text;
         param2.getChild("text").text = _loc3_;
         _loc3_ = param1.getChild("value").text;
         param1.getChild("value").text = param2.getChild("value").text;
         param2.getChild("value").text = _loc3_;
         _loc3_ = param1.getChild("icon").text;
         param1.getChild("icon").text = param2.getChild("icon").text;
         param2.getChild("icon").text = _loc3_;
      }
      
      public function open(param1:EGComboBox) : void
      {
         var _loc3_:Object = null;
         show();
         this._comboBox = param1;
         var _loc4_:Array = this._comboBox.items;
         this._itemList.removeChildrenToPool();
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_.length)
         {
            _loc3_ = _loc4_[_loc2_];
            this.addItem(_loc3_[0],_loc3_[1],_loc3_[2]);
            _loc2_++;
         }
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.editPanel.self.requestFocus();
      }
      
      private function __save(param1:Event) : void
      {
         var _loc2_:GComponent = null;
         var _loc5_:Array = [];
         var _loc3_:int = this._itemList.numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this._itemList.getChildAt(_loc4_).asCom;
            _loc5_.push([_loc2_.getChild("text").text,_loc2_.getChild("value").text,_loc2_.getChild("icon").text]);
            _loc4_++;
         }
         this._comboBox.setProperty("items",_loc5_);
         _editorWindow.mainPanel.propsPanelList.refresh();
         this.hide();
      }
      
      public function handleArrowKey(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this._itemList.handleArrowKey(param1);
      }
      
      public function handleKeyDownEvent(param1:KeyboardEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:GButton = null;
         var _loc3_:ListItemInput = null;
         if(param1.keyCode == 13)
         {
            _loc4_ = this._itemList.selectedIndex;
            if(_loc4_ != -1)
            {
               _loc2_ = this._itemList.getChildAt(_loc4_).asButton;
               _loc3_ = ListItemInput(_loc2_.getChild("text"));
               if(_loc3_.getChild("input").displayObject != param1.target)
               {
                  _loc3_.startEditing();
                  param1.preventDefault();
               }
            }
         }
      }
   }
}

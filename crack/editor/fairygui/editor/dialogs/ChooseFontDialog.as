package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.GTextField;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   import flash.text.Font;
   
   public class ChooseFontDialog extends WindowBase
   {
       
      
      private var _callback:Function;
      
      private var _list:GList;
      
      private var _built:Boolean;
      
      public function ChooseFontDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ChooseFontDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.modal = true;
         this._list = contentPane.getChild("list").asList;
         this._list.addEventListener("itemClick",this.__clickItem);
         contentPane.getChild("globalSetting").addClickListener(this.__globalSetting);
         contentPane.getChild("n40").addClickListener(__actionHandler);
         contentPane.getChild("n41").addClickListener(closeEventHandler);
      }
      
      public function open(param1:Function) : void
      {
         this._callback = param1;
         show();
      }
      
      override protected function onShown() : void
      {
         var _loc5_:Array = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:GButton = null;
         var _loc1_:Font = null;
         if(!this._built)
         {
            this._built = true;
            _loc5_ = Font.enumerateFonts(true);
            _loc5_.sort(this.sortFont);
            _loc4_ = _loc5_.length;
            this._list.removeChildrenToPool();
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               _loc3_ = this._list.addItemFromPool().asButton;
               _loc1_ = _loc5_[_loc2_];
               _loc3_.title = _loc1_.fontName;
               _loc2_++;
            }
         }
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.editPanel.self.requestFocus();
      }
      
      private function sortFont(param1:Font, param2:Font) : int
      {
         var _loc5_:String = param1.fontName;
         var _loc6_:String = param2.fontName;
         var _loc3_:Number = _loc5_.charCodeAt(0);
         var _loc4_:Number = _loc6_.charCodeAt(0);
         if(_loc3_ > 256 && _loc4_ > 256)
         {
            return _loc5_.localeCompare(_loc6_);
         }
         if(_loc3_ > 256)
         {
            return -1;
         }
         if(_loc4_ > 256)
         {
            return 1;
         }
         return _loc5_.localeCompare(_loc6_);
      }
      
      override public function actionHandler() : void
      {
         var _loc2_:Function = this._callback;
         this._callback = null;
         var _loc1_:int = this._list.selectedIndex;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         _loc2_(this._list.getChildAt(_loc1_).asButton.title);
         this.hide();
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc2_:GTextField = null;
         var _loc3_:GButton = param1.itemObject as GButton;
         if(_loc3_ && !_loc3_.data)
         {
            _loc3_.data = true;
            _loc2_ = _loc3_.getChild("demo").asTextField;
            _loc2_.font = _loc3_.title;
            _loc2_.text = Consts.g.text241;
         }
      }
      
      private function __globalSetting(param1:Event) : void
      {
         this.hide();
         ProjectSettingsDialog(_editorWindow.getDialog(ProjectSettingsDialog)).openFontSettings();
      }
   }
}

package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import flash.events.Event;
   
   public class SaveConfirmDialog extends WindowBase
   {
      
      public static const YES:int = 0;
      
      public static const NO:int = 1;
      
      public static const CANCEL:int = 2;
       
      
      private var _list:GList;
      
      private var _callback:Function;
      
      public function SaveConfirmDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","SaveConfirmDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.modal = true;
         contentPane.getChild("btnYes").addClickListener(__actionHandler);
         contentPane.getChild("btnNo").addClickListener(this.__clickNo);
         contentPane.getChild("btnCancel").addClickListener(this.__clickCancel);
         this._list = contentPane.getChild("list").asList;
         this._list.selectionMode = 3;
      }
      
      public function open(param1:Array, param2:Function) : void
      {
         var _loc3_:GButton = null;
         this.show();
         this._callback = param2;
         this._list.removeChildrenToPool();
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this._list.addItemFromPool().asButton;
            _loc3_.title = param1[_loc5_];
            _loc5_++;
         }
         this._list.scrollPane.scrollTop();
         this.frame.text = _editorWindow.groot.nativeStage.nativeWindow.title;
      }
      
      override public function actionHandler() : void
      {
         this.hide();
         this._callback(0);
      }
      
      private function __clickNo(param1:Event) : void
      {
         this.hide();
         this._callback(1);
      }
      
      private function __clickCancel(param1:Event) : void
      {
         this.hide();
         this._callback(2);
      }
   }
}

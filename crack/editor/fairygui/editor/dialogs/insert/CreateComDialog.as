package fairygui.editor.dialogs.insert
{
   import fairygui.GLabel;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.dialogs.ChooseFolderDialog;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import flash.events.Event;
   
   public class CreateComDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _path:String;
      
      private var _data:XML;
      
      private var _callback:Function;
      
      private var _name:GLabel;
      
      public function CreateComDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","CreateComDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._name = contentPane.getChild("n3").asLabel;
         contentPane.getChild("n8").text = "400";
         contentPane.getChild("n10").text = "400";
         contentPane.getChild("n13").asLabel.editable = false;
         this.contentPane.getChild("n6").addClickListener(__actionHandler);
         this.contentPane.getChild("n14").addClickListener(this.__browse);
         this.contentPane.getChild("n7").addClickListener(closeEventHandler);
      }
      
      public function open(param1:XML = null, param2:Function = null) : void
      {
         this._data = param1;
         this._callback = param2;
         show();
      }
      
      override protected function onShown() : void
      {
         var _loc2_:String = null;
         var _loc1_:Array = null;
         this._pkg = _editorWindow.mainPanel.getActivePackage();
         this._name.text = this._pkg.getSequenceName("Component");
         this._path = _editorWindow.mainPanel.libPanel.pkgsPanel.getSelectedFolderInPackage(this._pkg).id;
         this.__selectFolder(this._path);
         if(this._data != null)
         {
            _loc2_ = this._data.@size;
            _loc1_ = _loc2_.split(",");
            contentPane.getChild("n8").text = _loc1_[0];
            contentPane.getChild("n10").text = _loc1_[1];
         }
         this._name.getTextField().requestFocus();
      }
      
      override protected function onHide() : void
      {
         super.onHide();
         this._data = null;
         this._callback = null;
         _editorWindow.mainPanel.libPanel.self.requestFocus();
      }
      
      override public function actionHandler() : void
      {
         var _loc1_:EPackageItem = null;
         try
         {
            _loc1_ = this._pkg.createNewComponent(this._name.text,parseInt(contentPane.getChild("n8").text),parseInt(contentPane.getChild("n10").text),this._path,null,this._data);
            if(this._callback != null)
            {
               this._callback(_loc1_);
            }
            else
            {
               _editorWindow.mainPanel.openItem(_loc1_);
            }
            this.hide();
            return;
         }
         catch(err:Error)
         {
            _editorWindow.alertError(err);
            return;
         }
      }
      
      private function __browse(param1:Event) : void
      {
         ChooseFolderDialog(_editorWindow.getDialog(ChooseFolderDialog)).open(this._pkg,this._path,this.__selectFolder);
      }
      
      private function __selectFolder(param1:String) : void
      {
         this._path = param1;
         contentPane.getChild("n13").text = "/" + this._pkg.name + this._path;
      }
   }
}

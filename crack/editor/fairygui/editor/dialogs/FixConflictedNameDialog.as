package fairygui.editor.dialogs
{
   import fairygui.GLabel;
   import fairygui.GTextField;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.utils.UtilsStr;
   
   public class FixConflictedNameDialog extends WindowBase
   {
       
      
      private var _prompt:GTextField;
      
      private var _name:GLabel;
      
      private var _pis:Vector.<EPackageItem>;
      
      private var _index:int;
      
      private var _newNames:Vector.<String>;
      
      private var _callback:Function;
      
      private var _targetPath:EPackageItem;
      
      public function FixConflictedNameDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","FixConflictedNameDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._prompt = this.contentPane.getChild("n1").asTextField;
         this._name = this.contentPane.getChild("n2").asLabel;
         this.contentPane.getChild("n3").addClickListener(__actionHandler);
         this.contentPane.getChild("n4").addClickListener(closeEventHandler);
      }
      
      public function open(param1:Vector.<EPackageItem>, param2:String, param3:Function) : void
      {
         show();
         this._pis = param1;
         this._callback = param3;
         this._newNames = new Vector.<String>();
         this._index = 0;
         this._targetPath = this._pis[this._index].owner.getItem(param2);
         this._prompt.text = UtilsStr.formatString(Consts.g.text242,this._pis[this._index].name);
         this._name.text = UtilsStr.getFileName(this._pis[this._index].owner.getUniqueName(this._targetPath,this._pis[this._index].fileName));
      }
      
      override public function actionHandler() : void
      {
         this._newNames.push(this._name.text);
         this._index++;
         var _loc1_:int = this._pis.length;
         if(this._index < _loc1_)
         {
            this._prompt.text = UtilsStr.formatString(Consts.g.text242,this._pis[this._index].name);
            this._name.text = UtilsStr.getFileName(this._pis[this._index].owner.getUniqueName(this._targetPath,this._pis[this._index].fileName));
         }
         else
         {
            this._callback(this._pis,this._newNames);
            this.hide();
         }
      }
   }
}

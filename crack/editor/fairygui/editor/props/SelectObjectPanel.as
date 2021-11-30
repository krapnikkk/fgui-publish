package fairygui.editor.props
{
   import fairygui.GComponent;
   import fairygui.UIPackage;
   import fairygui.editor.ComDocument;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EGObject;
   
   public class SelectObjectPanel extends GComponent
   {
      
      public static var callback:Function;
      
      public static var callbackData:Object;
       
      
      private var _target:EGObject;
      
      private var _editorWindow:EditorWindow;
      
      public function SelectObjectPanel(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         UIPackage.createObject("Builder","SelectObjectPanel",this);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var xml:XML = param1;
         super.constructFromXML(xml);
         getChild("n4").addClickListener(function():void
         {
            var _loc1_:ComDocument = _editorWindow.activeComDocument;
            _loc1_.finishSelectingObject();
         });
         getChild("n5").addClickListener(function():void
         {
            var _loc1_:ComDocument = _editorWindow.activeComDocument;
            _loc1_.finishSelectingObject();
         });
      }
      
      public function update(param1:EGObject) : void
      {
         this._target = param1;
         if(!param1.parent)
         {
            getChild("title").text = Consts.g.text170;
         }
         else
         {
            getChild("title").text = this._target.toString();
         }
         getChild("icon").asLoader.url = Icons.all[this._target.objectType];
      }
   }
}

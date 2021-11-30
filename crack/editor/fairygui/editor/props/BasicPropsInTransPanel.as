package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.utils.UtilsStr;
   
   public class BasicPropsInTransPanel extends PropsPanel
   {
       
      
      public function BasicPropsInTransPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
      }
      
      override public function update(param1:Vector.<EGObject>) : void
      {
         if(_object)
         {
            _object.statusDispatcher.removeListener(1,this.updateOutline);
            _object.statusDispatcher.removeListener(2,this.updateOutline);
         }
         super.update(param1);
         if(param1.length == 1)
         {
            _object.statusDispatcher.addListener(1,this.updateOutline);
            _object.statusDispatcher.addListener(2,this.updateOutline);
         }
      }
      
      override protected function setObjectToUI() : void
      {
         this.updateOutline();
         this.updateEtc();
      }
      
      private function updateOutline() : void
      {
         if(!parent)
         {
            return;
         }
         getChild("x").text = "" + int(_object.x);
         getChild("y").text = "" + int(_object.y);
         getChild("width").text = "" + int(_object.width);
         getChild("height").text = "" + int(_object.height);
         getChild("width").width = 10;
      }
      
      private function updateEtc() : void
      {
         getChild("title").text = _object.getDetailString();
         getChild("icon").asLoader.url = Icons.all[_object.objectType];
         getChild("name").text = _object.name;
         getChild("alpha").text = "" + Math.round(_object.alpha * 100);
         getChild("rotation").text = "" + _object.rotation;
         getChild("pivotX").text = "" + _object.pivotX;
         getChild("pivotY").text = "" + _object.pivotY;
         getChild("scaleX").text = UtilsStr.toFixed(_object.scaleX);
         getChild("scaleY").text = UtilsStr.toFixed(_object.scaleY);
         getChild("skewX").text = UtilsStr.toFixed(_object.skewX);
         getChild("skewY").text = UtilsStr.toFixed(_object.skewY);
      }
   }
}

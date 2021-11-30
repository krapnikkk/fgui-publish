package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGMovieClip;
   
   public class MovieClipPropsPanel extends PropsPanel
   {
       
      
      public function MovieClipPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         ColorInput(getChild("color")).showAlpha = false;
         NumericInput(getChild("brightness")).max = 255;
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc4_:EGMovieClip = EGMovieClip(_object);
         getChild("playing").asButton.selected = _loc4_.playing;
         getChild("frame").text = "" + _loc4_.frame;
         ColorInput(getChild("color")).argb = _loc4_.color;
         var _loc3_:* = _loc4_.color >> 16 & 255;
         var _loc1_:* = _loc4_.color >> 8 & 255;
         var _loc2_:* = _loc4_.color & 255;
         if(_loc3_ == _loc1_ && _loc1_ == _loc2_)
         {
            NumericInput(getChild("brightness")).value = _loc3_;
         }
         else
         {
            NumericInput(getChild("brightness")).value = 255;
         }
      }
   }
}

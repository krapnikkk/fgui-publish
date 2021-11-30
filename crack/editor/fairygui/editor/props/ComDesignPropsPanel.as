package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGComponent;
   
   public class ComDesignPropsPanel extends PropsPanel
   {
       
      
      public function ComDesignPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var xml:XML = param1;
         super.constructFromXML(xml);
         NumericInput(getChild("designImageOffsetX")).min = -2147483648;
         NumericInput(getChild("designImageOffsetY")).min = -2147483648;
         with(NumericInput(getChild("designImageAlpha")))
         {
            
            max = 100;
            step = 3;
         }
         getController("layer").addEventListener("stateChanged",function():void
         {
            _object.setProperty("designImageLayer",getController("layer").selectedIndex);
         });
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGComponent = EGComponent(_object);
         getChild("designImage").text = _loc1_.designImage;
         getChild("designImageOffsetX").text = "" + _loc1_.designImageOffsetX;
         getChild("designImageOffsetY").text = "" + _loc1_.designImageOffsetY;
         getChild("designImageAlpha").text = "" + _loc1_.designImageAlpha;
         getController("layer").selectedIndex = _loc1_.designImageLayer;
      }
   }
}

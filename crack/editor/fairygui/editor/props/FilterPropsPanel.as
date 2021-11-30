package fairygui.editor.props
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import flash.desktop.Clipboard;
   
   public class FilterPropsPanel extends SubPropsPanel
   {
       
      
      public function FilterPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function setObjectToUI() : void
      {
         NumericInput(getChild("filter_cb")).value = _object.filter_cb;
         NumericInput(getChild("filter_cc")).value = _object.filter_cc;
         NumericInput(getChild("filter_cs")).value = _object.filter_cs;
         NumericInput(getChild("filter_ch")).value = _object.filter_ch;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var xml:XML = param1;
         super.constructFromXML(xml);
         with(NumericInput(getChild("filter_cb")))
         {
            
            min = -1;
            max = 1;
            step = 0.01;
            fractionDigits = 2;
         }
         with(NumericInput(getChild("filter_cc")))
         {
            
            min = -1;
            max = 1;
            step = 0.01;
            fractionDigits = 2;
         }
         with(NumericInput(getChild("filter_cs")))
         {
            
            min = -1;
            max = 1;
            step = 0.01;
            fractionDigits = 2;
         }
         with(NumericInput(getChild("filter_ch")))
         {
            
            min = -1;
            max = 1;
            step = 0.01;
            fractionDigits = 2;
         }
         getChild("copy").addClickListener(function():void
         {
            Clipboard.generalClipboard.setData("fairygui.ColorFilter",[_object.filter_cb,_object.filter_cc,_object.filter_cs,_object.filter_ch]);
         });
         getChild("paste").addClickListener(function():void
         {
            var _loc1_:Array = null;
            if(Clipboard.generalClipboard.hasFormat("fairygui.ColorFilter"))
            {
               _loc1_ = Clipboard.generalClipboard.getData("fairygui.ColorFilter") as Array;
               setValues(_loc1_[0],_loc1_[1],_loc1_[2],_loc1_[3]);
            }
         });
         getChild("reset").addClickListener(function():void
         {
            setValues(0,0,0,0);
         });
      }
      
      private function setValues(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc7_:Object = null;
         var _loc5_:int = _objects.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _objects[_loc6_];
            _loc7_.setProperty("filter_cb",param1);
            _loc7_.setProperty("filter_cc",param2);
            _loc7_.setProperty("filter_cs",param3);
            _loc7_.setProperty("filter_ch",param4);
            _loc6_++;
         }
         this.setObjectToUI();
      }
   }
}

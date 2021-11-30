package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GObject;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.dialogs.ListItemsEditDialog;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGList;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   
   public class ListPropsPanel extends PropsPanel
   {
       
      
      private var _scrollEditBtn:GButton;
      
      public function ListPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var cb:GComboBox = null;
         var xml:XML = param1;
         super.constructFromXML(xml);
         with(NumericInput(getChild("lineGap")))
         {
            
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("columnGap")))
         {
            
            min = int.MIN_VALUE;
         }
         cb = getChild("layout").asComboBox;
         cb.items = [Consts.g.text149,Consts.g.text150,Consts.g.text151,Consts.g.text152,Consts.g.text307];
         cb.values = ["column","row","flow_hz","flow_vt","pagination"];
         cb.addEventListener("stateChanged",this.__layoutChanged);
         cb = getChild("selectionMode").asComboBox;
         cb.items = [Consts.g.text231,Consts.g.text232,Consts.g.text233,Consts.g.text234];
         cb.values = ["single","multiple","multipleSingleClick","none"];
         cb = getChild("overflow2").asComboBox;
         cb.items = [Consts.g.text132,Consts.g.text133,Consts.g.text135,Consts.g.text136,Consts.g.text137];
         cb.values = ["visible","hidden","scroll-vertical","scroll-horizontal","scroll-both"];
         cb = getChild("align").asComboBox;
         cb.items = [Consts.g.text153,Consts.g.text154,Consts.g.text155];
         cb.values = ["left","center","right"];
         cb = getChild("verticalAlign").asComboBox;
         cb.items = [Consts.g.text156,Consts.g.text157,Consts.g.text158];
         cb.values = ["top","middle","bottom"];
         cb = getChild("childrenRenderOrder").asComboBox;
         cb.items = [Consts.g.text328,Consts.g.text329,Consts.g.text330];
         cb.values = ["ascent","descent","arch"];
         cb.addEventListener("stateChanged",this.__renderOrderChanged);
         this._scrollEditBtn = getChild("scrollEdit").asButton;
         initSubPropsButton(this._scrollEditBtn,"scrollProps");
         initSubPropsButton(getChild("layoutEdit"),"listLayoutProps");
         initSubPropsButton(getChild("margin"),"marginProps");
         getChild("margin").asLabel.editable = false;
         getChild("editItems").addClickListener(function():void
         {
            ListItemsEditDialog(_editorWindow.getDialog(ListItemsEditDialog)).open(EGList(_object));
         });
         getChild("pageController").addClickListener(this.__selectController);
         getChild("selectionController").addClickListener(this.__selectController);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:EGList = EGList(_object);
         getChild("layout").asComboBox.value = _loc1_.layout;
         getChild("selectionMode").asComboBox.value = _loc1_.selectionMode;
         getChild("overflow2").asComboBox.value = _loc1_.overflow2;
         this._scrollEditBtn.visible = _loc1_.overflow == "scroll";
         getChild("lineGap").text = "" + _loc1_.lineGap;
         getChild("columnGap").text = "" + _loc1_.columnGap;
         getChild("repeatX").text = "" + _loc1_.repeatX;
         getChild("repeatY").text = "" + _loc1_.repeatY;
         getChild("defaultItem").text = _loc1_.defaultItem;
         getChild("align").asComboBox.value = _loc1_.align;
         getChild("verticalAlign").asComboBox.value = _loc1_.verticalAlign;
         getChild("childrenRenderOrder").asComboBox.value = _loc1_.childrenRenderOrder;
         NumericInput(getChild("apexIndex")).value = _loc1_.apexIndex;
         getChild("margin").text = _loc1_.margin.toString();
         getChild("selectionController").text = UtilsStr.readableString(_loc1_.selectionController);
         getChild("pageController").text = UtilsStr.readableString(_loc1_.pageController);
         this.__layoutChanged(null);
         this.__renderOrderChanged(null);
      }
      
      private function __layoutChanged(param1:Event) : void
      {
         var _loc2_:EGList = EGList(_object);
         var _loc3_:* = _loc2_.layout;
         if("column" !== _loc3_)
         {
            if("row" !== _loc3_)
            {
               if("flow_hz" !== _loc3_)
               {
                  if("flow_vt" !== _loc3_)
                  {
                     if("pagination" === _loc3_)
                     {
                        getChild("lineGap").enabled = true;
                        getChild("columnGap").enabled = true;
                        getChild("repeatX").enabled = true;
                        getChild("repeatY").enabled = true;
                     }
                  }
                  else
                  {
                     getChild("lineGap").enabled = true;
                     getChild("columnGap").enabled = true;
                     getChild("repeatX").enabled = false;
                     getChild("repeatY").enabled = true;
                  }
               }
               else
               {
                  getChild("lineGap").enabled = true;
                  getChild("columnGap").enabled = true;
                  getChild("repeatX").enabled = true;
                  getChild("repeatY").enabled = false;
               }
            }
            else
            {
               getChild("lineGap").enabled = false;
               getChild("columnGap").enabled = true;
               getChild("repeatX").enabled = false;
               getChild("repeatY").enabled = false;
            }
         }
         else
         {
            getChild("lineGap").enabled = true;
            getChild("columnGap").enabled = false;
            getChild("repeatX").enabled = false;
            getChild("repeatY").enabled = false;
         }
      }
      
      private function __renderOrderChanged(param1:Event) : void
      {
         getChild("apexIndex").enabled = getChild("childrenRenderOrder").asComboBox.value == "arch";
      }
      
      private function __selectController(param1:Event) : void
      {
         _editorWindow.selectControllerMenu.show(GObject(param1.currentTarget),_object.parent);
      }
   }
}

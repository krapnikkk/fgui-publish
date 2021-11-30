package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ChildObjectInput;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGObject;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class ComPropsPanel extends PropsPanel
   {
       
      
      private var _scrollEditBtn:GButton;
      
      private var _extensionCombo:GComboBox;
      
      private var _menu:PopupMenu;
      
      public function ComPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var cb:GComboBox = null;
         var btn:GObject = null;
         var xml:XML = param1;
         super.constructFromXML(xml);
         this._scrollEditBtn = getChild("scrollEdit").asButton;
         initSubPropsButton(this._scrollEditBtn,"scrollProps");
         initSubPropsButton(getChild("margin"),"marginProps");
         with(NumericInput(getChild("pivotX")))
         {
            
            step = 0.1;
            fractionDigits = 2;
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("pivotY")))
         {
            
            step = 0.1;
            fractionDigits = 2;
            min = int.MIN_VALUE;
         }
         cb = getChild("overflow2").asComboBox;
         cb.items = [Consts.g.text132,Consts.g.text133,Consts.g.text135,Consts.g.text136,Consts.g.text137];
         cb.values = ["visible","hidden","scroll-vertical","scroll-horizontal","scroll-both"];
         this._extensionCombo = getChild("extentionId").asComboBox;
         this._extensionCombo.addEventListener("stateChanged",this.__extensionChanged,false,1);
         getChild("initName").asLabel.getTextField().asTextInput.disableIME = true;
         getChild("margin").asLabel.editable = false;
         ChildObjectInput(getChild("mask")).typeFilter = ["image","graph"];
         ChildObjectInput(getChild("hitTestSource")).typeFilter = ["image"];
         this._menu = new PopupMenu();
         this._menu.addItem(Consts.g.text109,this.__clickPivotType);
         this._menu.addItem(Consts.g.text261,this.__clickPivotType);
         this._menu.addItem(Consts.g.text262,this.__clickPivotType);
         this._menu.addItem(Consts.g.text263,this.__clickPivotType);
         this._menu.addItem(Consts.g.text264,this.__clickPivotType);
         btn = getChild("n92");
         btn.addClickListener(function():void
         {
            _menu.show(btn);
         });
         getChild("title").addClickListener(this.__clickTitle);
         getChild("fitSize").addClickListener(this.__clickFitSize);
      }
      
      override protected function setObjectToUI() : void
      {
         var _loc1_:int = 0;
         if(_editorWindow.plugInManager.comExtensionIDs.length != this._extensionCombo.items.length)
         {
            this._extensionCombo.items = _editorWindow.plugInManager.comExtensionNames;
            this._extensionCombo.values = _editorWindow.plugInManager.comExtensionIDs;
         }
         var _loc2_:EGComponent = EGComponent(_object);
         getChild("width").text = "" + int(_loc2_.width);
         getChild("height").text = "" + int(_loc2_.height);
         getChild("pivotX").text = "" + _loc2_.pivotX;
         getChild("pivotY").text = "" + _loc2_.pivotY;
         getChild("anchor").asButton.selected = _loc2_.anchor;
         getChild("title").text = _loc2_.packageItem != null?_loc2_.packageItem.name:"";
         getChild("overflow2").asComboBox.value = _loc2_.overflow2;
         this._scrollEditBtn.visible = _loc2_.overflow == "scroll";
         getChild("initName").text = _loc2_.initName;
         getChild("bgColorEnabled").asButton.selected = _loc2_.bgColorEnabled;
         ColorInput(getChild("bgColor")).argb = _loc2_.bgColor;
         getChild("clickThrough").asButton.selected = _loc2_.clickThrough;
         getChild("margin").text = _loc2_.margin.toString();
         if(_loc2_.customExtentionId != null)
         {
            _loc1_ = _editorWindow.plugInManager.comExtensionIDs.indexOf(_loc2_.customExtentionId);
            if(_loc1_ != -1)
            {
               this._extensionCombo.selectedIndex = _loc1_;
            }
            else
            {
               this._extensionCombo.selectedIndex = 0;
            }
         }
         else if(_loc2_.extentionId != null)
         {
            this._extensionCombo.value = _loc2_.extentionId;
         }
         else
         {
            this._extensionCombo.selectedIndex = 0;
         }
         getChild("remark").text = _loc2_.remark;
         getChild("minWidth").text = "" + int(_object.minWidth);
         getChild("minHeight").text = "" + int(_object.minHeight);
         getChild("maxWidth").text = "" + int(_object.maxWidth);
         getChild("maxHeight").text = "" + int(_object.maxHeight);
         ChildObjectInput(getChild("mask")).value = _loc2_.mask;
         ChildObjectInput(getChild("hitTestSource")).value = _loc2_.hitTestSource;
         getChild("reversedMask").asButton.selected = _loc2_.reversedMask;
      }
      
      private function __clickTitle(param1:Event) : void
      {
         if(_object.packageItem)
         {
            _editorWindow.mainPanel.libPanel.highlightItem(_object.packageItem);
         }
      }
      
      private function __extensionChanged(param1:Event) : void
      {
         var _loc2_:Object = null;
         param1.stopImmediatePropagation();
         var _loc3_:String = this._extensionCombo.value;
         if(this._extensionCombo.selectedIndex >= 7)
         {
            _loc2_ = _editorWindow.plugInManager.comExtensions[_loc3_];
            if(_loc2_)
            {
               EGComponent(_object).setProperty("customExtentionId",_loc3_);
               if(_loc2_.superClassName)
               {
                  EGComponent(_object).setProperty("extentionId",_loc2_.superClassName);
               }
               else
               {
                  EGComponent(_object).setProperty("extentionId",null);
               }
            }
            else
            {
               EGComponent(_object).setProperty("customExtentionId",null);
               EGComponent(_object).setProperty("extentionId",null);
            }
         }
         else
         {
            EGComponent(_object).setProperty("customExtentionId",null);
            EGComponent(_object).setProperty("extentionId",_loc3_);
         }
         _editorWindow.mainPanel.propsPanelList.refresh();
      }
      
      private function __clickPivotType(param1:ItemEvent) : void
      {
         var _loc2_:EGObject = null;
         var _loc5_:int = this._menu.list.getChildIndex(param1.itemObject);
         var _loc3_:int = _objects.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _objects[_loc4_];
            switch(int(_loc5_))
            {
               case 0:
                  _loc2_.setProperty("pivotX",0.5);
                  _loc2_.setProperty("pivotY",0.5);
                  break;
               case 1:
                  _loc2_.setProperty("pivotX",0);
                  _loc2_.setProperty("pivotY",0);
                  break;
               case 2:
                  _loc2_.setProperty("pivotX",1);
                  _loc2_.setProperty("pivotY",0);
                  break;
               case 3:
                  _loc2_.setProperty("pivotX",0);
                  _loc2_.setProperty("pivotY",1);
                  break;
               case 4:
                  _loc2_.setProperty("pivotX",1);
                  _loc2_.setProperty("pivotY",1);
            }
            _loc4_++;
         }
         this.setObjectToUI();
      }
      
      private function __clickFitSize(param1:Event) : void
      {
         var _loc3_:EGComponent = EGComponent(_object);
         var _loc2_:Rectangle = _loc3_.getBounds();
         if(_loc2_.isEmpty())
         {
            return;
         }
         _loc3_.setProperty("width",_loc2_.right);
         _loc3_.setProperty("height",_loc2_.bottom);
         this.setObjectToUI();
      }
   }
}

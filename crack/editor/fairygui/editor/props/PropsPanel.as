package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GComponent;
   import fairygui.GLabel;
   import fairygui.GList;
   import fairygui.GObject;
   import fairygui.UIPackage;
   import fairygui.editor.ComDocument;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.ChildObjectInput;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGObject;
   import flash.events.Event;
   
   public class PropsPanel extends GComponent
   {
       
      
      protected var _isExtention:Boolean;
      
      protected var _isTransition:Boolean;
      
      protected var _objects:Vector.<EGObject>;
      
      protected var _object:EGObject;
      
      protected var _savedHeight:int;
      
      protected var _titleBar:GButton;
      
      protected var _editorWindow:EditorWindow;
      
      public function PropsPanel(param1:EditorWindow, param2:String, param3:String = "Builder")
      {
         super();
         this._editorWindow = param1;
         UIPackage.createObject(param3,param2,this);
      }
      
      public static function setTargetProperty(param1:Object, param2:GObject, param3:String) : void
      {
         var _loc10_:Number = NaN;
         var _loc4_:int = 0;
         var _loc6_:GButton = null;
         var _loc9_:GButton = null;
         var _loc8_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc5_:String = null;
         if(param3 == "alpha" && param2 is NumericInput)
         {
            _loc10_ = NumericInput(param2).value / 100;
            param1.setProperty(param3,_loc10_);
         }
         else if(param2.name == "brightness" && param3 == "color")
         {
            _loc4_ = NumericInput(param2).value;
            param1.setProperty(param3,(_loc4_ << 16) + (_loc4_ << 8) + _loc4_);
         }
         else if((param2.name == "flipHZ" || param2.name == "flipVT") && param3 == "flip")
         {
            _loc6_ = GButton(param2.parent.getChild("flipHZ"));
            _loc9_ = GButton(param2.parent.getChild("flipVT"));
            _loc8_ = _loc6_ && _loc6_.selected;
            _loc7_ = _loc9_ && _loc9_.selected;
            param1.setProperty("flip",_loc8_ && _loc7_?"both":!!_loc8_?"hz":!!_loc7_?"vt":"none");
         }
         else if(param2 is ColorInput)
         {
            param1.setProperty(param3,ColorInput(param2).argb);
         }
         else if(param2 is GComboBox)
         {
            _loc5_ = GComboBox(param2).value;
            if(_loc5_ == "false")
            {
               param1.setProperty(param3,false);
            }
            else if(_loc5_ == "true")
            {
               param1.setProperty(param3,true);
            }
            else
            {
               param1.setProperty(param3,_loc5_);
            }
         }
         else if(param2 is GButton && GButton(param2).mode != 0)
         {
            param1.setProperty(param3,GButton(param2).selected);
         }
         else if(param2 is ChildObjectInput)
         {
            param1.setProperty(param3,ChildObjectInput(param2).value);
         }
         else
         {
            param1.setProperty(param3,param2.text);
         }
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc3_:GObject = null;
         super.constructFromXML(param1);
         this._savedHeight = this.initHeight;
         var _loc4_:int = this.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = getChildAt(_loc2_);
            _loc3_.addEventListener("stateChanged",this.__propChanged);
            _loc3_.addEventListener("__submit",this.__propChanged);
            _loc2_++;
         }
         this._titleBar = getChild("bg").asCom.getChild("title").asButton;
         this._titleBar.addEventListener("stateChanged",this.__expandStateChanged);
      }
      
      protected function set title(param1:String) : void
      {
         this._titleBar.title = param1;
      }
      
      public function set expanded(param1:Boolean) : void
      {
         param1 = !param1;
         if(this._titleBar.selected != param1)
         {
            this._titleBar.selected = param1;
            this.__expandStateChanged(null);
         }
      }
      
      public function get expanded() : Boolean
      {
         return !this._titleBar.selected;
      }
      
      public function update(param1:Vector.<EGObject>) : void
      {
         this._objects = param1;
         this._object = this._objects[0];
         this.setObjectToUI();
      }
      
      protected function setObjectToUI() : void
      {
      }
      
      protected function __propChanged(param1:Event) : void
      {
         var _loc2_:GObject = GObject(param1.currentTarget);
         this.setTargetsProperty(_loc2_);
      }
      
      private function __clickTitleBar(param1:Event) : void
      {
         this.expanded = !this.expanded;
      }
      
      private function __expandStateChanged(param1:Event) : void
      {
         if(this._titleBar.selected)
         {
            this._savedHeight = this.height;
            this.height = this._titleBar.height;
         }
         else
         {
            this.height = this._savedHeight;
         }
      }
      
      protected function setTargetsProperty(param1:GObject) : void
      {
         var _loc6_:Object = null;
         var _loc4_:ComDocument = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this._isTransition)
         {
            _loc4_ = this._editorWindow.activeComDocument;
            _loc6_ = _loc4_.editingTransition;
            if(!_loc6_.hasOwnProperty(param1.name))
            {
               return;
            }
            setTargetProperty(_loc6_,param1,param1.name);
         }
         else
         {
            _loc5_ = this._objects.length;
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               _loc6_ = this._objects[_loc2_];
               if(this._isExtention)
               {
                  _loc6_ = EGComponent(_loc6_).extention;
               }
               _loc3_ = param1.name;
               if(_loc3_ == "brightness")
               {
                  _loc3_ = "color";
               }
               else if(_loc3_ == "flipHZ" || _loc3_ == "flipVT")
               {
                  _loc3_ = "flip";
               }
               if(!_loc6_.hasOwnProperty(_loc3_))
               {
                  return;
               }
               setTargetProperty(_loc6_,param1,_loc3_);
               _loc2_++;
            }
         }
         this.setObjectToUI();
      }
      
      protected function fillControllerSettingsList() : void
      {
         var _loc2_:EController = null;
         var _loc3_:GLabel = null;
         var _loc1_:GComboBox = null;
         var _loc5_:GList = getChild("controllerSettings").asList;
         _loc5_.removeChildrenToPool();
         var _loc4_:Vector.<EController> = EGComponent(this._object).controllers;
         var _loc7_:int = 0;
         var _loc6_:* = _loc4_;
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.exported)
            {
               _loc3_ = _loc5_.addItemFromPool().asLabel;
               _loc3_.data = _loc2_;
               _loc3_.title = !!_loc2_.alias?_loc2_.alias:_loc2_.name;
               _loc1_ = _loc3_.getChild("pages").asComboBox;
               _loc1_.addEventListener("stateChanged",this.__pageChanged);
               _loc1_.items = _loc2_.getPageNames();
               _loc1_.values = _loc2_.getPageIds();
               _loc1_.value = _loc2_.selectedPageId;
            }
         }
         _loc5_.resizeToFit();
         if(_loc5_.numChildren > 0)
         {
            getController("controllerSettings").selectedIndex = 1;
         }
         else
         {
            getController("controllerSettings").selectedIndex = 0;
         }
      }
      
      private function __pageChanged(param1:Event) : void
      {
         var _loc4_:GComboBox = GComboBox(param1.currentTarget);
         var _loc2_:EController = EController(_loc4_.parent.data);
         var _loc3_:String = _loc2_.selectedPageId;
         _loc2_.selectedPageId = _loc4_.value;
         this._editorWindow.activeComDocument.actionHistory.action_controllerPageSet(_loc2_,_loc3_,_loc4_.value);
      }
      
      protected function initSubPropsButton(param1:GObject, param2:String) : void
      {
         param1.data = param2;
         param1.addClickListener(this.__clickSubPropsButton);
      }
      
      private function __clickSubPropsButton(param1:Event) : void
      {
         var _loc3_:SubPropsPanel = this._editorWindow.mainPanel.propsPanelList[param1.currentTarget.data];
         var _loc2_:* = false;
         _loc2_ = _loc3_ is ScrollPropsPanel;
         this._editorWindow.groot.togglePopup(_loc3_,GObject(param1.currentTarget),null,_loc2_);
         _loc3_.update(this._objects);
      }
   }
}

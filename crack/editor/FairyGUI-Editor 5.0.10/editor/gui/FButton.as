package fairygui.editor.gui
{
   import fairygui.ObjectPropID;
   import fairygui.event.GTouchEvent;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FButton extends ComExtention
   {
      
      public static const COMMON:String = "Common";
      
      public static const CHECK:String = "Check";
      
      public static const RADIO:String = "Radio";
      
      public static const UP:String = "up";
      
      public static const DOWN:String = "down";
      
      public static const OVER:String = "over";
      
      public static const SELECTED_OVER:String = "selectedOver";
      
      public static const DISABLED:String = "disabled";
      
      public static const SELECTED_DISABLED:String = "selectedDisabled";
       
      
      private var _mode:String;
      
      private var _selected:Boolean;
      
      private var _title:String;
      
      private var _selectedTitle:String;
      
      private var _titleColor:uint;
      
      private var _titleColorSet:Boolean;
      
      private var _originColor:uint;
      
      private var _titleFontSize:int;
      
      private var _titleFontSizeSet:Boolean;
      
      private var _originFontSize:int;
      
      private var _icon:String;
      
      private var _selectedIcon:String;
      
      private var _buttonController:FController;
      
      private var _titleObject:FObject;
      
      private var _iconObject:FObject;
      
      private var _controller:FController;
      
      private var _page:String;
      
      private var _sound:String;
      
      private var _volume:int;
      
      private var _soundSet:Boolean;
      
      private var _soundVolumeSet:Boolean;
      
      private var _downEffect:String;
      
      private var _downEffectValue:Number;
      
      private var _controllerFlag:Boolean;
      
      private var _downScaled:Boolean;
      
      private var _down:Boolean;
      
      private var _over:Boolean;
      
      public var changeStageOnClick:Boolean;
      
      public function FButton()
      {
         super();
         this._mode = COMMON;
         this._title = "";
         this._icon = "";
         this._selectedTitle = "";
         this._selectedIcon = "";
         this._volume = 100;
         this.changeStageOnClick = true;
         this._downEffect = "none";
         this._downEffectValue = 0.8;
      }
      
      override public function get icon() : String
      {
         return this._icon;
      }
      
      override public function set icon(param1:String) : void
      {
         var _loc2_:String = null;
         this._icon = param1;
         if(this._iconObject)
         {
            _loc2_ = this._selected && this._selectedIcon?this._selectedIcon:this._icon;
            this._iconObject.icon = _loc2_;
         }
         _owner.updateGear(7);
      }
      
      public function get selectedIcon() : String
      {
         return this._selectedIcon;
      }
      
      public function set selectedIcon(param1:String) : void
      {
         var _loc2_:String = null;
         this._selectedIcon = param1;
         if(this._iconObject)
         {
            _loc2_ = this._selected && this._selectedIcon?this._selectedIcon:this._icon;
            this._iconObject.icon = _loc2_;
         }
      }
      
      override public function get title() : String
      {
         return this._title;
      }
      
      override public function set title(param1:String) : void
      {
         var _loc2_:String = null;
         this._title = param1;
         if(this._titleObject)
         {
            _loc2_ = this._selected && this._selectedTitle?this._selectedTitle:this._title;
            this._titleObject.text = _loc2_;
         }
         _owner.updateGear(6);
      }
      
      public function get selectedTitle() : String
      {
         return this._selectedTitle;
      }
      
      public function set selectedTitle(param1:String) : void
      {
         var _loc2_:String = null;
         this._selectedTitle = param1;
         if(this._titleObject)
         {
            _loc2_ = this._selected && this._selectedTitle?this._selectedTitle:this._title;
            this._titleObject.text = _loc2_;
         }
      }
      
      public function get titleColor() : uint
      {
         return this._titleColor;
      }
      
      public function set titleColor(param1:uint) : void
      {
         if(this._titleColor != param1)
         {
            this._titleColor = param1;
            if(this._titleObject)
            {
               if(this._titleObject is FTextField)
               {
                  FTextField(this._titleObject).color = this._titleColor;
               }
               else if(this._titleObject is FComponent)
               {
                  if(FComponent(this._titleObject).extentionId == "Label")
                  {
                     FLabel(FComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
                  else if(FComponent(this._titleObject).extentionId == "Button")
                  {
                     FButton(FComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
               }
            }
            _owner.updateGear(4);
         }
      }
      
      public function get titleColorSet() : Boolean
      {
         return this._titleColorSet;
      }
      
      public function set titleColorSet(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         this._titleColorSet = param1;
         if(!this._titleColorSet)
         {
            _loc2_ = this._originColor;
         }
         else
         {
            _loc2_ = this._titleColor;
         }
         if(this._titleObject)
         {
            if(this._titleObject is FTextField)
            {
               FTextField(this._titleObject).color = _loc2_;
            }
            else if(this._titleObject is FComponent)
            {
               if(FComponent(this._titleObject).extentionId == "Label")
               {
                  FLabel(FComponent(this._titleObject).extention).titleColor = _loc2_;
               }
               else if(FComponent(this._titleObject).extentionId == "Button")
               {
                  FButton(FComponent(this._titleObject).extention).titleColor = _loc2_;
               }
            }
         }
      }
      
      public function get titleFontSize() : int
      {
         return this._titleFontSize;
      }
      
      public function set titleFontSize(param1:int) : void
      {
         if(this._titleFontSize != param1)
         {
            this._titleFontSize = param1;
            if(this._titleObject)
            {
               if(this._titleObject is FTextField)
               {
                  FTextField(this._titleObject).fontSize = this._titleFontSize;
               }
               else if(this._titleObject is FComponent)
               {
                  if(FComponent(this._titleObject).extentionId == "Label")
                  {
                     FLabel(FComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                  }
                  else if(FComponent(this._titleObject).extentionId == "Button")
                  {
                     FButton(FComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                  }
               }
            }
            _owner.updateGear(9);
         }
      }
      
      public function get titleFontSizeSet() : Boolean
      {
         return this._titleFontSizeSet;
      }
      
      public function set titleFontSizeSet(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         this._titleFontSizeSet = param1;
         if(!this._titleFontSizeSet)
         {
            _loc2_ = this._originFontSize;
         }
         else
         {
            _loc2_ = this._titleFontSize;
         }
         if(this._titleObject)
         {
            if(this._titleObject is FTextField)
            {
               FTextField(this._titleObject).fontSize = _loc2_;
            }
            else if(this._titleObject is FComponent)
            {
               if(FComponent(this._titleObject).extentionId == "Label")
               {
                  FLabel(FComponent(this._titleObject).extention).titleFontSize = _loc2_;
               }
               else if(FComponent(this._titleObject).extentionId == "Button")
               {
                  FButton(FComponent(this._titleObject).extention).titleFontSize = _loc2_;
               }
            }
         }
      }
      
      public function getTextField() : FTextField
      {
         if(this._titleObject is FTextField)
         {
            return FTextField(this._titleObject);
         }
         if(this._titleObject is FLabel)
         {
            return FLabel(this._titleObject).getTextField();
         }
         if(this._titleObject is FButton)
         {
            return FButton(this._titleObject).getTextField();
         }
         return null;
      }
      
      public function get sound() : String
      {
         return this._sound;
      }
      
      public function set sound(param1:String) : void
      {
         this._sound = param1;
      }
      
      public function get volume() : int
      {
         return this._volume;
      }
      
      public function set volume(param1:int) : void
      {
         this._volume = param1;
      }
      
      public function get soundSet() : Boolean
      {
         return this._soundSet;
      }
      
      public function set soundSet(param1:Boolean) : void
      {
         this._soundSet = param1;
      }
      
      public function get soundVolumeSet() : Boolean
      {
         return this._soundVolumeSet;
      }
      
      public function set soundVolumeSet(param1:Boolean) : void
      {
         this._soundVolumeSet = param1;
      }
      
      public function get downEffect() : String
      {
         return this._downEffect;
      }
      
      public function set downEffect(param1:String) : void
      {
         this._downEffect = param1;
      }
      
      public function get downEffectValue() : Number
      {
         return this._downEffectValue;
      }
      
      public function set downEffectValue(param1:Number) : void
      {
         this._downEffectValue = param1;
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(this._mode == COMMON)
         {
            return;
         }
         if(this._selected != param1)
         {
            this._selected = param1;
            this.setCurrentState();
            if(this._selectedTitle)
            {
               if(this._titleObject)
               {
                  _loc2_ = !!this._selected?this._selectedTitle:this._title;
                  this._titleObject.text = _loc2_;
               }
            }
            if(this._selectedIcon)
            {
               if(this._iconObject)
               {
                  _loc2_ = !!this._selected?this._selectedIcon:this._icon;
                  this._iconObject.icon = _loc2_;
               }
            }
            if(this._controller && _owner._parent && (_owner._flags & FObjectFlags.INSPECTING) == 0 && !_owner._parent._buildingDisplayList)
            {
               if(this._selected)
               {
                  if(!this._controllerFlag)
                  {
                     this._controllerFlag = true;
                     this._controller.selectedPageId = this._page;
                     this._controllerFlag = false;
                  }
                  if(this._controller.autoRadioGroupDepth)
                  {
                     _owner._parent.adjustRadioGroupDepth(_owner,this._controller);
                  }
               }
               else if(this._mode == CHECK && this._controller.selectedPageId == this._page)
               {
                  if(!this._controllerFlag)
                  {
                     this._controllerFlag = true;
                     this._controller.oppositePageId = this._page;
                     this._controllerFlag = false;
                  }
               }
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function get mode() : String
      {
         return this._mode;
      }
      
      public function set mode(param1:String) : void
      {
         if(this._mode != param1)
         {
            if(param1 == COMMON)
            {
               this._selected = false;
            }
            this._mode = param1;
         }
      }
      
      public function get controller() : String
      {
         if(this._controller && this._controller.parent)
         {
            return this._controller.name;
         }
         return null;
      }
      
      public function set controller(param1:String) : void
      {
         if(param1)
         {
            this._controller = _owner._parent.getController(param1);
         }
         else
         {
            this._controller = null;
         }
      }
      
      public function get controllerObj() : FController
      {
         return this._controller;
      }
      
      public function get page() : String
      {
         return this._page;
      }
      
      public function set page(param1:String) : void
      {
         this._page = param1;
      }
      
      private function setState(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:FObject = null;
         if(this._buttonController)
         {
            this._buttonController.selectedPage = param1;
         }
         if((_owner._flags & FObjectFlags.INSPECTING) == 0)
         {
            if(this._downEffect == "scale")
            {
               if(param1 == DOWN || param1 == SELECTED_OVER || param1 == SELECTED_DISABLED)
               {
                  if(!this._downScaled)
                  {
                     _owner.setScale(_owner.scaleX * this._downEffectValue,_owner.scaleY * this._downEffectValue);
                     this._downScaled = true;
                  }
               }
               else if(this._downScaled)
               {
                  _owner.setScale(_owner.scaleX / this._downEffectValue,_owner.scaleY / this._downEffectValue);
                  this._downScaled = false;
               }
            }
            else if(this._downEffect == "dark")
            {
               _loc2_ = _owner.numChildren;
               if(param1 == DOWN || param1 == SELECTED_OVER || param1 == SELECTED_DISABLED)
               {
                  _loc3_ = this._downEffectValue * 255;
                  _loc4_ = (_loc3_ << 16) + (_loc3_ << 8) + _loc3_;
                  _loc5_ = 0;
                  while(_loc5_ < _loc2_)
                  {
                     _loc6_ = _owner.getChildAt(_loc5_);
                     if(!(_loc6_ is FTextField))
                     {
                        _loc6_.setProp(ObjectPropID.Color,_loc4_);
                     }
                     _loc5_++;
                  }
               }
               else
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc2_)
                  {
                     _loc6_ = _owner.getChildAt(_loc5_);
                     if(!(_loc6_ is FTextField))
                     {
                        _loc6_.setProp(ObjectPropID.Color,16777215);
                     }
                     _loc5_++;
                  }
               }
            }
         }
      }
      
      public function handleGrayChanged() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._buttonController && this._buttonController.hasPageName(DISABLED))
         {
            _loc1_ = _owner.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _owner.getChildAt(_loc2_).grayed = false;
               _loc2_++;
            }
            if(_owner.grayed)
            {
               if(this._selected && this._buttonController.hasPageName(SELECTED_DISABLED))
               {
                  this.setState(SELECTED_DISABLED);
               }
               else
               {
                  this.setState(DISABLED);
               }
            }
            else if(this._selected)
            {
               this.setState(DOWN);
            }
            else
            {
               this.setState(UP);
            }
            return true;
         }
         return false;
      }
      
      protected function setCurrentState() : void
      {
         if(_owner.grayed && this._buttonController && this._buttonController.hasPageName(DISABLED))
         {
            if(this._selected)
            {
               this.setState(SELECTED_DISABLED);
            }
            else
            {
               this.setState(DISABLED);
            }
         }
         else if(this._selected)
         {
            this.setState(!!this._over?SELECTED_OVER:DOWN);
         }
         else
         {
            this.setState(!!this._over?OVER:UP);
         }
      }
      
      override public function handleControllerChanged(param1:FController) : void
      {
         super.handleControllerChanged(param1);
         if(this._controller == param1 && !this._controllerFlag)
         {
            this._controllerFlag = true;
            this.selected = this._page == param1.selectedPageId;
            this._controllerFlag = false;
         }
      }
      
      override public function create() : void
      {
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            _owner.displayObject.addEventListener(MouseEvent.ROLL_OVER,this.__rollover);
            _owner.displayObject.addEventListener(MouseEvent.ROLL_OUT,this.__rollout);
            _owner.displayObject.addEventListener(MouseEvent.MOUSE_DOWN,this.__mousedown);
            _owner.addEventListener(GTouchEvent.CLICK,this.__click);
         }
         this._buttonController = _owner.getController("button");
         this._titleObject = owner.getChild("title");
         this._iconObject = owner.getChild("icon");
         if(this._titleObject)
         {
            if(this._titleObject is FTextField)
            {
               this._originColor = FTextField(this._titleObject).color;
               this._originFontSize = FTextField(this._titleObject).fontSize;
            }
            else if(this._titleObject is FComponent)
            {
               if(FComponent(this._titleObject).extentionId == "Label")
               {
                  this._originColor = FLabel(FComponent(this._titleObject).extention).titleColor;
                  this._originFontSize = FLabel(FComponent(this._titleObject).extention).titleFontSize;
               }
               else if(FComponent(this._titleObject).extentionId == "Button")
               {
                  this._originColor = FButton(FComponent(this._titleObject).extention).titleColor;
                  this._originFontSize = FButton(FComponent(this._titleObject).extention).titleFontSize;
               }
            }
         }
         if(!this._titleColorSet)
         {
            this._titleColor = this._originColor;
         }
         if(!this._titleFontSizeSet)
         {
            this._titleFontSize = this._originFontSize;
         }
         this.setState(UP);
         if(_owner.grayed)
         {
            _owner.handleGrayedChanged();
         }
      }
      
      override public function dispose() : void
      {
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            _owner.displayObject.removeEventListener(MouseEvent.ROLL_OVER,this.__rollover);
            _owner.displayObject.removeEventListener(MouseEvent.ROLL_OUT,this.__rollout);
            _owner.displayObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mousedown);
            _owner.removeEventListener(GTouchEvent.CLICK,this.__click);
         }
      }
      
      override public function getProp(param1:int) : *
      {
         var _loc2_:FTextField = null;
         switch(param1)
         {
            case ObjectPropID.Color:
               return this.titleColor;
            case ObjectPropID.OutlineColor:
               _loc2_ = this.getTextField();
               if(_loc2_)
               {
                  return _loc2_.strokeColor;
               }
               return 0;
            case ObjectPropID.FontSize:
               return this.titleFontSize;
            case ObjectPropID.Selected:
               return this.selected;
            default:
               return super.getProp(param1);
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         var _loc3_:FTextField = null;
         switch(param1)
         {
            case ObjectPropID.Color:
               this.titleColor = param2;
               break;
            case ObjectPropID.OutlineColor:
               _loc3_ = this.getTextField();
               if(_loc3_)
               {
                  _loc3_.strokeColor = param2;
               }
               break;
            case ObjectPropID.FontSize:
               this.titleFontSize = param2;
               break;
            case ObjectPropID.Selected:
               this.selected = param2;
               break;
            default:
               super.setProp(param1,param2);
         }
      }
      
      override public function read_editMode(param1:XData) : void
      {
         var _loc2_:String = null;
         this._mode = param1.getAttribute("mode",COMMON);
         this._sound = param1.getAttribute("sound");
         this._volume = param1.getAttributeInt("volume",100);
         this._downEffect = param1.getAttribute("downEffect","none");
         if(this._downEffect == "scale" && _owner.pivotX == 0 && _owner.pivotY == 0)
         {
            _owner.setPivot(0.5,0.5,_owner.anchor);
         }
         this._downEffectValue = param1.getAttributeFloat("downEffectValue",0.8);
      }
      
      override public function write_editMode() : XData
      {
         var _loc1_:XData = XData.create("Button");
         if(this._mode != COMMON)
         {
            _loc1_.setAttribute("mode",this._mode);
         }
         if(this._sound)
         {
            _loc1_.setAttribute("sound",this._sound);
         }
         if(this._volume != 0 && this._volume != 100)
         {
            _loc1_.setAttribute("volume",this._volume);
         }
         if(this._downEffect && this._downEffect != "none")
         {
            _loc1_.setAttribute("downEffect",this._downEffect);
            _loc1_.setAttribute("downEffectValue",this._downEffectValue.toFixed(2));
         }
         return _loc1_;
      }
      
      override public function read(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         this.selected = param1.getAttributeBool("checked");
         _loc3_ = param1.getAttribute("title");
         if(param2)
         {
            _loc4_ = param2[_owner.id];
            if(_loc4_ != undefined)
            {
               _loc3_ = _loc4_;
            }
         }
         if(_loc3_)
         {
            this.title = _loc3_;
         }
         _loc3_ = param1.getAttribute("icon");
         if(_loc3_)
         {
            this.icon = _loc3_;
         }
         _loc3_ = param1.getAttribute("selectedTitle");
         if(param2)
         {
            _loc4_ = param2[_owner.id + "-0"];
            if(_loc4_ != undefined)
            {
               _loc3_ = _loc4_;
            }
         }
         if(_loc3_)
         {
            this.selectedTitle = _loc3_;
         }
         _loc3_ = param1.getAttribute("selectedIcon");
         if(_loc3_)
         {
            this.selectedIcon = _loc3_;
         }
         _loc3_ = param1.getAttribute("titleColor");
         if(_loc3_)
         {
            this.titleColor = UtilsStr.convertFromHtmlColor(_loc3_);
            this._titleColorSet = true;
         }
         _loc3_ = param1.getAttribute("titleFontSize");
         if(_loc3_)
         {
            this.titleFontSize = parseInt(_loc3_);
            this._titleFontSizeSet = true;
         }
         _loc3_ = param1.getAttribute("controller");
         if(_loc3_)
         {
            this._controller = _owner._parent.getController(_loc3_);
         }
         else
         {
            this._controller = null;
         }
         this._page = param1.getAttribute("page");
         _loc3_ = param1.getAttribute("sound");
         if(_loc3_ != null)
         {
            this._sound = _loc3_;
            this._soundSet = true;
         }
         else
         {
            this._soundSet = false;
         }
         _loc3_ = param1.getAttribute("volume");
         if(_loc3_)
         {
            this._volume = parseInt(_loc3_);
            this._soundVolumeSet = true;
         }
         else
         {
            this._soundVolumeSet = false;
         }
      }
      
      override public function write() : XData
      {
         var _loc1_:XData = XData.create("Button");
         if(this._selected)
         {
            _loc1_.setAttribute("checked",true);
         }
         if(this._title)
         {
            _loc1_.setAttribute("title",this._title);
         }
         if(this._titleColorSet)
         {
            _loc1_.setAttribute("titleColor",UtilsStr.convertToHtmlColor(this._titleColor));
         }
         if(this._titleFontSizeSet)
         {
            _loc1_.setAttribute("titleFontSize",this._titleFontSize);
         }
         if(this._icon)
         {
            _loc1_.setAttribute("icon",this._icon);
         }
         if(this._selectedTitle)
         {
            _loc1_.setAttribute("selectedTitle",this._selectedTitle);
         }
         if(this._selectedIcon)
         {
            _loc1_.setAttribute("selectedIcon",this._selectedIcon);
         }
         if(this._soundSet)
         {
            _loc1_.setAttribute("sound",this._sound);
         }
         if(this._soundVolumeSet)
         {
            _loc1_.setAttribute("volume",this._volume);
         }
         var _loc2_:String = this._controller && this._controller.parent?this._controller.name:null;
         if(_loc2_)
         {
            _loc1_.setAttribute("controller",_loc2_);
            if(this._page)
            {
               _loc1_.setAttribute("page",this._page);
            }
         }
         if(_loc1_.hasAttributes())
         {
            return _loc1_;
         }
         return null;
      }
      
      private function __rollover(param1:Event) : void
      {
         if(!this._buttonController || !this._buttonController.hasPageName(OVER))
         {
            return;
         }
         this._over = true;
         if(this._down || _owner.grayed && this._buttonController.hasPageName(DISABLED))
         {
            return;
         }
         this.setState(!!this._selected?SELECTED_OVER:OVER);
      }
      
      private function __rollout(param1:Event) : void
      {
         if(!this._buttonController || !this._buttonController.hasPageName(OVER))
         {
            return;
         }
         this._over = false;
         if(this._down || _owner.grayed && this._buttonController.hasPageName(DISABLED))
         {
            return;
         }
         this.setState(!!this._selected?DOWN:UP);
      }
      
      private function __mousedown(param1:MouseEvent) : void
      {
         this._down = true;
         _owner.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP,this.__mouseup);
         if(this._mode == COMMON)
         {
            if(_owner.grayed && this._buttonController && this._buttonController.hasPageName(DISABLED))
            {
               this.setState(SELECTED_DISABLED);
            }
            else
            {
               this.setState(DOWN);
            }
         }
      }
      
      private function __mouseup(param1:MouseEvent) : void
      {
         if(this._down)
         {
            param1.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseup);
            this._down = false;
            if(this._mode == COMMON)
            {
               if(_owner.grayed && this._buttonController && this._buttonController.hasPageName(DISABLED))
               {
                  this.setState(DISABLED);
               }
               else if(this._over)
               {
                  this.setState(OVER);
               }
               else
               {
                  this.setState(UP);
               }
               if(this._controller)
               {
                  this._controller.selectedPageId = this._page;
               }
            }
            else if(!this._over && this._buttonController && (this._buttonController.selectedPage == OVER || this._buttonController.selectedPage == SELECTED_OVER))
            {
               this.setCurrentState();
            }
         }
      }
      
      private function __click(param1:GTouchEvent) : void
      {
         var _loc2_:String = null;
         if((_owner._flags & FObjectFlags.IN_TEST) != 0)
         {
            _loc2_ = this._sound;
            if(!_loc2_)
            {
               _loc2_ = _owner._pkg.project.getSetting("common","buttonClickSound");
            }
            if(_loc2_)
            {
               _owner._pkg.project.playSound(_loc2_,this._volume / 100);
            }
         }
         if(this._mode == COMMON)
         {
            if(this._controller)
            {
               this._controller.selectedPageId = this._page;
            }
         }
         else if(this._mode == CHECK)
         {
            if(this.changeStageOnClick)
            {
               this.selected = !this._selected;
            }
         }
         else if(this.changeStageOnClick && !this._selected)
         {
            this.selected = true;
         }
      }
   }
}

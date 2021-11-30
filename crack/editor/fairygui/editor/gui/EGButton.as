package fairygui.editor.gui
{
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EGButton extends ComExtention
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
      
      private var _buttonController:EController;
      
      private var _titleObject:EGObject;
      
      private var _iconObject:EGObject;
      
      private var _controller:EController;
      
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
      
      public function EGButton()
      {
         super();
         this._mode = "Common";
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
               if(this._titleObject is EGTextField)
               {
                  EGTextField(this._titleObject).color = this._titleColor;
               }
               else if(this._titleObject is EGComponent)
               {
                  if(EGComponent(this._titleObject).extentionId == "Label")
                  {
                     EGLabel(EGComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
                  else if(EGComponent(this._titleObject).extentionId == "Button")
                  {
                     EGButton(EGComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
               }
            }
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
            if(this._titleObject is EGTextField)
            {
               EGTextField(this._titleObject).color = _loc2_;
            }
            else if(this._titleObject is EGComponent)
            {
               if(EGComponent(this._titleObject).extentionId == "Label")
               {
                  EGLabel(EGComponent(this._titleObject).extention).titleColor = _loc2_;
               }
               else if(EGComponent(this._titleObject).extentionId == "Button")
               {
                  EGButton(EGComponent(this._titleObject).extention).titleColor = _loc2_;
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
               if(this._titleObject is EGTextField)
               {
                  EGTextField(this._titleObject).fontSize = this._titleFontSize;
               }
               else if(this._titleObject is EGComponent)
               {
                  if(EGComponent(this._titleObject).extentionId == "Label")
                  {
                     EGLabel(EGComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                  }
                  else if(EGComponent(this._titleObject).extentionId == "Button")
                  {
                     EGButton(EGComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                  }
               }
            }
            _owner.updateGear(4);
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
            if(this._titleObject is EGTextField)
            {
               EGTextField(this._titleObject).fontSize = _loc2_;
            }
            else if(this._titleObject is EGComponent)
            {
               if(EGComponent(this._titleObject).extentionId == "Label")
               {
                  EGLabel(EGComponent(this._titleObject).extention).titleFontSize = _loc2_;
               }
               else if(EGComponent(this._titleObject).extentionId == "Button")
               {
                  EGButton(EGComponent(this._titleObject).extention).titleFontSize = _loc2_;
               }
            }
         }
      }
      
      public function getTextField() : EGTextField
      {
         if(this._titleObject is EGTextField)
         {
            return EGTextField(this._titleObject);
         }
         if(this._titleObject is EGLabel)
         {
            return EGLabel(this._titleObject).getTextField();
         }
         if(this._titleObject is EGButton)
         {
            return EGButton(this._titleObject).getTextField();
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
         if(this._mode == "Common")
         {
            return;
         }
         if(this._selected != param1)
         {
            this._selected = param1;
            if(_owner.grayed && this._buttonController && this._buttonController.hasPageName("disabled"))
            {
               if(this._selected)
               {
                  this.setState("selectedDisabled");
               }
               else
               {
                  this.setState("disabled");
               }
            }
            else if(this._selected)
            {
               this.setState(!!this._over?"selectedOver":"down");
            }
            else
            {
               this.setState(!!this._over?"over":"up");
            }
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
            if(this._controller && _owner.parent && _owner.editMode < 2 && !_owner.parent.buildingDisplayList)
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
                     _owner.parent.adjustRadioGroupDepth(_owner,this._controller);
                  }
               }
               else if(this._mode == "Check" && this._controller.selectedPageId == this._page)
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
            if(param1 == "Common")
            {
               setProperty("selected",false);
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
         var _loc2_:EController = null;
         if(param1)
         {
            _loc2_ = _owner.parent.getController(param1);
         }
         if(_loc2_ != this._controller)
         {
            this._controller = _loc2_;
            this._page = "";
         }
      }
      
      public function get controllerObj() : EController
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
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:EGObject = null;
         if(this._buttonController)
         {
            this._buttonController.selectedPage = param1;
         }
         if(_owner.editMode < 2)
         {
            if(this._downEffect == "scale")
            {
               _owner.setPivot(0.5,0.5);
               if(param1 == "down" || param1 == "selectedOver" || param1 == "selectedDisabled")
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
               _loc6_ = _owner.numChildren;
               if(param1 == "down" || param1 == "selectedOver" || param1 == "selectedDisabled")
               {
                  _loc4_ = this._downEffectValue * 255;
                  _loc5_ = (_loc4_ << 16) + (_loc4_ << 8) + _loc4_;
                  _loc2_ = 0;
                  while(_loc2_ < _loc6_)
                  {
                     _loc3_ = _owner.getChildAt(_loc2_);
                     if(_loc3_ is EIColorGear && !(_loc3_ is EGTextField))
                     {
                        EIColorGear(_loc3_).color = _loc5_;
                     }
                     _loc2_++;
                  }
               }
               else
               {
                  _loc2_ = 0;
                  while(_loc2_ < _loc6_)
                  {
                     _loc3_ = _owner.getChildAt(_loc2_);
                     if(_loc3_ is EIColorGear && !(_loc3_ is EGTextField))
                     {
                        EIColorGear(_loc3_).color = 16777215;
                     }
                     _loc2_++;
                  }
               }
            }
         }
      }
      
      public function handleGrayChanged() : Boolean
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         if(this._buttonController && this._buttonController.hasPageName("disabled"))
         {
            _loc2_ = _owner.numChildren;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _owner.getChildAt(_loc1_).grayed = false;
               _loc1_++;
            }
            if(_owner.grayed)
            {
               if(this._selected && this._buttonController.hasPageName("selectedDisabled"))
               {
                  this.setState("selectedDisabled");
               }
               else
               {
                  this.setState("disabled");
               }
            }
            else if(this._selected)
            {
               this.setState("down");
            }
            else
            {
               this.setState("up");
            }
            return true;
         }
         return false;
      }
      
      override public function handleControllerChanged(param1:EController) : void
      {
         super.handleControllerChanged(param1);
         if(this._controller == param1 && !this._controllerFlag)
         {
            this._controllerFlag = true;
            this.selected = this._page == param1.selectedPageId;
            this._controllerFlag = false;
         }
      }
      
      override protected function install() : void
      {
         if(_owner.editMode == 1)
         {
            _owner.displayObject.addEventListener("rollOver",this.__rollover);
            _owner.displayObject.addEventListener("rollOut",this.__rollout);
            _owner.displayObject.addEventListener("mouseDown",this.__mousedown);
            _owner.addEventListener("clickGTouch",this.__click);
         }
         this._buttonController = _owner.getController("button");
         this._titleObject = owner.getChild("title");
         this._iconObject = owner.getChild("icon");
         if(this._titleObject)
         {
            if(this._titleObject is EGTextField)
            {
               this._originColor = EGTextField(this._titleObject).color;
               this._originFontSize = EGTextField(this._titleObject).fontSize;
            }
            else if(this._titleObject is EGComponent)
            {
               if(EGComponent(this._titleObject).extentionId == "Label")
               {
                  this._originColor = EGLabel(EGComponent(this._titleObject).extention).titleColor;
                  this._originFontSize = EGLabel(EGComponent(this._titleObject).extention).titleFontSize;
               }
               else if(EGComponent(this._titleObject).extentionId == "Button")
               {
                  this._originColor = EGButton(EGComponent(this._titleObject).extention).titleColor;
                  this._originFontSize = EGButton(EGComponent(this._titleObject).extention).titleFontSize;
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
         this.setState("up");
      }
      
      override protected function uninstall() : void
      {
         if(_owner.editMode == 1)
         {
            _owner.displayObject.removeEventListener("rollOver",this.__rollover);
            _owner.displayObject.removeEventListener("rollOut",this.__rollout);
            _owner.displayObject.removeEventListener("mouseDown",this.__mousedown);
            _owner.removeEventListener("clickGTouch",this.__click);
         }
         this._buttonController = null;
         this._titleObject = null;
         this._iconObject = null;
      }
      
      override public function load(param1:XML) : void
      {
         var _loc2_:String = null;
         _loc2_ = param1.@mode;
         if(_loc2_)
         {
            this._mode = _loc2_;
         }
         else
         {
            this._mode = "Common";
         }
         this._sound = param1.@sound;
         _loc2_ = param1.@volume;
         if(_loc2_)
         {
            this._volume = parseInt(_loc2_);
         }
         _loc2_ = param1.@downEffect;
         if(_loc2_)
         {
            this._downEffect = _loc2_;
            _loc2_ = param1.@downEffectValue;
            if(_loc2_)
            {
               this._downEffectValue = parseFloat(_loc2_);
            }
         }
         else
         {
            this._downEffect = "none";
         }
      }
      
      override public function serialize() : XML
      {
         var _loc1_:XML = <Button/>;
         if(this._mode != "Common")
         {
            _loc1_.@mode = this._mode;
         }
         if(this._sound)
         {
            _loc1_.@sound = this._sound;
         }
         if(this._volume != 0 && this._volume != 100)
         {
            _loc1_.@volume = this._volume;
         }
         if(this._downEffect && this._downEffect != "none")
         {
            _loc1_.@downEffect = this._downEffect;
            _loc1_.@downEffectValue = this._downEffectValue.toFixed(2);
         }
         return _loc1_;
      }
      
      override public function fromXML(param1:XML) : void
      {
         var _loc2_:String = null;
         this.selected = param1.@checked == "true";
         _loc2_ = param1.@title;
         if(_loc2_)
         {
            this.title = _loc2_;
         }
         _loc2_ = param1.@icon;
         if(_loc2_)
         {
            this.icon = _loc2_;
         }
         _loc2_ = param1.@selectedTitle;
         if(_loc2_)
         {
            this.selectedTitle = _loc2_;
         }
         _loc2_ = param1.@selectedIcon;
         if(_loc2_)
         {
            this.selectedIcon = param1.@selectedIcon;
         }
         _loc2_ = param1.@titleColor;
         if(_loc2_)
         {
            this.titleColor = UtilsStr.convertFromHtmlColor(_loc2_);
            this._titleColorSet = true;
         }
         _loc2_ = param1.@titleFontSize;
         if(_loc2_)
         {
            this.titleFontSize = parseInt(_loc2_);
            this._titleFontSizeSet = true;
         }
         _loc2_ = param1.@controller;
         if(_loc2_)
         {
            this._controller = _owner.parent.getController(param1.@controller);
         }
         else
         {
            this._controller = null;
         }
         this._page = param1.@page;
         if(param1.@sound.length() != 0)
         {
            this._sound = param1.@sound;
            this._soundSet = true;
         }
         else
         {
            this._soundSet = false;
         }
         _loc2_ = param1.@volume;
         if(_loc2_)
         {
            this._volume = parseInt(_loc2_);
            this._soundVolumeSet = true;
         }
         else
         {
            this._soundVolumeSet = false;
         }
      }
      
      override public function toXML() : XML
      {
         var _loc2_:XML = <Button/>;
         if(this._selected)
         {
            _loc2_.@checked = true;
         }
         if(this._title)
         {
            _loc2_.@title = this._title;
         }
         if(this._titleColorSet)
         {
            _loc2_.@titleColor = UtilsStr.convertToHtmlColor(this._titleColor);
         }
         if(this._titleFontSizeSet)
         {
            _loc2_.@titleFontSize = this._titleFontSize;
         }
         if(this._icon)
         {
            _loc2_.@icon = this._icon;
         }
         if(this._selectedTitle)
         {
            _loc2_.@selectedTitle = this._selectedTitle;
         }
         if(this._selectedIcon)
         {
            _loc2_.@selectedIcon = this._selectedIcon;
         }
         if(this._soundSet)
         {
            _loc2_.@sound = this._sound;
         }
         if(this._soundVolumeSet)
         {
            _loc2_.@volume = this._volume;
         }
         var _loc1_:String = this._controller && this._controller.parent?this._controller.name:null;
         if(_loc1_)
         {
            _loc2_.@controller = _loc1_;
         }
         if(this._page)
         {
            _loc2_.@page = this._page;
         }
         if(_loc2_.attributes().length() == 0)
         {
            return null;
         }
         return _loc2_;
      }
      
      private function __rollover(param1:Event) : void
      {
         if(!this._buttonController || !this._buttonController.hasPageName("over"))
         {
            return;
         }
         this._over = true;
         if(this._down || _owner.grayed && this._buttonController.hasPageName("disabled"))
         {
            return;
         }
         this.setState(!!this._selected?"selectedOver":"over");
      }
      
      private function __rollout(param1:Event) : void
      {
         if(!this._buttonController || !this._buttonController.hasPageName("over"))
         {
            return;
         }
         this._over = false;
         if(this._down || _owner.grayed && this._buttonController.hasPageName("disabled"))
         {
            return;
         }
         this.setState(!!this._selected?"down":"up");
      }
      
      private function __mousedown(param1:MouseEvent) : void
      {
         this._down = true;
         _owner.displayObject.stage.addEventListener("mouseUp",this.__mouseup);
         if(this._mode == "Common")
         {
            if(_owner.grayed && this._buttonController && this._buttonController.hasPageName("disabled"))
            {
               this.setState("selectedDisabled");
            }
            else
            {
               this.setState("down");
            }
         }
      }
      
      private function __mouseup(param1:MouseEvent) : void
      {
         if(this._down)
         {
            param1.currentTarget.removeEventListener("mouseUp",this.__mouseup);
            this._down = false;
            if(this._mode == "Common")
            {
               if(_owner.grayed && this._buttonController && this._buttonController.hasPageName("disabled"))
               {
                  this.setState("disabled");
               }
               else if(this._over)
               {
                  this.setState("over");
               }
               else
               {
                  this.setState("up");
               }
               if(this._controller)
               {
                  this._controller.selectedPageId = this._page;
               }
            }
            else
            {
               if(!this.changeStageOnClick)
               {
                  return;
               }
               if(this._mode == "Check")
               {
                  this.selected = !this._selected;
               }
               else if(!this._selected)
               {
                  this.selected = true;
               }
            }
         }
      }
      
      private function __click(param1:Event) : void
      {
         if(!this.changeStageOnClick)
         {
            return;
         }
         if(_owner.editMode == 1)
         {
            if(this._sound)
            {
               _owner.pkg.project.editorWindow.playSound(this._sound,this._volume);
            }
            else if(_owner.pkg.project.settingsCenter.common.buttonClickSound)
            {
               _owner.pkg.project.editorWindow.playSound(_owner.pkg.project.settingsCenter.common.buttonClickSound,100);
            }
         }
      }
   }
}

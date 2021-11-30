package fairygui
{
   import fairygui.event.StateChangeEvent;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.media.Sound;
   
   public class GButton extends GComponent
   {
      
      public static const UP:String = "up";
      
      public static const DOWN:String = "down";
      
      public static const OVER:String = "over";
      
      public static const SELECTED_OVER:String = "selectedOver";
      
      public static const DISABLED:String = "disabled";
      
      public static const SELECTED_DISABLED:String = "selectedDisabled";
       
      
      protected var _titleObject:GObject;
      
      protected var _iconObject:GObject;
      
      protected var _relatedController:Controller;
      
      private var _mode:int;
      
      private var _selected:Boolean;
      
      private var _title:String;
      
      private var _selectedTitle:String;
      
      private var _icon:String;
      
      private var _selectedIcon:String;
      
      private var _sound:String;
      
      private var _soundVolumeScale:Number;
      
      private var _pageOption:PageOption;
      
      private var _buttonController:Controller;
      
      private var _changeStateOnClick:Boolean;
      
      private var _linkedPopup:GObject;
      
      private var _hasDisabledPage:Boolean;
      
      private var _downEffect:int;
      
      private var _downEffectValue:Number;
      
      private var _useHandCursor:Boolean;
      
      private var _downScaled:Boolean;
      
      private var _over:Boolean;
      
      public function GButton()
      {
         super();
         _mode = 0;
         _title = "";
         _icon = "";
         _sound = UIConfig.buttonSound;
         _soundVolumeScale = UIConfig.buttonSoundVolumeScale;
         _pageOption = new PageOption();
         _changeStateOnClick = true;
         _downEffectValue = 0.8;
         _useHandCursor = UIConfig.buttonUseHandCursor;
         if(_useHandCursor)
         {
            Sprite(this.displayObject).buttonMode = true;
            Sprite(this.displayObject).useHandCursor = true;
         }
      }
      
      override public function get icon() : String
      {
         return _icon;
      }
      
      override public function set icon(param1:String) : void
      {
         _icon = param1;
         param1 = _selected && _selectedIcon?_selectedIcon:_icon;
         if(_iconObject != null)
         {
            _iconObject.icon = param1;
         }
         updateGear(7);
      }
      
      public final function get selectedIcon() : String
      {
         return _selectedIcon;
      }
      
      public function set selectedIcon(param1:String) : void
      {
         _selectedIcon = param1;
         param1 = _selected && _selectedIcon?_selectedIcon:_icon;
         if(_iconObject != null)
         {
            _iconObject.icon = param1;
         }
      }
      
      public final function get title() : String
      {
         return _title;
      }
      
      public function set title(param1:String) : void
      {
         _title = param1;
         if(_titleObject)
         {
            _titleObject.text = _selected && _selectedTitle?_selectedTitle:_title;
         }
         updateGear(6);
      }
      
      override public final function get text() : String
      {
         return this.title;
      }
      
      override public function set text(param1:String) : void
      {
         this.title = param1;
      }
      
      public final function get selectedTitle() : String
      {
         return _selectedTitle;
      }
      
      public function set selectedTitle(param1:String) : void
      {
         _selectedTitle = param1;
         if(_titleObject)
         {
            _titleObject.text = _selected && _selectedTitle?_selectedTitle:_title;
         }
      }
      
      public final function get titleColor() : uint
      {
         var _loc1_:GTextField = getTextField();
         if(_loc1_)
         {
            return _loc1_.color;
         }
         return 0;
      }
      
      public function set titleColor(param1:uint) : void
      {
         var _loc2_:GTextField = getTextField();
         if(_loc2_)
         {
            _loc2_.color = param1;
         }
         updateGear(4);
      }
      
      public final function get titleFontSize() : int
      {
         var _loc1_:GTextField = getTextField();
         if(_loc1_)
         {
            return _loc1_.fontSize;
         }
         return 0;
      }
      
      public function set titleFontSize(param1:int) : void
      {
         var _loc2_:GTextField = getTextField();
         if(_loc2_)
         {
            _loc2_.fontSize = param1;
         }
      }
      
      public final function get sound() : String
      {
         return _sound;
      }
      
      public function set sound(param1:String) : void
      {
         _sound = param1;
      }
      
      public function get soundVolumeScale() : Number
      {
         return _soundVolumeScale;
      }
      
      public function set soundVolumeScale(param1:Number) : void
      {
         _soundVolumeScale = param1;
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:* = null;
         if(_mode == 0)
         {
            return;
         }
         if(_selected != param1)
         {
            _selected = param1;
            setCurrentState();
            if(_selectedTitle && _titleObject)
            {
               _titleObject.text = !!_selected?_selectedTitle:_title;
            }
            if(_selectedIcon)
            {
               _loc2_ = !!_selected?_selectedIcon:_icon;
               if(_iconObject != null)
               {
                  _iconObject.icon = _loc2_;
               }
            }
            if(_relatedController && _parent && !_parent._buildingDisplayList)
            {
               if(_selected)
               {
                  _relatedController.selectedPageId = _pageOption.id;
                  if(_relatedController._autoRadioGroupDepth)
                  {
                     _parent.adjustRadioGroupDepth(this,_relatedController);
                  }
               }
               else if(_mode == 1 && _relatedController.selectedPageId == _pageOption.id)
               {
                  _relatedController.oppositePageId = _pageOption.id;
               }
            }
         }
      }
      
      public final function get selected() : Boolean
      {
         return _selected;
      }
      
      public final function get mode() : int
      {
         return _mode;
      }
      
      public function set mode(param1:int) : void
      {
         if(_mode != param1)
         {
            if(param1 == 0)
            {
               this.selected = false;
            }
            _mode = param1;
         }
      }
      
      public final function get useHandCursor() : Boolean
      {
         return _useHandCursor;
      }
      
      public function set useHandCursor(param1:Boolean) : void
      {
         _useHandCursor = param1;
         Sprite(this.displayObject).buttonMode = _useHandCursor;
         Sprite(this.displayObject).useHandCursor = _useHandCursor;
      }
      
      public final function get relatedController() : Controller
      {
         return _relatedController;
      }
      
      public function set relatedController(param1:Controller) : void
      {
         if(param1 != _relatedController)
         {
            _relatedController = param1;
            _pageOption.controller = param1;
            _pageOption.clear();
         }
      }
      
      public final function get pageOption() : PageOption
      {
         return _pageOption;
      }
      
      public final function get changeStateOnClick() : Boolean
      {
         return _changeStateOnClick;
      }
      
      public final function set changeStateOnClick(param1:Boolean) : void
      {
         _changeStateOnClick = param1;
      }
      
      public final function get linkedPopup() : GObject
      {
         return _linkedPopup;
      }
      
      public final function set linkedPopup(param1:GObject) : void
      {
         _linkedPopup = param1;
      }
      
      public function addStateListener(param1:Function) : void
      {
         addEventListener("stateChanged",param1);
      }
      
      public function removeStateListener(param1:Function) : void
      {
         removeEventListener("stateChanged",param1);
      }
      
      public function fireClick(param1:Boolean = true) : void
      {
         if(param1 && _mode == 0)
         {
            setState("over");
            GTimers.inst.add(100,1,setState,"down");
            GTimers.inst.add(200,1,setState,"up");
         }
         __click(null);
      }
      
      public function getTextField() : GTextField
      {
         if(_titleObject is GTextField)
         {
            return GTextField(_titleObject);
         }
         if(_titleObject is GLabel)
         {
            return GLabel(_titleObject).getTextField();
         }
         if(_titleObject is GButton)
         {
            return GButton(_titleObject).getTextField();
         }
         return null;
      }
      
      protected function setState(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:* = 0;
         var _loc6_:int = 0;
         var _loc5_:* = null;
         if(_buttonController)
         {
            _buttonController.selectedPage = param1;
         }
         if(_downEffect == 1)
         {
            _loc2_ = this.numChildren;
            if(param1 == "down" || param1 == "selectedOver" || param1 == "selectedDisabled")
            {
               _loc4_ = _downEffectValue * 255;
               _loc3_ = uint((_loc4_ << 16) + (_loc4_ << 8) + _loc4_);
               _loc6_ = 0;
               while(_loc6_ < _loc2_)
               {
                  _loc5_ = this.getChildAt(_loc6_);
                  if(_loc5_ is IColorGear && !(_loc5_ is GTextField))
                  {
                     IColorGear(_loc5_).color = _loc3_;
                  }
                  _loc6_++;
               }
            }
            else
            {
               _loc6_ = 0;
               while(_loc6_ < _loc2_)
               {
                  _loc5_ = this.getChildAt(_loc6_);
                  if(_loc5_ is IColorGear && !(_loc5_ is GTextField))
                  {
                     IColorGear(_loc5_).color = 16777215;
                  }
                  _loc6_++;
               }
            }
         }
         else if(_downEffect == 2)
         {
            if(param1 == "down" || param1 == "selectedOver" || param1 == "selectedDisabled")
            {
               if(!_downScaled)
               {
                  setScale(this.scaleX * _downEffectValue,this.scaleY * _downEffectValue);
                  _downScaled = true;
               }
            }
            else if(_downScaled)
            {
               setScale(this.scaleX / _downEffectValue,this.scaleY / _downEffectValue);
               _downScaled = false;
            }
         }
      }
      
      protected function setCurrentState() : void
      {
         if(this.grayed && _buttonController && _buttonController.hasPage("disabled"))
         {
            if(_selected)
            {
               setState("selectedDisabled");
            }
            else
            {
               setState("disabled");
            }
         }
         else if(_selected)
         {
            setState(!!_over?"selectedOver":"down");
         }
         else
         {
            setState(!!_over?"over":"up");
         }
      }
      
      override public function handleControllerChanged(param1:Controller) : void
      {
         super.handleControllerChanged(param1);
         if(_relatedController == param1)
         {
            this.selected = _pageOption.id == param1.selectedPageId;
         }
      }
      
      override protected function handleGrayedChanged() : void
      {
         if(_buttonController && _buttonController.hasPage("disabled"))
         {
            if(this.grayed)
            {
               if(_selected)
               {
                  setState("selectedDisabled");
               }
               else
               {
                  setState("disabled");
               }
            }
            else if(_selected)
            {
               setState("down");
            }
            else
            {
               setState("up");
            }
         }
         else
         {
            super.handleGrayedChanged();
         }
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc2_:* = null;
         super.constructFromXML(param1);
         param1 = param1.Button[0];
         _loc2_ = param1.@mode;
         if(_loc2_)
         {
            _mode = ButtonMode.parse(_loc2_);
         }
         _loc2_ = param1.@sound;
         if(_loc2_)
         {
            _sound = _loc2_;
         }
         _loc2_ = param1.@volume;
         if(_loc2_)
         {
            _soundVolumeScale = parseInt(_loc2_) / 100;
         }
         _loc2_ = param1.@downEffect;
         if(_loc2_)
         {
            _downEffect = _loc2_ == "dark"?1:_loc2_ == "scale"?2:0;
            _loc2_ = param1.@downEffectValue;
            _downEffectValue = parseFloat(_loc2_);
            if(_downEffect == 2)
            {
               this.setPivot(0.5,0.5);
            }
         }
         _buttonController = getController("button");
         _titleObject = getChild("title");
         _iconObject = getChild("icon");
         if(_titleObject != null)
         {
            _title = _titleObject.text;
         }
         if(_iconObject != null)
         {
            _icon = _iconObject.icon;
         }
         if(_mode == 0)
         {
            setState("up");
         }
         this.opaque = true;
         if(!GRoot.touchScreen)
         {
            displayObject.addEventListener("rollOver",__rollover);
            displayObject.addEventListener("rollOut",__rollout);
         }
         this.addEventListener("beginGTouch",__mousedown);
         this.addEventListener("endGTouch",__mouseup);
         this.addEventListener("clickGTouch",__click,false,1000);
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         super.setup_afterAdd(param1);
         param1 = param1.Button[0];
         if(param1)
         {
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
               this.selectedIcon = _loc2_;
            }
            _loc2_ = param1.@titleColor;
            if(_loc2_)
            {
               this.titleColor = ToolSet.convertFromHtmlColor(_loc2_);
            }
            _loc2_ = param1.@titleFontSize;
            if(_loc2_)
            {
               this.titleFontSize = parseInt(_loc2_);
            }
            if(param1.@sound.length() != 0)
            {
               _sound = param1.@sound;
            }
            _loc2_ = param1.@volume;
            if(_loc2_)
            {
               _soundVolumeScale = parseInt(_loc2_) / 100;
            }
            _loc2_ = param1.@controller;
            if(_loc2_)
            {
               _relatedController = _parent.getController(param1.@controller);
            }
            else
            {
               _relatedController = null;
            }
            _pageOption.id = param1.@page;
            this.selected = param1.@checked == "true";
         }
      }
      
      private function __rollover(param1:Event) : void
      {
         if(!_buttonController || !_buttonController.hasPage("over"))
         {
            return;
         }
         _over = true;
         if(this.isDown)
         {
            return;
         }
         if(this.grayed && _buttonController.hasPage("disabled"))
         {
            return;
         }
         setState(!!_selected?"selectedOver":"over");
      }
      
      private function __rollout(param1:Event) : void
      {
         if(!_buttonController || !_buttonController.hasPage("over"))
         {
            return;
         }
         _over = false;
         if(this.isDown)
         {
            return;
         }
         if(this.grayed && _buttonController.hasPage("disabled"))
         {
            return;
         }
         setState(!!_selected?"down":"up");
      }
      
      private function __mousedown(param1:Event) : void
      {
         if(_mode == 0)
         {
            if(this.grayed && _buttonController && _buttonController.hasPage("disabled"))
            {
               setState("selectedDisabled");
            }
            else
            {
               setState("down");
            }
         }
         if(_linkedPopup != null)
         {
            if(_linkedPopup is Window)
            {
               Window(_linkedPopup).toggleStatus();
            }
            else
            {
               this.root.togglePopup(_linkedPopup,this);
            }
         }
      }
      
      private function __mouseup(param1:Event) : void
      {
         if(_mode == 0)
         {
            if(this.grayed && _buttonController && _buttonController.hasPage("disabled"))
            {
               setState("disabled");
            }
            else if(_over)
            {
               setState("over");
            }
            else
            {
               setState("up");
            }
         }
         else if(!_over && _buttonController && (_buttonController.selectedPage == "over" || _buttonController.selectedPage == "selectedOver"))
         {
            setCurrentState();
         }
      }
      
      private function __click(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(_sound)
         {
            _loc3_ = UIPackage.getItemByURL(_sound);
            if(_loc3_)
            {
               _loc2_ = _loc3_.owner.getSound(_loc3_);
               if(_loc2_)
               {
                  GRoot.inst.playOneShotSound(_loc2_,_soundVolumeScale);
               }
            }
         }
         if(_mode == 1)
         {
            if(_changeStateOnClick)
            {
               this.selected = !_selected;
               dispatchEvent(new StateChangeEvent("stateChanged"));
            }
         }
         else if(_mode == 2)
         {
            if(_changeStateOnClick && !_selected)
            {
               this.selected = true;
               dispatchEvent(new StateChangeEvent("stateChanged"));
            }
         }
         else if(_relatedController)
         {
            _relatedController.selectedPageId = _pageOption.id;
         }
      }
   }
}

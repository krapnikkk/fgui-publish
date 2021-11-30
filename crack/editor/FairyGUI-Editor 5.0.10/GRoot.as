package fairygui
{
   import fairygui.display.UIDisplayObject;
   import fairygui.event.FocusChangeEvent;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.ui.Multitouch;
   
   public class GRoot extends GComponent
   {
      
      private static var _inst:GRoot;
      
      public static var touchScreen:Boolean;
      
      public static var touchPointInput:Boolean;
      
      public static var eatUIEvents:Boolean;
      
      public static var contentScaleFactor:Number = 1;
      
      public static var contentScaleLevel:int = 0;
       
      
      private var _nativeStage:Stage;
      
      private var _modalLayer:GGraph;
      
      private var _popupStack:Vector.<GObject>;
      
      private var _justClosedPopups:Vector.<GObject>;
      
      private var _modalWaitPane:GObject;
      
      private var _focusedObject:GObject;
      
      private var _tooltipWin:GObject;
      
      private var _defaultTooltipWin:GObject;
      
      private var _hitUI:Boolean;
      
      private var _contextMenuDisabled:Boolean;
      
      private var _volumeScale:Number;
      
      private var _designResolutionX:int;
      
      private var _designResolutionY:int;
      
      private var _screenMatchMode:int;
      
      private var _popupCloseFlags:Vector.<Boolean>;
      
      public var buttonDown:Boolean;
      
      public var ctrlKeyDown:Boolean;
      
      public var shiftKeyDown:Boolean;
      
      public function GRoot()
      {
         super();
         if(_inst == null)
         {
            _inst = this;
         }
         _volumeScale = 1;
         _contextMenuDisabled = Capabilities.playerType == "Desktop";
         _popupStack = new Vector.<GObject>();
         _justClosedPopups = new Vector.<GObject>();
         _popupCloseFlags = new Vector.<Boolean>();
         displayObject.addEventListener("addedToStage",__addedToStage);
      }
      
      public static function get inst() : GRoot
      {
         if(_inst == null)
         {
            new GRoot();
         }
         return _inst;
      }
      
      public function get nativeStage() : Stage
      {
         return _nativeStage;
      }
      
      public function setContentScaleFactor(param1:int, param2:int, param3:int = 0) : void
      {
         _designResolutionX = param1;
         _designResolutionY = param2;
         _screenMatchMode = param3;
         if(_designResolutionX == 0)
         {
            _screenMatchMode = 1;
         }
         else if(_designResolutionY == 0)
         {
            _screenMatchMode = 2;
         }
         applyScaleFactor();
      }
      
      private function applyScaleFactor() : void
      {
         var _loc4_:* = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:int = _nativeStage.stageWidth;
         var _loc5_:int = _nativeStage.stageHeight;
         if(_designResolutionX == 0 || _designResolutionY == 0)
         {
            this.setSize(_loc1_,_loc5_);
            return;
         }
         var _loc2_:* = int(_designResolutionX);
         var _loc3_:* = int(_designResolutionY);
         if(_loc1_ > _loc5_ && _loc2_ < _loc3_ || _loc1_ < _loc5_ && _loc2_ > _loc3_)
         {
            _loc4_ = _loc2_;
            _loc2_ = _loc3_;
            _loc3_ = _loc4_;
         }
         if(_screenMatchMode == 0)
         {
            _loc6_ = _loc1_ / _loc2_;
            _loc7_ = _loc5_ / _loc3_;
            contentScaleFactor = Math.min(_loc6_,_loc7_);
         }
         else if(_screenMatchMode == 1)
         {
            contentScaleFactor = _loc1_ / _loc2_;
         }
         else
         {
            contentScaleFactor = _loc5_ / _loc3_;
         }
         this.setSize(Math.round(_loc1_ / contentScaleFactor),Math.round(_loc5_ / contentScaleFactor));
         this.scaleX = contentScaleFactor;
         this.scaleY = contentScaleFactor;
         updateContentScaleLevel();
      }
      
      private function updateContentScaleLevel() : void
      {
         var _loc1_:Number = contentScaleFactor;
         if(_nativeStage.hasOwnProperty("contentsScaleFactor"))
         {
            _loc1_ = _loc1_ * _nativeStage["contentsScaleFactor"];
         }
         if(_loc1_ >= 8)
         {
            contentScaleLevel = 4;
         }
         else if(_loc1_ >= 3.5)
         {
            contentScaleLevel = 3;
         }
         else if(_loc1_ >= 2.5)
         {
            contentScaleLevel = 2;
         }
         else if(_loc1_ >= 1.5)
         {
            contentScaleLevel = 1;
         }
         else
         {
            contentScaleLevel = 0;
         }
      }
      
      public function setFlashContextMenuDisabled(param1:Boolean) : void
      {
         _contextMenuDisabled = param1;
         if(_nativeStage)
         {
            if(_contextMenuDisabled)
            {
               _nativeStage.addEventListener("rightMouseDown",__stageMouseDownCapture,true);
               _nativeStage.addEventListener("rightMouseUp",__stageMouseUpCapture,true);
            }
            else
            {
               _nativeStage.removeEventListener("rightMouseDown",__stageMouseDownCapture,true);
               _nativeStage.removeEventListener("rightMouseUp",__stageMouseUpCapture,true);
            }
         }
      }
      
      public function showWindow(param1:Window) : void
      {
         addChild(param1);
         param1.requestFocus();
         if(param1.x > this.width)
         {
            param1.x = this.width - param1.width;
         }
         else if(param1.x + param1.width < 0)
         {
            param1.x = 0;
         }
         if(param1.y > this.height)
         {
            param1.y = this.height - param1.height;
         }
         else if(param1.y + param1.height < 0)
         {
            param1.y = 0;
         }
         adjustModalLayer();
      }
      
      public function hideWindow(param1:Window) : void
      {
         param1.hide();
      }
      
      public function hideWindowImmediately(param1:Window) : void
      {
         if(param1.parent == this)
         {
            removeChild(param1);
         }
         adjustModalLayer();
      }
      
      public function bringToFront(param1:Window) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = this.numChildren;
         if(this._modalLayer.parent != null && !param1.modal)
         {
            _loc4_ = this.getChildIndex(this._modalLayer) - 1;
         }
         else
         {
            _loc4_ = _loc3_ - 1;
         }
         while(_loc4_ >= 0)
         {
            _loc2_ = this.getChildAt(_loc4_);
            if(_loc2_ == param1)
            {
               return;
            }
            if(!(_loc2_ is Window))
            {
               _loc4_--;
               continue;
            }
            break;
         }
         if(_loc4_ >= 0)
         {
            this.setChildIndex(param1,_loc4_);
         }
      }
      
      public function showModalWait(param1:String = null) : void
      {
         if(UIConfig.globalModalWaiting != null)
         {
            if(_modalWaitPane == null)
            {
               _modalWaitPane = UIPackage.createObjectFromURL(UIConfig.globalModalWaiting);
            }
            _modalWaitPane.setSize(this.width,this.height);
            _modalWaitPane.addRelation(this,24);
            addChild(_modalWaitPane);
            _modalWaitPane.text = param1;
         }
      }
      
      public function closeModalWait() : void
      {
         if(_modalWaitPane != null && _modalWaitPane.parent != null)
         {
            removeChild(_modalWaitPane);
         }
      }
      
      public function closeAllExceptModals() : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc1_:Vector.<GObject> = _children.slice();
         var _loc3_:int = _loc1_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc1_[_loc4_];
            if(_loc2_ is Window && !(_loc2_ as Window).modal)
            {
               (_loc2_ as Window).hide();
            }
            _loc4_++;
         }
      }
      
      public function closeAllWindows() : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc1_:Vector.<GObject> = _children.slice();
         var _loc3_:int = _loc1_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc1_[_loc4_];
            if(_loc2_ is Window)
            {
               (_loc2_ as Window).hide();
            }
            _loc4_++;
         }
      }
      
      public function getTopWindow() : Window
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         var _loc2_:int = this.numChildren;
         _loc3_ = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc1_ = this.getChildAt(_loc3_);
            if(_loc1_ is Window)
            {
               return Window(_loc1_);
            }
            _loc3_--;
         }
         return null;
      }
      
      public function getWindowBefore(param1:Window) : Window
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = this.numChildren;
         var _loc5_:Boolean = false;
         _loc4_ = _loc3_ - 1;
         while(_loc4_ >= 0)
         {
            _loc2_ = this.getChildAt(_loc4_);
            if(_loc2_ is Window)
            {
               if(_loc5_)
               {
                  return Window(_loc2_);
               }
               if(_loc2_ == param1)
               {
                  _loc5_ = true;
               }
            }
            _loc4_--;
         }
         return null;
      }
      
      public function get modalLayer() : GGraph
      {
         return _modalLayer;
      }
      
      public function get hasModalWindow() : Boolean
      {
         return _modalLayer.parent != null;
      }
      
      public function get modalWaiting() : Boolean
      {
         return _modalWaitPane && _modalWaitPane.inContainer;
      }
      
      public function showPopup(param1:GObject, param2:GObject = null, param3:Object = null, param4:Boolean = false) : void
      {
         var _loc12_:int = 0;
         var _loc11_:int = 0;
         var _loc5_:* = null;
         var _loc10_:* = null;
         var _loc9_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = NaN;
         var _loc8_:Number = NaN;
         if(_popupStack.length > 0)
         {
            _loc12_ = _popupStack.indexOf(param1);
            if(_loc12_ != -1)
            {
               _loc11_ = _popupStack.length - 1;
               while(_loc11_ >= _loc12_)
               {
                  closePopup(_popupStack.pop());
                  _popupCloseFlags.pop();
                  _loc11_--;
               }
            }
         }
         _popupStack.push(param1);
         _popupCloseFlags.push(param4);
         if(param2 != null)
         {
            _loc5_ = param2;
            while(_loc5_ != null)
            {
               if(_loc5_.parent == this)
               {
                  if(param1.sortingOrder < _loc5_.sortingOrder)
                  {
                     param1.sortingOrder = _loc5_.sortingOrder;
                  }
                  break;
               }
               _loc5_ = _loc5_.parent;
            }
         }
         addChild(param1);
         adjustModalLayer();
         if(param2)
         {
            _loc10_ = param2.localToRoot();
            _loc6_ = param2.width;
            _loc9_ = param2.height;
         }
         else
         {
            _loc10_ = this.globalToLocal(nativeStage.mouseX,nativeStage.mouseY);
         }
         _loc8_ = _loc10_.x;
         if(_loc8_ + param1.width > this.width)
         {
            _loc8_ = _loc8_ + _loc6_ - param1.width;
         }
         _loc7_ = Number(_loc10_.y + _loc9_);
         if(param3 == null && _loc7_ + param1.height > this.height || param3 == false)
         {
            _loc7_ = Number(_loc10_.y - param1.height - 1);
            if(_loc7_ < 0)
            {
               _loc7_ = 0;
               _loc8_ = _loc8_ + _loc6_ / 2;
               if(_loc8_ + param1.width > this.width)
               {
                  _loc8_ = this.width - param1.width;
               }
            }
         }
         param1.setXY(int(_loc8_),int(_loc7_));
      }
      
      public function togglePopup(param1:GObject, param2:GObject = null, param3:Object = null, param4:Boolean = false) : void
      {
         if(_justClosedPopups.indexOf(param1) != -1)
         {
            return;
         }
         showPopup(param1,param2,param3,param4);
      }
      
      public function hidePopup(param1:GObject = null) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(param1 != null)
         {
            _loc4_ = _popupStack.indexOf(param1);
            if(_loc4_ != -1)
            {
               _loc3_ = _popupStack.length - 1;
               while(_loc3_ >= _loc4_)
               {
                  closePopup(_popupStack.pop());
                  _popupCloseFlags.pop();
                  _loc3_--;
               }
            }
         }
         else
         {
            _loc2_ = _popupStack.length;
            _loc3_ = _loc2_ - 1;
            while(_loc3_ >= 0)
            {
               closePopup(_popupStack[_loc3_]);
               _loc3_--;
            }
            _popupStack.length = 0;
            _popupCloseFlags.length = 0;
         }
      }
      
      public function get hasAnyPopup() : Boolean
      {
         return _popupStack.length != 0;
      }
      
      private function closePopup(param1:GObject) : void
      {
         if(param1.parent != null)
         {
            if(param1 is Window)
            {
               Window(param1).hide();
            }
            else
            {
               removeChild(param1);
            }
         }
      }
      
      public function showTooltips(param1:String) : void
      {
         var _loc2_:* = null;
         if(_defaultTooltipWin == null)
         {
            _loc2_ = UIConfig.tooltipsWin;
            if(!_loc2_)
            {
               return;
               §§push(trace("UIConfig.tooltipsWin not defined"));
            }
            else
            {
               _defaultTooltipWin = UIPackage.createObjectFromURL(_loc2_);
               _defaultTooltipWin.touchable = false;
            }
         }
         _defaultTooltipWin.text = param1;
         showTooltipsWin(_defaultTooltipWin);
      }
      
      public function showTooltipsWin(param1:GObject, param2:Point = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         hideTooltips();
         _tooltipWin = param1;
         if(param2 == null)
         {
            _loc3_ = _nativeStage.mouseX + 10;
            _loc4_ = _nativeStage.mouseY + 20;
         }
         else
         {
            _loc3_ = param2.x;
            _loc4_ = param2.y;
         }
         var _loc5_:Point = this.globalToLocal(_loc3_,_loc4_);
         _loc3_ = _loc5_.x;
         _loc4_ = _loc5_.y;
         if(_loc3_ + _tooltipWin.width > this.width)
         {
            _loc3_ = _loc3_ - _tooltipWin.width - 1;
            if(_loc3_ < 0)
            {
               _loc3_ = 10;
            }
         }
         if(_loc4_ + _tooltipWin.height > this.height)
         {
            _loc4_ = _loc4_ - _tooltipWin.height - 1;
            if(_loc3_ - _tooltipWin.width - 1 > 0)
            {
               _loc3_ = _loc3_ - _tooltipWin.width - 1;
            }
            if(_loc4_ < 0)
            {
               _loc4_ = 10;
            }
         }
         _tooltipWin.x = _loc3_;
         _tooltipWin.y = _loc4_;
         addChild(_tooltipWin);
      }
      
      public function hideTooltips() : void
      {
         if(_tooltipWin != null)
         {
            if(_tooltipWin.parent)
            {
               removeChild(_tooltipWin);
            }
            _tooltipWin = null;
         }
      }
      
      public function getObjectUnderMouse() : GObject
      {
         return getObjectUnderPoint(_nativeStage.mouseX,_nativeStage.mouseY);
      }
      
      public function getObjectUnderPoint(param1:Number, param2:Number) : GObject
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc6_:Array = _nativeStage.getObjectsUnderPoint(new Point(param1,param2));
         if(!_loc6_ || _loc6_.length == 0)
         {
            return null;
         }
         _loc4_ = _loc6_.length;
         _loc5_ = _loc4_ - 1;
         while(_loc5_ >= 0)
         {
            _loc3_ = isTouchableGObject(_loc6_[_loc5_]);
            if(_loc3_)
            {
               return _loc3_;
            }
            _loc5_--;
         }
         return null;
      }
      
      private function isTouchableGObject(param1:DisplayObject) : GObject
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         while(param1 != null && !(param1 is Stage))
         {
            if(param1 is UIDisplayObject)
            {
               _loc2_ = UIDisplayObject(param1).owner;
               if(!_loc3_)
               {
                  _loc3_ = _loc2_;
                  if(_loc3_.touchable)
                  {
                     return _loc3_;
                  }
               }
               else if(_loc2_.touchable)
               {
                  if(_loc2_ is GRoot)
                  {
                     return null;
                  }
                  return _loc3_;
               }
            }
            param1 = param1.parent;
         }
         return null;
      }
      
      public function get focus() : GObject
      {
         if(_focusedObject && !_focusedObject.onStage)
         {
            _focusedObject = null;
         }
         return _focusedObject;
      }
      
      public function set focus(param1:GObject) : void
      {
         if(param1 && (!param1.focusable || !param1.onStage))
         {
            return;
         }
         setFocus(param1);
         if(param1 is GTextInput)
         {
            _nativeStage.focus = TextField(GTextInput(param1).displayObject);
         }
      }
      
      private function setFocus(param1:GObject) : void
      {
         var _loc2_:* = null;
         if(_focusedObject != param1)
         {
            if(_focusedObject != null && _focusedObject.onStage)
            {
               _loc2_ = _focusedObject;
            }
            _focusedObject = param1;
            dispatchEvent(new FocusChangeEvent("focusChanged",_loc2_,param1));
         }
      }
      
      public function get volumeScale() : Number
      {
         return _volumeScale;
      }
      
      public function set volumeScale(param1:Number) : void
      {
         _volumeScale = param1;
      }
      
      public function playOneShotSound(param1:Sound, param2:Number = 1) : void
      {
         var _loc3_:Number = _volumeScale * param2;
         if(_loc3_ == 1)
         {
            param1.play();
         }
         else
         {
            param1.play(0,0,new SoundTransform(_loc3_));
         }
      }
      
      private function adjustModalLayer() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         var _loc2_:int = this.numChildren;
         if(_modalWaitPane != null && _modalWaitPane.parent != null)
         {
            setChildIndex(_modalWaitPane,_loc2_ - 1);
         }
         _loc3_ = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            _loc1_ = this.getChildAt(_loc3_);
            if(_loc1_ is Window && (_loc1_ as Window).modal)
            {
               if(_modalLayer.parent == null)
               {
                  addChildAt(_modalLayer,_loc3_);
               }
               else
               {
                  setChildIndexBefore(_modalLayer,_loc3_);
               }
               return;
            }
            _loc3_--;
         }
         if(_modalLayer.parent != null)
         {
            removeChild(_modalLayer);
         }
      }
      
      private function __addedToStage(param1:Event) : void
      {
         displayObject.removeEventListener("addedToStage",__addedToStage);
         _nativeStage = displayObject.stage;
         touchScreen = Capabilities.os.toLowerCase().slice(0,3) != "win" && Capabilities.os.toLowerCase().slice(0,3) != "mac" && Capabilities.touchscreenType != "none";
         if(touchScreen)
         {
            Multitouch.inputMode = "touchPoint";
            touchPointInput = true;
         }
         updateContentScaleLevel();
         _nativeStage.addEventListener("mouseDown",__stageMouseDownCapture,true);
         _nativeStage.addEventListener("mouseDown",__stageMouseDown,false,1);
         _nativeStage.addEventListener("mouseUp",__stageMouseUpCapture,true);
         _nativeStage.addEventListener("mouseUp",__stageMouseUp,false,1);
         if(_contextMenuDisabled)
         {
            _nativeStage.addEventListener("rightMouseDown",__stageMouseDownCapture,true);
            _nativeStage.addEventListener("rightMouseUp",__stageMouseUpCapture,true);
         }
         _modalLayer = new GGraph();
         _modalLayer.setSize(this.width,this.height);
         _modalLayer.drawRect(0,0,0,UIConfig.modalLayerColor,UIConfig.modalLayerAlpha);
         _modalLayer.addRelation(this,24);
         if(Capabilities.os.toLowerCase().slice(0,3) == "win" || Capabilities.os.toLowerCase().slice(0,3) == "mac")
         {
            _nativeStage.addEventListener("resize",__winResize);
         }
         else
         {
            _nativeStage.addEventListener("orientationChange",__orientationChange);
         }
         __winResize(null);
      }
      
      private function __stageMouseDownCapture(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc5_:Boolean = false;
         var _loc3_:* = null;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         ctrlKeyDown = param1.ctrlKey;
         shiftKeyDown = param1.shiftKey;
         buttonDown = true;
         _hitUI = param1.target != _nativeStage;
         var _loc4_:DisplayObject = param1.target as DisplayObject;
         while(_loc4_ != _nativeStage && _loc4_ != null)
         {
            if(_loc4_ is UIDisplayObject)
            {
               _loc2_ = UIDisplayObject(_loc4_).owner;
               if(_loc2_.touchable && _loc2_.focusable)
               {
                  this.setFocus(_loc2_);
                  break;
               }
            }
            _loc4_ = _loc4_.parent;
         }
         if(_tooltipWin != null)
         {
            hideTooltips();
         }
         _justClosedPopups.length = 0;
         if(_popupStack.length > 0)
         {
            _loc4_ = param1.target as DisplayObject;
            _loc5_ = false;
            while(_loc4_ != _nativeStage && _loc4_ != null)
            {
               if(_loc4_ is UIDisplayObject)
               {
                  _loc8_ = _popupStack.indexOf(UIDisplayObject(_loc4_).owner);
                  if(_loc8_ != -1)
                  {
                     _loc7_ = _popupStack.length - 1;
                     while(_loc7_ > _loc8_)
                     {
                        if(!_popupCloseFlags[_loc7_])
                        {
                           _loc3_ = _popupStack[_loc7_];
                           _popupStack.splice(_loc7_,1);
                           _popupCloseFlags.splice(_loc7_,1);
                           closePopup(_loc3_);
                           _justClosedPopups.push(_loc3_);
                        }
                        _loc7_--;
                     }
                     _loc5_ = true;
                     break;
                  }
               }
               _loc4_ = _loc4_.parent;
            }
            if(!_loc5_)
            {
               _loc6_ = _popupStack.length;
               _loc7_ = _loc6_ - 1;
               while(_loc7_ >= 0)
               {
                  if(!_popupCloseFlags[_loc7_])
                  {
                     _loc3_ = _popupStack[_loc7_];
                     _popupStack.splice(_loc7_,1);
                     _popupCloseFlags.splice(_loc7_,1);
                     closePopup(_loc3_);
                     _justClosedPopups.push(_loc3_);
                  }
                  _loc7_--;
               }
            }
         }
      }
      
      private function __stageMouseDown(param1:MouseEvent) : void
      {
         if(param1.eventPhase == 2)
         {
            __stageMouseDownCapture(param1);
         }
         if(eatUIEvents && param1.target != _nativeStage)
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function __stageMouseUpCapture(param1:MouseEvent) : void
      {
         var _loc3_:* = null;
         var _loc4_:Boolean = false;
         var _loc2_:* = null;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         buttonDown = false;
         if(_popupStack.length > 0)
         {
            _loc3_ = param1.target as DisplayObject;
            _loc4_ = false;
            while(_loc3_ != _nativeStage && _loc3_ != null)
            {
               if(_loc3_ is UIDisplayObject)
               {
                  _loc7_ = _popupStack.indexOf(UIDisplayObject(_loc3_).owner);
                  if(_loc7_ != -1)
                  {
                     _loc6_ = _popupStack.length - 1;
                     while(_loc6_ > _loc7_)
                     {
                        if(_popupCloseFlags[_loc6_])
                        {
                           _loc2_ = _popupStack[_loc6_];
                           _popupStack.splice(_loc6_,1);
                           _popupCloseFlags.splice(_loc6_,1);
                           closePopup(_loc2_);
                           _justClosedPopups.push(_loc2_);
                        }
                        _loc6_--;
                     }
                     _loc4_ = true;
                     break;
                  }
               }
               _loc3_ = _loc3_.parent;
            }
            if(!_loc4_)
            {
               _loc5_ = _popupStack.length;
               _loc6_ = _loc5_ - 1;
               while(_loc6_ >= 0)
               {
                  if(_popupCloseFlags[_loc6_])
                  {
                     _loc2_ = _popupStack[_loc6_];
                     _popupStack.splice(_loc6_,1);
                     _popupCloseFlags.splice(_loc6_,1);
                     closePopup(_loc2_);
                     _justClosedPopups.push(_loc2_);
                  }
                  _loc6_--;
               }
            }
         }
      }
      
      private function __stageMouseUp(param1:MouseEvent) : void
      {
         if(param1.eventPhase == 2)
         {
            __stageMouseUpCapture(param1);
         }
         if(eatUIEvents && (_hitUI || param1.target != _nativeStage))
         {
            param1.stopImmediatePropagation();
         }
         _hitUI = false;
      }
      
      private function __winResize(param1:Event) : void
      {
         applyScaleFactor();
      }
      
      private function __orientationChange(param1:Event) : void
      {
         applyScaleFactor();
      }
   }
}

package fairygui.editor.gui
{
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import fairygui.editor.gui.gear.EIAnimationGear;
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.Utils;
   import fairygui.utils.GTimers;
   import flash.utils.getTimer;
   
   public class ETransition
   {
       
      
      public var owner:EGComponent;
      
      private var _name:String;
      
      private var _options:int;
      
      private var _items:Vector.<ETransitionItem>;
      
      private var _ownerBaseX:Number;
      
      private var _ownerBaseY:Number;
      
      private var _autoPlay:Boolean;
      
      private var _autoPlayRepeat:int;
      
      private var _autoPlayDelay:Number;
      
      public var timelinePanelHeight:Number;
      
      public const OPTION_IGNORE_DISPLAY_CONTROLLER:int = 1;
      
      public const OPTION_AUTO_STOP_DISABLED:int = 2;
      
      public const OPTION_AUTO_STOP_AT_END:int = 4;
      
      private var pending:Vector.<ETransitionItem>;
      
      private var _totalTimes:int;
      
      private var _totalTasks:int;
      
      private var _playing:Boolean;
      
      private var _onComplete:Function;
      
      private var _onCompleteParam:Object;
      
      public function ETransition(param1:EGComponent)
      {
         this.pending = new Vector.<ETransitionItem>();
         super();
         this.owner = param1;
         this._items = new Vector.<ETransitionItem>();
         this._ownerBaseX = 0;
         this._ownerBaseY = 0;
         this._autoPlayRepeat = 1;
         this._autoPlayDelay = 0;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get options() : int
      {
         return this._options;
      }
      
      public function set options(param1:int) : void
      {
         this._options = param1;
      }
      
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         this._autoPlay = param1;
      }
      
      public function get autoPlayDelay() : Number
      {
         return this._autoPlayDelay;
      }
      
      public function set autoPlayDelay(param1:Number) : void
      {
         this._autoPlayDelay = param1;
      }
      
      public function get autoPlayRepeat() : int
      {
         return this._autoPlayRepeat;
      }
      
      public function set autoPlayRepeat(param1:int) : void
      {
         this._autoPlayRepeat = param1;
      }
      
      public function get ignoreDisplayController() : Boolean
      {
         return (this._options & 1) != 0;
      }
      
      public function set ignoreDisplayController(param1:Boolean) : void
      {
         if(param1)
         {
            this._options = this._options | 1;
         }
         else
         {
            this._options = this._options & ~1;
         }
      }
      
      public function get autoStop() : Boolean
      {
         return (this._options & 2) == 0;
      }
      
      public function set autoStop(param1:Boolean) : void
      {
         if(!param1)
         {
            this._options = this._options | 2;
         }
         else
         {
            this._options = this._options & ~2;
         }
      }
      
      public function get autoStopAtEnd() : Boolean
      {
         return (this._options & 4) != 0;
      }
      
      public function set autoStopAtEnd(param1:Boolean) : void
      {
         if(param1)
         {
            this._options = this._options | 4;
         }
         else
         {
            this._options = this._options & ~4;
         }
      }
      
      public function dispose() : void
      {
      }
      
      public function get items() : Vector.<ETransitionItem>
      {
         return this._items;
      }
      
      public function arrangeItems() : void
      {
         var _loc2_:ETransitionItem = null;
         var _loc3_:int = 0;
         var _loc1_:ETransitionItem = null;
         this._items.sort(this.__compareItem);
         var _loc5_:int = this._items.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = this._items[_loc4_];
            if(_loc2_.nextItem)
            {
               _loc2_.nextItem.prevItem = null;
               _loc2_.nextItem = null;
            }
            if(_loc2_.tween)
            {
               _loc3_ = _loc4_ + 1;
               while(_loc3_ < _loc5_)
               {
                  _loc1_ = this._items[_loc3_];
                  if(_loc1_.targetId == _loc2_.targetId && _loc1_.type == _loc2_.type)
                  {
                     _loc2_.nextItem = _loc1_;
                     _loc1_.prevItem = _loc2_;
                     break;
                  }
                  _loc3_++;
               }
            }
            _loc4_++;
         }
      }
      
      private function __compareItem(param1:ETransitionItem, param2:ETransitionItem) : int
      {
         if(param1.frame == param2.frame)
         {
            if(param1.type == "Pivot")
            {
               return -1;
            }
            if(param2.type == "Pivot")
            {
               return 1;
            }
            return param1.type.localeCompare(param2.type);
         }
         return param1.frame - param2.frame;
      }
      
      public function createItem(param1:String, param2:String, param3:int) : ETransitionItem
      {
         var _loc4_:ETransitionItem = new ETransitionItem(this);
         _loc4_.targetId = param1;
         _loc4_.type = param2;
         _loc4_.frame = param3;
         this.udpateValueFromTarget(_loc4_);
         this._items.push(_loc4_);
         this.arrangeItems();
         return _loc4_;
      }
      
      private function udpateValueFromTarget(param1:ETransitionItem) : void
      {
         var _loc2_:EGObject = null;
         var _loc3_:ETransitionValue = param1.value;
         if(param1.targetId)
         {
            _loc2_ = this.owner.getChildById(param1.targetId);
         }
         else
         {
            _loc2_ = this.owner;
         }
         var _loc4_:* = param1.type;
         if("XY" !== _loc4_)
         {
            if("XYV" !== _loc4_)
            {
               if("Size" !== _loc4_)
               {
                  if("Pivot" !== _loc4_)
                  {
                     if("Alpha" !== _loc4_)
                     {
                        if("Rotation" !== _loc4_)
                        {
                           if("Scale" !== _loc4_)
                           {
                              if("Skew" !== _loc4_)
                              {
                                 if("Color" !== _loc4_)
                                 {
                                    if("Animation" !== _loc4_)
                                    {
                                       if("Sound" !== _loc4_)
                                       {
                                          if("Controller" !== _loc4_)
                                          {
                                             if("Shake" !== _loc4_)
                                             {
                                                if("Visible" !== _loc4_)
                                                {
                                                   if("ColorFilter" === _loc4_)
                                                   {
                                                      _loc3_.filter_cb = _loc2_.filter_cb;
                                                      _loc3_.filter_cc = _loc2_.filter_cc;
                                                      _loc3_.filter_ch = _loc2_.filter_ch;
                                                      _loc3_.filter_cs = _loc2_.filter_cs;
                                                   }
                                                }
                                                else
                                                {
                                                   _loc3_.visible = _loc2_.visible;
                                                }
                                             }
                                             else
                                             {
                                                _loc3_.shakeAmplitude = 3;
                                                _loc3_.shakePeriod = 0.5;
                                             }
                                          }
                                       }
                                    }
                                    else
                                    {
                                       _loc3_.aniName = EIAnimationGear(_loc2_).aniName;
                                       _loc3_.frame = EIAnimationGear(_loc2_).frame;
                                       _loc3_.playing = EIAnimationGear(_loc2_).playing;
                                    }
                                 }
                                 else
                                 {
                                    _loc3_.color = EIColorGear(_loc2_).color;
                                 }
                              }
                              else
                              {
                                 _loc3_.a = _loc2_.skewX;
                                 _loc3_.b = _loc2_.skewY;
                              }
                           }
                           else
                           {
                              _loc3_.a = _loc2_.scaleX;
                              _loc3_.b = _loc2_.scaleY;
                           }
                        }
                        else
                        {
                           _loc3_.rotation = _loc2_.rotation;
                        }
                     }
                     else
                     {
                        _loc3_.alpha = _loc2_.alpha;
                     }
                  }
                  else
                  {
                     _loc3_.a = _loc2_.pivotX;
                     _loc3_.b = _loc2_.pivotY;
                  }
               }
               else
               {
                  _loc3_.a = _loc2_.width;
                  _loc3_.b = _loc2_.height;
               }
            }
            else
            {
               _loc3_.a = _loc2_.x;
               _loc3_.b = _loc2_.y;
            }
         }
         else
         {
            _loc3_.a = _loc2_.x;
            _loc3_.b = _loc2_.y;
         }
      }
      
      public function findCurItem(param1:String, param2:String) : ETransitionItem
      {
         var _loc3_:int = this.owner.pkg.project.editorWindow.mainPanel.editPanel.timelinePanel.head;
         return this.findItem(_loc3_,param1,param2);
      }
      
      public function findItem(param1:int, param2:String, param3:String) : ETransitionItem
      {
         return this.findItem2(param1,param2,param3,this._items);
      }
      
      public function findItem2(param1:int, param2:String, param3:String, param4:Vector.<ETransitionItem>) : ETransitionItem
      {
         var _loc7_:ETransitionItem = null;
         var _loc5_:int = param4.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param4[_loc6_];
            if(_loc7_.type == param3 && _loc7_.targetId == param2 && _loc7_.frame == param1)
            {
               return _loc7_;
            }
            _loc6_++;
         }
         return null;
      }
      
      public function addItem(param1:ETransitionItem) : void
      {
         this._items.push(param1);
         this.arrangeItems();
      }
      
      public function addItems(param1:Array) : void
      {
         var _loc2_:ETransitionItem = null;
         var _loc4_:int = 0;
         var _loc3_:* = param1;
         for each(_loc2_ in param1)
         {
            this._items.push(_loc2_);
         }
         this.arrangeItems();
      }
      
      public function deleteItem(param1:ETransitionItem) : void
      {
         var _loc2_:int = this._items.indexOf(param1);
         this._items.splice(_loc2_,1);
         this.arrangeItems();
      }
      
      public function deleteItems(param1:String, param2:String) : Array
      {
         var _loc4_:ETransitionItem = null;
         var _loc5_:Array = [];
         var _loc6_:int = this._items.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = this._items[_loc3_];
            if(_loc4_.type == param2 && _loc4_.targetId == param1)
            {
               this._items.splice(_loc3_,1);
               _loc5_.push(_loc4_);
               _loc6_--;
            }
            else
            {
               _loc3_++;
            }
         }
         this.arrangeItems();
         return _loc5_;
      }
      
      public function copyItems(param1:String, param2:String) : XML
      {
         var _loc5_:ETransitionItem = null;
         var _loc6_:int = this._items.length;
         var _loc7_:Vector.<ETransitionItem> = new Vector.<ETransitionItem>();
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_)
         {
            _loc5_ = this._items[_loc3_];
            if(_loc5_.type == param2 && _loc5_.targetId == param1)
            {
               _loc7_.push(_loc5_);
            }
            _loc3_++;
         }
         var _loc4_:XML = <transition/>;
         this.serializeItems(_loc7_,_loc4_,false);
         return _loc4_;
      }
      
      public function pasteItems(param1:XML, param2:String, param3:String) : void
      {
         var _loc7_:XML = null;
         var _loc6_:ETransitionItem = null;
         var _loc8_:int = this._items.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc8_)
         {
            _loc6_ = this._items[_loc4_];
            if(_loc6_.type == param3 && _loc6_.targetId == param2)
            {
               this._items.splice(_loc4_,1);
               _loc8_--;
            }
            else
            {
               _loc4_++;
            }
         }
         var _loc5_:XMLList = param1.item;
         var _loc10_:int = 0;
         var _loc9_:* = _loc5_;
         for each(_loc7_ in _loc5_)
         {
            _loc7_.@target = param2;
            _loc7_.@type = param3;
         }
         this.addItemsFromXML(param1);
         this._items.sort(this.__compareItem);
      }
      
      public function setProperty(param1:String, param2:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         _loc3_ = this[param1];
         if(Utils.equalText(param2,_loc3_))
         {
            return _loc3_;
         }
         this[param1] = param2;
         _loc4_ = this[param1];
         if(!Utils.equalText(_loc4_,_loc3_))
         {
            this.owner.pkg.project.editorWindow.activeComDocument.actionHistory.action_transitionSet(param1,_loc3_,_loc4_);
            if(param1 == "name")
            {
               this.owner.pkg.project.editorWindow.mainPanel.editPanel.updateTransitionListPanel();
            }
         }
         return _loc4_;
      }
      
      public function setItemProperty(param1:ETransitionItem, param2:String, param3:*) : *
      {
         var _loc5_:* = undefined;
         var _loc4_:* = undefined;
         _loc5_ = param1[param2];
         if(Utils.equalText(param3,_loc5_))
         {
            return _loc5_;
         }
         param1[param2] = param3;
         _loc4_ = param1[param2];
         if(!Utils.equalText(_loc4_,_loc5_))
         {
            this.owner.pkg.project.editorWindow.activeComDocument.actionHistory.action_transItemSet(param1,param2,_loc5_,_loc4_);
         }
         return _loc4_;
      }
      
      public function getAllowXChanged(param1:String) : Boolean
      {
         var _loc3_:int = this.owner.pkg.project.editorWindow.mainPanel.editPanel.timelinePanel.head;
         var _loc2_:ETransitionItem = this.findItem(_loc3_,param1,"XY");
         if(_loc2_ != null)
         {
            return _loc2_.value.aEnabled;
         }
         return false;
      }
      
      public function getAllowSizeChanged(param1:String) : Boolean
      {
         var _loc2_:int = this.owner.pkg.project.editorWindow.mainPanel.editPanel.timelinePanel.head;
         return this.findItem(_loc2_,param1,"Size") != null;
      }
      
      public function updateFromRelations(param1:String, param2:Number, param3:Number) : void
      {
         var _loc5_:ETransitionItem = null;
         var _loc6_:int = this._items.length;
         if(_loc6_ == 0)
         {
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc6_)
         {
            _loc5_ = this._items[_loc4_];
            if(_loc5_.type == "XY" && _loc5_.targetId == param1)
            {
               _loc5_.value.a = _loc5_.value.a + param2;
               _loc5_.value.b = _loc5_.value.b + param3;
            }
            _loc4_++;
         }
      }
      
      public function setCurFrame(param1:int) : void
      {
         var _loc8_:ETransitionItem = null;
         var _loc2_:EGObject = null;
         var _loc3_:Object = null;
         var _loc6_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc4_:TimelineMax = null;
         this.owner.pkg.project.editorWindow.mainPanel.propsPanelList.propsTransitionFrame.lockUpdate = true;
         this.owner.readSnapshot(false);
         this.pending.length = 0;
         var _loc9_:int = this._items.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc9_)
         {
            _loc8_ = this._items[_loc7_];
            if(_loc8_.valid)
            {
               if(_loc8_.frame <= param1)
               {
                  if(_loc8_.frame == param1)
                  {
                     this.applyValue(_loc8_,_loc8_.value,false);
                  }
                  else if(_loc8_.tween)
                  {
                     if(_loc8_.nextItem == null)
                     {
                        this.applyValue(_loc8_,_loc8_.value,false);
                        addr92:
                     }
                     else if(_loc8_.nextItem.frame > param1)
                     {
                        this.pending.push(_loc8_);
                        §§goto(addr92);
                     }
                  }
                  else
                  {
                     this.applyValue(_loc8_,_loc8_.value,false);
                  }
               }
               else
               {
                  break;
               }
            }
            _loc7_++;
         }
         if(this.pending.length > 0)
         {
            var _loc12_:int = 0;
            var _loc11_:* = this.pending;
            for each(_loc8_ in this.pending)
            {
               if(_loc8_.targetId)
               {
                  _loc2_ = this.owner.getChildById(_loc8_.targetId);
               }
               else
               {
                  _loc2_ = this.owner;
               }
               var _loc10_:* = _loc8_.type;
               if("XY" !== _loc10_)
               {
                  if("XYV" !== _loc10_)
                  {
                     if("Size" !== _loc10_)
                     {
                        if("Scale" !== _loc10_)
                        {
                           if("Skew" !== _loc10_)
                           {
                              if("Alpha" !== _loc10_)
                              {
                                 if("Rotation" !== _loc10_)
                                 {
                                    if("Color" !== _loc10_)
                                    {
                                       if("ColorFilter" === _loc10_)
                                       {
                                          _loc8_.tweenValue.filter_cb = _loc8_.value.filter_cb;
                                          _loc8_.tweenValue.filter_cc = _loc8_.value.filter_cc;
                                          _loc8_.tweenValue.filter_ch = _loc8_.value.filter_ch;
                                          _loc8_.tweenValue.filter_cs = _loc8_.value.filter_cs;
                                          _loc3_ = {
                                             "filter_cb":_loc8_.nextItem.value.filter_cb,
                                             "filter_cb":_loc8_.nextItem.value.filter_cc,
                                             "filter_cb":_loc8_.nextItem.value.filter_ch,
                                             "filter_cb":_loc8_.nextItem.value.filter_cs,
                                             "ease":_loc8_.ease
                                          };
                                       }
                                    }
                                    else
                                    {
                                       _loc8_.tweenValue.color = _loc8_.value.color;
                                       _loc3_ = {
                                          "hexColors":{"color":_loc8_.nextItem.value.color},
                                          "ease":_loc8_.ease
                                       };
                                    }
                                 }
                                 else
                                 {
                                    _loc8_.tweenValue.rotation = _loc8_.value.rotation;
                                    _loc3_ = {
                                       "rotation":_loc8_.nextItem.value.rotation,
                                       "ease":_loc8_.ease
                                    };
                                 }
                              }
                              else
                              {
                                 _loc8_.tweenValue.alpha = _loc8_.value.alpha;
                                 _loc3_ = {
                                    "alpha":_loc8_.nextItem.value.alpha,
                                    "ease":_loc8_.ease
                                 };
                              }
                           }
                        }
                        _loc8_.tweenValue.a = _loc8_.value.a;
                        _loc8_.tweenValue.b = _loc8_.value.b;
                        _loc3_ = {"ease":_loc8_.ease};
                        _loc3_.a = _loc8_.nextItem.value.a;
                        _loc3_.b = _loc8_.nextItem.value.b;
                     }
                     else
                     {
                        _loc8_.tweenValue.a = !!_loc8_.value.aEnabled?Number(_loc8_.value.a):Number(_loc2_.width);
                        _loc8_.tweenValue.b = !!_loc8_.value.bEnabled?Number(_loc8_.value.b):Number(_loc2_.height);
                        _loc3_ = {"ease":_loc8_.ease};
                        _loc3_.a = !!_loc8_.nextItem.value.aEnabled?_loc8_.nextItem.value.a:_loc8_.tweenValue.a;
                        _loc3_.b = !!_loc8_.nextItem.value.bEnabled?_loc8_.nextItem.value.b:_loc8_.tweenValue.b;
                     }
                  }
                  else
                  {
                     _loc8_.tweenValue.a = !!_loc8_.value.aEnabled?Number(_loc8_.value.a):Number(_loc2_.x);
                     _loc8_.tweenValue.b = !!_loc8_.value.bEnabled?Number(_loc8_.value.b):Number(_loc2_.y);
                     _loc3_ = {"ease":_loc8_.ease};
                     _loc3_.a = !!_loc8_.nextItem.value.aEnabled?_loc8_.nextItem.value.a:_loc8_.tweenValue.a;
                     _loc3_.b = !!_loc8_.nextItem.value.bEnabled?_loc8_.nextItem.value.b:_loc8_.tweenValue.b;
                  }
               }
               else
               {
                  _loc8_.tweenValue.a = !!_loc8_.value.aEnabled?Number(_loc8_.value.a):Number(_loc2_.x);
                  _loc8_.tweenValue.b = !!_loc8_.value.bEnabled?Number(_loc8_.value.b):Number(_loc2_.y);
                  _loc3_ = {"ease":_loc8_.ease};
                  _loc3_.a = !!_loc8_.nextItem.value.aEnabled?_loc8_.nextItem.value.a:_loc8_.tweenValue.a;
                  _loc3_.b = !!_loc8_.nextItem.value.bEnabled?_loc8_.nextItem.value.b:_loc8_.tweenValue.b;
               }
               if(_loc3_ != null)
               {
                  _loc6_ = (_loc8_.nextItem.frame - _loc8_.frame) / 24;
                  _loc5_ = (param1 - _loc8_.frame) / 24;
                  if(_loc8_.throughPoints.length > 0)
                  {
                     _loc3_.bezierThrough = _loc8_.throughPoints.concat([{
                        "a":_loc3_.a,
                        "b":_loc3_.b
                     }]);
                  }
                  if(_loc8_.repeat != 0)
                  {
                     if(_loc8_.repeat == -1)
                     {
                        _loc3_.repeat = 2147483647;
                     }
                     else
                     {
                        _loc3_.repeat = _loc8_.repeat;
                     }
                  }
                  if(_loc8_.yoyo)
                  {
                     _loc3_.yoyo = _loc8_.yoyo;
                  }
                  _loc4_ = new TimelineMax();
                  _loc4_.to(_loc8_.tweenValue,_loc6_,_loc3_);
                  _loc4_.seek(_loc5_);
                  _loc4_.kill(null,_loc8_.tweenValue);
                  this.applyValue(_loc8_,_loc8_.tweenValue,true);
               }
            }
         }
         this.owner.pkg.project.editorWindow.mainPanel.propsPanelList.propsTransitionFrame.lockUpdate = false;
      }
      
      private function applyValue(param1:ETransitionItem, param2:ETransitionValue, param3:Boolean) : void
      {
         var _loc4_:EGObject = null;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc6_:ETransition = null;
         var _loc8_:String = param1.type;
         if(param1.targetId)
         {
            _loc4_ = this.owner.getChildById(param1.targetId);
         }
         else
         {
            _loc4_ = this.owner;
         }
         if(_loc4_ != null)
         {
            _loc4_.gearLocked = true;
            var _loc9_:* = _loc8_;
            if("XY" !== _loc9_)
            {
               if("XYV" !== _loc9_)
               {
                  if("Size" !== _loc9_)
                  {
                     if("Pivot" !== _loc9_)
                     {
                        if("Alpha" !== _loc9_)
                        {
                           if("Rotation" !== _loc9_)
                           {
                              if("Scale" !== _loc9_)
                              {
                                 if("Skew" !== _loc9_)
                                 {
                                    if("Color" !== _loc9_)
                                    {
                                       if("Animation" !== _loc9_)
                                       {
                                          if("Visible" !== _loc9_)
                                          {
                                             if("Transition" !== _loc9_)
                                             {
                                                if("Sound" !== _loc9_)
                                                {
                                                   if("Shake" !== _loc9_)
                                                   {
                                                      if("ColorFilter" === _loc9_)
                                                      {
                                                         _loc4_.filter_cb = param2.filter_cb;
                                                         _loc4_.filter_cc = param2.filter_cc;
                                                         _loc4_.filter_ch = param2.filter_ch;
                                                         _loc4_.filter_cs = param2.filter_cs;
                                                         _loc4_.filter = "color";
                                                      }
                                                   }
                                                   else if(this.owner.editMode == 1)
                                                   {
                                                      param1.completed = false;
                                                      this._totalTasks++;
                                                      param2.a = getTimer();
                                                      param2.b = param2.shakePeriod;
                                                      param2.c = 0;
                                                      param2.d = 0;
                                                      GTimers.inst.add(1,0,param1.__shake,this);
                                                   }
                                                }
                                                else if(this.owner.editMode == 1)
                                                {
                                                   this.owner.pkg.project.editorWindow.playSound(param2.sound,param2.volume);
                                                }
                                             }
                                             else if(this.owner.editMode == 1)
                                             {
                                                _loc6_ = EGComponent(_loc4_).transitions.getItem(param2.transName);
                                                if(_loc6_ != null)
                                                {
                                                   if(param2.transTimes == 0)
                                                   {
                                                      _loc6_.stop(true);
                                                   }
                                                   else if(_loc6_.playing)
                                                   {
                                                      _loc6_._totalTimes = param2.transTimes == -1?2147483647:int(param2.transTimes);
                                                   }
                                                   else
                                                   {
                                                      param1.completed = false;
                                                      this._totalTasks++;
                                                      _loc6_.play(this.__tweenComplete,param1,param2.transTimes);
                                                   }
                                                }
                                             }
                                          }
                                          else
                                          {
                                             _loc4_.visible = param2.visible;
                                          }
                                       }
                                       else
                                       {
                                          if(!param2.aEnabled)
                                          {
                                             param2.frame = EIAnimationGear(_loc4_).frame;
                                          }
                                          EIAnimationGear(_loc4_).aniName = param2.aniName;
                                          EIAnimationGear(_loc4_).frame = param2.frame;
                                          EIAnimationGear(_loc4_).playing = param2.playing;
                                       }
                                    }
                                    else
                                    {
                                       EIColorGear(_loc4_).color = param2.color;
                                    }
                                 }
                                 else
                                 {
                                    _loc4_.setSkew(param2.a,param2.b);
                                 }
                              }
                              else
                              {
                                 _loc4_.setScale(param2.a,param2.b);
                              }
                           }
                           else
                           {
                              _loc4_.rotation = param2.rotation;
                           }
                        }
                        else
                        {
                           _loc4_.alpha = param2.alpha;
                        }
                     }
                     else
                     {
                        _loc4_.setPivot(param2.a,param2.b);
                     }
                  }
                  else
                  {
                     if(!param2.aEnabled)
                     {
                        param2.a = _loc4_.width;
                     }
                     if(!param2.bEnabled)
                     {
                        param2.b = _loc4_.height;
                     }
                     _loc4_.setSize(param2.a,param2.b);
                  }
               }
               else if(_loc4_ == this.owner)
               {
                  if(!param2.aEnabled)
                  {
                     _loc5_ = _loc4_.x;
                  }
                  else
                  {
                     _loc5_ = param2.a + this._ownerBaseX;
                  }
                  if(!param2.bEnabled)
                  {
                     _loc7_ = _loc4_.y;
                  }
                  else
                  {
                     _loc7_ = param2.b + this._ownerBaseY;
                  }
                  _loc4_.setXYV(_loc5_,_loc7_);
               }
               else
               {
                  if(!param2.aEnabled)
                  {
                     param2.a = _loc4_.x;
                  }
                  if(!param2.bEnabled)
                  {
                     param2.b = _loc4_.y;
                  }
                  _loc4_.setXYV(param2.a,param2.b);
               }
            }
            else if(_loc4_ == this.owner)
            {
               if(!param2.aEnabled)
               {
                  _loc5_ = _loc4_.x;
               }
               else
               {
                  _loc5_ = param2.a + this._ownerBaseX;
               }
               if(!param2.bEnabled)
               {
                  _loc7_ = _loc4_.y;
               }
               else
               {
                  _loc7_ = param2.b + this._ownerBaseY;
               }
               _loc4_.setXY(_loc5_,_loc7_);
            }
            else
            {
               if(!param2.aEnabled)
               {
                  param2.a = _loc4_.x;
               }
               if(!param2.bEnabled)
               {
                  param2.b = _loc4_.y;
               }
               _loc4_.setXY(param2.a,param2.b);
            }
            _loc4_.gearLocked = false;
         }
      }
      
      public function validate() : void
      {
         var _loc1_:ETransitionItem = null;
         var _loc3_:int = this._items.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._items[_loc2_];
            if(_loc1_.targetId)
            {
               _loc1_.valid = this.owner.getChildById(_loc1_.targetId) != null;
            }
            _loc2_++;
         }
      }
      
      public function addItemsFromXML(param1:XML) : void
      {
         var _loc11_:String = null;
         var _loc14_:XML = null;
         var _loc12_:int = 0;
         var _loc13_:ETransitionItem = null;
         var _loc2_:Object = null;
         var _loc4_:int = 0;
         var _loc3_:ETransitionValue = null;
         var _loc5_:ETransitionItem = null;
         var _loc8_:Vector.<ETransitionItem> = new Vector.<ETransitionItem>();
         var _loc6_:XMLList = param1.item;
         var _loc7_:Array = [];
         var _loc10_:int = 0;
         var _loc9_:int = 0;
         var _loc16_:int = 0;
         var _loc15_:* = _loc6_;
         for each(_loc14_ in _loc6_)
         {
            _loc13_ = new ETransitionItem(this);
            _loc8_.push(_loc13_);
            _loc2_ = {};
            _loc9_++;
            _loc7_[_loc9_] = _loc2_;
            _loc11_ = _loc14_.@duration;
            _loc2_.duration = parseInt(_loc11_);
            _loc11_ = _loc14_.@time;
            _loc13_.frame = parseInt(_loc11_);
            _loc13_.type = _loc14_.@type;
            _loc13_.targetId = _loc14_.@target;
            _loc13_.tween = _loc14_.@tween == "true";
            _loc11_ = _loc14_.@repeat;
            if(_loc11_)
            {
               _loc13_.repeat = parseInt(_loc11_);
            }
            _loc13_.yoyo = _loc14_.@yoyo == "true";
            _loc13_.label = _loc14_.@label;
            _loc11_ = _loc14_.@label2;
            if(_loc11_)
            {
               _loc2_.label2 = _loc11_;
            }
            _loc11_ = _loc14_.@ease;
            if(_loc11_)
            {
               _loc4_ = _loc11_.indexOf(".");
               if(_loc4_ != -1)
               {
                  _loc13_.easeType = _loc11_.substr(0,_loc4_);
                  _loc13_.easeInOutType = _loc11_.substr(_loc4_ + 1);
               }
               else
               {
                  _loc13_.easeType = _loc11_;
               }
            }
            _loc11_ = _loc14_.@startValue;
            if(_loc11_)
            {
               _loc13_.value.decode(_loc13_.type,_loc11_);
            }
            else
            {
               _loc11_ = _loc14_.@value;
               if(_loc11_)
               {
                  _loc13_.value.decode(_loc13_.type,_loc11_);
               }
            }
            _loc11_ = _loc14_.@endValue;
            if(_loc11_)
            {
               _loc3_ = new ETransitionValue();
               _loc3_.decode(_loc13_.type,_loc11_);
               _loc2_.value = _loc3_;
            }
         }
         _loc12_ = _loc8_.length;
         _loc10_ = 0;
         while(_loc10_ < _loc12_)
         {
            _loc13_ = _loc8_[_loc10_];
            _loc2_ = _loc7_[_loc10_];
            if(_loc13_.tween && _loc2_.duration > 0)
            {
               _loc5_ = this.findItem2(_loc13_.frame + _loc2_.duration,_loc13_.targetId,_loc13_.type,_loc8_);
               if(_loc5_ == null)
               {
                  _loc5_ = new ETransitionItem(this);
                  _loc5_.frame = _loc13_.frame + _loc2_.duration;
                  _loc5_.type = _loc13_.type;
                  _loc5_.targetId = _loc13_.targetId;
                  _loc5_.value.assign(_loc2_.value);
                  _loc5_.tween = false;
                  _loc5_.label = _loc2_.label2;
                  _loc8_.push(_loc5_);
               }
               _loc13_.nextItem = _loc5_;
               _loc5_.prevItem = _loc13_;
            }
            _loc10_++;
         }
         var _loc18_:int = 0;
         var _loc17_:* = _loc8_;
         for each(_loc13_ in _loc8_)
         {
            this._items.push(_loc13_);
         }
      }
      
      public function serializeItems(param1:Vector.<ETransitionItem>, param2:XML, param3:Boolean) : void
      {
         var _loc4_:ETransitionItem = null;
         var _loc7_:XML = null;
         var _loc6_:String = null;
         var _loc8_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc8_)
         {
            _loc4_ = param1[_loc5_];
            if(!(_loc4_.prevItem && !_loc4_.tween))
            {
               if(!(param3 && !_loc4_.valid))
               {
                  _loc7_ = <item/>;
                  _loc7_.@time = _loc4_.frame;
                  _loc7_.@type = _loc4_.type;
                  if(_loc4_.targetId)
                  {
                     _loc7_.@target = _loc4_.targetId;
                  }
                  if(_loc4_.label)
                  {
                     _loc7_.@label = _loc4_.label;
                  }
                  if(_loc4_.tween)
                  {
                     _loc7_.@tween = _loc4_.tween;
                     _loc7_.@startValue = _loc4_.value.encode(_loc4_.type);
                     if(_loc4_.nextItem)
                     {
                        _loc7_.@endValue = _loc4_.nextItem.value.encode(_loc4_.type);
                        _loc7_.@duration = _loc4_.nextItem.frame - _loc4_.frame;
                        if(_loc4_.nextItem.label)
                        {
                           _loc7_.@label2 = _loc4_.nextItem.label;
                        }
                     }
                     _loc6_ = _loc4_.easeName;
                     if(_loc6_ != "Quad.Out")
                     {
                        _loc7_.@ease = _loc6_;
                     }
                     if(_loc4_.repeat != 0)
                     {
                        _loc7_.@repeat = _loc4_.repeat;
                     }
                     if(_loc4_.yoyo)
                     {
                        _loc7_.@yoyo = _loc4_.yoyo;
                     }
                  }
                  else
                  {
                     _loc7_.@value = _loc4_.value.encode(_loc4_.type);
                  }
                  param2.appendChild(_loc7_);
               }
            }
            _loc5_++;
         }
      }
      
      public function fromXML(param1:XML) : void
      {
         var _loc2_:String = null;
         this._name = param1.@name;
         _loc2_ = param1.@options;
         if(_loc2_ != null)
         {
            this._options = parseInt(_loc2_);
         }
         else
         {
            this._options = 0;
         }
         this._autoPlay = param1.@autoPlay == "true";
         _loc2_ = param1.@autoPlayRepeat;
         if(_loc2_)
         {
            this._autoPlayRepeat = parseInt(_loc2_);
         }
         _loc2_ = param1.@autoPlayDelay;
         if(_loc2_)
         {
            this._autoPlayDelay = parseFloat(_loc2_);
         }
         this._items.length = 0;
         this.addItemsFromXML(param1);
         this._items.sort(this.__compareItem);
      }
      
      public function toXML(param1:Boolean) : XML
      {
         this.validate();
         var _loc2_:XML = <transition/>;
         _loc2_.@name = this._name;
         if(this._options != 0)
         {
            _loc2_.@options = this._options;
         }
         if(this._autoPlay)
         {
            _loc2_.@autoPlay = this._autoPlay;
         }
         if(this._autoPlayRepeat != 1)
         {
            _loc2_.@autoPlayRepeat = this._autoPlayRepeat;
         }
         if(this._autoPlayDelay != 0)
         {
            _loc2_.@autoPlayDelay = this._autoPlayDelay.toFixed(3);
         }
         this.serializeItems(this._items,_loc2_,param1);
         return _loc2_;
      }
      
      public function play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:ETransitionItem = null;
         var _loc7_:EGObject = null;
         this.stop();
         this.validate();
         if(param3 < 0)
         {
            param3 = 2147483647;
         }
         else if(param3 == 0)
         {
            param3 = 1;
         }
         this._totalTimes = param3;
         this.internalPlay(param4);
         this._playing = this._totalTasks > 0;
         if(this._playing)
         {
            this._onComplete = param1;
            this._onCompleteParam = param2;
            if(this.owner.editMode == 1)
            {
               if(this._options & 1)
               {
                  _loc5_ = this._items.length;
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     _loc8_ = this._items[_loc6_];
                     if(_loc8_.valid)
                     {
                        if(_loc8_.targetId)
                        {
                           _loc7_ = this.owner.getChildById(_loc8_.targetId);
                           if(this.owner.editMode == 1)
                           {
                              _loc8_.displayLockToken = _loc7_.addDisplayLock();
                           }
                        }
                     }
                     _loc6_++;
                  }
               }
            }
         }
         else if(param1 != null)
         {
            if(param1.length > 0)
            {
               param1(param2);
            }
            else
            {
               param1();
            }
         }
      }
      
      public function get playing() : Boolean
      {
         return this._playing;
      }
      
      public function set repeat(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 2147483647;
         }
         else if(param1 == 0)
         {
            param1 = 1;
         }
         this._totalTimes = param1;
      }
      
      public function get repeat() : int
      {
         return this._totalTimes;
      }
      
      private function internalPlay(param1:Number = 0) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc3_:ETransitionItem = null;
         var _loc4_:Number = NaN;
         this._ownerBaseX = this.owner.x;
         this._ownerBaseY = this.owner.y;
         this._totalTasks = 0;
         var _loc7_:int = this._items.length;
         var _loc2_:int = 0;
         for(; _loc2_ < _loc7_; _loc2_++)
         {
            _loc3_ = this._items[_loc2_];
            if(_loc3_.valid)
            {
               _loc6_ = param1 + _loc3_.frame / 24;
               if(_loc3_.tween)
               {
                  if(_loc3_.nextItem == null)
                  {
                     if(_loc3_.frame == 0)
                     {
                        this.applyValue(_loc3_,_loc3_.value,false);
                     }
                     else
                     {
                        this._totalTasks++;
                        _loc3_.completed = false;
                        _loc3_.tweener = TweenMax.delayedCall(_loc6_,this.delayCall,[_loc3_]);
                     }
                  }
                  else
                  {
                     _loc3_.completed = false;
                     this._totalTasks++;
                     _loc4_ = (_loc3_.nextItem.frame - _loc3_.frame) / 24;
                     var _loc8_:* = _loc3_.type;
                     if("XY" !== _loc8_)
                     {
                        if("XYV" !== _loc8_)
                        {
                           if("Size" !== _loc8_)
                           {
                              if("Scale" !== _loc8_)
                              {
                                 if("Skew" !== _loc8_)
                                 {
                                    if("Alpha" !== _loc8_)
                                    {
                                       if("Rotation" !== _loc8_)
                                       {
                                          if("Color" !== _loc8_)
                                          {
                                             if("ColorFilter" !== _loc8_)
                                             {
                                                _loc3_.completed = true;
                                                this._totalTasks--;
                                             }
                                             else
                                             {
                                                _loc3_.tweenValue.filter_cb = _loc3_.value.filter_cb;
                                                _loc3_.tweenValue.filter_cc = _loc3_.value.filter_cc;
                                                _loc3_.tweenValue.filter_ch = _loc3_.value.filter_ch;
                                                _loc3_.tweenValue.filter_cs = _loc3_.value.filter_cs;
                                                _loc5_ = {
                                                   "filter_cb":_loc3_.nextItem.value.filter_cb,
                                                   "filter_cc":_loc3_.nextItem.value.filter_cc,
                                                   "filter_ch":_loc3_.nextItem.value.filter_ch,
                                                   "filter_cs":_loc3_.nextItem.value.filter_cs,
                                                   "ease":_loc3_.ease,
                                                   "onUpdate":this.__tweenUpdate,
                                                   "onUpdateParams":[_loc3_],
                                                   "onComplete":this.__tweenComplete,
                                                   "onCompleteParams":[_loc3_]
                                                };
                                                if(_loc6_ != 0)
                                                {
                                                   _loc5_.delay = _loc6_;
                                                }
                                                else
                                                {
                                                   this.applyValue(_loc3_,_loc3_.tweenValue,false);
                                                }
                                                if(_loc3_.repeat != 0)
                                                {
                                                   if(_loc3_.repeat == -1)
                                                   {
                                                      _loc5_.repeat = 2147483647;
                                                   }
                                                   else
                                                   {
                                                      _loc5_.repeat = _loc3_.repeat;
                                                   }
                                                }
                                                if(_loc3_.yoyo)
                                                {
                                                   _loc5_.yoyo = _loc3_.yoyo;
                                                }
                                                _loc3_.tweener = TweenMax.to(_loc3_.tweenValue,_loc4_,_loc5_);
                                             }
                                          }
                                          else
                                          {
                                             _loc3_.tweenValue.color = _loc3_.value.color;
                                             _loc5_ = {
                                                "hexColors":{"color":_loc3_.nextItem.value.color},
                                                "ease":_loc3_.ease,
                                                "onUpdate":this.__tweenUpdate,
                                                "onUpdateParams":[_loc3_],
                                                "onComplete":this.__tweenComplete,
                                                "onCompleteParams":[_loc3_]
                                             };
                                             if(_loc6_ != 0)
                                             {
                                                _loc5_.delay = _loc6_;
                                             }
                                             else
                                             {
                                                this.applyValue(_loc3_,_loc3_.tweenValue,false);
                                             }
                                             if(_loc3_.repeat != 0)
                                             {
                                                if(_loc3_.repeat == -1)
                                                {
                                                   _loc5_.repeat = 2147483647;
                                                }
                                                else
                                                {
                                                   _loc5_.repeat = _loc3_.repeat;
                                                }
                                             }
                                             if(_loc3_.yoyo)
                                             {
                                                _loc5_.yoyo = _loc3_.yoyo;
                                             }
                                             _loc3_.tweener = TweenMax.to(_loc3_.tweenValue,_loc4_,_loc5_);
                                          }
                                       }
                                       else
                                       {
                                          _loc3_.tweenValue.rotation = _loc3_.value.rotation;
                                          _loc5_ = {
                                             "rotation":_loc3_.nextItem.value.rotation,
                                             "ease":_loc3_.ease,
                                             "onUpdate":this.__tweenUpdate,
                                             "onUpdateParams":[_loc3_],
                                             "onComplete":this.__tweenComplete,
                                             "onCompleteParams":[_loc3_]
                                          };
                                          if(_loc6_ != 0)
                                          {
                                             _loc5_.delay = _loc6_;
                                          }
                                          else
                                          {
                                             this.applyValue(_loc3_,_loc3_.tweenValue,false);
                                          }
                                          if(_loc3_.repeat != 0)
                                          {
                                             if(_loc3_.repeat == -1)
                                             {
                                                _loc5_.repeat = 2147483647;
                                             }
                                             else
                                             {
                                                _loc5_.repeat = _loc3_.repeat;
                                             }
                                          }
                                          if(_loc3_.yoyo)
                                          {
                                             _loc5_.yoyo = _loc3_.yoyo;
                                          }
                                          _loc3_.tweener = TweenMax.to(_loc3_.tweenValue,_loc4_,_loc5_);
                                       }
                                    }
                                    else
                                    {
                                       _loc3_.tweenValue.alpha = _loc3_.value.alpha;
                                       _loc5_ = {
                                          "alpha":_loc3_.nextItem.value.alpha,
                                          "ease":_loc3_.ease,
                                          "onUpdate":this.__tweenUpdate,
                                          "onUpdateParams":[_loc3_],
                                          "onComplete":this.__tweenComplete,
                                          "onCompleteParams":[_loc3_]
                                       };
                                       if(_loc6_ != 0)
                                       {
                                          _loc5_.delay = _loc6_;
                                       }
                                       else
                                       {
                                          this.applyValue(_loc3_,_loc3_.tweenValue,false);
                                       }
                                       if(_loc3_.repeat != 0)
                                       {
                                          if(_loc3_.repeat == -1)
                                          {
                                             _loc5_.repeat = 2147483647;
                                          }
                                          else
                                          {
                                             _loc5_.repeat = _loc3_.repeat;
                                          }
                                       }
                                       if(_loc3_.yoyo)
                                       {
                                          _loc5_.yoyo = _loc3_.yoyo;
                                       }
                                       _loc3_.tweener = TweenMax.to(_loc3_.tweenValue,_loc4_,_loc5_);
                                    }
                                 }
                              }
                              _loc3_.tweenValue.a = _loc3_.value.a;
                              _loc3_.tweenValue.b = _loc3_.value.b;
                              _loc5_ = {
                                 "a":_loc3_.nextItem.value.a,
                                 "b":_loc3_.nextItem.value.b,
                                 "ease":_loc3_.ease,
                                 "onUpdate":this.__tweenUpdate,
                                 "onUpdateParams":[_loc3_],
                                 "onComplete":this.__tweenComplete,
                                 "onCompleteParams":[_loc3_]
                              };
                              if(_loc6_ != 0)
                              {
                                 _loc5_.delay = _loc6_;
                              }
                              else
                              {
                                 this.applyValue(_loc3_,_loc3_.tweenValue,false);
                              }
                              if(_loc3_.repeat != 0)
                              {
                                 if(_loc3_.repeat == -1)
                                 {
                                    _loc5_.repeat = 2147483647;
                                 }
                                 else
                                 {
                                    _loc5_.repeat = _loc3_.repeat;
                                 }
                              }
                              if(_loc3_.yoyo)
                              {
                                 _loc5_.yoyo = _loc3_.yoyo;
                              }
                              _loc3_.tweener = TweenMax.to(_loc3_.tweenValue,_loc4_,_loc5_);
                           }
                        }
                        addr113:
                        if(_loc6_ == 0)
                        {
                           this.delayCall2(_loc3_);
                        }
                        else
                        {
                           _loc3_.tweener = TweenMax.delayedCall(_loc6_,this.delayCall2,[_loc3_]);
                        }
                     }
                     §§goto(addr113);
                  }
               }
               else if(_loc3_.prevItem == null)
               {
                  if(_loc6_ == 0)
                  {
                     this.applyValue(_loc3_,_loc3_.value,false);
                  }
                  else
                  {
                     _loc3_.completed = false;
                     this._totalTasks++;
                     _loc3_.tweener = TweenMax.delayedCall(_loc6_,this.delayCall,[_loc3_]);
                  }
                  continue;
               }
               continue;
            }
         }
      }
      
      public function stop(param1:Boolean = false) : void
      {
         var _loc9_:Function = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:ETransitionItem = null;
         var _loc6_:EGObject = null;
         var _loc5_:EGComponent = null;
         var _loc4_:ETransition = null;
         if(this._playing)
         {
            this._playing = false;
            this._totalTasks = 0;
            this._totalTimes = 0;
            _loc9_ = this._onComplete;
            _loc7_ = this._onCompleteParam;
            this._onComplete = null;
            this._onCompleteParam = null;
            _loc8_ = this._items.length;
            _loc2_ = 0;
            while(_loc2_ < _loc8_)
            {
               _loc3_ = this._items[_loc2_];
               if(_loc3_.valid)
               {
                  if(_loc3_.targetId)
                  {
                     _loc6_ = this.owner.getChildById(_loc3_.targetId);
                     if(_loc3_.displayLockToken != 0)
                     {
                        _loc6_.releaseDisplayLock(_loc3_.displayLockToken);
                        _loc3_.displayLockToken = 0;
                     }
                  }
                  else
                  {
                     _loc6_ = this.owner;
                  }
                  if(!_loc3_.completed)
                  {
                     if(_loc3_.type == "Transition")
                     {
                        _loc5_ = EGComponent(_loc6_);
                        _loc4_ = _loc5_.transitions.getItem(_loc3_.value.transName);
                        if(_loc4_ != null)
                        {
                           _loc4_.stop(false);
                        }
                     }
                     else if(_loc3_.type == "Shake")
                     {
                        GTimers.inst.remove(_loc3_.__shake);
                        _loc6_.gearLocked = true;
                        _loc6_.setXY(_loc6_.x - _loc3_.value.c,_loc6_.y - _loc3_.value.d);
                        _loc6_.gearLocked = false;
                     }
                     else if(_loc3_.prevItem == null)
                     {
                        if(_loc3_.tweener != null)
                        {
                           _loc3_.tweener.kill();
                           _loc3_.tweener = null;
                        }
                        if(_loc3_.tween && _loc3_.nextItem != null && (!_loc3_.yoyo || _loc3_.repeat % 2 == 0))
                        {
                           this.applyValue(_loc3_,_loc3_.nextItem.value,false);
                        }
                        else if(_loc3_.type != "Sound")
                        {
                           this.applyValue(_loc3_,_loc3_.value,false);
                        }
                     }
                  }
               }
               _loc2_++;
            }
            if(param1 && _loc9_ != null)
            {
               if(_loc9_.length > 0)
               {
                  _loc9_(_loc7_);
               }
               else
               {
                  _loc9_();
               }
            }
         }
      }
      
      private function delayCall(param1:ETransitionItem) : void
      {
         param1.tweener = null;
         param1.completed = true;
         this._totalTasks--;
         this.applyValue(param1,param1.value,false);
         this.checkAllComplete();
      }
      
      public function __shake(param1:ETransitionItem) : void
      {
         var _loc2_:EGObject = null;
         var _loc6_:Number = Math.ceil(param1.value.shakeAmplitude * param1.value.b / param1.value.shakePeriod);
         var _loc4_:Number = (Math.random() * 2 - 1) * _loc6_;
         var _loc5_:Number = (Math.random() * 2 - 1) * _loc6_;
         _loc4_ = _loc4_ > 0?Number(Math.ceil(_loc4_)):Number(Math.floor(_loc4_));
         _loc5_ = _loc5_ > 0?Number(Math.ceil(_loc5_)):Number(Math.floor(_loc5_));
         if(param1.targetId)
         {
            _loc2_ = this.owner.getChildById(param1.targetId);
         }
         else
         {
            _loc2_ = this.owner;
         }
         if(_loc2_ != null)
         {
            _loc2_.gearLocked = true;
            _loc2_.setXY(_loc2_.x - param1.value.c + _loc4_,_loc2_.y - param1.value.d + _loc5_);
            _loc2_.gearLocked = false;
            param1.value.c = _loc4_;
            param1.value.d = _loc5_;
         }
         var _loc3_:int = getTimer();
         param1.value.b = param1.value.b - (_loc3_ - param1.value.a) / 1000;
         param1.value.a = _loc3_;
         if(param1.value.b <= 0)
         {
            if(_loc2_ != null)
            {
               _loc2_.gearLocked = true;
               _loc2_.setXY(_loc2_.x - param1.value.c,_loc2_.y - param1.value.d);
               _loc2_.gearLocked = false;
            }
            param1.completed = true;
            this._totalTasks--;
            GTimers.inst.remove(param1.__shake);
            this.checkAllComplete();
         }
      }
      
      private function delayCall2(param1:ETransitionItem) : void
      {
         var _loc4_:EGObject = null;
         if(param1.targetId)
         {
            _loc4_ = this.owner.getChildById(param1.targetId);
         }
         else
         {
            _loc4_ = this.owner;
         }
         if(param1.type == "XY" || param1.type == "XYV")
         {
            param1.tweenValue.a = !!param1.value.aEnabled?Number(param1.value.a):Number(_loc4_.x);
            param1.tweenValue.b = !!param1.value.bEnabled?Number(param1.value.b):Number(_loc4_.y);
         }
         else
         {
            param1.tweenValue.a = !!param1.value.aEnabled?Number(param1.value.a):Number(_loc4_.width);
            param1.tweenValue.b = !!param1.value.bEnabled?Number(param1.value.b):Number(_loc4_.height);
         }
         var _loc2_:Object = {
            "ease":param1.ease,
            "onUpdate":this.__tweenUpdate,
            "onUpdateParams":[param1],
            "onComplete":this.__tweenComplete,
            "onCompleteParams":[param1]
         };
         _loc2_.a = !!param1.nextItem.value.aEnabled?param1.nextItem.value.a:param1.tweenValue.a;
         _loc2_.b = !!param1.nextItem.value.bEnabled?param1.nextItem.value.b:param1.tweenValue.b;
         if(param1.throughPoints.length > 0)
         {
            _loc2_.bezierThrough = param1.throughPoints.concat([{
               "a":_loc2_.a,
               "b":_loc2_.b
            }]);
         }
         if(param1.repeat != 0)
         {
            if(param1.repeat == -1)
            {
               _loc2_.repeat = 2147483647;
            }
            else
            {
               _loc2_.repeat = param1.repeat;
            }
         }
         if(param1.yoyo)
         {
            _loc2_.yoyo = param1.yoyo;
         }
         var _loc3_:Number = (param1.nextItem.frame - param1.frame) / 24;
         this.applyValue(param1,param1.tweenValue,false);
         param1.tweener = TweenMax.to(param1.tweenValue,_loc3_,_loc2_);
      }
      
      private function __tweenUpdate(param1:ETransitionItem) : void
      {
         this.applyValue(param1,param1.tweenValue,true);
      }
      
      private function __tweenComplete(param1:ETransitionItem) : void
      {
         param1.tweener = null;
         param1.completed = true;
         this._totalTasks--;
         this.checkAllComplete();
      }
      
      private function checkAllComplete() : void
      {
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:ETransitionItem = null;
         var _loc4_:EGObject = null;
         var _loc1_:Function = null;
         var _loc2_:Object = null;
         if(this._playing && this._totalTasks == 0)
         {
            if(this._totalTimes < 0)
            {
               this.internalPlay();
            }
            else
            {
               this._totalTimes--;
               if(this._totalTimes > 0)
               {
                  this.internalPlay();
               }
               else
               {
                  this._playing = false;
                  if(this.owner.editMode == 1)
                  {
                     if(this._options & 1)
                     {
                        _loc6_ = this._items.length;
                        _loc5_ = 0;
                        while(_loc5_ < _loc6_)
                        {
                           _loc3_ = this._items[_loc5_];
                           if(_loc3_.displayLockToken != 0)
                           {
                              if(_loc3_.valid)
                              {
                                 if(_loc3_.targetId)
                                 {
                                    _loc4_ = this.owner.getChildById(_loc3_.targetId);
                                    if(_loc4_)
                                    {
                                       _loc4_.releaseDisplayLock(_loc3_.displayLockToken);
                                    }
                                 }
                              }
                              _loc3_.displayLockToken = 0;
                           }
                           _loc5_++;
                        }
                     }
                  }
                  if(this._onComplete != null)
                  {
                     _loc1_ = this._onComplete;
                     _loc2_ = this._onCompleteParam;
                     this._onComplete = null;
                     this._onCompleteParam = null;
                     if(_loc1_.length > 0)
                     {
                        _loc1_(_loc2_);
                     }
                     else
                     {
                        _loc1_();
                     }
                  }
               }
            }
         }
      }
   }
}

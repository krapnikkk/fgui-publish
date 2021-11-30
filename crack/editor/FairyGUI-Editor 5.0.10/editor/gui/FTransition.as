package fairygui.editor.gui
{
   import fairygui.ObjectPropID;
   import fairygui.tween.EaseType;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   
   public class FTransition
   {
      
      public static const OPTION_IGNORE_DISPLAY_CONTROLLER:int = 1;
      
      public static const OPTION_AUTO_STOP_DISABLED:int = 2;
      
      public static const OPTION_AUTO_STOP_AT_END:int = 4;
       
      
      private var _owner:FComponent;
      
      private var _name:String;
      
      private var _options:int;
      
      private var _items:Vector.<FTransitionItem>;
      
      private var _ownerBaseX:Number;
      
      private var _ownerBaseY:Number;
      
      private var _autoPlay:Boolean;
      
      private var _autoPlayRepeat:int;
      
      private var _autoPlayDelay:Number;
      
      private var _editing:Boolean;
      
      private var _frameRate:int;
      
      private var _maxFrame:int;
      
      var _orderDirty:Boolean;
      
      private var _totalTimes:int;
      
      private var _totalTasks:int;
      
      private var _playing:Boolean;
      
      private var _startFrame:Number;
      
      private var _endFrame:Number;
      
      private var _elapsedFrame:Number;
      
      private var _onComplete:Function;
      
      private var _onCompleteParam:Object;
      
      public function FTransition(param1:FComponent)
      {
         super();
         this._owner = param1;
         this._items = new Vector.<FTransitionItem>();
         this._ownerBaseX = 0;
         this._ownerBaseY = 0;
         this._autoPlayRepeat = 1;
         this._autoPlayDelay = 0;
         this._frameRate = 24;
      }
      
      public static function getAllowType(param1:FObject, param2:String) : Boolean
      {
         var _loc3_:* = param1 is FGroup;
         var _loc4_:Boolean = _loc3_ && !FGroup(param1).advanced;
         switch(param2)
         {
            case "XY":
            case "Alpha":
            case "Visible":
               return !_loc4_;
            case "Color":
               return !_loc3_;
            case "Animation":
               return param1 is FMovieClip || param1 is FSwfObject;
            case "Transition":
               return param1 is FComponent && !(param1 is FList);
            default:
               return !_loc3_;
         }
      }
      
      public static function supportTween(param1:String) : Boolean
      {
         return param1 == "XY" || param1 == "Size" || param1 == "Scale" || param1 == "Skew" || param1 == "Alpha" || param1 == "Rotation" || param1 == "Color" || param1 == "ColorFilter";
      }
      
      public function get owner() : FComponent
      {
         return this._owner;
      }
      
      public function set owner(param1:FComponent) : void
      {
         this._owner = param1;
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
      
      public function get frameRate() : int
      {
         return this._frameRate;
      }
      
      public function set frameRate(param1:int) : void
      {
         this._frameRate = param1;
      }
      
      public function dispose() : void
      {
      }
      
      public function get items() : Vector.<FTransitionItem>
      {
         if(this._orderDirty)
         {
            this.arrangeItems();
         }
         return this._items;
      }
      
      public function get maxFrame() : int
      {
         if(this._orderDirty)
         {
            this.arrangeItems();
         }
         return this._maxFrame;
      }
      
      private function arrangeItems() : void
      {
         var _loc3_:FTransitionItem = null;
         var _loc4_:int = 0;
         var _loc5_:FTransitionItem = null;
         this._orderDirty = false;
         this._items.sort(this.__compareItem);
         var _loc1_:int = this._items.length;
         if(_loc1_ > 0)
         {
            this._maxFrame = this._items[_loc1_ - 1].frame;
         }
         else
         {
            this._maxFrame = 0;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._items[_loc2_];
            if(_loc3_.nextItem)
            {
               _loc3_.nextItem.prevItem = null;
               _loc3_.nextItem = null;
            }
            if(_loc3_.tween)
            {
               _loc4_ = _loc2_ + 1;
               while(_loc4_ < _loc1_)
               {
                  _loc5_ = this._items[_loc4_];
                  if(_loc5_.targetId == _loc3_.targetId && _loc5_.type == _loc3_.type)
                  {
                     _loc3_.nextItem = _loc5_;
                     _loc5_.prevItem = _loc3_;
                     break;
                  }
                  _loc4_++;
               }
            }
            _loc2_++;
         }
      }
      
      private function __compareItem(param1:FTransitionItem, param2:FTransitionItem) : int
      {
         var _loc3_:int = 0;
         if(param1.frame == param2.frame)
         {
            _loc3_ = param1.type.localeCompare(param2.type);
            if(_loc3_ != 0)
            {
               if(param1.type == "Pivot")
               {
                  return -1;
               }
               if(param2.type == "Pivot")
               {
                  return 1;
               }
               return _loc3_;
            }
            return param1.targetId.localeCompare(param2.targetId);
         }
         return param1.frame - param2.frame;
      }
      
      public function createItem(param1:String, param2:String, param3:int) : FTransitionItem
      {
         if(param1 == null)
         {
            param1 = "";
         }
         var _loc4_:FTransitionItem = new FTransitionItem(this);
         _loc4_.targetId = param1;
         _loc4_.type = param2;
         _loc4_.frame = param3;
         this.udpateValueFromTarget(_loc4_);
         this._items.push(_loc4_);
         this._orderDirty = true;
         return _loc4_;
      }
      
      private function udpateValueFromTarget(param1:FTransitionItem) : void
      {
         var _loc3_:FObject = null;
         var _loc2_:FTransitionValue = param1.value;
         if(param1.targetId)
         {
            _loc3_ = this._owner.getChildById(param1.targetId);
         }
         else
         {
            _loc3_ = this._owner;
         }
         switch(param1.type)
         {
            case "XY":
               _loc2_.f1 = _loc3_.x;
               _loc2_.f2 = _loc3_.y;
               _loc2_.f3 = _loc3_.x / this._owner.width;
               _loc2_.f4 = _loc3_.y / this._owner.height;
               _loc2_.b3 = false;
               break;
            case "Size":
               _loc2_.f1 = _loc3_.width;
               _loc2_.f2 = _loc3_.height;
               break;
            case "Pivot":
               _loc2_.f1 = _loc3_.pivotX;
               _loc2_.f2 = _loc3_.pivotY;
               break;
            case "Alpha":
               _loc2_.f1 = _loc3_.alpha;
               break;
            case "Rotation":
               _loc2_.f1 = _loc3_.rotation;
               break;
            case "Scale":
               _loc2_.f1 = _loc3_.scaleX;
               _loc2_.f2 = _loc3_.scaleY;
               break;
            case "Skew":
               _loc2_.f1 = _loc3_.skewX;
               _loc2_.f2 = _loc3_.skewY;
               break;
            case "Color":
               _loc2_.iu = _loc3_.getProp(ObjectPropID.Color);
               break;
            case "Animation":
               _loc2_.i = _loc3_.getProp(ObjectPropID.Frame);
               _loc2_.b2 = _loc3_.getProp(ObjectPropID.Playing);
               break;
            case "Sound":
               _loc2_.s = "";
               _loc2_.i = 0;
               break;
            case "Controller":
               break;
            case "Transition":
               _loc2_.i = 1;
               _loc2_.s = "";
               break;
            case "Shake":
               _loc2_.f1 = 3;
               _loc2_.f2 = 0.5;
               break;
            case "Visible":
               _loc2_.b1 = _loc3_.visible;
               break;
            case "ColorFilter":
               _loc2_.f1 = _loc3_.filterData.brightness;
               _loc2_.f2 = _loc3_.filterData.contrast;
               _loc2_.f3 = _loc3_.filterData.saturation;
               _loc2_.f4 = _loc3_.filterData.hue;
               break;
            case "Text":
               _loc2_.s = _loc3_.text;
               break;
            case "Icon":
               _loc2_.s = _loc3_.icon;
         }
      }
      
      public function findItem(param1:int, param2:String, param3:String) : FTransitionItem
      {
         return this.findItem2(param1,param2,param3,this._items);
      }
      
      public function findItem2(param1:int, param2:String, param3:String, param4:Vector.<FTransitionItem>) : FTransitionItem
      {
         var _loc7_:FTransitionItem = null;
         var _loc5_:int = param4.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param4[_loc6_];
            if((param3 == null || _loc7_.type == param3) && _loc7_.targetId == param2 && _loc7_.frame == param1)
            {
               return _loc7_;
            }
            _loc6_++;
         }
         return null;
      }
      
      public function getItemWithPath(param1:int, param2:String) : FTransitionItem
      {
         var _loc6_:FTransitionItem = null;
         var _loc3_:Vector.<FTransitionItem> = this.items;
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.usePath && _loc6_.tween && _loc6_.targetId == param2 && param1 >= _loc6_.frame && _loc6_.nextItem && param1 < _loc6_.nextItem.frame)
            {
               return _loc6_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function addItem(param1:FTransitionItem) : void
      {
         this._items.push(param1);
         this._orderDirty = true;
      }
      
      public function addItems(param1:Array) : void
      {
         var _loc2_:FTransitionItem = null;
         for each(_loc2_ in param1)
         {
            this._items.push(_loc2_);
         }
         this._orderDirty = true;
      }
      
      public function deleteItem(param1:FTransitionItem) : void
      {
         var _loc2_:int = this._items.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._items.splice(_loc2_,1);
            if(param1.target != null && param1.displayLockToken != 0)
            {
               param1.target.releaseDisplayLock(param1.displayLockToken);
               param1.displayLockToken = 0;
            }
            this._orderDirty = true;
         }
      }
      
      public function deleteItems(param1:String, param2:String) : Array
      {
         var _loc6_:FTransitionItem = null;
         var _loc3_:Array = [];
         var _loc4_:int = this._items.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this._items[_loc5_];
            if(_loc6_.type == param2 && _loc6_.targetId == param1)
            {
               this._items.splice(_loc5_,1);
               _loc3_.push(_loc6_);
               _loc4_--;
               if(_loc6_.target != null && _loc6_.displayLockToken != 0)
               {
                  _loc6_.target.releaseDisplayLock(_loc6_.displayLockToken);
                  _loc6_.displayLockToken = 0;
               }
            }
            else
            {
               _loc5_++;
            }
         }
         this._orderDirty = true;
         return _loc3_;
      }
      
      public function copyItems(param1:String, param2:String) : XData
      {
         var _loc7_:FTransitionItem = null;
         var _loc3_:int = this._items.length;
         var _loc4_:Vector.<FTransitionItem> = new Vector.<FTransitionItem>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc7_ = this._items[_loc5_];
            if(_loc7_.type == param2 && _loc7_.targetId == param1)
            {
               _loc4_.push(_loc7_);
            }
            _loc5_++;
         }
         var _loc6_:XData = XData.create("transition");
         this.writeItems(_loc4_,_loc6_,false);
         return _loc6_;
      }
      
      public function pasteItems(param1:XData, param2:String, param3:String) : void
      {
         var _loc7_:FTransitionItem = null;
         var _loc4_:int = this._items.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = this._items[_loc5_];
            if(_loc7_.type == param3 && _loc7_.targetId == param2)
            {
               this._items.splice(_loc5_,1);
               _loc4_--;
               if(_loc7_.target != null && _loc7_.displayLockToken != 0)
               {
                  _loc7_.target.releaseDisplayLock(_loc7_.displayLockToken);
                  _loc7_.displayLockToken = 0;
               }
            }
            else
            {
               _loc5_++;
            }
         }
         var _loc6_:XDataEnumerator = param1.getEnumerator("item");
         while(_loc6_.moveNext())
         {
            _loc6_.current.setAttribute("target",param2);
            _loc6_.current.setAttribute("type",param3);
         }
         this.readItems(param1);
         this._orderDirty = true;
      }
      
      public function updateFromRelations(param1:String, param2:Number, param3:Number) : void
      {
         var _loc6_:FTransitionItem = null;
         var _loc4_:int = this._items.length;
         if(_loc4_ == 0)
         {
            return;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this._items[_loc5_];
            if(_loc6_.type == "XY" && _loc6_.targetId == param1 && !_loc6_.value.b3)
            {
               _loc6_.value.f1 = _loc6_.value.f1 + param2;
               _loc6_.value.f2 = _loc6_.value.f2 + param3;
            }
            _loc5_++;
         }
      }
      
      public function validate() : void
      {
         var _loc3_:FTransitionItem = null;
         var _loc4_:FTransition = null;
         var _loc5_:int = 0;
         var _loc6_:FTransitionItem = null;
         var _loc1_:int = this._items.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._items[_loc2_];
            if(_loc3_.targetId)
            {
               _loc3_.target = this._owner.getChildById(_loc3_.targetId);
            }
            else
            {
               _loc3_.target = this._owner;
            }
            if(_loc3_.target != null && !getAllowType(_loc3_.target,_loc3_.type))
            {
               _loc3_.target = null;
            }
            if(_loc3_.target != null && _loc3_.type == "Transition")
            {
               _loc4_ = FComponent(_loc3_.target).transitions.getItem(_loc3_.value.s);
               if(_loc4_ == this)
               {
                  _loc4_ = null;
               }
               if(_loc4_ != null)
               {
                  if(_loc3_.value.i == 0)
                  {
                     _loc5_ = _loc2_ - 1;
                     while(_loc5_ >= 0)
                     {
                        _loc6_ = this._items[_loc5_];
                        if(_loc6_.type == "Transition")
                        {
                           if(_loc6_.innerTrans == _loc4_)
                           {
                              _loc6_.value.f1 = _loc3_.frame - _loc6_.frame;
                              break;
                           }
                        }
                        _loc5_--;
                     }
                     if(_loc5_ < 0)
                     {
                        _loc3_.value.f1 = 0;
                     }
                     else
                     {
                        _loc4_ = null;
                     }
                  }
                  else
                  {
                     _loc3_.value.f1 = -1;
                  }
               }
               _loc3_.innerTrans = _loc4_;
            }
            _loc2_++;
         }
      }
      
      private function readItems(param1:XData) : void
      {
         var _loc6_:String = null;
         var _loc8_:XData = null;
         var _loc9_:FTransitionItem = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:FTransitionItem = null;
         var _loc2_:Vector.<FTransitionItem> = new Vector.<FTransitionItem>();
         var _loc3_:XDataEnumerator = param1.getEnumerator("item");
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc3_.moveNext())
         {
            _loc8_ = _loc3_.current;
            _loc9_ = new FTransitionItem(this);
            _loc2_.push(_loc9_);
            _loc10_ = {};
            _loc4_[_loc13_] = _loc10_;
            _loc10_.duration = _loc8_.getAttributeInt("duration");
            _loc9_.frame = _loc8_.getAttributeInt("time");
            _loc9_.type = _loc8_.getAttribute("type");
            _loc9_.targetId = _loc8_.getAttribute("target","");
            _loc9_.tween = _loc8_.getAttributeBool("tween");
            _loc9_.repeat = _loc8_.getAttributeInt("repeat");
            _loc9_.yoyo = _loc8_.getAttributeBool("yoyo");
            _loc9_.label = _loc8_.getAttribute("label");
            _loc10_.label2 = _loc8_.getAttribute("label2");
            _loc6_ = _loc8_.getAttribute("ease");
            if(_loc6_)
            {
               _loc11_ = _loc6_.indexOf(".");
               if(_loc11_ != -1)
               {
                  _loc9_.easeType = _loc6_.substr(0,_loc11_);
                  _loc9_.easeInOutType = _loc6_.substr(_loc11_ + 1);
               }
               else
               {
                  _loc9_.easeType = _loc6_;
               }
            }
            _loc6_ = _loc8_.getAttribute("startValue");
            if(_loc6_)
            {
               _loc9_.value.decode(_loc9_.type,_loc6_);
            }
            else
            {
               _loc6_ = _loc8_.getAttribute("value");
               if(_loc6_)
               {
                  _loc9_.value.decode(_loc9_.type,_loc6_);
               }
            }
            _loc6_ = _loc8_.getAttribute("endValue");
            if(_loc6_)
            {
               _loc10_.endValue = new FTransitionValue();
               _loc10_.endValue.decode(_loc9_.type,_loc6_);
            }
            _loc6_ = _loc8_.getAttribute("path");
            if(_loc6_)
            {
               _loc9_.pathData = _loc6_;
            }
         }
         var _loc7_:int = _loc2_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc7_)
         {
            _loc9_ = _loc2_[_loc5_];
            _loc10_ = _loc4_[_loc5_];
            if(_loc9_.tween && _loc10_.duration > 0)
            {
               _loc12_ = this.findItem2(_loc9_.frame + _loc10_.duration,_loc9_.targetId,_loc9_.type,_loc2_);
               if(_loc12_ == null)
               {
                  _loc12_ = new FTransitionItem(this);
                  _loc12_.frame = _loc9_.frame + _loc10_.duration;
                  _loc12_.type = _loc9_.type;
                  _loc12_.targetId = _loc9_.targetId;
                  _loc12_.value.copyFrom(_loc10_.endValue);
                  _loc12_.tween = false;
                  _loc12_.label = _loc10_.label2;
                  _loc2_.push(_loc12_);
               }
               _loc9_.nextItem = _loc12_;
               _loc12_.prevItem = _loc9_;
            }
            _loc5_++;
         }
         for each(_loc9_ in _loc2_)
         {
            this._items.push(_loc9_);
         }
      }
      
      public function writeItems(param1:Vector.<FTransitionItem>, param2:XData, param3:Boolean) : void
      {
         var _loc5_:FTransitionItem = null;
         var _loc7_:XData = null;
         var _loc8_:String = null;
         var _loc4_:int = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = param1[_loc6_];
            if(!(_loc5_.prevItem && !_loc5_.tween))
            {
               if(!(param3 && !_loc5_.target))
               {
                  _loc7_ = XData.create("item");
                  _loc7_.setAttribute("time",_loc5_.frame);
                  _loc7_.setAttribute("type",_loc5_.type);
                  if(_loc5_.targetId)
                  {
                     _loc7_.setAttribute("target",_loc5_.targetId);
                  }
                  if(_loc5_.label)
                  {
                     _loc7_.setAttribute("label",_loc5_.label);
                  }
                  if(_loc5_.tween && _loc5_.nextItem)
                  {
                     _loc7_.setAttribute("tween",_loc5_.tween);
                     _loc7_.setAttribute("startValue",_loc5_.value.encode(_loc5_.type));
                     _loc7_.setAttribute("endValue",_loc5_.nextItem.value.encode(_loc5_.type));
                     _loc7_.setAttribute("duration",_loc5_.nextItem.frame - _loc5_.frame);
                     if(_loc5_.nextItem.label)
                     {
                        _loc7_.setAttribute("label2",_loc5_.nextItem.label);
                     }
                     _loc8_ = _loc5_.easeName;
                     if(_loc8_ != "Quad.Out")
                     {
                        _loc7_.setAttribute("ease",_loc8_);
                     }
                     if(_loc5_.repeat != 0)
                     {
                        _loc7_.setAttribute("repeat",_loc5_.repeat);
                     }
                     if(_loc5_.yoyo)
                     {
                        _loc7_.setAttribute("yoyo",_loc5_.yoyo);
                     }
                     if(_loc5_.usePath)
                     {
                        _loc7_.setAttribute("path",_loc5_.pathData);
                     }
                  }
                  else
                  {
                     _loc7_.setAttribute("value",_loc5_.value.encode(_loc5_.type));
                  }
                  param2.appendChild(_loc7_);
               }
            }
            _loc6_++;
         }
      }
      
      public function read(param1:XData) : void
      {
         this._name = param1.getAttribute("name");
         this._options = param1.getAttributeInt("options");
         this._autoPlay = param1.getAttributeBool("autoPlay");
         this._autoPlayRepeat = param1.getAttributeInt("autoPlayRepeat",1);
         this._autoPlayDelay = param1.getAttributeFloat("autoPlayDelay");
         this._frameRate = param1.getAttributeInt("frameRate",24);
         this._items.length = 0;
         this._orderDirty = true;
         this.readItems(param1);
      }
      
      public function write(param1:Boolean) : XData
      {
         this.validate();
         var _loc2_:XData = XData.create("transition");
         _loc2_.setAttribute("name",this._name);
         if(this._options != 0)
         {
            _loc2_.setAttribute("options",this._options);
         }
         if(this._autoPlay)
         {
            _loc2_.setAttribute("autoPlay",this._autoPlay);
         }
         if(this._autoPlayRepeat != 1)
         {
            _loc2_.setAttribute("autoPlayRepeat",this._autoPlayRepeat);
         }
         if(this._autoPlayDelay != 0)
         {
            _loc2_.setAttribute("autoPlayDelay",this._autoPlayDelay.toFixed(3));
         }
         if(this._frameRate != 24)
         {
            _loc2_.setAttribute("frameRate",this._frameRate);
         }
         this.writeItems(this._items,_loc2_,param1);
         return _loc2_;
      }
      
      public function onExit() : void
      {
         var _loc3_:FTransitionItem = null;
         var _loc1_:int = this._items.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._items[_loc2_];
            if(_loc3_.target != null && _loc3_.displayLockToken != 0)
            {
               _loc3_.target.releaseDisplayLock(_loc3_.displayLockToken);
               _loc3_.displayLockToken = 0;
            }
            _loc2_++;
         }
      }
      
      public function get playing() : Boolean
      {
         return this._playing;
      }
      
      public function set playTimes(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = int.MAX_VALUE;
         }
         else if(param1 == 0)
         {
            param1 = 1;
         }
         this._totalTimes = param1;
      }
      
      public function get playTimes() : int
      {
         return this._totalTimes;
      }
      
      public function play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:int = 0, param6:int = -1, param7:Boolean = false) : void
      {
         if(this._orderDirty)
         {
            this.arrangeItems();
         }
         this.stop();
         this.validate();
         this._editing = param7;
         this._totalTimes = param3;
         this._startFrame = param5;
         this._endFrame = param6;
         this._playing = true;
         this._elapsedFrame = 0;
         this._onComplete = param1;
         this._onCompleteParam = param2;
         if(param4 == 0)
         {
            this.onDelayedPlay();
         }
         else
         {
            GTween.delayedCall(param4).onComplete(this.onDelayedPlay);
         }
      }
      
      public function stop(param1:Boolean = true, param2:Boolean = false) : void
      {
         var _loc7_:FTransitionItem = null;
         if(!this._playing)
         {
            return;
         }
         this._playing = false;
         this._totalTasks = 0;
         this._totalTimes = 0;
         var _loc3_:Function = this._onComplete;
         var _loc4_:Object = this._onCompleteParam;
         this._onComplete = null;
         this._onCompleteParam = null;
         GTween.kill(this);
         var _loc5_:int = this._items.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._items[_loc6_];
            if(_loc7_.target)
            {
               if(_loc7_.displayLockToken != 0)
               {
                  _loc7_.target.releaseDisplayLock(_loc7_.displayLockToken);
                  _loc7_.displayLockToken = 0;
               }
               if(_loc7_.tweener != null)
               {
                  _loc7_.tweener.kill(param1);
                  _loc7_.tweener = null;
                  if(_loc7_.type == "Shake" && !param1)
                  {
                     _loc7_.target._gearLocked = true;
                     _loc7_.target.setXY(_loc7_.target.x - _loc7_.tweenValue.f1,_loc7_.target.y - _loc7_.tweenValue.f2);
                     _loc7_.target._gearLocked = false;
                  }
               }
               if(_loc7_.innerTrans != null)
               {
                  _loc7_.innerTrans.stop(param1,false);
               }
            }
            _loc6_++;
         }
         if(param2 && _loc3_ != null)
         {
            if(_loc3_.length > 0)
            {
               _loc3_(_loc4_);
            }
            else
            {
               _loc3_();
            }
         }
      }
      
      private function onDelayedPlay() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:FTransitionItem = null;
         var _loc4_:Function = null;
         var _loc5_:Object = null;
         this.internalPlay();
         this._playing = this._totalTasks > 0;
         if(this._playing)
         {
            _loc1_ = this._items.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._items[_loc2_];
               if(_loc3_.target != null && _loc3_.target != this._owner)
               {
                  if(_loc3_.displayLockToken != 0)
                  {
                     _loc3_.target.releaseDisplayLock(_loc3_.displayLockToken);
                     _loc3_.displayLockToken = 0;
                  }
                  if((this._options & OPTION_IGNORE_DISPLAY_CONTROLLER) != 0)
                  {
                     _loc3_.displayLockToken = _loc3_.target.addDisplayLock();
                  }
               }
               _loc2_++;
            }
         }
         else if(this._onComplete != null)
         {
            _loc4_ = this._onComplete;
            _loc5_ = this._onCompleteParam;
            this._onComplete = null;
            this._onCompleteParam = null;
            if(_loc4_.length > 0)
            {
               _loc4_(_loc5_);
            }
            else
            {
               _loc4_();
            }
         }
      }
      
      private function internalPlay() : void
      {
         var _loc4_:FTransitionItem = null;
         var _loc5_:Number = NaN;
         this._ownerBaseX = this._owner.x;
         this._ownerBaseY = this._owner.y;
         this._totalTasks = 0;
         this._elapsedFrame = 0;
         var _loc1_:Boolean = false;
         var _loc2_:int = this._items.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._items[_loc3_];
            if(_loc4_.target)
            {
               if(_loc4_.type == "Animation" && this._startFrame != 0 && _loc4_.frame <= this._startFrame)
               {
                  _loc1_ = true;
                  _loc4_.value.b3 = false;
               }
               if(_loc4_.tween && _loc4_.nextItem)
               {
                  if(this._endFrame == -1 || _loc4_.frame <= this._endFrame)
                  {
                     _loc5_ = (_loc4_.nextItem.frame - _loc4_.frame) / this._frameRate;
                     _loc4_.tweenValue.b1 = _loc4_.value.b1 || _loc4_.nextItem.value.b1;
                     _loc4_.tweenValue.b2 = _loc4_.value.b2 || _loc4_.nextItem.value.b2;
                     switch(_loc4_.type)
                     {
                        case "XY":
                        case "Size":
                        case "Scale":
                        case "Skew":
                           _loc4_.tweener = GTween.to2(_loc4_.value.f1,_loc4_.value.f2,_loc4_.nextItem.value.f1,_loc4_.nextItem.value.f2,_loc5_);
                           break;
                        case "Alpha":
                        case "Rotation":
                           _loc4_.tweener = GTween.to(_loc4_.value.f1,_loc4_.nextItem.value.f1,_loc5_);
                           break;
                        case "Color":
                           _loc4_.tweener = GTween.toColor(_loc4_.value.iu,_loc4_.nextItem.value.iu,_loc5_);
                           break;
                        case "ColorFilter":
                           _loc4_.tweener = GTween.to4(_loc4_.value.f1,_loc4_.value.f2,_loc4_.value.f3,_loc4_.value.f4,_loc4_.nextItem.value.f1,_loc4_.nextItem.value.f2,_loc4_.nextItem.value.f3,_loc4_.nextItem.value.f4,_loc5_);
                     }
                     _loc4_.tweener.setDelay(_loc4_.frame / this._frameRate).setEase(EaseType.parseEaseType(_loc4_.easeName)).setRepeat(_loc4_.repeat,_loc4_.yoyo).setTarget(_loc4_).onStart(this.onTweenStart).onUpdate(this.onTweenUpdate).onComplete(this.onTweenComplete);
                     if(this._endFrame >= 0)
                     {
                        _loc4_.tweener.setBreakpoint((this._endFrame - _loc4_.frame) / this._frameRate);
                     }
                     this._totalTasks++;
                  }
               }
               else if(_loc4_.type == "Shake")
               {
                  if((this._owner._flags & FObjectFlags.IN_TEST) != 0)
                  {
                     _loc4_.tweenValue.f3 = _loc4_.tweenValue.f4 = 0;
                     _loc4_.tweener = GTween.shake(0,0,_loc4_.value.f1,_loc4_.value.f2).setDelay(_loc4_.frame / this._frameRate).setTarget(_loc4_).onUpdate(this.onTweenUpdate).onComplete(this.onTweenComplete);
                     if(this._endFrame >= 0)
                     {
                        _loc4_.tweener.setBreakpoint((this._endFrame - _loc4_.frame) / this._frameRate);
                     }
                     this._totalTasks++;
                  }
               }
               else if(_loc4_.prevItem == null)
               {
                  if(_loc4_.frame <= this._startFrame)
                  {
                     this.applyValue(_loc4_,_loc4_.value);
                  }
                  else if(this._endFrame == -1 || _loc4_.frame <= this._endFrame)
                  {
                     this._totalTasks++;
                     _loc4_.tweener = GTween.delayedCall(_loc4_.frame / this._frameRate).setTarget(_loc4_).onComplete(this.onDelayedPlayItem);
                  }
               }
               if(_loc4_.tweener != null)
               {
                  _loc4_.tweener.seek(this._startFrame / this._frameRate);
               }
            }
            _loc3_++;
         }
         if(_loc1_)
         {
            this.skipAnimations();
         }
      }
      
      private function skipAnimations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:FObject = null;
         var _loc6_:FTransitionItem = null;
         var _loc9_:int = 0;
         var _loc7_:int = this._items.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_ = this._items[_loc8_];
            if(!(_loc6_.type != "Animation" || _loc6_.frame > this._startFrame))
            {
               _loc4_ = _loc6_.value;
               if(!_loc4_.b3)
               {
                  _loc5_ = _loc6_.target;
                  _loc1_ = _loc5_.getProp(ObjectPropID.Frame);
                  _loc2_ = !!_loc5_.getProp(ObjectPropID.Playing)?0:-1;
                  _loc3_ = 0;
                  _loc9_ = _loc8_;
                  while(_loc9_ < _loc7_)
                  {
                     _loc6_ = this._items[_loc9_];
                     if(!(_loc6_.type != "Animation" || _loc6_.target != _loc5_ || _loc6_.frame > this._startFrame))
                     {
                        _loc4_ = _loc6_.value;
                        _loc4_.b3 = true;
                        if(_loc4_.b1)
                        {
                           _loc1_ = _loc4_.i;
                           if(_loc4_.b2)
                           {
                              _loc2_ = _loc6_.frame;
                           }
                           else
                           {
                              _loc2_ = -1;
                           }
                           _loc3_ = 0;
                        }
                        else if(_loc4_.b2)
                        {
                           if(_loc2_ < 0)
                           {
                              _loc2_ = _loc6_.frame;
                           }
                        }
                        else
                        {
                           if(_loc2_ >= 0)
                           {
                              _loc3_ = _loc3_ + (_loc6_.frame - _loc2_);
                           }
                           _loc2_ = -1;
                        }
                     }
                     _loc9_++;
                  }
                  if(_loc2_ >= 0)
                  {
                     _loc3_ = _loc3_ + (this._startFrame - _loc2_);
                  }
                  _loc5_.setProp(ObjectPropID.Playing,!this._editing && _loc2_ >= 0);
                  _loc5_.setProp(ObjectPropID.Frame,_loc1_);
                  if(_loc3_ > 0)
                  {
                     _loc5_.setProp(ObjectPropID.DeltaTime,_loc3_ / this._frameRate * 1000);
                  }
               }
            }
            _loc8_++;
         }
      }
      
      private function onDelayedPlayItem(param1:GTweener) : void
      {
         var _loc2_:FTransitionItem = FTransitionItem(param1.target);
         _loc2_.tweener = null;
         this._totalTasks--;
         this.applyValue(_loc2_,_loc2_.value);
         this.checkAllComplete();
      }
      
      private function onTweenStart(param1:GTweener) : void
      {
         var _loc2_:FTransitionItem = FTransitionItem(param1.target);
         this._elapsedFrame = _loc2_.frame;
         if(_loc2_.type == "XY")
         {
            if(_loc2_.target != this._owner)
            {
               if(!_loc2_.value.b1)
               {
                  param1.startValue.x = _loc2_.target.x;
               }
               else if(_loc2_.value.b3)
               {
                  param1.startValue.x = _loc2_.value.f3 * this._owner.width;
               }
               if(!_loc2_.value.b2)
               {
                  param1.startValue.y = _loc2_.target.y;
               }
               else if(_loc2_.value.b3)
               {
                  param1.startValue.y = _loc2_.value.f4 * this._owner.height;
               }
               if(!_loc2_.nextItem.value.b1)
               {
                  param1.endValue.x = param1.startValue.x;
               }
               else if(_loc2_.nextItem.value.b3)
               {
                  param1.endValue.x = _loc2_.nextItem.value.f3 * this._owner.width;
               }
               if(!_loc2_.nextItem.value.b2)
               {
                  param1.endValue.y = param1.startValue.y;
               }
               else if(_loc2_.nextItem.value.b3)
               {
                  param1.endValue.y = _loc2_.nextItem.value.f4 * this._owner.height;
               }
            }
            else
            {
               if(!_loc2_.value.b1)
               {
                  param1.startValue.x = _loc2_.target.x - this._ownerBaseX;
               }
               if(!_loc2_.value.b2)
               {
                  param1.startValue.y = _loc2_.target.y - this._ownerBaseY;
               }
               if(!_loc2_.nextItem.value.b1)
               {
                  param1.endValue.x = param1.startValue.x;
               }
               if(!_loc2_.nextItem.value.b2)
               {
                  param1.endValue.y = param1.startValue.y;
               }
            }
            if(_loc2_.usePath)
            {
               _loc2_.tweenValue.b1 = _loc2_.tweenValue.b2 = true;
               _loc2_.setPathToTweener();
            }
         }
         else if(_loc2_.type == "Size")
         {
            if(!_loc2_.value.b1)
            {
               param1.startValue.x = _loc2_.target.width;
            }
            if(!_loc2_.value.b2)
            {
               param1.startValue.y = _loc2_.target.height;
            }
            if(!_loc2_.nextItem.value.b1)
            {
               param1.endValue.x = param1.startValue.x;
            }
            if(!_loc2_.nextItem.value.b2)
            {
               param1.endValue.y = param1.startValue.y;
            }
         }
      }
      
      private function onTweenUpdate(param1:GTweener) : void
      {
         var _loc2_:FTransitionItem = FTransitionItem(param1.target);
         switch(_loc2_.type)
         {
            case "XY":
            case "Size":
            case "Scale":
            case "Skew":
               _loc2_.tweenValue.f1 = param1.value.x;
               _loc2_.tweenValue.f2 = param1.value.y;
               if(_loc2_.usePath)
               {
                  _loc2_.tweenValue.f1 = _loc2_.tweenValue.f1 + _loc2_.pathOffsetX;
                  _loc2_.tweenValue.f2 = _loc2_.tweenValue.f2 + _loc2_.pathOffsetY;
               }
               this.applyValue(_loc2_,_loc2_.tweenValue);
               break;
            case "Alpha":
            case "Rotation":
               _loc2_.tweenValue.f1 = param1.value.x;
               this.applyValue(_loc2_,_loc2_.tweenValue);
               break;
            case "Color":
               _loc2_.tweenValue.iu = param1.value.color;
               this.applyValue(_loc2_,_loc2_.tweenValue);
               break;
            case "ColorFilter":
               _loc2_.tweenValue.f1 = param1.value.x;
               _loc2_.tweenValue.f2 = param1.value.y;
               _loc2_.tweenValue.f3 = param1.value.z;
               _loc2_.tweenValue.f4 = param1.value.w;
               this.applyValue(_loc2_,_loc2_.tweenValue);
               break;
            case "Shake":
               _loc2_.target._gearLocked = true;
               _loc2_.target.setXY(_loc2_.target.x - _loc2_.tweenValue.f3 + param1.deltaValue.x,_loc2_.target.y - _loc2_.tweenValue.f4 + param1.deltaValue.y);
               _loc2_.target._gearLocked = false;
               _loc2_.tweenValue.f3 = param1.deltaValue.x;
               _loc2_.tweenValue.f4 = param1.deltaValue.y;
         }
      }
      
      private function onTweenComplete(param1:GTweener) : void
      {
         var _loc2_:FTransitionItem = FTransitionItem(param1.target);
         _loc2_.tweener = null;
         this._totalTasks--;
         this.checkAllComplete();
      }
      
      private function onPlayTransComplete(param1:FTransitionItem) : void
      {
         this._totalTasks--;
         this.checkAllComplete();
      }
      
      private function checkAllComplete() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:FTransitionItem = null;
         var _loc4_:Function = null;
         var _loc5_:Object = null;
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
                  if((this._owner._flags & FObjectFlags.ROOT) == 0)
                  {
                     _loc1_ = this._items.length;
                     _loc2_ = 0;
                     while(_loc2_ < _loc1_)
                     {
                        _loc3_ = this._items[_loc2_];
                        if(_loc3_.target != null && _loc3_.displayLockToken != 0)
                        {
                           _loc3_.target.releaseDisplayLock(_loc3_.displayLockToken);
                           _loc3_.displayLockToken = 0;
                        }
                        _loc2_++;
                     }
                  }
                  if(this._onComplete != null)
                  {
                     _loc4_ = this._onComplete;
                     _loc5_ = this._onCompleteParam;
                     this._onComplete = null;
                     this._onCompleteParam = null;
                     if(_loc4_.length > 0)
                     {
                        _loc4_(_loc5_);
                     }
                     else
                     {
                        _loc4_();
                     }
                  }
               }
            }
         }
      }
      
      private function applyValue(param1:FTransitionItem, param2:FTransitionValue) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         param1.target._gearLocked = true;
         switch(param1.type)
         {
            case "XY":
               if(param1.target == this._owner)
               {
                  if(param2.b1 && param2.b2)
                  {
                     param1.target.setXY(param2.f1 + this._ownerBaseX,param2.f2 + this._ownerBaseY);
                  }
                  else if(param2.b1)
                  {
                     param1.target.x = param2.f1 + this._ownerBaseX;
                  }
                  else if(param2.b2)
                  {
                     param1.target.y = param2.f2 + this._ownerBaseY;
                  }
               }
               else if(param2.b3)
               {
                  if(param2.b1 && param2.b2)
                  {
                     param1.target.setXY(param2.f3 * this._owner.width,param2.f4 * this._owner.height);
                  }
                  else if(param2.b1)
                  {
                     param1.target.x = param2.f3 * this._owner.width;
                  }
                  else if(param2.b2)
                  {
                     param1.target.y = param2.f4 * this._owner.height;
                  }
               }
               else if(param2.b1 && param2.b2)
               {
                  param1.target.setXY(param2.f1,param2.f2);
               }
               else if(param2.b1)
               {
                  param1.target.x = param2.f1;
               }
               else if(param2.b2)
               {
                  param1.target.y = param2.f2;
               }
               break;
            case "Size":
               if(!param2.b1)
               {
                  param2.f1 = param1.target.width;
               }
               if(!param2.b2)
               {
                  param2.f2 = param1.target.height;
               }
               param1.target.setSize(param2.f1,param2.f2);
               break;
            case "Pivot":
               param1.target.setPivot(param2.f1,param2.f2,param1.target.anchor);
               break;
            case "Alpha":
               param1.target.alpha = param2.f1;
               break;
            case "Rotation":
               param1.target.rotation = param2.f1;
               break;
            case "Scale":
               param1.target.setScale(param2.f1,param2.f2);
               break;
            case "Skew":
               param1.target.setSkew(param2.f1,param2.f2);
               break;
            case "Color":
               param1.target.setProp(ObjectPropID.Color,param2.iu);
               break;
            case "Animation":
               if(param2.b1)
               {
                  param1.target.setProp(ObjectPropID.Frame,param2.i);
               }
               param1.target.setProp(ObjectPropID.Playing,!this._editing && param2.b2);
               break;
            case "Visible":
               param1.target.visible = param2.b1;
               break;
            case "Transition":
               if(this._playing)
               {
                  if(param1.innerTrans != null)
                  {
                     this._totalTasks++;
                     _loc3_ = this._startFrame > param1.frame?int(this._startFrame - param1.frame):0;
                     _loc4_ = this._endFrame >= 0?int(this._endFrame - param1.frame):-1;
                     if(param1.value.f1 >= 0 && (_loc4_ < 0 || _loc4_ > param1.value.f1))
                     {
                        _loc4_ = param1.value.f1;
                     }
                     param1.innerTrans.play(this.onPlayTransComplete,param1,param2.i,0,_loc3_,_loc4_,this._editing);
                  }
               }
               break;
            case "Sound":
               if(this._playing && param1.frame >= this._startFrame && (this._owner._flags & FObjectFlags.IN_TEST) != 0)
               {
                  this._owner._pkg.project.playSound(param2.s,param2.i / 100);
               }
               break;
            case "ColorFilter":
               param1.target.filterData.type = "color";
               param1.target.filterData.brightness = param2.f1;
               param1.target.filterData.contrast = param2.f2;
               param1.target.filterData.saturation = param2.f3;
               param1.target.filterData.hue = param2.f4;
               param1.target.displayObject.applyFilter();
               break;
            case "Text":
               param1.target.text = param2.s;
               break;
            case "Icon":
               param1.target.icon = param2.s;
         }
         param1.target._gearLocked = false;
      }
   }
}

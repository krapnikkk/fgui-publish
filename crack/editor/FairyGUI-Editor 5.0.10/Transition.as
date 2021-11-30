package fairygui
{
   import fairygui.tween.EaseType;
   import fairygui.tween.GPath;
   import fairygui.tween.GPathPoint;
   import fairygui.tween.GTween;
   import fairygui.tween.GTweener;
   import fairygui.utils.ColorMatrix;
   import fairygui.utils.ToolSet;
   import flash.filters.ColorMatrixFilter;
   
   public class Transition
   {
       
      
      public var name:String;
      
      private var _owner:GComponent;
      
      private var _ownerBaseX:Number;
      
      private var _ownerBaseY:Number;
      
      private var _items:Vector.<TransitionItem>;
      
      private var _totalTimes:int;
      
      private var _totalTasks:int;
      
      private var _playing:Boolean;
      
      private var _paused:Boolean;
      
      private var _onComplete:Function;
      
      private var _onCompleteParam:Object;
      
      private var _options:int;
      
      private var _reversed:Boolean;
      
      private var _totalDuration:Number;
      
      private var _autoPlay:Boolean;
      
      private var _autoPlayTimes:int;
      
      private var _autoPlayDelay:Number;
      
      private var _timeScale:Number;
      
      private var _startTime:Number;
      
      private var _endTime:Number;
      
      private const OPTION_IGNORE_DISPLAY_CONTROLLER:int = 1;
      
      private const OPTION_AUTO_STOP_DISABLED:int = 2;
      
      private const OPTION_AUTO_STOP_AT_END:int = 4;
      
      private var helperPathPoints:Vector.<GPathPoint>;
      
      public function Transition(param1:GComponent)
      {
         helperPathPoints = new Vector.<GPathPoint>();
         super();
         _owner = param1;
         _items = new Vector.<TransitionItem>();
         _totalDuration = 0;
         _autoPlayTimes = 1;
         _autoPlayDelay = 0;
         _timeScale = 1;
         _startTime = 0;
         _endTime = 0;
      }
      
      public function play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:Number = 0, param6:Number = -1) : void
      {
         _play(param1,param2,param3,param4,param5,param6,false);
      }
      
      public function playReverse(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:Number = 0, param6:Number = -1) : void
      {
         _play(param1,param2,1,param4,param5,param6,true);
      }
      
      public function changePlayTimes(param1:int) : void
      {
         _totalTimes = param1;
      }
      
      public function setAutoPlay(param1:Boolean, param2:int = 1, param3:Number = 0) : void
      {
         if(_autoPlay != param1)
         {
            _autoPlay = param1;
            _autoPlayTimes = param2;
            _autoPlayDelay = param3;
            if(_autoPlay)
            {
               if(_owner.onStage)
               {
                  play(null,null,_autoPlayTimes,_autoPlayDelay);
               }
            }
            else if(!_owner.onStage)
            {
               stop(false,true);
            }
         }
      }
      
      private function _play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:Number = 0, param6:Number = -1, param7:Boolean = false) : void
      {
         var _loc11_:int = 0;
         var _loc8_:* = null;
         var _loc13_:* = null;
         var _loc12_:int = 0;
         var _loc9_:* = null;
         stop(true,true);
         _totalTimes = param3;
         _reversed = param7;
         _startTime = param5;
         _endTime = param6;
         _playing = true;
         _paused = false;
         _onComplete = param1;
         _onCompleteParam = param2;
         var _loc10_:int = _items.length;
         _loc11_ = 0;
         while(_loc11_ < _loc10_)
         {
            _loc8_ = _items[_loc11_];
            if(_loc8_.target == null)
            {
               if(_loc8_.targetId)
               {
                  _loc8_.target = _owner.getChildById(_loc8_.targetId);
               }
               else
               {
                  _loc8_.target = _owner;
               }
            }
            else if(_loc8_.target != _owner && _loc8_.target.parent != _owner)
            {
               _loc8_.target = null;
            }
            if(_loc8_.target != null && _loc8_.type == 10)
            {
               _loc13_ = GComponent(_loc8_.target).getTransition(_loc8_.value.transName);
               if(_loc13_ == this)
               {
                  _loc13_ = null;
               }
               if(_loc13_ != null)
               {
                  if(_loc8_.value.playTimes == 0)
                  {
                     _loc12_ = _loc11_ - 1;
                     while(_loc12_ >= 0)
                     {
                        _loc9_ = _items[_loc12_];
                        if(_loc9_.type == 10)
                        {
                           if(_loc9_.value.trans == _loc13_)
                           {
                              _loc9_.value.stopTime = _loc8_.time - _loc9_.time;
                              break;
                           }
                        }
                        _loc12_--;
                     }
                     if(_loc12_ < 0)
                     {
                        _loc8_.value.stopTime = 0;
                     }
                     else
                     {
                        _loc13_ = null;
                     }
                  }
                  else
                  {
                     _loc8_.value.stopTime = -1;
                  }
               }
               _loc8_.value.trans = _loc13_;
            }
            _loc11_++;
         }
         if(param4 == 0)
         {
            onDelayedPlay();
         }
         else
         {
            GTween.delayedCall(param4).onComplete(onDelayedPlay);
         }
      }
      
      public function stop(param1:Boolean = true, param2:Boolean = false) : void
      {
         var _loc7_:int = 0;
         var _loc3_:* = null;
         if(!_playing)
         {
            return;
         }
         _playing = false;
         _totalTasks = 0;
         _totalTimes = 0;
         var _loc4_:Function = _onComplete;
         var _loc5_:Object = _onCompleteParam;
         _onComplete = null;
         _onCompleteParam = null;
         GTween.kill(this);
         var _loc6_:int = _items.length;
         if(_reversed)
         {
            _loc7_ = _loc6_ - 1;
            while(_loc7_ >= 0)
            {
               _loc3_ = _items[_loc7_];
               if(_loc3_.target != null)
               {
                  stopItem(_loc3_,param1);
               }
               _loc7_--;
            }
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc3_ = _items[_loc7_];
               if(_loc3_.target != null)
               {
                  stopItem(_loc3_,param1);
               }
               _loc7_++;
            }
         }
         if(param2 && _loc4_ != null)
         {
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
      
      private function stopItem(param1:TransitionItem, param2:Boolean) : void
      {
         var _loc3_:* = null;
         if(param1.displayLockToken != 0)
         {
            param1.target.releaseDisplayLock(param1.displayLockToken);
            param1.displayLockToken = 0;
         }
         if(param1.tweener != null)
         {
            param1.tweener.kill(param2);
            param1.tweener = null;
            if(param1.type == 11 && !param2)
            {
               param1.target._gearLocked = true;
               param1.target.setXY(param1.target.x - param1.value.lastOffsetX,param1.target.y - param1.value.lastOffsetY);
               param1.target._gearLocked = false;
            }
         }
         if(param1.type == 10)
         {
            _loc3_ = param1.value.trans;
            if(_loc3_ != null)
            {
               _loc3_.stop(param2,false);
            }
         }
      }
      
      public function setPaused(param1:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         if(!_playing || _paused == param1)
         {
            return;
         }
         _paused = param1;
         var _loc5_:GTweener = GTween.getTween(this);
         if(_loc5_ != null)
         {
            _loc5_.setPaused(param1);
         }
         var _loc3_:int = _items.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _items[_loc4_];
            if(_loc2_.target != null)
            {
               if(_loc2_.type == 10)
               {
                  if(_loc2_.value.trans != null)
                  {
                     _loc2_.value.trans.setPaused(param1);
                  }
               }
               else if(_loc2_.type == 7)
               {
                  if(param1)
                  {
                     _loc2_.value.flag = _loc2_.target.getProp(4);
                     _loc2_.target.setProp(4,false);
                  }
                  else
                  {
                     _loc2_.target.setProp(4,_loc2_.value.flag);
                  }
               }
               if(_loc2_.tweener != null)
               {
                  _loc2_.tweener.setPaused(param1);
               }
            }
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         if(_playing)
         {
            GTween.kill(this);
         }
         var _loc2_:int = _items.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _items[_loc3_];
            if(_loc1_.tweener != null)
            {
               _loc1_.tweener.kill();
               _loc1_.tweener = null;
            }
            _loc1_.target = null;
            _loc1_.hook = null;
            if(_loc1_.tweenConfig != null)
            {
               _loc1_.tweenConfig.endHook = null;
            }
            _loc3_++;
         }
         _items.length = 0;
         _playing = false;
         _onComplete = null;
         _onCompleteParam = null;
      }
      
      public function get playing() : Boolean
      {
         return _playing;
      }
      
      public function setValue(param1:String, ... rest) : void
      {
         var _loc7_:* = null;
         var _loc6_:int = 0;
         var _loc3_:* = null;
         var _loc5_:int = _items.length;
         var _loc4_:Boolean = false;
         _loc6_ = 0;
         for(; _loc6_ < _loc5_; _loc6_++)
         {
            _loc3_ = _items[_loc6_];
            if(_loc3_.label == param1)
            {
               if(_loc3_.tweenConfig != null)
               {
                  _loc7_ = _loc3_.tweenConfig.startValue;
               }
               else
               {
                  _loc7_ = _loc3_.value;
               }
               _loc4_ = true;
            }
            else if(_loc3_.tweenConfig != null && _loc3_.tweenConfig.endLabel == param1)
            {
               _loc7_ = _loc3_.tweenConfig.endValue;
               _loc4_ = true;
            }
            else
            {
               continue;
            }
            var _loc8_:* = _loc3_.type;
            if(TransitionActionType.XY !== _loc8_)
            {
               if(1 !== _loc8_)
               {
                  if(3 !== _loc8_)
                  {
                     if(2 !== _loc8_)
                     {
                        if(13 !== _loc8_)
                        {
                           if(4 !== _loc8_)
                           {
                              if(5 !== _loc8_)
                              {
                                 if(6 !== _loc8_)
                                 {
                                    if(7 !== _loc8_)
                                    {
                                       if(8 !== _loc8_)
                                       {
                                          if(9 !== _loc8_)
                                          {
                                             if(10 !== _loc8_)
                                             {
                                                if(11 !== _loc8_)
                                                {
                                                   if(12 !== _loc8_)
                                                   {
                                                      if(14 !== _loc8_)
                                                      {
                                                         if(15 !== _loc8_)
                                                         {
                                                         }
                                                         continue;
                                                      }
                                                      _loc7_.text = rest[0];
                                                   }
                                                   else
                                                   {
                                                      _loc7_.f1 = parseFloat(rest[0]);
                                                      _loc7_.f2 = parseFloat(rest[1]);
                                                      _loc7_.f3 = parseFloat(rest[2]);
                                                      _loc7_.f4 = parseFloat(rest[3]);
                                                   }
                                                }
                                                else
                                                {
                                                   _loc7_.amplitude = parseFloat(rest[0]);
                                                   if(rest.length > 1)
                                                   {
                                                      _loc7_.duration = parseFloat(rest[1]);
                                                   }
                                                }
                                             }
                                             else
                                             {
                                                _loc7_.transName = rest[0];
                                                if(rest.length > 1)
                                                {
                                                   _loc7_.playTimes = parseInt(rest[1]);
                                                }
                                             }
                                          }
                                          else
                                          {
                                             _loc7_.sound = rest[0];
                                             if(rest.length > 1)
                                             {
                                                _loc7_.volume = parseFloat(rest[1]);
                                             }
                                          }
                                       }
                                       else
                                       {
                                          _loc7_.visible = rest[0];
                                       }
                                    }
                                    else
                                    {
                                       _loc7_.frame = parseInt(rest[0]);
                                       if(rest.length > 1)
                                       {
                                          _loc7_.playing = rest[1];
                                       }
                                    }
                                 }
                                 else
                                 {
                                    _loc7_.f1 = parseFloat(rest[0]);
                                 }
                              }
                              else
                              {
                                 _loc7_.f1 = parseFloat(rest[0]);
                              }
                           }
                           else
                           {
                              _loc7_.f1 = parseFloat(rest[0]);
                           }
                           continue;
                        }
                     }
                     addr75:
                     _loc7_.b1 = true;
                     _loc7_.b2 = true;
                     _loc7_.f1 = parseFloat(rest[0]);
                     _loc7_.f2 = parseFloat(rest[1]);
                     continue;
                  }
                  addr74:
                  §§goto(addr75);
               }
               addr73:
               §§goto(addr74);
            }
            §§goto(addr73);
         }
         if(!_loc4_)
         {
            throw new Error("label not exists");
         }
      }
      
      public function setHook(param1:String, param2:Function) : void
      {
         var _loc6_:int = 0;
         var _loc3_:* = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = _items.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _items[_loc6_];
            if(_loc3_.label == param1)
            {
               _loc3_.hook = param2;
               _loc4_ = true;
               break;
            }
            if(_loc3_.tweenConfig != null && _loc3_.tweenConfig.endLabel == param1)
            {
               _loc3_.tweenConfig.endHook = param2;
               _loc4_ = true;
               break;
            }
            _loc6_++;
         }
         if(!_loc4_)
         {
            throw new Error("label not exists");
         }
      }
      
      public function clearHooks() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         var _loc2_:int = _items.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _items[_loc3_];
            _loc1_.hook = null;
            if(_loc1_.tweenConfig != null)
            {
               _loc1_.tweenConfig.endHook = null;
            }
            _loc3_++;
         }
      }
      
      public function setTarget(param1:String, param2:GObject) : void
      {
         var _loc6_:int = 0;
         var _loc3_:* = null;
         var _loc5_:int = _items.length;
         var _loc4_:Boolean = false;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _items[_loc6_];
            if(_loc3_.label == param1)
            {
               _loc3_.targetId = param2 == _owner || param2 == null?"":param2.id;
               if(_playing)
               {
                  if(_loc3_.targetId.length > 0)
                  {
                     _loc3_.target = _owner.getChildById(_loc3_.targetId);
                  }
                  else
                  {
                     _loc3_.target = _owner;
                  }
               }
               else
               {
                  _loc3_.target = null;
               }
               _loc4_ = true;
            }
            _loc6_++;
         }
         if(!_loc4_)
         {
            throw new Error("label not exists");
         }
      }
      
      public function setDuration(param1:String, param2:Number) : void
      {
         var _loc6_:int = 0;
         var _loc3_:* = null;
         var _loc5_:int = _items.length;
         var _loc4_:Boolean = false;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = _items[_loc6_];
            if(_loc3_.tweenConfig != null && _loc3_.label == param1)
            {
               _loc3_.tweenConfig.duration = param2;
               _loc4_ = true;
            }
            _loc6_++;
         }
         if(!_loc4_)
         {
            throw new Error("label not exists");
         }
      }
      
      public function getLabelTime(param1:String) : Number
      {
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = _items.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _items[_loc4_];
            if(_loc2_.label == param1)
            {
               return _loc2_.time;
            }
            if(_loc2_.tweenConfig != null && _loc2_.tweenConfig.endLabel == param1)
            {
               return _loc2_.time + _loc2_.tweenConfig.duration;
            }
            _loc4_++;
         }
         return NaN;
      }
      
      public function get timeScale() : Number
      {
         return _timeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:* = null;
         if(_timeScale != param1)
         {
            _timeScale = param1;
            if(_playing)
            {
               _loc3_ = _items.length;
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc2_ = _items[_loc4_];
                  if(_loc2_.tweener != null)
                  {
                     _loc2_.tweener.setTimeScale(param1);
                  }
                  else if(_loc2_.type == 10)
                  {
                     if(_loc2_.value.trans != null)
                     {
                        _loc2_.value.trans.timeScale = param1;
                     }
                  }
                  else if(_loc2_.type == 7)
                  {
                     if(_loc2_.target != null)
                     {
                        _loc2_.target.setProp(7,param1);
                     }
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      function updateFromRelations(param1:String, param2:Number, param3:Number) : void
      {
         var _loc6_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = _items.length;
         if(_loc5_ == 0)
         {
            return;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _items[_loc6_];
            if(_loc4_.type == TransitionActionType.XY && _loc4_.targetId == param1)
            {
               if(_loc4_.tweenConfig != null)
               {
                  if(!_loc4_.tweenConfig.startValue.b3)
                  {
                     _loc4_.tweenConfig.startValue.f1 = _loc4_.tweenConfig.startValue.f1 + param2;
                     _loc4_.tweenConfig.startValue.f2 = _loc4_.tweenConfig.startValue.f2 + param3;
                  }
                  if(!_loc4_.tweenConfig.endValue.b3)
                  {
                     _loc4_.tweenConfig.endValue.f1 = _loc4_.tweenConfig.endValue.f1 + param2;
                     _loc4_.tweenConfig.endValue.f2 = _loc4_.tweenConfig.endValue.f2 + param3;
                  }
               }
               else if(!_loc4_.value.b3)
               {
                  _loc4_.value.f1 = _loc4_.value.f1 + param2;
                  _loc4_.value.f2 = _loc4_.value.f2 + param3;
               }
            }
            _loc6_++;
         }
      }
      
      function onOwnerAddedToStage() : void
      {
         if(_autoPlay && !_playing)
         {
            play(null,null,_autoPlayTimes,_autoPlayDelay);
         }
      }
      
      function onOwnerRemovedFromStage() : void
      {
         if((_options & 2) == 0)
         {
            stop((_options & 4) != 0?true:false,false);
         }
      }
      
      private function onDelayedPlay() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         internalPlay();
         _playing = _totalTasks > 0;
         if(_playing)
         {
            if((_options & 1) != 0)
            {
               _loc4_ = _items.length;
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc1_ = _items[_loc5_];
                  if(_loc1_.target != null && _loc1_.target != _owner)
                  {
                     _loc1_.displayLockToken = _loc1_.target.addDisplayLock();
                  }
                  _loc5_++;
               }
            }
         }
         else if(_onComplete != null)
         {
            _loc2_ = _onComplete;
            _loc3_ = _onCompleteParam;
            _onComplete = null;
            _onCompleteParam = null;
            if(_loc2_.length > 0)
            {
               _loc2_(_loc3_);
            }
            else
            {
               _loc2_();
            }
         }
      }
      
      private function internalPlay() : void
      {
         var _loc1_:* = null;
         var _loc4_:int = 0;
         _ownerBaseX = _owner.x;
         _ownerBaseY = _owner.y;
         _totalTasks = 0;
         var _loc3_:int = _items.length;
         var _loc2_:Boolean = false;
         if(!_reversed)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc1_ = _items[_loc4_];
               if(_loc1_.target != null)
               {
                  if(_loc1_.type == 7 && _startTime != 0 && _loc1_.time <= _startTime)
                  {
                     _loc2_ = true;
                     _loc1_.value.flag = false;
                  }
                  else
                  {
                     playItem(_loc1_);
                  }
               }
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = _loc3_ - 1;
            while(_loc4_ >= 0)
            {
               _loc1_ = _items[_loc4_];
               if(_loc1_.target != null)
               {
                  playItem(_loc1_);
               }
               _loc4_--;
            }
         }
         if(_loc2_)
         {
            skipAnimations();
         }
      }
      
      private function playItem(param1:TransitionItem) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:* = null;
         var _loc2_:* = null;
         if(param1.tweenConfig != null)
         {
            if(_reversed)
            {
               _loc3_ = _totalDuration - param1.time - param1.tweenConfig.duration;
            }
            else
            {
               _loc3_ = param1.time;
            }
            if(_endTime == -1 || _loc3_ <= _endTime)
            {
               if(_reversed)
               {
                  _loc4_ = param1.tweenConfig.endValue;
                  _loc2_ = param1.tweenConfig.startValue;
               }
               else
               {
                  _loc4_ = param1.tweenConfig.startValue;
                  _loc2_ = param1.tweenConfig.endValue;
               }
               param1.value.b1 = _loc4_.b1 || _loc2_.b1;
               param1.value.b2 = _loc4_.b2 || _loc2_.b2;
               var _loc5_:* = param1.type;
               if(TransitionActionType.XY !== _loc5_)
               {
                  if(1 !== _loc5_)
                  {
                     if(2 !== _loc5_)
                     {
                        if(13 !== _loc5_)
                        {
                           if(4 !== _loc5_)
                           {
                              if(5 !== _loc5_)
                              {
                                 if(6 !== _loc5_)
                                 {
                                    if(12 === _loc5_)
                                    {
                                       param1.tweener = GTween.to4(_loc4_.f1,_loc4_.f2,_loc4_.f3,_loc4_.f4,_loc2_.f1,_loc2_.f2,_loc2_.f3,_loc2_.f4,param1.tweenConfig.duration);
                                    }
                                 }
                                 else
                                 {
                                    param1.tweener = GTween.toColor(_loc4_.f1,_loc2_.f1,param1.tweenConfig.duration);
                                 }
                              }
                           }
                           param1.tweener = GTween.to(_loc4_.f1,_loc2_.f1,param1.tweenConfig.duration);
                        }
                        addr185:
                        param1.tweener.setDelay(_loc3_).setEase(param1.tweenConfig.easeType).setRepeat(param1.tweenConfig.repeat,param1.tweenConfig.yoyo).setTimeScale(_timeScale).setTarget(param1).onStart(onTweenStart).onUpdate(onTweenUpdate).onComplete(onTweenComplete);
                        if(_endTime >= 0)
                        {
                           param1.tweener.setBreakpoint(_endTime - _loc3_);
                        }
                        _totalTasks = Number(_totalTasks) + 1;
                     }
                     addr91:
                     param1.tweener = GTween.to2(_loc4_.f1,_loc4_.f2,_loc2_.f1,_loc2_.f2,param1.tweenConfig.duration);
                     §§goto(addr185);
                  }
                  addr90:
                  §§goto(addr91);
               }
               §§goto(addr90);
            }
         }
         else if(param1.type == 11)
         {
            if(_reversed)
            {
               _loc3_ = _totalDuration - param1.time - param1.value.duration;
            }
            else
            {
               _loc3_ = param1.time;
            }
            _loc5_ = 0;
            param1.value.offsetY = _loc5_;
            param1.value.offsetX = _loc5_;
            _loc5_ = 0;
            param1.value.lastOffsetY = _loc5_;
            param1.value.lastOffsetX = _loc5_;
            param1.tweener = GTween.shake(0,0,param1.value.amplitude,param1.value.duration).setDelay(_loc3_).setTimeScale(_timeScale).setTarget(param1).onUpdate(onTweenUpdate).onComplete(onTweenComplete);
            if(_endTime >= 0)
            {
               param1.tweener.setBreakpoint(_endTime - param1.time);
            }
            _totalTasks = Number(_totalTasks) + 1;
         }
         else
         {
            if(_reversed)
            {
               _loc3_ = _totalDuration - param1.time;
            }
            else
            {
               _loc3_ = param1.time;
            }
            if(_loc3_ <= _startTime)
            {
               applyValue(param1);
               callHook(param1,false);
            }
            else if(_endTime == -1 || _loc3_ <= _endTime)
            {
               _totalTasks = Number(_totalTasks) + 1;
               param1.tweener = GTween.delayedCall(_loc3_).setTimeScale(_timeScale).setTarget(param1).onComplete(onDelayedPlayItem);
            }
         }
         if(param1.tweener != null)
         {
            param1.tweener.seek(_startTime);
         }
      }
      
      private function skipAnimations() : void
      {
         var _loc8_:int = 0;
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         var _loc7_:* = null;
         var _loc9_:* = null;
         var _loc3_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc4_:int = _items.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _items[_loc5_];
            if(!(_loc3_.type != 7 || _loc3_.time > _startTime))
            {
               _loc7_ = TValue_Animation(_loc3_.value);
               if(!_loc7_.flag)
               {
                  _loc9_ = _loc3_.target;
                  _loc8_ = _loc9_.getProp(5);
                  _loc1_ = Number(!!_loc9_.getProp(4)?0:-1);
                  _loc2_ = 0;
                  _loc6_ = _loc5_;
                  while(_loc6_ < _loc4_)
                  {
                     _loc3_ = _items[_loc6_];
                     if(!(_loc3_.type != 7 || _loc3_.target != _loc9_ || _loc3_.time > _startTime))
                     {
                        _loc7_ = TValue_Animation(_loc3_.value);
                        _loc7_.flag = true;
                        if(_loc7_.frame != -1)
                        {
                           _loc8_ = _loc7_.frame;
                           if(_loc7_.playing)
                           {
                              _loc1_ = Number(_loc3_.time);
                           }
                           else
                           {
                              _loc1_ = -1;
                           }
                           _loc2_ = 0;
                        }
                        else if(_loc7_.playing)
                        {
                           if(_loc1_ < 0)
                           {
                              _loc1_ = Number(_loc3_.time);
                           }
                        }
                        else
                        {
                           if(_loc1_ >= 0)
                           {
                              _loc2_ = Number(_loc2_ + (_loc3_.time - _loc1_));
                           }
                           _loc1_ = -1;
                        }
                        callHook(_loc3_,false);
                     }
                     _loc6_++;
                  }
                  if(_loc1_ >= 0)
                  {
                     _loc2_ = Number(_loc2_ + (_startTime - _loc1_));
                  }
                  _loc9_.setProp(4,_loc1_ >= 0);
                  _loc9_.setProp(5,_loc8_);
                  if(_loc2_ > 0)
                  {
                     _loc9_.setProp(6,_loc2_ * 1000);
                  }
               }
            }
            _loc5_++;
         }
      }
      
      private function onDelayedPlayItem(param1:GTweener) : void
      {
         var _loc2_:TransitionItem = TransitionItem(param1.target);
         _loc2_.tweener = null;
         _totalTasks = Number(_totalTasks) - 1;
         applyValue(_loc2_);
         callHook(_loc2_,false);
         checkAllComplete();
      }
      
      private function onTweenStart(param1:GTweener) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:TransitionItem = TransitionItem(param1.target);
         if(_loc2_.type == TransitionActionType.XY || _loc2_.type == 1)
         {
            if(_reversed)
            {
               _loc4_ = _loc2_.tweenConfig.endValue;
               _loc3_ = _loc2_.tweenConfig.startValue;
            }
            else
            {
               _loc4_ = _loc2_.tweenConfig.startValue;
               _loc3_ = _loc2_.tweenConfig.endValue;
            }
            if(_loc2_.type == TransitionActionType.XY)
            {
               if(_loc2_.target != _owner)
               {
                  if(!_loc4_.b1)
                  {
                     param1.startValue.x = _loc2_.target.x;
                  }
                  else if(_loc4_.b3)
                  {
                     param1.startValue.x = _loc4_.f1 * _owner.width;
                  }
                  if(!_loc4_.b2)
                  {
                     param1.startValue.y = _loc2_.target.y;
                  }
                  else if(_loc4_.b3)
                  {
                     param1.startValue.y = _loc4_.f2 * _owner.height;
                  }
                  if(!_loc3_.b1)
                  {
                     param1.endValue.x = param1.startValue.x;
                  }
                  else if(_loc3_.b3)
                  {
                     param1.endValue.x = _loc3_.f1 * _owner.width;
                  }
                  if(!_loc3_.b2)
                  {
                     param1.endValue.y = param1.startValue.y;
                  }
                  else if(_loc3_.b3)
                  {
                     param1.endValue.y = _loc3_.f2 * _owner.height;
                  }
               }
               else
               {
                  if(!_loc4_.b1)
                  {
                     param1.startValue.x = _loc2_.target.x - _ownerBaseX;
                  }
                  if(!_loc4_.b2)
                  {
                     param1.startValue.y = _loc2_.target.y - _ownerBaseY;
                  }
                  if(!_loc3_.b1)
                  {
                     param1.endValue.x = param1.startValue.x;
                  }
                  if(!_loc3_.b2)
                  {
                     param1.endValue.y = param1.startValue.y;
                  }
               }
            }
            else
            {
               if(!_loc4_.b1)
               {
                  param1.startValue.x = _loc2_.target.width;
               }
               if(!_loc4_.b2)
               {
                  param1.startValue.y = _loc2_.target.height;
               }
               if(!_loc3_.b1)
               {
                  param1.endValue.x = param1.startValue.x;
               }
               if(!_loc3_.b2)
               {
                  param1.endValue.y = param1.startValue.y;
               }
            }
            if(_loc2_.tweenConfig.path)
            {
               var _loc5_:Boolean = true;
               _loc2_.value.b2 = _loc5_;
               _loc2_.value.b1 = _loc5_;
               param1.setPath(_loc2_.tweenConfig.path);
            }
         }
         callHook(_loc2_,false);
      }
      
      private function onTweenUpdate(param1:GTweener) : void
      {
         var _loc2_:TransitionItem = TransitionItem(param1.target);
         var _loc3_:* = _loc2_.type;
         if(TransitionActionType.XY !== _loc3_)
         {
            if(1 !== _loc3_)
            {
               if(2 !== _loc3_)
               {
                  if(13 !== _loc3_)
                  {
                     if(4 !== _loc3_)
                     {
                        if(5 !== _loc3_)
                        {
                           if(6 !== _loc3_)
                           {
                              if(12 !== _loc3_)
                              {
                                 if(11 === _loc3_)
                                 {
                                    _loc2_.value.offsetX = param1.deltaValue.x;
                                    _loc2_.value.offsetY = param1.deltaValue.y;
                                 }
                              }
                              else
                              {
                                 _loc2_.value.f1 = param1.value.x;
                                 _loc2_.value.f2 = param1.value.y;
                                 _loc2_.value.f3 = param1.value.z;
                                 _loc2_.value.f4 = param1.value.w;
                              }
                           }
                           else
                           {
                              _loc2_.value.f1 = param1.value.color;
                           }
                        }
                     }
                     _loc2_.value.f1 = param1.value.x;
                  }
                  addr141:
                  applyValue(_loc2_);
                  return;
               }
               addr16:
               _loc2_.value.f1 = param1.value.x;
               _loc2_.value.f2 = param1.value.y;
               if(_loc2_.tweenConfig.path)
               {
                  _loc2_.value.f1 = _loc2_.value.f1 + param1.startValue.x;
                  _loc2_.value.f2 = _loc2_.value.f2 + param1.startValue.y;
               }
               §§goto(addr141);
            }
            addr15:
            §§goto(addr16);
         }
         §§goto(addr15);
      }
      
      private function onTweenComplete(param1:GTweener) : void
      {
         var _loc2_:TransitionItem = TransitionItem(param1.target);
         _loc2_.tweener = null;
         _totalTasks = Number(_totalTasks) - 1;
         if(param1.allCompleted)
         {
            callHook(_loc2_,true);
         }
         checkAllComplete();
      }
      
      private function onPlayTransCompleted(param1:TransitionItem) : void
      {
         _totalTasks = Number(_totalTasks) - 1;
         checkAllComplete();
      }
      
      private function callHook(param1:TransitionItem, param2:Boolean) : void
      {
         if(param2)
         {
            if(param1.tweenConfig != null && param1.tweenConfig.endHook != null)
            {
               param1.tweenConfig.endHook();
            }
         }
         else if(param1.time >= _startTime && param1.hook != null)
         {
            param1.hook();
         }
      }
      
      private function checkAllComplete() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(_playing && _totalTasks == 0)
         {
            if(_totalTimes < 0)
            {
               internalPlay();
            }
            else
            {
               _totalTimes = Number(_totalTimes) - 1;
               if(_totalTimes > 0)
               {
                  internalPlay();
               }
               else
               {
                  _playing = false;
                  _loc4_ = _items.length;
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc1_ = _items[_loc5_];
                     if(_loc1_.target != null && _loc1_.displayLockToken != 0)
                     {
                        _loc1_.target.releaseDisplayLock(_loc1_.displayLockToken);
                        _loc1_.displayLockToken = 0;
                     }
                     _loc5_++;
                  }
                  if(_onComplete != null)
                  {
                     _loc2_ = _onComplete;
                     _loc3_ = _onCompleteParam;
                     _onComplete = null;
                     _onCompleteParam = null;
                     if(_loc2_.length > 0)
                     {
                        _loc2_(_loc3_);
                     }
                     else
                     {
                        _loc2_();
                     }
                  }
               }
            }
         }
      }
      
      private function applyValue(param1:TransitionItem) : void
      {
         var _loc9_:* = null;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc6_:* = null;
         param1.target._gearLocked = true;
         var _loc8_:Object = param1.value;
         var _loc10_:* = param1.type;
         if(TransitionActionType.XY !== _loc10_)
         {
            if(1 !== _loc10_)
            {
               if(3 !== _loc10_)
               {
                  if(4 !== _loc10_)
                  {
                     if(5 !== _loc10_)
                     {
                        if(2 !== _loc10_)
                        {
                           if(13 !== _loc10_)
                           {
                              if(6 !== _loc10_)
                              {
                                 if(7 !== _loc10_)
                                 {
                                    if(8 !== _loc10_)
                                    {
                                       if(10 !== _loc10_)
                                       {
                                          if(9 !== _loc10_)
                                          {
                                             if(11 !== _loc10_)
                                             {
                                                if(12 !== _loc10_)
                                                {
                                                   if(14 !== _loc10_)
                                                   {
                                                      if(15 === _loc10_)
                                                      {
                                                         param1.target.icon = _loc8_.text;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      param1.target.text = _loc8_.text;
                                                   }
                                                }
                                                else
                                                {
                                                   _loc2_ = param1.target.filters;
                                                   if(_loc2_ == null || !(_loc2_[0] is ColorMatrixFilter))
                                                   {
                                                      _loc3_ = new ColorMatrixFilter();
                                                      _loc2_ = [_loc3_];
                                                   }
                                                   else
                                                   {
                                                      _loc3_ = ColorMatrixFilter(_loc2_[0]);
                                                   }
                                                   _loc6_ = new ColorMatrix();
                                                   _loc6_.adjustBrightness(_loc8_.f1);
                                                   _loc6_.adjustContrast(_loc8_.f2);
                                                   _loc6_.adjustSaturation(_loc8_.f3);
                                                   _loc6_.adjustHue(_loc8_.f4);
                                                   _loc3_.matrix = _loc6_;
                                                   param1.target.filters = _loc2_;
                                                }
                                             }
                                             else
                                             {
                                                param1.target.setXY(param1.target.x - _loc8_.lastOffsetX + _loc8_.offsetX,param1.target.y - _loc8_.lastOffsetY + _loc8_.offsetY);
                                                _loc8_.lastOffsetX = _loc8_.offsetX;
                                                _loc8_.lastOffsetY = _loc8_.offsetY;
                                             }
                                          }
                                          else if(_playing && param1.time >= _startTime)
                                          {
                                             if(_loc8_.audioClip == null)
                                             {
                                                _loc4_ = UIPackage.getItemByURL(_loc8_.sound);
                                                if(_loc4_)
                                                {
                                                   _loc8_.audioClip = _loc4_.owner.getSound(_loc4_);
                                                }
                                             }
                                             if(_loc8_.audioClip)
                                             {
                                                GRoot.inst.playOneShotSound(_loc8_.audioClip,_loc8_.volume);
                                             }
                                          }
                                       }
                                       else if(_playing)
                                       {
                                          _loc9_ = _loc8_.trans;
                                          if(_loc9_ != null)
                                          {
                                             _totalTasks = Number(_totalTasks) + 1;
                                             _loc5_ = _startTime > param1.time?_startTime - param1.time:0;
                                             _loc7_ = _endTime >= 0?_endTime - param1.time:-1;
                                             if(_loc8_.stopTime >= 0 && (_loc7_ < 0 || _loc7_ > _loc8_.stopTime))
                                             {
                                                _loc7_ = _loc8_.stopTime;
                                             }
                                             _loc9_.timeScale = _timeScale;
                                             _loc9_._play(onPlayTransCompleted,param1,_loc8_.playTimes,0,_loc5_,_loc7_,_reversed);
                                          }
                                       }
                                    }
                                    else
                                    {
                                       param1.target.visible = _loc8_.visible;
                                    }
                                 }
                                 else
                                 {
                                    if(_loc8_.frame >= 0)
                                    {
                                       param1.target.setProp(5,_loc8_.frame);
                                    }
                                    param1.target.setProp(4,_loc8_.playing);
                                    param1.target.setProp(7,_timeScale);
                                 }
                              }
                              else
                              {
                                 param1.target.setProp(2,_loc8_.f1);
                              }
                           }
                        }
                        else
                        {
                           param1.target.setScale(_loc8_.f1,_loc8_.f2);
                        }
                     }
                     else
                     {
                        param1.target.rotation = _loc8_.f1;
                     }
                  }
                  else
                  {
                     param1.target.alpha = _loc8_.f1;
                  }
               }
               else
               {
                  param1.target.setPivot(_loc8_.f1,_loc8_.f2,param1.target.pivotAsAnchor);
               }
            }
            else
            {
               if(!_loc8_.b1)
               {
                  _loc8_.f1 = param1.target.width;
               }
               if(!_loc8_.b2)
               {
                  _loc8_.f2 = param1.target.height;
               }
               param1.target.setSize(_loc8_.f1,_loc8_.f2);
            }
         }
         else if(param1.target == _owner)
         {
            if(_loc8_.b1 && _loc8_.b2)
            {
               param1.target.setXY(_loc8_.f1 + _ownerBaseX,_loc8_.f2 + _ownerBaseY);
            }
            else if(_loc8_.b1)
            {
               param1.target.x = _loc8_.f1 + _ownerBaseX;
            }
            else
            {
               param1.target.y = _loc8_.f2 + _ownerBaseY;
            }
         }
         else if(_loc8_.b3)
         {
            if(_loc8_.b1 && _loc8_.b2)
            {
               param1.target.setXY(_loc8_.f1 * _owner.width,_loc8_.f2 * _owner.height);
            }
            else if(_loc8_.b1)
            {
               param1.target.x = _loc8_.f1 * _owner.width;
            }
            else if(_loc8_.b2)
            {
               param1.target.y = _loc8_.f2 * _owner.height;
            }
         }
         else if(_loc8_.b1 && _loc8_.b2)
         {
            param1.target.setXY(_loc8_.f1,_loc8_.f2);
         }
         else if(_loc8_.b1)
         {
            param1.target.x = _loc8_.f1;
         }
         else if(_loc8_.b2)
         {
            param1.target.y = _loc8_.f2;
         }
         param1.target._gearLocked = false;
      }
      
      public function setup(param1:XML) : void
      {
         var _loc7_:* = NaN;
         var _loc6_:* = null;
         var _loc9_:* = null;
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc8_:* = null;
         this.name = param1.@name;
         var _loc2_:String = param1.@options;
         if(_loc2_)
         {
            _options = parseInt(_loc2_);
         }
         _autoPlay = param1.@autoPlay == "true";
         if(_autoPlay)
         {
            _loc2_ = param1.@autoPlayRepeat;
            if(_loc2_)
            {
               _autoPlayTimes = parseInt(_loc2_);
            }
            _loc2_ = param1.@autoPlayDelay;
            if(_loc2_)
            {
               _autoPlayDelay = parseFloat(_loc2_);
            }
         }
         _loc2_ = param1.@fps;
         if(_loc2_)
         {
            _loc7_ = Number(1 / parseInt(_loc2_));
         }
         else
         {
            _loc7_ = 0.0416666666666667;
         }
         var _loc4_:XMLList = param1.item;
         var _loc14_:int = 0;
         var _loc13_:* = _loc4_;
         for each(var _loc12_ in _loc4_)
         {
            _loc6_ = new TransitionItem(parseItemType(_loc12_.@type));
            _items.push(_loc6_);
            _loc6_.time = parseInt(_loc12_.@time) * _loc7_;
            _loc6_.targetId = _loc12_.@target;
            if(_loc12_.@tween == "true")
            {
               _loc6_.tweenConfig = new TweenConfig();
            }
            _loc6_.label = _loc12_.@label;
            if(_loc6_.label.length == 0)
            {
               _loc6_.label = null;
            }
            if(_loc6_.tweenConfig != null)
            {
               _loc6_.tweenConfig.duration = parseInt(_loc12_.@duration) * _loc7_;
               if(_loc6_.time + _loc6_.tweenConfig.duration > _totalDuration)
               {
                  _totalDuration = _loc6_.time + _loc6_.tweenConfig.duration;
               }
               _loc2_ = _loc12_.@ease;
               if(_loc2_)
               {
                  _loc6_.tweenConfig.easeType = EaseType.parseEaseType(_loc2_);
               }
               _loc6_.tweenConfig.repeat = parseInt(_loc12_.@repeat);
               _loc6_.tweenConfig.yoyo = _loc12_.@yoyo == "true";
               _loc6_.tweenConfig.endLabel = _loc12_.@label2;
               if(_loc6_.tweenConfig.endLabel.length == 0)
               {
                  _loc6_.tweenConfig.endLabel = null;
               }
               _loc9_ = _loc12_.@endValue;
               if(_loc9_)
               {
                  decodeValue(_loc6_,_loc12_.@startValue,_loc6_.tweenConfig.startValue);
                  decodeValue(_loc6_,_loc9_,_loc6_.tweenConfig.endValue);
               }
               else
               {
                  _loc6_.tweenConfig = null;
                  decodeValue(_loc6_,_loc12_.@startValue,_loc6_.value);
               }
               _loc2_ = _loc12_.@path;
               if(_loc2_)
               {
                  _loc3_ = _loc2_.split(",");
                  _loc5_ = new GPath();
                  _loc6_.tweenConfig.path = _loc5_;
                  helperPathPoints.length = 0;
                  _loc10_ = _loc3_.length;
                  _loc11_ = 0;
                  while(_loc11_ < _loc10_)
                  {
                     _loc8_ = new GPathPoint();
                     _loc11_++;
                     _loc8_.curveType = parseInt(_loc3_[_loc11_]);
                     switch(int(_loc8_.curveType) - 1)
                     {
                        case 0:
                           _loc11_++;
                           _loc8_.x = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.y = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.control1_x = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.control1_y = parseInt(_loc3_[_loc11_]);
                           break;
                        case 1:
                           _loc11_++;
                           _loc8_.x = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.y = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.control1_x = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.control1_y = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.control2_x = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.control2_y = parseInt(_loc3_[_loc11_]);
                           _loc11_++;
                           _loc8_.smooth = _loc3_[_loc11_] == "1";
                     }
                     helperPathPoints.push(_loc8_);
                  }
                  _loc5_.create(helperPathPoints);
               }
            }
            else
            {
               if(_loc6_.time > _totalDuration)
               {
                  _totalDuration = _loc6_.time;
               }
               decodeValue(_loc6_,_loc12_.@value,_loc6_.value);
            }
         }
      }
      
      private function parseItemType(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = param1;
         if("XY" !== _loc3_)
         {
            if("Size" !== _loc3_)
            {
               if("Scale" !== _loc3_)
               {
                  if("Pivot" !== _loc3_)
                  {
                     if("Alpha" !== _loc3_)
                     {
                        if("Rotation" !== _loc3_)
                        {
                           if("Color" !== _loc3_)
                           {
                              if("Animation" !== _loc3_)
                              {
                                 if("Visible" !== _loc3_)
                                 {
                                    if("Sound" !== _loc3_)
                                    {
                                       if("Transition" !== _loc3_)
                                       {
                                          if("Shake" !== _loc3_)
                                          {
                                             if("ColorFilter" !== _loc3_)
                                             {
                                                if("Skew" !== _loc3_)
                                                {
                                                   if("Text" !== _loc3_)
                                                   {
                                                      if("Icon" !== _loc3_)
                                                      {
                                                         _loc2_ = 16;
                                                      }
                                                      else
                                                      {
                                                         _loc2_ = 15;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      _loc2_ = 14;
                                                   }
                                                }
                                                else
                                                {
                                                   _loc2_ = 13;
                                                }
                                             }
                                             else
                                             {
                                                _loc2_ = 12;
                                             }
                                          }
                                          else
                                          {
                                             _loc2_ = 11;
                                          }
                                       }
                                       else
                                       {
                                          _loc2_ = 10;
                                       }
                                    }
                                    else
                                    {
                                       _loc2_ = 9;
                                    }
                                 }
                                 else
                                 {
                                    _loc2_ = 8;
                                 }
                              }
                              else
                              {
                                 _loc2_ = 7;
                              }
                           }
                           else
                           {
                              _loc2_ = 6;
                           }
                        }
                        else
                        {
                           _loc2_ = 5;
                        }
                     }
                     else
                     {
                        _loc2_ = 4;
                     }
                  }
                  else
                  {
                     _loc2_ = 3;
                  }
               }
               else
               {
                  _loc2_ = 2;
               }
            }
            else
            {
               _loc2_ = 1;
            }
         }
         else
         {
            _loc2_ = TransitionActionType.XY;
         }
         return _loc2_;
      }
      
      private function decodeValue(param1:TransitionItem, param2:String, param3:Object) : void
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = param1.type;
         if(TransitionActionType.XY !== _loc6_)
         {
            if(1 !== _loc6_)
            {
               if(3 !== _loc6_)
               {
                  if(13 !== _loc6_)
                  {
                     if(4 !== _loc6_)
                     {
                        if(5 !== _loc6_)
                        {
                           if(2 !== _loc6_)
                           {
                              if(6 !== _loc6_)
                              {
                                 if(7 !== _loc6_)
                                 {
                                    if(8 !== _loc6_)
                                    {
                                       if(9 !== _loc6_)
                                       {
                                          if(10 !== _loc6_)
                                          {
                                             if(11 !== _loc6_)
                                             {
                                                if(12 !== _loc6_)
                                                {
                                                   if(14 !== _loc6_)
                                                   {
                                                      if(15 !== _loc6_)
                                                      {
                                                      }
                                                   }
                                                   param3.text = param2;
                                                }
                                                else
                                                {
                                                   _loc4_ = param2.split(",");
                                                   param3.f1 = parseFloat(_loc4_[0]);
                                                   param3.f2 = parseFloat(_loc4_[1]);
                                                   param3.f3 = parseFloat(_loc4_[2]);
                                                   param3.f4 = parseFloat(_loc4_[3]);
                                                }
                                             }
                                             else
                                             {
                                                _loc4_ = param2.split(",");
                                                param3.amplitude = parseFloat(_loc4_[0]);
                                                param3.duration = parseFloat(_loc4_[1]);
                                             }
                                          }
                                          else
                                          {
                                             _loc4_ = param2.split(",");
                                             param3.transName = _loc4_[0];
                                             if(_loc4_.length > 1)
                                             {
                                                param3.playTimes = parseInt(_loc4_[1]);
                                             }
                                             else
                                             {
                                                param3.playTimes = 1;
                                             }
                                          }
                                       }
                                       else
                                       {
                                          _loc4_ = param2.split(",");
                                          param3.sound = _loc4_[0];
                                          if(_loc4_.length > 1)
                                          {
                                             _loc5_ = parseInt(_loc4_[1]);
                                             if(_loc5_ == 0 || _loc5_ == 100)
                                             {
                                                param3.volume = 1;
                                             }
                                             else
                                             {
                                                param3.volume = _loc5_ / 100;
                                             }
                                          }
                                          else
                                          {
                                             param3.volume = 1;
                                          }
                                       }
                                    }
                                    else
                                    {
                                       param3.visible = param2 == "true";
                                    }
                                 }
                                 else
                                 {
                                    _loc4_ = param2.split(",");
                                    if(_loc4_[0] == "-")
                                    {
                                       param3.frame = -1;
                                    }
                                    else
                                    {
                                       param3.frame = parseInt(_loc4_[0]);
                                    }
                                    param3.playing = _loc4_[1] == "p";
                                 }
                              }
                              else
                              {
                                 param3.f1 = ToolSet.convertFromHtmlColor(param2);
                              }
                           }
                           else
                           {
                              _loc4_ = param2.split(",");
                              param3.f1 = parseFloat(_loc4_[0]);
                              param3.f2 = parseFloat(_loc4_[1]);
                           }
                        }
                        else
                        {
                           param3.f1 = parseFloat(param2);
                        }
                     }
                     else
                     {
                        param3.f1 = parseFloat(param2);
                     }
                  }
                  addr368:
                  return;
               }
               addr13:
               _loc4_ = param2.split(",");
               if(_loc4_[0] == "-")
               {
                  param3.b1 = false;
               }
               else
               {
                  param3.f1 = parseFloat(_loc4_[0]);
                  param3.b1 = true;
               }
               if(_loc4_[1] == "-")
               {
                  param3.b2 = false;
               }
               else
               {
                  param3.f2 = parseFloat(_loc4_[1]);
                  param3.b2 = true;
               }
               if(_loc4_.length > 2 && param1.type == TransitionActionType.XY)
               {
                  param3.b3 = true;
                  param3.f1 = parseFloat(_loc4_[2]);
                  param3.f2 = parseFloat(_loc4_[3]);
               }
               §§goto(addr368);
            }
            addr12:
            §§goto(addr13);
         }
         §§goto(addr12);
      }
   }
}

class TransitionActionType
{
   
   public static const XY:int = 0;
   
   public static const Size:int = 1;
   
   public static const Scale:int = 2;
   
   public static const Pivot:int = 3;
   
   public static const Alpha:int = 4;
   
   public static const Rotation:int = 5;
   
   public static const Color:int = 6;
   
   public static const Animation:int = 7;
   
   public static const Visible:int = 8;
   
   public static const Sound:int = 9;
   
   public static const Transition:int = 10;
   
   public static const Shake:int = 11;
   
   public static const ColorFilter:int = 12;
   
   public static const Skew:int = 13;
   
   public static const Text:int = 14;
   
   public static const Icon:int = 15;
   
   public static const Unknown:int = 16;
    
   
   function TransitionActionType()
   {
      super();
   }
}

import fairygui.GObject;
import fairygui.tween.GTweener;

class TransitionItem
{
    
   
   public var time:Number;
   
   public var targetId:String;
   
   public var type:int;
   
   public var tweenConfig:TweenConfig;
   
   public var label:String;
   
   public var value:Object;
   
   public var hook:Function;
   
   public var tweener:GTweener;
   
   public var target:GObject;
   
   public var displayLockToken:uint;
   
   function TransitionItem(param1:int)
   {
      super();
      this.type = param1;
      switch(int(param1))
      {
         case 0:
         case 1:
         case 2:
         case 3:
         case 4:
         case 5:
         case 6:
            value = new TValue();
            break;
         case 7:
            value = new TValue_Animation();
            break;
         case 8:
            value = new TValue_Visible();
            break;
         case 9:
            value = new TValue_Sound();
            break;
         case 10:
            value = new TValue_Transition();
            break;
         case 11:
         case 12:
         case 13:
            value = new TValue_Shake();
            break;
         case 14:
         case 15:
            value = new TValue_Text();
      }
   }
}

import fairygui.tween.GPath;

class TweenConfig
{
    
   
   public var duration:Number;
   
   public var easeType:int;
   
   public var repeat:int;
   
   public var yoyo:Boolean;
   
   public var startValue:TValue;
   
   public var endValue:TValue;
   
   public var path:GPath;
   
   public var endLabel:String;
   
   public var endHook:Function;
   
   function TweenConfig()
   {
      super();
      easeType = 5;
      startValue = new TValue();
      endValue = new TValue();
   }
}

class TValue_Visible
{
    
   
   public var visible:Boolean;
   
   function TValue_Visible()
   {
      super();
   }
}

class TValue_Animation
{
    
   
   public var frame:int;
   
   public var playing:Boolean;
   
   public var flag:Boolean;
   
   function TValue_Animation()
   {
      super();
   }
}

import flash.media.Sound;

class TValue_Sound
{
    
   
   public var sound:String;
   
   public var volume:Number;
   
   public var audioClip:Sound;
   
   function TValue_Sound()
   {
      super();
   }
}

import fairygui.Transition;

class TValue_Transition
{
    
   
   public var transName:String;
   
   public var playTimes:int;
   
   public var trans:Transition;
   
   public var stopTime:Number;
   
   function TValue_Transition()
   {
      super();
   }
}

class TValue_Shake
{
    
   
   public var amplitude:Number;
   
   public var duration:Number;
   
   public var offsetX:Number;
   
   public var offsetY:Number;
   
   public var lastOffsetX:Number;
   
   public var lastOffsetY:Number;
   
   function TValue_Shake()
   {
      super();
   }
}

class TValue_Text
{
    
   
   public var text:String;
   
   function TValue_Text()
   {
      super();
   }
}

class TValue
{
    
   
   public var f1:Number;
   
   public var f2:Number;
   
   public var f3:Number;
   
   public var f4:Number;
   
   public var b1:Boolean;
   
   public var b2:Boolean;
   
   public var b3:Boolean;
   
   function TValue()
   {
      super();
      b2 = true;
      b1 = true;
   }
}

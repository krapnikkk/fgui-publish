package fairygui
{
   import com.greensock.TweenMax;
   import com.greensock.easing.EaseLookup;
   import fairygui.utils.ColorMatrix;
   import fairygui.utils.GTimers;
   import fairygui.utils.ToolSet;
   import flash.filters.ColorMatrixFilter;
   import flash.media.Sound;
   import flash.utils.getTimer;
   
   public class Transition
   {
       
      
      public var name:String;
      
      public var autoPlayRepeat:int;
      
      public var autoPlayDelay:Number;
      
      private var _owner:GComponent;
      
      private var _ownerBaseX:Number;
      
      private var _ownerBaseY:Number;
      
      private var _items:Vector.<TransitionItem>;
      
      private var _totalTimes:int;
      
      private var _totalTasks:int;
      
      private var _playing:Boolean;
      
      private var _onComplete:Function;
      
      private var _onCompleteParam:Object;
      
      private var _options:int;
      
      private var _reversed:Boolean;
      
      private var _maxTime:Number;
      
      private var _autoPlay:Boolean;
      
      private var _timeScale:Number;
      
      public const OPTION_IGNORE_DISPLAY_CONTROLLER:int = 1;
      
      public const OPTION_AUTO_STOP_DISABLED:int = 2;
      
      public const OPTION_AUTO_STOP_AT_END:int = 4;
      
      private const FRAME_RATE:int = 24;
      
      public function Transition(param1:GComponent)
      {
         super();
         _owner = param1;
         _items = new Vector.<TransitionItem>();
         _maxTime = 0;
         autoPlayDelay = 0;
         _timeScale = 1;
      }
      
      public function get autoPlay() : Boolean
      {
         return _autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         if(_autoPlay != param1)
         {
            _autoPlay = param1;
            if(_autoPlay)
            {
               if(_owner.onStage)
               {
                  play(null,null,autoPlayRepeat,autoPlayDelay);
               }
            }
            else if(!_owner.onStage)
            {
               stop(false,true);
            }
         }
      }
      
      public function play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0) : void
      {
         _play(param1,param2,param3,param4,false);
      }
      
      public function playReverse(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0) : void
      {
         _play(param1,param2,1,param4,true);
      }
      
      public function changeRepeat(param1:int) : void
      {
         _totalTimes = param1;
      }
      
      private function _play(param1:Function = null, param2:Object = null, param3:int = 1, param4:Number = 0, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc7_:* = null;
         stop();
         _totalTimes = param3;
         _reversed = param5;
         internalPlay(param4);
         _playing = _totalTasks > 0;
         if(_playing)
         {
            _onComplete = param1;
            _onCompleteParam = param2;
            if((_options & 1) != 0)
            {
               _loc6_ = _items.length;
               _loc8_ = 0;
               while(_loc8_ < _loc6_)
               {
                  _loc7_ = _items[_loc8_];
                  if(_loc7_.target != null && _loc7_.target != _owner)
                  {
                     _loc7_.displayLockToken = _loc7_.target.addDisplayLock();
                  }
                  _loc8_++;
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
      
      public function stop(param1:Boolean = true, param2:Boolean = false) : void
      {
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:* = null;
         if(_playing)
         {
            _playing = false;
            _totalTasks = 0;
            _totalTimes = 0;
            _loc6_ = _onComplete;
            _loc4_ = _onCompleteParam;
            _onComplete = null;
            _onCompleteParam = null;
            _loc3_ = _items.length;
            if(_reversed)
            {
               _loc7_ = _loc3_ - 1;
               while(_loc7_ >= 0)
               {
                  _loc5_ = _items[_loc7_];
                  if(_loc5_.target != null)
                  {
                     stopItem(_loc5_,param1);
                  }
                  _loc7_--;
               }
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < _loc3_)
               {
                  _loc5_ = _items[_loc7_];
                  if(_loc5_.target != null)
                  {
                     stopItem(_loc5_,param1);
                  }
                  _loc7_++;
               }
            }
            if(param2 && _loc6_ != null)
            {
               if(_loc6_.length > 0)
               {
                  _loc6_(_loc4_);
               }
               else
               {
                  _loc6_();
               }
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
         if(param1.type == 12 && param1.filterCreated)
         {
            param1.target.filters = null;
         }
         if(param1.completed)
         {
            return;
         }
         if(param1.tweener != null)
         {
            param1.tweener.kill();
            param1.tweener = null;
         }
         if(param1.type == 10)
         {
            _loc3_ = GComponent(param1.target).getTransition(param1.value.s);
            if(_loc3_ != null)
            {
               _loc3_.stop(param2,false);
            }
         }
         else if(param1.type == 11)
         {
            if(GTimers.inst.exists(param1.__shake))
            {
               GTimers.inst.remove(param1.__shake);
               param1.target._gearLocked = true;
               param1.target.setXY(param1.target.x - param1.startValue.f1,param1.target.y - param1.startValue.f2);
               param1.target._gearLocked = false;
            }
         }
         else if(param2)
         {
            if(param1.tween)
            {
               if(!param1.yoyo || param1.repeat % 2 == 0)
               {
                  applyValue(param1,!!_reversed?param1.startValue:param1.endValue);
               }
               else
               {
                  applyValue(param1,!!_reversed?param1.endValue:param1.startValue);
               }
            }
            else if(param1.type != 9)
            {
               applyValue(param1,param1.value);
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc4_:int = 0;
         var _loc3_:* = null;
         var _loc1_:* = null;
         if(!_playing)
         {
            return;
         }
         _playing = false;
         var _loc2_:int = _items.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _items[_loc4_];
            if(!(_loc3_.target == null || _loc3_.completed))
            {
               if(_loc3_.tweener != null)
               {
                  _loc3_.tweener.kill();
                  _loc3_.tweener = null;
               }
               if(_loc3_.type == 10)
               {
                  _loc1_ = GComponent(_loc3_.target).getTransition(_loc3_.value.s);
                  if(_loc1_ != null)
                  {
                     _loc1_.dispose();
                  }
               }
               else if(_loc3_.type == 11)
               {
                  GTimers.inst.remove(_loc3_.__shake);
               }
            }
            _loc4_++;
         }
      }
      
      public function get playing() : Boolean
      {
         return _playing;
      }
      
      public function setValue(param1:String, ... rest) : void
      {
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc4_:* = null;
         var _loc3_:int = _items.length;
         _loc6_ = 0;
         for(; _loc6_ < _loc3_; _loc6_++)
         {
            _loc4_ = _items[_loc6_];
            if(!(_loc4_.label == null && _loc4_.label2 == null))
            {
               if(_loc4_.label == param1)
               {
                  if(_loc4_.tween)
                  {
                     _loc5_ = _loc4_.startValue;
                  }
                  else
                  {
                     _loc5_ = _loc4_.value;
                  }
               }
               else if(_loc4_.label2 == param1)
               {
                  _loc5_ = _loc4_.endValue;
               }
               else
               {
                  continue;
               }
               var _loc7_:* = _loc4_.type;
               if(TransitionActionType.XY !== _loc7_)
               {
                  if(1 !== _loc7_)
                  {
                     if(3 !== _loc7_)
                     {
                        if(2 !== _loc7_)
                        {
                           if(13 !== _loc7_)
                           {
                              if(4 !== _loc7_)
                              {
                                 if(5 !== _loc7_)
                                 {
                                    if(6 !== _loc7_)
                                    {
                                       if(7 !== _loc7_)
                                       {
                                          if(8 !== _loc7_)
                                          {
                                             if(9 !== _loc7_)
                                             {
                                                if(10 !== _loc7_)
                                                {
                                                   if(11 !== _loc7_)
                                                   {
                                                      if(12 === _loc7_)
                                                      {
                                                         _loc5_.f1 = parseFloat(rest[0]);
                                                         _loc5_.f2 = parseFloat(rest[1]);
                                                         _loc5_.f3 = parseFloat(rest[2]);
                                                         _loc5_.f4 = parseFloat(rest[3]);
                                                         continue;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      _loc5_.f1 = parseFloat(rest[0]);
                                                      if(rest.length > 1)
                                                      {
                                                         _loc5_.f2 = parseFloat(rest[1]);
                                                      }
                                                   }
                                                }
                                                else
                                                {
                                                   _loc5_.s = rest[0];
                                                   if(rest.length > 1)
                                                   {
                                                      _loc5_.i = parseInt(rest[1]);
                                                   }
                                                }
                                             }
                                             else
                                             {
                                                _loc5_.s = rest[0];
                                                if(rest.length > 1)
                                                {
                                                   _loc5_.f1 = parseFloat(rest[1]);
                                                }
                                             }
                                          }
                                          else
                                          {
                                             _loc5_.b = rest[0];
                                          }
                                       }
                                       else
                                       {
                                          _loc5_.i = parseInt(rest[0]);
                                          if(rest.length > 1)
                                          {
                                             _loc5_.b = rest[1];
                                          }
                                       }
                                    }
                                    else
                                    {
                                       _loc5_.c = parseFloat(rest[0]);
                                    }
                                 }
                                 else
                                 {
                                    _loc5_.f1 = parseInt(rest[0]);
                                 }
                              }
                              else
                              {
                                 _loc5_.f1 = parseFloat(rest[0]);
                              }
                              continue;
                           }
                        }
                        addr68:
                        _loc5_.b1 = true;
                        _loc5_.b2 = true;
                        _loc5_.f1 = parseFloat(rest[0]);
                        _loc5_.f2 = parseFloat(rest[1]);
                        continue;
                     }
                     addr67:
                     §§goto(addr68);
                  }
                  addr66:
                  §§goto(addr67);
               }
               §§goto(addr66);
            }
         }
      }
      
      public function setHook(param1:String, param2:Function) : void
      {
         var _loc5_:int = 0;
         var _loc4_:* = null;
         var _loc3_:int = _items.length;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _items[_loc5_];
            if(_loc4_.label == param1)
            {
               _loc4_.hook = param2;
               break;
            }
            if(_loc4_.label2 == param1)
            {
               _loc4_.hook2 = param2;
               break;
            }
            _loc5_++;
         }
      }
      
      public function clearHooks() : void
      {
         var _loc3_:int = 0;
         var _loc2_:* = null;
         var _loc1_:int = _items.length;
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = _items[_loc3_];
            _loc2_.hook = null;
            _loc2_.hook2 = null;
            _loc3_++;
         }
      }
      
      public function setTarget(param1:String, param2:GObject) : void
      {
         var _loc5_:int = 0;
         var _loc4_:* = null;
         var _loc3_:int = _items.length;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _items[_loc5_];
            if(_loc4_.label == param1)
            {
               _loc4_.targetId = param2.id;
            }
            _loc5_++;
         }
      }
      
      public function setDuration(param1:String, param2:Number) : void
      {
         var _loc5_:int = 0;
         var _loc4_:* = null;
         var _loc3_:int = _items.length;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _items[_loc5_];
            if(_loc4_.tween && _loc4_.label == param1)
            {
               _loc4_.duration = param2;
            }
            _loc5_++;
         }
      }
      
      public function get timeScale() : Number
      {
         return _timeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:* = null;
         _timeScale = param1;
         if(_playing)
         {
            _loc2_ = _items.length;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = _items[_loc4_];
               if(_loc3_.tweener != null)
               {
                  _loc3_.tweener.timeScale(_timeScale);
               }
               _loc4_++;
            }
         }
      }
      
      function updateFromRelations(param1:String, param2:Number, param3:Number) : void
      {
         var _loc6_:int = 0;
         var _loc5_:* = null;
         var _loc4_:int = _items.length;
         if(_loc4_ == 0)
         {
            return;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = _items[_loc6_];
            if(_loc5_.type == TransitionActionType.XY && _loc5_.targetId == param1)
            {
               if(_loc5_.tween)
               {
                  _loc5_.startValue.f1 = _loc5_.startValue.f1 + param2;
                  _loc5_.startValue.f2 = _loc5_.startValue.f2 + param3;
                  _loc5_.endValue.f1 = _loc5_.endValue.f1 + param2;
                  _loc5_.endValue.f2 = _loc5_.endValue.f2 + param3;
               }
               else
               {
                  _loc5_.value.f1 = _loc5_.value.f1 + param2;
                  _loc5_.value.f2 = _loc5_.value.f2 + param3;
               }
            }
            _loc6_++;
         }
      }
      
      function OnOwnerRemovedFromStage() : void
      {
         if((_options & 2) == 0)
         {
            stop((_options & 4) != 0?true:false,false);
         }
      }
      
      private function internalPlay(param1:Number) : void
      {
         var _loc3_:* = null;
         var _loc6_:int = 0;
         var _loc5_:* = null;
         var _loc2_:Number = NaN;
         _ownerBaseX = _owner.x;
         _ownerBaseY = _owner.y;
         _totalTasks = 0;
         var _loc4_:int = _items.length;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = _items[_loc6_];
            if(_loc5_.targetId)
            {
               _loc5_.target = _owner.getChildById(_loc5_.targetId);
            }
            else
            {
               _loc5_.target = _owner;
            }
            if(_loc5_.target != null)
            {
               if(_loc5_.tween)
               {
                  if(_reversed)
                  {
                     _loc2_ = param1 + _maxTime - _loc5_.time - _loc5_.duration;
                  }
                  else
                  {
                     _loc2_ = param1 + _loc5_.time;
                  }
                  if(_loc2_ > 0 && (_loc5_.type == TransitionActionType.XY || _loc5_.type == 1))
                  {
                     _totalTasks = Number(_totalTasks) + 1;
                     _loc5_.completed = false;
                     _loc5_.tweener = TweenMax.delayedCall(_loc2_,__delayCall,_loc5_.params);
                     if(_timeScale != 1)
                     {
                        _loc5_.tweener.timeScale(_timeScale);
                     }
                  }
                  else
                  {
                     startTween(_loc5_,_loc2_);
                  }
               }
               else
               {
                  if(_reversed)
                  {
                     _loc2_ = param1 + _maxTime - _loc5_.time;
                  }
                  else
                  {
                     _loc2_ = param1 + _loc5_.time;
                  }
                  if(_loc2_ == 0)
                  {
                     applyValue(_loc5_,_loc5_.value);
                  }
                  else
                  {
                     _loc5_.completed = false;
                     _totalTasks = Number(_totalTasks) + 1;
                     _loc5_.tweener = TweenMax.delayedCall(_loc2_,__delayCall2,_loc5_.params);
                     if(_timeScale != 1)
                     {
                        _loc5_.tweener.timeScale(_timeScale);
                     }
                  }
               }
            }
            _loc6_++;
         }
      }
      
      private function startTween(param1:TransitionItem, param2:Number) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc5_:Object = {};
         _loc5_.onStart = __tweenStart;
         _loc5_.onStartParams = param1.params;
         _loc5_.onUpdate = __tweenUpdate;
         _loc5_.onUpdateParams = param1.params;
         _loc5_.onComplete = __tweenComplete;
         _loc5_.onCompleteParams = param1.params;
         _loc5_.ease = param1.easeType;
         if(_reversed)
         {
            _loc4_ = param1.endValue;
            _loc3_ = param1.startValue;
         }
         else
         {
            _loc4_ = param1.startValue;
            _loc3_ = param1.endValue;
         }
         var _loc6_:* = param1.type;
         if(TransitionActionType.XY !== _loc6_)
         {
            if(1 !== _loc6_)
            {
               if(2 !== _loc6_)
               {
                  if(13 !== _loc6_)
                  {
                     if(4 !== _loc6_)
                     {
                        if(5 !== _loc6_)
                        {
                           if(6 !== _loc6_)
                           {
                              if(12 === _loc6_)
                              {
                                 param1.value.f1 = _loc4_.f1;
                                 param1.value.f2 = _loc4_.f2;
                                 param1.value.f3 = _loc4_.f3;
                                 param1.value.f4 = _loc4_.f4;
                                 _loc5_.f1 = _loc3_.f1;
                                 _loc5_.f2 = _loc3_.f2;
                                 _loc5_.f3 = _loc3_.f3;
                                 _loc5_.f4 = _loc3_.f4;
                              }
                           }
                           else
                           {
                              param1.value.c = _loc4_.c;
                              _loc5_.hexColors = {"c":_loc3_.c};
                           }
                        }
                        else
                        {
                           param1.value.f1 = _loc4_.f1;
                           _loc5_.f1 = _loc3_.f1;
                        }
                     }
                     else
                     {
                        param1.value.f1 = _loc4_.f1;
                        _loc5_.f1 = _loc3_.f1;
                     }
                  }
               }
               param1.value.f1 = _loc4_.f1;
               param1.value.f2 = _loc4_.f2;
               _loc5_.f1 = _loc3_.f1;
               _loc5_.f2 = _loc3_.f2;
            }
            addr288:
            if(param2 > 0)
            {
               _loc5_.delay = param2;
            }
            else
            {
               applyValue(param1,param1.value);
            }
            if(param1.repeat != 0)
            {
               if(param1.repeat == -1)
               {
                  _loc5_.repeat = 2147483647;
               }
               else
               {
                  _loc5_.repeat = param1.repeat;
               }
               _loc5_.yoyo = param1.yoyo;
            }
            _totalTasks = Number(_totalTasks) + 1;
            param1.completed = false;
            param1.tweener = TweenMax.to(param1.value,param1.duration,_loc5_);
            if(_timeScale != 1)
            {
               param1.tweener.timeScale(_timeScale);
            }
            return;
         }
         if(param1.type == TransitionActionType.XY)
         {
            if(param1.target == _owner)
            {
               if(!_loc4_.b1)
               {
                  _loc4_.f1 = 0;
               }
               if(!_loc4_.b2)
               {
                  _loc4_.f2 = 0;
               }
            }
            else
            {
               if(!_loc4_.b1)
               {
                  _loc4_.f1 = param1.target.x;
               }
               if(!_loc4_.b2)
               {
                  _loc4_.f2 = param1.target.y;
               }
            }
         }
         else
         {
            if(!_loc4_.b1)
            {
               _loc4_.f1 = param1.target.width;
            }
            if(!_loc4_.b2)
            {
               _loc4_.f2 = param1.target.height;
            }
         }
         param1.value.f1 = _loc4_.f1;
         param1.value.f2 = _loc4_.f2;
         if(!_loc3_.b1)
         {
            _loc3_.f1 = param1.value.f1;
         }
         if(!_loc3_.b2)
         {
            _loc3_.f2 = param1.value.f2;
         }
         param1.value.b1 = _loc4_.b1 || _loc3_.b1;
         param1.value.b2 = _loc4_.b2 || _loc3_.b2;
         _loc5_.f1 = _loc3_.f1;
         _loc5_.f2 = _loc3_.f2;
         §§goto(addr288);
      }
      
      private function __delayCall(param1:TransitionItem) : void
      {
         param1.tweener = null;
         _totalTasks = Number(_totalTasks) - 1;
         startTween(param1,0);
      }
      
      private function __delayCall2(param1:TransitionItem) : void
      {
         param1.tweener = null;
         _totalTasks = Number(_totalTasks) - 1;
         param1.completed = true;
         applyValue(param1,param1.value);
         if(param1.hook != null)
         {
            param1.hook();
         }
         checkAllComplete();
      }
      
      private function __tweenStart(param1:TransitionItem) : void
      {
         if(param1.hook != null)
         {
            param1.hook();
         }
      }
      
      private function __tweenUpdate(param1:TransitionItem) : void
      {
         applyValue(param1,param1.value);
      }
      
      private function __tweenComplete(param1:TransitionItem) : void
      {
         param1.tweener = null;
         _totalTasks = Number(_totalTasks) - 1;
         param1.completed = true;
         if(param1.hook2 != null)
         {
            param1.hook2();
         }
         checkAllComplete();
      }
      
      private function __playTransComplete(param1:TransitionItem) : void
      {
         _totalTasks = Number(_totalTasks) - 1;
         param1.completed = true;
         checkAllComplete();
      }
      
      private function checkAllComplete() : void
      {
         var _loc1_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = null;
         if(_playing && _totalTasks == 0)
         {
            if(_totalTimes < 0)
            {
               internalPlay(0);
            }
            else
            {
               _totalTimes = Number(_totalTimes) - 1;
               if(_totalTimes > 0)
               {
                  internalPlay(0);
               }
               else
               {
                  _playing = false;
                  _loc1_ = _items.length;
                  _loc5_ = 0;
                  while(_loc5_ < _loc1_)
                  {
                     _loc3_ = _items[_loc5_];
                     if(_loc3_.target != null)
                     {
                        if(_loc3_.displayLockToken != 0)
                        {
                           _loc3_.target.releaseDisplayLock(_loc3_.displayLockToken);
                           _loc3_.displayLockToken = 0;
                        }
                        if(_loc3_.filterCreated)
                        {
                           _loc3_.filterCreated = false;
                           _loc3_.target.filters = null;
                        }
                     }
                     _loc5_++;
                  }
                  if(_onComplete != null)
                  {
                     _loc4_ = _onComplete;
                     _loc2_ = _onCompleteParam;
                     _onComplete = null;
                     _onCompleteParam = null;
                     if(_loc4_.length > 0)
                     {
                        _loc4_(_loc2_);
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
      
      private function applyValue(param1:TransitionItem, param2:TransitionValue) : void
      {
         var _loc10_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc3_:* = null;
         var _loc9_:* = null;
         var _loc6_:* = null;
         var _loc8_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         param1.target._gearLocked = true;
         var _loc11_:* = param1.type;
         if(TransitionActionType.XY !== _loc11_)
         {
            if(1 !== _loc11_)
            {
               if(3 !== _loc11_)
               {
                  if(4 !== _loc11_)
                  {
                     if(5 !== _loc11_)
                     {
                        if(2 !== _loc11_)
                        {
                           if(13 !== _loc11_)
                           {
                              if(6 !== _loc11_)
                              {
                                 if(7 !== _loc11_)
                                 {
                                    if(8 !== _loc11_)
                                    {
                                       if(10 !== _loc11_)
                                       {
                                          if(9 !== _loc11_)
                                          {
                                             if(11 !== _loc11_)
                                             {
                                                if(12 === _loc11_)
                                                {
                                                   _loc5_ = param1.target.filters;
                                                   if(_loc5_ == null || !(_loc5_[0] is ColorMatrixFilter))
                                                   {
                                                      _loc8_ = new ColorMatrixFilter();
                                                      _loc5_ = [_loc8_];
                                                      param1.filterCreated = true;
                                                   }
                                                   else
                                                   {
                                                      _loc8_ = ColorMatrixFilter(_loc5_[0]);
                                                   }
                                                   _loc4_ = new ColorMatrix();
                                                   _loc4_.adjustBrightness(param2.f1);
                                                   _loc4_.adjustContrast(param2.f2);
                                                   _loc4_.adjustSaturation(param2.f3);
                                                   _loc4_.adjustHue(param2.f4);
                                                   _loc8_.matrix = _loc4_;
                                                   param1.target.filters = _loc5_;
                                                }
                                             }
                                             else
                                             {
                                                param1.startValue.f1 = 0;
                                                param1.startValue.f2 = 0;
                                                param1.startValue.f3 = param1.value.f2;
                                                param1.startValue.i = getTimer();
                                                GTimers.inst.add(1,0,param1.__shake,this.shakeItem);
                                                _totalTasks = Number(_totalTasks) + 1;
                                                param1.completed = false;
                                             }
                                          }
                                          else
                                          {
                                             _loc9_ = UIPackage.getItemByURL(param2.s);
                                             if(_loc9_)
                                             {
                                                _loc6_ = _loc9_.owner.getSound(_loc9_);
                                                if(_loc6_)
                                                {
                                                   GRoot.inst.playOneShotSound(_loc6_,param2.f1);
                                                }
                                             }
                                          }
                                       }
                                       else
                                       {
                                          _loc3_ = GComponent(param1.target).getTransition(param2.s);
                                          if(_loc3_ != null)
                                          {
                                             if(param2.i == 0)
                                             {
                                                _loc3_.stop(false,true);
                                             }
                                             else if(_loc3_.playing)
                                             {
                                                _loc3_._totalTimes = param2.i;
                                             }
                                             else
                                             {
                                                param1.completed = false;
                                                _totalTasks = Number(_totalTasks) + 1;
                                                if(_reversed)
                                                {
                                                   _loc3_.playReverse(__playTransComplete,param1,param2.i);
                                                }
                                                else
                                                {
                                                   _loc3_.play(__playTransComplete,param1,param2.i);
                                                }
                                                if(_timeScale != 1)
                                                {
                                                   _loc3_.timeScale = _timeScale;
                                                }
                                             }
                                          }
                                       }
                                    }
                                    else
                                    {
                                       param1.target.visible = param2.b;
                                    }
                                 }
                                 else
                                 {
                                    if(!param2.b1)
                                    {
                                       param2.i = IAnimationGear(param1.target).frame;
                                    }
                                    IAnimationGear(param1.target).frame = param2.i;
                                    IAnimationGear(param1.target).playing = param2.b;
                                 }
                              }
                              else
                              {
                                 IColorGear(param1.target).color = param2.c;
                              }
                           }
                        }
                        else
                        {
                           param1.target.setScale(param2.f1,param2.f2);
                        }
                     }
                     else
                     {
                        param1.target.rotation = param2.f1;
                     }
                  }
                  else
                  {
                     param1.target.alpha = param2.f1;
                  }
               }
               else
               {
                  param1.target.setPivot(param2.f1,param2.f2);
               }
            }
            else
            {
               if(!param2.b1)
               {
                  param2.f1 = param1.target.width;
               }
               if(!param2.b2)
               {
                  param2.f2 = param1.target.height;
               }
               param1.target.setSize(param2.f1,param2.f2);
            }
         }
         else if(param1.target == _owner)
         {
            if(!param2.b1)
            {
               _loc7_ = param1.target.x;
            }
            else
            {
               _loc7_ = param2.f1 + _ownerBaseX;
            }
            if(!param2.b2)
            {
               _loc10_ = param1.target.y;
            }
            else
            {
               _loc10_ = param2.f2 + _ownerBaseY;
            }
            param1.target.setXY(_loc7_,_loc10_);
         }
         else
         {
            if(!param2.b1)
            {
               param2.f1 = param1.target.x;
            }
            if(!param2.b2)
            {
               param2.f2 = param1.target.y;
            }
            param1.target.setXY(param2.f1,param2.f2);
         }
         param1.target._gearLocked = false;
      }
      
      private function shakeItem(param1:TransitionItem) : void
      {
         var _loc3_:Number = Math.ceil(param1.value.f1 * param1.startValue.f3 / param1.value.f2);
         var _loc4_:Number = (Math.random() * 2 - 1) * _loc3_;
         var _loc5_:Number = (Math.random() * 2 - 1) * _loc3_;
         _loc4_ = _loc4_ > 0?Math.ceil(_loc4_):Math.floor(_loc4_);
         _loc5_ = _loc5_ > 0?Math.ceil(_loc5_):Math.floor(_loc5_);
         param1.target._gearLocked = true;
         param1.target.setXY(param1.target.x - param1.startValue.f1 + _loc4_,param1.target.y - param1.startValue.f2 + _loc5_);
         param1.target._gearLocked = false;
         param1.startValue.f1 = _loc4_;
         param1.startValue.f2 = _loc5_;
         var _loc2_:int = getTimer();
         param1.startValue.f3 = param1.startValue.f3 - (_loc2_ - param1.startValue.i) / 1000;
         param1.startValue.i = _loc2_;
         if(param1.startValue.f3 <= 0)
         {
            param1.target._gearLocked = true;
            param1.target.setXY(param1.target.x - param1.startValue.f1,param1.target.y - param1.startValue.f2);
            param1.target._gearLocked = false;
            param1.completed = true;
            _totalTasks = Number(_totalTasks) - 1;
            GTimers.inst.remove(param1.__shake);
            checkAllComplete();
         }
      }
      
      public function setup(param1:XML) : void
      {
         var _loc5_:* = null;
         var _loc7_:int = 0;
         var _loc2_:* = null;
         this.name = param1.@name;
         var _loc4_:String = param1.@options;
         if(_loc4_)
         {
            _options = parseInt(_loc4_);
         }
         this._autoPlay = param1.@autoPlay == "true";
         if(this._autoPlay)
         {
            _loc4_ = param1.@autoPlayRepeat;
            if(_loc4_)
            {
               this.autoPlayRepeat = parseInt(_loc4_);
            }
            _loc4_ = param1.@autoPlayDelay;
            if(_loc4_)
            {
               this.autoPlayDelay = parseFloat(_loc4_);
            }
         }
         var _loc3_:XMLList = param1.item;
         var _loc10_:int = 0;
         var _loc9_:* = _loc3_;
         for each(var _loc6_ in _loc3_)
         {
            _loc5_ = new TransitionItem();
            _items.push(_loc5_);
            _loc5_.time = parseInt(_loc6_.@time) / 24;
            _loc5_.targetId = _loc6_.@target;
            _loc4_ = _loc6_.@type;
            var _loc8_:* = _loc4_;
            if("XY" !== _loc8_)
            {
               if("XYV" !== _loc8_)
               {
                  if("Size" !== _loc8_)
                  {
                     if("Scale" !== _loc8_)
                     {
                        if("Pivot" !== _loc8_)
                        {
                           if("Alpha" !== _loc8_)
                           {
                              if("Rotation" !== _loc8_)
                              {
                                 if("Color" !== _loc8_)
                                 {
                                    if("Animation" !== _loc8_)
                                    {
                                       if("Visible" !== _loc8_)
                                       {
                                          if("Sound" !== _loc8_)
                                          {
                                             if("Transition" !== _loc8_)
                                             {
                                                if("Shake" !== _loc8_)
                                                {
                                                   if("ColorFilter" !== _loc8_)
                                                   {
                                                      if("Skew" !== _loc8_)
                                                      {
                                                         _loc5_.type = 14;
                                                      }
                                                      else
                                                      {
                                                         _loc5_.type = 13;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      _loc5_.type = 12;
                                                   }
                                                }
                                                else
                                                {
                                                   _loc5_.type = 11;
                                                }
                                             }
                                             else
                                             {
                                                _loc5_.type = 10;
                                             }
                                          }
                                          else
                                          {
                                             _loc5_.type = 9;
                                          }
                                       }
                                       else
                                       {
                                          _loc5_.type = 8;
                                       }
                                    }
                                    else
                                    {
                                       _loc5_.type = 7;
                                    }
                                 }
                                 else
                                 {
                                    _loc5_.type = 6;
                                 }
                              }
                              else
                              {
                                 _loc5_.type = 5;
                              }
                           }
                           else
                           {
                              _loc5_.type = 4;
                           }
                        }
                        else
                        {
                           _loc5_.type = 3;
                        }
                     }
                     else
                     {
                        _loc5_.type = 2;
                     }
                  }
                  else
                  {
                     _loc5_.type = 1;
                  }
               }
               else
               {
                  _loc5_.type = 16;
               }
            }
            else
            {
               _loc5_.type = TransitionActionType.XY;
            }
            _loc5_.tween = _loc6_.@tween == "true";
            _loc5_.label = _loc6_.@label;
            if(_loc5_.label.length == 0)
            {
               _loc5_.label = null;
            }
            if(_loc5_.tween)
            {
               _loc5_.duration = parseInt(_loc6_.@duration) / 24;
               if(_loc5_.time + _loc5_.duration > _maxTime)
               {
                  _maxTime = _loc5_.time + _loc5_.duration;
               }
               _loc4_ = _loc6_.@ease;
               if(_loc4_)
               {
                  _loc7_ = _loc4_.indexOf(".");
                  if(_loc7_ != -1)
                  {
                     _loc4_ = _loc4_.substr(0,_loc7_) + ".ease" + _loc4_.substr(_loc7_ + 1);
                  }
                  if(_loc4_ == "Linear")
                  {
                     _loc5_.easeType = EaseLookup.find("linear.easenone");
                  }
                  else
                  {
                     _loc5_.easeType = EaseLookup.find(_loc4_);
                  }
               }
               _loc5_.repeat = parseInt(_loc6_.@repeat);
               _loc5_.yoyo = _loc6_.@yoyo == "true";
               _loc5_.label2 = _loc6_.@label2;
               if(_loc5_.label2.length == 0)
               {
                  _loc5_.label2 = null;
               }
               _loc2_ = _loc6_.@endValue;
               if(_loc2_)
               {
                  decodeValue(_loc5_.type,_loc6_.@startValue,_loc5_.startValue);
                  decodeValue(_loc5_.type,_loc2_,_loc5_.endValue);
               }
               else
               {
                  _loc5_.tween = false;
                  decodeValue(_loc5_.type,_loc6_.@startValue,_loc5_.value);
               }
            }
            else
            {
               if(_loc5_.time > _maxTime)
               {
                  _maxTime = _loc5_.time;
               }
               decodeValue(_loc5_.type,_loc6_.@value,_loc5_.value);
            }
         }
      }
      
      private function decodeValue(param1:int, param2:String, param3:TransitionValue) : void
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = param1;
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
                                                if(12 === _loc6_)
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
                                                param3.f1 = parseFloat(_loc4_[0]);
                                                param3.f2 = parseFloat(_loc4_[1]);
                                             }
                                          }
                                          else
                                          {
                                             _loc4_ = param2.split(",");
                                             param3.s = _loc4_[0];
                                             if(_loc4_.length > 1)
                                             {
                                                param3.i = parseInt(_loc4_[1]);
                                             }
                                             else
                                             {
                                                param3.i = 1;
                                             }
                                          }
                                       }
                                       else
                                       {
                                          _loc4_ = param2.split(",");
                                          param3.s = _loc4_[0];
                                          if(_loc4_.length > 1)
                                          {
                                             _loc5_ = parseInt(_loc4_[1]);
                                             if(_loc5_ == 0 || _loc5_ == 100)
                                             {
                                                param3.f1 = 1;
                                             }
                                             else
                                             {
                                                param3.f1 = _loc5_ / 100;
                                             }
                                          }
                                          else
                                          {
                                             param3.f1 = 1;
                                          }
                                       }
                                    }
                                    else
                                    {
                                       param3.b = param2 == "true";
                                    }
                                 }
                                 else
                                 {
                                    _loc4_ = param2.split(",");
                                    if(_loc4_[0] == "-")
                                    {
                                       param3.b1 = false;
                                    }
                                    else
                                    {
                                       param3.i = parseInt(_loc4_[0]);
                                       param3.b1 = true;
                                    }
                                    param3.b = _loc4_[1] == "p";
                                 }
                              }
                              else
                              {
                                 param3.c = ToolSet.convertFromHtmlColor(param2);
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
                           param3.f1 = parseInt(param2);
                        }
                     }
                     else
                     {
                        param3.f1 = parseFloat(param2);
                     }
                  }
                  addr326:
                  return;
               }
               addr12:
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
               §§goto(addr326);
            }
            addr11:
            §§goto(addr12);
         }
         §§goto(addr11);
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
   
   public static const Unknown:int = 14;
   
   public static const Music:int = 15;
   
   public static const XYV:int = 16;
    
   
   function TransitionActionType()
   {
      super();
   }
}

import com.greensock.TweenLite;
import com.greensock.easing.Ease;
import com.greensock.easing.Quad;
import fairygui.GObject;

class TransitionItem
{
    
   
   public var time:Number;
   
   public var targetId:String;
   
   public var type:int;
   
   public var duration:Number;
   
   public var value:TransitionValue;
   
   public var startValue:TransitionValue;
   
   public var endValue:TransitionValue;
   
   public var easeType:Ease;
   
   public var repeat:int;
   
   public var yoyo:Boolean;
   
   public var tween:Boolean;
   
   public var label:String;
   
   public var label2:String;
   
   public var hook:Function;
   
   public var hook2:Function;
   
   public var tweener:TweenLite;
   
   public var completed:Boolean;
   
   public var target:GObject;
   
   public var filterCreated:Boolean;
   
   public var displayLockToken:uint;
   
   public var params:Array;
   
   function TransitionItem()
   {
      super();
      easeType = Quad.easeOut;
      value = new TransitionValue();
      startValue = new TransitionValue();
      endValue = new TransitionValue();
      params = [this];
   }
   
   public function __shake(param1:Object) : void
   {
   }
}

class TransitionValue
{
    
   
   public var f1:Number;
   
   public var f2:Number;
   
   public var f3:Number;
   
   public var f4:Number;
   
   public var i:int;
   
   public var c:uint;
   
   public var b:Boolean;
   
   public var s:String;
   
   public var b1:Boolean = true;
   
   public var b2:Boolean = true;
   
   function TransitionValue()
   {
      super();
   }
}

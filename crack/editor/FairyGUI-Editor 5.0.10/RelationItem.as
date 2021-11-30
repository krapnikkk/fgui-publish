package fairygui
{
   class RelationItem
   {
       
      
      private var _owner:GObject;
      
      private var _target:GObject;
      
      private var _defs:Vector.<RelationDef>;
      
      private var _targetX:Number;
      
      private var _targetY:Number;
      
      private var _targetWidth:Number;
      
      private var _targetHeight:Number;
      
      function RelationItem(param1:GObject)
      {
         super();
         _owner = param1;
         _defs = new Vector.<RelationDef>();
      }
      
      public final function get owner() : GObject
      {
         return _owner;
      }
      
      public function set target(param1:GObject) : void
      {
         if(_target != param1)
         {
            if(_target)
            {
               releaseRefTarget(_target);
            }
            _target = param1;
            if(_target)
            {
               addRefTarget(_target);
            }
         }
      }
      
      public final function get target() : GObject
      {
         return _target;
      }
      
      public function add(param1:int, param2:Boolean) : void
      {
         if(param1 == 24)
         {
            add(14,param2);
            add(15,param2);
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:* = _defs;
         for each(var _loc3_ in _defs)
         {
            if(_loc3_.type == param1)
            {
               return;
            }
         }
         internalAdd(param1,param2);
      }
      
      public function internalAdd(param1:int, param2:Boolean) : void
      {
         if(param1 == 24)
         {
            internalAdd(14,param2);
            internalAdd(15,param2);
            return;
         }
         var _loc3_:RelationDef = new RelationDef();
         _loc3_.percent = param2;
         _loc3_.type = param1;
         _loc3_.axis = param1 <= 6 || param1 == 14 || param1 >= 16 && param1 <= 19?0:1;
         _defs.push(_loc3_);
         if(param2 || param1 == 1 || param1 == 3 || param1 == 5 || param1 == 8 || param1 == 10 || param1 == 12)
         {
            _owner.pixelSnapping = true;
         }
      }
      
      public function remove(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 == 24)
         {
            remove(14);
            remove(15);
            return;
         }
         var _loc3_:int = _defs.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_defs[_loc2_].type == param1)
            {
               _defs.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function copyFrom(param1:RelationItem) : void
      {
         var _loc3_:* = null;
         this.target = param1.target;
         _defs.length = 0;
         var _loc5_:int = 0;
         var _loc4_:* = param1._defs;
         for each(var _loc2_ in param1._defs)
         {
            _loc3_ = new RelationDef();
            _loc3_.copyFrom(_loc2_);
            _defs.push(_loc3_);
         }
      }
      
      public function dispose() : void
      {
         if(_target != null)
         {
            releaseRefTarget(_target);
            _target = null;
         }
      }
      
      public final function get isEmpty() : Boolean
      {
         return _defs.length == 0;
      }
      
      public function applyOnSelfResized(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc8_:* = null;
         var _loc4_:int = _defs.length;
         if(_loc4_ == 0)
         {
            return;
         }
         var _loc5_:Number = _owner.x;
         var _loc7_:Number = _owner.y;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc8_ = _defs[_loc6_];
            switch(int(_loc8_.type) - 3)
            {
               case 0:
                  _owner.x = _owner.x - (0.5 - (!!param3?_owner.pivotX:0)) * param1;
                  break;
               case 1:
               case 2:
               case 3:
                  _owner.x = _owner.x - (1 - (!!param3?_owner.pivotX:0)) * param1;
                  break;
               default:
                  _owner.x = _owner.x - (1 - (!!param3?_owner.pivotX:0)) * param1;
                  break;
               default:
                  _owner.x = _owner.x - (1 - (!!param3?_owner.pivotX:0)) * param1;
                  break;
               default:
                  _owner.x = _owner.x - (1 - (!!param3?_owner.pivotX:0)) * param1;
                  break;
               case 7:
                  _owner.y = _owner.y - (0.5 - (!!param3?_owner.pivotY:0)) * param2;
                  break;
               case 8:
               case 9:
               case 10:
                  _owner.y = _owner.y - (1 - (!!param3?_owner.pivotY:0)) * param2;
            }
            _loc6_++;
         }
         if(_loc5_ != _owner.x || _loc7_ != _owner.y)
         {
            _loc5_ = _owner.x - _loc5_;
            _loc7_ = _owner.y - _loc7_;
            _owner.updateGearFromRelations(1,_loc5_,_loc7_);
            if(_owner.parent != null && _owner.parent._transitions.length > 0)
            {
               var _loc11_:int = 0;
               var _loc10_:* = _owner.parent._transitions;
               for each(var _loc9_ in _owner.parent._transitions)
               {
                  _loc9_.updateFromRelations(_owner.id,_loc5_,_loc7_);
               }
            }
         }
      }
      
      private function applyOnXYChanged(param1:RelationDef, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:* = param1.type;
         if(0 !== _loc5_)
         {
            if(1 !== _loc5_)
            {
               if(2 !== _loc5_)
               {
                  if(3 !== _loc5_)
                  {
                     if(4 !== _loc5_)
                     {
                        if(5 !== _loc5_)
                        {
                           if(6 !== _loc5_)
                           {
                              if(7 !== _loc5_)
                              {
                                 if(8 !== _loc5_)
                                 {
                                    if(9 !== _loc5_)
                                    {
                                       if(10 !== _loc5_)
                                       {
                                          if(11 !== _loc5_)
                                          {
                                             if(12 !== _loc5_)
                                             {
                                                if(13 !== _loc5_)
                                                {
                                                   if(14 !== _loc5_)
                                                   {
                                                      if(15 !== _loc5_)
                                                      {
                                                         if(16 !== _loc5_)
                                                         {
                                                            if(17 !== _loc5_)
                                                            {
                                                               if(18 !== _loc5_)
                                                               {
                                                                  if(19 !== _loc5_)
                                                                  {
                                                                     if(20 !== _loc5_)
                                                                     {
                                                                        if(21 !== _loc5_)
                                                                        {
                                                                           if(22 !== _loc5_)
                                                                           {
                                                                              if(23 !== _loc5_)
                                                                              {
                                                                              }
                                                                           }
                                                                           if(_owner != _target.parent)
                                                                           {
                                                                              _loc4_ = _owner.yMin;
                                                                              _owner.height = _owner._rawHeight + param3;
                                                                              _owner.yMin = _loc4_;
                                                                           }
                                                                           else
                                                                           {
                                                                              _owner.height = _owner._rawHeight + param3;
                                                                           }
                                                                        }
                                                                     }
                                                                     if(_owner != _target.parent)
                                                                     {
                                                                        _loc4_ = _owner.yMin;
                                                                        _owner.height = _owner._rawHeight - param3;
                                                                        _owner.yMin = _loc4_ + param3;
                                                                     }
                                                                     else
                                                                     {
                                                                        _owner.height = _owner._rawHeight - param3;
                                                                     }
                                                                  }
                                                               }
                                                               if(_owner != _target.parent)
                                                               {
                                                                  _loc4_ = _owner.xMin;
                                                                  _owner.width = _owner._rawWidth + param2;
                                                                  _owner.xMin = _loc4_;
                                                               }
                                                               else
                                                               {
                                                                  _owner.width = _owner._rawWidth + param2;
                                                               }
                                                            }
                                                         }
                                                         if(_owner != _target.parent)
                                                         {
                                                            _loc4_ = _owner.xMin;
                                                            _owner.width = _owner._rawWidth - param2;
                                                            _owner.xMin = _loc4_ + param2;
                                                         }
                                                         else
                                                         {
                                                            _owner.width = _owner._rawWidth - param2;
                                                         }
                                                      }
                                                   }
                                                }
                                             }
                                             addr29:
                                             _owner.y = _owner.y + param3;
                                          }
                                          addr28:
                                          §§goto(addr29);
                                       }
                                       addr27:
                                       §§goto(addr28);
                                    }
                                    addr26:
                                    §§goto(addr27);
                                 }
                                 addr25:
                                 §§goto(addr26);
                              }
                              §§goto(addr25);
                           }
                           addr225:
                           return;
                        }
                        addr14:
                        _owner.x = _owner.x + param2;
                        §§goto(addr225);
                     }
                     addr13:
                     §§goto(addr14);
                  }
                  addr12:
                  §§goto(addr13);
               }
               addr11:
               §§goto(addr12);
            }
            addr10:
            §§goto(addr11);
         }
         §§goto(addr10);
      }
      
      private function applyOnSizeChanged(param1:RelationDef) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:* = 0;
         var _loc6_:* = 0;
         var _loc5_:* = 0;
         if(param1.axis == 0)
         {
            if(_target != _owner.parent)
            {
               _loc2_ = Number(_target.x);
               if(_target.pivotAsAnchor)
               {
                  _loc6_ = Number(_target.pivotX);
               }
            }
            if(param1.percent)
            {
               if(_targetWidth != 0)
               {
                  _loc5_ = Number(_target._width / _targetWidth);
               }
            }
            else
            {
               _loc5_ = Number(_target._width - _targetWidth);
            }
         }
         else
         {
            if(_target != _owner.parent)
            {
               _loc2_ = Number(_target.y);
               if(_target.pivotAsAnchor)
               {
                  _loc6_ = Number(_target.pivotY);
               }
            }
            if(param1.percent)
            {
               if(_targetHeight != 0)
               {
                  _loc5_ = Number(_target._height / _targetHeight);
               }
            }
            else
            {
               _loc5_ = Number(_target._height - _targetHeight);
            }
         }
         var _loc7_:* = param1.type;
         if(0 !== _loc7_)
         {
            if(1 !== _loc7_)
            {
               if(2 !== _loc7_)
               {
                  if(3 !== _loc7_)
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
                                             if(12 !== _loc7_)
                                             {
                                                if(13 !== _loc7_)
                                                {
                                                   if(14 !== _loc7_)
                                                   {
                                                      if(15 !== _loc7_)
                                                      {
                                                         if(16 !== _loc7_)
                                                         {
                                                            if(17 !== _loc7_)
                                                            {
                                                               if(18 !== _loc7_)
                                                               {
                                                                  if(19 !== _loc7_)
                                                                  {
                                                                     if(20 !== _loc7_)
                                                                     {
                                                                        if(21 !== _loc7_)
                                                                        {
                                                                           if(22 !== _loc7_)
                                                                           {
                                                                              if(23 === _loc7_)
                                                                              {
                                                                                 _loc3_ = _owner.yMin;
                                                                                 if(param1.percent)
                                                                                 {
                                                                                    if(_owner == _target.parent)
                                                                                    {
                                                                                       if(_owner._underConstruct)
                                                                                       {
                                                                                          _owner.height = _loc2_ + _target._height - _target._height * _loc6_ + (_owner.sourceHeight - _loc2_ - _target.initHeight + _target.initHeight * _loc6_) * _loc5_;
                                                                                       }
                                                                                       else
                                                                                       {
                                                                                          _owner.height = _loc2_ + (_owner._rawHeight - _loc2_) * _loc5_;
                                                                                       }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                       _loc4_ = _loc2_ + (_loc3_ + _owner._rawHeight - _loc2_) * _loc5_ - (_loc3_ + _owner._rawHeight);
                                                                                       _owner.height = _owner._rawHeight + _loc4_;
                                                                                       _owner.yMin = _loc3_;
                                                                                    }
                                                                                 }
                                                                                 else if(_owner == _target.parent)
                                                                                 {
                                                                                    if(_owner._underConstruct)
                                                                                    {
                                                                                       _owner.height = _owner.sourceHeight + (_target._height - _target.initHeight) * (1 - _loc6_);
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                       _owner.height = _owner._rawHeight + _loc5_ * (1 - _loc6_);
                                                                                    }
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    _loc4_ = _loc5_ * (1 - _loc6_);
                                                                                    _owner.height = _owner._rawHeight + _loc4_;
                                                                                    _owner.yMin = _loc3_;
                                                                                 }
                                                                              }
                                                                           }
                                                                           else
                                                                           {
                                                                              _loc3_ = _owner.yMin;
                                                                              if(param1.percent)
                                                                              {
                                                                                 _loc4_ = _loc2_ + (_loc3_ + _owner._rawHeight - _loc2_) * _loc5_ - (_loc3_ + _owner._rawHeight);
                                                                              }
                                                                              else
                                                                              {
                                                                                 _loc4_ = _loc5_ * -_loc6_;
                                                                              }
                                                                              _owner.height = _owner._rawHeight + _loc4_;
                                                                              _owner.yMin = _loc3_;
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           _loc3_ = _owner.yMin;
                                                                           if(param1.percent)
                                                                           {
                                                                              _loc4_ = _loc2_ + (_loc3_ - _loc2_) * _loc5_ - _loc3_;
                                                                           }
                                                                           else
                                                                           {
                                                                              _loc4_ = _loc5_ * (1 - _loc6_);
                                                                           }
                                                                           _owner.height = _owner._rawHeight - _loc4_;
                                                                           _owner.yMin = _loc3_ + _loc4_;
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        _loc3_ = _owner.yMin;
                                                                        if(param1.percent)
                                                                        {
                                                                           _loc4_ = _loc2_ + (_loc3_ - _loc2_) * _loc5_ - _loc3_;
                                                                        }
                                                                        else
                                                                        {
                                                                           _loc4_ = _loc5_ * -_loc6_;
                                                                        }
                                                                        _owner.height = _owner._rawHeight - _loc4_;
                                                                        _owner.yMin = _loc3_ + _loc4_;
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     _loc3_ = _owner.xMin;
                                                                     if(param1.percent)
                                                                     {
                                                                        if(_owner == _target.parent)
                                                                        {
                                                                           if(_owner._underConstruct)
                                                                           {
                                                                              _owner.width = _loc2_ + _target._width - _target._width * _loc6_ + (_owner.sourceWidth - _loc2_ - _target.initWidth + _target.initWidth * _loc6_) * _loc5_;
                                                                           }
                                                                           else
                                                                           {
                                                                              _owner.width = _loc2_ + (_owner._rawWidth - _loc2_) * _loc5_;
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           _loc4_ = _loc2_ + (_loc3_ + _owner._rawWidth - _loc2_) * _loc5_ - (_loc3_ + _owner._rawWidth);
                                                                           _owner.width = _owner._rawWidth + _loc4_;
                                                                           _owner.xMin = _loc3_;
                                                                        }
                                                                     }
                                                                     else if(_owner == _target.parent)
                                                                     {
                                                                        if(_owner._underConstruct)
                                                                        {
                                                                           _owner.width = _owner.sourceWidth + (_target._width - _target.initWidth) * (1 - _loc6_);
                                                                        }
                                                                        else
                                                                        {
                                                                           _owner.width = _owner._rawWidth + _loc5_ * (1 - _loc6_);
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        _loc4_ = _loc5_ * (1 - _loc6_);
                                                                        _owner.width = _owner._rawWidth + _loc4_;
                                                                        _owner.xMin = _loc3_;
                                                                     }
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  _loc3_ = _owner.xMin;
                                                                  if(param1.percent)
                                                                  {
                                                                     _loc4_ = _loc2_ + (_loc3_ + _owner._rawWidth - _loc2_) * _loc5_ - (_loc3_ + _owner._rawWidth);
                                                                  }
                                                                  else
                                                                  {
                                                                     _loc4_ = _loc5_ * -_loc6_;
                                                                  }
                                                                  _owner.width = _owner._rawWidth + _loc4_;
                                                                  _owner.xMin = _loc3_;
                                                               }
                                                            }
                                                            else
                                                            {
                                                               _loc3_ = _owner.xMin;
                                                               if(param1.percent)
                                                               {
                                                                  _loc4_ = _loc2_ + (_loc3_ - _loc2_) * _loc5_ - _loc3_;
                                                               }
                                                               else
                                                               {
                                                                  _loc4_ = _loc5_ * (1 - _loc6_);
                                                               }
                                                               _owner.width = _owner._rawWidth - _loc4_;
                                                               _owner.xMin = _loc3_ + _loc4_;
                                                            }
                                                         }
                                                         else
                                                         {
                                                            _loc3_ = _owner.xMin;
                                                            if(param1.percent)
                                                            {
                                                               _loc4_ = _loc2_ + (_loc3_ - _loc2_) * _loc5_ - _loc3_;
                                                            }
                                                            else
                                                            {
                                                               _loc4_ = _loc5_ * -_loc6_;
                                                            }
                                                            _owner.width = _owner._rawWidth - _loc4_;
                                                            _owner.xMin = _loc3_ + _loc4_;
                                                         }
                                                      }
                                                      else
                                                      {
                                                         if(_owner._underConstruct && _owner == _target.parent)
                                                         {
                                                            _loc4_ = _owner.sourceHeight - _target.initHeight;
                                                         }
                                                         else
                                                         {
                                                            _loc4_ = _owner._rawHeight - _targetHeight;
                                                         }
                                                         if(param1.percent)
                                                         {
                                                            _loc4_ = _loc4_ * _loc5_;
                                                         }
                                                         if(_target == _owner.parent)
                                                         {
                                                            if(_owner.pivotAsAnchor)
                                                            {
                                                               _loc3_ = _owner.yMin;
                                                               _owner.setSize(_owner._rawWidth,_target._height + _loc4_,true);
                                                               _owner.yMin = _loc3_;
                                                            }
                                                            else
                                                            {
                                                               _owner.setSize(_owner._rawWidth,_target._height + _loc4_,true);
                                                            }
                                                         }
                                                         else
                                                         {
                                                            _owner.height = _target._height + _loc4_;
                                                         }
                                                      }
                                                   }
                                                   else
                                                   {
                                                      if(_owner._underConstruct && _owner == _target.parent)
                                                      {
                                                         _loc4_ = _owner.sourceWidth - _target.initWidth;
                                                      }
                                                      else
                                                      {
                                                         _loc4_ = _owner._rawWidth - _targetWidth;
                                                      }
                                                      if(param1.percent)
                                                      {
                                                         _loc4_ = _loc4_ * _loc5_;
                                                      }
                                                      if(_target == _owner.parent)
                                                      {
                                                         if(_owner.pivotAsAnchor)
                                                         {
                                                            _loc3_ = _owner.xMin;
                                                            _owner.setSize(_target._width + _loc4_,_owner._rawHeight,true);
                                                            _owner.xMin = _loc3_;
                                                         }
                                                         else
                                                         {
                                                            _owner.setSize(_target._width + _loc4_,_owner._rawHeight,true);
                                                         }
                                                      }
                                                      else
                                                      {
                                                         _owner.width = _target._width + _loc4_;
                                                      }
                                                   }
                                                }
                                                else if(param1.percent)
                                                {
                                                   _owner.yMin = _loc2_ + (_owner.yMin + _owner._rawHeight - _loc2_) * _loc5_ - _owner._rawHeight;
                                                }
                                                else
                                                {
                                                   _owner.y = _owner.y + _loc5_ * (1 - _loc6_);
                                                }
                                             }
                                             else if(param1.percent)
                                             {
                                                _owner.yMin = _loc2_ + (_owner.yMin + _owner._rawHeight - _loc2_) * _loc5_ - _owner._rawHeight;
                                             }
                                             else
                                             {
                                                _owner.y = _owner.y + _loc5_ * (0.5 - _loc6_);
                                             }
                                          }
                                          else if(param1.percent)
                                          {
                                             _owner.yMin = _loc2_ + (_owner.yMin + _owner._rawHeight - _loc2_) * _loc5_ - _owner._rawHeight;
                                          }
                                          else if(_loc6_ != 0)
                                          {
                                             _owner.y = _owner.y + _loc5_ * -_loc6_;
                                          }
                                       }
                                       else if(param1.percent)
                                       {
                                          _owner.yMin = _loc2_ + (_owner.yMin + _owner._rawHeight * 0.5 - _loc2_) * _loc5_ - _owner._rawHeight * 0.5;
                                       }
                                       else
                                       {
                                          _owner.y = _owner.y + _loc5_ * (0.5 - _loc6_);
                                       }
                                    }
                                    else if(param1.percent)
                                    {
                                       _owner.yMin = _loc2_ + (_owner.yMin - _loc2_) * _loc5_;
                                    }
                                    else
                                    {
                                       _owner.y = _owner.y + _loc5_ * (1 - _loc6_);
                                    }
                                 }
                                 else if(param1.percent)
                                 {
                                    _owner.yMin = _loc2_ + (_owner.yMin - _loc2_) * _loc5_;
                                 }
                                 else
                                 {
                                    _owner.y = _owner.y + _loc5_ * (0.5 - _loc6_);
                                 }
                              }
                              else if(param1.percent)
                              {
                                 _owner.yMin = _loc2_ + (_owner.yMin - _loc2_) * _loc5_;
                              }
                              else if(_loc6_ != 0)
                              {
                                 _owner.y = _owner.y + _loc5_ * -_loc6_;
                              }
                           }
                           else if(param1.percent)
                           {
                              _owner.xMin = _loc2_ + (_owner.xMin + _owner._rawWidth - _loc2_) * _loc5_ - _owner._rawWidth;
                           }
                           else
                           {
                              _owner.x = _owner.x + _loc5_ * (1 - _loc6_);
                           }
                        }
                        else if(param1.percent)
                        {
                           _owner.xMin = _loc2_ + (_owner.xMin + _owner._rawWidth - _loc2_) * _loc5_ - _owner._rawWidth;
                        }
                        else
                        {
                           _owner.x = _owner.x + _loc5_ * (0.5 - _loc6_);
                        }
                     }
                     else if(param1.percent)
                     {
                        _owner.xMin = _loc2_ + (_owner.xMin + _owner._rawWidth - _loc2_) * _loc5_ - _owner._rawWidth;
                     }
                     else if(_loc6_ != 0)
                     {
                        _owner.x = _owner.x + _loc5_ * -_loc6_;
                     }
                  }
                  else if(param1.percent)
                  {
                     _owner.xMin = _loc2_ + (_owner.xMin + _owner._rawWidth * 0.5 - _loc2_) * _loc5_ - _owner._rawWidth * 0.5;
                  }
                  else
                  {
                     _owner.x = _owner.x + _loc5_ * (0.5 - _loc6_);
                  }
               }
               else if(param1.percent)
               {
                  _owner.xMin = _loc2_ + (_owner.xMin - _loc2_) * _loc5_;
               }
               else
               {
                  _owner.x = _owner.x + _loc5_ * (1 - _loc6_);
               }
            }
            else if(param1.percent)
            {
               _owner.xMin = _loc2_ + (_owner.xMin - _loc2_) * _loc5_;
            }
            else
            {
               _owner.x = _owner.x + _loc5_ * (0.5 - _loc6_);
            }
         }
         else if(param1.percent)
         {
            _owner.xMin = _loc2_ + (_owner.xMin - _loc2_) * _loc5_;
         }
         else if(_loc6_ != 0)
         {
            _owner.x = _owner.x + _loc5_ * -_loc6_;
         }
      }
      
      private function addRefTarget(param1:GObject) : void
      {
         if(param1 != _owner.parent)
         {
            param1.addXYChangeCallback(__targetXYChanged);
         }
         param1.addSizeChangeCallback(__targetSizeChanged);
         param1.addSizeDelayChangeCallback(__targetSizeWillChange);
         _targetX = _target.x;
         _targetY = _target.y;
         _targetWidth = _target._width;
         _targetHeight = _target._height;
      }
      
      private function releaseRefTarget(param1:GObject) : void
      {
         param1.removeXYChangeCallback(__targetXYChanged);
         param1.removeSizeChangeCallback(__targetSizeChanged);
         param1.removeSizeDelayChangeCallback(__targetSizeWillChange);
      }
      
      private function __targetXYChanged(param1:GObject) : void
      {
         if(_owner.relations.handling != null || _owner.group != null && _owner.group._updating)
         {
            _targetX = _target.x;
            _targetY = _target.y;
            return;
         }
         _owner.relations.handling = param1;
         var _loc4_:Number = _owner.x;
         var _loc5_:Number = _owner.y;
         var _loc2_:Number = _target.x - _targetX;
         var _loc3_:Number = _target.y - _targetY;
         var _loc9_:int = 0;
         var _loc8_:* = _defs;
         for each(var _loc6_ in _defs)
         {
            applyOnXYChanged(_loc6_,_loc2_,_loc3_);
         }
         _targetX = _target.x;
         _targetY = _target.y;
         if(_loc4_ != _owner.x || _loc5_ != _owner.y)
         {
            _loc4_ = _owner.x - _loc4_;
            _loc5_ = _owner.y - _loc5_;
            _owner.updateGearFromRelations(1,_loc4_,_loc5_);
            if(_owner.parent != null && _owner.parent._transitions.length > 0)
            {
               var _loc11_:int = 0;
               var _loc10_:* = _owner.parent._transitions;
               for each(var _loc7_ in _owner.parent._transitions)
               {
                  _loc7_.updateFromRelations(_owner.id,_loc4_,_loc5_);
               }
            }
         }
         _owner.relations.handling = null;
      }
      
      private function __targetSizeChanged(param1:GObject) : void
      {
         if(_owner.relations.sizeDirty)
         {
            _owner.relations.ensureRelationsSizeCorrect();
         }
         if(_owner.relations.handling != null)
         {
            _targetWidth = _target._width;
            _targetHeight = _target._height;
            return;
         }
         _owner.relations.handling = param1;
         var _loc3_:Number = _owner.x;
         var _loc5_:Number = _owner.y;
         var _loc2_:Number = _owner._rawWidth;
         var _loc4_:Number = _owner._rawHeight;
         var _loc9_:int = 0;
         var _loc8_:* = _defs;
         for each(var _loc6_ in _defs)
         {
            applyOnSizeChanged(_loc6_);
         }
         _targetWidth = _target._width;
         _targetHeight = _target._height;
         if(_loc3_ != _owner.x || _loc5_ != _owner.y)
         {
            _loc3_ = _owner.x - _loc3_;
            _loc5_ = _owner.y - _loc5_;
            _owner.updateGearFromRelations(1,_loc3_,_loc5_);
            if(_owner.parent != null && _owner.parent._transitions.length > 0)
            {
               var _loc11_:int = 0;
               var _loc10_:* = _owner.parent._transitions;
               for each(var _loc7_ in _owner.parent._transitions)
               {
                  _loc7_.updateFromRelations(_owner.id,_loc3_,_loc5_);
               }
            }
         }
         if(_loc2_ != _owner._rawWidth || _loc4_ != _owner._rawHeight)
         {
            _loc2_ = _owner._rawWidth - _loc2_;
            _loc4_ = _owner._rawHeight - _loc4_;
            _owner.updateGearFromRelations(2,_loc2_,_loc4_);
         }
         _owner.relations.handling = null;
      }
      
      private function __targetSizeWillChange(param1:GObject) : void
      {
         _owner.relations.sizeDirty = true;
      }
   }
}

class RelationDef
{
    
   
   public var percent:Boolean;
   
   public var type:int;
   
   public var axis:int;
   
   function RelationDef()
   {
      super();
   }
   
   public function copyFrom(param1:RelationDef) : void
   {
      this.percent = param1.percent;
      this.type = param1.type;
      this.axis = param1.axis;
   }
}

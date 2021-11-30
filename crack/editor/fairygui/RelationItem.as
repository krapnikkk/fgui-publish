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
         _defs.push(_loc3_);
         if(param2 || param1 == 1 || param1 == 3 || param1 == 5 || param1 == 8 || param1 == 10 || param1 == 12)
         {
            _owner.pixelSnapping = true;
         }
      }
      
      public function remove(param1:int) : void
      {
         var _loc3_:int = 0;
         if(param1 == 24)
         {
            remove(14);
            remove(15);
            return;
         }
         var _loc2_:int = _defs.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_defs[_loc3_].type == param1)
            {
               _defs.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function copyFrom(param1:RelationItem) : void
      {
         var _loc2_:* = null;
         this.target = param1.target;
         _defs.length = 0;
         var _loc5_:int = 0;
         var _loc4_:* = param1._defs;
         for each(var _loc3_ in param1._defs)
         {
            _loc2_ = new RelationDef();
            _loc2_.copyFrom(_loc3_);
            _defs.push(_loc2_);
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
      
      public function applyOnSelfResized(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = _owner.x;
         var _loc6_:Number = _owner.y;
         var _loc8_:int = 0;
         var _loc7_:* = _defs;
         for each(var _loc5_ in _defs)
         {
            switch(int(_loc5_.type) - 3)
            {
               case 0:
                  _owner.x = _owner.x - param1 / 2;
                  continue;
               case 1:
               case 2:
               case 3:
                  _owner.x = _owner.x - param1;
                  continue;
               default:
               default:
               default:
                  continue;
               case 7:
                  _owner.y = _owner.y - param2 / 2;
                  continue;
               case 8:
               case 9:
               case 10:
                  _owner.y = _owner.y - param2;
                  continue;
            }
         }
         if(_loc4_ != _owner.x || _loc6_ != _owner.y)
         {
            _loc4_ = _owner.x - _loc4_;
            _loc6_ = _owner.y - _loc6_;
            _owner.updateGearFromRelations(1,_loc4_,_loc6_);
            if(_owner.parent != null && _owner.parent._transitions.length > 0)
            {
               var _loc10_:int = 0;
               var _loc9_:* = _owner.parent._transitions;
               for each(var _loc3_ in _owner.parent._transitions)
               {
                  _loc3_.updateFromRelations(_owner.id,_loc4_,_loc6_);
               }
            }
         }
      }
      
      private function applyOnXYChanged(param1:RelationDef, param2:Number, param3:Number) : void
      {
         var _loc4_:* = param1.type;
         if(0 !== _loc4_)
         {
            if(1 !== _loc4_)
            {
               if(2 !== _loc4_)
               {
                  if(3 !== _loc4_)
                  {
                     if(4 !== _loc4_)
                     {
                        if(5 !== _loc4_)
                        {
                           if(6 !== _loc4_)
                           {
                              if(7 !== _loc4_)
                              {
                                 if(8 !== _loc4_)
                                 {
                                    if(9 !== _loc4_)
                                    {
                                       if(10 !== _loc4_)
                                       {
                                          if(11 !== _loc4_)
                                          {
                                             if(12 !== _loc4_)
                                             {
                                                if(13 !== _loc4_)
                                                {
                                                   if(14 !== _loc4_)
                                                   {
                                                      if(15 !== _loc4_)
                                                      {
                                                         if(16 !== _loc4_)
                                                         {
                                                            if(17 !== _loc4_)
                                                            {
                                                               if(18 !== _loc4_)
                                                               {
                                                                  if(19 !== _loc4_)
                                                                  {
                                                                     if(20 !== _loc4_)
                                                                     {
                                                                        if(21 !== _loc4_)
                                                                        {
                                                                           if(22 !== _loc4_)
                                                                           {
                                                                              if(23 !== _loc4_)
                                                                              {
                                                                              }
                                                                           }
                                                                           _owner.height = _owner._rawHeight + param3;
                                                                        }
                                                                     }
                                                                     _owner.y = _owner.y + param3;
                                                                     _owner.height = _owner._rawHeight - param3;
                                                                  }
                                                               }
                                                               _owner.width = _owner._rawWidth + param2;
                                                            }
                                                         }
                                                         _owner.x = _owner.x + param2;
                                                         _owner.width = _owner._rawWidth - param2;
                                                      }
                                                   }
                                                }
                                             }
                                             addr27:
                                             _owner.y = _owner.y + param3;
                                          }
                                          addr26:
                                          §§goto(addr27);
                                       }
                                       addr25:
                                       §§goto(addr26);
                                    }
                                    addr24:
                                    §§goto(addr25);
                                 }
                                 addr23:
                                 §§goto(addr24);
                              }
                              §§goto(addr23);
                           }
                           addr161:
                           return;
                        }
                        addr12:
                        _owner.x = _owner.x + param2;
                        §§goto(addr161);
                     }
                     addr11:
                     §§goto(addr12);
                  }
                  addr10:
                  §§goto(addr11);
               }
               addr9:
               §§goto(addr10);
            }
            addr8:
            §§goto(addr9);
         }
         §§goto(addr8);
      }
      
      private function applyOnSizeChanged(param1:RelationDef) : void
      {
         var _loc5_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         if(_target != _owner.parent)
         {
            _loc3_ = Number(_target.x);
            _loc5_ = Number(_target.y);
         }
         else
         {
            _loc3_ = 0;
            _loc5_ = 0;
         }
         var _loc6_:* = param1.type;
         if(0 !== _loc6_)
         {
            if(1 !== _loc6_)
            {
               if(2 !== _loc6_)
               {
                  if(3 !== _loc6_)
                  {
                     if(4 !== _loc6_)
                     {
                        if(5 !== _loc6_)
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
                                                if(13 !== _loc6_)
                                                {
                                                   if(14 !== _loc6_)
                                                   {
                                                      if(15 !== _loc6_)
                                                      {
                                                         if(16 !== _loc6_)
                                                         {
                                                            if(17 !== _loc6_)
                                                            {
                                                               if(18 !== _loc6_)
                                                               {
                                                                  if(19 !== _loc6_)
                                                                  {
                                                                     if(20 !== _loc6_)
                                                                     {
                                                                        if(21 !== _loc6_)
                                                                        {
                                                                           if(22 !== _loc6_)
                                                                           {
                                                                              if(23 === _loc6_)
                                                                              {
                                                                                 if(_owner._underConstruct && _owner == _target.parent)
                                                                                 {
                                                                                    _loc2_ = _owner.sourceHeight - (_loc5_ + _target.initHeight);
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    _loc2_ = _owner._rawHeight - (_loc5_ + _targetHeight);
                                                                                 }
                                                                                 if(_owner != _target.parent)
                                                                                 {
                                                                                    _loc2_ = _loc2_ + _owner.y;
                                                                                 }
                                                                                 if(param1.percent)
                                                                                 {
                                                                                    _loc2_ = _loc2_ / _targetHeight * _target._height;
                                                                                 }
                                                                                 if(_owner != _target.parent)
                                                                                 {
                                                                                    _owner.height = _loc5_ + _target._height + _loc2_ - _owner.y;
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    _owner.height = _loc5_ + _target._height + _loc2_;
                                                                                 }
                                                                              }
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           _loc2_ = _owner.y - (_loc5_ + _targetHeight);
                                                                           if(param1.percent)
                                                                           {
                                                                              _loc2_ = _loc2_ / _targetHeight * _target._height;
                                                                           }
                                                                           _loc4_ = _owner.y;
                                                                           _owner.y = _loc5_ + _target._height + _loc2_;
                                                                           _owner.height = _owner._rawHeight - (_owner.y - _loc4_);
                                                                        }
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     if(_owner._underConstruct && _owner == _target.parent)
                                                                     {
                                                                        _loc2_ = _owner.sourceWidth - (_loc3_ + _target.initWidth);
                                                                     }
                                                                     else
                                                                     {
                                                                        _loc2_ = _owner._rawWidth - (_loc3_ + _targetWidth);
                                                                     }
                                                                     if(_owner != _target.parent)
                                                                     {
                                                                        _loc2_ = _loc2_ + _owner.x;
                                                                     }
                                                                     if(param1.percent)
                                                                     {
                                                                        _loc2_ = _loc2_ / _targetWidth * _target._width;
                                                                     }
                                                                     if(_owner != _target.parent)
                                                                     {
                                                                        _owner.width = _loc3_ + _target._width + _loc2_ - _owner.x;
                                                                     }
                                                                     else
                                                                     {
                                                                        _owner.width = _loc3_ + _target._width + _loc2_;
                                                                     }
                                                                  }
                                                               }
                                                            }
                                                            else
                                                            {
                                                               _loc2_ = _owner.x - (_loc3_ + _targetWidth);
                                                               if(param1.percent)
                                                               {
                                                                  _loc2_ = _loc2_ / _targetWidth * _target._width;
                                                               }
                                                               _loc4_ = _owner.x;
                                                               _owner.x = _loc3_ + _target._width + _loc2_;
                                                               _owner.width = _owner._rawWidth - (_owner.x - _loc4_);
                                                            }
                                                         }
                                                      }
                                                      else
                                                      {
                                                         if(_owner._underConstruct && _owner == _target.parent)
                                                         {
                                                            _loc2_ = _owner.sourceHeight - _target.initHeight;
                                                         }
                                                         else
                                                         {
                                                            _loc2_ = _owner._rawHeight - _targetHeight;
                                                         }
                                                         if(param1.percent)
                                                         {
                                                            _loc2_ = _loc2_ / _targetHeight * _target._height;
                                                         }
                                                         if(_target == _owner.parent)
                                                         {
                                                            _owner.setSize(_owner._rawWidth,_target._height + _loc2_,true);
                                                         }
                                                         else
                                                         {
                                                            _owner.height = _target._height + _loc2_;
                                                         }
                                                      }
                                                   }
                                                   else
                                                   {
                                                      if(_owner._underConstruct && _owner == _target.parent)
                                                      {
                                                         _loc2_ = _owner.sourceWidth - _target.initWidth;
                                                      }
                                                      else
                                                      {
                                                         _loc2_ = _owner._rawWidth - _targetWidth;
                                                      }
                                                      if(param1.percent)
                                                      {
                                                         _loc2_ = _loc2_ / _targetWidth * _target._width;
                                                      }
                                                      if(_target == _owner.parent)
                                                      {
                                                         _owner.setSize(_target._width + _loc2_,_owner._rawHeight,true);
                                                      }
                                                      else
                                                      {
                                                         _owner.width = _target._width + _loc2_;
                                                      }
                                                   }
                                                }
                                                else
                                                {
                                                   _loc2_ = _owner.y + _owner._rawHeight - (_loc5_ + _targetHeight);
                                                   if(param1.percent)
                                                   {
                                                      _loc2_ = _loc2_ / _targetHeight * _target._height;
                                                   }
                                                   _owner.y = _loc5_ + _target._height + _loc2_ - _owner._rawHeight;
                                                }
                                             }
                                             else
                                             {
                                                _loc2_ = _owner.y + _owner._rawHeight - (_loc5_ + _targetHeight / 2);
                                                if(param1.percent)
                                                {
                                                   _loc2_ = _loc2_ / _targetHeight * _target._height;
                                                }
                                                _owner.y = _loc5_ + _target._height / 2 + _loc2_ - _owner._rawHeight;
                                             }
                                          }
                                          else
                                          {
                                             _loc2_ = _owner.y + _owner._rawHeight - _loc5_;
                                             if(param1.percent)
                                             {
                                                _loc2_ = _loc2_ / _targetHeight * _target._height;
                                             }
                                             _owner.y = _loc5_ + _loc2_ - _owner._rawHeight;
                                          }
                                       }
                                       else
                                       {
                                          _loc2_ = _owner.y + _owner._rawHeight / 2 - (_loc5_ + _targetHeight / 2);
                                          if(param1.percent)
                                          {
                                             _loc2_ = _loc2_ / _targetHeight * _target._height;
                                          }
                                          _owner.y = _loc5_ + _target._height / 2 + _loc2_ - _owner._rawHeight / 2;
                                       }
                                    }
                                    else
                                    {
                                       _loc2_ = _owner.y - (_loc5_ + _targetHeight);
                                       if(param1.percent)
                                       {
                                          _loc2_ = _loc2_ / _targetHeight * _target._height;
                                       }
                                       _owner.y = _loc5_ + _target._height + _loc2_;
                                    }
                                 }
                                 else
                                 {
                                    _loc2_ = _owner.y - (_loc5_ + _targetHeight / 2);
                                    if(param1.percent)
                                    {
                                       _loc2_ = _loc2_ / _targetHeight * _target._height;
                                    }
                                    _owner.y = _loc5_ + _target._height / 2 + _loc2_;
                                 }
                              }
                              else if(param1.percent && _target == _owner.parent)
                              {
                                 _loc2_ = _owner.y - _loc5_;
                                 if(param1.percent)
                                 {
                                    _loc2_ = _loc2_ / _targetHeight * _target._height;
                                 }
                                 _owner.y = _loc5_ + _loc2_;
                              }
                           }
                           else
                           {
                              _loc2_ = _owner.x + _owner._rawWidth - (_loc3_ + _targetWidth);
                              if(param1.percent)
                              {
                                 _loc2_ = _loc2_ / _targetWidth * _target._width;
                              }
                              _owner.x = _loc3_ + _target._width + _loc2_ - _owner._rawWidth;
                           }
                        }
                        else
                        {
                           _loc2_ = _owner.x + _owner._rawWidth - (_loc3_ + _targetWidth / 2);
                           if(param1.percent)
                           {
                              _loc2_ = _loc2_ / _targetWidth * _target._width;
                           }
                           _owner.x = _loc3_ + _target._width / 2 + _loc2_ - _owner._rawWidth;
                        }
                     }
                     else
                     {
                        _loc2_ = _owner.x + _owner._rawWidth - _loc3_;
                        if(param1.percent)
                        {
                           _loc2_ = _loc2_ / _targetWidth * _target._width;
                        }
                        _owner.x = _loc3_ + _loc2_ - _owner._rawWidth;
                     }
                  }
                  else
                  {
                     _loc2_ = _owner.x + _owner._rawWidth / 2 - (_loc3_ + _targetWidth / 2);
                     if(param1.percent)
                     {
                        _loc2_ = _loc2_ / _targetWidth * _target._width;
                     }
                     _owner.x = _loc3_ + _target._width / 2 + _loc2_ - _owner._rawWidth / 2;
                  }
               }
               else
               {
                  _loc2_ = _owner.x - (_loc3_ + _targetWidth);
                  if(param1.percent)
                  {
                     _loc2_ = _loc2_ / _targetWidth * _target._width;
                  }
                  _owner.x = _loc3_ + _target._width + _loc2_;
               }
            }
            else
            {
               _loc2_ = _owner.x - (_loc3_ + _targetWidth / 2);
               if(param1.percent)
               {
                  _loc2_ = _loc2_ / _targetWidth * _target._width;
               }
               _owner.x = _loc3_ + _target._width / 2 + _loc2_;
            }
         }
         else if(param1.percent && _target == _owner.parent)
         {
            _loc2_ = _owner.x - _loc3_;
            if(param1.percent)
            {
               _loc2_ = _loc2_ / _targetWidth * _target._width;
            }
            _owner.x = _loc3_ + _loc2_;
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
         var _loc5_:Number = _owner.x;
         var _loc7_:Number = _owner.y;
         var _loc3_:Number = _target.x - _targetX;
         var _loc4_:Number = _target.y - _targetY;
         var _loc9_:int = 0;
         var _loc8_:* = _defs;
         for each(var _loc6_ in _defs)
         {
            applyOnXYChanged(_loc6_,_loc3_,_loc4_);
         }
         _targetX = _target.x;
         _targetY = _target.y;
         if(_loc5_ != _owner.x || _loc7_ != _owner.y)
         {
            _loc5_ = _owner.x - _loc5_;
            _loc7_ = _owner.y - _loc7_;
            _owner.updateGearFromRelations(1,_loc5_,_loc7_);
            if(_owner.parent != null && _owner.parent._transitions.length > 0)
            {
               var _loc11_:int = 0;
               var _loc10_:* = _owner.parent._transitions;
               for each(var _loc2_ in _owner.parent._transitions)
               {
                  _loc2_.updateFromRelations(_owner.id,_loc5_,_loc7_);
               }
            }
         }
         _owner.relations.handling = null;
      }
      
      private function __targetSizeChanged(param1:GObject) : void
      {
         if(_owner.relations.handling != null)
         {
            _targetWidth = _target._width;
            _targetHeight = _target._height;
            return;
         }
         _owner.relations.handling = param1;
         var _loc3_:Number = _owner.x;
         var _loc7_:Number = _owner.y;
         var _loc4_:Number = _owner._rawWidth;
         var _loc6_:Number = _owner._rawHeight;
         var _loc9_:int = 0;
         var _loc8_:* = _defs;
         for each(var _loc5_ in _defs)
         {
            applyOnSizeChanged(_loc5_);
         }
         _targetWidth = _target._width;
         _targetHeight = _target._height;
         if(_loc3_ != _owner.x || _loc7_ != _owner.y)
         {
            _loc3_ = _owner.x - _loc3_;
            _loc7_ = _owner.y - _loc7_;
            _owner.updateGearFromRelations(1,_loc3_,_loc7_);
            if(_owner.parent != null && _owner.parent._transitions.length > 0)
            {
               var _loc11_:int = 0;
               var _loc10_:* = _owner.parent._transitions;
               for each(var _loc2_ in _owner.parent._transitions)
               {
                  _loc2_.updateFromRelations(_owner.id,_loc3_,_loc7_);
               }
            }
         }
         if(_loc4_ != _owner._rawWidth || _loc6_ != _owner._rawHeight)
         {
            _loc4_ = _owner._rawWidth - _loc4_;
            _loc6_ = _owner._rawHeight - _loc6_;
            _owner.updateGearFromRelations(2,_loc4_,_loc6_);
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
   
   function RelationDef()
   {
      super();
   }
   
   public function copyFrom(param1:RelationDef) : void
   {
      this.percent = param1.percent;
      this.type = param1.type;
   }
}

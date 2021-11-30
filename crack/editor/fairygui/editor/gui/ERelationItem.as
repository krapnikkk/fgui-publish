package fairygui.editor.gui
{
   public class ERelationItem
   {
      
      private static const RELATION_NAMES:Array = ["left-left","left-center","left-right","center-center","right-left","right-center","right-right","top-top","top-middle","top-bottom","middle-middle","bottom-top","bottom-middle","bottom-bottom","width-width","height-height","leftext-left","leftext-right","rightext-left","rightext-right","topext-top","topext-bottom","bottomext-top","bottomext-bottom"];
       
      
      private var _owner:EGObject;
      
      private var _target:EGObject;
      
      private var _defs:Vector.<ERelationDef>;
      
      private var _targetX:Number;
      
      private var _targetY:Number;
      
      private var _targetWidth:Number;
      
      private var _targetHeight:Number;
      
      private var _readOnly:Boolean;
      
      public function ERelationItem(param1:EGObject)
      {
         super();
         this._owner = param1;
         this._defs = new Vector.<ERelationDef>(2);
         this._defs[0] = new ERelationDef();
         this._defs[1] = new ERelationDef();
      }
      
      public function get owner() : EGObject
      {
         return this._owner;
      }
      
      public function get readOnly() : Boolean
      {
         return this._readOnly;
      }
      
      public function set(param1:EGObject, param2:String, param3:Boolean = false) : void
      {
         this._readOnly = param3;
         this.target = param1;
         this.updateDefs(param2);
      }
      
      public function updateDefs(param1:String) : void
      {
         var _loc9_:String = null;
         var _loc10_:* = null;
         var _loc2_:* = null;
         var _loc4_:Boolean = false;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:ERelationDef = null;
         var _loc5_:int = 0;
         var _loc11_:Array = param1.split(",");
         _loc8_ = 0;
         while(_loc8_ < 2)
         {
            this._defs[_loc8_].valid = false;
            _loc8_++;
         }
         var _loc3_:int = 0;
         _loc8_ = 0;
         while(_loc8_ < 2)
         {
            _loc9_ = _loc11_[_loc8_];
            if(_loc9_)
            {
               _loc3_++;
               _loc6_ = this._defs[_loc3_];
               if(_loc9_.charAt(_loc9_.length - 1) == "%")
               {
                  _loc9_ = _loc9_.substr(0,_loc9_.length - 1);
                  _loc4_ = true;
               }
               else
               {
                  _loc4_ = false;
               }
               _loc5_ = _loc9_.indexOf("-");
               if(_loc5_ == -1)
               {
                  _loc10_ = _loc9_;
                  _loc2_ = _loc9_;
               }
               else
               {
                  _loc10_ = _loc9_.substring(0,_loc5_);
                  _loc2_ = _loc9_.substring(_loc5_ + 1);
               }
               _loc7_ = RELATION_NAMES.indexOf(_loc10_ + "-" + _loc2_);
               if(_loc7_ == -1)
               {
                  throw new Error("invalid relation type");
               }
               _loc6_.selfSide = _loc10_;
               _loc6_.targetSide = _loc2_;
               _loc6_.affectBySelfSizeChanged = _loc7_ >= 3 && _loc7_ <= 6 || _loc7_ >= 10 && _loc7_ <= 13;
               _loc6_.percent = _loc4_;
               _loc6_.type = _loc7_;
               _loc6_.valid = true;
            }
            _loc8_++;
         }
      }
      
      public function get target() : EGObject
      {
         return this._target;
      }
      
      public function set target(param1:EGObject) : void
      {
         if(this._target != param1)
         {
            if(this._target)
            {
               this.releaseRefTarget(this._target);
            }
            this._target = param1;
            if(this._target)
            {
               this.addRefTarget(this._target);
            }
         }
      }
      
      public function get defs() : Vector.<ERelationDef>
      {
         return this._defs;
      }
      
      public function get containsWidthRelated() : Boolean
      {
         return this._defs[0].valid && (this._defs[0].type == 14 || this._defs[0].type == 19) || this._defs[1].valid && (this._defs[1].type == 14 || this._defs[1].type == 19);
      }
      
      public function get containsHeightRelated() : Boolean
      {
         return this._defs[0].valid && (this._defs[0].type == 15 || this._defs[0].type == 23) || this._defs[1].valid && (this._defs[1].type == 15 || this._defs[1].type == 23);
      }
      
      public function dispose() : void
      {
         if(this._target)
         {
            this.releaseRefTarget(this._target);
            this._target = null;
         }
      }
      
      public function get sidePair() : String
      {
         var _loc1_:ERelationDef = null;
         var _loc2_:* = "";
         _loc1_ = this._defs[0];
         if(_loc1_.valid)
         {
            _loc2_ = _loc1_.selfSide + "-" + _loc1_.targetSide + (!!_loc1_.percent?"%":"");
         }
         _loc1_ = this._defs[1];
         if(_loc1_.valid)
         {
            if(_loc2_.length)
            {
               _loc2_ = _loc2_ + ",";
            }
            _loc2_ = _loc2_ + (_loc1_.selfSide + "-" + _loc1_.targetSide + (!!_loc1_.percent?"%":""));
         }
         return _loc2_;
      }
      
      private function applyXYChanged(param1:Number, param2:Number) : void
      {
         var _loc3_:ERelationDef = null;
         if((this._owner.editMode == 3 && EGComponent(this._owner).disabled_relations || this._owner.parent && this._owner.parent.disabled_relations) && (this._target.editMode == 2 || this._target.editMode == 3))
         {
            return;
         }
         _loc3_ = this._defs[0];
         if(_loc3_.valid)
         {
            this.applyXYChanged2(_loc3_,param1,param2);
         }
         _loc3_ = this._defs[1];
         if(_loc3_.valid)
         {
            this.applyXYChanged2(_loc3_,param1,param2);
         }
      }
      
      private function applySizeChanged() : void
      {
         var _loc1_:ERelationDef = null;
         if((this._owner.editMode == 3 && EGComponent(this._owner).disabled_relations || this._owner.parent && this._owner.parent.disabled_relations) && (this._target.editMode == 2 || this._target.editMode == 3))
         {
            return;
         }
         _loc1_ = this._defs[0];
         if(_loc1_.valid)
         {
            this.applySizeChanged2(_loc1_);
         }
         _loc1_ = this._defs[1];
         if(_loc1_.valid)
         {
            this.applySizeChanged2(_loc1_);
         }
      }
      
      public function applySelfSizeChanged(param1:Number, param2:Number) : void
      {
         var _loc3_:ERelationDef = null;
         if(this._owner.editMode == 3 && EGComponent(this._owner).disabled_relations == 2 || this._owner.parent && this._owner.parent.disabled_relations == 2)
         {
            return;
         }
         _loc3_ = this._defs[0];
         if(_loc3_.valid && _loc3_.affectBySelfSizeChanged)
         {
            this.applySelfSizeChanged2(_loc3_,param1,param2);
         }
         _loc3_ = this._defs[1];
         if(_loc3_.valid && _loc3_.affectBySelfSizeChanged)
         {
            this.applySelfSizeChanged2(_loc3_,param1,param2);
         }
      }
      
      private function applyXYChanged2(param1:ERelationDef, param2:Number, param3:Number) : void
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
                                                                           this._owner.height = this._owner._rawHeight + param3;
                                                                        }
                                                                     }
                                                                     this._owner.y = this._owner.y + param3;
                                                                     this._owner.height = this._owner._rawHeight - param3;
                                                                  }
                                                               }
                                                               this._owner.width = this._owner._rawWidth + param2;
                                                            }
                                                         }
                                                         this._owner.x = this._owner.x + param2;
                                                         this._owner.width = this._owner._rawWidth - param2;
                                                      }
                                                   }
                                                }
                                             }
                                             addr28:
                                             this._owner.y = this._owner.y + param3;
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
                                 addr24:
                                 §§goto(addr25);
                              }
                              §§goto(addr24);
                           }
                           addr173:
                           return;
                        }
                        addr12:
                        this._owner.x = this._owner.x + param2;
                        §§goto(addr173);
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
      
      private function applySizeChanged2(param1:ERelationDef) : void
      {
         var _loc5_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this._target != this._owner.parent)
         {
            _loc5_ = Number(this._target.x);
            _loc3_ = Number(this._target.y);
         }
         else
         {
            _loc5_ = 0;
            _loc3_ = 0;
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
                                                                                 if(this._owner.editMode != 3 && this._owner == this._target.parent)
                                                                                 {
                                                                                    _loc4_ = this._owner.sourceHeight - (_loc3_ + this._target._initHeight);
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    _loc4_ = this._owner._rawHeight - (_loc3_ + this._targetHeight);
                                                                                 }
                                                                                 if(this._owner != this._target.parent)
                                                                                 {
                                                                                    _loc4_ = _loc4_ + this._owner.y;
                                                                                 }
                                                                                 if(param1.percent)
                                                                                 {
                                                                                    _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                                                                 }
                                                                                 if(this._owner != this._target.parent)
                                                                                 {
                                                                                    this._owner.height = _loc3_ + this._target._height + _loc4_ - this._owner.y;
                                                                                 }
                                                                                 else
                                                                                 {
                                                                                    this._owner.height = _loc3_ + this._target._height + _loc4_;
                                                                                 }
                                                                              }
                                                                           }
                                                                        }
                                                                        else
                                                                        {
                                                                           _loc4_ = this._owner.y - (_loc3_ + this._targetHeight);
                                                                           if(param1.percent)
                                                                           {
                                                                              _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                                                           }
                                                                           _loc2_ = this._owner.y;
                                                                           this._owner.y = _loc3_ + this._target._height + _loc4_;
                                                                           this._owner.height = this._owner._rawHeight - (this._owner.y - _loc2_);
                                                                        }
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     if(this._owner.editMode != 3 && this._owner == this._target.parent)
                                                                     {
                                                                        _loc4_ = this._owner.sourceWidth - (_loc5_ + this._target._initWidth);
                                                                     }
                                                                     else
                                                                     {
                                                                        _loc4_ = this._owner._rawWidth - (_loc5_ + this._targetWidth);
                                                                     }
                                                                     if(this._owner != this._target.parent)
                                                                     {
                                                                        _loc4_ = _loc4_ + this._owner.x;
                                                                     }
                                                                     if(param1.percent)
                                                                     {
                                                                        _loc4_ = _loc4_ / this._targetWidth * this._target._width;
                                                                     }
                                                                     if(this._owner != this._target.parent)
                                                                     {
                                                                        this._owner.width = _loc5_ + this._target._width + _loc4_ - this._owner.x;
                                                                     }
                                                                     else
                                                                     {
                                                                        this._owner.width = _loc5_ + this._target._width + _loc4_;
                                                                     }
                                                                  }
                                                               }
                                                            }
                                                            else
                                                            {
                                                               _loc4_ = this._owner.x - (_loc5_ + this._targetWidth);
                                                               if(param1.percent)
                                                               {
                                                                  _loc4_ = _loc4_ / this._targetWidth * this._target._width;
                                                               }
                                                               _loc2_ = this._owner.x;
                                                               this._owner.x = _loc5_ + this._target._width + _loc4_;
                                                               this._owner.width = this._owner._rawWidth - (this._owner.x - _loc2_);
                                                            }
                                                         }
                                                      }
                                                      else
                                                      {
                                                         if(this._owner.editMode != 3 && this._owner == this._target.parent)
                                                         {
                                                            _loc4_ = this._owner.sourceHeight - this._target._initHeight;
                                                         }
                                                         else
                                                         {
                                                            _loc4_ = this._owner._rawHeight - this._targetHeight;
                                                         }
                                                         if(param1.percent)
                                                         {
                                                            _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                                         }
                                                         if(this._target == this._owner.parent)
                                                         {
                                                            this._owner.setSize(this._owner._rawWidth,this._target._height + _loc4_,true);
                                                         }
                                                         else
                                                         {
                                                            this._owner.height = this._target._height + _loc4_;
                                                         }
                                                      }
                                                   }
                                                   else
                                                   {
                                                      if(this._owner.editMode != 3 && this._owner == this._target.parent)
                                                      {
                                                         _loc4_ = this._owner.sourceWidth - this._target._initWidth;
                                                      }
                                                      else
                                                      {
                                                         _loc4_ = this._owner._rawWidth - this._targetWidth;
                                                      }
                                                      if(param1.percent)
                                                      {
                                                         _loc4_ = _loc4_ / this._targetWidth * this._target._width;
                                                      }
                                                      if(this._target == this._owner.parent)
                                                      {
                                                         this._owner.setSize(this._target._width + _loc4_,this._owner._rawHeight,true);
                                                      }
                                                      else
                                                      {
                                                         this._owner.width = this._target._width + _loc4_;
                                                      }
                                                   }
                                                }
                                                else
                                                {
                                                   _loc4_ = this._owner.y + this._owner._rawHeight - (_loc3_ + this._targetHeight);
                                                   if(param1.percent)
                                                   {
                                                      _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                                   }
                                                   this._owner.y = _loc3_ + this._target._height + _loc4_ - this._owner._rawHeight;
                                                }
                                             }
                                             else
                                             {
                                                _loc4_ = this._owner.y + this._owner._rawHeight - (_loc3_ + this._targetHeight / 2);
                                                if(param1.percent)
                                                {
                                                   _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                                }
                                                this._owner.y = _loc3_ + this._target._height / 2 + _loc4_ - this._owner._rawHeight;
                                             }
                                          }
                                          else
                                          {
                                             _loc4_ = this._owner.y + this._owner._rawHeight - _loc3_;
                                             if(param1.percent)
                                             {
                                                _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                             }
                                             this._owner.y = _loc3_ + _loc4_ - this._owner._rawHeight;
                                          }
                                       }
                                       else
                                       {
                                          _loc4_ = this._owner.y + this._owner._rawHeight / 2 - (_loc3_ + this._targetHeight / 2);
                                          if(param1.percent)
                                          {
                                             _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                          }
                                          this._owner.y = _loc3_ + this._target._height / 2 + _loc4_ - this._owner._rawHeight / 2;
                                       }
                                    }
                                    else
                                    {
                                       _loc4_ = this._owner.y - (_loc3_ + this._targetHeight);
                                       if(param1.percent)
                                       {
                                          _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                       }
                                       this._owner.y = _loc3_ + this._target._height + _loc4_;
                                    }
                                 }
                                 else
                                 {
                                    _loc4_ = this._owner.y - (_loc3_ + this._targetHeight / 2);
                                    if(param1.percent)
                                    {
                                       _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                    }
                                    this._owner.y = _loc3_ + this._target._height / 2 + _loc4_;
                                 }
                              }
                              else if(param1.percent && this._target == this._owner.parent)
                              {
                                 _loc4_ = this._owner.y - _loc3_;
                                 if(param1.percent)
                                 {
                                    _loc4_ = _loc4_ / this._targetHeight * this._target._height;
                                 }
                                 this._owner.y = _loc3_ + _loc4_;
                              }
                           }
                           else
                           {
                              _loc4_ = this._owner.x + this._owner._rawWidth - (_loc5_ + this._targetWidth);
                              if(param1.percent)
                              {
                                 _loc4_ = _loc4_ / this._targetWidth * this._target._width;
                              }
                              this._owner.x = _loc5_ + this._target._width + _loc4_ - this._owner._rawWidth;
                           }
                        }
                        else
                        {
                           _loc4_ = this._owner.x + this._owner._rawWidth - (_loc5_ + this._targetWidth / 2);
                           if(param1.percent)
                           {
                              _loc4_ = _loc4_ / this._targetWidth * this._target._width;
                           }
                           this._owner.x = _loc5_ + this._target._width / 2 + _loc4_ - this._owner._rawWidth;
                        }
                     }
                     else
                     {
                        _loc4_ = this._owner.x + this._owner._rawWidth - _loc5_;
                        if(param1.percent)
                        {
                           _loc4_ = _loc4_ / this._targetWidth * this._target._width;
                        }
                        this._owner.x = _loc5_ + _loc4_ - this._owner._rawWidth;
                     }
                  }
                  else
                  {
                     _loc4_ = this._owner.x + this._owner._rawWidth / 2 - (_loc5_ + this._targetWidth / 2);
                     if(param1.percent)
                     {
                        _loc4_ = _loc4_ / this._targetWidth * this._target._width;
                     }
                     this._owner.x = _loc5_ + this._target._width / 2 + _loc4_ - this._owner._rawWidth / 2;
                  }
               }
               else
               {
                  _loc4_ = this._owner.x - (_loc5_ + this._targetWidth);
                  if(param1.percent)
                  {
                     _loc4_ = _loc4_ / this._targetWidth * this._target._width;
                  }
                  this._owner.x = _loc5_ + this._target._width + _loc4_;
               }
            }
            else
            {
               _loc4_ = this._owner.x - (_loc5_ + this._targetWidth / 2);
               if(param1.percent)
               {
                  _loc4_ = _loc4_ / this._targetWidth * this._target._width;
               }
               this._owner.x = _loc5_ + this._target._width / 2 + _loc4_;
            }
         }
         else if(param1.percent && this._target == this._owner.parent)
         {
            _loc4_ = this._owner.x - _loc5_;
            if(param1.percent)
            {
               _loc4_ = _loc4_ / this._targetWidth * this._target._width;
            }
            this._owner.x = _loc5_ + _loc4_;
         }
      }
      
      private function applySelfSizeChanged2(param1:ERelationDef, param2:Number, param3:Number) : void
      {
         switch(int(param1.type) - 3)
         {
            case 0:
               this._owner.x = this._owner.x - param2 / 2;
               break;
            case 1:
            case 2:
            case 3:
               this._owner.x = this._owner.x - param2;
               break;
            default:
               this._owner.x = this._owner.x - param2;
               break;
            default:
               this._owner.x = this._owner.x - param2;
               break;
            default:
               this._owner.x = this._owner.x - param2;
               break;
            case 7:
               this._owner.y = this._owner.y - param3 / 2;
               break;
            case 8:
            case 9:
            case 10:
               this._owner.y = this._owner.y - param3;
         }
      }
      
      private function addRefTarget(param1:EGObject) : void
      {
         if(param1 != this._owner.parent)
         {
            param1.statusDispatcher.addListener(1,this.__targetXYChanged);
         }
         param1.statusDispatcher.addListener(2,this.__targetSizeChanged);
         this._targetX = this._target.x;
         this._targetY = this._target.y;
         this._targetWidth = this._target._width;
         this._targetHeight = this._target._height;
      }
      
      private function releaseRefTarget(param1:EGObject) : void
      {
         param1.statusDispatcher.removeListener(1,this.__targetXYChanged);
         param1.statusDispatcher.removeListener(2,this.__targetSizeChanged);
      }
      
      private function __targetXYChanged(param1:EGObject) : void
      {
         var _loc3_:ETransition = null;
         if(this._owner.relations.handling || EGObject.snapshotHandling && this._owner.editMode == 2 || this._owner.groupInst != null && this._owner.groupInst.updating != 0 || this._owner is EGGroup && !EGGroup(this._owner).advanced)
         {
            this._targetX = this._target.x;
            this._targetY = this._target.y;
            return;
         }
         this._owner.relations.handling = param1;
         var _loc6_:Number = this._owner.x;
         var _loc4_:Number = this._owner.y;
         var _loc5_:Number = this._target.x - this._targetX;
         var _loc2_:Number = this._target.y - this._targetY;
         this.applyXYChanged(_loc5_,_loc2_);
         this._targetX = this._target.x;
         this._targetY = this._target.y;
         if(_loc6_ != this._owner.x || _loc4_ != this._owner.y)
         {
            _loc6_ = this._owner.x - _loc6_;
            _loc4_ = this._owner.y - _loc4_;
            this._owner.updateGearFromRelations(1,_loc6_,_loc4_);
            if(this._owner.editMode == 1 && this._owner.parent != null && !this._owner.parent.transitions.isEmpty)
            {
               var _loc8_:int = 0;
               var _loc7_:* = this._owner.parent.transitions.items;
               for each(_loc3_ in this._owner.parent.transitions.items)
               {
                  _loc3_.updateFromRelations(this._owner.id,_loc6_,_loc4_);
               }
            }
         }
         this._owner.relations.handling = null;
      }
      
      private function __targetSizeChanged(param1:EGObject) : void
      {
         var _loc3_:ETransition = null;
         if(this._owner.relations.handling || EGObject.snapshotHandling && this._owner.editMode == 2 || this._owner.groupInst != null && this._owner.groupInst.updating != 0 || this._owner is EGGroup && !EGGroup(this._owner).advanced)
         {
            this._targetWidth = this._target._width;
            this._targetHeight = this._target._height;
            return;
         }
         this._owner.relations.handling = param1;
         var _loc6_:Number = this._owner.x;
         var _loc4_:Number = this._owner.y;
         var _loc5_:Number = this._owner._rawWidth;
         var _loc2_:Number = this._owner._rawHeight;
         this.applySizeChanged();
         this._targetWidth = param1._width;
         this._targetHeight = param1._height;
         if(_loc6_ != this._owner.x || _loc4_ != this._owner.y)
         {
            _loc6_ = this._owner.x - _loc6_;
            _loc4_ = this._owner.y - _loc4_;
            this._owner.updateGearFromRelations(1,_loc6_,_loc4_);
            if(this._owner.editMode == 1 && this._owner.parent != null && !this._owner.parent.transitions.isEmpty)
            {
               var _loc8_:int = 0;
               var _loc7_:* = this._owner.parent.transitions.items;
               for each(_loc3_ in this._owner.parent.transitions.items)
               {
                  _loc3_.updateFromRelations(this._owner.id,_loc6_,_loc4_);
               }
            }
         }
         if(_loc5_ != this._owner._rawWidth || _loc2_ != this._owner._rawHeight)
         {
            _loc6_ = this._owner._rawWidth - _loc5_;
            _loc4_ = this._owner._rawHeight - _loc2_;
            this._owner.updateGearFromRelations(2,_loc6_,_loc4_);
         }
         this._owner.relations.handling = null;
      }
   }
}

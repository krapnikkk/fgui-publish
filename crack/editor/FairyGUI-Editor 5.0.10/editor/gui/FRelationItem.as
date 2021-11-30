package fairygui.editor.gui
{
   public class FRelationItem
   {
       
      
      private var _owner:FObject;
      
      private var _target:FObject;
      
      private var _defs:Vector.<FRelationDef>;
      
      private var _targetX:Number;
      
      private var _targetY:Number;
      
      private var _targetWidth:Number;
      
      private var _targetHeight:Number;
      
      private var _readOnly:Boolean;
      
      private var _containsWidthRelated:Boolean;
      
      private var _containsHeightRelated:Boolean;
      
      public function FRelationItem(param1:FObject)
      {
         super();
         this._owner = param1;
         this._defs = new Vector.<FRelationDef>();
      }
      
      public function get owner() : FObject
      {
         return this._owner;
      }
      
      public function get readOnly() : Boolean
      {
         return this._readOnly;
      }
      
      public function set(param1:FObject, param2:String, param3:Boolean = false) : void
      {
         this._readOnly = param3;
         this.target = param1;
         this.desc = param2;
      }
      
      public function get target() : FObject
      {
         return this._target;
      }
      
      public function set target(param1:FObject) : void
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
      
      public function get containsWidthRelated() : Boolean
      {
         return this._containsWidthRelated;
      }
      
      public function get containsHeightRelated() : Boolean
      {
         return this._containsHeightRelated;
      }
      
      public function dispose() : void
      {
         if(this._target)
         {
            this.releaseRefTarget(this._target);
            this._target = null;
         }
      }
      
      public function get defs() : Vector.<FRelationDef>
      {
         return this._defs;
      }
      
      public function get desc() : String
      {
         var _loc2_:FRelationDef = null;
         var _loc1_:* = "";
         for each(_loc2_ in this._defs)
         {
            if(_loc1_.length > 0)
            {
               _loc1_ = _loc1_ + ",";
            }
            _loc1_ = _loc1_ + _loc2_.toString();
         }
         return _loc1_;
      }
      
      public function set desc(param1:String) : void
      {
         this._containsWidthRelated = false;
         this._containsHeightRelated = false;
         this._defs.length = 0;
         this.addDefs(param1,false);
      }
      
      public function addDef(param1:int, param2:Boolean = false, param3:Boolean = true) : void
      {
         var _loc4_:FRelationDef = null;
         if(param1 == FRelationType.Size)
         {
            this.addDef(FRelationType.Width,param2,param3);
            this.addDef(FRelationType.Height,param2,param3);
            return;
         }
         if(param3)
         {
            for each(_loc4_ in this._defs)
            {
               if(_loc4_.type == param1)
               {
                  _loc4_.percent = param2;
                  return;
               }
            }
         }
         _loc4_ = new FRelationDef();
         this._defs.push(_loc4_);
         _loc4_.affectBySelfSizeChanged = param1 >= FRelationType.Center_Center && param1 <= FRelationType.Right_Right || param1 >= FRelationType.Middle_Middle && param1 <= FRelationType.Bottom_Bottom;
         _loc4_.percent = param2;
         _loc4_.type = param1;
         if(_loc4_.type == FRelationType.Width || _loc4_.type == FRelationType.RightExt_Right)
         {
            this._containsWidthRelated = true;
         }
         if(_loc4_.type == FRelationType.Height || _loc4_.type == FRelationType.BottomExt_Bottom)
         {
            this._containsHeightRelated = true;
         }
      }
      
      public function addDefs(param1:String, param2:Boolean = true) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:Array = param1.split(",");
         var _loc10_:int = _loc3_.length;
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            _loc4_ = _loc3_[_loc8_];
            if(_loc4_)
            {
               if(_loc4_.charAt(_loc4_.length - 1) == "%")
               {
                  _loc4_ = _loc4_.substr(0,_loc4_.length - 1);
                  _loc7_ = true;
               }
               else
               {
                  _loc7_ = false;
               }
               _loc11_ = _loc4_.indexOf("-");
               if(_loc11_ == -1)
               {
                  _loc5_ = _loc4_;
                  _loc6_ = _loc4_;
               }
               else
               {
                  _loc5_ = _loc4_.substring(0,_loc11_);
                  _loc6_ = _loc4_.substring(_loc11_ + 1);
               }
               _loc9_ = FRelationType.Names.indexOf(_loc5_ + "-" + _loc6_);
               if(_loc9_ != -1)
               {
                  this.addDef(_loc9_,_loc7_,param2);
               }
            }
            _loc8_++;
         }
      }
      
      public function hasDef(param1:int) : Boolean
      {
         var _loc2_:FRelationDef = null;
         for each(_loc2_ in this._defs)
         {
            if(_loc2_.type == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function applyXYChanged(param1:Number, param2:Number) : void
      {
         var _loc3_:FRelationDef = null;
         if(this._owner.docElement && this._owner.docElement.relationsDisabled)
         {
            return;
         }
         for each(_loc3_ in this._defs)
         {
            this.applyXYChanged2(_loc3_,param1,param2);
         }
      }
      
      private function applySizeChanged() : void
      {
         var _loc1_:FRelationDef = null;
         if(this._owner.docElement && this._owner.docElement.relationsDisabled)
         {
            return;
         }
         for each(_loc1_ in this._defs)
         {
            this.applySizeChanged2(_loc1_);
         }
      }
      
      public function applySelfSizeChanged(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc6_:FRelationDef = null;
         var _loc7_:FTransition = null;
         if(this._owner.docElement && this._owner.docElement.relationsDisabled)
         {
            return;
         }
         var _loc4_:Number = this._owner.x;
         var _loc5_:Number = this._owner.y;
         for each(_loc6_ in this._defs)
         {
            this.applySelfSizeChanged2(_loc6_,param1,param2,param3);
         }
         if(_loc4_ != this._owner.x || _loc5_ != this._owner.y)
         {
            _loc4_ = this._owner.x - _loc4_;
            _loc5_ = this._owner.y - _loc5_;
            this._owner.updateGearFromRelations(1,_loc4_,_loc5_);
            if((this._owner._flags & FObjectFlags.IN_TEST) != 0 && this._owner._parent != null && !this._owner._parent.transitions.isEmpty)
            {
               for each(_loc7_ in this._owner._parent.transitions.items)
               {
                  _loc7_.updateFromRelations(this._owner._id,_loc4_,_loc5_);
               }
            }
         }
      }
      
      private function applyXYChanged2(param1:FRelationDef, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         switch(param1.type)
         {
            case FRelationType.Left_Left:
            case FRelationType.Left_Center:
            case FRelationType.Left_Right:
            case FRelationType.Center_Center:
            case FRelationType.Right_Left:
            case FRelationType.Right_Center:
            case FRelationType.Right_Right:
               this._owner.x = this._owner.x + param2;
               break;
            case FRelationType.Top_Top:
            case FRelationType.Top_Middle:
            case FRelationType.Top_Bottom:
            case FRelationType.Middle_Middle:
            case FRelationType.Bottom_Top:
            case FRelationType.Bottom_Middle:
            case FRelationType.Bottom_Bottom:
               this._owner.y = this._owner.y + param3;
               break;
            case FRelationType.Width:
            case FRelationType.Height:
               break;
            case FRelationType.LeftExt_Left:
            case FRelationType.LeftExt_Right:
               if(this._owner != this._target.parent)
               {
                  _loc4_ = this._owner.xMin;
                  this._owner.width = this._owner._rawWidth - param2;
                  this._owner.xMin = _loc4_ + param2;
               }
               else
               {
                  this._owner.setSize(this._owner._rawWidth - param2,this._owner._rawHeight,false,true);
               }
               break;
            case FRelationType.RightExt_Left:
            case FRelationType.RightExt_Right:
               if(this._owner != this._target.parent)
               {
                  _loc4_ = this._owner.xMin;
                  this._owner.width = this._owner._rawWidth + param2;
                  this._owner.xMin = _loc4_;
               }
               else
               {
                  this._owner.setSize(this._owner._rawWidth + param2,this._owner._rawHeight,false,true);
               }
               break;
            case FRelationType.TopExt_Top:
            case FRelationType.TopExt_Bottom:
               if(this._owner != this._target.parent)
               {
                  _loc4_ = this._owner.yMin;
                  this._owner.height = this._owner._rawHeight - param3;
                  this._owner.yMin = _loc4_ + param3;
               }
               else
               {
                  this._owner.setSize(this._owner._rawWidth,this._owner._rawHeight - param3,false,true);
               }
               break;
            case FRelationType.BottomExt_Top:
            case FRelationType.BottomExt_Bottom:
               if(this._owner != this._target.parent)
               {
                  _loc4_ = this._owner.yMin;
                  this._owner.height = this._owner._rawHeight + param3;
                  this._owner.yMin = _loc4_;
               }
               else
               {
                  this._owner.setSize(this._owner._rawWidth,this._owner._rawHeight + param3,false,true);
               }
         }
      }
      
      private function applySizeChanged2(param1:FRelationDef) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(param1.type < FRelationType.Top_Top)
         {
            if(this._target != this._owner._parent)
            {
               _loc2_ = this._target.x;
               if(this._target.anchor)
               {
                  _loc3_ = this._target.pivotX;
               }
            }
            if(param1.percent)
            {
               if(this._targetWidth != 0)
               {
                  _loc4_ = this._target._width / this._targetWidth;
               }
            }
            else
            {
               _loc4_ = this._target._width - this._targetWidth;
            }
         }
         else
         {
            if(this._target != this._owner._parent)
            {
               _loc2_ = this._target.y;
               if(this._target.anchor)
               {
                  _loc3_ = this._target.pivotY;
               }
            }
            if(param1.percent)
            {
               if(this._targetHeight != 0)
               {
                  _loc4_ = this._target._height / this._targetHeight;
               }
            }
            else
            {
               _loc4_ = this._target._height - this._targetHeight;
            }
         }
         switch(param1.type)
         {
            case FRelationType.Left_Left:
               if(param1.percent)
               {
                  this._owner.xMin = _loc2_ + (this._owner.xMin - _loc2_) * _loc4_;
               }
               else
               {
                  this._owner.x = this._owner.x + _loc4_ * -_loc3_;
               }
               break;
            case FRelationType.Left_Center:
               if(param1.percent)
               {
                  this._owner.xMin = _loc2_ + (this._owner.xMin - _loc2_) * _loc4_;
               }
               else
               {
                  this._owner.x = this._owner.x + _loc4_ * (0.5 - _loc3_);
               }
               break;
            case FRelationType.Left_Right:
               if(param1.percent)
               {
                  this._owner.xMin = _loc2_ + (this._owner.xMin - _loc2_) * _loc4_;
               }
               else
               {
                  this._owner.x = this._owner.x + _loc4_ * (1 - _loc3_);
               }
               break;
            case FRelationType.Center_Center:
               if(param1.percent)
               {
                  this._owner.xMin = _loc2_ + (this._owner.xMin + this._owner._rawWidth * 0.5 - _loc2_) * _loc4_ - this._owner._rawWidth * 0.5;
               }
               else
               {
                  this._owner.x = this._owner.x + _loc4_ * (0.5 - _loc3_);
               }
               break;
            case FRelationType.Right_Left:
               if(param1.percent)
               {
                  this._owner.xMin = _loc2_ + (this._owner.xMin + this._owner._rawWidth - _loc2_) * _loc4_ - this._owner._rawWidth;
               }
               else
               {
                  this._owner.x = this._owner.x + _loc4_ * -_loc3_;
               }
               break;
            case FRelationType.Right_Center:
               if(param1.percent)
               {
                  this._owner.xMin = _loc2_ + (this._owner.xMin + this._owner._rawWidth - _loc2_) * _loc4_ - this._owner._rawWidth;
               }
               else
               {
                  this._owner.x = this._owner.x + _loc4_ * (0.5 - _loc3_);
               }
               break;
            case FRelationType.Right_Right:
               if(param1.percent)
               {
                  this._owner.xMin = _loc2_ + (this._owner.xMin + this._owner._rawWidth - _loc2_) * _loc4_ - this._owner._rawWidth;
               }
               else
               {
                  this._owner.x = this._owner.x + _loc4_ * (1 - _loc3_);
               }
               break;
            case FRelationType.Top_Top:
               if(param1.percent)
               {
                  this._owner.yMin = _loc2_ + (this._owner.yMin - _loc2_) * _loc4_;
               }
               else
               {
                  this._owner.y = this._owner.y + _loc4_ * -_loc3_;
               }
               break;
            case FRelationType.Top_Middle:
               if(param1.percent)
               {
                  this._owner.yMin = _loc2_ + (this._owner.yMin - _loc2_) * _loc4_;
               }
               else
               {
                  this._owner.y = this._owner.y + _loc4_ * (0.5 - _loc3_);
               }
               break;
            case FRelationType.Top_Bottom:
               if(param1.percent)
               {
                  this._owner.yMin = _loc2_ + (this._owner.yMin - _loc2_) * _loc4_;
               }
               else
               {
                  this._owner.y = this._owner.y + _loc4_ * (1 - _loc3_);
               }
               break;
            case FRelationType.Middle_Middle:
               if(param1.percent)
               {
                  this._owner.yMin = _loc2_ + (this._owner.yMin + this._owner._rawHeight * 0.5 - _loc2_) * _loc4_ - this._owner._rawHeight * 0.5;
               }
               else
               {
                  this._owner.y = this._owner.y + _loc4_ * (0.5 - _loc3_);
               }
               break;
            case FRelationType.Bottom_Top:
               if(param1.percent)
               {
                  this._owner.yMin = _loc2_ + (this._owner.yMin + this._owner._rawHeight - _loc2_) * _loc4_ - this._owner._rawHeight;
               }
               else
               {
                  this._owner.y = this._owner.y + _loc4_ * -_loc3_;
               }
               break;
            case FRelationType.Bottom_Middle:
               if(param1.percent)
               {
                  this._owner.yMin = _loc2_ + (this._owner.yMin + this._owner._rawHeight - _loc2_) * _loc4_ - this._owner._rawHeight;
               }
               else
               {
                  this._owner.y = this._owner.y + _loc4_ * (0.5 - _loc3_);
               }
               break;
            case FRelationType.Bottom_Bottom:
               if(param1.percent)
               {
                  this._owner.yMin = _loc2_ + (this._owner.yMin + this._owner._rawHeight - _loc2_) * _loc4_ - this._owner._rawHeight;
               }
               else
               {
                  this._owner.y = this._owner.y + _loc4_ * (1 - _loc3_);
               }
               break;
            case FRelationType.Width:
               if(!FObjectFlags.isDocRoot(this._owner._flags) && this._owner == this._target.parent)
               {
                  _loc5_ = this._owner.sourceWidth - this._target.initWidth;
               }
               else
               {
                  _loc5_ = this._owner._rawWidth - this._targetWidth;
               }
               if(param1.percent)
               {
                  _loc5_ = _loc5_ * _loc4_;
               }
               if(this._target == this._owner._parent)
               {
                  if(this._owner.anchor)
                  {
                     _loc6_ = this._owner.xMin;
                     this._owner.setSize(this._target._width + _loc5_,this._owner._rawHeight,true);
                     this._owner.xMin = _loc6_;
                  }
                  else
                  {
                     this._owner.setSize(this._target._width + _loc5_,this._owner._rawHeight,true);
                  }
               }
               else
               {
                  this._owner.setSize(this._target._width + _loc5_,this._owner._rawHeight,false,this._owner == this._target.parent);
               }
               break;
            case FRelationType.Height:
               if(!FObjectFlags.isDocRoot(this._owner._flags) && this._owner == this._target.parent)
               {
                  _loc5_ = this._owner.sourceHeight - this._target.initHeight;
               }
               else
               {
                  _loc5_ = this._owner._rawHeight - this._targetHeight;
               }
               if(param1.percent)
               {
                  _loc5_ = _loc5_ * _loc4_;
               }
               if(this._target == this._owner._parent)
               {
                  if(this._owner.anchor)
                  {
                     _loc6_ = this._owner.yMin;
                     this._owner.setSize(this._owner._rawWidth,this._target._height + _loc5_,true);
                     this._owner.yMin = _loc6_;
                  }
                  else
                  {
                     this._owner.setSize(this._owner._rawWidth,this._target._height + _loc5_,true);
                  }
               }
               else
               {
                  this._owner.setSize(this._owner._rawWidth,this._target._height + _loc5_,false,this._owner == this._target.parent);
               }
               break;
            case FRelationType.LeftExt_Left:
               _loc6_ = this._owner.xMin;
               if(param1.percent)
               {
                  _loc5_ = _loc2_ + (_loc6_ - _loc2_) * _loc4_ - _loc6_;
               }
               else
               {
                  _loc5_ = _loc4_ * -_loc3_;
               }
               this._owner.width = this._owner._rawWidth - _loc5_;
               this._owner.xMin = _loc6_ + _loc5_;
               break;
            case FRelationType.LeftExt_Right:
               _loc6_ = this._owner.xMin;
               if(param1.percent)
               {
                  _loc5_ = _loc2_ + (_loc6_ - _loc2_) * _loc4_ - _loc6_;
               }
               else
               {
                  _loc5_ = _loc4_ * (1 - _loc3_);
               }
               this._owner.width = this._owner._rawWidth - _loc5_;
               this._owner.xMin = _loc6_ + _loc5_;
               break;
            case FRelationType.RightExt_Left:
               _loc6_ = this._owner.xMin;
               if(param1.percent)
               {
                  _loc5_ = _loc2_ + (_loc6_ + this._owner._rawWidth - _loc2_) * _loc4_ - (_loc6_ + this._owner._rawWidth);
               }
               else
               {
                  _loc5_ = _loc4_ * -_loc3_;
               }
               this._owner.width = this._owner._rawWidth + _loc5_;
               this._owner.xMin = _loc6_;
               break;
            case FRelationType.RightExt_Right:
               if(param1.percent)
               {
                  if(this._owner == this._target.parent)
                  {
                     if(!FObjectFlags.isDocRoot(this._owner._flags))
                     {
                        _loc6_ = _loc2_ + this._target._width - this._target._width * _loc3_ + (this._owner.sourceWidth - _loc2_ - this._target.initWidth + this._target.initWidth * _loc3_) * _loc4_;
                     }
                     else
                     {
                        _loc6_ = _loc2_ + (this._owner._rawWidth - _loc2_) * _loc4_;
                     }
                     this._owner.setSize(_loc6_,this._owner._rawHeight,false,true);
                  }
                  else
                  {
                     _loc6_ = this._owner.xMin;
                     _loc5_ = _loc2_ + (_loc6_ + this._owner._rawWidth - _loc2_) * _loc4_ - (_loc6_ + this._owner._rawWidth);
                     this._owner.width = this._owner._rawWidth + _loc5_;
                     this._owner.xMin = _loc6_;
                  }
               }
               else if(this._owner == this._target.parent)
               {
                  if(!FObjectFlags.isDocRoot(this._owner._flags))
                  {
                     _loc6_ = this._owner.sourceWidth + (this._target._width - this._target.initWidth) * (1 - _loc3_);
                  }
                  else
                  {
                     _loc6_ = this._owner._rawWidth + _loc4_ * (1 - _loc3_);
                  }
                  this._owner.setSize(_loc6_,this._owner._rawHeight,false,true);
               }
               else
               {
                  _loc6_ = this._owner.xMin;
                  _loc5_ = _loc4_ * (1 - _loc3_);
                  this._owner.width = this._owner._rawWidth + _loc5_;
                  this._owner.xMin = _loc6_;
               }
               break;
            case FRelationType.TopExt_Top:
               _loc6_ = this._owner.yMin;
               if(param1.percent)
               {
                  _loc5_ = _loc2_ + (_loc6_ - _loc2_) * _loc4_ - _loc6_;
               }
               else
               {
                  _loc5_ = _loc4_ * -_loc3_;
               }
               this._owner.height = this._owner._rawHeight - _loc5_;
               this._owner.yMin = _loc6_ + _loc5_;
               break;
            case FRelationType.TopExt_Bottom:
               _loc6_ = this._owner.yMin;
               if(param1.percent)
               {
                  _loc5_ = _loc2_ + (_loc6_ - _loc2_) * _loc4_ - _loc6_;
               }
               else
               {
                  _loc5_ = _loc4_ * (1 - _loc3_);
               }
               this._owner.height = this._owner._rawHeight - _loc5_;
               this._owner.yMin = _loc6_ + _loc5_;
               break;
            case FRelationType.BottomExt_Top:
               _loc6_ = this._owner.yMin;
               if(param1.percent)
               {
                  _loc5_ = _loc2_ + (_loc6_ + this._owner._rawHeight - _loc2_) * _loc4_ - (_loc6_ + this._owner._rawHeight);
               }
               else
               {
                  _loc5_ = _loc4_ * -_loc3_;
               }
               this._owner.height = this._owner._rawHeight + _loc5_;
               this._owner.yMin = _loc6_;
               break;
            case FRelationType.BottomExt_Bottom:
               if(param1.percent)
               {
                  if(this._owner == this._target.parent)
                  {
                     if(!FObjectFlags.isDocRoot(this._owner._flags))
                     {
                        _loc6_ = _loc2_ + this._target._height - this._target._height * _loc3_ + (this._owner.sourceHeight - _loc2_ - this._target.initHeight + this._target.initHeight * _loc3_) * _loc4_;
                     }
                     else
                     {
                        _loc6_ = _loc2_ + (this._owner._rawHeight - _loc2_) * _loc4_;
                     }
                     this._owner.setSize(this._owner._rawWidth,_loc6_,false,true);
                  }
                  else
                  {
                     _loc6_ = this._owner.yMin;
                     _loc5_ = _loc2_ + (_loc6_ + this._owner._rawHeight - _loc2_) * _loc4_ - (_loc6_ + this._owner._rawHeight);
                     this._owner.height = this._owner._rawHeight + _loc5_;
                     this._owner.yMin = _loc6_;
                  }
               }
               else if(this._owner == this._target.parent)
               {
                  if(!FObjectFlags.isDocRoot(this._owner._flags))
                  {
                     _loc6_ = this._owner.sourceHeight + (this._target._height - this._target.initHeight) * (1 - _loc3_);
                  }
                  else
                  {
                     _loc6_ = this._owner._rawHeight + _loc4_ * (1 - _loc3_);
                  }
                  this._owner.setSize(this._owner._rawWidth,_loc6_,false,true);
               }
               else
               {
                  _loc6_ = this._owner.yMin;
                  _loc5_ = _loc4_ * (1 - _loc3_);
                  this._owner.height = this._owner._rawHeight + _loc5_;
                  this._owner.yMin = _loc6_;
               }
         }
      }
      
      private function applySelfSizeChanged2(param1:FRelationDef, param2:Number, param3:Number, param4:Boolean) : void
      {
         switch(param1.type)
         {
            case FRelationType.Center_Center:
               this._owner.x = this._owner.x - (0.5 - (!!param4?this._owner.pivotX:0)) * param2;
               break;
            case FRelationType.Right_Center:
            case FRelationType.Right_Left:
            case FRelationType.Right_Right:
               this._owner.x = this._owner.x - (1 - (!!param4?this._owner.pivotX:0)) * param2;
               break;
            case FRelationType.Middle_Middle:
               this._owner.y = this._owner.y - (0.5 - (!!param4?this._owner.pivotY:0)) * param3;
               break;
            case FRelationType.Bottom_Middle:
            case FRelationType.Bottom_Top:
            case FRelationType.Bottom_Bottom:
               this._owner.y = this._owner.y - (1 - (!!param4?this._owner.pivotY:0)) * param3;
         }
      }
      
      private function addRefTarget(param1:FObject) : void
      {
         if(param1 != this._owner._parent)
         {
            param1.dispatcher.on(FObject.XY_CHANGED,this.__targetXYChanged);
         }
         param1.dispatcher.on(FObject.SIZE_CHANGED,this.__targetSizeChanged);
         this._targetX = this._target.x;
         this._targetY = this._target.y;
         this._targetWidth = this._target._width;
         this._targetHeight = this._target._height;
      }
      
      private function releaseRefTarget(param1:FObject) : void
      {
         param1.dispatcher.off(FObject.XY_CHANGED,this.__targetXYChanged);
         param1.dispatcher.off(FObject.SIZE_CHANGED,this.__targetSizeChanged);
      }
      
      private function __targetXYChanged(param1:FObject) : void
      {
         var _loc6_:FTransition = null;
         if(this._owner.relations.handling || FObject.loadingSnapshot && this._owner._hasSnapshot || this._owner._group != null && this._owner._group._updating != 0 || this._owner is FGroup && !FGroup(this._owner).advanced)
         {
            this._targetX = this._target.x;
            this._targetY = this._target.y;
            return;
         }
         this._owner.relations.handling = param1;
         var _loc2_:Number = this._owner.x;
         var _loc3_:Number = this._owner.y;
         var _loc4_:Number = this._target.x - this._targetX;
         var _loc5_:Number = this._target.y - this._targetY;
         this.applyXYChanged(_loc4_,_loc5_);
         this._targetX = this._target.x;
         this._targetY = this._target.y;
         if(_loc2_ != this._owner.x || _loc3_ != this._owner.y)
         {
            _loc2_ = this._owner.x - _loc2_;
            _loc3_ = this._owner.y - _loc3_;
            this._owner.updateGearFromRelations(1,_loc2_,_loc3_);
            if((this._owner._flags & FObjectFlags.IN_TEST) != 0 && this._owner._parent != null && !this._owner._parent.transitions.isEmpty)
            {
               for each(_loc6_ in this._owner._parent.transitions.items)
               {
                  _loc6_.updateFromRelations(this._owner._id,_loc2_,_loc3_);
               }
            }
         }
         this._owner.relations.handling = null;
      }
      
      private function __targetSizeChanged(param1:FObject) : void
      {
         var _loc6_:FTransition = null;
         if(this._owner.relations.handling || FObject.loadingSnapshot && this._owner._hasSnapshot || this._owner._group != null && this._owner._group._updating != 0 || this._owner is FGroup && !FGroup(this._owner).advanced)
         {
            this._targetWidth = this._target._width;
            this._targetHeight = this._target._height;
            return;
         }
         this._owner.relations.handling = param1;
         var _loc2_:Number = this._owner.x;
         var _loc3_:Number = this._owner.y;
         var _loc4_:Number = this._owner._rawWidth;
         var _loc5_:Number = this._owner._rawHeight;
         this.applySizeChanged();
         this._targetWidth = param1._width;
         this._targetHeight = param1._height;
         if(_loc2_ != this._owner.x || _loc3_ != this._owner.y)
         {
            _loc2_ = this._owner.x - _loc2_;
            _loc3_ = this._owner.y - _loc3_;
            this._owner.updateGearFromRelations(1,_loc2_,_loc3_);
            if((this._owner._flags & FObjectFlags.IN_TEST) != 0 && this._owner._parent != null && !this._owner._parent.transitions.isEmpty)
            {
               for each(_loc6_ in this._owner._parent.transitions.items)
               {
                  _loc6_.updateFromRelations(this._owner._id,_loc2_,_loc3_);
               }
            }
         }
         if(_loc4_ != this._owner._rawWidth || _loc5_ != this._owner._rawHeight)
         {
            _loc2_ = this._owner._rawWidth - _loc4_;
            _loc3_ = this._owner._rawHeight - _loc5_;
            this._owner.updateGearFromRelations(2,_loc2_,_loc3_);
         }
         this._owner.relations.handling = null;
      }
   }
}

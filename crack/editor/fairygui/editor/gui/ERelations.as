package fairygui.editor.gui
{
   public class ERelations
   {
       
      
      private var _owner:EGObject;
      
      private var _items:Vector.<ERelationItem>;
      
      private var _widthLocked:Boolean;
      
      private var _heightLocked:Boolean;
      
      public var handling:EGObject;
      
      public function ERelations(param1:EGObject)
      {
         super();
         this._owner = param1;
         this._items = new Vector.<ERelationItem>();
      }
      
      public function get widthLocked() : Boolean
      {
         return this._widthLocked;
      }
      
      public function get heightLocked() : Boolean
      {
         return this._heightLocked;
      }
      
      public function addItem(param1:EGObject, param2:String, param3:Boolean = false) : ERelationItem
      {
         var _loc4_:ERelationItem = new ERelationItem(this._owner);
         _loc4_.set(param1,param2,param3);
         this._items.push(_loc4_);
         return _loc4_;
      }
      
      public function removeItem(param1:ERelationItem) : void
      {
         var _loc2_:int = this._items.indexOf(param1);
         param1.dispose();
         this._items.splice(_loc2_,1);
      }
      
      public function addItem2(param1:EGObject, param2:String, param3:String) : ERelationItem
      {
         this.removeItem2(param1,param2,param3);
         return this.addItem(param1,param2 + "-" + param3);
      }
      
      public function removeItem2(param1:EGObject, param2:String, param3:String) : void
      {
         var _loc5_:ERelationItem = null;
         var _loc6_:int = this._items.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc6_)
         {
            _loc5_ = this._items[_loc4_];
            if(_loc5_.defs[0].valid && _loc5_.defs[0].selfSide == param2 && _loc5_.defs[0].targetSide == param3)
            {
               _loc5_.defs[0].valid = false;
            }
            if(_loc5_.defs[1].valid && _loc5_.defs[1].selfSide == param2 && _loc5_.defs[1].targetSide == param3)
            {
               _loc5_.defs[1].valid = false;
            }
            if(!_loc5_.defs[0].valid && !_loc5_.defs[1].valid)
            {
               this.removeItem(_loc5_);
               _loc6_--;
            }
            else
            {
               _loc4_++;
            }
         }
      }
      
      public function replaceItem(param1:int, param2:EGObject, param3:String) : void
      {
         var _loc4_:ERelationItem = this._items[param1];
         _loc4_.set(param2,param3,false);
      }
      
      public function get items() : Vector.<ERelationItem>
      {
         return this._items;
      }
      
      public function hasTarget(param1:EGObject) : Boolean
      {
         var _loc3_:int = this._items.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._items[_loc2_].target == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function removeTarget(param1:EGObject) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ERelationItem = null;
         var _loc4_:int = this._items.length;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._items[_loc2_];
            if(_loc3_.target == param1)
            {
               _loc3_.dispose();
               this._items.splice(_loc2_,1);
               _loc4_--;
            }
            else
            {
               _loc2_++;
            }
         }
      }
      
      public function replaceTarget(param1:EGObject, param2:EGObject) : void
      {
         var _loc3_:int = this._items.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._items[_loc4_].target == param1)
            {
               this._items[_loc4_].target = param2;
            }
            _loc4_++;
         }
      }
      
      public function onOwnerSizeChanged(param1:Boolean, param2:Number, param3:Number) : void
      {
         var _loc4_:ERelationItem = null;
         if(this._items.length == 0)
         {
            return;
         }
         var _loc6_:int = 0;
         var _loc5_:* = this._items;
         for each(_loc4_ in this._items)
         {
            if(!param1)
            {
               _loc4_.applySelfSizeChanged(param2,param3);
            }
         }
      }
      
      public function reset() : void
      {
         var _loc2_:int = this._items.length;
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            this._items[_loc1_].dispose();
            _loc1_++;
         }
         this._items.length = 0;
         this._widthLocked = false;
         this._heightLocked = false;
      }
      
      public function get isEmpty() : Boolean
      {
         return this._items.length == 0;
      }
      
      public function fromXML(param1:XML, param2:Boolean = false) : void
      {
         var _loc10_:String = null;
         var _loc3_:EGObject = null;
         var _loc5_:XML = null;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:ERelationItem = null;
         var _loc4_:Boolean = false;
         if(param2)
         {
            this.reset();
         }
         else
         {
            _loc8_ = this._items.length;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc6_ = this._items[_loc7_];
               if(!_loc6_.readOnly)
               {
                  _loc6_.dispose();
                  this._items.splice(_loc7_,1);
                  _loc8_--;
               }
               else
               {
                  _loc7_++;
               }
            }
         }
         var _loc9_:XMLList = param1.relation;
         if(param2)
         {
            this._widthLocked = false;
            this._heightLocked = false;
         }
         var _loc12_:int = 0;
         var _loc11_:* = _loc9_;
         for each(_loc5_ in _loc9_)
         {
            _loc10_ = _loc5_.@target;
            if(param2)
            {
               _loc3_ = EGComponent(this._owner).getChildById(_loc10_);
            }
            else if(this._owner.parent)
            {
               if(_loc10_)
               {
                  _loc3_ = this._owner.parent.getChildById(_loc10_);
               }
               else
               {
                  _loc3_ = this._owner.parent;
               }
            }
            if(_loc3_)
            {
               _loc4_ = param2 && this._owner.editMode != 3;
               _loc6_ = this.addItem(_loc3_,_loc5_.@sidePair,_loc4_);
               if(_loc4_)
               {
                  this._widthLocked = _loc6_.containsWidthRelated;
                  this._heightLocked = _loc6_.containsHeightRelated;
               }
            }
         }
      }
      
      public function toXML() : XML
      {
         var _loc4_:ERelationItem = null;
         var _loc2_:XML = null;
         var _loc5_:XML = <relations/>;
         var _loc3_:int = this._items.length;
         var _loc1_:int = 0;
         while(_loc1_ < _loc3_)
         {
            _loc4_ = this._items[_loc1_];
            if(!(this._owner.editMode != 3 && _loc4_.readOnly))
            {
               _loc2_ = <relation/>;
               if(_loc4_.target == this._owner.parent)
               {
                  _loc2_.@target = "";
               }
               else
               {
                  _loc2_.@target = _loc4_.target._id;
               }
               _loc2_.@sidePair = _loc4_.sidePair;
               _loc5_.appendChild(_loc2_);
            }
            _loc1_++;
         }
         return _loc5_;
      }
   }
}

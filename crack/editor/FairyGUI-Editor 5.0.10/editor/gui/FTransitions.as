package fairygui.editor.gui
{
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   
   public class FTransitions
   {
      
      private static var helperArray:Array = [];
       
      
      private var _owner:FComponent;
      
      private var _items:Vector.<FTransition>;
      
      private var _nextId:int;
      
      private var _snapshot:Vector.<ObjectSnapshot>;
      
      private var _controllerSnapshot:Vector.<String>;
      
      public var _loadingSnapshot:Boolean;
      
      public function FTransitions(param1:FComponent)
      {
         super();
         this._owner = param1;
         this._items = new Vector.<FTransition>();
      }
      
      public function get items() : Vector.<FTransition>
      {
         return this._items;
      }
      
      public function get isEmpty() : Boolean
      {
         return this._items.length == 0;
      }
      
      public function addItem(param1:String = null) : FTransition
      {
         var _loc2_:FTransition = new FTransition(this._owner);
         if(param1 == null)
         {
            _loc2_.name = "t" + this._nextId++;
         }
         this._items.push(_loc2_);
         return _loc2_;
      }
      
      public function removeItem(param1:FTransition) : void
      {
         var _loc2_:int = this._items.indexOf(param1);
         param1.dispose();
         this._items.splice(_loc2_,1);
      }
      
      public function getItem(param1:String) : FTransition
      {
         var _loc2_:FTransition = null;
         for each(_loc2_ in this._items)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function read(param1:XData) : void
      {
         var _loc3_:FTransition = null;
         var _loc4_:int = 0;
         this._items.length = 0;
         this._nextId = 0;
         var _loc2_:XDataEnumerator = param1.getEnumerator("transition");
         while(_loc2_.moveNext())
         {
            _loc3_ = this.addItem();
            _loc3_.read(_loc2_.current);
            if(_loc3_.name.length > 1 && _loc3_.name.charAt(0) == "t")
            {
               _loc4_ = parseInt(_loc3_.name.substr(1));
               if(_loc4_ >= this._nextId)
               {
                  this._nextId = _loc4_ + 1;
               }
            }
         }
      }
      
      public function write(param1:XData = null) : XData
      {
         var _loc4_:FTransition = null;
         var _loc6_:XData = null;
         var _loc2_:Boolean = true;
         if(!param1)
         {
            param1 = XData.create("transitions");
            _loc2_ = false;
         }
         var _loc3_:int = this._items.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._items[_loc5_];
            _loc6_ = _loc4_.write(_loc2_);
            param1.appendChild(_loc6_);
            _loc5_++;
         }
         return param1;
      }
      
      public function dispose() : void
      {
         var _loc1_:FTransition = null;
         for each(_loc1_ in this._items)
         {
            _loc1_.stop();
         }
         if(this._snapshot && this._snapshot.length > 0)
         {
            ObjectSnapshot.returnToPool(this._snapshot);
         }
      }
      
      private function collectSnapshots(param1:Vector.<ObjectSnapshot>) : void
      {
         var _loc4_:FTransition = null;
         var _loc5_:Vector.<FTransitionItem> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:FTransitionItem = null;
         var _loc9_:ObjectSnapshot = null;
         var _loc2_:int = this._items.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._items[_loc3_];
            _loc5_ = _loc4_.items;
            _loc6_ = _loc5_.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = _loc5_[_loc7_];
               if(_loc8_.target && _loc8_.target != this._owner && _loc8_.type == "Transition" && _loc8_.target is FComponent)
               {
                  FComponent(_loc8_.target).transitions.collectSnapshots(param1);
               }
               _loc7_++;
            }
            _loc3_++;
         }
         _loc2_ = this._owner.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc9_ = ObjectSnapshot.getFromPool(this._owner.getChildAt(_loc3_));
            param1.push(_loc9_);
            _loc3_++;
         }
      }
      
      public function clearSnapshot() : void
      {
         if(!this._snapshot)
         {
            return;
         }
         ObjectSnapshot.returnToPool(this._snapshot);
         this._snapshot.length = 0;
      }
      
      public function takeSnapshot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:ObjectSnapshot = null;
         if(!this._snapshot)
         {
            this._snapshot = new Vector.<ObjectSnapshot>();
            this._controllerSnapshot = new Vector.<String>();
         }
         if(this._snapshot.length == 0)
         {
            this.collectSnapshots(this._snapshot);
            _loc3_ = ObjectSnapshot.getFromPool(this._owner);
            this._snapshot.push(_loc3_);
         }
         _loc2_ = this._snapshot.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._snapshot[_loc1_].take();
            _loc1_++;
         }
         _loc2_ = this._owner.controllers.length;
         this._controllerSnapshot.length = _loc2_;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._controllerSnapshot[_loc1_] = this._owner.controllers[_loc1_].selectedPageId;
            _loc1_++;
         }
      }
      
      public function readSnapshot(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._loadingSnapshot = true;
         var _loc4_:int = this._owner.controllers.length;
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               helperArray[_loc3_] = this._owner.controllers[_loc3_].selectedIndex;
               this._owner.controllers[_loc3_].selectedPageId = this._controllerSnapshot[_loc3_];
               _loc3_++;
            }
         }
         _loc2_ = this._snapshot.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this._snapshot[_loc3_].load();
            _loc3_++;
         }
         if(param1)
         {
            _loc2_ = this._owner.controllers.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this._owner.controllers[_loc3_].selectedIndex = helperArray[_loc3_];
               _loc3_++;
            }
         }
         this._loadingSnapshot = false;
      }
   }
}

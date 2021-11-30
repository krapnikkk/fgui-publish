package fairygui
{
   public class Relations
   {
      
      private static const RELATION_NAMES:Array = ["left-left","left-center","left-right","center-center","right-left","right-center","right-right","top-top","top-middle","top-bottom","middle-middle","bottom-top","bottom-middle","bottom-bottom","width-width","height-height","leftext-left","leftext-right","rightext-left","rightext-right","topext-top","topext-bottom","bottomext-top","bottomext-bottom"];
       
      
      private var _owner:GObject;
      
      private var _items:Vector.<RelationItem>;
      
      public var handling:GObject;
      
      var sizeDirty:Boolean;
      
      public function Relations(param1:GObject)
      {
         super();
         _owner = param1;
         _items = new Vector.<RelationItem>();
      }
      
      public function add(param1:GObject, param2:int, param3:Boolean = false) : void
      {
         var _loc7_:int = 0;
         var _loc6_:* = _items;
         for each(var _loc5_ in _items)
         {
            if(_loc5_.target == param1)
            {
               _loc5_.add(param2,param3);
               return;
            }
         }
         var _loc4_:RelationItem = new RelationItem(_owner);
         _loc4_.target = param1;
         _loc4_.add(param2,param3);
         _items.push(_loc4_);
      }
      
      private function addItems(param1:GObject, param2:String) : void
      {
         var _loc4_:* = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:Array = param2.split(",");
         var _loc3_:RelationItem = new RelationItem(_owner);
         _loc3_.target = param1;
         _loc9_ = 0;
         while(_loc9_ < 2)
         {
            _loc4_ = _loc5_[_loc9_];
            if(_loc4_)
            {
               if(_loc4_.charAt(_loc4_.length - 1) == "%")
               {
                  _loc4_ = _loc4_.substr(0,_loc4_.length - 1);
                  _loc8_ = true;
               }
               else
               {
                  _loc8_ = false;
               }
               _loc7_ = _loc4_.indexOf("-");
               if(_loc7_ == -1)
               {
                  _loc4_ = _loc4_ + "-" + _loc4_;
               }
               _loc6_ = RELATION_NAMES.indexOf(_loc4_);
               if(_loc6_ == -1)
               {
                  throw new Error("invalid relation type");
               }
               _loc3_.internalAdd(_loc6_,_loc8_);
            }
            _loc9_++;
         }
         _items.push(_loc3_);
      }
      
      public function remove(param1:GObject, param2:int) : void
      {
         var _loc4_:* = null;
         var _loc3_:int = _items.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _items[_loc5_];
            if(_loc4_.target == param1)
            {
               _loc4_.remove(param2);
               if(_loc4_.isEmpty)
               {
                  _loc4_.dispose();
                  _items.splice(_loc5_,1);
                  _loc3_--;
               }
               else
               {
                  _loc5_++;
               }
            }
            else
            {
               _loc5_++;
            }
         }
      }
      
      public function contains(param1:GObject) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:* = _items;
         for each(var _loc2_ in _items)
         {
            if(_loc2_.target == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clearFor(param1:GObject) : void
      {
         var _loc3_:* = null;
         var _loc2_:int = _items.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _items[_loc4_];
            if(_loc3_.target == param1)
            {
               _loc3_.dispose();
               _items.splice(_loc4_,1);
               _loc2_--;
            }
            else
            {
               _loc4_++;
            }
         }
      }
      
      public function clearAll() : void
      {
         var _loc3_:int = 0;
         var _loc2_:* = _items;
         for each(var _loc1_ in _items)
         {
            _loc1_.dispose();
         }
         _items.length = 0;
      }
      
      public function copyFrom(param1:Relations) : void
      {
         var _loc3_:* = null;
         clearAll();
         var _loc2_:Vector.<RelationItem> = param1._items;
         var _loc6_:int = 0;
         var _loc5_:* = _loc2_;
         for each(var _loc4_ in _loc2_)
         {
            _loc3_ = new RelationItem(_owner);
            _loc3_.copyFrom(_loc4_);
            _items.push(_loc3_);
         }
      }
      
      public function dispose() : void
      {
         clearAll();
      }
      
      public function onOwnerSizeChanged(param1:Number, param2:Number) : void
      {
         if(_items.length == 0)
         {
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:* = _items;
         for each(var _loc3_ in _items)
         {
            _loc3_.applyOnSelfResized(param1,param2);
         }
      }
      
      public function ensureRelationsSizeCorrect() : void
      {
         if(_items.length == 0)
         {
            return;
         }
         sizeDirty = false;
         var _loc3_:int = 0;
         var _loc2_:* = _items;
         for each(var _loc1_ in _items)
         {
            _loc1_.target.ensureSizeCorrect();
         }
      }
      
      public final function get empty() : Boolean
      {
         return _items.length == 0;
      }
      
      public function setup(param1:XML) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:XMLList = param1.relation;
         var _loc7_:int = 0;
         var _loc6_:* = _loc2_;
         for each(var _loc5_ in _loc2_)
         {
            _loc4_ = _loc5_.@target;
            if(_owner.parent)
            {
               if(_loc4_)
               {
                  _loc3_ = _owner.parent.getChildById(_loc4_);
               }
               else
               {
                  _loc3_ = _owner.parent;
               }
            }
            else
            {
               _loc3_ = GComponent(_owner).getChildById(_loc4_);
            }
            if(_loc3_)
            {
               addItems(_loc3_,_loc5_.@sidePair);
            }
         }
      }
   }
}

package fairygui.editor.gui
{
   public class ETransitions
   {
       
      
      private var _owner:EGComponent;
      
      private var _items:Vector.<ETransition>;
      
      private var _nextId:int;
      
      public function ETransitions(param1:EGComponent)
      {
         super();
         this._owner = param1;
         this._items = new Vector.<ETransition>();
      }
      
      public function get items() : Vector.<ETransition>
      {
         return this._items;
      }
      
      public function get isEmpty() : Boolean
      {
         return this._items.length == 0;
      }
      
      public function addItem() : ETransition
      {
         var _loc1_:ETransition = new ETransition(this._owner);
         var _loc2_:Number = this._nextId;
         this._nextId++;
         _loc1_.name = "t" + _loc2_;
         this._items.push(_loc1_);
         return _loc1_;
      }
      
      public function removeItem(param1:ETransition) : void
      {
         var _loc2_:int = this._items.indexOf(param1);
         param1.dispose();
         this._items.splice(_loc2_,1);
      }
      
      public function getItem(param1:String) : ETransition
      {
         var _loc2_:ETransition = null;
         var _loc4_:int = 0;
         var _loc3_:* = this._items;
         for each(_loc2_ in this._items)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function fromXML(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:ETransition = null;
         var _loc2_:int = 0;
         this._items.length = 0;
         this._nextId = 0;
         var _loc5_:XMLList = param1.transition;
         var _loc7_:int = 0;
         var _loc6_:* = _loc5_;
         for each(_loc3_ in _loc5_)
         {
            _loc4_ = this.addItem();
            _loc4_.fromXML(_loc3_);
            if(_loc4_.name.length > 1 && _loc4_.name.charAt(0) == "t")
            {
               _loc2_ = parseInt(_loc4_.name.substr(1));
               if(_loc2_ >= this._nextId)
               {
                  this._nextId = _loc2_ + 1;
               }
            }
         }
      }
      
      public function toXML(param1:Boolean) : XML
      {
         var _loc5_:ETransition = null;
         var _loc3_:XML = null;
         var _loc6_:XML = <transitions/>;
         var _loc4_:int = this._items.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc5_ = this._items[_loc2_];
            _loc3_ = _loc5_.toXML(param1);
            _loc6_.appendChild(_loc3_);
            _loc2_++;
         }
         return _loc6_;
      }
      
      public function stopAll() : void
      {
         var _loc1_:ETransition = null;
         var _loc3_:int = 0;
         var _loc2_:* = this._items;
         for each(_loc1_ in this._items)
         {
            _loc1_.stop();
         }
      }
   }
}

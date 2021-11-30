package fairygui.editor.gui
{
   public class ObjectSnapshot
   {
      
      private static var pool:Vector.<ObjectSnapshot> = new Vector.<ObjectSnapshot>();
       
      
      private var _obj:FObject;
      
      public var x:Number;
      
      public var y:Number;
      
      public var width:Number;
      
      public var height:Number;
      
      public var scaleX:Number;
      
      public var scaleY:Number;
      
      public var skewX:Number;
      
      public var skewY:Number;
      
      public var pivotX:Number;
      
      public var pivotY:Number;
      
      public var anchor:Boolean;
      
      public var alpha:Number;
      
      public var rotation:Number;
      
      public var color:uint;
      
      public var playing:Boolean;
      
      public var frame:int;
      
      public var visible:Boolean;
      
      public var filterData:FilterData;
      
      public var text:String;
      
      public var icon:String;
      
      public function ObjectSnapshot()
      {
         super();
         this.filterData = new FilterData();
      }
      
      public static function getFromPool(param1:FObject) : ObjectSnapshot
      {
         var _loc2_:ObjectSnapshot = null;
         if(pool.length)
         {
            _loc2_ = pool.pop();
         }
         else
         {
            _loc2_ = new ObjectSnapshot();
         }
         _loc2_._obj = param1;
         if(_loc2_._obj)
         {
            _loc2_._obj._hasSnapshot = true;
         }
         return _loc2_;
      }
      
      public static function returnToPool(param1:Vector.<ObjectSnapshot>) : void
      {
         var _loc2_:ObjectSnapshot = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_._obj)
            {
               _loc2_._obj._hasSnapshot = false;
            }
            _loc2_._obj = null;
            pool.push(_loc2_);
         }
      }
      
      public function take() : void
      {
         this._obj.takeSnapshot(this);
      }
      
      public function load() : void
      {
         this._obj.readSnapshot(this);
      }
   }
}

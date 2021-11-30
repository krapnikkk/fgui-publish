package fairygui.editor.gui
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Ease;
   import com.greensock.easing.EaseLookup;
   import fairygui.editor.utils.UtilsStr;
   
   public class ETransitionItem
   {
      
      private static var gId:Number = 0;
       
      
      private var _frame:int;
      
      private var _targetId:String;
      
      private var _value:ETransitionValue;
      
      private var _type:String;
      
      private var _easeType:String;
      
      private var _easeInOutType:String;
      
      private var _ease:Ease;
      
      private var _tween:Boolean;
      
      private var _throughPoints:Array;
      
      private var _repeat:int;
      
      private var _yoyo:Boolean;
      
      private var _label:String;
      
      public var owner:ETransition;
      
      public var tweener:TweenLite;
      
      public var completed:Boolean;
      
      public var valid:Boolean;
      
      public var nextItem:ETransitionItem;
      
      public var prevItem:ETransitionItem;
      
      public var id:Number;
      
      public var tweenValue:ETransitionValue;
      
      public var displayLockToken:uint;
      
      public function ETransitionItem(param1:ETransition)
      {
         super();
         this.owner = param1;
         gId = Number(gId) + 1;
         this.id = Number(gId);
         this._easeType = "Quad";
         this._easeInOutType = "Out";
         this._ease = EaseLookup.find(this._easeType + ".ease" + this._easeInOutType);
         this._value = new ETransitionValue();
         this._throughPoints = [];
         this.valid = true;
         this.tweenValue = new ETransitionValue();
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set frame(param1:int) : void
      {
         this._frame = param1;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get tween() : Boolean
      {
         return this._tween;
      }
      
      public function set tween(param1:Boolean) : void
      {
         this._tween = param1;
      }
      
      public function get easeType() : String
      {
         return this._easeType;
      }
      
      public function set easeType(param1:String) : void
      {
         this._easeType = param1;
         if(this._easeType == "Linear")
         {
            this._ease = EaseLookup.find("linear.easenone");
         }
         else
         {
            this._ease = EaseLookup.find(this._easeType + ".ease" + this._easeInOutType);
         }
      }
      
      public function get easeInOutType() : String
      {
         return this._easeInOutType;
      }
      
      public function set easeInOutType(param1:String) : void
      {
         this._easeInOutType = param1;
         if(this._easeType == "Linear")
         {
            this._ease = EaseLookup.find("linear.easenone");
         }
         else
         {
            this._ease = EaseLookup.find(this._easeType + ".ease" + this._easeInOutType);
         }
      }
      
      public function get easeName() : String
      {
         if(this._easeType == "Linear")
         {
            return this._easeType;
         }
         return this._easeType + "." + this._easeInOutType;
      }
      
      public function get ease() : Ease
      {
         return this._ease;
      }
      
      public function get targetId() : String
      {
         return this._targetId;
      }
      
      public function set targetId(param1:String) : void
      {
         this._targetId = param1;
      }
      
      public function get value() : ETransitionValue
      {
         return this._value;
      }
      
      public function set value(param1:ETransitionValue) : void
      {
         this._value = param1;
      }
      
      public function get throughPoints() : Array
      {
         return this._throughPoints;
      }
      
      public function set throughPoints(param1:Array) : void
      {
         this._throughPoints = param1;
      }
      
      public function encodeThroughPoints(param1:String = "|") : String
      {
         var _loc2_:Object = null;
         var _loc3_:String = "";
         var _loc5_:int = 0;
         var _loc4_:* = this._throughPoints;
         for each(_loc2_ in this._throughPoints)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ = _loc3_ + param1;
            }
            _loc3_ = _loc3_ + (_loc2_.a + "," + _loc2_.b);
         }
         return _loc3_;
      }
      
      public function decodeThroughPoints(param1:String, param2:String = "|") : void
      {
         var _loc4_:Array = null;
         this._throughPoints.length = 0;
         var _loc3_:Array = param1.split(param2);
         var _loc6_:int = 0;
         var _loc5_:* = _loc3_;
         for each(param1 in _loc3_)
         {
            param1 = UtilsStr.trim(param1);
            if(param1)
            {
               _loc4_ = param1.split(",");
               this.throughPoints.push({
                  "a":parseInt(_loc4_[0]),
                  "b":parseInt(_loc4_[1])
               });
            }
         }
      }
      
      public function get repeat() : int
      {
         return this._repeat;
      }
      
      public function set repeat(param1:int) : void
      {
         this._repeat = param1;
      }
      
      public function get yoyo() : Boolean
      {
         return this._yoyo;
      }
      
      public function set yoyo(param1:Boolean) : void
      {
         this._yoyo = param1;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         this._label = param1;
      }
      
      public function __shake(param1:ETransition) : void
      {
         param1.__shake(this);
      }
   }
}

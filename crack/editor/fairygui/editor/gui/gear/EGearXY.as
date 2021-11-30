package fairygui.editor.gui.gear
{
   import com.greensock.TweenLite;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EUIObjectFactory;
   import flash.geom.Point;
   
   public class EGearXY extends EGearBase
   {
       
      
      private var _tweenPoint:Point;
      
      private var _tweener:TweenLite;
      
      public function EGearXY(param1:EGObject)
      {
         super(param1);
         gearIndex = 1;
      }
      
      override protected function init() : void
      {
         _default = new Point(owner.x,owner.y);
         _storage = {};
      }
      
      override protected function writeValue(param1:Object) : String
      {
         return int(param1.x) + "," + int(param1.y);
      }
      
      override protected function readValue(param1:String) : Object
      {
         if(param1 == "-" || param1.length == 0)
         {
            return null;
         }
         var _loc2_:Array = param1.split(",");
         return new Point(_loc2_[0],_loc2_[1]);
      }
      
      override public function apply() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Point = _storage[_controller.selectedPageId];
         if(!_loc2_)
         {
            _loc2_ = _default;
         }
         if(_tween && owner.editMode == 1 && !EUIObjectFactory.constructingDepth)
         {
            if(this._tweener != null)
            {
               if(this._tweener.vars.x != _loc2_.x || this._tweener.vars.y != _loc2_.y)
               {
                  owner.gearLocked = true;
                  owner.setXY(this._tweener.vars.x,this._tweener.vars.y);
                  owner.gearLocked = false;
                  this._tweener.kill();
                  this._tweener = null;
                  if(_displayLockToken != 0)
                  {
                     owner.releaseDisplayLock(_displayLockToken);
                     _displayLockToken = 0;
                  }
               }
               else
               {
                  return;
               }
            }
            if(owner.x != _loc2_.x || owner.y != _loc2_.y)
            {
               if(owner.checkGearController(0,_controller))
               {
                  _displayLockToken = owner.addDisplayLock();
               }
               _loc1_ = {
                  "x":_loc2_.x,
                  "y":_loc2_.y,
                  "ease":_ease,
                  "overwrite":0,
                  "delay":_delay
               };
               _loc1_.onUpdate = this.__tweenUpdate;
               _loc1_.onComplete = this.__tweenComplete;
               if(this._tweenPoint == null)
               {
                  this._tweenPoint = new Point();
               }
               this._tweenPoint.x = owner.x;
               this._tweenPoint.y = owner.y;
               this._tweener = TweenLite.to(this._tweenPoint,_duration,_loc1_);
            }
         }
         else
         {
            owner.gearLocked = true;
            owner.setXY(_loc2_.x,_loc2_.y);
            owner.gearLocked = false;
         }
      }
      
      private function __tweenUpdate() : void
      {
         owner.gearLocked = true;
         owner.setXY(this._tweenPoint.x,this._tweenPoint.y);
         owner.gearLocked = false;
      }
      
      private function __tweenComplete() : void
      {
         if(_displayLockToken != 0)
         {
            owner.releaseDisplayLock(_displayLockToken);
            _displayLockToken = 0;
         }
         this._tweener = null;
      }
      
      override public function updateState() : void
      {
         var _loc1_:Point = null;
         _loc1_ = _storage[_controller.selectedPageId];
         if(!_loc1_)
         {
            _loc1_ = new Point();
            _storage[_controller.selectedPageId] = _loc1_;
         }
         _loc1_.x = owner.x;
         _loc1_.y = owner.y;
      }
      
      override public function updateFromRelations(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = null;
         if(_controller == null || _storage == null)
         {
            return;
         }
         var _loc5_:int = 0;
         var _loc4_:* = _storage;
         for each(_loc3_ in _storage)
         {
            _loc3_.x = _loc3_.x + param1;
            _loc3_.y = _loc3_.y + param2;
         }
         _default.x = _default.x + param1;
         _default.y = _default.y + param2;
         this.updateState();
      }
   }
}

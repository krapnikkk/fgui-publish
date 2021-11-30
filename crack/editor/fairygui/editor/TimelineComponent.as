package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.GObject;
   import fairygui.GObjectPool;
   import fairygui.UIPackage;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class TimelineComponent extends GButton
   {
       
      
      private var _range:GObject;
      
      private var _kfURL:String;
      
      private var _kfContainer:GComponent;
      
      private var _keyFrames:Array;
      
      private var _tweenURL:String;
      
      private var _tweenContainer:GComponent;
      
      private var _tweenMap:Object;
      
      private var _pool:GObjectPool;
      
      private var _maxFrame:int;
      
      public var targetId:String;
      
      public var type:String;
      
      public function TimelineComponent()
      {
         super();
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:Bitmap = null;
         super.constructFromXML(param1);
         this.opaque = false;
         this.touchable = false;
         this.width = 8000;
         var _loc7_:Sprite = new Sprite();
         _loc7_.mouseEnabled = false;
         _loc7_.mouseChildren = false;
         var _loc5_:int = 8;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = TimelinePanel.frameBitmapDatas[_loc6_];
            _loc4_ = new Bitmap(_loc3_);
            _loc4_.x = _loc6_ * _loc3_.width;
            _loc7_.addChild(_loc4_);
            _loc6_++;
         }
         var _loc2_:GGraph = new GGraph();
         _loc2_.setNativeObject(_loc7_);
         _loc2_.y = 0;
         _loc2_.x = 0;
         addChild(_loc2_);
         this._range = getChild("range");
         this._range.x = 0;
         this._range.visible = false;
         this._range.touchable = false;
         addChild(this._range);
         this._pool = new GObjectPool();
         this._keyFrames = [];
         this._kfURL = UIPackage.getItemURL("Builder","TimelineIndicator");
         this._kfContainer = new GComponent();
         this._kfContainer.touchable = false;
         this._kfContainer.y = 0;
         addChild(this._kfContainer);
         this._tweenMap = {};
         this._tweenURL = UIPackage.getItemURL("Builder","TweenLine");
         this._tweenContainer = new GComponent();
         this._tweenContainer.y = 0;
         this._tweenContainer.touchable = false;
         addChild(this._tweenContainer);
      }
      
      public function findKeyFrame(param1:int) : int
      {
         var _loc2_:KeyFrame = null;
         var _loc3_:* = param1;
         while(_loc3_ <= this._maxFrame)
         {
            _loc2_ = this._keyFrames[_loc3_];
            if(_loc2_ != null)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function setKeyFrame(param1:int, param2:Object) : void
      {
         var _loc4_:GObject = null;
         var _loc3_:KeyFrame = this._keyFrames[param1];
         if(!_loc3_)
         {
            _loc3_ = new KeyFrame();
            this._keyFrames[param1] = _loc3_;
            _loc4_ = this._pool.getObject(this._kfURL);
            _loc4_.x = param1 * 10;
            _loc4_.y = 0;
            this._kfContainer.addChild(_loc4_);
            _loc3_.indicator = _loc4_;
            if(param1 > this._maxFrame)
            {
               this._maxFrame = param1;
               this.updateRange();
            }
         }
         _loc3_.userData = param2;
      }
      
      public function removeKeyFrame(param1:int) : void
      {
         var _loc4_:KeyFrame = this._keyFrames[param1];
         if(!_loc4_)
         {
            return;
         }
         this._kfContainer.removeChild(_loc4_.indicator);
         this._pool.returnObject(_loc4_.indicator);
         this._keyFrames[param1] = null;
         this._maxFrame = -1;
         var _loc2_:int = this._keyFrames.length;
         var _loc3_:int = _loc2_ - 1;
         while(_loc3_ >= 0)
         {
            if(this._keyFrames[_loc3_] != null)
            {
               this._maxFrame = _loc3_;
               break;
            }
            _loc3_--;
         }
         this.updateRange();
      }
      
      public function hasKeyFrame(param1:int) : Boolean
      {
         return this._keyFrames[param1];
      }
      
      public function getKeyFrameData(param1:int) : Object
      {
         var _loc2_:KeyFrame = this._keyFrames[param1];
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_.userData;
      }
      
      public function get maxFrame() : int
      {
         return this._maxFrame;
      }
      
      public function get empty() : Boolean
      {
         return this._kfContainer.numChildren == 0;
      }
      
      public function setTween(param1:int, param2:int) : void
      {
         var _loc3_:KeyFrame = this._keyFrames[param1];
         if(!_loc3_)
         {
            return;
         }
         if(!_loc3_.tweenIndicator)
         {
            _loc3_.tweenIndicator = this._pool.getObject(this._tweenURL);
            this._tweenContainer.addChild(_loc3_.tweenIndicator);
         }
         if(param2 - param1 <= 1)
         {
            _loc3_.tweenIndicator.visible = false;
         }
         else
         {
            _loc3_.tweenIndicator.visible = true;
            _loc3_.tweenIndicator.x = (param1 + 1) * 10;
            _loc3_.tweenIndicator.width = (param2 - param1 - 1) * 10;
            if(param2 - param1 == 2)
            {
               _loc3_.tweenIndicator.asCom.getController("c1").selectedIndex = 1;
            }
            else
            {
               _loc3_.tweenIndicator.asCom.getController("c1").selectedIndex = 0;
               _loc3_.tweenIndicator.asCom.getChild("body").scaleX = (_loc3_.tweenIndicator.width - 6) / 3;
            }
         }
      }
      
      public function clearTween(param1:int) : void
      {
         var _loc2_:KeyFrame = this._keyFrames[param1];
         if(!_loc2_ || !_loc2_.tweenIndicator)
         {
            return;
         }
         this._tweenContainer.removeChild(_loc2_.tweenIndicator);
         this._pool.returnObject(_loc2_.tweenIndicator);
         _loc2_.tweenIndicator = null;
      }
      
      public function getTweenStart(param1:int) : int
      {
         var _loc2_:KeyFrame = null;
         var _loc3_:* = param1;
         while(_loc3_ >= 0)
         {
            _loc2_ = this._keyFrames[_loc3_];
            if(_loc2_ != null)
            {
               if(_loc2_.tweenIndicator != null)
               {
                  return _loc3_;
               }
               if(_loc3_ != this._maxFrame)
               {
                  return -1;
               }
            }
            _loc3_--;
         }
         return -1;
      }
      
      public function getPossibleTweenStart(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this._keyFrames[param1] != null && param1 != this._maxFrame)
         {
            return param1;
         }
         _loc2_ = param1 - 1;
         while(_loc2_ >= 0)
         {
            if(this._keyFrames[_loc2_] != null)
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return -1;
      }
      
      public function reset() : void
      {
         var _loc1_:KeyFrame = null;
         this._kfContainer.removeChildren();
         this._tweenContainer.removeChildren();
         var _loc2_:int = 0;
         while(_loc2_ <= this._maxFrame)
         {
            _loc1_ = this._keyFrames[_loc2_];
            if(_loc1_)
            {
               if(_loc1_.indicator)
               {
                  this._pool.returnObject(_loc1_.indicator);
               }
               if(_loc1_.tweenIndicator)
               {
                  this._pool.returnObject(_loc1_.tweenIndicator);
               }
            }
            _loc2_++;
         }
         this._keyFrames.length = 0;
         this._maxFrame = -1;
         this._range.visible = false;
      }
      
      private function updateRange() : void
      {
         if(this._maxFrame == -1)
         {
            this._range.visible = false;
         }
         else
         {
            this._range.visible = true;
            this._range.width = (this._maxFrame + 1) * 10;
         }
      }
   }
}

import fairygui.GObject;

class KeyFrame
{
    
   
   public var indicator:GObject;
   
   public var tweenIndicator:GObject;
   
   public var userData:Object;
   
   function KeyFrame()
   {
      super();
   }
}

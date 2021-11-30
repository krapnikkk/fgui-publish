package fairygui.editor.gui
{
   import fairygui.editor.ComDocument;
   import fairygui.editor.extui.CursorManager;
   import fairygui.utils.GTimers;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class RangeEditor extends Sprite
   {
      
      public static var dragging:EGObject;
      
      private static var helperPoint:Point = new Point();
      
      private static var helperPoints:Vector.<Point> = new Vector.<Point>(10);
      
      private static var helperRect:Rectangle = new Rectangle();
      
      private static var helperMatrix:Matrix = new Matrix();
      
      private static var RESIZE_CURSORS:Array = [CursorManager.TL_RESIZE,CursorManager.V_RESIZE,CursorManager.TR_RESIZE,CursorManager.H_RESIZE,CursorManager.BR_RESIZE,CursorManager.V_RESIZE,CursorManager.BL_RESIZE,CursorManager.H_RESIZE];
      
      private static var RESIZE_SCHEME:Array = [[1,1,-1,-1],[0,1,0,-1],[0,1,1,-1],[0,0,1,0],[0,0,1,1],[0,0,0,1],[1,0,-1,1],[1,0,-1,0],[1,1,0,0]];
       
      
      private var _doc:ComDocument;
      
      private var _owner:EGObject;
      
      private var _graphContainer:Sprite;
      
      private var _resizers:Vector.<Sprite>;
      
      private var _anchor:Sprite;
      
      private var _lastMousePos:Point;
      
      private var _delta:Point;
      
      private var _xMoveDir:int;
      
      private var _yMoveDir:int;
      
      private var _dragStartTime:int;
      
      private var _color:uint;
      
      private var _dirLockDetected:int;
      
      private var _topLeftResizerIndex:int;
      
      private var _activeResizerIndex:int;
      
      public function RangeEditor(param1:ComDocument, param2:EGObject)
      {
         var _loc5_:Sprite = null;
         var _loc3_:Graphics = null;
         super();
         this._owner = param2;
         this._doc = param1;
         this._lastMousePos = new Point();
         this._delta = new Point();
         this._dirLockDetected = 0;
         this.mouseEnabled = false;
         this._graphContainer = new Sprite();
         this._graphContainer.mouseEnabled = false;
         addChild(this._graphContainer);
         if(this._owner is EGGroup)
         {
            this._color = 1883060;
         }
         else if(this._owner is EGComponent)
         {
            this._color = 48127;
         }
         else
         {
            this._color = 26367;
         }
         this._resizers = new Vector.<Sprite>(8);
         var _loc4_:int = 0;
         while(_loc4_ < 8)
         {
            _loc5_ = new Sprite();
            _loc3_ = _loc5_.graphics;
            _loc3_.lineStyle(0,this._color,1,false,"normal");
            _loc3_.beginFill(this._color,0.6);
            _loc3_.drawRect(-3,-3,6,6);
            _loc3_.endFill();
            _loc5_.addEventListener("mouseDown",this.__mouseDown);
            this._doc.editorWindow.cursorManager.setCursorForObject(_loc5_,RESIZE_CURSORS[_loc4_]);
            this._graphContainer.addChild(_loc5_);
            this._resizers[_loc4_] = _loc5_;
            _loc4_++;
         }
         this._anchor = new Sprite();
         var _loc6_:Boolean = false;
         this._anchor.mouseEnabled = _loc6_;
         this._anchor.mouseChildren = _loc6_;
         _loc3_ = this._anchor.graphics;
         _loc3_.lineStyle(0,this._color,1,false,"normal");
         _loc3_.beginFill(16777215,1);
         _loc3_.drawCircle(0,0,4);
         _loc3_.endFill();
         this._graphContainer.addChild(this._anchor);
         this._owner.rangeEditor = this;
         this._owner.statusDispatcher.addListener(1,this.__compChanged);
         this._owner.statusDispatcher.addListener(2,this.__compChanged);
         this._owner.statusDispatcher.addListener(3,this.__compChanged);
         this._owner.statusDispatcher.addListener(4,this.__compChanged);
         this._owner.statusDispatcher.addListener(5,this.__compChanged);
         this._owner.statusDispatcher.addListener(6,this.__compChanged);
         this._owner.parent.statusDispatcher.addListener(1,this.__compChanged);
         this._owner.parent.statusDispatcher.addListener(2,this.__compChanged);
         this._owner.parent.statusDispatcher.addListener(3,this.__compChanged);
         this._owner.parent.statusDispatcher.addListener(4,this.__compChanged);
         this._owner.parent.statusDispatcher.addListener(5,this.__compChanged);
         this._owner.parent.statusDispatcher.addListener(6,this.__compChanged);
         this.synEditorRange();
      }
      
      public function dispose() : void
      {
         this._owner.rangeEditor = null;
         this._owner.statusDispatcher.removeListener(1,this.__compChanged);
         this._owner.statusDispatcher.removeListener(2,this.__compChanged);
         this._owner.statusDispatcher.removeListener(3,this.__compChanged);
         this._owner.statusDispatcher.removeListener(4,this.__compChanged);
         this._owner.statusDispatcher.removeListener(5,this.__compChanged);
         this._owner.statusDispatcher.removeListener(6,this.__compChanged);
         this._owner.parent.statusDispatcher.removeListener(1,this.__compChanged);
         this._owner.parent.statusDispatcher.removeListener(2,this.__compChanged);
         this._owner.parent.statusDispatcher.removeListener(3,this.__compChanged);
         this._owner.parent.statusDispatcher.removeListener(4,this.__compChanged);
         this._owner.parent.statusDispatcher.removeListener(5,this.__compChanged);
         this._owner.parent.statusDispatcher.removeListener(6,this.__compChanged);
         if(stage)
         {
            stage.removeEventListener("mouseUp",this.__mouseUp);
            stage.removeEventListener("mouseMove",this.__mouseMove);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this._owner = null;
         this._doc = null;
      }
      
      public function get target() : EGObject
      {
         return this._owner;
      }
      
      public function dragMe(param1:MouseEvent) : void
      {
         this._dragStartTime = getTimer();
         this.__mouseDown(param1);
      }
      
      public function onViewScaleChanged() : void
      {
         this.synEditorRange();
      }
      
      private function showResize(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this._resizers[_loc2_].visible = param1;
            _loc2_++;
         }
      }
      
      public function synEditorRange() : void
      {
         var _loc8_:int = 0;
         var _loc1_:* = 0;
         var _loc6_:Number = NaN;
         var _loc3_:Sprite = null;
         var _loc4_:Point = null;
         if(this._owner.parent == null)
         {
            return;
         }
         var _loc11_:Number = this._owner.width;
         var _loc10_:Number = this._owner.height;
         helperMatrix.identity();
         helperMatrix.concat(this._owner.displayObject.contentMatrix);
         helperMatrix.translate(this._owner.displayObject.x,this._owner.displayObject.y);
         helperMatrix.concat(this._owner.parent.displayObject.contentMatrix);
         helperPoints[0] = this.transformPoint(0,0);
         helperPoints[1] = this.transformPoint(_loc11_ / 2,0);
         helperPoints[2] = this.transformPoint(_loc11_,0);
         helperPoints[3] = this.transformPoint(_loc11_,_loc10_ / 2);
         helperPoints[4] = this.transformPoint(_loc11_,_loc10_);
         helperPoints[5] = this.transformPoint(_loc11_ / 2,_loc10_);
         helperPoints[6] = this.transformPoint(0,_loc10_);
         helperPoints[7] = this.transformPoint(0,_loc10_ / 2);
         helperPoints[8] = this.transformPoint(_loc11_ / 2,_loc10_ / 2);
         helperPoints[9] = this.transformPoint(_loc11_ * this._owner.pivotX,_loc10_ * this._owner.pivotY);
         this.x = this._owner.parent.displayObject.x + helperPoints[0].x;
         this.y = this._owner.parent.displayObject.y + helperPoints[0].y;
         _loc8_ = 1;
         while(_loc8_ < 10)
         {
            helperPoints[_loc8_].x = helperPoints[_loc8_].x - helperPoints[0].x;
            helperPoints[_loc8_].y = helperPoints[_loc8_].y - helperPoints[0].y;
            _loc8_++;
         }
         var _loc12_:* = 0;
         helperPoints[0].y = _loc12_;
         helperPoints[0].x = _loc12_;
         var _loc9_:* = 2147483647;
         _loc8_ = 0;
         while(_loc8_ < 8)
         {
            _loc6_ = Math.abs(helperPoints[_loc8_].x - helperPoints[8].x);
            if(_loc6_ < _loc9_ && helperPoints[_loc8_].y <= helperPoints[8].y)
            {
               _loc9_ = _loc6_;
               _loc1_ = _loc8_;
            }
            _loc8_++;
         }
         if(_loc1_ > 0)
         {
            this._topLeftResizerIndex = _loc1_ - 1;
         }
         else
         {
            this._topLeftResizerIndex = 7;
         }
         var _loc2_:Number = 1 / this._doc.editorWindow.mainPanel.viewScale;
         var _loc7_:Graphics = this._graphContainer.graphics;
         _loc7_.clear();
         _loc7_.lineStyle(1,this._color,1,true,"none");
         _loc7_.moveTo(helperPoints[0].x,helperPoints[0].y);
         _loc7_.lineTo(helperPoints[2].x - _loc2_,helperPoints[2].y);
         _loc7_.lineTo(helperPoints[4].x - _loc2_,helperPoints[4].y - _loc2_);
         _loc7_.lineTo(helperPoints[6].x,helperPoints[6].y - _loc2_);
         _loc7_.lineTo(helperPoints[0].x,helperPoints[0].y);
         var _loc5_:Number = _loc2_ < 0.5?Number(_loc2_ * 2):_loc2_ < 1?1:Number(_loc2_);
         _loc8_ = 0;
         while(_loc8_ < 8)
         {
            _loc3_ = this._resizers[_loc8_];
            _loc4_ = helperPoints[(this._topLeftResizerIndex + _loc8_) % 8];
            _loc3_.x = _loc4_.x;
            _loc3_.y = _loc4_.y;
            _loc12_ = _loc5_;
            _loc3_.scaleY = _loc12_;
            _loc3_.scaleX = _loc12_;
            _loc8_++;
         }
         if(this._owner.pivotX == 0 && this._owner.pivotY == 0)
         {
            this._anchor.visible = false;
         }
         else
         {
            this._anchor.visible = true;
            _loc12_ = _loc5_;
            this._anchor.scaleY = _loc12_;
            this._anchor.scaleX = _loc12_;
         }
         this._anchor.x = helperPoints[9].x;
         this._anchor.y = helperPoints[9].y;
         _loc12_ = _loc11_ > 16 && _loc10_ > 16;
         this._resizers[6].visible = _loc12_;
         _loc12_ = _loc12_;
         this._resizers[4].visible = _loc12_;
         _loc12_ = _loc12_;
         this._resizers[2].visible = _loc12_;
         this._resizers[0].visible = _loc12_;
      }
      
      private function transformPoint(param1:Number, param2:Number) : Point
      {
         helperPoint.setTo(param1,param2);
         return helperMatrix.transformPoint(helperPoint);
      }
      
      private function __mouseDown(param1:MouseEvent) : void
      {
         this._activeResizerIndex = this._resizers.indexOf(param1.currentTarget as Sprite);
         this._lastMousePos.setTo(param1.stageX,param1.stageY);
         this._delta.setTo(0,0);
         this._dragStartTime = getTimer();
         stage.addEventListener("mouseUp",this.__mouseUp);
         stage.addEventListener("mouseMove",this.__mouseMove);
      }
      
      private function __mouseMove(param1:MouseEvent) : void
      {
         if(getTimer() - this._dragStartTime < 100)
         {
            return;
         }
         dragging = this._owner;
         this._delta.setTo((param1.stageX - this._lastMousePos.x) / parent.scaleX,(param1.stageY - this._lastMousePos.y) / parent.scaleY);
         if(this._doc.editorWindow.groot.shiftKeyDown)
         {
            if(this._dirLockDetected == 0)
            {
               if(Math.abs(this._delta.x) >= Math.abs(this._delta.y))
               {
                  this._dirLockDetected = 1;
               }
               else
               {
                  this._dirLockDetected = 2;
               }
            }
         }
         else
         {
            this._dirLockDetected = 0;
         }
         if(this._dirLockDetected == 1)
         {
            this._delta.y = 0;
         }
         else if(this._dirLockDetected == 2)
         {
            this._delta.x = 0;
         }
         this._lastMousePos.setTo(param1.stageX,param1.stageY);
         this._xMoveDir = this._delta.x == 0?0:this._delta.x > 0?1:-1;
         this._yMoveDir = this._delta.y == 0?0:this._delta.y > 0?1:-1;
         this.handleMove();
      }
      
      private function __mouseUp(param1:MouseEvent) : void
      {
         param1.currentTarget.removeEventListener("mouseUp",this.__mouseUp);
         param1.currentTarget.removeEventListener("mouseMove",this.__mouseMove);
         dragging = null;
         this._dirLockDetected = 0;
         GTimers.inst.remove(this.sideScrollTest);
      }
      
      private function __compChanged() : void
      {
         this.synEditorRange();
      }
      
      private function handleMove() : void
      {
         var _loc3_:Array = RESIZE_SCHEME[this._activeResizerIndex >= 0?this._activeResizerIndex:8];
         var _loc2_:Number = _loc3_[2] * this._delta.x / (this._owner.scaleX != 0?this._owner.scaleX:1);
         var _loc1_:Number = _loc3_[3] * this._delta.y / (this._owner.scaleY != 0?this._owner.scaleY:1);
         this._delta.x = this._delta.x * _loc3_[0];
         this._delta.y = this._delta.y * _loc3_[1];
         if(this._owner.aspectLocked)
         {
            if(_loc3_[0] != 0 || _loc3_[2] != 0)
            {
               _loc1_ = _loc2_ / this._owner.aspectRatio;
            }
            else
            {
               _loc2_ = _loc1_ * this._owner.aspectRatio;
            }
         }
         this._doc.syncOutineFromRangeEditor(this._owner,this._delta.x,this._delta.y,_loc2_,_loc1_);
         GTimers.inst.add(333,1,this.sideScrollTest);
      }
      
      private function sideScrollTest() : void
      {
         this._delta.setTo(0,0);
         var _loc1_:int = this._doc.sideScrollTest(this._xMoveDir,this._yMoveDir,this._delta);
         if(_loc1_)
         {
            this.handleMove();
         }
      }
   }
}

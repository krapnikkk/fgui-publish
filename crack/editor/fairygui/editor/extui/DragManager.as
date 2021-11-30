package fairygui.editor.extui
{
   import fairygui.GComponent;
   import fairygui.GObject;
   import fairygui.ScrollPane;
   import fairygui.editor.EditorWindow;
   import fairygui.event.DragEvent;
   import fairygui.utils.GTimers;
   import flash.geom.Point;
   
   public class DragManager
   {
      
      private static const autoScrollTest:int = 100;
      
      private static const autoScrollStep:int = 50;
       
      
      private var _agent:GObject;
      
      private var _source:Object;
      
      private var _sourceData:Object;
      
      private var _scrollPane:ScrollPane;
      
      private var _lastMousePos:Point;
      
      private var _xMoveDir:int;
      
      private var _yMoveDir:int;
      
      private var _editorWindow:EditorWindow;
      
      public function DragManager(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this._agent = new GComponent();
         this._agent.draggable = true;
         this._agent.sortingOrder = 2147483647;
         this._agent.addEventListener("dragMoving",this.__dragging);
         this._agent.addEventListener("endDrag",this.__dragEnd);
         this._lastMousePos = new Point();
      }
      
      public function get dragAgent() : GObject
      {
         return this._agent;
      }
      
      public function get dragging() : Boolean
      {
         return this._agent.parent != null;
      }
      
      public function startDrag(param1:Object, param2:Object, param3:ScrollPane = null) : void
      {
         if(this._agent.parent != null)
         {
            return;
         }
         this._source = param1;
         this._sourceData = param2;
         if(param2)
         {
            this._editorWindow.cursorManager.setExclusiveCursor(CursorManager.DRAG);
         }
         this._scrollPane = param3;
         this._lastMousePos.setTo(this._editorWindow.groot.nativeStage.mouseX,this._editorWindow.groot.nativeStage.mouseY);
         this._editorWindow.groot.addChild(this._agent);
         this._agent.startDrag();
      }
      
      public function cancel() : void
      {
         if(this._agent.parent != null)
         {
            this._agent.stopDrag();
            this._editorWindow.groot.removeChild(this._agent);
            this._editorWindow.cursorManager.setExclusiveCursor(null);
            this._sourceData = null;
            GTimers.inst.remove(this.sideScrollTest);
         }
      }
      
      private function __dragging(param1:DragEvent) : void
      {
         if(!this._scrollPane)
         {
            return;
         }
         this._xMoveDir = param1.stageX - this._lastMousePos.x;
         this._yMoveDir = param1.stageY - this._lastMousePos.y;
         GTimers.inst.add(200,1,this.sideScrollTest);
      }
      
      private function sideScrollTest() : void
      {
         var _loc4_:Number = this._editorWindow.groot.nativeStage.mouseX;
         var _loc3_:Number = this._editorWindow.groot.nativeStage.mouseY;
         var _loc1_:Point = this._scrollPane.owner.globalToLocal(_loc4_,_loc3_);
         if(_loc1_.x < 100 && this._xMoveDir < 0)
         {
            this._scrollPane.posX = this._scrollPane.posX - 50;
         }
         if(_loc1_.x > this._scrollPane.owner.width - 100 - 20 && this._xMoveDir > 0)
         {
            this._scrollPane.posX = this._scrollPane.posX + 50;
         }
         GTimers.inst.add(200,1,this.sideScrollTest);
         var _loc2_:DragEvent = new DragEvent("dragMoving");
         _loc2_.stageX = _loc4_;
         _loc2_.stageY = _loc3_;
         this._agent.dispatchEvent(_loc2_);
      }
      
      private function __dragEnd(param1:DragEvent) : void
      {
         var _loc2_:DropEvent = null;
         GTimers.inst.remove(this.sideScrollTest);
         if(this._agent.parent == null)
         {
            return;
         }
         this._editorWindow.groot.removeChild(this._agent);
         this._editorWindow.cursorManager.setExclusiveCursor(null);
         var _loc5_:Object = this._source;
         var _loc3_:Object = this._sourceData;
         this._source = null;
         this._sourceData = null;
         var _loc4_:GObject = this._editorWindow.groot.getObjectUnderMouse();
         while(_loc4_ != null)
         {
            if(_loc4_.hasEventListener("__drop") && _loc4_.touchable)
            {
               _loc2_ = new DropEvent("__drop",_loc5_,_loc3_);
               _loc4_.requestFocus();
               _loc4_.dispatchEvent(_loc2_);
               return;
            }
            _loc4_ = _loc4_.parent;
         }
      }
   }
}

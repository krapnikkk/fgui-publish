package fairygui.editor.extui
{
   import fairygui.GObject;
   import fairygui.editor.EditorWindow;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ScreenColorPickerManager
   {
       
      
      private var _editorWindow:EditorWindow;
      
      private var _owner:GObject;
      
      private var _callback:Function;
      
      private var helperBmd:BitmapData;
      
      private var helperMatrix:Matrix;
      
      private var helperRect:Rectangle;
      
      public function ScreenColorPickerManager(param1:EditorWindow)
      {
         this.helperBmd = new BitmapData(1,1,false);
         this.helperMatrix = new Matrix();
         this.helperRect = new Rectangle(0,0,1,1);
         super();
         this._editorWindow = param1;
      }
      
      public function start(param1:GObject, param2:Function) : void
      {
         this._owner = param1;
         this._callback = param2;
         this._editorWindow.cursorManager.setExclusiveCursor(CursorManager.COLOR_PICKER,this._cursorDetector);
         this._editorWindow.stage.addEventListener("mouseDown",this.onClickStage,true,1);
         param1.addEventListener("removedFromStage",this.__removed);
      }
      
      public function stop() : void
      {
         this._owner.removeEventListener("removedFromStage",this.__removed);
         this._owner = null;
         this._callback = null;
         this._editorWindow.cursorManager.setExclusiveCursor(null);
         this._editorWindow.stage.removeEventListener("click",this.onClickStage,true);
      }
      
      private function __removed(param1:Event) : void
      {
         this.stop();
      }
      
      private function _cursorDetector() : Boolean
      {
         var _loc2_:Number = this._editorWindow.stage.mouseX;
         var _loc1_:Number = this._editorWindow.stage.mouseY;
         return _loc2_ < this._owner.x || _loc1_ < this._owner.y || _loc2_ > this._owner.x + this._owner.width || _loc1_ > this._owner.y + this._owner.height;
      }
      
      private function onClickStage(param1:MouseEvent) : void
      {
         if(!this._editorWindow.cursorManager.isColorPicking)
         {
            return;
         }
         param1.stopPropagation();
         this.helperMatrix.identity();
         this.helperMatrix.translate(-param1.stageX,-param1.stageY);
         this.helperBmd.draw(this._editorWindow.stage,this.helperMatrix,null,null,this.helperRect);
         var _loc2_:uint = this.helperBmd.getPixel(0,0);
         if(this._owner.displayObject && this._owner.displayObject.stage)
         {
            this._callback(_loc2_);
         }
      }
   }
}

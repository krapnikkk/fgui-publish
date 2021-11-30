package fairygui.editor.extui
{
   import fairygui.editor.EditorWindow;
   import fairygui.editor.utils.UtilsStr;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   
   public class CursorManager
   {
      
      public static var H_RESIZE:String = "fgui_h_resize";
      
      public static var V_RESIZE:String = "fgui_v_resize";
      
      public static var TL_RESIZE:String = "fgui_tl_resize";
      
      public static var TR_RESIZE:String = "fgui_tr_resize";
      
      public static var BL_RESIZE:String = "fgui_bl_resize";
      
      public static var BR_RESIZE:String = "fgui_br_resize";
      
      public static var SELECT:String = "fgui_select";
      
      public static var HAND:String = "fgui_hand";
      
      public static var DRAG:String = "fgui_drag";
      
      public static var ADJUST:String = "fgui_adjust";
      
      public static var FINGER:String = "fgui_finger";
      
      public static var COLOR_PICKER:String = "fgui_color_picker";
      
      public static var WAIT:String = "fgui_wait";
       
      
      private var _currentCursor:String;
      
      private var _exclusiveCursor:String;
      
      private var _exclusiveDetector:Function;
      
      private var _activeTrigger:DisplayObject;
      
      private var _activeTriggerInfo:Object;
      
      private var _triggerHover:Boolean;
      
      private var _triggers:Dictionary;
      
      private var _eventRegistered:Boolean;
      
      private var _editorWindow:EditorWindow;
      
      public function CursorManager(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         this._triggers = new Dictionary(true);
         this.createCursor(H_RESIZE,"cursor_hResize");
         this.createCursor(V_RESIZE,"cursor_vResize");
         this.createCursor(TL_RESIZE,"cursor_d1Resize");
         this.createCursor(TR_RESIZE,"cursor_d2Resize");
         this.createCursor(BL_RESIZE,"cursor_d2Resize");
         this.createCursor(BR_RESIZE,"cursor_d1Resize");
         this.createCursor(SELECT,"cursor_select");
         this.createCursor(HAND,"cursor_hand");
         this.createCursor(DRAG,"cursor_drag",new Point(4,0));
         this.createCursor(ADJUST,"cursor_adjust",new Point(11,5));
         this.createCursor(FINGER,"cursor_finger",new Point(7,0));
         this.createCursor(COLOR_PICKER,"cursor_picker",new Point(0,13));
         this.createCursor(WAIT,"cursor_wait",new Point(9,10));
         this._editorWindow.groot.nativeStage.addEventListener("mouseMove",this.__mouseMove);
         this._editorWindow.groot.nativeStage.addEventListener("mouseUp",this.__mouseUp);
      }
      
      private function createCursor(param1:String, param2:String, param3:Point = null) : void
      {
      }
      
      public function setExclusiveCursor(param1:String, param2:Function = null) : void
      {
         this._exclusiveCursor = param1;
         this._exclusiveDetector = param2;
         this.updateCursor();
      }
      
      public function setWaitCursor(param1:Boolean) : void
      {
         this.setExclusiveCursor(!!param1?WAIT:null);
      }
      
      public function setCursorForObject(param1:DisplayObject, param2:String, param3:Function = null, param4:Boolean = false) : void
      {
         if(param2 != null)
         {
            this._triggers[param1] = {
               "cursor":param2,
               "detector":param3
            };
            param1.addEventListener("rollOver",this.__triggerOver);
            param1.addEventListener("rollOut",this.__triggerOut);
            param1.addEventListener("removedFromStage",this.__removedFromStage);
            if(param4 && this._activeTrigger == null && param1.stage != null && param1.hitTestPoint(param1.stage.mouseX,param1.stage.mouseY))
            {
               this.activateTrigger(param1);
            }
         }
         else
         {
            param1.removeEventListener("rollOver",this.__triggerOver);
            param1.removeEventListener("rollOut",this.__triggerOut);
            param1.removeEventListener("removedFromStage",this.__removedFromStage);
            delete this._triggers[param1];
            if(this._activeTrigger == param1)
            {
               this.deactivateTrigger();
            }
         }
      }
      
      public function updateCursor() : void
      {
         var _loc1_:String = null;
         if(this._exclusiveCursor != null)
         {
            if(this._exclusiveDetector == null || this._exclusiveDetector())
            {
               _loc1_ = this._exclusiveCursor;
            }
         }
         if(_loc1_ == null && this._activeTrigger != null && (this._activeTriggerInfo.detector == null || this._activeTriggerInfo.detector()))
         {
            _loc1_ = this._activeTriggerInfo.cursor;
         }
         if(_loc1_ != this._currentCursor)
         {
            this._currentCursor = _loc1_;
            if(!UtilsStr.startsWith(this._currentCursor,"fgui_"))
            {
               if(this._currentCursor == null)
               {
                  Mouse.cursor = "auto";
               }
               else
               {
                  Mouse.cursor = this._currentCursor;
               }
               Mouse.show();
            }
         }
      }
      
      public function get currentCursor() : String
      {
         return this._currentCursor;
      }
      
      public function get isColorPicking() : Boolean
      {
         return this._currentCursor == COLOR_PICKER;
      }
      
      private function activateTrigger(param1:DisplayObject) : void
      {
         this._activeTrigger = param1;
         this._triggerHover = true;
         this._activeTriggerInfo = this._triggers[this._activeTrigger];
         this.updateCursor();
      }
      
      private function deactivateTrigger() : void
      {
         this._activeTrigger = null;
         this._activeTriggerInfo = null;
         this._triggerHover = false;
         this.updateCursor();
      }
      
      private function __mouseMove(param1:MouseEvent) : void
      {
         this.updateCursor();
      }
      
      private function __mouseUp(param1:MouseEvent) : void
      {
         if(this._activeTrigger != null && !this._triggerHover)
         {
            this.deactivateTrigger();
         }
      }
      
      private function __triggerOver(param1:MouseEvent) : void
      {
         if(this._editorWindow.groot.buttonDown)
         {
            return;
         }
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         if(this._activeTrigger == null)
         {
            this.activateTrigger(_loc2_);
         }
         else if(this._activeTrigger == _loc2_)
         {
            this._triggerHover = true;
         }
      }
      
      private function __triggerOut(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.currentTarget);
         if(_loc2_ != this._activeTrigger)
         {
            return;
         }
         this._triggerHover = false;
         if(this._editorWindow.groot.buttonDown)
         {
            return;
         }
         this.deactivateTrigger();
      }
      
      private function __removedFromStage(param1:Event) : void
      {
         if(this._activeTrigger == param1.currentTarget)
         {
            this._activeTrigger = null;
            this._activeTriggerInfo = null;
            this.updateCursor();
         }
      }
   }
}

package fairygui.editor
{
   import fairygui.utils.GTimers;
   import flash.display.Stage;
   import flash.events.Event;
   
   public class WindowState
   {
       
      
      private var _stage:Stage;
      
      public function WindowState(param1:Stage)
      {
         super();
         this._stage = param1;
      }
      
      public function initAndRestore(param1:Function) : void
      {
         var _loc3_:Object = LocalStore.data;
         if(_loc3_.win_x != undefined && _loc3_.win_x > 0)
         {
            this._stage.nativeWindow.x = _loc3_.win_x;
         }
         if(_loc3_.win_y != undefined && _loc3_.win_y > 0)
         {
            this._stage.nativeWindow.y = _loc3_.win_y;
         }
         if(_loc3_.win_width != undefined)
         {
            this._stage.nativeWindow.width = _loc3_.win_width;
         }
         if(_loc3_.win_height != undefined)
         {
            this._stage.nativeWindow.height = _loc3_.win_height;
         }
         var _loc2_:* = _loc3_.win_state == "maximized";
         if(_loc2_)
         {
            this._stage.nativeWindow.maximize();
         }
         this._stage.nativeWindow.visible = true;
         this._stage.nativeWindow.addEventListener("move",this.__move);
         this._stage.nativeWindow.addEventListener("resize",this.__resize);
         this._stage.nativeWindow.addEventListener("displayStateChange",this.__displayStateChange);
         if(!_loc2_)
         {
            param1();
         }
         else
         {
            GTimers.inst.add(10,1,param1);
         }
      }
      
      private function __move(param1:Event) : void
      {
         if(this._stage.nativeWindow.displayState != "normal")
         {
            return;
         }
         var _loc2_:Object = LocalStore.data;
         _loc2_.win_x = this._stage.nativeWindow.x;
         _loc2_.win_y = this._stage.nativeWindow.y;
      }
      
      private function __resize(param1:Event) : void
      {
         if(this._stage.nativeWindow.displayState != "normal")
         {
            return;
         }
         var _loc2_:Object = LocalStore.data;
         _loc2_.win_width = this._stage.nativeWindow.width;
         _loc2_.win_height = this._stage.nativeWindow.height;
      }
      
      private function __displayStateChange(param1:Event) : void
      {
         var _loc2_:Object = LocalStore.data;
         _loc2_.win_state = this._stage.nativeWindow.displayState;
      }
   }
}

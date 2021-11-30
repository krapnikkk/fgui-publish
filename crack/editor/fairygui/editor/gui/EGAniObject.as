package fairygui.editor.gui
{
   import fairygui.editor.gui.gear.EIAnimationGear;
   
   public class EGAniObject extends EGObject implements EIAnimationGear
   {
       
      
      protected var _playing:Boolean;
      
      protected var _aniName:String;
      
      protected var _frame:int;
      
      public function EGAniObject()
      {
         super();
         this._playing = true;
      }
      
      public function get aniName() : String
      {
         return this._aniName;
      }
      
      public function set aniName(param1:String) : void
      {
         if(param1 != null || param1 == "")
         {
            this._aniName = param1;
            this.stateChanged();
            updateGear(5);
         }
      }
      
      public function get playing() : Boolean
      {
         return this._playing;
      }
      
      public function set playing(param1:Boolean) : void
      {
         if(this._playing != param1)
         {
            this._playing = param1;
            this.stateChanged();
            updateGear(5);
         }
      }
      
      public function get frame() : int
      {
         return this._frame;
      }
      
      public function set frame(param1:int) : void
      {
         this._frame = param1;
         this.stateChanged();
         updateGear(5);
      }
      
      protected function stateChanged() : void
      {
      }
   }
}

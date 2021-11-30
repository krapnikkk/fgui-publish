package fairygui.editor.extui
{
   import fairygui.GButton;
   import fairygui.GObject;
   import fairygui.editor.EditorWindow;
   import flash.events.Event;
   
   public class ColorInput extends GButton
   {
       
      
      private var _colorValue:uint;
      
      private var _alphaValue:Number;
      
      private var _showAlpha:Boolean;
      
      public function ColorInput()
      {
         super();
         this._showAlpha = false;
         this._alphaValue = 1;
      }
      
      public function get colorValue() : Number
      {
         return this._colorValue;
      }
      
      public function set colorValue(param1:Number) : void
      {
         this._colorValue = param1;
         this.update();
      }
      
      public function get alphaValue() : Number
      {
         return this._alphaValue;
      }
      
      public function set alphaValue(param1:Number) : void
      {
         this._alphaValue = param1;
         this.update();
      }
      
      public function set argb(param1:uint) : void
      {
         if(this._showAlpha)
         {
            this._alphaValue = (param1 >> 24 & 255) / 255;
         }
         else
         {
            this._alphaValue = 1;
         }
         this._colorValue = param1 & 16777215;
         this.update();
      }
      
      public function get argb() : uint
      {
         if(this._showAlpha)
         {
            return (Math.round(this._alphaValue * 255) << 24) + this._colorValue;
         }
         return this._colorValue;
      }
      
      public function set showAlpha(param1:Boolean) : void
      {
         this._showAlpha = param1;
      }
      
      public function get showAlpha() : Boolean
      {
         return this._showAlpha;
      }
      
      private function update() : void
      {
         getChild("n1").asGraph.drawRect(1,0,1,this._colorValue,this._alphaValue);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         var _loc2_:GObject = getChild("arrow");
         if(_loc2_)
         {
            _loc2_.addEventListener("beginGTouch",this.__clickPreset);
         }
         addEventListener("beginGTouch",this.__click);
         this.update();
      }
      
      private function __colorChanged(param1:Event) : void
      {
         this.update();
         this.dispatchEvent(param1);
      }
      
      private function __click(param1:Event) : void
      {
         EditorWindow.getInstance(this).colorPicker.show(this,GObject(param1.currentTarget),this._colorValue,this._alphaValue,this._showAlpha);
      }
      
      private function __clickPreset(param1:Event) : void
      {
         param1.stopPropagation();
         EditorWindow.getInstance(this).colorPresetMenu.show(this,GObject(param1.currentTarget));
      }
   }
}

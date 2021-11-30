package fairygui.editor.gui
{
   import fairygui.utils.XData;
   
   public class FilterData
   {
       
      
      private var _type:String;
      
      private var _brightness:Number;
      
      private var _contrast:Number;
      
      private var _saturation:Number;
      
      private var _hue:Number;
      
      public function FilterData()
      {
         super();
         this._brightness = this._contrast = this._saturation = this._hue = 0;
         this._type = "none";
      }
      
      public function read(param1:XData) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         _loc2_ = param1.getAttribute("filter");
         if(_loc2_)
         {
            this._type = _loc2_;
            _loc2_ = param1.getAttribute("filterData");
            _loc3_ = _loc2_.split(",");
            this._brightness = parseFloat(_loc3_[0]);
            this._contrast = parseFloat(_loc3_[1]);
            this._saturation = parseFloat(_loc3_[2]);
            this._hue = parseFloat(_loc3_[3]);
         }
         else
         {
            this._type = "none";
         }
      }
      
      public function write(param1:XData) : void
      {
         if(this._type != "none")
         {
            param1.setAttribute("filter",this._type);
            param1.setAttribute("filterData",this._brightness.toFixed(2) + "," + this._contrast.toFixed(2) + "," + this._saturation.toFixed(2) + "," + this._hue.toFixed(2));
         }
      }
      
      public function copyFrom(param1:FilterData) : void
      {
         this._type = param1._type;
         this._brightness = param1._brightness;
         this._contrast = param1._contrast;
         this._saturation = param1._saturation;
         this._hue = param1._hue;
      }
      
      public function clone() : FilterData
      {
         var _loc1_:FilterData = new FilterData();
         _loc1_.copyFrom(this);
         return _loc1_;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function get brightness() : Number
      {
         return this._brightness;
      }
      
      public function set brightness(param1:Number) : void
      {
         this._brightness = param1;
      }
      
      public function get contrast() : Number
      {
         return this._contrast;
      }
      
      public function set contrast(param1:Number) : void
      {
         this._contrast = param1;
      }
      
      public function get saturation() : Number
      {
         return this._saturation;
      }
      
      public function set saturation(param1:Number) : void
      {
         this._saturation = param1;
      }
      
      public function get hue() : Number
      {
         return this._hue;
      }
      
      public function set hue(param1:Number) : void
      {
         this._hue = param1;
      }
   }
}

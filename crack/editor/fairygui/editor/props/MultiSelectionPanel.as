package fairygui.editor.props
{
   import fairygui.GComponent;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGObject;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class MultiSelectionPanel extends GComponent
   {
       
      
      private var _objects:Vector.<EGObject>;
      
      private var _top:Point;
      
      private var _editorWindow:EditorWindow;
      
      public function MultiSelectionPanel(param1:EditorWindow)
      {
         super();
         this._editorWindow = param1;
         UIPackage.createObject("Builder","MultiSelectionPanel",this);
         this._top = new Point();
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         NumericInput(getChild("x")).min = -2147483648;
         NumericInput(getChild("y")).min = -2147483648;
         getChild("x").addEventListener("__submit",this.__xyChanged);
         getChild("y").addEventListener("__submit",this.__xyChanged);
      }
      
      public function update(param1:Vector.<EGObject>) : void
      {
         var _loc3_:int = 0;
         var _loc2_:EGObject = null;
         if(this._objects != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this._objects.length)
            {
               _loc2_ = this._objects[_loc3_];
               _loc2_.statusDispatcher.removeListener(1,this.updateOutline);
               _loc2_.statusDispatcher.removeListener(2,this.updateOutline);
               _loc3_++;
            }
         }
         this._objects = param1;
         _loc3_ = 0;
         while(_loc3_ < this._objects.length)
         {
            _loc2_ = this._objects[_loc3_];
            _loc2_.statusDispatcher.addListener(1,this.updateOutline);
            _loc2_.statusDispatcher.addListener(2,this.updateOutline);
            _loc3_++;
         }
         this.updateOutline(null);
      }
      
      private function __xyChanged(param1:Event) : void
      {
         var _loc3_:EGObject = null;
         var _loc4_:Number = NaN;
         var _loc7_:Number = int(getChild("x").text) - this._top.x;
         var _loc5_:Number = int(getChild("y").text) - this._top.y;
         var _loc6_:int = this._objects.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc6_)
         {
            _loc3_ = this._objects[_loc2_];
            _loc4_ = _loc3_.x + _loc7_;
            _loc3_.setProperty("x",_loc4_);
            _loc4_ = _loc3_.y + _loc5_;
            _loc3_.setProperty("y",_loc4_);
            _loc2_++;
         }
      }
      
      private function updateOutline(param1:EGObject) : void
      {
         var _loc3_:EGObject = null;
         if(param1 != null && (this._objects.length == 0 || param1 != this._objects[this._objects.length - 1]))
         {
            return;
         }
         this._top.x = 2147483647;
         this._top.y = 2147483647;
         var _loc6_:int = -2147483648;
         var _loc4_:int = -2147483648;
         var _loc5_:int = this._objects.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = this._objects[_loc2_];
            if(_loc3_.x < this._top.x)
            {
               this._top.x = _loc3_.x;
            }
            if(_loc3_.y < this._top.y)
            {
               this._top.y = _loc3_.y;
            }
            if(_loc3_.x + _loc3_.width > _loc6_)
            {
               _loc6_ = _loc3_.x + _loc3_.width;
            }
            if(_loc3_.y + _loc3_.height > _loc4_)
            {
               _loc4_ = _loc3_.y + _loc3_.height;
            }
            _loc2_++;
         }
         this._top.x = int(this._top.x);
         this._top.y = int(this._top.y);
         getChild("x").text = "" + this._top.x;
         getChild("y").text = "" + this._top.y;
         getChild("width").text = "" + (int(_loc6_ - this._top.x));
         getChild("height").text = "" + (int(_loc4_ - this._top.y));
      }
   }
}

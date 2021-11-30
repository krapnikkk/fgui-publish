package fairygui.editor.gui
{
   public class ListItemData
   {
       
      
      public var url:String;
      
      public var name:String;
      
      public var title:String;
      
      public var icon:String;
      
      public var selectedTitle:String;
      
      public var selectedIcon:String;
      
      public var level:int;
      
      private var _properties:Vector.<ComProperty>;
      
      public function ListItemData()
      {
         super();
         this._properties = new Vector.<ComProperty>();
      }
      
      public function get properties() : Vector.<ComProperty>
      {
         return this._properties;
      }
      
      public function copyFrom(param1:ListItemData) : void
      {
         var _loc4_:ComProperty = null;
         var _loc5_:ComProperty = null;
         this.url = param1.url;
         this.name = param1.name;
         this.title = param1.title;
         this.icon = param1.icon;
         this.selectedIcon = param1.selectedIcon;
         this.selectedTitle = param1.selectedTitle;
         this.level = param1.level;
         var _loc2_:int = param1._properties.length;
         this._properties.length = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._properties[_loc3_];
            _loc5_ = param1._properties[_loc3_];
            if(!_loc4_)
            {
               _loc4_ = new ComProperty();
               this._properties[_loc3_] = _loc4_;
            }
            _loc4_.copyFrom(_loc5_);
            _loc3_++;
         }
      }
   }
}

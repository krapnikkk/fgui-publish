package fairygui.editor.gui
{
   import fairygui.editor.utils.Utils;
   import flash.events.EventDispatcher;
   
   public class ComExtention extends EventDispatcher
   {
       
      
      protected var _owner:EGComponent;
      
      public var _type:String;
      
      public function ComExtention()
      {
         super();
      }
      
      public function get owner() : EGComponent
      {
         return this._owner;
      }
      
      public function set owner(param1:EGComponent) : void
      {
         if(this._owner != param1)
         {
            if(this._owner && this._owner.editMode != 3)
            {
               this.uninstall();
            }
            this._owner = param1;
            if(this._owner && this._owner.editMode != 3)
            {
               this.install();
            }
         }
      }
      
      public function get title() : String
      {
         return null;
      }
      
      public function set title(param1:String) : void
      {
      }
      
      public function get icon() : String
      {
         return null;
      }
      
      public function set icon(param1:String) : void
      {
      }
      
      public function get color() : uint
      {
         return 0;
      }
      
      public function set color(param1:uint) : void
      {
      }
      
      protected function uninstall() : void
      {
      }
      
      protected function install() : void
      {
      }
      
      public function load(param1:XML) : void
      {
      }
      
      public function serialize() : XML
      {
         return null;
      }
      
      public function fromXML(param1:XML) : void
      {
      }
      
      public function toXML() : XML
      {
         return null;
      }
      
      public function setProperty(param1:String, param2:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         _loc3_ = this[param1];
         if(Utils.equalText(param2,_loc3_))
         {
            return _loc3_;
         }
         this[param1] = param2;
         _loc4_ = this[param1];
         if(!this._owner.underConstruct && !Utils.equalText(_loc4_,_loc3_))
         {
            this._owner.pkg.project.editorWindow.activeComDocument.actionHistory.action_extentionSet(this._owner,param1,_loc3_,_loc4_);
         }
         return _loc4_;
      }
      
      public function handleControllerChanged(param1:EController) : void
      {
      }
   }
}

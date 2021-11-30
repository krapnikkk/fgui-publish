package fairygui.editor.extui
{
   import fairygui.Controller;
   import fairygui.GLabel;
   import fairygui.GTextField;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.LibPanel;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.utils.UtilsStr;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class ResourceInput extends GLabel
   {
       
      
      private var _nameTextField:GTextField;
      
      private var _savedText:String;
      
      private var _c1:Controller;
      
      private var _defaultColor:uint;
      
      public var isFontInput:Boolean;
      
      public function ResourceInput()
      {
         super();
      }
      
      override public function set text(param1:String) : void
      {
         .super.text = param1;
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:EPackageItem = null;
         var _loc2_:String = this.text;
         if(_loc2_)
         {
            if(UtilsStr.startsWith(_loc2_,"ui://"))
            {
               _loc1_ = EditorWindow.getInstance(this).project.getItemByURL(_loc2_);
               if(_loc1_ != null)
               {
                  this._nameTextField.text = _loc1_.name + " @" + _loc1_.owner.name;
                  this.icon = Icons.all[_loc1_.type];
                  this._nameTextField.color = this._defaultColor;
               }
               else
               {
                  this._nameTextField.text = _loc2_;
                  this._nameTextField.color = this._defaultColor;
                  this.icon = Icons.all.res_error;
               }
            }
            else
            {
               this._nameTextField.text = _loc2_;
               this._nameTextField.color = this._defaultColor;
               this.icon = null;
            }
         }
         else
         {
            if(this.isFontInput)
            {
               this._nameTextField.text = EditorWindow.getInstance(this).project.settingsCenter.common.font;
            }
            else if(!this.grayed)
            {
               this._nameTextField.text = Consts.g.text61;
            }
            else
            {
               this._nameTextField.text = "";
            }
            this._nameTextField.color = 9803157;
            this.icon = null;
         }
         if(this.icon == null)
         {
            this._nameTextField.x = 2;
         }
         else
         {
            this._nameTextField.x = 20;
         }
      }
      
      override protected function handleGrayedChanged() : void
      {
         super.handleGrayedChanged();
         this.update();
      }
      
      private function __drop(param1:DropEvent) : void
      {
         var _loc3_:EPackageItem = null;
         if(!(param1.source is LibPanel))
         {
            return;
         }
         if(!this.enabled || !this.editable)
         {
            return;
         }
         var _loc4_:Object = param1.sourceData;
         var _loc2_:Object = _loc4_[0];
         if(_loc2_ is EPackageItem)
         {
            _loc3_ = EPackageItem(_loc2_);
            if(_loc3_.type != "folder")
            {
               this.text = "ui://" + _loc3_.owner.id + _loc3_.id;
               this.dispatchEvent(new SubmitEvent("__submit"));
            }
         }
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         this._c1 = getController("c1");
         this._c1.selectedIndex = 1;
         this._nameTextField = getChild("nameText").asTextField;
         this._nameTextField.text = Consts.g.text61;
         this._defaultColor = this._nameTextField.color;
         this._nameTextField.color = 9803157;
         this._nameTextField.x = 2;
         this._titleObject.addEventListener("focusIn",this.__focusIn);
         this._titleObject.addEventListener("focusOut",this.__focusOut);
         this._titleObject.addEventListener("keyDown",this.__keyDown);
         addClickListener(this.__click);
         addEventListener("rightClick",this.__rightClick);
         addEventListener("__drop",this.__drop);
      }
      
      private function __click(param1:Event) : void
      {
         if(!this.enabled)
         {
            return;
         }
         this._c1.selectedIndex = 0;
         this.root.nativeStage.focus = this._titleObject.displayObject as TextField;
      }
      
      private function __focusIn(param1:Event) : void
      {
         this._savedText = this.text;
      }
      
      private function __focusOut(param1:Event) : void
      {
         this._c1.selectedIndex = 1;
         if(this._savedText != this.text)
         {
            this.update();
            this.dispatchEvent(new SubmitEvent("__submit"));
         }
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.__focusOut(null);
         }
         else if(param1.keyCode == 27)
         {
            this._titleObject.text = this._savedText;
            this._c1.selectedIndex = 1;
         }
      }
      
      private function __rightClick(param1:Event) : void
      {
         param1.stopPropagation();
         var _loc2_:EditorWindow = EditorWindow.getInstance(this);
         _loc2_.resourceInputMenu.show(this,_loc2_.groot,this.enabled);
      }
   }
}

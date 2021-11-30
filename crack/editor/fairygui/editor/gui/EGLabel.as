package fairygui.editor.gui
{
   import fairygui.editor.utils.UtilsStr;
   
   public class EGLabel extends ComExtention
   {
       
      
      public var promptText:String;
      
      public var restrict:String;
      
      public var maxLength:int;
      
      public var keyboardType:String;
      
      private var _title:String;
      
      private var _icon:String;
      
      private var _titleColor:uint;
      
      private var _titleColorSet:Boolean;
      
      private var _originColor:uint;
      
      private var _titleFontSize:int;
      
      private var _titleFontSizeSet:Boolean;
      
      private var _originFontSize:int;
      
      private var _password:Boolean;
      
      private var _titleObject:EGObject;
      
      private var _iconObject:EGObject;
      
      public function EGLabel()
      {
         super();
         this._title = "";
         this._icon = "";
      }
      
      override public function get icon() : String
      {
         return this._icon;
      }
      
      override public function set icon(param1:String) : void
      {
         this._icon = param1;
         if(this._iconObject)
         {
            this._iconObject.icon = param1;
         }
         _owner.updateGear(7);
      }
      
      override public function get title() : String
      {
         return this._title;
      }
      
      override public function set title(param1:String) : void
      {
         this._title = param1;
         if(this._titleObject)
         {
            this._titleObject.text = param1;
         }
         _owner.updateGear(6);
      }
      
      public function get titleColor() : uint
      {
         return this._titleColor;
      }
      
      public function set titleColor(param1:uint) : void
      {
         if(this._titleColor != param1)
         {
            this._titleColor = param1;
            if(this._titleObject)
            {
               if(this._titleObject is EGTextField)
               {
                  EGTextField(this._titleObject).color = this._titleColor;
               }
               else if(this._titleObject is EGComponent)
               {
                  if(EGComponent(this._titleObject).extentionId == "Label")
                  {
                     EGLabel(EGComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
                  else if(EGComponent(this._titleObject).extentionId == "Button")
                  {
                     EGButton(EGComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
               }
            }
            _owner.updateGear(4);
         }
      }
      
      override public function get color() : uint
      {
         return this._titleColor;
      }
      
      override public function set color(param1:uint) : void
      {
         this.titleColor = param1;
      }
      
      public function get titleColorSet() : Boolean
      {
         return this._titleColorSet;
      }
      
      public function set titleColorSet(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         this._titleColorSet = param1;
         if(!this._titleColorSet)
         {
            _loc2_ = this._originColor;
         }
         else
         {
            _loc2_ = this._titleColor;
         }
         if(this._titleObject)
         {
            if(this._titleObject is EGTextField)
            {
               EGTextField(this._titleObject).color = _loc2_;
            }
            else if(this._titleObject is EGComponent)
            {
               if(EGComponent(this._titleObject).extentionId == "Label")
               {
                  EGLabel(EGComponent(this._titleObject).extention).titleColor = _loc2_;
               }
               else if(EGComponent(this._titleObject).extentionId == "Button")
               {
                  EGButton(EGComponent(this._titleObject).extention).titleColor = _loc2_;
               }
            }
         }
      }
      
      public function get titleFontSize() : int
      {
         return this._titleFontSize;
      }
      
      public function set titleFontSize(param1:int) : void
      {
         if(this._titleFontSize != param1)
         {
            this._titleFontSize = param1;
            if(this._titleObject)
            {
               if(this._titleObject is EGTextField)
               {
                  EGTextField(this._titleObject).fontSize = this._titleFontSize;
               }
               else if(this._titleObject is EGComponent)
               {
                  if(EGComponent(this._titleObject).extentionId == "Label")
                  {
                     EGLabel(EGComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                  }
                  else if(EGComponent(this._titleObject).extentionId == "Button")
                  {
                     EGButton(EGComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                  }
               }
            }
            _owner.updateGear(4);
         }
      }
      
      public function get titleFontSizeSet() : Boolean
      {
         return this._titleFontSizeSet;
      }
      
      public function set titleFontSizeSet(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         this._titleFontSizeSet = param1;
         if(!this._titleFontSizeSet)
         {
            _loc2_ = this._originFontSize;
         }
         else
         {
            _loc2_ = this._titleFontSize;
         }
         if(this._titleObject)
         {
            if(this._titleObject is EGTextField)
            {
               EGTextField(this._titleObject).fontSize = _loc2_;
            }
            else if(this._titleObject is EGComponent)
            {
               if(EGComponent(this._titleObject).extentionId == "Label")
               {
                  EGLabel(EGComponent(this._titleObject).extention).titleFontSize = _loc2_;
               }
               else if(EGComponent(this._titleObject).extentionId == "Button")
               {
                  EGButton(EGComponent(this._titleObject).extention).titleFontSize = _loc2_;
               }
            }
         }
      }
      
      public function get input() : Boolean
      {
         var _loc1_:EGTextField = this.getTextField();
         return _loc1_ && _loc1_.input;
      }
      
      public function get password() : Boolean
      {
         return this._password;
      }
      
      public function set password(param1:Boolean) : void
      {
         this._password = param1;
         EGTextField(this._titleObject).password = this._password;
      }
      
      public function getTextField() : EGTextField
      {
         if(this._titleObject is EGTextField)
         {
            return EGTextField(this._titleObject);
         }
         if(this._titleObject is EGLabel)
         {
            return EGLabel(this._titleObject).getTextField();
         }
         if(this._titleObject is EGButton)
         {
            return EGButton(this._titleObject).getTextField();
         }
         return null;
      }
      
      override protected function install() : void
      {
         this._titleObject = owner.getChild("title");
         this._iconObject = owner.getChild("icon");
         if(this._titleObject)
         {
            if(this._titleObject is EGTextField)
            {
               this._originColor = EGTextField(this._titleObject).color;
               this._originFontSize = EGTextField(this._titleObject).fontSize;
            }
            else if(this._titleObject is EGComponent)
            {
               if(EGComponent(this._titleObject).extentionId == "Label")
               {
                  this._originColor = EGLabel(EGComponent(this._titleObject).extention).titleColor;
                  this._originFontSize = EGLabel(EGComponent(this._titleObject).extention).titleFontSize;
               }
               else if(EGComponent(this._titleObject).extentionId == "Button")
               {
                  this._originColor = EGButton(EGComponent(this._titleObject).extention).titleColor;
                  this._originFontSize = EGButton(EGComponent(this._titleObject).extention).titleFontSize;
               }
            }
         }
         if(!this._titleColorSet)
         {
            this._titleColor = this._originColor;
         }
         if(!this._titleFontSizeSet)
         {
            this._titleFontSize = this._originFontSize;
         }
      }
      
      override protected function uninstall() : void
      {
         this._titleObject = null;
         this._iconObject = null;
      }
      
      override public function load(param1:XML) : void
      {
      }
      
      override public function serialize() : XML
      {
         return null;
      }
      
      override public function fromXML(param1:XML) : void
      {
         var _loc2_:String = null;
         _loc2_ = param1.@title;
         if(_loc2_)
         {
            this.title = _loc2_;
         }
         _loc2_ = param1.@icon;
         if(_loc2_)
         {
            this.icon = _loc2_;
         }
         _loc2_ = param1.@titleColor;
         if(_loc2_)
         {
            this.titleColor = UtilsStr.convertFromHtmlColor(_loc2_);
            this._titleColorSet = true;
         }
         _loc2_ = param1.@titleFontSize;
         if(_loc2_)
         {
            this.titleFontSize = parseInt(_loc2_);
            this._titleFontSizeSet = true;
         }
         if(this.input)
         {
            this.promptText = param1.@prompt;
            if(this.promptText)
            {
               EGTextField(this._titleObject).promptText = this.promptText;
            }
            _loc2_ = param1.@maxLength;
            if(_loc2_)
            {
               this.maxLength = parseInt(_loc2_);
               if(this.maxLength > 0)
               {
                  EGTextField(this._titleObject).maxLength = this.maxLength;
               }
            }
            this.restrict = param1.@restrict;
            if(this.restrict)
            {
               EGTextField(this._titleObject).restrict = this.restrict;
            }
            this.keyboardType = param1.@keyboardType;
            if(this.keyboardType)
            {
               EGTextField(this._titleObject).keyboardType = this.keyboardType;
            }
            this._password = param1.@password == "true";
            if(this._password)
            {
               EGTextField(this._titleObject).password = this._password;
            }
         }
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = <Label/>;
         if(this._title)
         {
            _loc1_.@title = this._title;
         }
         if(this._titleColorSet)
         {
            _loc1_.@titleColor = UtilsStr.convertToHtmlColor(this._titleColor);
         }
         if(this._titleFontSizeSet)
         {
            _loc1_.@titleFontSize = this._titleFontSize;
         }
         if(this._icon)
         {
            _loc1_.@icon = this._icon;
         }
         if(this.input)
         {
            if(this.promptText)
            {
               _loc1_.@prompt = this.promptText;
            }
            if(this.maxLength > 0)
            {
               _loc1_.@maxLength = this.maxLength;
            }
            if(this.restrict)
            {
               _loc1_.@restrict = this.restrict;
            }
            if(this.keyboardType)
            {
               _loc1_.@keyboardType = this.keyboardType;
            }
            if(this._password)
            {
               _loc1_.@password = this._password;
            }
         }
         if(_loc1_.attributes().length() == 0)
         {
            return null;
         }
         return _loc1_;
      }
   }
}

package fairygui.editor.gui
{
   import fairygui.ObjectPropID;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   
   public class FLabel extends ComExtention
   {
       
      
      public var restrict:String;
      
      public var maxLength:int;
      
      public var keyboardType:int;
      
      private var _title:String;
      
      private var _icon:String;
      
      private var _titleColor:uint;
      
      private var _titleColorSet:Boolean;
      
      private var _originColor:uint;
      
      private var _titleFontSize:int;
      
      private var _titleFontSizeSet:Boolean;
      
      private var _originFontSize:int;
      
      private var _password:Boolean;
      
      private var _promptText:String;
      
      private var _titleObject:FObject;
      
      private var _iconObject:FObject;
      
      public function FLabel()
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
               if(this._titleObject is FTextField)
               {
                  FTextField(this._titleObject).color = this._titleColor;
               }
               else if(this._titleObject is FComponent)
               {
                  if(FComponent(this._titleObject).extentionId == "Label")
                  {
                     FLabel(FComponent(this._titleObject).extention).titleColor = this._titleColor;
                  }
                  else if(FComponent(this._titleObject).extentionId == "Button")
                  {
                     FButton(FComponent(this._titleObject).extention).titleColor = this._titleColor;
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
            if(this._titleObject is FTextField)
            {
               FTextField(this._titleObject).color = _loc2_;
            }
            else if(this._titleObject is FComponent)
            {
               if(FComponent(this._titleObject).extentionId == "Label")
               {
                  FLabel(FComponent(this._titleObject).extention).titleColor = _loc2_;
               }
               else if(FComponent(this._titleObject).extentionId == "Button")
               {
                  FButton(FComponent(this._titleObject).extention).titleColor = _loc2_;
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
               if(this._titleObject is FTextField)
               {
                  FTextField(this._titleObject).fontSize = this._titleFontSize;
               }
               else if(this._titleObject is FComponent)
               {
                  if(FComponent(this._titleObject).extentionId == "Label")
                  {
                     FLabel(FComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                  }
                  else if(FComponent(this._titleObject).extentionId == "Button")
                  {
                     FButton(FComponent(this._titleObject).extention).titleFontSize = this._titleFontSize;
                  }
               }
            }
            _owner.updateGear(9);
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
            if(this._titleObject is FTextField)
            {
               FTextField(this._titleObject).fontSize = _loc2_;
            }
            else if(this._titleObject is FComponent)
            {
               if(FComponent(this._titleObject).extentionId == "Label")
               {
                  FLabel(FComponent(this._titleObject).extention).titleFontSize = _loc2_;
               }
               else if(FComponent(this._titleObject).extentionId == "Button")
               {
                  FButton(FComponent(this._titleObject).extention).titleFontSize = _loc2_;
               }
            }
         }
      }
      
      public function get input() : Boolean
      {
         var _loc1_:FTextField = this.getTextField();
         return _loc1_ && _loc1_.input;
      }
      
      public function get password() : Boolean
      {
         return this._password;
      }
      
      public function set password(param1:Boolean) : void
      {
         this._password = param1;
         var _loc2_:FTextField = this.getTextField();
         if(_loc2_)
         {
            _loc2_.password = param1;
         }
      }
      
      public function get promptText() : String
      {
         return this._promptText;
      }
      
      public function set promptText(param1:String) : void
      {
         this._promptText = param1;
         var _loc2_:FTextField = this.getTextField();
         if(_loc2_)
         {
            _loc2_.promptText = param1;
         }
      }
      
      public function getTextField() : FTextField
      {
         if(this._titleObject is FTextField)
         {
            return FTextField(this._titleObject);
         }
         if(this._titleObject is FLabel)
         {
            return FLabel(this._titleObject).getTextField();
         }
         if(this._titleObject is FButton)
         {
            return FButton(this._titleObject).getTextField();
         }
         return null;
      }
      
      override public function getProp(param1:int) : *
      {
         var _loc2_:FTextField = null;
         switch(param1)
         {
            case ObjectPropID.Color:
               return this.titleColor;
            case ObjectPropID.OutlineColor:
               _loc2_ = this.getTextField();
               if(_loc2_)
               {
                  return _loc2_.strokeColor;
               }
               return 0;
            case ObjectPropID.FontSize:
               return this.titleFontSize;
            default:
               return super.getProp(param1);
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         var _loc3_:FTextField = null;
         switch(param1)
         {
            case ObjectPropID.Color:
               this.titleColor = param2;
               break;
            case ObjectPropID.OutlineColor:
               _loc3_ = this.getTextField();
               if(_loc3_)
               {
                  _loc3_.strokeColor = param2;
               }
               break;
            case ObjectPropID.FontSize:
               this.titleFontSize = param2;
               break;
            default:
               super.setProp(param1,param2);
         }
      }
      
      override public function create() : void
      {
         this._titleObject = owner.getChild("title");
         this._iconObject = owner.getChild("icon");
         if(this._titleObject)
         {
            if(this._titleObject is FTextField)
            {
               this._originColor = FTextField(this._titleObject).color;
               this._originFontSize = FTextField(this._titleObject).fontSize;
            }
            else if(this._titleObject is FComponent)
            {
               if(FComponent(this._titleObject).extentionId == "Label")
               {
                  this._originColor = FLabel(FComponent(this._titleObject).extention).titleColor;
                  this._originFontSize = FLabel(FComponent(this._titleObject).extention).titleFontSize;
               }
               else if(FComponent(this._titleObject).extentionId == "Button")
               {
                  this._originColor = FButton(FComponent(this._titleObject).extention).titleColor;
                  this._originFontSize = FButton(FComponent(this._titleObject).extention).titleFontSize;
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
      
      override public function read(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         _loc3_ = param1.getAttribute("title");
         if(param2)
         {
            _loc4_ = param2[_owner.id];
            if(_loc4_ != undefined)
            {
               _loc3_ = _loc4_;
            }
         }
         if(_loc3_)
         {
            this.title = _loc3_;
         }
         _loc3_ = param1.getAttribute("icon");
         if(_loc3_)
         {
            this.icon = _loc3_;
         }
         _loc3_ = param1.getAttribute("titleColor");
         if(_loc3_)
         {
            this.titleColor = UtilsStr.convertFromHtmlColor(_loc3_);
            this._titleColorSet = true;
         }
         _loc3_ = param1.getAttribute("titleFontSize");
         if(_loc3_)
         {
            this.titleFontSize = parseInt(_loc3_);
            this._titleFontSizeSet = true;
         }
         if(this.input)
         {
            this.promptText = param1.getAttribute("prompt");
            if(param2)
            {
               _loc4_ = param2[_owner.id + "-0"];
               if(_loc4_ != undefined)
               {
                  this.promptText = _loc4_;
               }
            }
            if(this.promptText)
            {
               FTextField(this._titleObject).promptText = this.promptText;
            }
            _loc3_ = param1.getAttribute("maxLength");
            if(_loc3_)
            {
               this.maxLength = parseInt(_loc3_);
               if(this.maxLength > 0)
               {
                  FTextField(this._titleObject).maxLength = this.maxLength;
               }
            }
            this.restrict = param1.getAttribute("restrict");
            if(this.restrict)
            {
               FTextField(this._titleObject).restrict = this.restrict;
            }
            this.keyboardType = param1.getAttributeInt("keyboardType");
            if(this.keyboardType)
            {
               FTextField(this._titleObject).keyboardType = this.keyboardType;
            }
            this._password = param1.getAttributeBool("password");
            if(this._password)
            {
               FTextField(this._titleObject).password = this._password;
            }
         }
      }
      
      override public function write() : XData
      {
         var _loc1_:XData = XData.create("Label");
         if(this._title)
         {
            _loc1_.setAttribute("title",this._title);
         }
         if(this._titleColorSet)
         {
            _loc1_.setAttribute("titleColor",UtilsStr.convertToHtmlColor(this._titleColor));
         }
         if(this._titleFontSizeSet)
         {
            _loc1_.setAttribute("titleFontSize",this._titleFontSize);
         }
         if(this._icon)
         {
            _loc1_.setAttribute("icon",this._icon);
         }
         if(this.input)
         {
            if(this.promptText)
            {
               _loc1_.setAttribute("prompt",this.promptText);
            }
            if(this.maxLength > 0)
            {
               _loc1_.setAttribute("maxLength",this.maxLength);
            }
            if(this.restrict)
            {
               _loc1_.setAttribute("restrict",this.restrict);
            }
            if(this.keyboardType)
            {
               _loc1_.setAttribute("keyboardType",this.keyboardType);
            }
            if(this._password)
            {
               _loc1_.setAttribute("password",this._password);
            }
         }
         if(_loc1_.hasAttributes())
         {
            return _loc1_;
         }
         return null;
      }
   }
}

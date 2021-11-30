package fairygui
{
   import fairygui.utils.ToolSet;
   
   public class GLabel extends GComponent
   {
       
      
      protected var _titleObject:GObject;
      
      protected var _iconObject:GObject;
      
      public function GLabel()
      {
         super();
      }
      
      override public function get icon() : String
      {
         if(_iconObject != null)
         {
            return _iconObject.icon;
         }
         return null;
      }
      
      override public function set icon(param1:String) : void
      {
         if(_iconObject != null)
         {
            _iconObject.icon = param1;
         }
         updateGear(7);
      }
      
      public final function get title() : String
      {
         if(_titleObject)
         {
            return _titleObject.text;
         }
         return null;
      }
      
      public function set title(param1:String) : void
      {
         if(_titleObject)
         {
            _titleObject.text = param1;
         }
         updateGear(6);
      }
      
      override public final function get text() : String
      {
         return this.title;
      }
      
      override public function set text(param1:String) : void
      {
         this.title = param1;
      }
      
      public final function get titleColor() : uint
      {
         var _loc1_:GTextField = getTextField();
         if(_loc1_)
         {
            return _loc1_.color;
         }
         return 0;
      }
      
      public function set titleColor(param1:uint) : void
      {
         var _loc2_:GTextField = getTextField();
         if(_loc2_)
         {
            _loc2_.color = param1;
         }
         updateGear(4);
      }
      
      public final function get titleFontSize() : int
      {
         var _loc1_:GTextField = getTextField();
         if(_loc1_)
         {
            return _loc1_.fontSize;
         }
         return 0;
      }
      
      public function set titleFontSize(param1:int) : void
      {
         var _loc2_:GTextField = getTextField();
         if(_loc2_)
         {
            _loc2_.fontSize = param1;
         }
      }
      
      public function set editable(param1:Boolean) : void
      {
         var _loc2_:GTextField = getTextField();
         if(_loc2_ && _loc2_ is GTextInput)
         {
            _loc2_.asTextInput.editable = param1;
         }
      }
      
      public function get editable() : Boolean
      {
         var _loc1_:GTextField = getTextField();
         if(_loc1_ && _loc1_ is GTextInput)
         {
            return _loc1_.asTextInput.editable;
         }
         return false;
      }
      
      public function getTextField() : GTextField
      {
         if(_titleObject is GTextField)
         {
            return GTextField(_titleObject);
         }
         if(_titleObject is GLabel)
         {
            return GLabel(_titleObject).getTextField();
         }
         if(_titleObject is GButton)
         {
            return GButton(_titleObject).getTextField();
         }
         return null;
      }
      
      override public function getProp(param1:int) : *
      {
         var _loc2_:* = null;
         switch(int(param1) - 2)
         {
            case 0:
               return this.titleColor;
            case 1:
               _loc2_ = getTextField();
               if(_loc2_)
               {
                  return _loc2_.strokeColor;
               }
               return 0;
            default:
            default:
            default:
            default:
               return super.getProp(param1);
            case 6:
               return this.titleFontSize;
         }
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         var _loc3_:* = null;
         switch(int(param1) - 2)
         {
            case 0:
               this.titleColor = param2;
               break;
            case 1:
               _loc3_ = getTextField();
               if(_loc3_)
               {
                  _loc3_.strokeColor = param2;
               }
               break;
            default:
            default:
            default:
            default:
               super.setProp(param1,param2);
               break;
            case 6:
               this.titleFontSize = param2;
         }
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         super.constructFromXML(param1);
         _titleObject = getChild("title");
         _iconObject = getChild("icon");
      }
      
      override public function setup_afterAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         super.setup_afterAdd(param1);
         param1 = param1.Label[0];
         if(param1)
         {
            _loc2_ = param1.@title;
            if(_loc2_)
            {
               this.text = _loc2_;
            }
            _loc2_ = param1.@icon;
            if(_loc2_)
            {
               this.icon = _loc2_;
            }
            _loc2_ = param1.@titleColor;
            if(_loc2_)
            {
               this.titleColor = ToolSet.convertFromHtmlColor(_loc2_);
            }
            _loc2_ = param1.@titleFontSize;
            if(_loc2_)
            {
               this.titleFontSize = parseInt(_loc2_);
            }
            _loc3_ = getTextField();
            if(_loc3_ is GTextInput)
            {
               _loc2_ = param1.@prompt;
               if(_loc2_)
               {
                  GTextInput(_loc3_).promptText = _loc2_;
               }
               _loc2_ = param1.@maxLength;
               if(_loc2_)
               {
                  GTextInput(_loc3_).maxLength = parseInt(_loc2_);
               }
               _loc2_ = param1.@restrict;
               if(_loc2_)
               {
                  GTextInput(_loc3_).restrict = _loc2_;
               }
               _loc2_ = param1.@password;
               if(_loc2_)
               {
                  GTextInput(_loc3_).password = _loc2_ == "true";
               }
            }
         }
      }
   }
}

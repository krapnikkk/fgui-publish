package fairygui.editor.gui.gear
{
   import com.greensock.easing.Ease;
   import com.greensock.easing.EaseLookup;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EControllerPage;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.utils.Utils;
   
   public class EGearBase
   {
      
      private static var GearXMLKeys:Array = ["gearDisplay","gearXY","gearSize","gearLook","gearColor","gearAni","gearText","gearIcon"];
       
      
      public var owner:EGObject;
      
      public var gearIndex:int;
      
      protected var _tween:Boolean;
      
      protected var _easeType:String;
      
      protected var _easeInOutType:String;
      
      protected var _ease:Ease;
      
      protected var _duration:Number;
      
      protected var _delay:Number;
      
      protected var _displayLockToken:uint;
      
      protected var _controller:EController;
      
      protected var _storage:Object;
      
      protected var _default;
      
      public var display:Boolean;
      
      public function EGearBase(param1:EGObject)
      {
         super();
         this.owner = param1;
         this._easeType = "Quad";
         this._easeInOutType = "Out";
         this._duration = 0.3;
         this._delay = 0;
         this._ease = EaseLookup.find(this._easeType + ".ease" + this._easeInOutType);
      }
      
      public function get controller() : String
      {
         if(this._controller && this._controller.parent)
         {
            return this._controller.name;
         }
         return null;
      }
      
      public function set controller(param1:String) : void
      {
         var _loc2_:EController = null;
         if(param1)
         {
            _loc2_ = this.owner.parent.getController(param1);
         }
         if(_loc2_ != this._controller)
         {
            this._controller = _loc2_;
            if(this._controller)
            {
               this.init();
               this.display = true;
            }
            else
            {
               this.display = false;
               if(this is EGearDisplay)
               {
                  this.owner.checkGearDisplay();
               }
            }
         }
      }
      
      public function get controllerObject() : EController
      {
         return this._controller;
      }
      
      public function get tween() : Boolean
      {
         return this._tween;
      }
      
      public function set tween(param1:Boolean) : void
      {
         this._tween = param1;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function set duration(param1:Number) : void
      {
         this._duration = param1;
      }
      
      public function get delay() : Number
      {
         return this._delay;
      }
      
      public function set delay(param1:Number) : void
      {
         this._delay = param1;
      }
      
      public function get easeInOutType() : String
      {
         return this._easeInOutType;
      }
      
      public function set easeInOutType(param1:String) : void
      {
         this._easeInOutType = param1;
         if(this._easeType == "Linear")
         {
            this._ease = EaseLookup.find("linear.easenone");
         }
         else
         {
            this._ease = EaseLookup.find(this._easeType + ".ease" + this._easeInOutType);
         }
      }
      
      public function get easeType() : String
      {
         return this._easeType;
      }
      
      public function set easeType(param1:String) : void
      {
         this._easeType = param1;
         if(this._easeType == "Linear")
         {
            this._ease = EaseLookup.find("linear.easenone");
         }
         else
         {
            this._ease = EaseLookup.find(this._easeType + ".ease" + this._easeInOutType);
         }
      }
      
      public function get easeName() : String
      {
         if(this._easeType == "Linear")
         {
            return this._easeType;
         }
         return this._easeType + "." + this._easeInOutType;
      }
      
      protected function writeValue(param1:Object) : String
      {
         return "";
      }
      
      protected function readValue(param1:String) : Object
      {
         return null;
      }
      
      public function fromXML(param1:XML) : void
      {
         var _loc7_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         this._controller = this.owner.parent.getController(param1.@controller);
         if(this._controller != null)
         {
            this.display = true;
            this.init();
         }
         else
         {
            this.display = false;
         }
         _loc7_ = param1.@tween;
         if(_loc7_)
         {
            this._tween = true;
         }
         _loc7_ = param1.@ease;
         if(_loc7_)
         {
            _loc5_ = _loc7_.indexOf(".");
            if(_loc5_ != -1)
            {
               this.easeType = _loc7_.substr(0,_loc5_);
               this.easeInOutType = _loc7_.substr(_loc5_ + 1);
            }
            else
            {
               this.easeType = _loc7_;
            }
         }
         _loc7_ = param1.@duration;
         if(_loc7_)
         {
            this._duration = parseFloat(_loc7_);
         }
         _loc7_ = param1.@delay;
         if(_loc7_)
         {
            this._delay = parseFloat(_loc7_);
         }
         if(this is EGearDisplay)
         {
            _loc7_ = param1.@pages;
            if(_loc7_)
            {
               EGearDisplay(this).pages = _loc7_.split(",");
            }
         }
         else
         {
            _loc7_ = param1.@pages;
            if(_loc7_)
            {
               _loc6_ = _loc7_.split(",");
            }
            else
            {
               _loc6_ = [];
            }
            _loc7_ = param1.@values;
            if(_loc7_)
            {
               _loc2_ = _loc7_.split("|");
            }
            else
            {
               _loc2_ = [];
            }
            if(this._storage != null)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc6_.length)
               {
                  _loc7_ = _loc2_[_loc3_];
                  if(_loc7_ == null)
                  {
                     _loc7_ = "";
                  }
                  _loc4_ = this.readValue(_loc7_);
                  if(_loc4_ != null)
                  {
                     this._storage[_loc6_[_loc3_]] = _loc4_;
                  }
                  _loc3_++;
               }
            }
            _loc7_ = param1["default"];
            if(_loc7_)
            {
               this._default = this.readValue(_loc7_);
            }
         }
      }
      
      public function toXML() : XML
      {
         var _loc7_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc4_:Boolean = false;
         var _loc3_:Vector.<EControllerPage> = null;
         var _loc8_:XML = new XML("<" + GearXMLKeys[this.gearIndex] + "/>");
         if(this._controller && this._controller.parent)
         {
            _loc8_.@controller = this._controller.name;
            if(this is EGearDisplay)
            {
               _loc8_.@pages = EGearDisplay(this).pages.join(",");
            }
            else
            {
               _loc6_ = "";
               _loc1_ = 0;
               _loc2_ = "";
               _loc4_ = true;
               if(this._storage != null)
               {
                  _loc3_ = this._controller.getPages();
                  _loc7_ = 0;
                  while(_loc7_ < _loc3_.length)
                  {
                     _loc5_ = this._storage[_loc3_[_loc7_].id];
                     if(_loc5_ != null)
                     {
                        if(!_loc4_)
                        {
                           _loc6_ = _loc6_ + "|";
                           _loc2_ = _loc2_ + ",";
                        }
                        else
                        {
                           _loc4_ = false;
                        }
                        _loc6_ = _loc6_ + this.writeValue(_loc5_);
                        _loc2_ = _loc2_ + _loc3_[_loc7_].id;
                        _loc1_++;
                     }
                     _loc7_++;
                  }
               }
               if(_loc1_ > 0)
               {
                  _loc8_.@pages = _loc2_;
                  _loc8_.@values = _loc6_;
               }
               if(this._default != undefined && this._default != null && _loc1_ < _loc3_.length)
               {
                  _loc8_["default"] = this.writeValue(this._default);
               }
            }
         }
         else
         {
            _loc8_.@controller = "";
         }
         if(this._tween)
         {
            _loc8_.@tween = true;
         }
         _loc6_ = this.easeName;
         if(_loc6_ != "Quad.Out")
         {
            _loc8_.@ease = _loc6_;
         }
         if(this._duration != 0.3)
         {
            _loc8_.@duration = this._duration;
         }
         if(this._delay != 0)
         {
            _loc8_.@delay = this._delay;
         }
         return _loc8_;
      }
      
      protected function init() : void
      {
      }
      
      public function apply() : void
      {
      }
      
      public function updateState() : void
      {
      }
      
      public function updateFromRelations(param1:Number, param2:Number) : void
      {
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
         if(!this.owner.underConstruct && !Utils.equalText(_loc4_,_loc3_))
         {
            this.owner.pkg.project.editorWindow.activeComDocument.actionHistory.action_gearSet(this.owner,this.gearIndex,param1,_loc3_,_loc4_);
         }
         return _loc4_;
      }
   }
}

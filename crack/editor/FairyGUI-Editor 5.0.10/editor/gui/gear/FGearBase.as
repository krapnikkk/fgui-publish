package fairygui.editor.gui.gear
{
   import fairygui.editor.gui.FController;
   import fairygui.editor.gui.FControllerPage;
   import fairygui.editor.gui.FObject;
   import fairygui.utils.XData;
   
   public class FGearBase
   {
      
      private static var Classes:Array;
      
      public static var NameToIndex:Object = {
         "gearDisplay":0,
         "gearXY":1,
         "gearSize":2,
         "gearLook":3,
         "gearColor":4,
         "gearAni":5,
         "gearText":6,
         "gearIcon":7,
         "gearDisplay2":8,
         "gearFontSize":9
      };
      
      public static var Names:Array = ["gearDisplay","gearXY","gearSize","gearLook","gearColor","gearAni","gearText","gearIcon","gearDisplay2","gearFontSize"];
       
      
      public var _owner:FObject;
      
      public var _gearIndex:int;
      
      public var _display:Boolean;
      
      protected var _tween:Boolean;
      
      protected var _easeType:String;
      
      protected var _easeInOutType:String;
      
      protected var _duration:Number;
      
      protected var _delay:Number;
      
      protected var _positionsInPercent:Boolean;
      
      protected var _condition:int;
      
      protected var _displayLockToken:uint;
      
      protected var _controller:FController;
      
      protected var _storage:Object;
      
      protected var _storageHistory:Object;
      
      protected var _default;
      
      public function FGearBase(param1:FObject)
      {
         super();
         this._owner = param1;
         this._easeType = "Quad";
         this._easeInOutType = "Out";
         this._duration = 0.3;
         this._delay = 0;
      }
      
      public static function create(param1:FObject, param2:int) : FGearBase
      {
         if(!Classes)
         {
            Classes = [FGearDisplay,FGearXY,FGearSize,FGearLook,FGearColor,FGearAnimation,FGearText,FGearIcon,FGearDisplay2,FGearFontSize];
         }
         return new Classes[param2](param1);
      }
      
      public static function getIndexByName(param1:String) : int
      {
         var _loc2_:* = NameToIndex[param1];
         if(_loc2_ == undefined)
         {
            return -1;
         }
         return int(_loc2_);
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
         var _loc2_:FController = null;
         var _loc3_:Object = null;
         if(param1)
         {
            _loc2_ = this._owner._parent.getController(param1);
         }
         if(_loc2_ != this._controller)
         {
            if(this._controller)
            {
               if(!this._storageHistory)
               {
                  this._storageHistory = {};
               }
               this._storageHistory[this._controller.name] = [this._storage,this._default];
            }
            this._controller = _loc2_;
            if(this._controller)
            {
               if(this._storageHistory)
               {
                  _loc3_ = this._storageHistory[this._controller.name];
                  if(_loc3_)
                  {
                     this._storage = _loc3_[0];
                     this._default = _loc3_[1];
                  }
                  else
                  {
                     this.init();
                  }
               }
               else
               {
                  this.init();
               }
            }
            if(this._gearIndex == 0 || this._gearIndex == 8)
            {
               this.apply();
               this._owner.checkGearDisplay();
            }
            else if(this._controller)
            {
               this.apply();
            }
         }
      }
      
      public function get controllerObject() : FController
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
      }
      
      public function get easeType() : String
      {
         return this._easeType;
      }
      
      public function set easeType(param1:String) : void
      {
         this._easeType = param1;
      }
      
      public function get easeName() : String
      {
         if(this._easeType == "Linear")
         {
            return this._easeType;
         }
         return this._easeType + "." + this._easeInOutType;
      }
      
      public function get positionsInPercent() : Boolean
      {
         return this._positionsInPercent;
      }
      
      public function set positionsInPercent(param1:Boolean) : void
      {
         this._positionsInPercent = param1;
      }
      
      public function get condition() : int
      {
         return this._condition;
      }
      
      public function set condition(param1:int) : void
      {
         if(this._condition != param1)
         {
            this._condition = param1;
            this._owner.checkGearDisplay();
         }
      }
      
      protected function writeValue(param1:Object) : String
      {
         return "";
      }
      
      protected function readValue(param1:String) : Object
      {
         return null;
      }
      
      public function read(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:* = undefined;
         this._controller = this._owner._parent.getController(param1.getAttribute("controller"));
         if(this._controller != null)
         {
            this.init();
         }
         this._tween = param1.getAttributeBool("tween");
         _loc3_ = param1.getAttribute("ease");
         if(_loc3_)
         {
            _loc5_ = _loc3_.indexOf(".");
            if(_loc5_ != -1)
            {
               this.easeType = _loc3_.substr(0,_loc5_);
               this.easeInOutType = _loc3_.substr(_loc5_ + 1);
            }
            else
            {
               this.easeType = _loc3_;
            }
         }
         this._duration = param1.getAttributeFloat("duration",0.3);
         this._delay = param1.getAttributeFloat("delay");
         _loc3_ = param1.getAttribute("pages");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
         }
         else
         {
            _loc4_ = [];
         }
         if(this._gearIndex == 0 || this._gearIndex == 8)
         {
            this._condition = param1.getAttributeInt("condition");
            this._storage = _loc4_;
         }
         else
         {
            this._positionsInPercent = param1.getAttributeBool("positionsInPercent");
            _loc3_ = param1.getAttribute("values");
            if(_loc3_)
            {
               _loc6_ = _loc3_.split("|");
            }
            else
            {
               _loc6_ = [];
            }
            if(this._storage != null)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc4_.length)
               {
                  _loc3_ = _loc6_[_loc7_];
                  if(_loc3_ == null)
                  {
                     _loc3_ = "";
                  }
                  if(param2)
                  {
                     _loc9_ = param2[this._owner._id + "-texts_" + _loc7_];
                     if(_loc9_ != undefined)
                     {
                        _loc3_ = _loc9_;
                     }
                  }
                  _loc8_ = this.readValue(_loc3_);
                  if(_loc8_ != null)
                  {
                     this._storage[_loc4_[_loc7_]] = _loc8_;
                  }
                  _loc7_++;
               }
            }
            _loc3_ = param1.getAttribute("default");
            if(param2)
            {
               _loc9_ = param2[this._owner._id + "-texts_def"];
               if(_loc9_ != undefined)
               {
                  _loc3_ = _loc9_;
               }
            }
            if(_loc3_)
            {
               this._default = this.readValue(_loc3_);
            }
         }
      }
      
      public function write() : XData
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:Boolean = false;
         var _loc8_:Vector.<FControllerPage> = null;
         var _loc1_:XData = XData.create(Names[this._gearIndex]);
         if(this._controller && this._controller.parent)
         {
            _loc1_.setAttribute("controller",this._controller.name);
            if(this._gearIndex == 0 || this._gearIndex == 8)
            {
               if(this._gearIndex == 8)
               {
                  _loc1_.setAttribute("pages",FGearDisplay2(this).pages.join(","));
                  _loc1_.setAttribute("condition",this._condition);
               }
               else
               {
                  _loc1_.setAttribute("pages",FGearDisplay(this).pages.join(","));
               }
            }
            else
            {
               _loc4_ = "";
               _loc5_ = 0;
               _loc6_ = "";
               _loc7_ = true;
               if(this._storage != null)
               {
                  _loc8_ = this._controller.getPages();
                  _loc2_ = 0;
                  while(_loc2_ < _loc8_.length)
                  {
                     _loc3_ = this._storage[_loc8_[_loc2_].id];
                     if(_loc3_ != null)
                     {
                        if(!_loc7_)
                        {
                           _loc4_ = _loc4_ + "|";
                           _loc6_ = _loc6_ + ",";
                        }
                        else
                        {
                           _loc7_ = false;
                        }
                        _loc4_ = _loc4_ + this.writeValue(_loc3_);
                        _loc6_ = _loc6_ + _loc8_[_loc2_].id;
                        _loc5_++;
                     }
                     _loc2_++;
                  }
               }
               if(_loc5_ > 0)
               {
                  _loc1_.setAttribute("pages",_loc6_);
                  _loc1_.setAttribute("values",_loc4_);
               }
               if(this._default != undefined && this._default != null && _loc5_ < _loc8_.length)
               {
                  _loc1_.setAttribute("default",this.writeValue(this._default));
               }
            }
         }
         else
         {
            _loc1_.setAttribute("controller","");
         }
         if(this._tween)
         {
            _loc1_.setAttribute("tween",true);
         }
         _loc4_ = this.easeName;
         if(_loc4_ != "Quad.Out")
         {
            _loc1_.setAttribute("ease",_loc4_);
         }
         if(this._duration != 0.3)
         {
            _loc1_.setAttribute("duration",this._duration);
         }
         if(this._delay != 0)
         {
            _loc1_.setAttribute("delay",this._delay);
         }
         if(this._positionsInPercent)
         {
            _loc1_.setAttribute("positionsInPercent",true);
         }
         return _loc1_;
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
   }
}

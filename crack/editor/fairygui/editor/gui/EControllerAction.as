package fairygui.editor.gui
{
   public class EControllerAction
   {
       
      
      public var type:String;
      
      public var fromPage:Array;
      
      public var toPage:Array;
      
      public var transitionName:String;
      
      public var repeat:int;
      
      public var delay:Number;
      
      public var stopOnExit:Boolean;
      
      public var objectId:String;
      
      public var controllerName:String;
      
      public var targetPage:String;
      
      private var _currentTransition:ETransition;
      
      public function EControllerAction()
      {
         super();
         this.fromPage = [];
         this.toPage = [];
         this.repeat = 1;
         this.delay = 0;
      }
      
      public function run(param1:EController, param2:String, param3:String) : void
      {
         var _loc4_:Boolean = (this.fromPage.length == 0 || this.fromPage.indexOf(param2) != -1) && (this.toPage.length == 0 || this.toPage.indexOf(param3) != -1);
         if(_loc4_)
         {
            this.enter(param1);
         }
         else
         {
            this.leave(param1);
         }
      }
      
      public function copyFrom(param1:EControllerAction) : void
      {
         this.type = param1.type;
         this.copyArray(param1.fromPage,this.fromPage);
         this.copyArray(param1.toPage,this.toPage);
         if(this.type == "play_transition")
         {
            this.transitionName = param1.transitionName;
            this.repeat = param1.repeat;
            this.delay = param1.delay;
            this.stopOnExit = param1.stopOnExit;
         }
         else if(this.type == "change_page")
         {
            this.objectId = param1.objectId;
            this.controllerName = param1.controllerName;
            this.targetPage = param1.targetPage;
         }
      }
      
      public function reset() : void
      {
         this.fromPage.length = 0;
         this.toPage.length = 0;
         this.transitionName = null;
         this.repeat = 1;
         this.delay = 0;
         this.stopOnExit = false;
         this.objectId = null;
         this.controllerName = null;
         this.targetPage = null;
      }
      
      public function copyArray(param1:Array, param2:Array) : void
      {
         var _loc3_:int = param1.length;
         param2.length = _loc3_;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            param2[_loc4_] = param1[_loc4_];
            _loc4_++;
         }
      }
      
      public function getFullControllerName(param1:EGComponent) : String
      {
         var _loc2_:EGObject = null;
         if(this.objectId)
         {
            _loc2_ = param1.getChildById(this.objectId);
            if(_loc2_)
            {
               return _loc2_.name + "." + this.controllerName;
            }
            return "";
         }
         return this.controllerName;
      }
      
      public function getControllerObj(param1:EGComponent) : EController
      {
         if(this.controllerName)
         {
            if(this.objectId)
            {
               param1 = param1.getChildById(this.objectId) as EGComponent;
            }
            if(param1)
            {
               return param1.getController(this.controllerName);
            }
         }
         return null;
      }
      
      public function fromXML(param1:XML) : void
      {
         var _loc2_:String = null;
         this.type = param1.@type;
         _loc2_ = param1.@fromPage;
         if(_loc2_)
         {
            this.fromPage = _loc2_.split(",");
         }
         _loc2_ = param1.@toPage;
         if(_loc2_)
         {
            this.toPage = _loc2_.split(",");
         }
         if(this.type == "play_transition")
         {
            this.transitionName = param1.@transition;
            _loc2_ = param1.@repeat;
            if(_loc2_)
            {
               this.repeat = parseInt(_loc2_);
            }
            _loc2_ = param1.@delay;
            if(_loc2_)
            {
               this.delay = parseFloat(_loc2_);
            }
            _loc2_ = param1.@stopOnExit;
            this.stopOnExit = _loc2_ == "true";
         }
         else if(this.type == "change_page")
         {
            this.objectId = param1.@objectId;
            this.controllerName = param1.@controller;
            this.targetPage = param1.@targetPage;
         }
      }
      
      public function toXML() : XML
      {
         var _loc1_:XML = <action/>;
         _loc1_.@type = this.type;
         _loc1_.@fromPage = this.fromPage.join(",");
         _loc1_.@toPage = this.toPage.join(",");
         if(this.type == "play_transition")
         {
            _loc1_.@transition = !!this.transitionName?this.transitionName:"";
            if(this.repeat != 1)
            {
               _loc1_.@repeat = this.repeat;
            }
            if(this.delay != 0)
            {
               _loc1_.@delay = this.delay;
            }
            if(this.stopOnExit)
            {
               _loc1_.@stopOnExit = this.stopOnExit;
            }
         }
         else if(this.type == "change_page")
         {
            if(this.objectId)
            {
               _loc1_.@objectId = this.objectId;
            }
            _loc1_.@controller = !!this.controllerName?this.controllerName:"";
            _loc1_.@targetPage = this.targetPage;
         }
         return _loc1_;
      }
      
      public function setProperty(param1:String, param2:*) : *
      {
         var _loc3_:* = undefined;
         this[param1] = param2;
         _loc3_ = this[param1];
         return _loc3_;
      }
      
      protected function enter(param1:EController) : void
      {
         var _loc3_:ETransition = null;
         var _loc2_:EController = null;
         var _loc4_:* = this.type;
         if("play_transition" !== _loc4_)
         {
            if("change_page" === _loc4_)
            {
               _loc2_ = this.getControllerObj(param1.parent);
               if(_loc2_ && _loc2_ != param1 && !_loc2_.changing)
               {
                  _loc2_.selectedPageId = this.targetPage;
               }
            }
         }
         else
         {
            if(param1.parent.editMode != 1)
            {
               return;
            }
            _loc3_ = param1.parent.transitions.getItem(this.transitionName);
            if(_loc3_)
            {
               if(this._currentTransition && this._currentTransition.playing)
               {
                  _loc3_.repeat = this.repeat;
               }
               else
               {
                  _loc3_.play(null,null,this.repeat,this.delay);
               }
               this._currentTransition = _loc3_;
            }
         }
      }
      
      protected function leave(param1:EController) : void
      {
         var _loc2_:* = this.type;
         if("play_transition" === _loc2_)
         {
            if(param1.parent.editMode != 1)
            {
               return;
            }
            if(this.stopOnExit && this._currentTransition)
            {
               this._currentTransition.stop();
               this._currentTransition = null;
            }
         }
      }
   }
}

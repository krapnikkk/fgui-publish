package fairygui.editor.gui
{
   import fairygui.utils.XData;
   
   public class FControllerAction
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
      
      private var _currentTransition:FTransition;
      
      public function FControllerAction()
      {
         super();
         this.fromPage = [];
         this.toPage = [];
         this.repeat = 1;
         this.delay = 0;
      }
      
      public function run(param1:FController, param2:String, param3:String) : void
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
      
      public function copyFrom(param1:FControllerAction) : void
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
      
      public function getFullControllerName(param1:FComponent) : String
      {
         var _loc2_:FObject = null;
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
      
      public function getControllerObj(param1:FComponent) : FController
      {
         if(this.controllerName)
         {
            if(this.objectId)
            {
               param1 = param1.getChildById(this.objectId) as FComponent;
            }
            if(param1)
            {
               return param1.getController(this.controllerName);
            }
         }
         return null;
      }
      
      public function read(param1:XData) : void
      {
         var _loc2_:String = null;
         this.type = param1.getAttribute("type");
         _loc2_ = param1.getAttribute("fromPage");
         if(_loc2_)
         {
            this.fromPage = _loc2_.split(",");
         }
         _loc2_ = param1.getAttribute("toPage");
         if(_loc2_)
         {
            this.toPage = _loc2_.split(",");
         }
         if(this.type == "play_transition")
         {
            this.transitionName = param1.getAttribute("transition");
            this.repeat = param1.getAttributeInt("repeat",1);
            this.delay = param1.getAttributeFloat("delay");
            this.stopOnExit = param1.getAttributeBool("stopOnExit");
         }
         else if(this.type == "change_page")
         {
            this.objectId = param1.getAttribute("objectId");
            this.controllerName = param1.getAttribute("controller");
            this.targetPage = param1.getAttribute("targetPage");
         }
      }
      
      public function write() : XData
      {
         var _loc1_:XData = XData.create("action");
         _loc1_.setAttribute("type",this.type);
         _loc1_.setAttribute("fromPage",this.fromPage.join(","));
         _loc1_.setAttribute("toPage",this.toPage.join(","));
         if(this.type == "play_transition")
         {
            _loc1_.setAttribute("transition",!!this.transitionName?this.transitionName:"");
            if(this.repeat != 1)
            {
               _loc1_.setAttribute("repeat",this.repeat);
            }
            if(this.delay != 0)
            {
               _loc1_.setAttribute("delay",this.delay);
            }
            if(this.stopOnExit)
            {
               _loc1_.setAttribute("stopOnExit",this.stopOnExit);
            }
         }
         else if(this.type == "change_page")
         {
            if(this.objectId)
            {
               _loc1_.setAttribute("objectId",this.objectId);
            }
            _loc1_.setAttribute("controller",!!this.controllerName?this.controllerName:"");
            _loc1_.setAttribute("targetPage",this.targetPage);
         }
         return _loc1_;
      }
      
      protected function enter(param1:FController) : void
      {
         var _loc2_:FTransition = null;
         var _loc3_:FController = null;
         switch(this.type)
         {
            case "play_transition":
               if((param1.parent._flags & FObjectFlags.IN_TEST) == 0)
               {
                  return;
               }
               _loc2_ = param1.parent.transitions.getItem(this.transitionName);
               if(_loc2_)
               {
                  if(this._currentTransition && this._currentTransition.playing)
                  {
                     _loc2_.playTimes = this.repeat;
                  }
                  else
                  {
                     _loc2_.play(null,null,this.repeat,this.delay);
                  }
                  this._currentTransition = _loc2_;
               }
               break;
            case "change_page":
               _loc3_ = this.getControllerObj(param1.parent);
               if(_loc3_ && _loc3_ != param1 && !_loc3_.changing)
               {
                  if(this.targetPage == "~1")
                  {
                     if(param1.selectedIndex < _loc3_.pageCount)
                     {
                        _loc3_.selectedIndex = param1.selectedIndex;
                     }
                  }
                  else if(this.targetPage == "~2")
                  {
                     _loc3_.selectedPage = param1.selectedPage;
                  }
                  else
                  {
                     _loc3_.selectedPageId = this.targetPage;
                  }
               }
         }
      }
      
      protected function leave(param1:FController) : void
      {
         switch(this.type)
         {
            case "play_transition":
               if((param1.parent._flags & FObjectFlags.IN_TEST) == 0)
               {
                  return;
               }
               if(this.stopOnExit && this._currentTransition)
               {
                  this._currentTransition.stop();
                  this._currentTransition = null;
               }
               break;
         }
      }
   }
}

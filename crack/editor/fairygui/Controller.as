package fairygui
{
   import fairygui.action.ControllerAction;
   import fairygui.action.PlayTransitionAction;
   import fairygui.event.StateChangeEvent;
   import flash.events.EventDispatcher;
   
   public class Controller extends EventDispatcher
   {
      
      private static var _nextPageId:uint;
       
      
      private var _name:String;
      
      private var _selectedIndex:int;
      
      private var _previousIndex:int;
      
      private var _pageIds:Array;
      
      private var _pageNames:Array;
      
      private var _actions:Vector.<ControllerAction>;
      
      var _parent:GComponent;
      
      var _autoRadioGroupDepth:Boolean;
      
      public var changing:Boolean;
      
      public function Controller()
      {
         super();
         _pageIds = [];
         _pageNames = [];
         _selectedIndex = -1;
         _previousIndex = -1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get parent() : GComponent
      {
         return _parent;
      }
      
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(_selectedIndex != param1)
         {
            if(param1 > _pageIds.length - 1)
            {
               throw new Error("index out of bounds: " + param1);
            }
            changing = true;
            _previousIndex = _selectedIndex;
            _selectedIndex = param1;
            _parent.applyController(this);
            this.dispatchEvent(new StateChangeEvent("stateChanged"));
            changing = false;
         }
      }
      
      public function setSelectedIndex(param1:int) : void
      {
         if(_selectedIndex != param1)
         {
            if(param1 > _pageIds.length - 1)
            {
               throw new Error("index out of bounds: " + param1);
            }
            changing = true;
            _previousIndex = _selectedIndex;
            _selectedIndex = param1;
            _parent.applyController(this);
            changing = false;
         }
      }
      
      public function get previsousIndex() : int
      {
         return _previousIndex;
      }
      
      public function get selectedPage() : String
      {
         if(_selectedIndex == -1)
         {
            return null;
         }
         return _pageNames[_selectedIndex];
      }
      
      public function set selectedPage(param1:String) : void
      {
         var _loc2_:int = _pageNames.indexOf(param1);
         if(_loc2_ == -1)
         {
            _loc2_ = 0;
         }
         this.selectedIndex = _loc2_;
      }
      
      public function setSelectedPage(param1:String) : void
      {
         var _loc2_:int = _pageNames.indexOf(param1);
         if(_loc2_ == -1)
         {
            _loc2_ = 0;
         }
         this.setSelectedIndex(_loc2_);
      }
      
      public function get previousPage() : String
      {
         if(_previousIndex == -1)
         {
            return null;
         }
         return _pageNames[_previousIndex];
      }
      
      public function get pageCount() : int
      {
         return _pageIds.length;
      }
      
      public function getPageName(param1:int) : String
      {
         return _pageNames[param1];
      }
      
      public function addPage(param1:String = "") : void
      {
         addPageAt(param1,_pageIds.length);
      }
      
      public function addPageAt(param1:String, param2:int) : void
      {
         _nextPageId = Number(_nextPageId) + 1;
         var _loc3_:String = "_" + Number(_nextPageId);
         if(param2 == _pageIds.length)
         {
            _pageIds.push(_loc3_);
            _pageNames.push(param1);
         }
         else
         {
            _pageIds.splice(param2,0,_loc3_);
            _pageNames.splice(param2,0,param1);
         }
      }
      
      public function removePage(param1:String) : void
      {
         var _loc2_:int = _pageNames.indexOf(param1);
         if(_loc2_ != -1)
         {
            _pageIds.splice(_loc2_,1);
            _pageNames.splice(_loc2_,1);
            if(_selectedIndex >= _pageIds.length)
            {
               this.selectedIndex = _selectedIndex - 1;
            }
            else
            {
               _parent.applyController(this);
            }
         }
      }
      
      public function removePageAt(param1:int) : void
      {
         _pageIds.splice(param1,1);
         _pageNames.splice(param1,1);
         if(_selectedIndex >= _pageIds.length)
         {
            this.selectedIndex = _selectedIndex - 1;
         }
         else
         {
            _parent.applyController(this);
         }
      }
      
      public function clearPages() : void
      {
         _pageIds.length = 0;
         _pageNames.length = 0;
         if(_selectedIndex != -1)
         {
            this.selectedIndex = -1;
         }
         else
         {
            _parent.applyController(this);
         }
      }
      
      public function hasPage(param1:String) : Boolean
      {
         return _pageNames.indexOf(param1) != -1;
      }
      
      public function getPageIndexById(param1:String) : int
      {
         return _pageIds.indexOf(param1);
      }
      
      public function getPageIdByName(param1:String) : String
      {
         var _loc2_:int = _pageNames.indexOf(param1);
         if(_loc2_ != -1)
         {
            return _pageIds[_loc2_];
         }
         return null;
      }
      
      public function getPageNameById(param1:String) : String
      {
         var _loc2_:int = _pageIds.indexOf(param1);
         if(_loc2_ != -1)
         {
            return _pageNames[_loc2_];
         }
         return null;
      }
      
      public function getPageId(param1:int) : String
      {
         return _pageIds[param1];
      }
      
      public function get selectedPageId() : String
      {
         if(_selectedIndex == -1)
         {
            return null;
         }
         return _pageIds[_selectedIndex];
      }
      
      public function set selectedPageId(param1:String) : void
      {
         var _loc2_:int = _pageIds.indexOf(param1);
         this.selectedIndex = _loc2_;
      }
      
      public function set oppositePageId(param1:String) : void
      {
         var _loc2_:int = _pageIds.indexOf(param1);
         if(_loc2_ > 0)
         {
            this.selectedIndex = 0;
         }
         else if(_pageIds.length > 1)
         {
            this.selectedIndex = 1;
         }
      }
      
      public function get previousPageId() : String
      {
         if(_previousIndex == -1)
         {
            return null;
         }
         return _pageIds[_previousIndex];
      }
      
      public function runActions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(_actions)
         {
            _loc1_ = _actions.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _actions[_loc2_].run(this,previousPageId,selectedPageId);
               _loc2_++;
            }
         }
      }
      
      public function setup(param1:XML) : void
      {
         var _loc11_:int = 0;
         var _loc10_:int = 0;
         var _loc5_:* = null;
         var _loc3_:int = 0;
         var _loc8_:* = null;
         var _loc7_:int = 0;
         var _loc6_:* = null;
         _name = param1.@name;
         _autoRadioGroupDepth = param1.@autoRadioGroupDepth == "true";
         var _loc4_:String = param1.@pages;
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc3_ = _loc5_.length;
            _loc11_ = 0;
            while(_loc11_ < _loc3_)
            {
               _pageIds.push(_loc5_[_loc11_]);
               _pageNames.push(_loc5_[_loc11_ + 1]);
               _loc11_ = _loc11_ + 2;
            }
         }
         var _loc2_:XMLList = param1.action;
         if(_loc2_.length() > 0)
         {
            _actions = new Vector.<ControllerAction>();
            var _loc13_:int = 0;
            var _loc12_:* = _loc2_;
            for each(var _loc9_ in _loc2_)
            {
               _loc8_ = ControllerAction.createAction(_loc9_.@type);
               _loc8_.setup(_loc9_);
               _actions.push(_loc8_);
            }
         }
         _loc4_ = param1.@transitions;
         if(_loc4_)
         {
            if(!_actions)
            {
               _actions = new Vector.<ControllerAction>();
            }
            _loc5_ = _loc4_.split(",");
            _loc3_ = _loc5_.length;
            _loc11_ = 0;
            while(_loc11_ < _loc3_)
            {
               _loc4_ = _loc5_[_loc11_];
               if(_loc4_)
               {
                  _loc6_ = new PlayTransitionAction();
                  _loc10_ = _loc4_.indexOf("=");
                  _loc6_.transitionName = _loc4_.substr(_loc10_ + 1);
                  _loc4_ = _loc4_.substring(0,_loc10_);
                  _loc10_ = _loc4_.indexOf("-");
                  _loc7_ = parseInt(_loc4_.substring(_loc10_ + 1));
                  if(_loc7_ < _pageIds.length)
                  {
                     _loc6_.toPage = [_pageIds[_loc7_]];
                  }
                  _loc4_ = _loc4_.substring(0,_loc10_);
                  if(_loc4_ != "*")
                  {
                     _loc7_ = parseInt(_loc4_);
                     if(_loc7_ < _pageIds.length)
                     {
                        _loc6_.fromPage = [_pageIds[_loc7_]];
                     }
                  }
                  _loc6_.stopOnExit = true;
                  _actions.push(_loc6_);
               }
               _loc11_++;
            }
         }
         if(_parent && _pageIds.length > 0)
         {
            _selectedIndex = 0;
         }
         else
         {
            _selectedIndex = -1;
         }
      }
   }
}

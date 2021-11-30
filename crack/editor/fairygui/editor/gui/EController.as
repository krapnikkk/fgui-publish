package fairygui.editor.gui
{
   public class EController
   {
       
      
      public var name:String;
      
      public var autoRadioGroupDepth:Boolean;
      
      public var exported:Boolean;
      
      public var alias:String;
      
      public var homePage:String;
      
      public var parent:EGComponent;
      
      public var changing:Boolean;
      
      private var _selectedIndex:int;
      
      private var _previousIndex:int;
      
      private var _nextPageId:int;
      
      private var _pages:Vector.<EControllerPage>;
      
      private var _actions:Vector.<EControllerAction>;
      
      public function EController()
      {
         super();
         this._pages = new Vector.<EControllerPage>();
         this._actions = new Vector.<EControllerAction>();
         this._selectedIndex = -1;
         this._previousIndex = -1;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex != param1)
         {
            this._previousIndex = this._selectedIndex;
            this._selectedIndex = param1;
            if(this.parent)
            {
               this.changing = true;
               this.parent.applyController(this);
               if(this.parent.editMode == 1 && this.parent.parent == null)
               {
                  this.parent.pkg.project.editorWindow.mainPanel.testPanel.updateControllerSelection(this);
               }
               else if(this.parent.editMode == 3)
               {
                  this.parent.pkg.project.editorWindow.mainPanel.editPanel.updateControllerSelection(this);
               }
               this.changing = false;
            }
         }
      }
      
      public function setSelectedIndex(param1:int) : void
      {
         if(this._selectedIndex != param1)
         {
            this._previousIndex = this._selectedIndex;
            this._selectedIndex = param1;
            if(this.parent)
            {
               this.changing = true;
               this.parent.applyController(this);
               this.changing = false;
            }
         }
      }
      
      public function get previsousIndex() : int
      {
         return this._previousIndex;
      }
      
      public function get selectedPage() : String
      {
         if(this._selectedIndex == -1)
         {
            return null;
         }
         return this._pages[this._selectedIndex].name;
      }
      
      public function set selectedPage(param1:String) : void
      {
         var _loc3_:int = this._pages.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._pages[_loc2_].name == param1)
            {
               this.selectedIndex = _loc2_;
               return;
            }
            _loc2_++;
         }
      }
      
      public function set selectedPageId(param1:String) : void
      {
         var _loc3_:int = this._pages.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._pages[_loc2_].id == param1)
            {
               this.selectedIndex = _loc2_;
               return;
            }
            _loc2_++;
         }
      }
      
      public function set oppositePageId(param1:String) : void
      {
         var _loc3_:int = this._pages.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._pages[_loc2_].id != param1)
            {
               _loc2_++;
               continue;
            }
            break;
         }
         if(_loc2_ > 0)
         {
            this.selectedIndex = 0;
         }
         else if(this._pages.length > 1)
         {
            this.selectedIndex = 1;
         }
      }
      
      public function get previousPage() : String
      {
         if(this._previousIndex == -1)
         {
            return null;
         }
         return this._pages[this._previousIndex].name;
      }
      
      public function get selectedPageId() : String
      {
         if(this._selectedIndex == -1)
         {
            return null;
         }
         return this._pages[this._selectedIndex].id;
      }
      
      public function get previousPageId() : String
      {
         if(this._previousIndex == -1)
         {
            return null;
         }
         return this._pages[this._previousIndex].id;
      }
      
      public function getPages() : Vector.<EControllerPage>
      {
         return this._pages;
      }
      
      public function getPageIds() : Array
      {
         var _loc3_:Array = [];
         var _loc2_:int = this._pages.length;
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_.push(this._pages[_loc1_].id);
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function getPageNames() : Array
      {
         var _loc3_:Array = [];
         var _loc2_:int = this._pages.length;
         var _loc1_:int = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_.push(_loc1_ + ":" + this._pages[_loc1_].name);
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function hasPageId(param1:String) : Boolean
      {
         var _loc3_:int = this._pages.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._pages[_loc2_].id == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function hasPageName(param1:String) : Boolean
      {
         var _loc3_:int = this._pages.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._pages[_loc2_].name == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function getNameById(param1:String, param2:String) : String
      {
         var _loc5_:int = 0;
         var _loc3_:EControllerPage = null;
         var _loc4_:int = this._pages.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this._pages[_loc5_];
            if(_loc3_.id == param1)
            {
               return _loc5_ + (!!_loc3_.name?":" + _loc3_.name:"");
            }
            _loc5_++;
         }
         return param2;
      }
      
      public function getNamesByIds(param1:Array, param2:String) : String
      {
         var _loc6_:int = 0;
         var _loc4_:EControllerPage = null;
         if(param1 == null || param1.length == 0)
         {
            return param2;
         }
         var _loc5_:int = this._pages.length;
         var _loc3_:* = "";
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = this._pages[_loc6_];
            if(param1.indexOf(_loc4_.id) != -1)
            {
               if(_loc3_)
               {
                  _loc3_ = _loc3_ + ",";
               }
               _loc3_ = _loc3_ + ("" + _loc6_);
            }
            _loc6_++;
         }
         if(_loc3_)
         {
            return _loc3_;
         }
         return param2;
      }
      
      public function get pageCount() : int
      {
         return this._pages.length;
      }
      
      public function addPage(param1:String) : EControllerPage
      {
         return this.addPageAt(param1,this._pages.length);
      }
      
      public function addPageAt(param1:String, param2:int) : EControllerPage
      {
         var _loc3_:EControllerPage = new EControllerPage();
         var _loc4_:Number = this._nextPageId;
         this._nextPageId++;
         _loc3_.id = "" + _loc4_;
         _loc3_.name = param1;
         if(param2 == this._pages.length)
         {
            this._pages.push(_loc3_);
         }
         else
         {
            this._pages.splice(param2,0,_loc3_);
         }
         return _loc3_;
      }
      
      public function removePageAt(param1:int) : void
      {
         this._pages.splice(param1,1);
      }
      
      public function swapPage(param1:int, param2:int) : void
      {
         var _loc3_:EControllerPage = this._pages[param1];
         var _loc4_:EControllerPage = this._pages[param2];
         this._pages[param1] = _loc4_;
         this._pages[param2] = _loc3_;
      }
      
      public function getActions() : Vector.<EControllerAction>
      {
         return this._actions;
      }
      
      public function addAction(param1:String) : EControllerAction
      {
         var _loc2_:EControllerAction = new EControllerAction();
         _loc2_.type = param1;
         this._actions.push(_loc2_);
         return _loc2_;
      }
      
      public function removeAction(param1:EControllerAction) : void
      {
         var _loc2_:int = this._actions.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._actions.splice(_loc2_,1);
         }
      }
      
      public function runActions() : void
      {
         var _loc1_:EControllerAction = null;
         if(this._actions.length)
         {
            var _loc3_:int = 0;
            var _loc2_:* = this._actions;
            for each(_loc1_ in this._actions)
            {
               _loc1_.run(this,this.previousPageId,this.selectedPageId);
            }
         }
      }
      
      public function fromXML(param1:XML) : void
      {
         var _loc12_:int = 0;
         var _loc10_:int = 0;
         var _loc9_:XML = null;
         var _loc8_:Array = null;
         var _loc7_:int = 0;
         var _loc5_:EControllerPage = null;
         var _loc6_:EControllerAction = null;
         var _loc4_:int = 0;
         this.name = param1.@name;
         this.alias = param1.@alias;
         this.autoRadioGroupDepth = param1.@autoRadioGroupDepth == "true";
         this.exported = param1.@exported == "true";
         this.homePage = param1.@homePage;
         var _loc11_:int = 0;
         this._pages.length = 0;
         var _loc2_:String = param1.@pages;
         if(_loc2_)
         {
            _loc8_ = _loc2_.split(",");
            _loc7_ = _loc8_.length;
            _loc12_ = 0;
            while(_loc12_ < _loc7_)
            {
               _loc5_ = new EControllerPage();
               _loc5_.id = _loc8_[_loc12_];
               if(_loc5_.id == this.homePage)
               {
                  _loc11_ = this._pages.length;
               }
               _loc10_ = _loc5_.id;
               if(_loc10_ >= this._nextPageId)
               {
                  this._nextPageId = _loc10_ + 1;
               }
               _loc5_.name = _loc8_[_loc12_ + 1];
               this._pages.push(_loc5_);
               _loc12_ = _loc12_ + 2;
            }
         }
         this._actions.length = 0;
         var _loc3_:XMLList = param1.action;
         var _loc14_:int = 0;
         var _loc13_:* = _loc3_;
         for each(_loc9_ in _loc3_)
         {
            _loc6_ = new EControllerAction();
            _loc6_.fromXML(_loc9_);
            this._actions.push(_loc6_);
         }
         _loc2_ = param1.@transitions;
         if(_loc2_)
         {
            _loc8_ = _loc2_.split(",");
            _loc7_ = _loc8_.length;
            _loc12_ = 0;
            while(_loc12_ < _loc7_)
            {
               _loc2_ = _loc8_[_loc12_];
               if(_loc2_)
               {
                  _loc6_ = new EControllerAction();
                  _loc6_.type = "play_transition";
                  _loc10_ = _loc2_.indexOf("=");
                  _loc6_.transitionName = _loc2_.substr(_loc10_ + 1);
                  _loc2_ = _loc2_.substring(0,_loc10_);
                  _loc10_ = _loc2_.indexOf("-");
                  _loc4_ = parseInt(_loc2_.substring(_loc10_ + 1));
                  if(_loc4_ < this._pages.length)
                  {
                     _loc6_.toPage = [this._pages[_loc4_].id];
                  }
                  _loc2_ = _loc2_.substring(0,_loc10_);
                  if(_loc2_ != "*")
                  {
                     _loc4_ = parseInt(_loc2_);
                     if(_loc4_ < this._pages.length)
                     {
                        _loc6_.fromPage = [this._pages[_loc4_].id];
                     }
                  }
                  _loc6_.stopOnExit = true;
                  this._actions.push(_loc6_);
               }
               _loc12_++;
            }
         }
         if(this._pages.length > 0)
         {
            this._selectedIndex = _loc11_;
            this._previousIndex = 0;
         }
         else
         {
            this._selectedIndex = -1;
            this._previousIndex = -1;
         }
      }
      
      public function toXML() : XML
      {
         var _loc1_:XML = null;
         var _loc5_:XML = <controller/>;
         _loc5_.@name = this.name;
         if(this.alias)
         {
            _loc5_.@alias = this.alias;
         }
         if(this.autoRadioGroupDepth)
         {
            _loc5_.@autoRadioGroupDepth = true;
         }
         if(this.exported)
         {
            _loc5_.@exported = true;
         }
         if(this.homePage)
         {
            _loc5_.@homePage = this.homePage;
         }
         var _loc4_:int = this._pages.length;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_.push(this._pages[_loc3_].id,this._pages[_loc3_].name);
            _loc3_++;
         }
         _loc5_.@pages = _loc2_.join(",");
         _loc5_.@selected = this._selectedIndex;
         if(this._actions.length > 0)
         {
            _loc4_ = this._actions.length;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc1_ = this._actions[_loc3_].toXML();
               _loc5_.appendChild(_loc1_);
               _loc3_++;
            }
         }
         return _loc5_;
      }
      
      public function copyFrom(param1:EController) : void
      {
         var _loc2_:int = 0;
         this.name = param1.name;
         this.autoRadioGroupDepth = param1.autoRadioGroupDepth;
         this.exported = param1.exported;
         this.alias = param1.alias;
         this.homePage = param1.homePage;
         this._nextPageId = param1._nextPageId;
         var _loc3_:int = param1._pages.length;
         this._pages.length = _loc3_;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(!this._pages[_loc2_])
            {
               this._pages[_loc2_] = new EControllerPage();
            }
            this._pages[_loc2_].copyFrom(param1._pages[_loc2_]);
            _loc2_++;
         }
         if(_loc3_ > 0)
         {
            if(this._selectedIndex == -1 || this._selectedIndex >= _loc3_)
            {
               this._selectedIndex = 0;
            }
         }
         else
         {
            this._selectedIndex = -1;
         }
         _loc3_ = param1._actions.length;
         this._actions.length = _loc3_;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(!this._actions[_loc2_])
            {
               this._actions[_loc2_] = new EControllerAction();
            }
            this._actions[_loc2_].copyFrom(param1._actions[_loc2_]);
            _loc2_++;
         }
      }
      
      public function reset() : void
      {
         this.name = "";
         this.autoRadioGroupDepth = false;
         this.exported = false;
         this.alias = "";
         this.homePage = "";
         this._nextPageId = 0;
         this._pages.length = 0;
         this._actions.length = 0;
      }
   }
}

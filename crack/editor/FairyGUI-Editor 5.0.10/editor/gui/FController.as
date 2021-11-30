package fairygui.editor.gui
{
   import fairygui.editor.settings.CustomProps;
   import fairygui.event.StateChangeEvent;
   import fairygui.utils.XData;
   import flash.events.EventDispatcher;
   
   public class FController extends EventDispatcher
   {
       
      
      public var name:String;
      
      public var autoRadioGroupDepth:Boolean;
      
      public var exported:Boolean;
      
      public var alias:String;
      
      public var homePageType:String;
      
      public var homePage:String;
      
      public var parent:FComponent;
      
      public var changing:Boolean;
      
      private var _selectedIndex:int;
      
      private var _previousIndex:int;
      
      private var _nextPageId:int;
      
      private var _pages:Vector.<FControllerPage>;
      
      private var _actions:Vector.<FControllerAction>;
      
      public function FController()
      {
         super();
         this._pages = new Vector.<FControllerPage>();
         this._actions = new Vector.<FControllerAction>();
         this._selectedIndex = -1;
         this._previousIndex = -1;
         this.homePageType = "default";
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
               dispatchEvent(new StateChangeEvent(StateChangeEvent.CHANGED));
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
         var _loc2_:int = this._pages.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._pages[_loc3_].name == param1)
            {
               this.selectedIndex = _loc3_;
               return;
            }
            _loc3_++;
         }
      }
      
      public function set selectedPageId(param1:String) : void
      {
         var _loc2_:int = this._pages.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._pages[_loc3_].id == param1)
            {
               this.selectedIndex = _loc3_;
               return;
            }
            _loc3_++;
         }
      }
      
      public function set oppositePageId(param1:String) : void
      {
         var _loc2_:int = this._pages.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._pages[_loc3_].id == param1)
            {
               break;
            }
            _loc3_++;
         }
         if(_loc3_ > 0)
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
      
      public function getPages() : Vector.<FControllerPage>
      {
         return this._pages;
      }
      
      public function getPageIds(param1:Array = null) : Array
      {
         if(!param1)
         {
            param1 = [];
         }
         var _loc2_:int = this._pages.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            param1.push(this._pages[_loc3_].id);
            _loc3_++;
         }
         return param1;
      }
      
      public function getPageNames(param1:Array = null) : Array
      {
         var _loc4_:FControllerPage = null;
         var _loc5_:String = null;
         if(!param1)
         {
            param1 = [];
         }
         var _loc2_:int = this._pages.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._pages[_loc3_];
            if(_loc4_.name)
            {
               _loc5_ = _loc3_ + ":" + _loc4_.name;
            }
            else if(_loc4_.remark)
            {
               _loc5_ = _loc3_ + ":" + _loc4_.remark;
            }
            else
            {
               _loc5_ = "" + _loc3_;
            }
            param1.push(_loc5_);
            _loc3_++;
         }
         return param1;
      }
      
      public function hasPageId(param1:String) : Boolean
      {
         var _loc2_:int = this._pages.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._pages[_loc3_].id == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function hasPageName(param1:String) : Boolean
      {
         var _loc2_:int = this._pages.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._pages[_loc3_].name == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function getNameById(param1:String, param2:String) : String
      {
         var _loc4_:int = 0;
         var _loc5_:FControllerPage = null;
         var _loc3_:int = this._pages.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._pages[_loc4_];
            if(_loc5_.id == param1)
            {
               return _loc4_ + (!!_loc5_.name?":" + _loc5_.name:"");
            }
            _loc4_++;
         }
         return param2;
      }
      
      public function getNamesByIds(param1:Array, param2:String) : String
      {
         var _loc4_:int = 0;
         var _loc6_:FControllerPage = null;
         var _loc7_:FControllerPage = null;
         if(param1 == null || param1.length == 0)
         {
            return param2;
         }
         var _loc3_:int = this._pages.length;
         var _loc5_:* = "";
         var _loc8_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = this._pages[_loc4_];
            if(param1.indexOf(_loc6_.id) != -1)
            {
               if(_loc5_)
               {
                  _loc5_ = _loc5_ + ",";
               }
               _loc5_ = _loc5_ + ("" + _loc4_);
               _loc7_ = _loc6_;
               _loc8_++;
            }
            _loc4_++;
         }
         if(_loc8_ > 0)
         {
            if(_loc8_ == 1 && _loc7_.name)
            {
               return _loc5_ + ":" + _loc7_.name;
            }
            return _loc5_;
         }
         return param2;
      }
      
      public function get pageCount() : int
      {
         return this._pages.length;
      }
      
      public function addPage(param1:String) : FControllerPage
      {
         return this.addPageAt(param1,this._pages.length);
      }
      
      public function addPageAt(param1:String, param2:int) : FControllerPage
      {
         var _loc3_:FControllerPage = new FControllerPage();
         _loc3_.id = "" + this._nextPageId++;
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
      
      public function setPages(param1:Array) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = this._pages.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.indexOf(this._pages[_loc4_].name);
            if(_loc5_ != -1)
            {
               _loc2_[_loc5_] = this._pages[_loc4_];
            }
            _loc4_++;
         }
         this._pages.length = 0;
         _loc3_ = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_])
            {
               this._pages.push(_loc2_[_loc4_]);
            }
            else
            {
               this.addPage(param1[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      public function swapPage(param1:int, param2:int) : void
      {
         var _loc3_:FControllerPage = this._pages[param1];
         var _loc4_:FControllerPage = this._pages[param2];
         this._pages[param1] = _loc4_;
         this._pages[param2] = _loc3_;
      }
      
      public function getActions() : Vector.<FControllerAction>
      {
         return this._actions;
      }
      
      public function addAction(param1:String) : FControllerAction
      {
         var _loc2_:FControllerAction = new FControllerAction();
         _loc2_.type = param1;
         this._actions.push(_loc2_);
         return _loc2_;
      }
      
      public function removeAction(param1:FControllerAction) : void
      {
         var _loc2_:int = this._actions.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._actions.splice(_loc2_,1);
         }
      }
      
      public function swapAction(param1:int, param2:int) : void
      {
         var _loc3_:FControllerAction = this._actions[param1];
         var _loc4_:FControllerAction = this._actions[param2];
         this._actions[param1] = _loc4_;
         this._actions[param2] = _loc3_;
      }
      
      public function runActions() : void
      {
         var _loc1_:FControllerAction = null;
         if(this._actions.length)
         {
            for each(_loc1_ in this._actions)
            {
               _loc1_.run(this,this.previousPageId,this.selectedPageId);
            }
         }
      }
      
      public function read(param1:XData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:XData = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:FControllerPage = null;
         var _loc12_:FControllerAction = null;
         var _loc13_:int = 0;
         this.name = param1.getAttribute("name","");
         this.alias = param1.getAttribute("alias","");
         this.autoRadioGroupDepth = param1.getAttributeBool("autoRadioGroupDepth");
         this.exported = param1.getAttributeBool("exported");
         this.homePageType = param1.getAttribute("homePageType","default");
         this.homePage = param1.getAttribute("homePage","");
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(this.parent && !FObjectFlags.isDocRoot(this.parent._flags) && (this.parent._flags & FObjectFlags.IN_PREVIEW) == 0)
         {
            _loc3_ = this.homePageType == "default"?0:-1;
            if(this.homePageType == "branch")
            {
               _loc2_ = this.parent._pkg.project.activeBranch;
            }
            else if(this.homePageType == "variable")
            {
               _loc2_ = CustomProps(this.parent._pkg.project.getSettings("customProps")).all[this.homePage];
            }
         }
         this._pages.length = 0;
         var _loc6_:String = param1.getAttribute("pages");
         if(_loc6_)
         {
            _loc9_ = _loc6_.split(",");
            _loc10_ = _loc9_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc10_)
            {
               _loc11_ = new FControllerPage();
               _loc11_.id = _loc9_[_loc4_];
               _loc5_ = int(_loc11_.id);
               if(_loc5_ >= this._nextPageId)
               {
                  this._nextPageId = _loc5_ + 1;
               }
               _loc11_.name = _loc9_[_loc4_ + 1];
               if(_loc3_ == -1 && (_loc2_ == null?Boolean(_loc11_.id == this.homePage):Boolean(_loc11_.name == _loc2_)))
               {
                  _loc3_ = this._pages.length;
               }
               this._pages.push(_loc11_);
               _loc4_ = _loc4_ + 2;
            }
         }
         var _loc7_:Vector.<XData> = param1.getChildren();
         this._actions.length = 0;
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_.getName() == "remark")
            {
               _loc4_ = _loc8_.getAttributeInt("page");
               this._pages[_loc4_].remark = _loc8_.getAttribute("value","");
            }
            else if(_loc8_.getName() == "action")
            {
               _loc12_ = new FControllerAction();
               _loc12_.read(_loc8_);
               this._actions.push(_loc12_);
            }
         }
         _loc6_ = param1.getAttribute("transitions");
         if(_loc6_)
         {
            _loc9_ = _loc6_.split(",");
            _loc10_ = _loc9_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc10_)
            {
               _loc6_ = _loc9_[_loc4_];
               if(_loc6_)
               {
                  _loc12_ = new FControllerAction();
                  _loc12_.type = "play_transition";
                  _loc5_ = _loc6_.indexOf("=");
                  _loc12_.transitionName = _loc6_.substr(_loc5_ + 1);
                  _loc6_ = _loc6_.substring(0,_loc5_);
                  _loc5_ = _loc6_.indexOf("-");
                  _loc13_ = parseInt(_loc6_.substring(_loc5_ + 1));
                  if(_loc13_ < this._pages.length)
                  {
                     _loc12_.toPage = [this._pages[_loc13_].id];
                  }
                  _loc6_ = _loc6_.substring(0,_loc5_);
                  if(_loc6_ != "*")
                  {
                     _loc13_ = parseInt(_loc6_);
                     if(_loc13_ < this._pages.length)
                     {
                        _loc12_.fromPage = [this._pages[_loc13_].id];
                     }
                  }
                  _loc12_.stopOnExit = true;
                  this._actions.push(_loc12_);
               }
               _loc4_++;
            }
         }
         if(this._pages.length > 0)
         {
            this._selectedIndex = _loc3_ < 0?0:int(_loc3_);
            this._previousIndex = 0;
         }
         else
         {
            this._selectedIndex = -1;
            this._previousIndex = -1;
         }
      }
      
      public function write() : XData
      {
         var _loc4_:XData = null;
         var _loc6_:FControllerPage = null;
         var _loc1_:XData = XData.create("controller");
         _loc1_.setAttribute("name",this.name);
         if(this.alias)
         {
            _loc1_.setAttribute("alias",this.alias);
         }
         if(this.autoRadioGroupDepth)
         {
            _loc1_.setAttribute("autoRadioGroupDepth",true);
         }
         if(this.exported)
         {
            _loc1_.setAttribute("exported",true);
         }
         if(this.homePageType != "default")
         {
            _loc1_.setAttribute("homePageType",this.homePageType);
         }
         if(this.homePageType == "specific" || this.homePageType == "variable")
         {
            _loc1_.setAttribute("homePage",this.homePage);
         }
         var _loc2_:int = this._pages.length;
         var _loc3_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc6_ = this._pages[_loc5_];
            _loc3_.push(_loc6_.id,_loc6_.name);
            if(_loc6_.remark)
            {
               _loc4_ = XData.create("remark");
               _loc4_.setAttribute("page",_loc5_);
               _loc4_.setAttribute("value",_loc6_.remark);
               _loc1_.appendChild(_loc4_);
            }
            _loc5_++;
         }
         _loc1_.setAttribute("pages",_loc3_.join(","));
         _loc1_.setAttribute("selected",this._selectedIndex);
         if(this._actions.length > 0)
         {
            _loc2_ = this._actions.length;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc4_ = this._actions[_loc5_].write();
               _loc1_.appendChild(_loc4_);
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function reset() : void
      {
         this.name = "";
         this.autoRadioGroupDepth = false;
         this.exported = false;
         this.alias = "";
         this.homePageType = "default";
         this.homePage = "";
         this._nextPageId = 0;
         this._pages.length = 0;
         this._actions.length = 0;
      }
   }
}

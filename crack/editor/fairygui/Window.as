package fairygui
{
   import fairygui.event.DragEvent;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Window extends GComponent
   {
       
      
      private var _contentPane:GComponent;
      
      private var _modalWaitPane:GObject;
      
      private var _closeButton:GObject;
      
      private var _dragArea:GObject;
      
      private var _contentArea:GObject;
      
      private var _frame:GComponent;
      
      private var _modal:Boolean;
      
      private var _uiSources:Vector.<IUISource>;
      
      private var _inited:Boolean;
      
      private var _loading:Boolean;
      
      protected var _requestingCmd:int;
      
      public var bringToFontOnClick:Boolean;
      
      public function Window()
      {
         super();
         this.focusable = true;
         _uiSources = new Vector.<IUISource>();
         bringToFontOnClick = UIConfig.bringWindowToFrontOnClick;
         displayObject.addEventListener("addedToStage",__onShown);
         displayObject.addEventListener("removedFromStage",__onHidden);
         displayObject.addEventListener("mouseDown",__mouseDown,true);
      }
      
      public function addUISource(param1:IUISource) : void
      {
         _uiSources.push(param1);
      }
      
      public function set contentPane(param1:GComponent) : void
      {
         if(_contentPane != param1)
         {
            if(_contentPane != null)
            {
               removeChild(_contentPane);
            }
            _contentPane = param1;
            if(_contentPane != null)
            {
               addChild(_contentPane);
               this.setSize(_contentPane.width,_contentPane.height);
               _contentPane.addRelation(this,24);
               _frame = _contentPane.getChild("frame") as GComponent;
               if(_frame != null)
               {
                  this.closeButton = _frame.getChild("closeButton");
                  this.dragArea = _frame.getChild("dragArea");
                  this.contentArea = _frame.getChild("contentArea");
               }
            }
         }
      }
      
      public function get contentPane() : GComponent
      {
         return _contentPane;
      }
      
      public function get frame() : GComponent
      {
         return _frame;
      }
      
      public function get closeButton() : GObject
      {
         return _closeButton;
      }
      
      public function set closeButton(param1:GObject) : void
      {
         if(_closeButton != null)
         {
            _closeButton.removeClickListener(closeEventHandler);
         }
         _closeButton = param1;
         if(_closeButton != null)
         {
            _closeButton.addClickListener(closeEventHandler);
         }
      }
      
      public function get dragArea() : GObject
      {
         return _dragArea;
      }
      
      public function set dragArea(param1:GObject) : void
      {
         if(_dragArea != param1)
         {
            if(_dragArea != null)
            {
               _dragArea.draggable = false;
               _dragArea.removeEventListener("startDrag",__dragStart);
            }
            _dragArea = param1;
            if(_dragArea != null)
            {
               if(_dragArea is GGraph && GGraph(_dragArea).displayObject == null)
               {
                  _dragArea.asGraph.drawRect(0,0,0,0,0);
               }
               _dragArea.draggable = true;
               _dragArea.addEventListener("startDrag",__dragStart);
            }
         }
      }
      
      public function get contentArea() : GObject
      {
         return _contentArea;
      }
      
      public function set contentArea(param1:GObject) : void
      {
         _contentArea = param1;
      }
      
      public function show() : void
      {
         GRoot.inst.showWindow(this);
      }
      
      public function showOn(param1:GRoot) : void
      {
         param1.showWindow(this);
      }
      
      public function hide() : void
      {
         if(this.isShowing)
         {
            doHideAnimation();
         }
      }
      
      public function hideImmediately() : void
      {
         var _loc1_:GRoot = parent is GRoot?GRoot(parent):null;
         if(!_loc1_)
         {
            _loc1_ = GRoot.inst;
         }
         _loc1_.hideWindowImmediately(this);
      }
      
      public function centerOn(param1:GRoot, param2:Boolean = false) : void
      {
         this.setXY(int((param1.width - this.width) / 2),int((param1.height - this.height) / 2));
         if(param2)
         {
            this.addRelation(param1,3);
            this.addRelation(param1,10);
         }
      }
      
      public function toggleStatus() : void
      {
         if(isTop)
         {
            hide();
         }
         else
         {
            show();
         }
      }
      
      public function get isShowing() : Boolean
      {
         return parent != null;
      }
      
      public function get isTop() : Boolean
      {
         return parent != null && parent.getChildIndex(this) == parent.numChildren - 1;
      }
      
      public function get modal() : Boolean
      {
         return _modal;
      }
      
      public function set modal(param1:Boolean) : void
      {
         _modal = param1;
      }
      
      public function bringToFront() : void
      {
         this.root.bringToFront(this);
      }
      
      public function showModalWait(param1:int = 0) : void
      {
         if(param1 != 0)
         {
            _requestingCmd = param1;
         }
         if(UIConfig.windowModalWaiting)
         {
            if(!_modalWaitPane)
            {
               _modalWaitPane = UIPackage.createObjectFromURL(UIConfig.windowModalWaiting);
            }
            layoutModalWaitPane();
            addChild(_modalWaitPane);
         }
      }
      
      protected function layoutModalWaitPane() : void
      {
         var _loc1_:* = null;
         if(_contentArea != null)
         {
            _loc1_ = _frame.localToGlobal();
            _loc1_ = this.globalToLocal(_loc1_.x,_loc1_.y);
            _modalWaitPane.setXY(_loc1_.x + _contentArea.x,_loc1_.y + _contentArea.y);
            _modalWaitPane.setSize(_contentArea.width,_contentArea.height);
         }
         else
         {
            _modalWaitPane.setSize(this.width,this.height);
         }
      }
      
      public function closeModalWait(param1:int = 0) : Boolean
      {
         if(param1 != 0)
         {
            if(_requestingCmd != param1)
            {
               return false;
            }
         }
         _requestingCmd = 0;
         if(_modalWaitPane && _modalWaitPane.parent != null)
         {
            removeChild(_modalWaitPane);
         }
         return true;
      }
      
      public function get modalWaiting() : Boolean
      {
         return _modalWaitPane && _modalWaitPane.parent != null;
      }
      
      public function init() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:* = null;
         if(_inited || _loading)
         {
            return;
         }
         if(_uiSources.length > 0)
         {
            _loading = false;
            _loc2_ = _uiSources.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = _uiSources[_loc3_];
               if(!_loc1_.loaded)
               {
                  _loc1_.load(__uiLoadComplete);
                  _loading = true;
               }
               _loc3_++;
            }
            if(!_loading)
            {
               _init();
            }
         }
         else
         {
            _init();
         }
      }
      
      protected function onInit() : void
      {
      }
      
      protected function onShown() : void
      {
      }
      
      protected function onHide() : void
      {
      }
      
      protected function doShowAnimation() : void
      {
         onShown();
      }
      
      protected function doHideAnimation() : void
      {
         this.hideImmediately();
      }
      
      private function __uiLoadComplete() : void
      {
         var _loc3_:int = 0;
         var _loc1_:* = null;
         var _loc2_:int = _uiSources.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _uiSources[_loc3_];
            if(!_loc1_.loaded)
            {
               return;
            }
            _loc3_++;
         }
         _loading = false;
         _init();
      }
      
      private function _init() : void
      {
         _inited = true;
         onInit();
         if(this.isShowing)
         {
            doShowAnimation();
         }
      }
      
      override public function dispose() : void
      {
         displayObject.removeEventListener("addedToStage",__onShown);
         displayObject.removeEventListener("removedFromStage",__onHidden);
         if(parent != null)
         {
            this.hideImmediately();
         }
         super.dispose();
      }
      
      protected function closeEventHandler(param1:Event) : void
      {
         hide();
      }
      
      private function __onShown(param1:Event) : void
      {
         if(param1.target == displayObject)
         {
            if(!_inited)
            {
               init();
            }
            else
            {
               doShowAnimation();
            }
         }
      }
      
      private function __onHidden(param1:Event) : void
      {
         if(param1.target == displayObject)
         {
            closeModalWait();
            onHide();
         }
      }
      
      private function __mouseDown(param1:Event) : void
      {
         if(this.isShowing && bringToFontOnClick)
         {
            bringToFront();
         }
      }
      
      private function __dragStart(param1:DragEvent) : void
      {
         param1.preventDefault();
         this.startDrag(param1.touchPointID);
      }
   }
}

package fairygui.editor
{
   import fairygui.Controller;
   import fairygui.GComboBox;
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.ETransition;
   import fairygui.editor.gui.EUIObjectFactory;
   import fairygui.editor.settings.AdaptationSettings;
   import fairygui.utils.GTimers;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class TestPanel
   {
       
      
      public var self:GComponent;
      
      public var controllerPanel:ControllerPanel;
      
      public var transtionListPanel:TransitionListPanel;
      
      public var adaptationPanel:AdaptationPanel;
      
      private var _editorWindow:EditorWindow;
      
      private var _docContainer:GComponent;
      
      private var _bgGraphics:Graphics;
      
      private var _contentHolder:GGraph;
      
      private var _container:Sprite;
      
      private var _content:EGComponent;
      
      private var _c1:Controller;
      
      private var _viewScaleCombo:GComboBox;
      
      private var _packageItem:EPackageItem;
      
      private var _viewScale:Number;
      
      private var _transitionName:String;
      
      private var _canvasWidth:int;
      
      private var _canvasHeight:int;
      
      private var _contentWidth:int;
      
      private var _contentHeight:int;
      
      private var _scaleFactor:Number;
      
      private var _popupObject:EGObject;
      
      private var _justClosedPopup:EGObject;
      
      private var _tipsObject:EGObject;
      
      public function TestPanel(param1:EditorWindow, param2:GComponent)
      {
         super();
         this.self = param2;
         this._editorWindow = param1;
         this._docContainer = this.self.getChild("docContainer").asCom;
         this._docContainer.addSizeChangeCallback(this.__docContainerSizeChanged);
         this._docContainer.displayObject.addEventListener("mouseWheel",this.__mouseWheel,false,1);
         this.controllerPanel = new ControllerPanel(this._editorWindow,this.self.getChild("controllerPanel").asCom,false);
         this.transtionListPanel = new TransitionListPanel(this._editorWindow,this.self.getChild("transitionListPanel").asCom,false);
         this.adaptationPanel = new AdaptationPanel(this._editorWindow,this.self.getChild("adaptationPanel").asCom);
         this._container = new Sprite();
         var _loc3_:GGraph = new GGraph();
         this._docContainer.addChild(_loc3_);
         this._bgGraphics = _loc3_.graphics;
         this._contentHolder = new GGraph();
         this._docContainer.addChild(this._contentHolder);
         this._contentHolder.setNativeObject(this._container);
         this._c1 = this.self.getController("c1");
         this._viewScaleCombo = this.self.getChild("viewScale").asComboBox;
         this._viewScaleCombo.items = ["25%","50%","100%","150%","200%","300%","400%","800%"];
         this._viewScaleCombo.selectedIndex = 2;
         this._viewScaleCombo.visibleItemCount = 20;
         this._viewScaleCombo.addEventListener("stateChanged",this.__viewScaleChanged);
         this.self.getChild("back").addClickListener(this.__back);
         this.self.getChild("play").addClickListener(this.__play);
      }
      
      public function open(param1:EPackageItem, param2:String = null) : void
      {
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:* = param1;
         var _loc6_:* = param2;
         this.self.getChild("n1").asGraph.drawRect(0,0,0,this._editorWindow.mainPanel.bgColor,1);
         this._editorWindow.mainPanel.self.getController("test").selectedIndex = 1;
         this._packageItem = _loc5_;
         var _loc3_:ComDocument = this._editorWindow.activeComDocument;
         try
         {
            if(this._content != null)
            {
               this._container.removeChild(this._content.displayObject);
               this._content.dispose();
               this._content = null;
            }
            this._content = EUIObjectFactory.createObject(_loc5_,1) as EGComponent;
            this._container.addChild(this._content.displayObject);
            if(_loc3_.editingTransition)
            {
               _loc4_ = _loc3_.editingContent.controllers.length;
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  this._content.controllers[_loc7_].selectedIndex = _loc3_.editingContent.controllers[_loc7_].selectedIndex;
                  _loc7_++;
               }
            }
            this._content.updateDisplayList(true);
            this.controllerPanel.update(this._content);
            this.transtionListPanel.update(this._content);
            this.adaptationPanel.update(this._content);
            this._contentWidth = this._content.width;
            this._contentHeight = this._content.height;
            this._viewScale = _loc5_.testPanelScale;
            this._viewScaleCombo.text = (this._viewScale * 100).toFixed(0) + "%";
            this.applyAdaptation();
            this._docContainer.scrollPane.percY = _loc9_;
            this._docContainer.scrollPane.percX = _loc9_;
            if(!this._content.transitions.isEmpty)
            {
               this._content.takeSnapshot();
            }
            this._transitionName = _loc6_;
            if(this._transitionName != null)
            {
               this._c1.selectedIndex = 1;
               this._content.transitions.getItem(this._transitionName).play();
            }
            else
            {
               this._c1.selectedIndex = 0;
            }
            this.playAllTransitions(this._content,true);
            this.self.root.nativeStage.addEventListener("mouseDown",this.__stageMouseDownCapture,true);
            this.self.root.nativeStage.addEventListener("mouseDown",this.__stageMouseDown,false,1);
            GTimers.inst.add(500,0,this.onDocumentUpdate);
            return;
         }
         catch(err:Error)
         {
            _editorWindow.alertError(err);
            return;
         }
      }
      
      private function onDocumentUpdate() : void
      {
         if(this._content)
         {
            this._content.onDocumentUpdate();
         }
      }
      
      private function playAllTransitions(param1:EGComponent, param2:Boolean) : void
      {
         var _loc3_:ETransition = null;
         var _loc4_:EGObject = null;
         if(param2)
         {
            var _loc8_:int = 0;
            var _loc7_:* = param1.transitions.items;
            for each(_loc3_ in param1.transitions.items)
            {
               if(_loc3_.autoPlay)
               {
                  _loc3_.play(null,null,_loc3_.autoPlayRepeat,_loc3_.autoPlayDelay);
               }
            }
         }
         else
         {
            param1.transitions.stopAll();
         }
         var _loc5_:int = param1.numChildren;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = param1.getChildAt(_loc6_);
            if(_loc4_ is EGComponent)
            {
               this.playAllTransitions(EGComponent(_loc4_),param2);
            }
            _loc6_++;
         }
      }
      
      public function close() : void
      {
         if(this._content != null)
         {
            if(this._content.displayObject.parent != null)
            {
               this._container.removeChild(this._content.displayObject);
            }
            this.playAllTransitions(this._content,false);
         }
         this._content = null;
         this._transitionName = null;
         this._popupObject = null;
         this._justClosedPopup = null;
         this._tipsObject = null;
         this.self.root.nativeStage.removeEventListener("mouseDown",this.__stageMouseDownCapture,true);
         this.self.root.nativeStage.removeEventListener("mouseDown",this.__stageMouseDown);
         this._editorWindow.mainPanel.self.getController("test").selectedIndex = 0;
         GTimers.inst.remove(this.onDocumentUpdate);
      }
      
      public function play() : void
      {
         if(this._transitionName != null)
         {
            this._content.readSnapshot();
            this._content.transitions.getItem(this._transitionName).play();
         }
      }
      
      public function playTransition(param1:ETransition) : void
      {
         if(this._transitionName != null)
         {
            this._content.transitions.getItem(this._transitionName).stop();
            this._content.readSnapshot();
         }
         this._transitionName = param1.name;
         this.play();
      }
      
      public function changeViewScale(param1:Boolean, param2:Boolean) : void
      {
         if(param1)
         {
            if(param2)
            {
               this._viewScale = this._viewScale * 2;
            }
            else
            {
               this._viewScale = this._viewScale * 1.25;
            }
            if(this._viewScale > 16)
            {
               this._viewScale = 16;
            }
         }
         else
         {
            if(param2)
            {
               this._viewScale = this._viewScale / 2;
            }
            else
            {
               this._viewScale = this._viewScale / 1.25;
            }
            if(this._viewScale < 0.25)
            {
               this._viewScale = 0.25;
            }
         }
         this._viewScaleCombo.text = (this._viewScale * 100).toFixed(0) + "%";
         this.applyViewScale();
      }
      
      public function changeViewScale2(param1:Number) : void
      {
         this._viewScale = param1;
         this._viewScaleCombo.text = (this._viewScale * 100).toFixed(0) + "%";
         this.applyViewScale();
      }
      
      public function applyAdaptation() : void
      {
         var _loc7_:AdaptationSettings = null;
         var _loc6_:Array = null;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc1_:* = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._content.adaptationTest)
         {
            _loc7_ = this._editorWindow.project.settingsCenter.adaptation;
            _loc6_ = this.adaptationPanel.getScreenSize();
            this._scaleFactor = 1;
            if(_loc7_.scaleMode == "ScaleWithScreenSize")
            {
               _loc4_ = Number(_loc7_.designResolutionX);
               _loc5_ = Number(_loc7_.designResolutionY);
               if(_loc4_ != 0 && _loc5_ != 0)
               {
                  if(!_loc6_[2] && (_loc6_[0] > _loc6_[1] && _loc4_ < _loc5_ || _loc6_[0] < _loc6_[1] && _loc4_ > _loc5_))
                  {
                     _loc1_ = _loc4_;
                     _loc4_ = _loc5_;
                     _loc5_ = _loc1_;
                  }
                  if(_loc7_.screenMathMode == "MatchWidthOrHeight")
                  {
                     _loc2_ = _loc6_[0] / _loc4_;
                     _loc3_ = _loc6_[1] / _loc5_;
                     this._scaleFactor = Math.min(_loc2_,_loc3_);
                  }
                  else if(_loc7_.screenMathMode == "MatchWidth")
                  {
                     this._scaleFactor = _loc6_[0] / _loc4_;
                  }
                  else
                  {
                     this._scaleFactor = _loc6_[1] / _loc5_;
                  }
               }
            }
            this._canvasWidth = Math.ceil(_loc6_[0] / this._scaleFactor);
            this._canvasHeight = Math.ceil(_loc6_[1] / this._scaleFactor);
            this._container.scrollRect = new Rectangle(0,0,this._canvasWidth,this._canvasHeight);
         }
         else
         {
            this._scaleFactor = 1;
            this._canvasWidth = this._contentWidth;
            this._canvasHeight = this._contentHeight;
            this._container.scrollRect = null;
         }
         if(this._content.adaptationTest == "FitSize")
         {
            this._content.setXY(0,0);
            this._content.setSize(this._canvasWidth,this._canvasHeight);
         }
         else if(this._content.adaptationTest == "FitWidthAndSetMiddle")
         {
            this._content.setXY(0,int((this._canvasHeight - this._contentHeight) / 2));
            this._content.setSize(this._canvasWidth,this._contentHeight);
         }
         else if(this._content.adaptationTest == "FitHeightAndSetCenter")
         {
            this._content.setXY(int((this._canvasWidth - this._contentWidth) / 2),0);
            this._content.setSize(this._contentWidth,this._canvasHeight);
         }
         else
         {
            this._content.setXY(0,0);
            this._content.setSize(this._contentWidth,this._contentHeight);
         }
         this.applyViewScale();
      }
      
      private function applyViewScale() : void
      {
         this._packageItem.testPanelScale = this._viewScale;
         this._container.scaleX = this._viewScale * this._scaleFactor;
         this._container.scaleY = this._viewScale * this._scaleFactor;
         var _loc2_:Number = this._docContainer.scrollPane.percX;
         var _loc1_:Number = this._docContainer.scrollPane.percY;
         this.updateCanvasSize();
         this._docContainer.scrollPane.percX = _loc2_;
         this._docContainer.scrollPane.percY = _loc1_;
      }
      
      private function updateCanvasSize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:int = this._canvasWidth * this._container.scaleX;
         var _loc3_:int = this._canvasHeight * this._container.scaleY;
         if(_loc4_ < this._docContainer.viewWidth)
         {
            _loc1_ = (this._docContainer.viewWidth - _loc4_) / 2;
         }
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         if(_loc3_ < this._docContainer.viewHeight)
         {
            _loc2_ = (this._docContainer.viewHeight - _loc3_) / 2;
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         this._contentHolder.x = _loc1_;
         this._contentHolder.y = _loc2_;
         this._contentHolder.setSize(_loc4_,_loc3_);
         this.drawBackground();
      }
      
      private function drawBackground() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:* = NaN;
         var _loc4_:int = this._contentHolder.x;
         var _loc3_:int = this._contentHolder.y;
         if(this._content.bgColorEnabled)
         {
            _loc1_ = this._content.bgColor;
            _loc2_ = 1;
         }
         else
         {
            _loc1_ = 16777215;
            _loc2_ = 0.5;
         }
         this._bgGraphics.clear();
         this._bgGraphics.lineStyle(0,0,0,true);
         this._bgGraphics.beginFill(_loc1_,_loc2_);
         this._bgGraphics.drawRect(_loc4_,_loc3_,this._canvasWidth * this._container.scaleX,this._canvasHeight * this._container.scaleY);
         this._bgGraphics.endFill();
      }
      
      private function __viewScaleChanged(param1:Event) : void
      {
         var _loc2_:Number = parseInt(this._viewScaleCombo.text) / 100;
         if(_loc2_ == this._viewScale)
         {
            return;
         }
         this._viewScale = _loc2_;
         this.applyViewScale();
      }
      
      private function __mouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(param1.ctrlKey)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.delta;
            if(_loc2_ < 0)
            {
               this.changeViewScale(false,false);
            }
            else
            {
               this.changeViewScale(true,false);
            }
         }
      }
      
      private function __docContainerSizeChanged() : void
      {
         if(this._content != null)
         {
            this.updateCanvasSize();
         }
      }
      
      private function __back(param1:Event) : void
      {
         this.close();
      }
      
      private function __play(param1:Event) : void
      {
         this.play();
      }
      
      public function togglePopup(param1:EGObject, param2:EGObject = null, param3:String = null) : void
      {
         if(this._justClosedPopup == param1)
         {
            return;
         }
         this.showPopup(param1,param2,param3);
      }
      
      public function showPopup(param1:EGObject, param2:EGObject = null, param3:String = null) : void
      {
         var _loc10_:Point = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc5_:int = 0;
         if(this._popupObject)
         {
            this.hidePopup();
         }
         this._popupObject = param1;
         if(param2)
         {
            _loc10_ = param2.displayObject.localToGlobal(new Point(0,0));
            _loc10_ = this._container.globalToLocal(_loc10_);
            _loc4_ = param2.width;
            _loc6_ = param2.height;
         }
         else
         {
            _loc10_ = this._container.globalToLocal(new Point(this.self.root.nativeStage.mouseX,this.self.root.nativeStage.mouseY));
         }
         var _loc9_:* = Number(this._contentHolder.width);
         var _loc7_:* = Number(this._contentHolder.height);
         if(param2 == this._content)
         {
            _loc9_ = 2147483647;
            _loc7_ = 2147483647;
         }
         _loc8_ = _loc10_.x;
         if(_loc8_ + param1.width > _loc9_)
         {
            _loc8_ = _loc8_ + _loc4_ - param1.width;
         }
         _loc5_ = _loc10_.y + _loc6_;
         if((param3 == null || param3 == "auto") && _loc5_ + param1.height > _loc7_ || param3 == "up")
         {
            _loc5_ = _loc10_.y - param1.height - 1;
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
               _loc8_ = _loc8_ + _loc4_ / 2;
            }
         }
         param1.x = _loc8_;
         param1.y = _loc5_;
         this._container.addChild(param1.displayObject);
      }
      
      public function hidePopup() : void
      {
         if(this._popupObject != null && this._popupObject.displayObject.parent != null)
         {
            this._container.removeChild(this._popupObject.displayObject);
            this._justClosedPopup = this._popupObject;
         }
         this._popupObject = null;
      }
      
      public function showTooltips(param1:String) : void
      {
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:String = null;
         var _loc3_:EPackageItem = null;
         if(this._content == null)
         {
            return;
         }
         if(this._tipsObject == null)
         {
            _loc2_ = this._content.pkg.project.settingsCenter.common.tipsRes;
            if(!_loc2_)
            {
               return;
            }
            _loc3_ = this._content.pkg.project.getItemByURL(_loc2_);
            if(_loc3_)
            {
               this._tipsObject = EUIObjectFactory.createObject(_loc3_,1);
               if(!this._tipsObject)
               {
                  return;
               }
            }
         }
         this._tipsObject.text = param1;
         _loc6_ = this.self.root.nativeStage.mouseX + 10;
         _loc4_ = this.self.root.nativeStage.mouseY + 20;
         var _loc5_:Point = this._container.globalToLocal(new Point(_loc6_,_loc4_));
         _loc6_ = _loc5_.x;
         _loc4_ = _loc5_.y;
         if(_loc6_ + this._tipsObject.width > this._contentHolder.width)
         {
            _loc6_ = _loc6_ - this._tipsObject.width - 1;
            if(_loc6_ < 0)
            {
               _loc6_ = 10;
            }
         }
         if(_loc4_ + this._tipsObject.height > this._contentHolder.height)
         {
            _loc4_ = _loc4_ - this._tipsObject.height - 1;
            if(_loc6_ - this._tipsObject.width - 1 > 0)
            {
               _loc6_ = _loc6_ - this._tipsObject.width - 1;
            }
            if(_loc4_ < 0)
            {
               _loc4_ = 10;
            }
         }
         this._tipsObject.x = _loc6_;
         this._tipsObject.y = _loc4_;
         this._container.addChild(this._tipsObject.displayObject);
      }
      
      public function hideTooltips() : void
      {
         if(this._tipsObject != null)
         {
            if(this._tipsObject.displayObject.parent)
            {
               this._container.removeChild(this._tipsObject.displayObject);
            }
         }
      }
      
      private function __stageMouseDown(param1:MouseEvent) : void
      {
         if(param1.eventPhase == 2)
         {
            this.__stageMouseDownCapture(param1);
         }
      }
      
      private function __stageMouseDownCapture(param1:MouseEvent) : void
      {
         this._justClosedPopup = null;
         if(this._popupObject == null)
         {
            return;
         }
         if(!this._popupObject.displayObject.hitTestPoint(param1.currentTarget.stage.mouseX,param1.currentTarget.stage.mouseY))
         {
            this.hidePopup();
         }
      }
      
      public function updateControllerSelection(param1:EController) : void
      {
         this.controllerPanel.updateSelection(param1);
      }
   }
}

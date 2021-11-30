package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.PopupMenu;
   import fairygui.editor.dialogs.ExchangeDialog;
   import fairygui.editor.dialogs.PasteOptionDialog;
   import fairygui.editor.dialogs.insert.CreateComDialog;
   import fairygui.editor.extui.DropEvent;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.ActionHistory;
   import fairygui.editor.gui.EController;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGGroup;
   import fairygui.editor.gui.EGImage;
   import fairygui.editor.gui.EGList;
   import fairygui.editor.gui.EGLoader;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EGTextField;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.ETransition;
   import fairygui.editor.gui.ETransitionItem;
   import fairygui.editor.gui.EUIObjectFactory;
   import fairygui.editor.gui.EUISprite;
   import fairygui.editor.gui.RangeEditor;
   import fairygui.editor.gui.gear.EIAnimationGear;
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.handlers.CopyHandler;
   import fairygui.editor.utils.RuntimeErrorUtil;
   import fairygui.editor.utils.Utils;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.utils.GTimers;
   import flash.desktop.Clipboard;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.PNGEncoderOptions;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class ComDocument extends GComponent implements IDocument
   {
      
      private static var _copyInfo:Object;
      
      private static var _copiedObjects:Array;
      
      private static const autoScrollLeft:int = 30;
      
      private static const autoScrollStep:int = 10;
      
      private static const OFFSET:Array = [0,0,0,-1,1,-1,1,0,1,1,0,1,-1,1,-1,0,-1,-1];
       
      
      private var _contentHolder:Sprite;
      
      private var _container:Sprite;
      
      private var _bgGraphics:Graphics;
      
      private var _selContainer:Sprite;
      
      private var _selMC:Sprite;
      
      private var _docItem:EPackageItem;
      
      private var _docContent:EGComponent;
      
      private var _group:EGGroup;
      
      private var _designImage:EGObject;
      
      private var _selections:Vector.<EGObject>;
      
      private var _selStartPosX:Number;
      
      private var _selStartPosY:Number;
      
      private var _popupMenu:PopupMenu;
      
      private var _transitionMenu:PopupMenu;
      
      private var _active:Boolean;
      
      private var _selectingObject:Boolean;
      
      private var _groupBeforeSelect:EGGroup;
      
      private var _emptySelectionBeforeSelect:Boolean;
      
      private var _modified:Boolean;
      
      private var _savedVersion:int;
      
      private var _latestVersion:int;
      
      private var _savedScrollPercX:Number;
      
      private var _savedScrollPercY:Number;
      
      private var _savedEditingTransition:ETransition;
      
      private var _lastTextField:EGTextField;
      
      private var _pastePoint:Point;
      
      private var _menuPos:Point;
      
      private var _bgColorChanged:Boolean;
      
      private var _actionHistory:ActionHistory;
      
      private var _dragStartX:int;
      
      private var _dragStartY:int;
      
      private var _editorWindow:EditorWindow;
      
      private var _editPanel:EditPanel;
      
      private var _error:Boolean;
      
      private var _clickOnRangeEditor:Boolean;
      
      public function ComDocument()
      {
         var _loc1_:GButton = null;
         super();
         this.opaque = true;
         var _loc3_:GGraph = new GGraph();
         addChild(_loc3_);
         this._bgGraphics = _loc3_.graphics;
         this._contentHolder = new Sprite();
         this._contentHolder.mouseEnabled = false;
         var _loc2_:GGraph = new GGraph();
         addChild(_loc2_);
         _loc2_.setNativeObject(this._contentHolder);
         this._container = new Sprite();
         this._container.x = 0;
         this._container.y = 0;
         this._contentHolder.addChild(this._container);
         this._selContainer = new Sprite();
         this._selContainer.x = 0;
         this._selContainer.y = 0;
         this._contentHolder.addChild(this._selContainer);
         this._selMC = new Sprite();
         this._selMC.graphics.lineStyle(0.1);
         this._selMC.graphics.drawRect(0,0,10,10);
         this._selMC.graphics.endFill();
         this._popupMenu = new PopupMenu();
         this._popupMenu.contentPane.width = 210;
         this._popupMenu.addItem(Consts.g.text1,this.__menuCut).name = "cut";
         this._popupMenu.addItem(Consts.g.text2,this.__menuCopy).name = "copy";
         this._popupMenu.addItem(Consts.g.text3,this.__menuPaste).name = "paste";
         this._popupMenu.addItem(Consts.g.text4,this.__menuDelete).name = "delete";
         this._popupMenu.addSeperator();
         this._popupMenu.addItem(Consts.g.text5,this.__menuSelectAll).name = "selectAll";
         this._popupMenu.addItem(Consts.g.text23,this.__menuUnselectAll).name = "unselectAll";
         this._popupMenu.addSeperator();
         _loc1_ = this._popupMenu.addItem(Consts.g.text6,this.__menuMoveTop);
         _loc1_.name = "moveTop";
         if(!ClassEditor.os_mac)
         {
            _loc1_.getChild("shortcut").text = "Ctrl+→";
         }
         _loc1_ = this._popupMenu.addItem(Consts.g.text7,this.__menuMoveUp);
         _loc1_.name = "moveUp";
         if(!ClassEditor.os_mac)
         {
            _loc1_.getChild("shortcut").text = "Ctrl+←";
         }
         _loc1_ = this._popupMenu.addItem(Consts.g.text8,this.__menuMoveDown);
         _loc1_.name = "moveDown";
         if(!ClassEditor.os_mac)
         {
            _loc1_.getChild("shortcut").text = "Ctrl+↓";
         }
         _loc1_ = this._popupMenu.addItem(Consts.g.text9,this.__menuMoveBottom);
         _loc1_.name = "moveBottom";
         if(!ClassEditor.os_mac)
         {
            _loc1_.getChild("shortcut").text = "Ctrl+↑";
         }
         this._popupMenu.addSeperator();
         this._popupMenu.addItem(Consts.g.text10 + "...",this.__menuExchange).name = "exchange";
         _loc1_ = this._popupMenu.addItem(Consts.g.text238,this.__menuCreateCom);
         _loc1_.name = "createCom";
         _loc1_.getChild("shortcut").text = "F8";
         _loc1_ = this._popupMenu.addItem(Consts.g.text325,this.__menuConvertToBitmap);
         _loc1_.name = "convertToBitmap";
         _loc1_ = this._popupMenu.addItem("裁剪边缘空白",this.__menuCutImageFileAlpha);
         _loc1_.name = "menuCutImageFileAlpha";
         _loc1_ = this._popupMenu.addItem("切割成四张小图",this.__menuCutFourBitmap);
         _loc1_.name = "menuCutFourBitma";
         this._popupMenu.addSeperator();
         this._popupMenu.addItem(Consts.g.text11,this.__menuShowInLib).name = "showInLib";
         this._transitionMenu = new PopupMenu();
         this._transitionMenu.addItem(Consts.g.text209,this.__menuTransXY).name = "xy";
         this._transitionMenu.addItem(Consts.g.text210,this.__menuTransSize).name = "size";
         this._transitionMenu.addItem(Consts.g.text211,this.__menuTransAlpha).name = "alpha";
         this._transitionMenu.addItem(Consts.g.text212,this.__menuTransRotation).name = "rotation";
         this._transitionMenu.addItem(Consts.g.text213,this.__menuTransScale).name = "scale";
         this._transitionMenu.addItem(Consts.g.text306,this.__menuTransSkew).name = "skew";
         this._transitionMenu.addItem(Consts.g.text214,this.__menuTransColor).name = "color";
         this._transitionMenu.addItem(Consts.g.text215,this.__menuTransAnimation).name = "animation";
         this._transitionMenu.addItem(Consts.g.text216,this.__menuTransPivot).name = "pivot";
         this._transitionMenu.addItem(Consts.g.text225,this.__menuTransVisible).name = "visible";
         this._transitionMenu.addItem(Consts.g.text223,this.__menuTransTrans).name = "trans";
         this._transitionMenu.addItem(Consts.g.text222,this.__menuTransSound).name = "sound";
         this._transitionMenu.addItem(Consts.g.text224,this.__menuTransShake).name = "shake";
         this._transitionMenu.addItem(Consts.g.text305,this.__menuTransColorFilter).name = "colorFilter";
         this._selections = new Vector.<EGObject>();
         this._actionHistory = new ActionHistory(this);
         this.displayObject.addEventListener("mouseDown",this.__mouseDown);
         this.displayObject.addEventListener("middleMouseDown",this.__midMouseDown);
         this.displayObject.addEventListener("rightClick",this.__rightClick);
         this.addEventListener("__drop",this.__drop);
      }
      
      public function open(param1:EPackageItem) : void
      {
         this._docItem = param1;
         this._modified = false;
         this._docContent = null;
         this._editorWindow = this._docItem.owner.project.editorWindow;
         this._editPanel = this._editorWindow.mainPanel.editPanel;
      }
      
      public function activate() : void
      {
         var newCreate:Boolean = false;
         var func:Function = null;
         if(this._active)
         {
            return;
         }
         this._docItem.touch();
         if(this._docContent && this._latestVersion != this._docItem.version && !this._modified)
         {
            this.release();
         }
         this._active = true;
         if(!this._docContent)
         {
            this._docContent = EUIObjectFactory.createObject(this._docItem,3) as EGComponent;
            if(!this._error)
            {
               this._docContent.statusDispatcher.addListener(2,this.__contentSizeChanged);
               this._docContent.statusDispatcher.addListener(1,this.__contentXYChanged);
               this._container.addChild(this._docContent.displayObject);
               this._docContent.updateDisplayList(true);
               this.updateDesignImage();
               this._group = null;
               newCreate = true;
               this._savedVersion = this._docItem.version;
            }
         }
         else
         {
            this.refresh();
         }
         if(this._error)
         {
            return;
         }
         this._latestVersion = this._docItem.version;
         this._editorWindow.mainPanel.propsPanelList.refresh();
         this._editPanel.updateControllerPanel();
         this._editPanel.updateTransitionListPanel();
         this._editPanel.updateGroupPathList(this._group);
         this._editorWindow.mainPanel.updateToolbox();
         this.setUpdateChildrenPanelFlag();
         if(newCreate)
         {
            this.updateCanvasSize(true);
         }
         else
         {
            this.updateCanvasSize(false);
         }
         this.onViewScaleChanged();
         if(this._bgColorChanged)
         {
            this.drawBackground();
         }
         parent.ensureBoundsCorrect();
         if(newCreate)
         {
            func = function():void
            {
               if(_docContent == null)
               {
                  return;
               }
               var _loc2_:Number = _container.x + _docContent.width * _container.scaleX / 2 - parent.viewWidth / 2;
               var _loc1_:Number = _container.y + _docContent.height * _container.scaleY / 2 - parent.viewHeight / 2;
               if(_loc2_ > _container.x)
               {
                  _loc2_ = _container.x - 10;
               }
               if(_loc1_ > _container.y)
               {
                  _loc1_ = _container.y - 10;
               }
               parent.scrollPane.posX = _loc2_;
               parent.scrollPane.posY = _loc1_;
            };
            func();
            GTimers.inst.add(200,1,func);
         }
         else
         {
            parent.scrollPane.percX = this._savedScrollPercX;
            parent.scrollPane.percY = this._savedScrollPercY;
         }
         parent.addSizeChangeCallback(this.__docContainerSizeChanged);
         if(this._savedEditingTransition != null)
         {
            this.startEditingTransition(this._savedEditingTransition);
         }
         GTimers.inst.add(500,0,this.onDocumentUpdate);
      }
      
      public function deactivate() : void
      {
         if(!this._active)
         {
            return;
         }
         this._active = false;
         if(this._error)
         {
            return;
         }
         this.finishSelectingObject();
         this._savedEditingTransition = this._docContent.editingTransition;
         this.finishEditingTransition();
         this._savedScrollPercX = parent.scrollPane.percX;
         this._savedScrollPercY = parent.scrollPane.percY;
         this.root.nativeStage.removeEventListener("mouseUp",this.__stageMouseUp);
         parent.removeSizeChangeCallback(this.__docContainerSizeChanged);
         GTimers.inst.remove(this.onDocumentUpdate);
      }
      
      public function release() : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc1_:EGObject = null;
         this.deactivate();
         this._selections.length = 0;
         this._container.removeChildren();
         this._container.x = 0;
         this._container.y = 0;
         this._selContainer.x = 0;
         this._selContainer.y = 0;
         this._savedEditingTransition = null;
         if(this._designImage)
         {
            this._designImage.dispose();
            this._designImage = null;
         }
         if(this._docContent)
         {
            _loc3_ = this._docContent.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this._docContent.getChildAt(_loc2_);
               if(_loc1_.rangeEditor)
               {
                  _loc1_.rangeEditor.dispose();
                  _loc1_.rangeEditor = null;
               }
               _loc2_++;
            }
            if(this._modified)
            {
               this._docItem.version = this._savedVersion;
            }
            this._actionHistory.reset();
            this._docContent.dispose();
            this._docContent = null;
         }
      }
      
      public function refresh() : void
      {
         var _loc2_:EGObject = null;
         var _loc1_:RangeEditor = null;
         this._docItem.touch();
         if(!this._modified && this._latestVersion != this._docItem.version && !this._modified)
         {
            this.release();
            this.activate();
            return;
         }
         this._docContent.validateChildren();
         var _loc3_:int = 0;
         while(_loc3_ < this._selections.length)
         {
            _loc2_ = this._selections[_loc3_];
            if(!_loc2_.parent)
            {
               this._selections.splice(_loc3_,1);
               _loc1_ = _loc2_.rangeEditor;
               if(_loc1_)
               {
                  _loc1_.visible = false;
               }
            }
            else
            {
               _loc3_++;
            }
         }
      }
      
      private function onDocumentUpdate() : void
      {
         var _loc1_:Boolean = false;
         if(this._docContent && this._editorWindow.active)
         {
            _loc1_ = this._docContent.namesChanged;
            this._docContent.onDocumentUpdate();
            if(_loc1_)
            {
               this._editorWindow.mainPanel.updateToolbox();
            }
         }
      }
      
      public function get editingTarget() : EPackageItem
      {
         return this._docItem;
      }
      
      public function get editingContent() : EGComponent
      {
         return this._docContent;
      }
      
      public function get editorWindow() : EditorWindow
      {
         return this._editorWindow;
      }
      
      public function get actionHistory() : ActionHistory
      {
         return this._actionHistory;
      }
      
      public function get uid() : String
      {
         return this._docItem.owner.id + this._docItem.id;
      }
      
      public function get isModified() : Boolean
      {
         return this._modified;
      }
      
      public function setModified() : void
      {
         this._modified = true;
         this._latestVersion = this._docItem.version;
         this.updateDocTitle();
      }
      
      public function updateDocTitle() : void
      {
         this._editPanel.updateTab(this.uid,this._docItem.name,Icons.all.component,this._modified);
      }
      
      public function serialize() : XML
      {
         if(this._docContent.editingTransition)
         {
            this._editorWindow.mainPanel.propsPanelList.propsTransitionFrame.lockUpdate = true;
            this._docContent.readSnapshot();
            this._editorWindow.mainPanel.propsPanelList.propsTransitionFrame.lockUpdate = false;
         }
         var _loc1_:XML = this._docContent.serialize();
         if(this._docContent.editingTransition && this._active)
         {
            this.setTimelineUpdateFlag();
         }
         return _loc1_;
      }
      
      public function save() : void
      {
         var _loc1_:EGGroup = null;
         if(!this._modified)
         {
            return;
         }
         if(this._docContent.editingTransition)
         {
            this._editorWindow.mainPanel.propsPanelList.propsTransitionFrame.lockUpdate = true;
            this._docContent.readSnapshot();
            this._editorWindow.mainPanel.propsPanelList.propsTransitionFrame.lockUpdate = false;
         }
         if(this._group)
         {
            _loc1_ = this._group;
            while(_loc1_)
            {
               if(_loc1_.needUpdate)
               {
                  _loc1_.updateImmdediately();
               }
               _loc1_ = _loc1_.groupInst;
            }
         }
         try
         {
            UtilsFile.saveXML(this._docItem.file,this.serialize());
         }
         catch(err:Error)
         {
            _editorWindow.alert("Save failed!\n" + RuntimeErrorUtil.toString(err));
            return;
         }
         if(this._docContent.customExtentionId != "" && this._docContent.customExtentionId != null)
         {
            this._docItem.data.@customExtention = this._docContent.customExtentionId;
         }
         else
         {
            this._docItem.data.@customExtention = "";
         }
         this._docItem.owner.save(true);
         var _loc4_:* = this._docItem.version;
         this._savedVersion = _loc4_;
         this._latestVersion = _loc4_;
         this._modified = false;
         this.updateDocTitle();
         if(this._docContent.editingTransition && this._active)
         {
            this.setTimelineUpdateFlag();
         }
      }
      
      private function updateCanvasSize(param1:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         var _loc9_:Rectangle = this._docContent.getBounds();
         _loc9_.x = _loc9_.x + this._docContent.x;
         _loc9_.y = _loc9_.y + this._docContent.y;
         _loc9_.x = _loc9_.x * this._container.scaleX;
         _loc9_.y = _loc9_.y * this._container.scaleY;
         _loc9_.width = _loc9_.width * this._container.scaleX;
         _loc9_.height = _loc9_.height * this._container.scaleY;
         var _loc7_:int = Math.max(-_loc9_.x + 50,400);
         var _loc8_:Boolean = false;
         if(param1 || _loc7_ > this._container.x)
         {
            this._container.x = _loc7_;
            this._selContainer.x = _loc7_;
            _loc8_ = true;
         }
         else
         {
            _loc7_ = this._container.x;
         }
         var _loc2_:int = Math.max(-_loc9_.y + 50,400);
         if(param1 || _loc2_ > this._container.y)
         {
            this._container.y = _loc2_;
            this._selContainer.y = _loc2_;
            _loc8_ = true;
         }
         else
         {
            _loc2_ = this._container.y;
         }
         if(param1)
         {
            _loc3_ = _loc7_ + Math.max(_loc9_.right + 50,this._docContent.width * this._container.scaleX + 400);
            _loc6_ = _loc2_ + Math.max(_loc9_.bottom + 50,this._docContent.height * this._container.scaleY + 400);
         }
         else
         {
            _loc3_ = Math.max(_loc7_ + Math.max(_loc9_.right + 50,this._docContent.width * this._container.scaleX + 400),this.width - this._contentHolder.x);
            _loc6_ = Math.max(_loc2_ + Math.max(_loc9_.bottom + 50,this._docContent.height * this._container.scaleY + 400),this.height - this._contentHolder.y);
         }
         if(_loc3_ < parent.viewWidth)
         {
            _loc5_ = (parent.viewWidth - _loc3_) / 2;
         }
         else
         {
            _loc5_ = 0;
         }
         if(_loc6_ < parent.viewHeight)
         {
            _loc4_ = (parent.viewHeight - _loc6_) / 2;
         }
         else
         {
            _loc4_ = 0;
         }
         this._contentHolder.x = _loc5_;
         this._contentHolder.y = _loc4_;
         _loc3_ = _loc3_ + _loc5_;
         _loc6_ = _loc6_ + _loc4_;
         if(_loc3_ != this.width || _loc6_ != this.height)
         {
            this.setSize(_loc3_,_loc6_);
            this.drawBackground();
         }
         else if(_loc8_)
         {
            this.drawBackground();
         }
      }
      
      public function drawBackground() : void
      {
         var _loc4_:uint = 0;
         this._bgColorChanged = false;
         this._bgGraphics.clear();
         var _loc8_:int = Math.max(this.width,parent.width);
         var _loc7_:int = Math.max(this.height,parent.height);
         var _loc5_:int = this._contentHolder.x + this._container.x;
         var _loc6_:int = this._contentHolder.y + this._container.y;
         var _loc1_:int = _loc5_ + this._docContent.width * this._container.scaleX - 1;
         var _loc2_:int = _loc6_ + this._docContent.height * this._container.scaleY - 1;
         if(this._docContent.bgColorEnabled)
         {
            _loc4_ = this._docContent.bgColor;
         }
         else
         {
            _loc4_ = this._docItem.owner.project.editorWindow.mainPanel.bgColor2;
         }
         var _loc3_:uint = this._docItem.owner.project.editorWindow.mainPanel.bgColor == 0?16777215:0;
         if(_loc4_ == this._docItem.owner.project.editorWindow.mainPanel.bgColor)
         {
            this._bgGraphics.lineStyle(0,0,0,true,"none");
            this._bgGraphics.beginFill(_loc4_,1);
            this._container.scaleX = 1;
            this._container.scaleY = 1;
            this._bgGraphics.drawRect(_loc5_,_loc6_,this._docContent.width * this._container.scaleX,this._docContent.height * this._container.scaleY);
            this._bgGraphics.endFill();
            this._bgGraphics.lineStyle(1,_loc3_,1,true);
            Utils.drawDashedLine(this._bgGraphics,_loc5_,0,_loc5_,_loc7_,4);
            Utils.drawDashedLine(this._bgGraphics,_loc1_,0,_loc1_,_loc7_,4);
            Utils.drawDashedLine(this._bgGraphics,0,_loc6_,_loc8_,_loc6_,4);
            Utils.drawDashedLine(this._bgGraphics,0,_loc2_,_loc8_,_loc2_,4);
         }
         else
         {
            this._bgGraphics.lineStyle(1,_loc3_,1,true);
            Utils.drawDashedLine(this._bgGraphics,_loc5_,0,_loc5_,_loc7_,4);
            Utils.drawDashedLine(this._bgGraphics,_loc1_,0,_loc1_,_loc7_,4);
            Utils.drawDashedLine(this._bgGraphics,0,_loc6_,_loc8_,_loc6_,4);
            Utils.drawDashedLine(this._bgGraphics,0,_loc2_,_loc8_,_loc2_,4);
            this._bgGraphics.lineStyle(0,0,0,true,"none");
            this._bgGraphics.beginFill(_loc4_,1);
            this._bgGraphics.drawRect(_loc5_,_loc6_,this._docContent.width * this._container.scaleX,this._docContent.height * this._container.scaleY);
            this._bgGraphics.endFill();
         }
      }
      
      public function updateDesignImage() : void
      {
         if(this._designImage != null)
         {
            if(this._docContent.designImage == this._designImage.resourceURL)
            {
               this._designImage.x = this._docContent.designImageOffsetX;
               this._designImage.y = this._docContent.designImageOffsetY;
               this._designImage.alpha = this._docContent.designImageAlpha / 100;
               if(this._docContent.designImageLayer == 0)
               {
                  this._container.addChildAt(this._designImage.displayObject,0);
               }
               else
               {
                  this._container.addChild(this._designImage.displayObject);
               }
               return;
            }
            this._container.removeChild(this._designImage.displayObject);
            this._designImage.dispose();
            this._designImage = null;
         }
         if(!this._docContent.designImage)
         {
            return;
         }
         var _loc1_:EPackageItem = this._docItem.owner.project.getItemByURL(this._docContent.designImage);
         if(_loc1_ != null)
         {
            this._designImage = EUIObjectFactory.createObject(_loc1_);
            this._designImage.name = "designImage";
            this._designImage.touchable = false;
            if(this._docContent.designImageLayer == 0)
            {
               this._container.addChildAt(this._designImage.displayObject,0);
            }
            else
            {
               this._container.addChild(this._designImage.displayObject);
            }
            this._designImage.x = this._docContent.designImageOffsetX;
            this._designImage.y = this._docContent.designImageOffsetY;
            this._designImage.alpha = this._docContent.designImageAlpha / 100;
         }
      }
      
      public function hasClipboardData() : Boolean
      {
         return Clipboard.generalClipboard.hasFormat("fairygui.GObject") && _copiedObjects != null || Clipboard.generalClipboard.hasFormat("air:text") || Clipboard.generalClipboard.hasFormat("air:bitmap");
      }
      
      public function canUndo() : Boolean
      {
         return this._actionHistory.canUndo();
      }
      
      public function canRedo() : Boolean
      {
         return this._actionHistory.canRedo();
      }
      
      public function addSelection(param1:EGObject, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:EGObject = null;
         var _loc5_:Rectangle = null;
         var _loc6_:TimelinePanel = null;
         if(param1 == null || param1.groupInst != this._group)
         {
            return;
         }
         if(!param2)
         {
            this._actionHistory.action_selectionAdd(param1);
         }
         var _loc7_:int = this._selections.indexOf(param1);
         if(_loc7_ != -1)
         {
            _loc4_ = this._selections[this._selections.length - 1];
            this._selections[this._selections.length - 1] = param1;
            this._selections[_loc7_] = _loc4_;
            return;
         }
         this._selections.push(param1);
         this.installRangeEditor(param1,true);
         if(param3)
         {
            _loc5_ = new Rectangle(this._container.x + param1.x * this._container.scaleX,this._container.y + param1.y * this._container.scaleY,param1.width * this._container.scaleX,param1.height * this._container.scaleY);
            parent.scrollPane.scrollToView(_loc5_);
         }
         this.setUpdateFlag();
         this.setChildrenPanelSelection();
         if(this.editingTransition != null)
         {
            _loc6_ = this._editorWindow.mainPanel.editPanel.timelinePanel;
            _loc6_.onSelectObject(param1);
         }
      }
      
      public function hasSelection() : Boolean
      {
         return this._selections.length > 0;
      }
      
      public function inSelection(param1:EGObject) : Boolean
      {
         return this._selections.indexOf(param1) != -1;
      }
      
      public function openAndSetSelection(param1:EGObject) : void
      {
         if(param1.groupInst != this._group)
         {
            this.openGroup(param1.groupInst);
         }
         this.clearSelection();
         this.addSelection(param1,false,true);
      }
      
      public function addSelectionByName(param1:String) : void
      {
         var _loc3_:EGObject = null;
         var _loc4_:int = this._docContent.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._docContent.getChildAt(_loc2_);
            if(_loc3_.name == param1)
            {
               if(_loc3_.groupInst != this._group)
               {
                  this.openGroup(_loc3_.groupInst);
               }
               this.addSelection(_loc3_,false,true);
            }
            _loc2_++;
         }
      }
      
      private function getSelection() : EGObject
      {
         if(this._selections.length == 0)
         {
            return null;
         }
         return this._selections[this._selections.length - 1];
      }
      
      public function getSelections() : Vector.<EGObject>
      {
         return this._selections;
      }
      
      private function getSelectionRect() : Rectangle
      {
         var _loc1_:EGObject = null;
         var _loc5_:Rectangle = new Rectangle();
         var _loc4_:int = this._selections.length;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc5_ = _loc5_.union(new Rectangle(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height));
            _loc3_++;
         }
         return _loc5_;
      }
      
      public function getSelectionIds() : Vector.<String>
      {
         var _loc2_:EGObject = null;
         var _loc4_:Vector.<String> = new Vector.<String>();
         var _loc3_:int = this._selections.length;
         var _loc1_:int = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this._selections[_loc1_];
            _loc4_.push(_loc2_.id);
            _loc1_++;
         }
         return _loc4_;
      }
      
      public function removeSelection(param1:EGObject, param2:Boolean = false) : void
      {
         var _loc3_:int = this._selections.indexOf(param1);
         if(_loc3_ == -1)
         {
            return;
         }
         if(!param2)
         {
            this._actionHistory.action_selectionRemove(param1);
         }
         this._selections.splice(_loc3_,1);
         var _loc4_:RangeEditor = param1.rangeEditor;
         if(_loc4_)
         {
            _loc4_.visible = false;
         }
         this.setUpdateFlag();
         this.setChildrenPanelSelection();
      }
      
      public function clearSelection(param1:Boolean = false) : void
      {
         var _loc5_:EGObject = null;
         var _loc2_:RangeEditor = null;
         var _loc3_:TimelinePanel = null;
         var _loc6_:int = this._selections.length;
         if(_loc6_ == 0)
         {
            return;
         }
         var _loc4_:int = _loc6_ - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = this._selections[_loc4_];
            _loc2_ = _loc5_.rangeEditor;
            if(_loc2_)
            {
               _loc2_.visible = false;
            }
            if(!param1)
            {
               this._actionHistory.action_selectionRemove(_loc5_);
            }
            _loc4_--;
         }
         this._selections.length = 0;
         this.setUpdateFlag();
         this.setChildrenPanelSelection();
         if(this.editingTransition != null)
         {
            _loc3_ = this._editorWindow.mainPanel.editPanel.timelinePanel;
            _loc3_.onSelectObject(null);
         }
      }
      
      private function getSortedSelectionList() : Array
      {
         var _loc5_:EGObject = null;
         var _loc1_:int = 0;
         var _loc2_:EGObject = null;
         var _loc3_:int = 0;
         var _loc7_:int = this._selections.length;
         var _loc6_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < _loc7_)
         {
            _loc5_ = this._selections[_loc4_];
            if(_loc5_ is EGGroup)
            {
               _loc1_ = this._docContent.numChildren;
               _loc3_ = 0;
               while(_loc3_ < _loc1_)
               {
                  _loc2_ = this._docContent.getChildAt(_loc3_);
                  if(_loc2_.inGroup(EGGroup(_loc5_)))
                  {
                     _loc6_.push({
                        "index":_loc3_,
                        "obj":_loc2_
                     });
                  }
                  _loc3_++;
               }
            }
            _loc6_.push({
               "index":this._docContent.getChildIndex(_loc5_),
               "obj":_loc5_
            });
            _loc4_++;
         }
         _loc6_.sortOn("index",16);
         return _loc6_;
      }
      
      private function copySelection() : void
      {
         var _loc7_:Boolean = false;
         var _loc2_:Object = null;
         var _loc5_:EGObject = null;
         var _loc4_:XML = null;
         var _loc3_:int = 0;
         var _loc9_:Rectangle = this.getSelectionRect();
         var _loc8_:Array = this.getSortedSelectionList();
         var _loc6_:int = _loc8_.length;
         if(_loc6_ == 0)
         {
            return;
         }
         _copyInfo = {
            "src":this._docItem,
            "rect":_loc9_
         };
         _copiedObjects = new Array(_loc6_);
         var _loc1_:int = 0;
         while(_loc1_ < _loc6_)
         {
            _loc2_ = _loc8_[_loc1_];
            _loc5_ = _loc2_.obj;
            _loc4_ = _loc5_.toXML();
            _copiedObjects[_loc1_] = _loc4_;
            _loc4_.@xy = _loc5_.x - _loc9_.x + "," + (_loc5_.y - _loc9_.y);
            if(_loc5_.packageItem != null)
            {
               _loc4_.@pkg = _loc5_.pkg.id;
            }
            if(_loc5_.groupInst != null)
            {
               _loc7_ = false;
               _loc3_ = _loc1_ + 1;
               while(_loc3_ < _loc6_)
               {
                  if(_loc8_[_loc3_].obj == _loc5_.groupInst)
                  {
                     _loc7_ = true;
                     break;
                  }
                  _loc3_++;
               }
               if(!_loc7_)
               {
                  delete _loc4_.@group;
               }
            }
            _loc1_++;
         }
         Clipboard.generalClipboard.setData("fairygui.GObject","fairygui.GObject");
      }
      
      public function deleteSelection() : void
      {
         var _loc1_:EGObject = null;
         var _loc2_:RangeEditor = null;
         if(this._selectingObject)
         {
            return;
         }
         var _loc4_:int = this._selections.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc2_ = _loc1_.rangeEditor;
            if(_loc2_)
            {
               _loc2_.visible = false;
            }
            this._actionHistory.action_selectionRemove(_loc1_);
            if(_loc1_ is EGGroup)
            {
               this.deleteGroupContent(EGGroup(_loc1_));
            }
            this.content_removeChild(_loc1_);
            _loc3_++;
         }
         this._selections.length = 0;
         this.setUpdateFlag();
         this.setUpdateChildrenPanelFlag();
      }
      
      public function deleteGroupContent(param1:EGGroup) : void
      {
         var _loc2_:int = 0;
         var _loc3_:EGObject = null;
         var _loc4_:int = this._docContent.numChildren;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._docContent.getChildAt(_loc2_);
            if(_loc3_.inGroup(param1))
            {
               this.content_removeChild(_loc3_);
               _loc4_--;
            }
            else
            {
               _loc2_++;
            }
         }
      }
      
      private function makeSelectionsFixed(param1:Boolean) : void
      {
         var _loc3_:EGObject = null;
         var _loc4_:int = this._selections.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._selections[_loc2_];
            _loc3_.fixedByDoc = param1;
            _loc2_++;
         }
      }
      
      public function moveSelection(param1:Number, param2:Number) : void
      {
         var _loc3_:EGObject = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         this.makeSelectionsFixed(true);
         var _loc6_:int = this._selections.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = this._selections[_loc7_];
            _loc4_ = this.getOutlineLocks(_loc3_);
            _loc5_ = _loc3_.x + param1;
            if(!(_loc4_ & 1))
            {
               _loc3_.setProperty("x",_loc5_);
            }
            _loc5_ = _loc3_.y + param2;
            if(!(_loc4_ & 2))
            {
               _loc3_.setProperty("y",_loc5_);
            }
            _loc7_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function doSelectAll() : void
      {
         var _loc1_:EGObject = null;
         var _loc3_:int = this._docContent.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._docContent.getChildAt(_loc2_);
            if(_loc1_.displayObject.parent && _loc1_.groupInst == this._group && !_loc1_.locked && !_loc1_.hideByEditor)
            {
               this.addSelection(_loc1_);
            }
            _loc2_++;
         }
      }
      
      public function doUnselectAll() : void
      {
         this.clearSelection();
      }
      
      public function doCopy() : void
      {
         this.copySelection();
      }
      
      public function doCut() : void
      {
         this.copySelection();
         this.deleteSelection();
      }
      
      public function doDelete() : void
      {
         this.deleteSelection();
         this.root.nativeStage.focus = null;
      }
      
      public function getMousePos() : Point
      {
         var _loc1_:Point = this._container.globalToLocal(new Point(displayObject.stage.mouseX,displayObject.stage.mouseY));
         _loc1_.x = _loc1_.x - this._docContent.x;
         _loc1_.y = _loc1_.y - this._docContent.y;
         _loc1_.x = int(_loc1_.x);
         _loc1_.y = int(_loc1_.y);
         return _loc1_;
      }
      
      public function getCenterPos() : Point
      {
         var _loc1_:Point = parent.localToGlobal(parent.width / 2,parent.height / 2);
         _loc1_ = this._container.globalToLocal(_loc1_);
         return _loc1_;
      }
      
      public function doPaste(param1:Point = null, param2:Boolean = false) : void
      {
         var _loc7_:BitmapData = null;
         var _loc8_:ByteArray = null;
         var _loc3_:File = null;
         var _loc4_:File = null;
         var _loc6_:String = null;
         var _loc5_:Array = null;
         if(this._selectingObject)
         {
            return;
         }
         if(Clipboard.generalClipboard.hasFormat("fairygui.GObject"))
         {
            if(_copiedObjects == null)
            {
               return;
            }
            this._pastePoint = param1;
            if(this._pastePoint == null)
            {
               if(param2)
               {
                  this._pastePoint = this.getCenterPos();
                  this._pastePoint.x = this._pastePoint.x - _copyInfo.rect.width / 2;
                  this._pastePoint.y = this._pastePoint.y - _copyInfo.rect.height / 2;
               }
               else
               {
                  this._pastePoint = _copyInfo.rect.topLeft;
               }
            }
            this._pastePoint.x = int(this._pastePoint.x);
            this._pastePoint.y = int(this._pastePoint.y);
            this.doPasteStep2();
         }
         else if(Clipboard.generalClipboard.hasFormat("air:bitmap"))
         {
            _loc7_ = Clipboard.generalClipboard.getData("air:bitmap") as BitmapData;
            _loc8_ = _loc7_.encode(_loc7_.rect,new PNGEncoderOptions());
            _loc3_ = new File(this._editorWindow.project.objsPath + "/temp");
            if(!_loc3_.exists)
            {
               _loc3_.createDirectory();
            }
            _loc4_ = _loc3_.resolvePath("Bitmap.png");
            UtilsFile.saveBytes(_loc4_,_loc8_);
            this._editorWindow.mainPanel.importResources([_loc4_],this._docContent.pkg,["/"],{"dropTarget":"document"});
         }
         else if(Clipboard.generalClipboard.hasFormat("air:text"))
         {
            _loc6_ = Clipboard.generalClipboard.getData("air:text") as String;
            if(_loc6_)
            {
               _loc5_ = this.dropObjects(["text"]);
               if(_loc5_ && _loc5_.length)
               {
                  EGTextField(_loc5_[0]).text = _loc6_;
               }
            }
         }
      }
      
      private function doPasteStep2() : void
      {
         var xml:XML = null;
         var displayList:XML = null;
         var cnt:int = 0;
         var i:int = 0;
         var copyHandler:CopyHandler = null;
         var data:Array = null;
         if(!_copyInfo.src.owner.project.opened)
         {
            return;
         }
         if(_copyInfo.src.owner != this._docItem.owner)
         {
            xml = <dummy/>;
            displayList = <displayList/>;
            cnt = _copiedObjects.length;
            i = 0;
            while(i < cnt)
            {
               displayList.appendChild(_copiedObjects[i].copy());
               i = Number(i) + 1;
            }
            xml.appendChild(displayList);
            copyHandler = new CopyHandler();
            copyHandler.copyXML(_copyInfo.src.owner,xml,this._docItem.owner,"/",true);
            if(copyHandler.existsItemCount > 0)
            {
               PasteOptionDialog(this._editorWindow.getDialog(PasteOptionDialog)).open(function(param1:int):void
               {
                  copyHandler.paste(_docItem.owner,param1);
                  doPasteStep3(displayList.elements());
               });
            }
            else
            {
               copyHandler.paste(this._docItem.owner,0);
               this.doPasteStep3(displayList.elements());
            }
         }
         else
         {
            data = _copiedObjects.concat();
            i = 0;
            while(i < cnt)
            {
               data[i] = data[i].copy();
               i = Number(i) + 1;
            }
            this.doPasteStep3(data);
         }
      }
      
      private function doPasteStep3(param1:Object) : void
      {
         var _loc8_:XML = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc13_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc2_:String = null;
         var _loc4_:XMLList = null;
         var _loc3_:XML = null;
         var _loc5_:EGObject = null;
         var _loc9_:Object = {};
         var _loc10_:* = _copyInfo.src == this._docItem;
         var _loc15_:int = 0;
         var _loc14_:* = param1;
         for each(_loc8_ in param1)
         {
            _loc6_ = _loc8_.@id;
            if(!_loc10_ || this._docContent.isIdInUse(_loc6_))
            {
               _loc7_ = this._docContent.getNextId();
               _loc9_[_loc6_] = _loc7_;
               _loc8_.@id = _loc7_;
               _loc2_ = _loc8_.@name;
               if(UtilsStr.startsWith(_loc6_,_loc2_))
               {
                  _loc8_.@name = UtilsStr.getNameFromId(_loc7_);
               }
            }
         }
         var _loc19_:int = 0;
         var _loc18_:* = param1;
         for each(_loc8_ in param1)
         {
            _loc6_ = _loc8_.@group;
            if(_loc6_)
            {
               _loc7_ = _loc9_[_loc6_];
               if(_loc7_)
               {
                  _loc8_.@group = _loc7_;
               }
            }
            else if(this._group)
            {
               _loc8_.@group = this._group.id;
            }
            _loc4_ = _loc8_.relation;
            var _loc17_:int = 0;
            var _loc16_:* = _loc4_;
            for each(_loc3_ in _loc4_)
            {
               _loc7_ = _loc9_[_loc3_.@target];
               if(_loc7_)
               {
                  _loc3_.@target = _loc7_;
               }
            }
         }
         this.clearSelection();
         _loc13_ = [];
         _loc12_ = 0;
         if(this._group)
         {
            _loc11_ = this._docContent.getGroupTopIndex(this._group) + 1;
         }
         else
         {
            _loc11_ = this._docContent.numChildren;
         }
         var _loc21_:int = 0;
         var _loc20_:* = param1;
         for each(_loc8_ in param1)
         {
            _loc5_ = this._docContent.xmlCreateChild(_loc8_);
            _loc5_.underConstruct = true;
            _loc5_.fromXML_beforeAdd(_loc8_);
            _loc5_.x = _loc5_.x + this._pastePoint.x;
            _loc5_.y = _loc5_.y + this._pastePoint.y;
            _loc5_.locked = false;
            _loc11_++;
            this._docContent.addChildAt(_loc5_,_loc11_);
            this._actionHistory.action_childAdd(_loc5_);
            _loc13_.push(_loc5_);
         }
         var _loc23_:int = 0;
         var _loc22_:* = param1;
         for each(_loc8_ in param1)
         {
            _loc12_++;
            _loc5_ = _loc13_[_loc12_];
            _loc5_.relations.fromXML(_loc8_);
            _loc5_.fromXML_afterAdd(_loc8_);
            _loc5_.underConstruct = false;
            if(_loc5_.groupInst)
            {
               _loc5_.groupInst.update();
            }
            this.addSelection(_loc5_);
         }
         this.setUpdateChildrenPanelFlag();
      }
      
      private function installRangeEditor(param1:EGObject, param2:Boolean) : void
      {
         var _loc3_:RangeEditor = param1.rangeEditor;
         if(!_loc3_)
         {
            _loc3_ = new RangeEditor(this,param1);
            this._selContainer.addChild(_loc3_);
            _loc3_.visible = false;
         }
         if(param2)
         {
            _loc3_.visible = true;
         }
      }
      
      private function getObjectOnMouse(param1:MouseEvent) : EGObject
      {
         var _loc2_:EGObject = null;
         var _loc3_:EGGroup = null;
         this._clickOnRangeEditor = false;
         var _loc4_:DisplayObject = DisplayObject(param1.target);
         while(_loc4_ && _loc4_ != this._container)
         {
            if(_loc4_ is RangeEditor)
            {
               this._clickOnRangeEditor = true;
               return RangeEditor(_loc4_).target;
            }
            if(_loc4_ is EUISprite)
            {
               _loc2_ = EUISprite(_loc4_).owner;
               if(_loc2_.editMode == 2 && !_loc2_.locked)
               {
                  _loc3_ = _loc2_.groupInst;
                  if(_loc3_ == this._group)
                  {
                     return _loc2_;
                  }
                  if(_loc3_ != null && _loc3_.groupInst == this._group)
                  {
                     return _loc3_;
                  }
               }
            }
            _loc4_ = _loc4_.parent;
         }
         return null;
      }
      
      private function __mouseDown(param1:MouseEvent) : void
      {
         if(!this._docContent || this._editorWindow.cursorManager.isColorPicking)
         {
            return;
         }
         displayObject.stage.addEventListener("mouseUp",this.__stageMouseUp);
         displayObject.addEventListener("mouseUp",this.__mouseUp);
         if(this._editPanel.editType == 1)
         {
            this._dragStartX = param1.stageX;
            this._dragStartY = param1.stageY;
            displayObject.stage.addEventListener("mouseMove",this.__mouseMove);
            return;
         }
         var _loc2_:EGObject = this.getObjectOnMouse(param1);
         if(_loc2_ && !_loc2_.locked)
         {
            if(!this._clickOnRangeEditor)
            {
               this.installRangeEditor(_loc2_,false);
               _loc2_.rangeEditor.dragMe(param1);
            }
         }
         else
         {
            this._selStartPosX = this._selContainer.mouseX;
            this._selStartPosY = this._selContainer.mouseY;
            displayObject.stage.addEventListener("mouseMove",this.__mouseMove);
         }
      }
      
      private function __midMouseDown(param1:MouseEvent) : void
      {
         if(!this._docContent || this._editorWindow.cursorManager.isColorPicking)
         {
            return;
         }
         displayObject.stage.addEventListener("middleMouseUp",this.__midMouseUp);
         displayObject.stage.addEventListener("mouseMove",this.__mouseMove);
         this._editPanel.editType = 1;
         this.__mouseDown(param1);
      }
      
      private function __midMouseUp(param1:MouseEvent) : void
      {
         param1.currentTarget.removeEventListener("middleMouseUp",this.__midMouseUp);
         param1.currentTarget.removeEventListener("mouseMove",this.__mouseMove);
         this._editPanel.editType = 0;
      }
      
      private function __mouseMove(param1:MouseEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this._editPanel.editType == 1)
         {
            _loc4_ = param1.stageX - this._dragStartX;
            _loc2_ = param1.stageY - this._dragStartY;
            this._dragStartX = param1.stageX;
            this._dragStartY = param1.stageY;
            parent.scrollPane.posX = parent.scrollPane.posX - _loc4_;
            parent.scrollPane.posY = parent.scrollPane.posY - _loc2_;
            return;
         }
         var _loc5_:int = Math.abs(this._selContainer.mouseX - this._selStartPosX);
         var _loc3_:int = Math.abs(this._selContainer.mouseY - this._selStartPosY);
         if(!this._selMC.parent)
         {
            if(_loc5_ < 2 && _loc3_ < 2)
            {
               return;
            }
            this._selContainer.addChild(this._selMC);
         }
         this._selMC.x = Math.min(this._selContainer.mouseX,this._selStartPosX);
         this._selMC.y = Math.min(this._selContainer.mouseY,this._selStartPosY);
         this._selMC.width = _loc5_;
         this._selMC.height = _loc3_;
      }
      
      private function __mouseUp(param1:MouseEvent) : void
      {
         var _loc3_:EGObject = null;
         var _loc2_:int = 0;
         displayObject.removeEventListener("mouseUp",this.__mouseUp);
         if(!this._docContent)
         {
            return;
         }
         if(this._editPanel.editType == 1)
         {
            return;
         }
         if(!this._selMC.parent)
         {
            _loc3_ = this.getObjectOnMouse(param1);
            if(RangeEditor.dragging != null && _loc3_ != RangeEditor.dragging || this._editorWindow.dragManager.dragging)
            {
               return;
            }
            if(!_loc3_)
            {
               if(param1.shiftKey)
               {
                  return;
               }
               this.clearSelection();
               if(param1.clickCount == 2)
               {
                  this.closeGroup();
               }
            }
            else if(!param1.shiftKey)
            {
               _loc2_ = this._selections.indexOf(_loc3_);
               if(_loc2_ == -1)
               {
                  if(!RangeEditor.dragging)
                  {
                     this.clearSelection();
                  }
                  this.addSelection(_loc3_);
               }
               else if(_loc2_ != this._selections.length - 1)
               {
                  this._selections.splice(_loc2_,1);
                  this._selections.push(_loc3_);
                  this.setUpdateFlag();
               }
               if(param1.clickCount == 2)
               {
                  this.openChild(_loc3_);
               }
            }
            else if(this._selections.indexOf(_loc3_) != -1)
            {
               if(_loc3_.rangeEditor == null || !RangeEditor.dragging)
               {
                  this.removeSelection(_loc3_);
               }
            }
            else
            {
               this.addSelection(_loc3_);
            }
         }
      }
      
      public function openChild(param1:EGObject) : void
      {
         if(param1 is EGGroup)
         {
            this.openGroup(EGGroup(param1));
         }
         else if(!this.isSelectingObject && !this._docContent.editingTransition)
         {
            if(param1.packageItem)
            {
               this._editorWindow.mainPanel.openItem(param1.packageItem);
            }
            else if(param1 is EGList)
            {
               if(EGList(param1).defaultItem)
               {
                  this._editorWindow.mainPanel.openItem(param1.pkg.project.getItemByURL(EGList(param1).defaultItem));
               }
            }
         }
      }
      
      private function __stageMouseUp(param1:MouseEvent) : void
      {
         var _loc6_:Point = null;
         var _loc4_:Rectangle = null;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:EGObject = null;
         displayObject.stage.removeEventListener("mouseUp",this.__stageMouseUp);
         displayObject.stage.removeEventListener("mouseMove",this.__mouseMove);
         if(this._editPanel.editType == 1)
         {
            return;
         }
         if(this._selMC.parent)
         {
            this._selMC.parent.removeChild(this._selMC);
            this.clearSelection();
            _loc6_ = new Point(this._selMC.x,this._selMC.y);
            _loc6_ = this._container.localToGlobal(_loc6_);
            _loc6_ = this._docContent.displayObject.globalToLocal(_loc6_);
            _loc4_ = new Rectangle(_loc6_.x,_loc6_.y,this._selMC.width,this._selMC.height);
            _loc5_ = this._docContent.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               _loc3_ = this._docContent.getChildAt(_loc2_);
               if(_loc3_.displayObject.parent && _loc3_.groupInst == this._group && !_loc3_.locked && (_loc4_.containsPoint(new Point(_loc3_.x,_loc3_.y)) || _loc4_.intersects(new Rectangle(_loc3_.x,_loc3_.y,Math.max(_loc3_.width,1),Math.max(_loc3_.height,1)))))
               {
                  this.addSelection(_loc3_);
               }
               _loc2_++;
            }
         }
         this.updateCanvasSize();
      }
      
      private function __rightClick(param1:MouseEvent) : void
      {
         if(!this._docContent || this._selectingObject || this._editorWindow.cursorManager.isColorPicking)
         {
            return;
         }
         this._docItem;
         this.__mouseUp(param1);
         this.showContextMenu();
      }
      
      public function showContextMenu() : void
      {
         var _loc3_:EGObject = null;
         var _loc1_:* = false;
         var _loc2_:Boolean = false;
         var _loc4_:* = this._selections.length == 0;
         this._menuPos = this.getMousePos();
         if(this._docContent.editingTransition == null)
         {
            this._popupMenu.setItemGrayed("copy",_loc4_);
            this._popupMenu.setItemGrayed("cut",_loc4_);
            this._popupMenu.setItemGrayed("paste",!this.hasClipboardData());
            this._popupMenu.setItemGrayed("delete",_loc4_);
            this._popupMenu.setItemGrayed("unselectAll",_loc4_);
            this._popupMenu.setItemGrayed("moveTop",_loc4_);
            this._popupMenu.setItemGrayed("moveBottom",_loc4_);
            this._popupMenu.setItemGrayed("moveUp",_loc4_);
            this._popupMenu.setItemGrayed("moveDown",_loc4_);
            this._popupMenu.setItemGrayed("exchange",_loc4_);
            this._popupMenu.setItemGrayed("showInLib",_loc4_);
            this._popupMenu.setItemGrayed("createCom",_loc4_);
            this._popupMenu.setItemGrayed("convertToBitmap",_loc4_);
            this._popupMenu.show(this.root);
         }
         else
         {
            _loc3_ = !!_loc4_?this._docContent:this._selections[0];
            _loc1_ = _loc3_ is EGGroup;
            _loc2_ = _loc1_ && !EGGroup(_loc3_).advanced;
            this._transitionMenu.setItemGrayed("xy",_loc2_);
            this._transitionMenu.setItemGrayed("size",_loc1_);
            this._transitionMenu.setItemGrayed("alpha",_loc2_);
            this._transitionMenu.setItemGrayed("rotation",_loc1_);
            this._transitionMenu.setItemGrayed("visible",_loc2_);
            this._transitionMenu.setItemGrayed("scale",_loc1_);
            this._transitionMenu.setItemGrayed("skew",_loc1_);
            this._transitionMenu.setItemGrayed("color",!(_loc3_ is EIColorGear));
            this._transitionMenu.setItemGrayed("animation",!(_loc3_ is EIAnimationGear));
            this._transitionMenu.setItemGrayed("pivot",_loc1_);
            this._transitionMenu.setItemGrayed("trans",!(_loc3_ is EGComponent));
            this._transitionMenu.setItemGrayed("sound",_loc1_);
            this._transitionMenu.setItemGrayed("shake",_loc1_);
            this._transitionMenu.setItemGrayed("colorFilter",_loc1_);
            this._transitionMenu.show(this.root);
         }
      }
      
      private function __drop(param1:DropEvent) : void
      {
         if(!(param1.source is LibPanel) && !(param1.source is ComDocument))
         {
            return;
         }
         if(this._docContent.editingTransition != null)
         {
            return;
         }
         this.dropObjects(param1.sourceData,{"dropPos":this.getMousePos()});
      }
      
      public function dropObjects(param1:Object, param2:Object = null) : Array
      {
         var _loc13_:Boolean = false;
         var _loc14_:EGObject = null;
         var _loc7_:Object = null;
         var _loc3_:EPackageItem = null;
         var _loc10_:EGTextField = null;
         if(param2 == null)
         {
            param2 = {};
         }
         var _loc8_:Point = param2.dropPos;
         var _loc9_:int = param2.insertIndex == undefined?-1:int(param2.insertIndex);
         var _loc11_:String = param2.names;
         var _loc12_:String = param2.newId;
         this.clearSelection();
         var _loc15_:int = param1.length;
         if(_loc8_ == null)
         {
            _loc8_ = this.getCenterPos();
            _loc13_ = true;
         }
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc4_:int = 0;
         for(; _loc4_ < _loc15_; _loc4_++)
         {
            _loc7_ = param1[_loc4_];
            if(_loc7_ is EPackageItem)
            {
               _loc3_ = EPackageItem(_loc7_);
               if(_loc3_.type != "folder")
               {
                  if(_loc3_.owner == this._docItem.owner && _loc3_.id == this._docItem.id)
                  {
                     this._editorWindow.alert(Consts.g.text76);
                     return _loc6_;
                  }
                  if(_loc3_.owner != this._docContent.pkg && !_loc3_.exported)
                  {
                     _loc5_.push(_loc3_.name);
                  }
                  else
                  {
                     _loc14_ = EUIObjectFactory.createObject(_loc3_,2);
                     if(_loc14_ != null)
                     {
                        _loc14_.aspectLocked = false;
                        if(_loc15_ == 1)
                        {
                           if(_loc11_ != null)
                           {
                              _loc14_.name = _loc11_;
                           }
                           if(_loc12_ != null)
                           {
                              _loc14_.id = _loc12_;
                           }
                        }
                        if(_loc14_ is EGComponent)
                        {
                           if(EGComponent(_loc14_).initName)
                           {
                              _loc14_.name = EGComponent(_loc14_).initName;
                           }
                        }
                        if(_loc14_ is EGComponent && (_loc14_ as EGComponent).containsComponent(this._docItem))
                        {
                           _loc14_.dispose();
                           this._editorWindow.alert(Consts.g.text76);
                           return _loc6_;
                        }
                        this.content_addChild(_loc14_,!!_loc13_?new Point(_loc8_.x - _loc14_.width / 2,_loc8_.y - _loc14_.height / 2):_loc8_,_loc9_);
                        _loc6_.push(_loc14_);
                     }
                  }
                  continue;
               }
               continue;
            }
            _loc14_ = EUIObjectFactory.createObject2(this._docContent.pkg,String(_loc7_),2);
            if(_loc15_ == 1)
            {
               if(_loc11_ != null)
               {
                  _loc14_.name = _loc11_;
               }
               if(_loc12_ != null)
               {
                  _loc14_.id = _loc12_;
               }
            }
            this.clearSelection();
            if(_loc14_ is EGTextField)
            {
               _loc10_ = EGTextField(_loc14_);
               _loc14_.setSize(40,18);
               _loc10_.initFrom(this._lastTextField);
               this._lastTextField = _loc10_;
            }
            else if(_loc14_ is EGList)
            {
               EGList(_loc14_).overflow = "scroll";
               _loc14_.setSize(200,300);
            }
            else if(_loc14_ is EGLoader)
            {
               _loc14_.setSize(50,50);
            }
            else
            {
               _loc14_.setSize(100,100);
            }
            this.content_addChild(_loc14_,!!_loc13_?new Point(_loc8_.x - _loc14_.width / 2,_loc8_.y - _loc14_.height / 2):_loc8_,_loc9_);
            _loc6_.push(_loc14_);
            if(_loc9_ != -1)
            {
               _loc9_++;
            }
            _loc8_.x = _loc8_.x + 50;
            _loc8_.y = _loc8_.y + 50;
         }
         if(_loc5_.length)
         {
            this._editorWindow.alert(Consts.g.text12 + ":\n" + _loc5_.toString());
         }
         this.requestFocus();
         return _loc6_;
      }
      
      private function content_addChild(param1:EGObject, param2:Point, param3:int) : void
      {
         if(this._selectingObject)
         {
            return;
         }
         if(param2 == null)
         {
            param2 = this.getCenterPos();
         }
         param1.x = param2.x;
         param1.y = param2.y;
         if(param3 == -1)
         {
            if(this._group)
            {
               param3 = this._docContent.getGroupTopIndex(this._group) + 1;
            }
            else
            {
               param3 = this._docContent.numChildren;
            }
         }
         else if(param3 < 0)
         {
            param3 = 0;
         }
         else if(param3 > this._docContent.numChildren)
         {
            param3 = this._docContent.numChildren;
         }
         this._docContent.addChildAt(param1,param3);
         param1.groupId = !!this._group?this._group.id:null;
         this._actionHistory.action_childAdd(param1);
         this.addSelection(param1);
         this.setUpdateChildrenPanelFlag();
      }
      
      public function content_removeChild(param1:EGObject) : void
      {
         var _loc4_:EGObject = null;
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc6_:int = this._docContent.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = this._docContent.getChildAt(_loc5_);
            if(_loc4_.relations.hasTarget(param1))
            {
               _loc2_ = _loc4_.relations.toXML();
               _loc4_.relations.removeTarget(param1);
               _loc3_ = _loc4_.relations.toXML();
               this._actionHistory.action_relationSet(_loc4_,_loc2_,_loc3_);
            }
            _loc5_++;
         }
         if(this._docContent.relations.hasTarget(param1))
         {
            _loc2_ = this._docContent.relations.toXML();
            this._docContent.relations.removeTarget(param1);
            _loc3_ = this._docContent.relations.toXML();
            this._actionHistory.action_relationSet(this._docContent,_loc2_,_loc3_);
         }
         this._actionHistory.action_childDelete(param1);
         this._docContent.removeChild(param1);
         this.setUpdateChildrenPanelFlag();
      }
      
      public function onControllerSwitched(param1:EController) : void
      {
         this.setUpdateFlag();
         this.updateCanvasSize();
         var _loc4_:EGGroup = this._group;
         var _loc2_:int = 0;
         var _loc3_:* = -1;
         while(_loc4_ != null)
         {
            _loc2_++;
            if(!_loc4_.finalVisible)
            {
               _loc3_ = _loc2_;
            }
            _loc4_ = _loc4_.groupInst;
         }
         if(_loc3_ != -1)
         {
            this.closeGroup(_loc3_);
         }
      }
      
      public function sideScrollTest(param1:int, param2:int, param3:Point) : int
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         if(parent.displayObject.mouseX < 30 && param1 < 0)
         {
            _loc4_ = parent.scrollPane.posX;
            parent.scrollPane.posX = parent.scrollPane.posX - 10;
            _loc5_ = _loc4_ - parent.scrollPane.posX;
            if(_loc5_ != 0)
            {
               param3.x = param3.x - _loc5_ / this._container.scaleX;
               _loc6_ = _loc6_ | 1;
            }
         }
         if(parent.displayObject.mouseX > parent.width - 30 - 20 && param1 > 0)
         {
            _loc4_ = parent.scrollPane.posX;
            parent.scrollPane.posX = parent.scrollPane.posX + 10;
            _loc5_ = _loc4_ - parent.scrollPane.posX;
            if(_loc5_ != 0)
            {
               param3.x = param3.x - _loc5_ / this._container.scaleX;
               _loc6_ = _loc6_ | 2;
            }
         }
         if(parent.displayObject.mouseY < 30 && param2 < 0)
         {
            _loc4_ = parent.scrollPane.posY;
            parent.scrollPane.posY = parent.scrollPane.posY - 10;
            _loc5_ = _loc4_ - parent.scrollPane.posY;
            if(_loc5_ != 0)
            {
               param3.y = param3.y - _loc5_ / this._container.scaleX;
               _loc6_ = _loc6_ | 4;
            }
         }
         if(parent.displayObject.mouseY > parent.height - 30 - 20 && param2 > 0)
         {
            _loc4_ = parent.scrollPane.posY;
            parent.scrollPane.posY = parent.scrollPane.posY + 10;
            _loc5_ = _loc4_ - parent.scrollPane.posY;
            param3.y = param3.y - _loc5_ / this._container.scaleX;
            _loc6_ = _loc6_ | 8;
         }
         return _loc6_;
      }
      
      public function syncOutineFromRangeEditor(param1:EGObject, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc8_:Boolean = false;
         var _loc6_:EGObject = null;
         var _loc11_:Number = NaN;
         if(this._selections.indexOf(param1) == -1)
         {
            this.clearSelection();
         }
         var _loc12_:Number = param1.x;
         var _loc15_:Number = param1.y;
         var _loc13_:Number = param1.width;
         var _loc14_:Number = param1.height;
         this.makeSelectionsFixed(true);
         var _loc9_:int = this.getOutlineLocks(param1);
         param2 = !!(_loc9_ & 1)?0:Number(param1.setProperty("x",param1.x + param2) - _loc12_);
         param3 = !!(_loc9_ & 2)?0:Number(param1.setProperty("y",param1.y + param3) - _loc15_);
         if(param4 != 0 || param5 != 0)
         {
            if((_loc9_ & 12) == 0)
            {
               if(param1 is EGTextField && (EGTextField(param1).autoSize != "none" && EGTextField(param1).autoSize != "shrink"))
               {
                  EGTextField(param1).setProperty("autoSize","none");
                  _loc8_ = true;
               }
            }
            param4 = !!(_loc9_ & 4)?0:Number(param1.setProperty("width",param1.width + param4) - _loc13_);
            param5 = !!(_loc9_ & 8)?0:Number(param1.setProperty("height",param1.height + param5) - _loc14_);
         }
         var _loc7_:int = this._selections.length;
         var _loc10_:int = 0;
         while(_loc10_ < _loc7_)
         {
            _loc6_ = this._selections[_loc10_];
            if(_loc6_ != param1)
            {
               _loc9_ = this.getOutlineLocks(_loc6_);
               _loc11_ = _loc6_.x + param2;
               if(!(_loc9_ & 1))
               {
                  _loc6_.setProperty("x",_loc11_);
               }
               _loc11_ = _loc6_.y + param3;
               if(!(_loc9_ & 2))
               {
                  _loc6_.setProperty("y",_loc11_);
               }
               if(param4 != 0 || param5 != 0)
               {
                  if((_loc9_ & 12) == 0)
                  {
                     if(_loc6_ is EGTextField && (EGTextField(_loc6_).autoSize != "none" && EGTextField(_loc6_).autoSize != "shrink"))
                     {
                        EGTextField(_loc6_).setProperty("autoSize","none");
                        _loc8_ = true;
                     }
                  }
                  _loc11_ = _loc6_.width + param4;
                  if(!(_loc9_ & 4))
                  {
                     _loc6_.setProperty("width",_loc11_);
                  }
                  _loc11_ = _loc6_.height + param5;
                  if(!(_loc9_ & 8))
                  {
                     _loc6_.setProperty("height",_loc11_);
                  }
               }
            }
            _loc10_++;
         }
         this.makeSelectionsFixed(false);
         if(_loc8_)
         {
            this.setUpdateFlag();
         }
      }
      
      private function __menuCut(param1:Event) : void
      {
         this.copySelection();
         this.deleteSelection();
      }
      
      private function __menuCopy(param1:Event) : void
      {
         this.copySelection();
      }
      
      private function __menuPaste(param1:Event) : void
      {
         this.doPaste(this._menuPos);
      }
      
      private function __menuDelete(param1:Event) : void
      {
         this.deleteSelection();
      }
      
      private function __menuSelectAll(param1:Event) : void
      {
         this.doSelectAll();
      }
      
      private function __menuUnselectAll(param1:Event) : void
      {
         this.doUnselectAll();
      }
      
      public function moveCrossGroups(param1:EGObject) : void
      {
         var _loc6_:EGObject = null;
         var _loc4_:int = 0;
         if(this._docContent.editingTransition != null)
         {
            return;
         }
         var _loc10_:Array = this.getSortedSelectionList();
         var _loc8_:int = _loc10_.length;
         if(_loc10_.length == 0)
         {
            return;
         }
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            if(_loc10_[_loc9_].obj == param1)
            {
               return;
            }
            _loc9_++;
         }
         var _loc2_:EGObject = _loc10_[_loc8_ - 1].obj;
         var _loc3_:EGGroup = _loc2_.groupInst;
         var _loc7_:int = this._docContent.getChildIndex(_loc2_);
         var _loc5_:* = int(this._docContent.getChildIndex(param1));
         if(_loc7_ > _loc5_ && param1 is EGGroup)
         {
            _loc4_ = this._docContent.numChildren;
            _loc9_ = 0;
            while(_loc9_ < _loc4_)
            {
               if(this._docContent.getChildAt(_loc9_).groupInst == param1)
               {
                  _loc5_ = _loc9_;
                  break;
               }
               _loc9_++;
            }
         }
         this.openGroup(param1.groupInst);
         if(_loc3_ != param1.groupInst)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc6_ = _loc10_[_loc9_].obj;
               if(_loc6_.groupInst == _loc3_)
               {
                  _loc6_.setProperty("groupId",param1.groupId);
               }
               _loc9_++;
            }
         }
         if(_loc7_ < _loc5_)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc6_ = _loc10_[_loc9_].obj;
               this._actionHistory.action_childIndex(_loc6_,_loc5_);
               this._docContent.setChildIndex(_loc6_,_loc5_);
               _loc9_++;
            }
         }
         else
         {
            _loc9_ = _loc8_ - 1;
            while(_loc9_ >= 0)
            {
               _loc6_ = _loc10_[_loc9_].obj;
               this._actionHistory.action_childIndex(_loc6_,_loc5_);
               this._docContent.setChildIndex(_loc6_,_loc5_);
               _loc9_--;
            }
         }
         if(_loc3_ != null)
         {
            _loc3_.update();
         }
         if(param1.groupInst != null)
         {
            param1.groupInst.update();
         }
         this.setUpdateChildrenPanelFlag();
         this.clearSelection();
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            this.addSelection(_loc10_[_loc9_].obj);
            _loc9_++;
         }
      }
      
      private function __menuMoveTop(param1:Event) : void
      {
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         if(this._docContent.editingTransition != null)
         {
            return;
         }
         if(this._group)
         {
            _loc6_ = this._docContent.getGroupTopIndex(this._group);
         }
         else
         {
            _loc6_ = this._docContent.numChildren - 1;
         }
         var _loc4_:Array = this.getSortedSelectionList();
         var _loc5_:int = _loc4_.length;
         if(_loc4_.length == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = _loc4_[_loc2_];
            this._actionHistory.action_childIndex(_loc3_.obj,_loc6_);
            this._docContent.setChildIndex(_loc3_.obj,_loc6_);
            _loc2_++;
         }
         this.setUpdateChildrenPanelFlag();
      }
      
      private function __menuMoveUp(param1:Event) : void
      {
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         if(this._docContent.editingTransition != null)
         {
            return;
         }
         if(this._group)
         {
            _loc6_ = this._docContent.getGroupTopIndex(this._group);
         }
         else
         {
            _loc6_ = this._docContent.numChildren - 1;
         }
         var _loc4_:Array = this.getSortedSelectionList();
         var _loc5_:int = _loc4_.length;
         if(_loc4_.length == 0 || _loc4_[_loc5_ - 1].index == _loc6_)
         {
            return;
         }
         var _loc2_:int = _loc5_ - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = _loc4_[_loc2_];
            this._actionHistory.action_childIndex(_loc3_.obj,_loc3_.index + 1);
            this._docContent.setChildIndex(_loc3_.obj,_loc3_.index + 1);
            _loc2_--;
         }
         this.setUpdateChildrenPanelFlag();
      }
      
      private function __menuMoveDown(param1:Event) : void
      {
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         if(this._docContent.editingTransition != null)
         {
            return;
         }
         if(this._group)
         {
            _loc6_ = this._docContent.getGroupBottomIndex(this._group);
         }
         else
         {
            _loc6_ = 0;
         }
         var _loc4_:Array = this.getSortedSelectionList();
         var _loc5_:int = _loc4_.length;
         if(_loc4_.length == 0 || _loc4_[0].index == _loc6_)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = _loc4_[_loc2_];
            this._actionHistory.action_childIndex(_loc3_.obj,_loc3_.index - 1);
            this._docContent.setChildIndex(_loc3_.obj,_loc3_.index - 1);
            _loc2_++;
         }
         this.setUpdateChildrenPanelFlag();
      }
      
      private function __menuMoveBottom(param1:Event) : void
      {
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         if(this._docContent.editingTransition != null)
         {
            return;
         }
         if(this._group)
         {
            _loc6_ = this._docContent.getGroupBottomIndex(this._group);
         }
         else
         {
            _loc6_ = 0;
         }
         var _loc4_:Array = this.getSortedSelectionList();
         var _loc5_:int = _loc4_.length;
         if(_loc4_.length == 0)
         {
            return;
         }
         var _loc2_:int = _loc5_ - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = _loc4_[_loc2_];
            this._actionHistory.action_childIndex(_loc3_.obj,_loc6_);
            this._docContent.setChildIndex(_loc3_.obj,_loc6_);
            _loc2_--;
         }
         this.setUpdateChildrenPanelFlag();
      }
      
      private function __menuShowInLib(param1:Event) : void
      {
         var _loc2_:EGObject = this.getSelection();
         if(!_loc2_)
         {
            _loc2_ = this._docContent;
         }
         if(_loc2_ && _loc2_.packageItem)
         {
            this._docItem.owner.project.editorWindow.mainPanel.libPanel.highlightItem(_loc2_.packageItem);
         }
      }
      
      private function __menuExchange(param1:Event) : void
      {
         ExchangeDialog(this._docItem.owner.project.editorWindow.getDialog(ExchangeDialog)).open(this.getSelections());
      }
      
      private function __menuCreateCom(param1:Event) : void
      {
         param1 = param1;
         var left:int = 0;
         var top:int = 0;
         var i:int = 0;
         var j:int = 0;
         var insertIndex:int = 0;
         var cxml:XML = null;
         var pns:Vector.<String> = null;
         var newName:String = null;
         var newId:String = null;
         var obj:EGObject = null;
         var cc:EController = null;
         var evt:Event = param1;
         var ssl:Array = this.getSortedSelectionList();
         if(ssl.length == 0)
         {
            return;
         }
         left = 2147483647;
         top = 2147483647;
         var right:int = -2147483648;
         var bottom:int = -2147483648;
         var cnt:int = ssl.length;
         var sels:Vector.<EGObject> = new Vector.<EGObject>();
         i = 0;
         while(i < cnt)
         {
            obj = ssl[i].obj;
            sels.push(obj);
            if(obj.x < left)
            {
               left = obj.x;
            }
            if(obj.y < top)
            {
               top = obj.y;
            }
            if(obj.x + obj.width > right)
            {
               right = obj.x + obj.width;
            }
            if(obj.y + obj.height > bottom)
            {
               bottom = obj.y + obj.height;
            }
            i = Number(i) + 1;
         }
         insertIndex = ssl[0].index;
         var xml:XML = <component/>;
         xml.@size = right - left + "," + (bottom - top);
         var ccCnt:int = this._docContent.controllers.length;
         i = 0;
         while(i < ccCnt)
         {
            cc = this._docContent.controllers[i];
            j = 0;
            while(j < cnt)
            {
               obj = sels[j];
               if(obj.checkGearsController(cc))
               {
                  cxml = cc.toXML();
                  if(cxml)
                  {
                     xml.appendChild(cxml);
                  }
                  break;
               }
               j = Number(j) + 1;
            }
            i = Number(i) + 1;
         }
         var dxml:XML = <displayList/>;
         xml.appendChild(dxml);
         i = 0;
         while(i < cnt)
         {
            obj = sels[i];
            cxml = obj.toXML();
            cxml.@xy = int(obj.x - left) + "," + (int(obj.y - top));
            if(obj.groupInst != null && sels.indexOf(obj.groupInst) == -1)
            {
               delete cxml.@group;
            }
            dxml.appendChild(cxml);
            i = Number(i) + 1;
         }
         newName = ssl[0].obj.name;
         newId = ssl[0].obj.id;
         CreateComDialog(this._editorWindow.getDialog(CreateComDialog)).open(xml,function(param1:EPackageItem):void
         {
            deleteSelection();
            dropObjects([param1],{
               "dropPos":new Point(left,top),
               "insertIndex":insertIndex,
               "newName":newName,
               "newId":newId
            });
         });
      }
      
      private function __menuCutFourBitmap(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:EGObject = null;
         var _loc4_:EGObject = this.getSelection();
         if(!_loc4_)
         {
            _loc4_ = this._docContent;
         }
         if(_loc4_ && _loc4_.packageItem)
         {
            this._docItem.owner.project.editorWindow.mainPanel.libPanel.highlightItem(_loc4_.packageItem);
         }
         if(_loc4_ && _loc4_ is EGImage)
         {
            _loc3_ = _loc4_.packageItem.fileName.substr(0,_loc4_.packageItem.fileName.length - 4);
            this.cutFourImage((_loc4_ as EGImage).bitmap.bitmapData,1,_loc3_);
            this.cutFourImage((_loc4_ as EGImage).bitmap.bitmapData,2,_loc3_);
            this.cutFourImage((_loc4_ as EGImage).bitmap.bitmapData,3,_loc3_);
            this.cutFourImage((_loc4_ as EGImage).bitmap.bitmapData,4,_loc3_);
         }
         else
         {
            _editorWindow.alert("只能对图片进行切割！");
         }
      }
      
      private function cutImageFileAlpha(param1:EPackageItem) : void
      {
         var _loc2_:* = param1;
         var _loc5_:BitmapData = null;
         var _loc3_:ByteArray = null;
         var _loc6_:* = BitmapData(_loc2_.data);
         if(_loc6_ == null || !_loc6_.transparent)
         {
            return;
         }
         var _loc4_:Rectangle = _loc6_.getColorBoundsRect(4278190080,0,false);
         if(!_loc4_.isEmpty() && !_loc4_.equals(_loc6_.rect))
         {
            _loc5_ = new BitmapData(_loc4_.width,_loc4_.height,_loc6_.transparent,0);
            _loc5_.copyPixels(_loc6_,_loc4_,new Point(0,0));
            _loc6_.dispose();
            _loc6_ = _loc5_;
            _loc3_ = _loc6_.encode(_loc6_.rect,new PNGEncoderOptions());
            UtilsFile.saveBytes(_loc2_.file,_loc3_);
            _loc2_.invalidate();
            _editorWindow.mainPanel.editPanel.refreshDocument();
            _editorWindow.mainPanel.previewPanel.refresh(true);
         }
      }
      
      private function __menuCutImageFileAlpha(param1:Event) : void
      {
         var _loc2_:EGObject = null;
         var _loc3_:EGObject = this.getSelection();
         if(!_loc3_)
         {
            _loc3_ = this._docContent;
         }
         if(_loc3_ && _loc3_.packageItem)
         {
            if(_loc3_ && _loc3_ is EGImage)
            {
               this.cutImageFileAlpha(_loc3_.packageItem);
            }
            else
            {
               _editorWindow.alert("只能对图片进行裁剪！");
            }
         }
      }
      
      private function cutFourImage(param1:BitmapData, param2:*, param3:String) : void
      {
         var _loc8_:* = null;
         var _loc10_:Number = Math.floor(param1.width / 2);
         var _loc9_:Number = Math.floor(param1.height / 2);
         var _loc5_:Number = Math.floor(param1.width / 2) + param1.width % 2;
         var _loc7_:Number = Math.floor(param1.height / 2) + param1.height % 2;
         if(param2 == 1)
         {
            _loc8_ = new BitmapData(_loc10_ + 2,_loc9_ + 2,true,0);
            _loc8_.copyPixels(param1,new Rectangle(0,0,_loc10_ + 2,_loc9_ + 2),new Point(0,0),null,null,true);
         }
         else if(param2 == 2)
         {
            _loc8_ = new BitmapData(_loc5_ + 2,_loc9_ + 2,true,0);
            _loc8_.copyPixels(param1,new Rectangle(_loc10_ - 2,0,_loc5_ + 2,_loc9_ + 2),new Point(0,0),null,null,true);
         }
         else if(param2 == 3)
         {
            _loc8_ = new BitmapData(_loc10_ + 2,_loc7_ + 2,true,0);
            _loc8_.copyPixels(param1,new Rectangle(0,_loc7_ - 2,_loc10_ + 2,_loc7_ + 2),new Point(0,0),null,null,true);
         }
         else if(param2 == 4)
         {
            _loc8_ = new BitmapData(_loc5_ + 2,_loc7_ + 2,true,0);
            _loc8_.copyPixels(param1,new Rectangle(_loc10_ - 2,_loc7_ - 2,_loc5_ + 2,_loc7_ + 2),new Point(0,0),null,null,true);
         }
         var _loc11_:File = new File(this._editorWindow.project.objsPath + "/temp");
         if(!_loc11_.exists)
         {
            _loc11_.createDirectory();
         }
         var _loc12_:* = "";
         _loc12_ = param3 + "_" + param2 + ".png";
         var _loc6_:File = _loc11_.resolvePath(_loc12_);
         var _loc4_:ByteArray = _loc8_.encode(_loc8_.rect,new PNGEncoderOptions());
         UtilsFile.saveBytes(_loc6_,_loc4_);
         _loc8_.dispose();
         _loc8_ = null;
         _loc6_.clone();
         _loc8_ = null;
         this._editorWindow.mainPanel.importResources([_loc6_],this._docContent.pkg,["/"]);
      }
      
      private function __menuConvertToBitmap(param1:Event) : void
      {
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc3_:Rectangle = null;
         var _loc5_:EGObject = null;
         var _loc12_:Array = this.getSortedSelectionList();
         if(_loc12_.length == 0)
         {
            return;
         }
         var _loc10_:int = 2147483647;
         var _loc11_:int = 2147483647;
         var _loc15_:int = -2147483648;
         var _loc16_:int = -2147483648;
         var _loc19_:int = _loc12_.length;
         _loc17_ = 0;
         while(_loc17_ < _loc19_)
         {
            _loc5_ = _loc12_[_loc17_].obj;
            if(!(_loc5_ is EGGroup))
            {
               if(_loc3_ == null)
               {
                  _loc3_ = _loc5_.displayObject.getBounds(this._docContent.displayObject);
               }
               else
               {
                  _loc3_ = _loc3_.union(_loc5_.displayObject.getBounds(this._docContent.displayObject));
               }
            }
            _loc17_++;
         }
         var _loc4_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,true,0);
         var _loc7_:Matrix = new Matrix();
         _loc17_ = 0;
         while(_loc17_ < _loc19_)
         {
            _loc5_ = _loc12_[_loc17_].obj;
            if(!(_loc5_ is EGGroup))
            {
               _loc7_.identity();
               _loc7_.translate(_loc5_.x - _loc3_.x,_loc5_.y - _loc3_.y);
               _loc5_.displayObject.drawTo(_loc4_,_loc7_);
            }
            _loc17_++;
         }
         var _loc2_:ByteArray = _loc4_.encode(_loc4_.rect,new PNGEncoderOptions());
         var _loc13_:File = new File(this._editorWindow.project.objsPath + "/temp");
         if(!_loc13_.exists)
         {
            _loc13_.createDirectory();
         }
         var _loc14_:* = _loc12_[0].obj.name;
         if(!_loc14_)
         {
            _loc14_ = "Bitmap.png";
         }
         else
         {
            _loc14_ = _loc14_ + ".png";
         }
         var _loc9_:File = _loc13_.resolvePath(_loc14_);
         UtilsFile.saveBytes(_loc9_,_loc2_);
         var _loc6_:int = _loc12_[0].index;
         this.deleteSelection();
         var _loc21_:String = _loc12_[0].obj.name;
         var _loc8_:String = _loc12_[0].obj.id;
         var _loc20_:Object = {
            "dropTarget":"document",
            "dropPos":_loc3_.topLeft,
            "crop":false,
            "insertIndex":_loc6_,
            "newName":_loc21_,
            "newId":_loc8_
         };
         this._editorWindow.mainPanel.importResources([_loc9_],this._docContent.pkg,["/"],_loc20_);
      }
      
      public function undo() : void
      {
         if(this._selectingObject)
         {
            return;
         }
         if(this._actionHistory.undo())
         {
            this.setUpdateFlag();
            this.setUpdateChildrenPanelFlag();
         }
      }
      
      public function redo() : void
      {
         if(this._selectingObject)
         {
            return;
         }
         if(this._actionHistory.redo())
         {
            this.setUpdateFlag();
            this.setUpdateChildrenPanelFlag();
         }
      }
      
      public function makeGroup() : void
      {
         var _loc3_:int = 0;
         var _loc2_:EGObject = null;
         var _loc6_:int = this._selections.length;
         if(_loc6_ == 0)
         {
            return;
         }
         this.__menuMoveTop(null);
         var _loc5_:Vector.<EGObject> = new Vector.<EGObject>().concat(this._selections);
         this.clearSelection();
         if(this._group)
         {
            _loc3_ = this._docContent.getGroupTopIndex(this._group) + 1;
         }
         else
         {
            _loc3_ = this._docContent.numChildren;
         }
         var _loc4_:EGGroup = EUIObjectFactory.createObject2(this._docContent.pkg,"group",2) as EGGroup;
         this._docContent.addChildAt(_loc4_,_loc3_);
         if(this._group)
         {
            _loc4_.groupId = this._group.id;
         }
         this._actionHistory.action_childAdd(_loc4_);
         var _loc1_:int = 0;
         while(_loc1_ < _loc6_)
         {
            _loc2_ = _loc5_[_loc1_];
            _loc2_.setProperty("groupId",_loc4_.id);
            _loc1_++;
         }
         _loc4_.updateImmdediately();
         this.addSelection(_loc4_);
         this.setUpdateChildrenPanelFlag();
      }
      
      public function ungroup() : void
      {
         var _loc5_:EGObject = this.getSelection();
         if(!(_loc5_ is EGGroup))
         {
            return;
         }
         var _loc4_:EGGroup = EGGroup(_loc5_);
         this.removeSelection(_loc4_);
         var _loc2_:String = _loc4_.groupId;
         var _loc3_:int = this._docContent.numChildren;
         var _loc1_:int = 0;
         while(_loc1_ < _loc3_)
         {
            _loc5_ = this._docContent.getChildAt(_loc1_);
            if(_loc5_.groupId == _loc4_.id)
            {
               _loc5_.setProperty("groupId",_loc2_);
               this.addSelection(_loc5_);
            }
            _loc1_++;
         }
         this.content_removeChild(_loc4_);
      }
      
      public function get openedGroup() : EGGroup
      {
         return this._group;
      }
      
      public function openGroup(param1:EGGroup) : void
      {
         var _loc2_:EGGroup = null;
         if(!param1)
         {
            this.closeGroup(2147483647);
            return;
         }
         if(this._group)
         {
            if(this._group != param1.groupInst)
            {
               _loc2_ = this._group;
               while(_loc2_)
               {
                  _loc2_.opened = false;
                  _loc2_ = _loc2_.groupInst;
               }
            }
         }
         this._group = param1;
         this._group.opened = true;
         this._docContent.updateDisplayList();
         this.clearSelection(true);
         this._editPanel.updateGroupPathList(this._group);
      }
      
      public function closeGroup(param1:int = 1) : void
      {
         var _loc3_:EGGroup = null;
         if(!this._group || param1 < 1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            if(this._group.needUpdate)
            {
               this._group.updateImmdediately();
            }
            this._group.opened = false;
            _loc3_ = this._group;
            this._group = this._group.groupInst;
            if(_loc3_.parent && _loc3_.empty)
            {
               this.content_removeChild(_loc3_);
            }
            if(this._group)
            {
               _loc2_++;
               continue;
            }
            break;
         }
         this.clearSelection(true);
         if(_loc3_.parent && _loc3_.finalVisible)
         {
            this.addSelection(_loc3_,true);
         }
         this._docContent.updateDisplayList();
         this._editPanel.updateGroupPathList(this._group);
      }
      
      public function notifyGroupRemoved(param1:EGGroup) : void
      {
         while(this._group && (this._group == param1 || this._group.inGroup(param1)))
         {
            this.closeGroup();
         }
      }
      
      public function handleKeyDownEvent(param1:KeyboardEvent) : void
      {
         if(!this._docContent)
         {
            return;
         }
         var _loc2_:String = String.fromCharCode(param1.charCode).toLowerCase();
         var _loc3_:* = param1.keyCode;
         if(46 !== _loc3_)
         {
            if(8 !== _loc3_)
            {
               if(119 !== _loc3_)
               {
                  if(param1.ctrlKey && !param1.altKey)
                  {
                     _loc3_ = _loc2_;
                     if("c" !== _loc3_)
                     {
                        if("x" !== _loc3_)
                        {
                           if("v" !== _loc3_)
                           {
                              if("a" !== _loc3_)
                              {
                                 if("z" !== _loc3_)
                                 {
                                    if("y" !== _loc3_)
                                    {
                                       if("g" !== _loc3_)
                                       {
                                          if("d" !== _loc3_)
                                          {
                                             if("k" !== _loc3_)
                                             {
                                                if("i" === _loc3_)
                                                {
                                                   if(this._docContent.editingTransition != null)
                                                   {
                                                      this._editPanel.timelinePanel.insertFrame();
                                                   }
                                                   return;
                                                }
                                             }
                                             else
                                             {
                                                if(this._docContent.editingTransition != null)
                                                {
                                                   this._editPanel.timelinePanel.setKeyFrame();
                                                }
                                                return;
                                             }
                                          }
                                          else if(this._docContent.editingTransition != null)
                                          {
                                             this._editPanel.timelinePanel.removeFrame();
                                          }
                                       }
                                       else if(this._docContent.editingTransition == null)
                                       {
                                          if(param1.shiftKey)
                                          {
                                             this.ungroup();
                                          }
                                          else
                                          {
                                             this.makeGroup();
                                          }
                                       }
                                    }
                                    else
                                    {
                                       this.redo();
                                    }
                                 }
                                 else
                                 {
                                    this.undo();
                                 }
                              }
                              else if(this._docContent.editingTransition == null)
                              {
                                 if(param1.shiftKey)
                                 {
                                    this.doUnselectAll();
                                 }
                                 else
                                 {
                                    this.doSelectAll();
                                 }
                              }
                           }
                           else if(this._docContent.editingTransition == null)
                           {
                              if(param1.shiftKey)
                              {
                                 this.doPaste(null);
                              }
                              else
                              {
                                 this.doPaste(null,true);
                              }
                           }
                        }
                        else if(this._docContent.editingTransition == null)
                        {
                           this.doCut();
                        }
                     }
                     else if(this._docContent.editingTransition == null)
                     {
                        this.doCopy();
                     }
                  }
                  else
                  {
                     _loc3_ = _loc2_;
                     if(" " !== _loc3_)
                     {
                        if("v" === _loc3_)
                        {
                           this._editPanel.editType = 0;
                           return;
                        }
                     }
                     else
                     {
                        this._editPanel.editType = 1;
                        return;
                     }
                  }
                  return;
               }
               if(this._docContent.editingTransition == null)
               {
                  this.__menuCreateCom(null);
               }
               return;
            }
         }
         if(this._docContent.editingTransition == null)
         {
            this.doDelete();
         }
      }
      
      public function handleKeyUpEvent(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 32)
         {
            if(this._editPanel.editType == 1)
            {
               this._editPanel.editType = 0;
            }
            return;
         }
      }
      
      public function handleArrowKey(param1:int, param2:Boolean, param3:Boolean) : void
      {
         if(param2)
         {
            if(param1 == 1)
            {
               this.__menuMoveUp(null);
            }
            else if(param1 == 5)
            {
               this.__menuMoveDown(null);
            }
            else if(param1 == 3)
            {
               this.__menuMoveTop(null);
            }
            else if(param1 == 7)
            {
               this.__menuMoveBottom(null);
            }
         }
         else if(param3)
         {
            this.moveSelection(OFFSET[param1 * 2] * 10,OFFSET[param1 * 2 + 1] * 10);
         }
         else
         {
            this.moveSelection(OFFSET[param1 * 2],OFFSET[param1 * 2 + 1]);
         }
      }
      
      public function setTimelineUpdateFlag() : void
      {
         this._docContent.editingTransition.setCurFrame(this._editPanel.timelinePanel.head);
         GTimers.inst.callLater(this._docItem.owner.project.editorWindow.mainPanel.propsPanelList.refresh);
      }
      
      public function setUpdateFlag() : void
      {
         GTimers.inst.callLater(this._docItem.owner.project.editorWindow.mainPanel.propsPanelList.refresh);
      }
      
      public function setUpdateChildrenPanelFlag() : void
      {
         this._editorWindow.mainPanel.childrenPanel.update(null);
      }
      
      public function setChildrenPanelSelection() : void
      {
         this._editorWindow.mainPanel.childrenPanel.syncSelection();
      }
      
      public function startSelectingObject(param1:EGObject) : void
      {
         if(this._selections.length == 0)
         {
            this._emptySelectionBeforeSelect = true;
         }
         else
         {
            this._emptySelectionBeforeSelect = false;
            this.clearSelection();
         }
         this._selectingObject = true;
         this._actionHistory.enabled = false;
         this._groupBeforeSelect = this._group;
         if(param1)
         {
            if(param1 == this._docContent)
            {
               this.closeGroup(2147483647);
            }
            else
            {
               this.openGroup(param1.groupInst);
               this.addSelection(param1);
            }
         }
         this.setUpdateFlag();
      }
      
      public function finishSelectingObject() : void
      {
         if(!this._selectingObject)
         {
            return;
         }
         this._selectingObject = false;
         this.openGroup(this._groupBeforeSelect);
         this.clearSelection();
         this._actionHistory.enabled = true;
         if(!this._emptySelectionBeforeSelect)
         {
            this._actionHistory.undo();
         }
         this.setUpdateFlag();
      }
      
      public function get isSelectingObject() : Boolean
      {
         return this._selectingObject;
      }
      
      public function startEditingTransition(param1:ETransition) : void
      {
         if(this._docContent.editingTransition != null)
         {
            this.finishEditingTransition();
         }
         this._docContent.editingTransition = param1;
         this._actionHistory.enterTransition(param1);
         this.closeGroup(2147483647);
         this._docContent.takeSnapshot();
         this._docContent.editingTransition.validate();
         this._editPanel.timelinePanel.show(this);
         this._editPanel.updateControllerPanel();
         this._editPanel.updateTransitionListPanel();
         this._editPanel.enterEditingTrans();
         this.setUpdateFlag();
      }
      
      public function finishEditingTransition() : void
      {
         if(this._docContent.editingTransition == null)
         {
            return;
         }
         this._editPanel.timelinePanel.hide(this);
         this._docContent.editingTransition = null;
         this._docContent.readSnapshot();
         this._actionHistory.leaveTransition();
         this._editPanel.updateControllerPanel();
         this._editPanel.updateTransitionListPanel();
         this._editPanel.leaveEditingTrans();
         this.setUpdateFlag();
      }
      
      public function get editingTransition() : ETransition
      {
         return this._docContent.editingTransition;
      }
      
      public function getOutlineLocks(param1:EGObject) : int
      {
         var _loc2_:ETransitionItem = null;
         var _loc3_:* = 0;
         if(param1.relations.widthLocked)
         {
            _loc3_ = _loc3_ | 4;
         }
         if(param1.relations.heightLocked)
         {
            _loc3_ = _loc3_ | 8;
         }
         if(this._docContent.editingTransition)
         {
            _loc2_ = this._docContent.editingTransition.findCurItem(param1.id,"XY");
            if(!_loc2_)
            {
               _loc3_ = _loc3_ | 3;
            }
            else
            {
               if(!_loc2_.value.aEnabled)
               {
                  _loc3_ = _loc3_ | 1;
               }
               if(!_loc2_.value.bEnabled)
               {
                  _loc3_ = _loc3_ | 2;
               }
            }
            _loc2_ = this._docContent.editingTransition.findCurItem(param1.id,"Size");
            if(!_loc2_)
            {
               _loc3_ = _loc3_ | 12;
            }
            else
            {
               if(!_loc2_.value.aEnabled)
               {
                  _loc3_ = _loc3_ | 4;
               }
               if(!_loc2_.value.bEnabled)
               {
                  _loc3_ = _loc3_ | 8;
               }
            }
            return _loc3_;
         }
         return _loc3_;
      }
      
      public function arrangeLeft() : void
      {
         var _loc4_:int = 0;
         var _loc1_:EGObject = null;
         var _loc5_:int = this._selections.length;
         if(_loc5_ == 0)
         {
            return;
         }
         if(_loc5_ == 1)
         {
            _loc1_ = this._selections[0];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 1))
            {
               _loc1_.setProperty("x",0);
            }
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc2_:int = this._selections[0].x;
         var _loc3_:int = 1;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 1))
            {
               _loc1_.setProperty("x",_loc2_);
            }
            _loc3_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function arrangeRight() : void
      {
         var _loc4_:int = 0;
         var _loc1_:EGObject = null;
         var _loc5_:int = this._selections.length;
         if(_loc5_ == 0)
         {
            return;
         }
         if(_loc5_ == 1)
         {
            _loc1_ = this._selections[0];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 1))
            {
               _loc1_.setProperty("x",this._docContent.width - _loc1_.width);
            }
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc2_:int = this._selections[0].x + this._selections[0].width;
         var _loc3_:int = 1;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 1))
            {
               _loc1_.setProperty("x",_loc2_ - _loc1_.width);
            }
            _loc3_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function arrangeCenter() : void
      {
         var _loc4_:int = 0;
         var _loc1_:EGObject = null;
         var _loc5_:int = this._selections.length;
         if(_loc5_ == 0)
         {
            return;
         }
         if(_loc5_ == 1)
         {
            _loc1_ = this._selections[0];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 1))
            {
               _loc1_.setProperty("x",int((this._docContent.width - _loc1_.width) / 2));
            }
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc2_:int = this._selections[0].x + this._selections[0].width / 2;
         var _loc3_:int = 1;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 1))
            {
               _loc1_.setProperty("x",int(_loc2_ - _loc1_.width / 2));
            }
            _loc3_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function arrangeTop() : void
      {
         var _loc4_:int = 0;
         var _loc1_:EGObject = null;
         var _loc5_:int = this._selections.length;
         if(_loc5_ == 0)
         {
            return;
         }
         if(_loc5_ == 1)
         {
            _loc1_ = this._selections[0];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 2))
            {
               _loc1_.setProperty("y",0);
            }
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc2_:int = this._selections[0].y;
         var _loc3_:int = 1;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 2))
            {
               _loc1_.setProperty("y",_loc2_);
            }
            _loc3_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function arrangeBottom() : void
      {
         var _loc4_:int = 0;
         var _loc1_:EGObject = null;
         var _loc5_:int = this._selections.length;
         if(_loc5_ == 0)
         {
            return;
         }
         if(_loc5_ == 1)
         {
            _loc1_ = this._selections[0];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 2))
            {
               _loc1_.setProperty("y",this._docContent.height - _loc1_.height);
            }
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc2_:int = this._selections[0].y + this._selections[0].height;
         var _loc3_:int = 1;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 2))
            {
               _loc1_.setProperty("y",_loc2_ - _loc1_.height);
            }
            _loc3_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function arrangeMiddle() : void
      {
         var _loc4_:int = 0;
         var _loc1_:EGObject = null;
         var _loc5_:int = this._selections.length;
         if(_loc5_ == 0)
         {
            return;
         }
         if(_loc5_ == 1)
         {
            _loc1_ = this._selections[0];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 2))
            {
               _loc1_.setProperty("y",int((this._docContent.height - _loc1_.height) / 2));
            }
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc2_:int = this._selections[0].y + this._selections[0].height / 2;
         var _loc3_:int = 1;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 2))
            {
               _loc1_.setProperty("y",int(_loc2_ - _loc1_.height / 2));
            }
            _loc3_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function arrangeSameWidth() : void
      {
         var _loc4_:int = 0;
         var _loc1_:EGObject = null;
         var _loc5_:int = this._selections.length;
         if(_loc5_ == 0)
         {
            return;
         }
         if(_loc5_ == 1)
         {
            _loc1_ = this._selections[0];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 4))
            {
               _loc1_.setProperty("width",this._docContent.width);
            }
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc2_:int = this._selections[0].width;
         var _loc3_:int = 1;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 4))
            {
               _loc2_ = _loc1_.setProperty("width",_loc2_);
               if(_loc1_.aspectLocked)
               {
                  _loc1_.setProperty("height",int(_loc2_ / _loc1_.aspectRatio));
               }
            }
            _loc3_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function arrangeSameHeight() : void
      {
         var _loc4_:int = 0;
         var _loc1_:EGObject = null;
         var _loc5_:int = this._selections.length;
         if(_loc5_ == 0)
         {
            return;
         }
         if(_loc5_ == 1)
         {
            _loc1_ = this._selections[0];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 8))
            {
               _loc1_.setProperty("height",this._docContent.height);
            }
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc2_:int = this._selections[0].height;
         var _loc3_:int = 1;
         while(_loc3_ < _loc5_)
         {
            _loc1_ = this._selections[_loc3_];
            _loc4_ = this.getOutlineLocks(_loc1_);
            if(!(_loc4_ & 8))
            {
               _loc2_ = _loc1_.setProperty("height",_loc2_);
               if(_loc1_.aspectLocked)
               {
                  _loc1_.setProperty("width",int(_loc2_ * _loc1_.aspectRatio));
               }
            }
            _loc3_++;
         }
         this.makeSelectionsFixed(false);
      }
      
      public function getSelectionHGap() : int
      {
         var _loc5_:int = 0;
         var _loc3_:EGObject = null;
         var _loc4_:Array = null;
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc6_:int = this._selections.length;
         if(_loc6_ > 1)
         {
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc3_ = this._selections[_loc5_];
               _loc4_.push(_loc3_);
               _loc5_++;
            }
            _loc4_.sortOn("y",16);
            _loc1_ = 0;
            _loc5_ = 1;
            while(_loc5_ < _loc6_)
            {
               _loc3_ = _loc4_[_loc5_];
               _loc2_ = _loc3_.y - (_loc4_[_loc5_ - 1].y + _loc4_[_loc5_ - 1].height);
               if(_loc2_ > 0)
               {
                  _loc1_ = _loc2_;
                  break;
               }
               _loc5_++;
            }
            return _loc1_;
         }
         return 0;
      }
      
      public function getSelectionVGap() : int
      {
         var _loc5_:int = 0;
         var _loc3_:EGObject = null;
         var _loc4_:Array = null;
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc6_:int = this._selections.length;
         if(_loc6_ > 1)
         {
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc3_ = this._selections[_loc5_];
               _loc4_.push(_loc3_);
               _loc5_++;
            }
            _loc4_.sortOn("x",16);
            _loc1_ = 0;
            _loc5_ = 1;
            while(_loc5_ < _loc6_)
            {
               _loc3_ = _loc4_[_loc5_];
               _loc2_ = _loc3_.x - (_loc4_[_loc5_ - 1].x + _loc4_[_loc5_ - 1].width);
               if(_loc2_ > 0)
               {
                  _loc1_ = _loc2_;
                  break;
               }
               _loc5_++;
            }
            return _loc1_;
         }
         return 0;
      }
      
      public function getSelectionCols() : int
      {
         var _loc4_:int = 0;
         var _loc2_:EGObject = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         var _loc5_:int = this._selections.length;
         if(_loc5_ > 1)
         {
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc2_ = this._selections[_loc4_];
               _loc3_.push(_loc2_);
               _loc4_++;
            }
            _loc3_.sortOn("y",16);
            _loc4_ = 1;
            while(_loc4_ < _loc5_)
            {
               _loc2_ = _loc3_[_loc4_];
               _loc1_ = _loc2_.y - (_loc3_[_loc4_ - 1].y + _loc3_[_loc4_ - 1].height);
               if(_loc1_ > 0)
               {
                  return _loc4_;
               }
               _loc4_++;
            }
            return _loc4_;
         }
         return 1;
      }
      
      public function doArrangeCustom(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc10_:int = 0;
         var _loc13_:int = 0;
         var _loc11_:EGObject = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:int = this._selections.length;
         if(_loc9_ <= 1)
         {
            return;
         }
         this.makeSelectionsFixed(true);
         var _loc12_:Array = [];
         if(param1 == 0)
         {
            _loc13_ = 0;
            while(_loc13_ < _loc9_)
            {
               _loc11_ = this._selections[_loc13_];
               _loc12_.push(_loc11_);
               _loc13_++;
            }
            _loc12_.sortOn("y",16);
            _loc13_ = 1;
            while(_loc13_ < _loc9_)
            {
               _loc11_ = _loc12_[_loc13_];
               _loc10_ = this.getOutlineLocks(_loc11_);
               if(!(_loc10_ & 2))
               {
                  _loc11_.setProperty("y",int(_loc12_[_loc13_ - 1].y + _loc12_[_loc13_ - 1].height + param4));
               }
               _loc13_++;
            }
         }
         else if(param1 == 1)
         {
            _loc13_ = 0;
            while(_loc13_ < _loc9_)
            {
               _loc11_ = this._selections[_loc13_];
               _loc12_.push(_loc11_);
               _loc13_++;
            }
            _loc12_.sortOn("x",16);
            _loc13_ = 1;
            while(_loc13_ < _loc9_)
            {
               _loc11_ = _loc12_[_loc13_];
               _loc10_ = this.getOutlineLocks(_loc11_);
               if(!(_loc10_ & 1))
               {
                  _loc11_.setProperty("x",int(_loc12_[_loc13_ - 1].x + _loc12_[_loc13_ - 1].width + param3));
               }
               _loc13_++;
            }
         }
         else
         {
            if(param2 == 0)
            {
               param2 = 1;
            }
            _loc13_ = 0;
            while(_loc13_ < _loc9_)
            {
               _loc11_ = this._selections[_loc13_];
               _loc12_.push(_loc11_);
               _loc13_++;
            }
            _loc12_.sortOn("x",16);
            _loc5_ = _loc12_[0].x;
            _loc12_.sortOn("y",16);
            _loc7_ = _loc12_[0].y;
            while(true)
            {
               _loc8_ = _loc12_.slice(0,param2);
               _loc8_.sortOn("x",16);
               _loc6_ = 0;
               _loc13_ = 0;
               while(_loc13_ < param2)
               {
                  _loc11_ = _loc8_[_loc13_];
                  if(_loc11_)
                  {
                     _loc10_ = this.getOutlineLocks(_loc11_);
                     if(!(_loc10_ & 1))
                     {
                        if(_loc13_ == 0)
                        {
                           _loc11_.setProperty("x",_loc5_);
                        }
                        else
                        {
                           _loc11_.setProperty("x",_loc8_[_loc13_ - 1].x + _loc8_[_loc13_ - 1].width + param3);
                        }
                     }
                     if(!(_loc10_ & 2))
                     {
                        _loc11_.setProperty("y",_loc7_);
                     }
                     if(_loc11_.height > _loc6_)
                     {
                        _loc6_ = _loc11_.height;
                     }
                     _loc13_++;
                     continue;
                  }
                  break;
               }
               if(_loc13_ == param2)
               {
                  _loc7_ = _loc7_ + (_loc6_ + param4);
                  _loc12_.splice(0,param2);
                  if(_loc12_.length == 0)
                  {
                     break;
                  }
                  continue;
               }
               break;
            }
         }
         this.makeSelectionsFixed(false);
      }
      
      public function onBgColorChanged() : void
      {
         if(parent != null)
         {
            this.drawBackground();
         }
         else
         {
            this._bgColorChanged = true;
         }
      }
      
      public function onViewScaleChanged() : void
      {
         var _loc1_:RangeEditor = null;
         var _loc2_:EUISprite = null;
         var _loc6_:Number = this._docItem.owner.project.editorWindow.mainPanel.viewScale;
         var _loc5_:Number = this._container.scaleX;
         if(_loc6_ == _loc5_)
         {
            return;
         }
         this._container.scaleX = _loc6_;
         this._container.scaleY = _loc6_;
         this._selContainer.scaleX = _loc6_;
         this._selContainer.scaleY = _loc6_;
         this._savedScrollPercX = parent.scrollPane.percX;
         this._savedScrollPercY = parent.scrollPane.percY;
         this._savedScrollPercX = 1;
         this._savedScrollPercY = 1;
         this.updateCanvasSize(true);
         var _loc3_:int = this._selContainer.numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = RangeEditor(this._selContainer.getChildAt(_loc4_));
            _loc1_.onViewScaleChanged();
            _loc4_++;
         }
         _loc3_ = this._docContent.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this._docContent.getChildAt(_loc4_).displayObject;
            _loc2_.onViewScaleChanged();
            _loc4_++;
         }
         parent.scrollPane.percX = this._savedScrollPercX;
         parent.scrollPane.percY = this._savedScrollPercY;
      }
      
      private function __docContainerSizeChanged() : void
      {
         this.updateCanvasSize(true);
      }
      
      private function __contentSizeChanged() : void
      {
         this.updateCanvasSize(true);
      }
      
      private function __contentXYChanged() : void
      {
         var _loc1_:RangeEditor = null;
         this.updateCanvasSize(false);
         var _loc3_:int = this._selContainer.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = RangeEditor(this._selContainer.getChildAt(_loc2_));
            _loc1_.synEditorRange();
            _loc2_++;
         }
      }
      
      private function __menuTransXY(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"XY");
      }
      
      private function __menuTransXYV(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"XYV");
      }
      
      private function __menuTransSize(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Size");
      }
      
      private function __menuTransAlpha(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Alpha");
      }
      
      private function __menuTransRotation(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Rotation");
      }
      
      private function __menuTransScale(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Scale");
      }
      
      private function __menuTransSkew(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Skew");
      }
      
      private function __menuTransColor(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Color");
      }
      
      private function __menuTransAnimation(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Animation");
      }
      
      private function __menuTransPivot(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Pivot");
      }
      
      private function __menuTransSound(param1:Event) : void
      {
         this._editPanel.timelinePanel.createTimeline("","Sound");
      }
      
      private function __menuTransTrans(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Transition");
      }
      
      private function __menuTransShake(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Shake");
      }
      
      private function __menuTransController(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Controller");
      }
      
      private function __menuTransVisible(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"Visible");
      }
      
      private function __menuTransColorFilter(param1:Event) : void
      {
         var _loc2_:Vector.<String> = this.getSelectionIds();
         if(_loc2_.length == 0)
         {
            _loc2_.push("");
         }
         this._editPanel.timelinePanel.createTimelines(_loc2_,"ColorFilter");
      }
   }
}

package fairygui.editor.dialogs
{
   import fairygui.Controller;
   import fairygui.GComboBox;
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGImage;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIObjectFactory;
   import fairygui.editor.settings.ImageSetting;
   import fairygui.editor.utils.Utils;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.PNGEncoderOptions;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class ImageEditDialog extends WindowBase
   {
       
      
      private var _imageItem:EPackageItem;
      
      private var _imageSetting:ImageSetting;
      
      private var _hLine1:Sprite;
      
      private var _hLine2:Sprite;
      
      private var _vLine1:Sprite;
      
      private var _vLine2:Sprite;
      
      private var _container:Sprite;
      
      private var _image:EGImage;
      
      private var _imageHolder:GGraph;
      
      private var _c2:Controller;
      
      private var _offset:Point;
      
      private var _dragStartTime:int;
      
      private var _draggingLine:Sprite;
      
      private var _dragStartPos:Point;
      
      private const MARGIN:int = 50;
      
      private const VIEW_SIZE:int = 400;
      
      public function ImageEditDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ImageEditDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._dragStartPos = new Point();
         this._offset = new Point();
         this._container = new Sprite();
         this._hLine1 = new Sprite();
         this._container.addChild(this._hLine1);
         this._hLine2 = new Sprite();
         this._container.addChild(this._hLine2);
         this._vLine1 = new Sprite();
         this._container.addChild(this._vLine1);
         this._vLine2 = new Sprite();
         this._container.addChild(this._vLine2);
         this._hLine1.addEventListener("mouseDown",this.__mouseDown);
         this._hLine2.addEventListener("mouseDown",this.__mouseDown);
         this._vLine1.addEventListener("mouseDown",this.__mouseDown);
         this._vLine2.addEventListener("mouseDown",this.__mouseDown);
         this._imageHolder = new GGraph();
         this._imageHolder.setNativeObject(this._container);
         var _loc3_:GComponent = this.contentPane.getChild("imageContainer").asCom;
         _loc3_.addChild(this._imageHolder);
         _loc3_.scrollPane.touchEffect = true;
         _loc2_ = contentPane.getChild("qualityOption").asComboBox;
         _loc2_.items = [Consts.g.text82,Consts.g.text83,Consts.g.text84];
         _loc2_.values = ["default","source","custom"];
         _loc2_.addEventListener("stateChanged",this.__qualityChanged);
         _loc2_ = contentPane.getChild("smoothing").asComboBox;
         _loc2_.items = [Consts.g.text161,Consts.g.text162];
         _loc2_.values = ["false","true"];
         NumericInput(contentPane.getChild("quality")).max = 100;
         this._c2 = contentPane.getController("c2");
         this._c2.addEventListener("stateChanged",this.__scaleChanged);
         contentPane.getChild("grid0").addEventListener("__submit",this.__rectChanged);
         contentPane.getChild("grid1").addEventListener("__submit",this.__rectChanged);
         contentPane.getChild("grid2").addEventListener("__submit",this.__rectChanged);
         contentPane.getChild("grid3").addEventListener("__submit",this.__rectChanged);
         contentPane.getController("c1").addEventListener("stateChanged",this.__resizeOptionChanged);
         this.contentPane.getChild("save").addClickListener(this.__action);
         this.contentPane.getChild("apply").addClickListener(this.__apply);
         this.contentPane.getChild("close").addClickListener(closeEventHandler);
         this.contentPane.getChild("import").addClickListener(this.__import);
         this.contentPane.getChild("cutAlpha").addClickListener(this.__cutAlpha);
      }
      
      public function open(param1:EPackageItem) : void
      {
         this._imageItem = param1;
         this._imageSetting = param1.imageSetting;
         this.frame.text = this._imageItem.fileName;
         contentPane.getChild("imageSize").text = param1.width + " x " + param1.height;
         contentPane.getChild("fileSize").text = "";
         contentPane.getController("c1").setSelectedPage(this._imageSetting.scaleOption);
         this.setScale9GridRectToUI(this._imageSetting.scale9Grid.x,this._imageSetting.scale9Grid.y,this._imageSetting.scale9Grid.width,this._imageSetting.scale9Grid.height);
         contentPane.getChild("qualityOption").asComboBox.value = this._imageSetting.qualityOption;
         contentPane.getChild("quality").text = "" + this._imageSetting.quality;
         var _loc3_:GComboBox = contentPane.getChild("atlas").asComboBox;
         this._imageItem.owner.publishSettings.fillCombo(_loc3_,this._imageItem.owner);
         _loc3_.value = this._imageSetting.atlas;
         this.__qualityChanged(null);
         this._c2.setSelectedIndex(0);
         contentPane.getChild("smoothing").asComboBox.value = !!this._imageSetting.smoothing?"true":"false";
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            contentPane.getChild("gridTile" + _loc2_).asButton.selected = (this._imageSetting.gridTile & 1 << _loc2_) != 0;
            _loc2_++;
         }
         if(this._image != null)
         {
            this._container.removeChild(this._image.displayObject);
            this._image.dispose();
            this._image = null;
         }
         this._imageItem.owner.getImage(this._imageItem,this.__imageLoaded);
         this._image = EGImage(EUIObjectFactory.createObject(this._imageItem));
         this._container.addChildAt(this._image.displayObject,0);
         this.adjustLayout();
         show();
      }
      
      private function adjustLayout() : void
      {
         var _loc7_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = NaN;
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc8_:int = this._c2.selectedIndex;
         if(_loc8_ == 0)
         {
            _loc4_ = this._image.width / (400 - 50 * 2);
            _loc3_ = this._image.height / (400 - 50 * 2);
            if(_loc4_ > 1 || _loc3_ > 1)
            {
               _loc6_ = Number(1 / Math.max(_loc4_,_loc3_));
            }
            else
            {
               _loc6_ = 1;
            }
         }
         else
         {
            _loc6_ = Number(_loc8_ == 3?4:Number(_loc8_));
         }
         var _loc9_:* = _loc6_;
         this._container.scaleY = _loc9_;
         this._container.scaleX = _loc9_;
         this._image.setXY(50 / _loc6_,50 / _loc6_);
         _loc7_ = this._image.width * _loc6_;
         _loc5_ = this._image.height * _loc6_;
         this._imageHolder.setSize(_loc7_ + 50 * 2,_loc5_ + 50 * 2);
         var _loc1_:int = (400 - this._imageHolder.width) / 2;
         var _loc2_:int = (400 - this._imageHolder.height) / 2;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         this._imageHolder.setXY(_loc1_,_loc2_);
         this.drawLineShape(this._hLine1.graphics,false);
         this.drawLineShape(this._hLine2.graphics,false);
         this.drawLineShape(this._vLine1.graphics,true);
         this.drawLineShape(this._vLine2.graphics,true);
         this.drawScale9GridLines();
      }
      
      private function drawLineShape(param1:Graphics, param2:Boolean) : void
      {
         var _loc3_:int = this._imageHolder.width / this._container.scaleX;
         var _loc4_:int = this._imageHolder.height / this._container.scaleY;
         param1.clear();
         param1.lineStyle(1,0,1);
         if(param2)
         {
            Utils.drawDashedLine(param1,0,0,0,_loc4_,4);
         }
         else
         {
            Utils.drawDashedLine(param1,0,0,_loc3_,0,4);
         }
         param1.lineStyle(0,0,0);
         param1.beginFill(0,0);
         if(param2)
         {
            param1.drawRect(-2,0,4,_loc4_);
         }
         else
         {
            param1.drawRect(0,-2,_loc3_,4);
         }
         param1.endFill();
      }
      
      public function get imageItem() : EPackageItem
      {
         return this._imageItem;
      }
      
      private function apply(param1:Boolean) : void
      {
         this._imageSetting.scaleOption = contentPane.getController("c1").selectedPage;
         this._imageSetting.scale9Grid.x = parseInt(contentPane.getChild("grid2").text);
         this._imageSetting.scale9Grid.y = parseInt(contentPane.getChild("grid0").text);
         this._imageSetting.scale9Grid.width = this._imageItem.width - this._imageSetting.scale9Grid.x - parseInt(contentPane.getChild("grid3").text);
         this._imageSetting.scale9Grid.height = this._imageItem.height - this._imageSetting.scale9Grid.y - parseInt(contentPane.getChild("grid1").text);
         this._imageSetting.qualityOption = contentPane.getChild("qualityOption").asComboBox.value;
         this._imageSetting.quality = parseInt(contentPane.getChild("quality").text);
         this._imageSetting.smoothing = contentPane.getChild("smoothing").asComboBox.selectedIndex == 1;
         this._imageSetting.gridTile = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            if(contentPane.getChild("gridTile" + _loc2_).asButton.selected)
            {
               this._imageSetting.gridTile = this._imageSetting.gridTile | 1 << _loc2_;
            }
            _loc2_++;
         }
         this._imageSetting.atlas = contentPane.getChild("atlas").asComboBox.value;
         this._imageItem.owner.save();
         this._imageItem.invalidate();
         this._imageItem.owner.getImage(this._imageItem,this.__imageLoaded);
         _editorWindow.closeWaiting();
         if(param1)
         {
            hide();
         }
         _editorWindow.mainPanel.editPanel.refreshDocument();
      }
      
      private function setScale9GridRectToUI(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._imageSetting.scale9Grid.x = param1;
         this._imageSetting.scale9Grid.y = param2;
         this._imageSetting.scale9Grid.width = param3;
         this._imageSetting.scale9Grid.height = param4;
         contentPane.getChild("grid2").text = "" + this._imageSetting.scale9Grid.x;
         contentPane.getChild("grid0").text = "" + this._imageSetting.scale9Grid.y;
         contentPane.getChild("grid3").text = "" + (this._imageItem.width - this._imageSetting.scale9Grid.right);
         contentPane.getChild("grid1").text = "" + (this._imageItem.height - this._imageSetting.scale9Grid.bottom);
      }
      
      private function drawScale9GridLines() : void
      {
         var _loc2_:Rectangle = this._imageSetting.scale9Grid;
         var _loc1_:* = contentPane.getController("c1").selectedIndex == 1;
         this._hLine1.visible = _loc1_;
         this._hLine2.visible = _loc1_;
         this._vLine1.visible = _loc1_;
         this._vLine2.visible = _loc1_;
         this._hLine1.y = _loc2_.y + this._image.x;
         this._hLine2.y = _loc2_.bottom + this._image.y;
         this._vLine1.x = _loc2_.x + this._image.x;
         this._vLine2.x = _loc2_.right + this._image.y;
      }
      
      private function __rectChanged(param1:Event) : void
      {
         this._imageSetting.scale9Grid.x = parseInt(contentPane.getChild("grid2").text);
         this._imageSetting.scale9Grid.y = parseInt(contentPane.getChild("grid0").text);
         this._imageSetting.scale9Grid.width = this._imageItem.width - this._imageSetting.scale9Grid.x - parseInt(contentPane.getChild("grid3").text);
         this._imageSetting.scale9Grid.height = this._imageItem.height - this._imageSetting.scale9Grid.y - parseInt(contentPane.getChild("grid1").text);
         this.drawScale9GridLines();
      }
      
      private function __resizeOptionChanged(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         this._imageSetting.scaleOption = contentPane.getController("c1").selectedPage;
         if(this._imageSetting.scaleOption == "9grid" && this._imageSetting.scale9Grid.isEmpty())
         {
            _loc3_ = Math.ceil(this._imageItem.width / 4);
            _loc2_ = Math.ceil(this._imageItem.height / 4);
            this.setScale9GridRectToUI(_loc3_,_loc2_,_loc3_ * 2,_loc2_ * 2);
         }
         this.drawScale9GridLines();
      }
      
      private function __action(param1:Event) : void
      {
         this.apply(true);
      }
      
      private function __apply(param1:Event) : void
      {
         this.apply(false);
      }
      
      private function __import(param1:Event) : void
      {
         _editorWindow.mainPanel.selectForUpdateResource(this._imageItem);
      }
      
      private function __qualityChanged(param1:Event) : void
      {
         contentPane.getChild("quality").enabled = contentPane.getChild("qualityOption").asComboBox.selectedIndex == 2;
      }
      
      private function __mouseDown(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         this._draggingLine = Sprite(param1.currentTarget);
         this._dragStartPos.x = this._draggingLine.x;
         this._dragStartPos.y = this._draggingLine.y;
         this._offset.x = this._container.mouseX;
         this._offset.y = this._container.mouseY;
         this._dragStartTime = getTimer();
         displayObject.stage.addEventListener("mouseUp",this.__mouseUp);
         displayObject.addEventListener("mouseMove",this.__mouseMove);
      }
      
      private function __mouseUp(param1:MouseEvent) : void
      {
         if(this._draggingLine)
         {
            param1.stopPropagation();
            this._draggingLine = null;
            displayObject.stage.removeEventListener("mouseUp",this.__mouseUp);
            displayObject.removeEventListener("mouseMove",this.__mouseMove);
         }
      }
      
      private function __mouseMove(param1:MouseEvent) : void
      {
         if(!this._draggingLine || this._dragStartTime && getTimer() - this._dragStartTime < 100)
         {
            return;
         }
         var _loc3_:Number = this._container.mouseX - this._offset.x;
         var _loc2_:Number = this._container.mouseY - this._offset.y;
         if(this._draggingLine == this._hLine1 || this._draggingLine == this._hLine2)
         {
            this._draggingLine.y = Math.min(this._image.height + this._image.y,Math.max(this._image.y,this._dragStartPos.y + _loc2_));
         }
         else if(this._draggingLine == this._vLine1 || this._draggingLine == this._vLine2)
         {
            this._draggingLine.x = Math.min(this._image.width + this._image.x,Math.max(this._image.x,this._dragStartPos.x + _loc3_));
         }
         this.setScale9GridRectToUI(Math.min(this._vLine1.x,this._vLine2.x) - this._image.x,Math.min(this._hLine1.y,this._hLine2.y) - this._image.y,Math.abs(this._vLine1.x - this._vLine2.x),Math.abs(this._hLine1.y - this._hLine2.y));
      }
      
      private function __scaleChanged(param1:Event) : void
      {
         this.adjustLayout();
      }
      
      private function __imageLoaded(param1:EPackageItem) : void
      {
         var _loc2_:* = param1;
         if(_loc2_ == this._imageItem)
         {
            try
            {
               if(!this._imageItem.file.exists)
               {
                  return;
               }
               if(this._imageItem.file == this._imageItem.imageInfo.file || this._imageItem.imageInfo.file == null || !this._imageItem.imageInfo.file.exists)
               {
                  contentPane.getChild("fileSize").text = UtilsStr.getSizeName(this._imageItem.fileSize);
               }
               else
               {
                  contentPane.getChild("fileSize").text = UtilsStr.getSizeName(this._imageItem.file.size) + " => " + UtilsStr.getSizeName(this._imageItem.imageInfo.file.size);
               }
               return;
               return;
            }
            catch(err:Error)
            {
               return;
            }
            return;
         }
      }
      
      private function __cutAlpha(param1:Event) : void
      {
         var _loc4_:BitmapData = null;
         var _loc2_:ByteArray = null;
         var _loc5_:* = BitmapData(this._imageItem.data);
         if(_loc5_ == null || !_loc5_.transparent)
         {
            return;
         }
         var _loc3_:Rectangle = _loc5_.getColorBoundsRect(4278190080,0,false);
         if(!_loc3_.isEmpty() && !_loc3_.equals(_loc5_.rect))
         {
            _loc4_ = new BitmapData(_loc3_.width,_loc3_.height,_loc5_.transparent,0);
            _loc4_.copyPixels(_loc5_,_loc3_,new Point(0,0));
            _loc5_.dispose();
            _loc5_ = _loc4_;
            _loc2_ = _loc5_.encode(_loc5_.rect,new PNGEncoderOptions());
            UtilsFile.saveBytes(this._imageItem.file,_loc2_);
            this._imageItem.invalidate();
            _editorWindow.mainPanel.editPanel.refreshDocument();
            _editorWindow.mainPanel.previewPanel.refresh(true);
            this.open(this._imageItem);
         }
      }
      
      public function cutImageFileAlpha(param1:EPackageItem) : void
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
   }
}

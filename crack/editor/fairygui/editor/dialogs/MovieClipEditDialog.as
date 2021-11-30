package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GGraph;
   import fairygui.GLabel;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.LibPanel;
   import fairygui.editor.WindowBase;
   import fairygui.editor.animation.AniDef;
   import fairygui.editor.animation.AniImporter;
   import fairygui.editor.animation.AniSprite;
   import fairygui.editor.animation.PlaySettings;
   import fairygui.editor.extui.DropEvent;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.utils.GTimers;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.geom.Rectangle;
   import flash.net.FileFilter;
   import flash.utils.ByteArray;
   
   public class MovieClipEditDialog extends WindowBase
   {
       
      
      private var _pi:EPackageItem;
      
      private var _ani:AniDef;
      
      private var _container:Sprite;
      
      private var _holder:GGraph;
      
      private var _playSettings:PlaySettings;
      
      private var _aniSprite:AniSprite;
      
      private var _playing:Boolean;
      
      private var _fpsInput:GComboBox;
      
      private var _frameLabel:GLabel;
      
      private var _frameDelayInput:GLabel;
      
      private var _playButton:GButton;
      
      private var _speed:GLabel;
      
      private var _repeatDelay:GLabel;
      
      private var _swing:GButton;
      
      private var _prevFrame:GButton;
      
      private var _nextFrame:GButton;
      
      private var _modified:Boolean;
      
      public function MovieClipEditDialog(param1:EditorWindow)
      {
         param1 = param1;
         var cb:GComboBox = null;
         var win:EditorWindow = param1;
         super();
         _editorWindow = win;
         this.contentPane = UIPackage.createObject("Builder","MovieClipEditDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         cb = contentPane.getChild("smoothing").asComboBox;
         cb.items = [Consts.g.text161,Consts.g.text162];
         cb.values = ["false","true"];
         this._fpsInput = contentPane.getChild("fps").asComboBox;
         this._fpsInput.addEventListener("stateChanged",function():void
         {
            _ani.fps = parseInt(_fpsInput.text);
            GTimers.inst.add(1000 / _ani.fps,0,frameScript);
            _modified = true;
         });
         this._speed = contentPane.getChild("speed").asLabel;
         NumericInput(this._speed).min = 1;
         this._speed.addEventListener("__submit",function():void
         {
            _ani.speed = parseInt(_speed.text);
            if(_ani.speed < 1)
            {
               _ani.speed = 1;
            }
            _modified = true;
         });
         this._repeatDelay = contentPane.getChild("repeatDelay").asLabel;
         this._repeatDelay.addEventListener("__submit",function():void
         {
            _ani.repeatDelay = parseInt(_repeatDelay.text);
            _modified = true;
         });
         this._swing = contentPane.getChild("swing").asButton;
         this._swing.addEventListener("stateChanged",function():void
         {
            _ani.swing = _swing.selected;
            _modified = true;
         });
         this._frameLabel = contentPane.getChild("currentFrame").asLabel;
         this._frameLabel.editable = false;
         this._frameLabel.getChild("title").asTextField.align = 1;
         this._frameLabel.addEventListener("__submit",function():void
         {
            var _loc1_:int = parseInt(_frameLabel.text);
            if(_ani.frameCount == 0)
            {
               _loc1_ = 0;
            }
            else if(_loc1_ > _ani.frameCount)
            {
               _loc1_ = _ani.frameCount;
            }
            else if(_loc1_ < 1)
            {
               _loc1_ = 1;
            }
            _playSettings.curFrame = _loc1_ - 1;
         });
         this._frameDelayInput = contentPane.getChild("frameDelay").asLabel;
         this._frameDelayInput.addEventListener("__submit",function():void
         {
            if(_ani.frameCount == 0)
            {
               return;
            }
            var _loc1_:int = _playSettings.curFrame;
            _ani.frameList[_loc1_].delay = parseInt(_frameDelayInput.text);
            _modified = true;
         });
         this._playButton = contentPane.getChild("play").asButton;
         this._playButton.addEventListener("stateChanged",function():void
         {
            _playing = _playButton.selected;
         });
         this._prevFrame = contentPane.getChild("prevFrame").asButton;
         this._nextFrame = contentPane.getChild("nextFrame").asButton;
         this._prevFrame.addClickListener(function():void
         {
            if(_ani.frameCount == 0)
            {
               return;
            }
            _playSettings.stepPrev(_ani);
            _frameDelayInput.text = "" + int(_ani.frameList[_playSettings.curFrame].delay);
         });
         this._nextFrame.addClickListener(function():void
         {
            if(_ani.frameCount == 0)
            {
               return;
            }
            _playSettings.stepNext(_ani);
            _frameDelayInput.text = "" + int(_ani.frameList[_playSettings.curFrame].delay);
         });
         contentPane.getChild("n42").addClickListener(this.__save);
         contentPane.getChild("n44").addClickListener(closeEventHandler);
         contentPane.getChild("n76").addClickListener(this.__import);
         contentPane.getChild("n77").addClickListener(this.__import2);
         this._ani = new AniDef();
         this._container = new Sprite();
         this._container.mouseEnabled = false;
         this._holder = new GGraph();
         this._holder.setNativeObject(this._container);
         contentPane.getChild("n74").asCom.addChild(this._holder);
         contentPane.getChild("n74").asCom.scrollPane.touchEffect = true;
         this._playSettings = new PlaySettings();
         this._aniSprite = new AniSprite(this._playSettings);
         this._aniSprite.mouseEnabled = false;
         this._aniSprite.playing = false;
         this._container.addChild(this._aniSprite);
         this.addEventListener("__drop",this.__drop);
      }
      
      public function open(param1:EPackageItem) : void
      {
         var _loc2_:GComboBox = null;
         var _loc4_:* = param1;
         this._pi = _loc4_;
         this._modified = false;
         _loc2_ = contentPane.getChild("atlas").asComboBox;
         this._pi.owner.publishSettings.fillCombo(_loc2_,this._pi.owner);
         _loc2_.value = this._pi.imageSetting.atlas;
         _loc2_ = contentPane.getChild("smoothing").asComboBox;
         _loc2_.value = !!this._pi.imageSetting.smoothing?"true":"false";
         this._ani.reset();
         var _loc3_:ByteArray = UtilsFile.loadBytes(_loc4_.file);
         if(_loc3_ != null)
         {
            try
            {
               this._ani.load(_loc3_);
            }
            catch(err:Error)
            {
               _editorWindow.alertError(err);
            }
         }
         this._aniSprite.def = this._ani;
         this._playSettings.rewind();
         this._playing = true;
         this._playButton.selected = true;
         this._aniSprite.clear();
         this.setActionToUI();
         this.frame.text = this._pi.name + " - " + Consts.g.text87;
         show();
      }
      
      override protected function onHide() : void
      {
         super.onHide();
         GTimers.inst.remove(this.frameScript);
      }
      
      private function setActionToUI() : void
      {
         GTimers.inst.add(1000 / this._ani.fps,0,this.frameScript);
         this._fpsInput.text = "" + this._ani.fps;
         this._speed.text = "" + this._ani.speed;
         this._repeatDelay.text = "" + int(this._ani.repeatDelay);
         this._swing.selected = this._ani.swing;
         if(this._ani.frameCount > 0)
         {
            this._frameDelayInput.text = "" + int(this._ani.frameList[this._playSettings.curFrame].delay);
         }
         else
         {
            this._frameDelayInput.text = "0";
         }
         var _loc1_:Rectangle = this._ani.boundsRect;
         if(_loc1_.width < this._holder.parent.width)
         {
            this._holder.x = -_loc1_.x + (this._holder.parent.width - _loc1_.width) / 2;
         }
         else
         {
            this._holder.x = -_loc1_.x;
         }
         if(_loc1_.height < this._holder.parent.height)
         {
            this._holder.y = -_loc1_.y + (this._holder.parent.height - _loc1_.height) / 2;
         }
         else
         {
            this._holder.y = -_loc1_.y;
         }
         this._holder.setSize(_loc1_.width,_loc1_.height);
         this._holder.parent.scrollPane.percX = 0;
         this._holder.parent.scrollPane.percY = 0;
      }
      
      private function frameScript() : void
      {
         var _loc1_:int = 0;
         this._aniSprite.update();
         if(this._playing)
         {
            this._playSettings.nextFrame(this._aniSprite.def);
         }
         if(this._ani.frameCount > 0)
         {
            _loc1_ = this._playSettings.curFrame;
            this._frameLabel.text = "" + (_loc1_ + 1) + "/" + this._ani.frameCount;
            if(this._playing)
            {
               this._frameDelayInput.text = "" + int(this._ani.frameList[_loc1_].delay);
            }
         }
         else
         {
            this._frameLabel.text = "0/0";
            this._frameDelayInput.text = "0";
         }
      }
      
      private function __save(param1:Event) : void
      {
         this.doSave();
         this.hide();
      }
      
      private function doSave() : void
      {
         var _loc2_:AniDef = null;
         var _loc4_:Boolean = false;
         var _loc3_:String = contentPane.getChild("atlas").asComboBox.value;
         var _loc1_:* = contentPane.getChild("smoothing").asComboBox.value == "true";
         if(this._pi.imageSetting.atlas != _loc3_ || _loc1_ != this._pi.imageSetting.smoothing)
         {
            this._pi.imageSetting.atlas = _loc3_;
            this._pi.imageSetting.smoothing = _loc1_;
            this._pi.owner.save();
            this._pi.invalidate();
            _loc4_ = true;
         }
         if(this._modified)
         {
            UtilsFile.saveBytes(this._pi.file,this._ani.save());
            this._playSettings.rewind();
            this._pi.invalidate();
            this._modified = false;
            _loc2_ = this._pi.owner.getMovieClip(this._pi);
            if(_loc2_ != this._ani)
            {
               this.open(this._pi);
            }
            _loc4_ = true;
         }
         if(_loc4_)
         {
            _editorWindow.mainPanel.editPanel.refreshDocument();
            _editorWindow.mainPanel.previewPanel.refresh(true);
         }
      }
      
      private function __open(param1:Event) : void
      {
         this._pi.file.openWithDefaultApplication();
      }
      
      private function __drop(param1:DropEvent) : void
      {
         param1 = param1;
         var callback:Callback = null;
         var pi:EPackageItem = null;
         var evt:DropEvent = param1;
         if(!(evt.source is LibPanel))
         {
            return;
         }
         var cnt:int = evt.sourceData.length;
         var files:Array = [];
         var i:int = 0;
         while(i < cnt)
         {
            pi = EPackageItem(evt.sourceData[i]);
            if(pi.type == "image")
            {
               files.push(pi.file);
            }
            i = Number(i) + 1;
         }
         if(files.length == 0)
         {
            return;
         }
         callback = new Callback();
         callback.success = function():void
         {
            _modified = true;
            doSave();
            _editorWindow.closeWaiting();
            setActionToUI();
         };
         callback.failed = function():void
         {
            _editorWindow.closeWaiting();
            _editorWindow.alert(callback.msgs.join("\n"));
         };
         _editorWindow.showWaiting(Consts.g.text86 + "...");
         AniImporter.importImages(files,this._ani,!_editorWindow.project.usingAtlas,callback);
      }
      
      private function __import(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         UtilsFile.browseForOpenMultiple(Consts.g.text49,[new FileFilter(Consts.g.text49,"*.jpg;*.png"),new FileFilter(Consts.g.text48,"*.*")],function(param1:Array):void
         {
            param1 = param1;
            var callback:Callback = null;
            var files:Array = param1;
            files.sortOn("name");
            callback = new Callback();
            callback.success = function():void
            {
               _modified = true;
               doSave();
               _editorWindow.closeWaiting();
               setActionToUI();
            };
            callback.failed = function():void
            {
               _editorWindow.closeWaiting();
               _editorWindow.alert(callback.msgs.join("\n"));
               setActionToUI();
            };
            _editorWindow.showWaiting(Consts.g.text86 + "...");
            GTimers.inst.remove(frameScript);
            AniImporter.importImages(files,_ani,!_editorWindow.project.usingAtlas,callback);
         });
      }
      
      private function __import2(param1:Event) : void
      {
         param1 = param1;
         var evt:Event = param1;
         UtilsFile.browseForOpen(Consts.g.text303,[new FileFilter(Consts.g.text303,"*.eas;*.json;*.xml;*.plist")],function(param1:File):void
         {
            param1 = param1;
            var callback:Callback = null;
            var file:File = param1;
            callback = new Callback();
            callback.success = function():void
            {
               _modified = true;
               doSave();
               _editorWindow.closeWaiting();
               setActionToUI();
            };
            callback.failed = function():void
            {
               _editorWindow.closeWaiting();
               _editorWindow.alert(callback.msgs.join("\n"));
               setActionToUI();
            };
            _editorWindow.showWaiting(Consts.g.text86 + "...");
            GTimers.inst.remove(frameScript);
            AniImporter.importSpriteSheet(file,_ani,!_editorWindow.project.usingAtlas,callback);
         });
      }
   }
}

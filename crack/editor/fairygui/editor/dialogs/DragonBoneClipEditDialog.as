package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GGraph;
   import fairygui.GLabel;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.animation.AniSprite;
   import fairygui.editor.animation.BoneDef;
   import fairygui.editor.animation.PlaySettings;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import fairygui.editor.utils.UtilsFile;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.net.FileFilter;
   import flash.utils.ByteArray;
   
   public class DragonBoneClipEditDialog extends WindowBase
   {
       
      
      private var _pi:EPackageItem;
      
      private var _ani:BoneDef;
      
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
      
      public function DragonBoneClipEditDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         var _loc3_:* = param1;
         super();
         _editorWindow = _loc3_;
         this.contentPane = UIPackage.createObject("Fysheji","ImportDragonBone").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.contentPane.getChild("btnImportRes").addClickListener(this.__import);
         this.contentPane.getChild("btnYes").addClickListener(this.__save);
         this.contentPane.getChild("btnCancel").addClickListener(this.closeEventHandler);
         this._ani = new BoneDef();
      }
      
      public function open(param1:EPackageItem) : void
      {
         var _loc2_:* = param1;
         this._pi = _loc2_;
         show();
      }
      
      override protected function onHide() : void
      {
         super.onHide();
      }
      
      private function __save(param1:Event) : void
      {
         this.doSave();
         this.hide();
      }
      
      private function doSave() : void
      {
         var _loc1_:BoneDef = null;
         var _loc2_:Boolean = false;
         UtilsFile.saveBytes(this._pi.file,this._ani.save());
         this._pi.invalidate();
         this._modified = false;
         _loc1_ = this._pi.owner.getBoneDef(this._pi);
         if(_loc1_ != this._ani)
         {
            this.open(this._pi);
         }
         _loc2_ = true;
         if(_loc2_)
         {
            _editorWindow.mainPanel.editPanel.refreshDocument();
            _editorWindow.mainPanel.previewPanel.refresh(true);
         }
      }
      
      private function __open(param1:Event) : void
      {
         this._pi.file.openWithDefaultApplication();
      }
      
      private function __import(param1:Event) : void
      {
         var _loc2_:* = param1;
         UtilsFile.browseForOpenMultiple(Consts.g.text49,[new FileFilter(Consts.g.text49,"*.json;*.png;*.sk;*.atlas;"),new FileFilter(Consts.g.text48,"*.*")],this.ssss);
      }
      
      private function ssss(param1:Array) : void
      {
         var _loc2_:* = param1;
         _loc2_.sortOn("name");
         _editorWindow.showWaiting(Consts.g.text86 + "...");
         var _loc4_:File = null;
         var _loc6_:Array = [];
         var _loc8_:int = 0;
         var _loc7_:* = _loc2_;
         for each(_loc4_ in _loc2_)
         {
            _loc6_.push(_loc4_.url);
         }
         var _loc3_:Array = _loc4_.name.split(".");
         var _loc5_:String = _loc3_[0];
         EasyLoader.loadMultiple(_loc6_,{
            "name":_loc4_.name,
            "boneName":_loc5_
         },this.onLoadComplete);
      }
      
      public function onLoadComplete(param1:Array) : void
      {
         var _loc6_:* = null;
         var _loc8_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc10_:* = null;
         var _loc5_:* = null;
         var _loc7_:* = null;
         var _loc9_:* = null;
         var _loc11_:int = 1;
         var _loc2_:String = "";
         while(param1.length > 0)
         {
            _loc10_ = param1.shift();
            _loc2_ = _loc10_.props["boneName"];
            if(_loc10_.iType == "image")
            {
               _loc6_ = _loc10_.content;
               if(_loc6_.width > 2048 || _loc6_.height > 2048)
               {
                  _editorWindow.alert("导入的骨骼动画贴图尺寸超出了2048！");
                  return;
               }
            }
            else if(_loc10_.iType == "binary")
            {
               _loc5_ = _loc10_.content;
               if(_loc10_.extName == "json")
               {
                  _loc7_ = _loc5_.readUTFBytes(_loc5_.length);
                  _loc9_ = JSON.parse(_loc7_);
                  if(_loc9_.version)
                  {
                     _loc3_ = _loc7_;
                  }
                  else if(_loc9_.imagePath)
                  {
                     _loc8_ = _loc7_;
                  }
                  else if(_loc9_.skeleton)
                  {
                     _loc3_ = _loc7_;
                  }
               }
               else if(_loc10_.extName == "sk")
               {
                  _loc4_ = new ByteArray();
                  _loc5_.readBytes(_loc4_);
               }
               else if(_loc10_.extName == "atlas")
               {
                  _loc8_ = _loc5_.readUTFBytes(_loc5_.length);
                  _loc11_ = 2;
               }
            }
         }
         this._ani.setBoneRes(_loc3_,_loc8_,_loc6_.bitmapData,_loc4_,_loc11_,_loc2_);
         this._pi.boneName = this._ani.boneName;
         _editorWindow.closeWaiting();
      }
   }
}

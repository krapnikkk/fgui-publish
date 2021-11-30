package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.LibPanel;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.DropEvent;
   import fairygui.editor.extui.ListItemInput;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   import fairygui.tree.TreeNode;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   
   public class FontEditDialog extends WindowBase
   {
       
      
      private var _pi:EPackageItem;
      
      private var _container:Sprite;
      
      private var _bitmap:Bitmap;
      
      private var _bitmapHolder:GGraph;
      
      private var _ttf:Boolean;
      
      private var _list:GList;
      
      public function FontEditDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","FontEditDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._list = contentPane.getChild("n1").asList;
         this._list.addEventListener("itemClick",this.__clickItem);
         this._bitmap = new Bitmap();
         this._bitmapHolder = new GGraph();
         this._bitmapHolder.setNativeObject(this._bitmap);
         contentPane.getChild("n15").asCom.addChild(this._bitmapHolder);
         this.contentPane.getChild("fontTexture").asLabel.editable = false;
         contentPane.getChild("n9").addClickListener(this.__save);
         contentPane.getChild("n17").addClickListener(this.__apply);
         contentPane.getChild("n7").addClickListener(this.__deleteChar);
         contentPane.getChild("n10").addClickListener(closeEventHandler);
         this.addEventListener("__drop",this.__drop);
      }
      
      public function open(param1:EPackageItem) : void
      {
         var _loc8_:String = null;
         var _loc12_:Array = null;
         var _loc10_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Object = null;
         var _loc9_:String = null;
         var _loc2_:Array = null;
         var _loc5_:int = 0;
         var _loc13_:Array = null;
         var _loc15_:EPackageItem = null;
         var _loc16_:* = param1;
         show();
         this._pi = _loc16_;
         this.frame.text = this._pi.name;
         this._list.removeChildrenToPool();
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc11_:* = false;
         var _loc14_:* = false;
         try
         {
            _loc8_ = UtilsFile.loadString(_loc16_.file);
            if(_loc8_ == null)
            {
               return;
            }
            _loc12_ = _loc8_.split("\n");
            _loc10_ = _loc12_.length;
            _loc3_ = {};
            _loc7_ = 0;
            while(_loc7_ < _loc10_)
            {
               _loc9_ = _loc12_[_loc7_];
               if(_loc9_)
               {
                  _loc2_ = _loc9_.split(" ");
                  _loc5_ = 1;
                  while(_loc5_ < _loc2_.length)
                  {
                     _loc13_ = _loc2_[_loc5_].split("=");
                     _loc3_[_loc13_[0]] = _loc13_[1];
                     _loc5_++;
                  }
                  _loc9_ = _loc2_[0];
                  if(_loc9_ == "char")
                  {
                     this.addChar(_loc3_);
                  }
                  else if(_loc9_ == "info")
                  {
                     this._ttf = _loc3_.face != null;
                     _loc14_ = Boolean(this._ttf);
                     _loc6_ = _loc3_.size;
                     _loc11_ = _loc3_.resizable == "true";
                     if(_loc3_.colored != undefined)
                     {
                        _loc14_ = _loc3_.colored == "true";
                     }
                  }
                  else if(_loc9_ == "common")
                  {
                     if(_loc6_ == 0)
                     {
                        _loc6_ = _loc3_.lineHeight;
                     }
                     _loc4_ = _loc3_.xadvance;
                  }
               }
               _loc7_++;
            }
         }
         catch(err:Error)
         {
            _editorWindow.alertError(err);
            return;
         }
         this.contentPane.getChild("n6").text = "" + int(_loc6_);
         this.contentPane.getChild("n19").text = "" + int(_loc4_);
         this.contentPane.getChild("n24").asButton.selected = _loc11_;
         this.contentPane.getChild("n27").asButton.selected = _loc14_;
         this.contentPane.getChild("n7").visible = !this._ttf;
         this.contentPane.getChild("n6").enabled = !this._ttf;
         this.contentPane.getChild("n19").enabled = !this._ttf;
         this.contentPane.getChild("n20").visible = !this._ttf;
         this._bitmap.bitmapData = null;
         if(this._pi.fontTexture)
         {
            this.contentPane.getChild("n28").visible = true;
            this.contentPane.getChild("fontTexture").text = "ui://" + this._pi.owner.id + this._pi.fontTexture;
            _loc15_ = this._pi.owner.getItem(this._pi.fontTexture);
            if(_loc15_)
            {
               this._pi.owner.getImage(_loc15_,this.__imageLoaded);
            }
         }
         else
         {
            this.contentPane.getChild("n28").visible = false;
         }
      }
      
      private function addChar(param1:Object) : void
      {
         var _loc2_:GComponent = this._list.addItemFromPool().asCom;
         _loc2_.name = !!param1.img?param1.img:"";
         _loc2_.getChild("n0").text = !!this._ttf?"":this._pi.owner.getItemName(param1.img);
         _loc2_.getChild("n19").text = String.fromCharCode(param1.id);
         _loc2_.getChild("n20").text = "" + int(param1.xoffset);
         _loc2_.getChild("n21").text = "" + int(param1.yoffset);
         _loc2_.getChild("n22").text = "" + int(param1.xadvance);
         ListItemInput(_loc2_.getChild("n19")).enabled = !this._ttf;
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc2_:EPackageItem = null;
         if(this._ttf)
         {
            return;
         }
         var _loc3_:String = param1.itemObject.name;
         if(_loc3_)
         {
            _loc2_ = this._pi.owner.getItem(_loc3_);
            if(_loc2_)
            {
               this._pi.owner.getImage(_loc2_,this.__imageLoaded);
            }
            return;
         }
         this._bitmap.bitmapData = null;
         this.contentPane.getChild("n13").text = "";
      }
      
      private function __imageLoaded(param1:EPackageItem) : void
      {
         if(!param1.data)
         {
            return;
         }
         var _loc2_:BitmapData = BitmapData(param1.data);
         this._bitmap.bitmapData = _loc2_;
         this._bitmapHolder.width = _loc2_.width;
         this._bitmapHolder.height = _loc2_.height;
         this.contentPane.getChild("n13").text = _loc2_.width + "x" + _loc2_.height;
      }
      
      private function __deleteChar(param1:Event) : void
      {
         var _loc2_:int = this._list.selectedIndex;
         if(_loc2_ != -1)
         {
            this._list.removeChildToPoolAt(_loc2_);
            _loc2_ = Math.min(_loc2_,this._list.numChildren);
            this._list.selectedIndex = _loc2_;
         }
      }
      
      private function __save(param1:Event) : void
      {
         this.__apply(param1);
         this.hide();
      }
      
      private function __apply(param1:Event) : void
      {
         var _loc15_:* = null;
         var _loc16_:String = null;
         var _loc17_:Array = null;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:FileStream = null;
         var _loc6_:int = 0;
         var _loc2_:GComponent = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc9_:int = 0;
         var _loc7_:int = 0;
         var _loc19_:int = 0;
         var _loc11_:int = parseInt(this.contentPane.getChild("n6").text);
         var _loc8_:int = parseInt(this.contentPane.getChild("n19").text);
         var _loc10_:Boolean = this.contentPane.getChild("n24").asButton.selected;
         var _loc14_:Boolean = this.contentPane.getChild("n27").asButton.selected;
         var _loc18_:File = this._pi.file;
         if(this._ttf)
         {
            _loc16_ = UtilsFile.loadString(_loc18_);
            _loc17_ = _loc16_.split("\n");
            _loc15_ = _loc17_[0];
            _loc15_ = UtilsStr.trim(_loc15_);
            _loc6_ = _loc15_.indexOf("resizable=");
            if(_loc6_ != -1)
            {
               _loc3_ = _loc15_.indexOf(" ",_loc6_);
               if(_loc3_ == -1)
               {
                  _loc3_ = _loc15_.length;
               }
               _loc15_ = _loc15_.substring(0,_loc6_ + 10) + _loc10_ + _loc15_.substring(_loc3_);
            }
            else if(_loc10_)
            {
               _loc15_ = _loc15_ + " resizable=" + _loc10_;
            }
            _loc6_ = _loc15_.indexOf("colored=");
            if(_loc6_ != -1)
            {
               _loc3_ = _loc15_.indexOf(" ",_loc6_);
               if(_loc3_ == -1)
               {
                  _loc3_ = _loc15_.length;
               }
               _loc15_ = _loc15_.substring(0,_loc6_ + 8) + _loc14_ + _loc15_.substring(_loc3_);
            }
            else
            {
               _loc15_ = _loc15_ + " colored=" + _loc14_;
            }
            _loc17_[0] = _loc15_;
            _loc4_ = new FileStream();
            _loc4_.open(_loc18_,"write");
            _loc4_.writeUTFBytes(_loc17_.join("\n"));
            _loc4_.close();
         }
         else
         {
            _loc5_ = this._list.numChildren;
            _loc4_ = new FileStream();
            _loc4_.open(_loc18_,"write");
            _loc15_ = "info creator=UIBuilder";
            if(_loc11_)
            {
               _loc15_ = _loc15_ + (" size=" + _loc11_);
            }
            if(_loc10_)
            {
               _loc15_ = _loc15_ + " resizable=true";
            }
            if(_loc14_ && !this._ttf)
            {
               _loc15_ = _loc15_ + " colored=true";
            }
            else if(!_loc14_ && this._ttf)
            {
               _loc15_ = _loc15_ + " colored=false";
            }
            _loc4_.writeUTFBytes(_loc15_ + "\n");
            if(_loc8_ != 0)
            {
               _loc15_ = "common xadvance=" + _loc8_;
               _loc4_.writeUTFBytes(_loc15_ + "\n");
            }
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc2_ = this._list.getChildAt(_loc6_).asCom;
               _loc12_ = _loc2_.name;
               _loc13_ = _loc2_.getChild("n19").text;
               if(!(!_loc12_ || !_loc13_))
               {
                  _loc9_ = parseInt(_loc2_.getChild("n20").text);
                  _loc7_ = parseInt(_loc2_.getChild("n21").text);
                  _loc19_ = parseInt(_loc2_.getChild("n22").text);
                  _loc15_ = "char id=" + String(_loc13_).charCodeAt(0) + " img=" + _loc12_ + " xoffset=" + _loc9_ + " yoffset=" + _loc7_ + " xadvance=" + _loc19_ + "\n";
                  _loc4_.writeUTFBytes(_loc15_);
               }
               _loc6_++;
            }
            _loc4_.close();
         }
         this._pi.invalidate();
         _editorWindow.mainPanel.editPanel.refreshDocument();
      }
      
      private function __drop(param1:DropEvent) : void
      {
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         var _loc5_:Object = null;
         var _loc4_:EPackageItem = null;
         if(!(param1.source is LibPanel))
         {
            return;
         }
         if(this._ttf)
         {
            return;
         }
         var _loc8_:Object = param1.sourceData;
         var _loc6_:int = _loc8_.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_)
         {
            _loc5_ = _loc8_[_loc3_];
            if(_loc5_ is TreeNode)
            {
               _loc5_ = TreeNode(_loc5_).data;
            }
            if(_loc5_ is EPackageItem)
            {
               _loc4_ = EPackageItem(_loc5_);
               if(_loc4_.type != "image")
               {
                  _editorWindow.alert(Consts.g.text78);
                  return;
               }
               if(_loc4_.owner != this._pi.owner)
               {
                  _editorWindow.alert(Consts.g.text79);
                  return;
               }
               _loc2_ = _loc4_.name.indexOf(".");
               if(_loc2_ >= 1)
               {
                  _loc7_ = _loc4_.name.charCodeAt(_loc2_ - 1);
               }
               else
               {
                  _loc7_ = _loc4_.name.charCodeAt(_loc4_.name.length - 1);
               }
               this.addChar({
                  "img":_loc4_.id,
                  "id":_loc7_,
                  "xoffset":"",
                  "yoffset":"",
                  "advance":""
               });
            }
            _loc3_++;
         }
         this.requestFocus();
      }
      
      public function handleArrowKey(param1:int, param2:Boolean, param3:Boolean) : void
      {
         this._list.handleArrowKey(param1);
      }
      
      public function handleKeyDownEvent(param1:KeyboardEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:GButton = null;
         var _loc3_:ListItemInput = null;
         if(param1.keyCode == 13)
         {
            _loc4_ = this._list.selectedIndex;
            if(_loc4_ != -1)
            {
               _loc2_ = this._list.getChildAt(_loc4_).asButton;
               _loc3_ = ListItemInput(_loc2_.getChild("n19"));
               if(_loc3_.getChild("input").displayObject != param1.target)
               {
                  _loc3_.startEditing();
                  param1.preventDefault();
               }
            }
         }
      }
   }
}

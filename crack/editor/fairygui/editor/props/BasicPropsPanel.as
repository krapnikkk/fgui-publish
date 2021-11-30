package fairygui.editor.props
{
   import fairygui.GObject;
   import fairygui.PopupMenu;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGGraph;
   import fairygui.editor.gui.EGGroup;
   import fairygui.editor.gui.EGImage;
   import fairygui.editor.gui.EGList;
   import fairygui.editor.gui.EGLoader;
   import fairygui.editor.gui.EGMovieClip;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EGRichTextField;
   import fairygui.editor.gui.EGTextField;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class BasicPropsPanel extends PropsPanel
   {
       
      
      private var _menu:PopupMenu;
      
      public function BasicPropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var btn:GObject = null;
         var xml:XML = param1;
         super.constructFromXML(xml);
         NumericInput(getChild("x")).min = -2147483648;
         NumericInput(getChild("y")).min = -2147483648;
         NumericInput(getChild("pivotX")).min = -2147483648;
         NumericInput(getChild("pivotY")).min = -2147483648;
         with(NumericInput(getChild("alpha")))
         {
            
            max = 100;
         }
         with(NumericInput(getChild("rotation")))
         {
            
            max = 180;
            min = -180;
         }
         with(NumericInput(getChild("scaleX")))
         {
            
            step = 0.1;
            fractionDigits = 2;
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("scaleY")))
         {
            
            step = 0.1;
            fractionDigits = 2;
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("pivotX")))
         {
            
            step = 0.1;
            fractionDigits = 2;
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("pivotY")))
         {
            
            step = 0.1;
            fractionDigits = 2;
            min = int.MIN_VALUE;
         }
         with(NumericInput(getChild("skewX")))
         {
            
            min = -360;
            max = 360;
         }
         with(NumericInput(getChild("skewY")))
         {
            
            min = -360;
            max = 360;
         }
         getChild("name").asLabel.getTextField().asTextInput.disableIME = true;
         this._menu = new PopupMenu();
         this._menu.addItem(Consts.g.text109,this.__clickPivotType);
         this._menu.addItem(Consts.g.text261,this.__clickPivotType);
         this._menu.addItem(Consts.g.text262,this.__clickPivotType);
         this._menu.addItem(Consts.g.text263,this.__clickPivotType);
         this._menu.addItem(Consts.g.text264,this.__clickPivotType);
         btn = getChild("n55");
         btn.addClickListener(function():void
         {
            _menu.show(btn);
         });
         getChild("title").addClickListener(this.__clickTitle);
         getChild("width").addEventListener("__submit",this.__widthHeightChanged,false,1);
         getChild("height").addEventListener("__submit",this.__widthHeightChanged,false,1);
         getChild("name").addEventListener("__submit",this.__nameChanged,false,1);
      }
      
      override public function update(param1:Vector.<EGObject>) : void
      {
         if(_object)
         {
            _object.statusDispatcher.removeListener(1,this.updateOutline);
            _object.statusDispatcher.removeListener(2,this.updateOutline);
         }
         super.update(param1);
         if(param1.length == 1)
         {
            _object.statusDispatcher.addListener(1,this.updateOutline);
            _object.statusDispatcher.addListener(2,this.updateOutline);
            getController("showRestrictSize").selectedIndex = _object.minWidth != 0 || _object.minWidth != 0 || _object.maxWidth != 0 || _object.maxHeight != 0?1:0;
         }
         else
         {
            getController("showRestrictSize").selectedIndex = 1;
         }
      }
      
      override protected function setObjectToUI() : void
      {
         this.updateOutline();
         this.updateEtc();
      }
      
      private function updateOutline() : void
      {
         if(!parent)
         {
            return;
         }
         getChild("x").text = "" + int(_object.x);
         getChild("y").text = "" + int(_object.y);
         getChild("width").text = "" + int(_object.width);
         getChild("height").text = "" + int(_object.height);
         getChild("useSourceSize").asButton.selected = _object.useSourceSize;
      }
      
      private function updateEtc() : void
      {
         var _loc1_:String = null;
         if(_objects.length == 1)
         {
            getChild("title").text = _object.getDetailString();
            getChild("icon").asLoader.url = Icons.all[_object.objectType];
         }
         else
         {
            getChild("title").text = Consts.g.text103;
            getChild("icon").asLoader.url = null;
         }
         getChild("name").text = _object.name;
         getChild("alpha").text = "" + Math.round(_object.alpha * 100);
         getChild("rotation").text = "" + _object.rotation;
         getChild("untouchable").asButton.selected = _object.untouchable;
         getChild("invisible").asButton.selected = _object.invisible;
         getChild("grayed").asButton.selected = _object.grayed;
         getChild("pivotX").text = "" + _object.pivotX;
         getChild("pivotY").text = "" + _object.pivotY;
         getChild("anchor").asButton.selected = _object.anchor;
         getChild("scaleX").text = UtilsStr.toFixed(_object.scaleX);
         getChild("scaleY").text = UtilsStr.toFixed(_object.scaleY);
         getChild("skewX").text = UtilsStr.toFixed(_object.skewX);
         getChild("skewY").text = UtilsStr.toFixed(_object.skewY);
         if(_objects.length == 1)
         {
            if(_object is EGTextField || _object is EGGroup || _object is EGRichTextField)
            {
               getChild("aspectLocked").visible = false;
            }
            else
            {
               getChild("aspectLocked").visible = true;
               getChild("aspectLocked").asButton.selected = _object.aspectLocked;
            }
            if(_object is EGTextField || _object is EGGroup || _object is EGList || _object is EGLoader || _object is EGRichTextField || _object is EGGraph)
            {
               getChild("useSourceSize").enabled = false;
            }
            else
            {
               getChild("useSourceSize").enabled = true;
            }
            if(_object is EGTextField && !(_object is EGRichTextField) || _object is EGImage || _object is EGMovieClip)
            {
               getChild("untouchable").visible = false;
            }
            else
            {
               getChild("untouchable").visible = true;
            }
            getChild("width").enabled = !_object.relations.widthLocked;
            getChild("height").enabled = !_object.relations.heightLocked;
         }
         else
         {
            getChild("aspectLocked").visible = true;
            getChild("aspectLocked").asButton.selected = _object.aspectLocked;
            getChild("useSourceSize").visible = true;
            getChild("untouchable").visible = true;
            getChild("width").enabled = true;
            getChild("height").enabled = true;
         }
         getChild("minWidth").text = "" + _object.minWidth;
         getChild("minHeight").text = "" + _object.minHeight;
         getChild("maxWidth").text = "" + _object.maxWidth;
         getChild("maxHeight").text = "" + _object.maxHeight;
      }
      
      private function __widthHeightChanged(param1:Event) : void
      {
         var _loc4_:EGObject = null;
         param1.stopImmediatePropagation();
         var _loc7_:GObject = GObject(param1.currentTarget);
         var _loc5_:String = _loc7_.text;
         var _loc6_:int = _objects.length;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = _objects[_loc3_];
            if(!(_loc4_.relations.widthLocked && _loc7_.name == "width"))
            {
               if(!(_loc4_.relations.heightLocked && _loc7_.name == "height"))
               {
                  if(_loc4_ is EGTextField && (EGTextField(_loc4_).autoSize != "none" && EGTextField(_loc4_).autoSize != "shrink"))
                  {
                     EGTextField(_loc4_).setProperty("autoSize","none");
                     _loc2_ = true;
                  }
                  _loc4_.setProperty(_loc7_.name,_loc5_);
                  if(_loc4_.aspectLocked)
                  {
                     if(_loc7_.name == "width")
                     {
                        _loc4_.setProperty("height",int(_loc5_) / _loc4_.aspectRatio);
                     }
                     else if(_loc7_.name == "height")
                     {
                        _loc4_.setProperty("width",int(_loc5_) * _loc4_.aspectRatio);
                     }
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _editorWindow.activeComDocument.setUpdateFlag();
         }
         else
         {
            this.updateOutline();
         }
      }
      
      private function __nameChanged(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:EGObject = null;
         var _loc4_:String = null;
         param1.stopImmediatePropagation();
         var _loc8_:GObject = GObject(param1.currentTarget);
         var _loc6_:String = _loc8_.text;
         var _loc7_:int = _loc6_.indexOf("#");
         if(_loc7_ == -1)
         {
            _loc2_ = _objects.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = _objects[_loc3_];
               _loc5_.setProperty("name",_loc6_);
               _editorWindow.mainPanel.childrenPanel.update(_loc5_);
               _loc3_++;
            }
         }
         else
         {
            _loc6_ = _loc6_.replace(/\#/g,"{0}");
            _loc2_ = _objects.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc5_ = _objects[_loc3_];
               _loc4_ = UtilsStr.formatString(_loc6_,_loc3_);
               _loc5_.setProperty("name",_loc4_);
               _editorWindow.mainPanel.childrenPanel.update(_loc5_);
               _loc3_++;
            }
         }
         getChild("name").text = _object.name;
      }
      
      private function __clickTitle(param1:Event) : void
      {
         if(_objects.length == 1 && _object.packageItem)
         {
            _editorWindow.mainPanel.libPanel.highlightItem(_object.packageItem);
         }
      }
      
      private function __clickPivotType(param1:ItemEvent) : void
      {
         var _loc2_:EGObject = null;
         var _loc5_:int = this._menu.list.getChildIndex(param1.itemObject);
         var _loc3_:int = _objects.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _objects[_loc4_];
            switch(int(_loc5_))
            {
               case 0:
                  _loc2_.setProperty("pivotX",0.5);
                  _loc2_.setProperty("pivotY",0.5);
                  break;
               case 1:
                  _loc2_.setProperty("pivotX",0);
                  _loc2_.setProperty("pivotY",0);
                  break;
               case 2:
                  _loc2_.setProperty("pivotX",1);
                  _loc2_.setProperty("pivotY",0);
                  break;
               case 3:
                  _loc2_.setProperty("pivotX",0);
                  _loc2_.setProperty("pivotY",1);
                  break;
               case 4:
                  _loc2_.setProperty("pivotX",1);
                  _loc2_.setProperty("pivotY",1);
            }
            _loc4_++;
         }
         this.setObjectToUI();
      }
   }
}

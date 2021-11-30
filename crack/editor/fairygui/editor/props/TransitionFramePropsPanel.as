package fairygui.editor.props
{
   import fairygui.GButton;
   import fairygui.GComboBox;
   import fairygui.GObject;
   import fairygui.GTextField;
   import fairygui.PopupMenu;
   import fairygui.UIPackage;
   import fairygui.editor.ComDocument;
   import fairygui.editor.Consts;
   import fairygui.editor.EditPanel;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.TimelineComponent;
   import fairygui.editor.extui.ColorInput;
   import fairygui.editor.extui.NumericInput;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.ETransition;
   import fairygui.editor.gui.ETransitionItem;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.event.ItemEvent;
   import fairygui.fysheji.EGDragonBone;
   import flash.events.Event;
   
   public class TransitionFramePropsPanel extends PropsPanel
   {
       
      
      public var lockUpdate:Boolean;
      
      private var _transItem:ETransitionItem;
      
      private var _menu:PopupMenu;
      
      private var actionComboBox:GComboBox;
      
      private var actionText:GTextField;
      
      public function TransitionFramePropsPanel(param1:EditorWindow, param2:String)
      {
         super(param1,param2);
      }
      
      private function __pageChanged(param1:Event) : void
      {
         this.actionText.text = "动效帧数:" + ((this._object as EGDragonBone)._basebone.aniFrameCount - 1) + " | 总帧数:" + (this._object as EGDragonBone)._basebone.aniFrameCount;
      }
      
      override protected function constructFromXML(param1:XML) : void
      {
         param1 = param1;
         var tb:GButton = null;
         var btn:GObject = null;
         var xml:XML = param1;
         super.constructFromXML(xml);
         var cb:GComboBox = getChild("easeType").asComboBox;
         cb.items = Consts.easeType;
         cb.values = Consts.easeType;
         cb.addEventListener("stateChanged",this.__easeTypeChanged);
         cb = getChild("easeInOutType").asComboBox;
         cb.items = Consts.easeInOutType;
         cb.values = Consts.easeInOutType;
         tb = getChild("tween").asButton;
         tb.addClickListener(function():void
         {
            getController("tween").selectedIndex = !!tb.selected?1:0;
         });
         NumericInput(getChild("alpha")).max = 100;
         NumericInput(getChild("volume")).max = 100;
         NumericInput(getChild("x")).min = -2147483648;
         NumericInput(getChild("y")).min = -2147483648;
         NumericInput(getChild("pivotX")).min = -2147483648;
         NumericInput(getChild("pivotY")).min = -2147483648;
         if(this.actionComboBox == null)
         {
            this.actionComboBox = UIPackage.createObject("Basic","ComboBox").asComboBox;
            this.actionComboBox.name = "aniName";
            this.actionComboBox.addEventListener("stateChanged",this.__propChanged);
            this.actionComboBox.addEventListener("stateChanged",this.__pageChanged);
            actionComboBox.x = 15;
            actionComboBox.y = 70;
            this.addChild(this.actionComboBox);
         }
         if(this.actionText == null)
         {
            this.actionText = new GTextField();
            this.actionText.color = 16777215;
            actionText.x = 15;
            actionText.y = 100;
            this.addChild(this.actionText);
         }
         with(NumericInput(getChild("rotation")))
         {
            
            min = -int.MAX_VALUE;
            max = int.MAX_VALUE;
         }
         with(NumericInput(getChild("shakePeriod")))
         {
            
            step = 0.1;
            fractionDigits = 2;
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
         with(NumericInput(getChild("repeat")))
         {
            
            step = 1;
            min = -1;
         }
         with(NumericInput(getChild("transTimes")))
         {
            
            step = 1;
            min = -1;
         }
         with(NumericInput(getChild("filter_cb")))
         {
            
            min = -1;
            max = 1;
            step = 0.01;
            fractionDigits = 2;
         }
         with(NumericInput(getChild("filter_cc")))
         {
            
            min = -1;
            max = 1;
            step = 0.01;
            fractionDigits = 2;
         }
         with(NumericInput(getChild("filter_cs")))
         {
            
            min = -1;
            max = 1;
            step = 0.01;
            fractionDigits = 2;
         }
         with(NumericInput(getChild("filter_ch")))
         {
            
            min = -1;
            max = 1;
            step = 0.01;
            fractionDigits = 2;
         }
         this._menu = new PopupMenu();
         this._menu.addItem(Consts.g.text109,this.__clickPivotType);
         this._menu.addItem(Consts.g.text261,this.__clickPivotType);
         this._menu.addItem(Consts.g.text262,this.__clickPivotType);
         this._menu.addItem(Consts.g.text263,this.__clickPivotType);
         this._menu.addItem(Consts.g.text264,this.__clickPivotType);
         btn = getChild("n126");
         btn.addClickListener(function():void
         {
            _menu.show(btn);
         });
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
         }
         this.updateFrame();
      }
      
      private function updateFrame() : void
      {
         var _loc6_:Boolean = false;
         var _loc12_:int = 0;
         var _loc7_:ETransitionItem = null;
         var _loc5_:EGObject = null;
         var _loc4_:GButton = null;
         var _loc3_:GObject = null;
         this.lockUpdate = true;
         var _loc11_:EditPanel = _editorWindow.mainPanel.editPanel;
         var _loc10_:ComDocument = _loc11_.activeDocument as ComDocument;
         var _loc8_:ETransition = _loc10_.editingTransition;
         var _loc9_:int = _loc11_.timelinePanel.head;
         var _loc1_:EGComponent = _loc10_.editingContent;
         var _loc2_:TimelineComponent = _loc11_.timelinePanel.selectedTimeline;
         if(!_loc2_)
         {
            return;
         }
         var _loc15_:int = 0;
         var _loc14_:* = _loc8_.items;
         for each(_loc7_ in _loc8_.items)
         {
            if(_loc7_.frame == _loc9_)
            {
               if(!(_loc2_.targetId != _loc7_.targetId || _loc2_.type != _loc7_.type))
               {
                  getController("c1").selectedPage = _loc7_.type;
                  this._transItem = _loc7_;
                  if(_loc7_.targetId)
                  {
                     _loc5_ = _loc1_.getChildById(_loc7_.targetId);
                  }
                  else
                  {
                     _loc5_ = _loc1_;
                  }
                  _loc4_ = getChild("tween").asButton;
                  _loc4_.selected = _loc7_.tween;
                  getController("tween").selectedIndex = !!_loc4_.selected?1:0;
                  getChild("easeType").asComboBox.value = _loc7_.easeType;
                  getChild("easeInOutType").asComboBox.value = _loc7_.easeInOutType;
                  getChild("easeInOutType").visible = _loc7_.easeType != "Linear";
                  getChild("repeat").text = "" + _loc7_.repeat;
                  getChild("yoyo").asButton.selected = _loc7_.yoyo;
                  getChild("label").text = _loc7_.label;
                  this.actionComboBox.visible = false;
                  this.actionText.visible = false;
                  var _loc13_:* = _loc7_.type;
                  if("XY" !== _loc13_)
                  {
                     if("XYV" !== _loc13_)
                     {
                        if("Size" !== _loc13_)
                        {
                           if("Pivot" !== _loc13_)
                           {
                              if("Alpha" !== _loc13_)
                              {
                                 if("Rotation" !== _loc13_)
                                 {
                                    if("Scale" !== _loc13_)
                                    {
                                       if("Skew" !== _loc13_)
                                       {
                                          if("Color" !== _loc13_)
                                          {
                                             if("Animation" !== _loc13_)
                                             {
                                                if("Sound" !== _loc13_)
                                                {
                                                   if("Transition" !== _loc13_)
                                                   {
                                                      if("Shake" !== _loc13_)
                                                      {
                                                         if("Visible" !== _loc13_)
                                                         {
                                                            if("ColorFilter" === _loc13_)
                                                            {
                                                               NumericInput(getChild("filter_cb")).value = _loc7_.value.filter_cb;
                                                               NumericInput(getChild("filter_cc")).value = _loc7_.value.filter_cc;
                                                               NumericInput(getChild("filter_ch")).value = _loc7_.value.filter_ch;
                                                               NumericInput(getChild("filter_cs")).value = _loc7_.value.filter_cs;
                                                            }
                                                         }
                                                         else
                                                         {
                                                            getChild("visible").asButton.selected = _loc7_.value.visible;
                                                         }
                                                      }
                                                      else
                                                      {
                                                         getChild("shakeAmplitude").text = "" + _loc7_.value.shakeAmplitude;
                                                         getChild("shakePeriod").text = "" + _loc7_.value.shakePeriod;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      getChild("transName").text = _loc7_.value.transName;
                                                      getChild("transTimes").text = "" + _loc7_.value.transTimes;
                                                   }
                                                }
                                                else
                                                {
                                                   getChild("sound").text = _loc7_.value.sound;
                                                   getChild("volume").text = "" + _loc7_.value.volume;
                                                }
                                             }
                                             else
                                             {
                                                if(this._object is EGDragonBone)
                                                {
                                                   _loc6_ = false;
                                                   actionComboBox.items = (this._object as EGDragonBone)._basebone.actionsName;
                                                   _loc12_ = 0;
                                                   while(_loc12_ < actionComboBox.items.length)
                                                   {
                                                      if(actionComboBox.items[_loc12_] == _loc7_.value.aniName)
                                                      {
                                                         _loc6_ = true;
                                                      }
                                                      _loc12_++;
                                                   }
                                                   if(!_loc6_)
                                                   {
                                                      _loc7_.value.aniName = actionComboBox.items[0];
                                                   }
                                                   this.actionComboBox.visible = true;
                                                   this.actionText.visible = true;
                                                   this.actionComboBox.text = _loc7_.value.aniName;
                                                   this.actionText.text = "动效帧数:" + ((this._object as EGDragonBone)._basebone.aniFrameCount - 1) + " | 总帧数:" + (this._object as EGDragonBone)._basebone.aniFrameCount;
                                                }
                                                getChild("frameEnabled").asButton.selected = _loc7_.value.aEnabled;
                                                getChild("playing").asButton.selected = _loc7_.value.playing;
                                                _loc3_ = getChild("frame");
                                                _loc3_.enabled = _loc7_.value.aEnabled;
                                                _loc3_.text = "" + _loc7_.value.frame;
                                             }
                                          }
                                          else
                                          {
                                             ColorInput(getChild("color")).argb = _loc7_.value.color;
                                          }
                                       }
                                       else
                                       {
                                          getChild("skewX").text = "" + _loc7_.value.a;
                                          getChild("skewY").text = "" + _loc7_.value.b;
                                       }
                                    }
                                    else
                                    {
                                       getChild("scaleX").text = "" + _loc7_.value.a;
                                       getChild("scaleY").text = "" + _loc7_.value.b;
                                    }
                                 }
                                 else
                                 {
                                    getChild("rotation").text = "" + _loc7_.value.rotation;
                                 }
                              }
                              else
                              {
                                 getChild("alpha").text = "" + Math.round(_loc7_.value.alpha * 100);
                              }
                           }
                           else
                           {
                              getChild("pivotX").text = "" + _loc7_.value.a;
                              getChild("pivotY").text = "" + _loc7_.value.b;
                           }
                        }
                        else
                        {
                           getChild("widthEnabled").asButton.selected = _loc7_.value.aEnabled;
                           getChild("heightEnabled").asButton.selected = _loc7_.value.bEnabled;
                           _loc3_ = getChild("width");
                           _loc3_.text = "" + int(_loc7_.value.a);
                           _loc3_.enabled = _loc7_.value.aEnabled;
                           _loc3_ = getChild("height");
                           _loc3_.text = "" + int(_loc7_.value.b);
                           _loc3_.enabled = _loc7_.value.bEnabled;
                        }
                     }
                     else
                     {
                        getChild("xEnabled").asButton.selected = _loc7_.value.aEnabled;
                        getChild("yEnabled").asButton.selected = _loc7_.value.bEnabled;
                        _loc3_ = getChild("x");
                        _loc3_.text = "" + int(_loc7_.value.a);
                        _loc3_.enabled = _loc7_.value.aEnabled;
                        _loc3_ = getChild("y");
                        _loc3_.text = "" + int(_loc7_.value.b);
                        _loc3_.enabled = _loc7_.value.bEnabled;
                     }
                  }
                  else
                  {
                     getChild("xEnabled").asButton.selected = _loc7_.value.aEnabled;
                     getChild("yEnabled").asButton.selected = _loc7_.value.bEnabled;
                     _loc3_ = getChild("x");
                     _loc3_.text = "" + int(_loc7_.value.a);
                     _loc3_.enabled = _loc7_.value.aEnabled;
                     _loc3_ = getChild("y");
                     _loc3_.text = "" + int(_loc7_.value.b);
                     _loc3_.enabled = _loc7_.value.bEnabled;
                  }
               }
            }
         }
         this.lockUpdate = false;
      }
      
      override protected function __propChanged(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc5_:String = null;
         var _loc4_:GObject = null;
         if(this.lockUpdate)
         {
            return;
         }
         var _loc8_:EditPanel = _editorWindow.mainPanel.editPanel;
         var _loc6_:ComDocument = _loc8_.activeDocument as ComDocument;
         var _loc7_:ETransition = _loc6_.editingTransition;
         var _loc2_:GObject = GObject(param1.currentTarget);
         var _loc9_:* = _loc2_.name;
         if("tween" !== _loc9_)
         {
            if("easeType" !== _loc9_)
            {
               if("easeInOutType" !== _loc9_)
               {
                  if("repeat" !== _loc9_)
                  {
                     if("yoyo" !== _loc9_)
                     {
                        if("label" !== _loc9_)
                        {
                           _loc3_ = this._transItem.value.encode(this._transItem.type);
                           _loc9_ = this._transItem.type;
                           if("XY" !== _loc9_)
                           {
                              if("XYV" !== _loc9_)
                              {
                                 if("Size" !== _loc9_)
                                 {
                                    if("Pivot" !== _loc9_)
                                    {
                                       if("Alpha" !== _loc9_)
                                       {
                                          if("Rotation" !== _loc9_)
                                          {
                                             if("Scale" !== _loc9_)
                                             {
                                                if("Skew" !== _loc9_)
                                                {
                                                   if("Color" !== _loc9_)
                                                   {
                                                      if("Animation" !== _loc9_)
                                                      {
                                                         if("Sound" !== _loc9_)
                                                         {
                                                            if("Transition" !== _loc9_)
                                                            {
                                                               if("Shake" !== _loc9_)
                                                               {
                                                                  if("Visible" !== _loc9_)
                                                                  {
                                                                     if("ColorFilter" === _loc9_)
                                                                     {
                                                                        this._transItem.value.filter_cb = NumericInput(getChild("filter_cb")).value;
                                                                        this._transItem.value.filter_cc = NumericInput(getChild("filter_cc")).value;
                                                                        this._transItem.value.filter_ch = NumericInput(getChild("filter_ch")).value;
                                                                        this._transItem.value.filter_cs = NumericInput(getChild("filter_cs")).value;
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     this._transItem.value.visible = getChild("visible").asButton.selected;
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  this._transItem.value.shakeAmplitude = NumericInput(getChild("shakeAmplitude")).value;
                                                                  this._transItem.value.shakePeriod = NumericInput(getChild("shakePeriod")).value;
                                                               }
                                                            }
                                                            else
                                                            {
                                                               this._transItem.value.transName = getChild("transName").text;
                                                               this._transItem.value.transTimes = NumericInput(getChild("transTimes")).value;
                                                            }
                                                         }
                                                         else
                                                         {
                                                            this._transItem.value.sound = getChild("sound").text;
                                                            this._transItem.value.volume = NumericInput(getChild("volume")).value;
                                                         }
                                                      }
                                                      else
                                                      {
                                                         this._transItem.value.aEnabled = getChild("frameEnabled").asButton.selected;
                                                         _loc4_ = getChild("frame");
                                                         this._transItem.value.frame = NumericInput(_loc4_).value;
                                                         _loc4_.enabled = this._transItem.value.aEnabled;
                                                         this._transItem.value.playing = getChild("playing").asButton.selected;
                                                         this._transItem.value.aniName = this.actionComboBox.text;
                                                      }
                                                   }
                                                   else
                                                   {
                                                      this._transItem.value.color = ColorInput(getChild("color")).argb;
                                                   }
                                                }
                                                else
                                                {
                                                   this._transItem.value.a = NumericInput(getChild("skewX")).value;
                                                   this._transItem.value.b = NumericInput(getChild("skewY")).value;
                                                }
                                             }
                                             else
                                             {
                                                this._transItem.value.a = NumericInput(getChild("scaleX")).value;
                                                this._transItem.value.b = NumericInput(getChild("scaleY")).value;
                                             }
                                          }
                                          else
                                          {
                                             this._transItem.value.rotation = NumericInput(getChild("rotation")).value;
                                          }
                                       }
                                       else
                                       {
                                          this._transItem.value.alpha = NumericInput(getChild("alpha")).value / 100;
                                       }
                                    }
                                    else
                                    {
                                       this._transItem.value.a = NumericInput(getChild("pivotX")).value;
                                       this._transItem.value.b = NumericInput(getChild("pivotY")).value;
                                    }
                                 }
                                 else
                                 {
                                    this._transItem.value.aEnabled = getChild("widthEnabled").asButton.selected;
                                    this._transItem.value.bEnabled = getChild("heightEnabled").asButton.selected;
                                    _loc4_ = getChild("width");
                                    this._transItem.value.a = NumericInput(_loc4_).value;
                                    _loc4_.enabled = this._transItem.value.aEnabled;
                                    _loc4_ = getChild("height");
                                    this._transItem.value.b = NumericInput(_loc4_).value;
                                    _loc4_.enabled = this._transItem.value.bEnabled;
                                 }
                              }
                              else
                              {
                                 this._transItem.value.aEnabled = getChild("xEnabled").asButton.selected;
                                 this._transItem.value.bEnabled = getChild("yEnabled").asButton.selected;
                                 _loc4_ = getChild("x");
                                 this._transItem.value.a = NumericInput(_loc4_).value;
                                 _loc4_.enabled = this._transItem.value.aEnabled;
                                 _loc4_ = getChild("y");
                                 this._transItem.value.b = NumericInput(_loc4_).value;
                                 _loc4_.enabled = this._transItem.value.bEnabled;
                              }
                           }
                           else
                           {
                              this._transItem.value.aEnabled = getChild("xEnabled").asButton.selected;
                              this._transItem.value.bEnabled = getChild("yEnabled").asButton.selected;
                              _loc4_ = getChild("x");
                              this._transItem.value.a = NumericInput(_loc4_).value;
                              _loc4_.enabled = this._transItem.value.aEnabled;
                              _loc4_ = getChild("y");
                              this._transItem.value.b = NumericInput(_loc4_).value;
                              _loc4_.enabled = this._transItem.value.bEnabled;
                           }
                           _loc5_ = this._transItem.value.encode(this._transItem.type);
                           _editorWindow.activeComDocument.actionHistory.action_transItemSet(this._transItem,null,_loc3_,_loc5_);
                           _loc7_.setCurFrame(_loc8_.timelinePanel.head);
                        }
                        else
                        {
                           _loc7_.setItemProperty(this._transItem,"label",UtilsStr.trim(_loc2_.text));
                        }
                     }
                     else
                     {
                        _loc7_.setItemProperty(this._transItem,"yoyo",GButton(_loc2_).selected);
                     }
                  }
                  else
                  {
                     _loc7_.setItemProperty(this._transItem,"repeat",NumericInput(_loc2_).value);
                  }
               }
               else
               {
                  _loc7_.setItemProperty(this._transItem,"easeInOutType",_loc2_.text);
               }
            }
            else
            {
               _loc7_.setItemProperty(this._transItem,"easeType",_loc2_.text);
            }
         }
         else
         {
            _loc7_.setItemProperty(this._transItem,"tween",_loc2_.asButton.selected);
            _loc7_.arrangeItems();
            _loc8_.timelinePanel.refreshTimeline2(this._transItem.targetId,this._transItem.type);
         }
         _loc6_.setModified();
      }
      
      private function updateOutline() : void
      {
         if(!parent)
         {
            return;
         }
         if(_object.parent == null && !this._transItem.targetId || _object.id == this._transItem.targetId)
         {
            if(this._transItem.type == "XY" || this._transItem.type == "XYV")
            {
               getChild("x").text = "" + int(this._transItem.value.a);
               getChild("y").text = "" + int(this._transItem.value.b);
            }
            if(this._transItem.type == "Size")
            {
               getChild("width").text = "" + int(this._transItem.value.a);
               getChild("height").text = "" + int(this._transItem.value.b);
            }
         }
      }
      
      private function __easeTypeChanged(param1:Event) : void
      {
         getChild("easeInOutType").visible = getChild("easeType").asComboBox.value != "Linear";
      }
      
      private function __clickPivotType(param1:ItemEvent) : void
      {
         var _loc3_:EGObject = null;
         if(this.lockUpdate)
         {
            return;
         }
         var _loc9_:EditPanel = _editorWindow.mainPanel.editPanel;
         var _loc7_:ComDocument = _loc9_.activeDocument as ComDocument;
         var _loc8_:ETransition = _loc7_.editingTransition;
         var _loc2_:EGComponent = _loc7_.editingContent;
         if(this._transItem.targetId)
         {
            _loc3_ = _loc2_.getChildById(this._transItem.targetId);
         }
         else
         {
            _loc3_ = _loc2_;
         }
         var _loc6_:String = this._transItem.value.encode(this._transItem.type);
         var _loc5_:int = this._menu.list.getChildIndex(param1.itemObject);
         switch(int(_loc5_))
         {
            case 0:
               this._transItem.value.a = 0.5;
               this._transItem.value.b = 0.5;
               break;
            case 1:
               this._transItem.value.a = 0;
               this._transItem.value.b = 0;
               break;
            case 2:
               this._transItem.value.a = 1;
               this._transItem.value.b = 0;
               break;
            case 3:
               this._transItem.value.a = 0;
               this._transItem.value.b = 1;
               break;
            case 4:
               this._transItem.value.a = 1;
               this._transItem.value.b = 1;
         }
         _loc7_.setModified();
         var _loc4_:String = this._transItem.value.encode(this._transItem.type);
         _editorWindow.activeComDocument.actionHistory.action_transItemSet(this._transItem,null,_loc6_,_loc4_);
         getChild("pivotX").text = "" + this._transItem.value.a;
         getChild("pivotY").text = "" + this._transItem.value.b;
      }
   }
}

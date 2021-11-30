package fairygui.editor.props
{
   import fairygui.GList;
   import fairygui.editor.ComDocument;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.TimelinePanel;
   import fairygui.editor.gui.ComExtention;
   import fairygui.editor.gui.EGButton;
   import fairygui.editor.gui.EGComboBox;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGGraph;
   import fairygui.editor.gui.EGGroup;
   import fairygui.editor.gui.EGImage;
   import fairygui.editor.gui.EGLabel;
   import fairygui.editor.gui.EGList;
   import fairygui.editor.gui.EGLoader;
   import fairygui.editor.gui.EGMovieClip;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EGProgressBar;
   import fairygui.editor.gui.EGRichTextField;
   import fairygui.editor.gui.EGScrollBar;
   import fairygui.editor.gui.EGSlider;
   import fairygui.editor.gui.EGSwfObject;
   import fairygui.editor.gui.EGTextField;
   import fairygui.editor.gui.EGVideo;
   import fairygui.editor.props_ext.ButtonPropsPanel;
   import fairygui.editor.props_ext.ButtonPropsPanel2;
   import fairygui.editor.props_ext.ComboBoxPropsPanel;
   import fairygui.editor.props_ext.ComboBoxPropsPanel2;
   import fairygui.editor.props_ext.LabelPropsPanel;
   import fairygui.editor.props_ext.LabelPropsPanel2;
   import fairygui.editor.props_ext.ProgressBarPropsPanel;
   import fairygui.editor.props_ext.ProgressBarPropsPanel2;
   import fairygui.editor.props_ext.ScrollBarPropsPanel2;
   import fairygui.editor.props_ext.SliderPropsPanel;
   import fairygui.editor.props_ext.SliderPropsPanel2;
   import fairygui.fysheji.DragonBonePropsPanel;
   import fairygui.fysheji.EGDragonBone;
   
   public class PropsPanelList
   {
       
      
      public var self:GList;
      
      public var propsBasic:PropsPanel;
      
      public var propsCom:PropsPanel;
      
      public var propsCom2:PropsPanel;
      
      public var propsComDesign:PropsPanel;
      
      public var propsGraph:PropsPanel;
      
      public var propsVideo:PropsPanel;
      
      public var propsText:PropsPanel;
      
      public var propsRichText:PropsPanel;
      
      public var propsList:PropsPanel;
      
      public var propsLoader:PropsPanel;
      
      public var propsGroup:PropsPanel;
      
      public var propsMovieClip:PropsPanel;
      
      public var propsSwf:PropsPanel;
      
      public var propsEtc:PropsPanel;
      
      public var propsImage:PropsPanel;
      
      public var propsEvent:PropsPanel;
      
      public var propsEffect:PropsPanel;
      
      public var propsGear:PropsPanel;
      
      public var propsButton:ButtonPropsPanel;
      
      public var propsButton2:ButtonPropsPanel2;
      
      public var propsLabel:LabelPropsPanel;
      
      public var propsLabel2:LabelPropsPanel2;
      
      public var propsComboBox:ComboBoxPropsPanel;
      
      public var propsComboBox2:ComboBoxPropsPanel2;
      
      public var propsProgressBar:ProgressBarPropsPanel;
      
      public var propsProgressBar2:ProgressBarPropsPanel2;
      
      public var propsSlider:SliderPropsPanel;
      
      public var propsSlider2:SliderPropsPanel2;
      
      public var propsScrollBar2:ScrollBarPropsPanel2;
      
      public var propsRelation:PropsPanel;
      
      public var propsTransition:TransitionPropsPanel;
      
      public var propsTransitionFrame:TransitionFramePropsPanel;
      
      public var propsBasicInTrans:BasicPropsInTransPanel;
      
      public var tweenProps:TweenPropsPanel;
      
      public var scrollProps:ScrollPropsPanel;
      
      public var marginProps:MarginPropsPanel;
      
      public var textInputProps:TextInputPropsPanel;
      
      public var listLayoutProps:ListLayoutPropsPanel;
      
      public var fillProps:FillPropsPanel;
      
      public var filterProps:FilterPropsPanel;
      
      public var playTransActionProps:PlayTransActionPropsPanel;
      
      private var _selectObject:SelectObjectPanel;
      
      private var _multiSelection:MultiSelectionPanel;
      
      private var _editorWindow:EditorWindow;
      
      private var _lastObj:EGObject;
      
      private var helperArray:Vector.<EGObject>;
      
      public var propsDragonBone:PropsPanel;
      
      public function PropsPanelList(param1:EditorWindow, param2:GList)
      {
         this.helperArray = new Vector.<EGObject>(1);
         super();
         this.self = param2;
         this._editorWindow = param1;
         this.self.removeChildren();
         this.self.scrollPane.mouseWheelEnabled = false;
         this.self.scrollItemToViewOnClick = false;
         this.propsBasic = new BasicPropsPanel(this._editorWindow,"BasicPropsPanel");
         this.propsCom = new ComPropsPanel(this._editorWindow,"ComPropsPanel");
         this.propsCom2 = new ComPropsPanel2(this._editorWindow,"ComPropsPanel2");
         this.propsComDesign = new ComDesignPropsPanel(this._editorWindow,"ComDesignPropsPanel");
         this.propsGraph = new GraphPropsPanel(this._editorWindow,"GraphPropsPanel");
         this.propsVideo = new VideoPropsPanel(this._editorWindow,"VideoPropsPanel");
         this.propsText = new TextPropsPanel(this._editorWindow,"TextPropsPanel");
         this.propsRichText = new RichTextPropsPanel(this._editorWindow,"RichTextPropsPanel");
         this.propsList = new ListPropsPanel(this._editorWindow,"ListPropsPanel");
         this.propsLoader = new LoaderPropsPanel(this._editorWindow,"LoaderPropsPanel");
         this.propsGroup = new GroupPropsPanel(this._editorWindow,"GroupPropsPanel");
         this.propsMovieClip = new MovieClipPropsPanel(this._editorWindow,"MovieClipPropsPanel");
         this.propsSwf = new SwfPropsPanel(this._editorWindow,"SwfPropsPanel");
         this.propsEtc = new EtcPropsPanel(this._editorWindow,"EtcPropsPanel");
         this.propsRelation = new RelationPropsPanel(this._editorWindow,"RelationPropsPanel");
         this.propsImage = new ImagePropsPanel(this._editorWindow,"ImagePropsPanel");
         this.propsEvent = new EventPropsPanel(this._editorWindow,"EventPropsPanel");
         this.propsEffect = new EffectPropsPanel(this._editorWindow,"EffectPropsPanel");
         this.propsGear = new GearPropsPanel(this._editorWindow,"GearPropsPanel");
         this.propsButton = new ButtonPropsPanel(this._editorWindow,"ButtonPropsPanel");
         this.propsButton2 = new ButtonPropsPanel2(this._editorWindow,"ButtonPropsPanel2");
         this.propsLabel = new LabelPropsPanel(this._editorWindow,"LabelPropsPanel");
         this.propsLabel2 = new LabelPropsPanel2(this._editorWindow,"LabelPropsPanel2");
         this.propsComboBox = new ComboBoxPropsPanel(this._editorWindow,"ComboBoxPropsPanel");
         this.propsComboBox2 = new ComboBoxPropsPanel2(this._editorWindow,"ComboBoxPropsPanel2");
         this.propsProgressBar = new ProgressBarPropsPanel(this._editorWindow,"ProgressBarPropsPanel");
         this.propsProgressBar2 = new ProgressBarPropsPanel2(this._editorWindow,"ProgressBarPropsPanel2");
         this.propsSlider = new SliderPropsPanel(this._editorWindow,"SliderPropsPanel");
         this.propsSlider2 = new SliderPropsPanel2(this._editorWindow,"SliderPropsPanel2");
         this.propsScrollBar2 = new ScrollBarPropsPanel2(this._editorWindow,"ScrollBarPropsPanel2");
         this.propsTransition = new TransitionPropsPanel(this._editorWindow,"TransitionPropsPanel");
         this.propsTransitionFrame = new TransitionFramePropsPanel(this._editorWindow,"TransitionFramePanel");
         this.propsBasicInTrans = new BasicPropsInTransPanel(this._editorWindow,"BasicPropsInTransPanel");
         this.tweenProps = new TweenPropsPanel(this._editorWindow,"TweenPropsPanel");
         this.scrollProps = new ScrollPropsPanel(this._editorWindow,"ScrollPropsPanel");
         this.marginProps = new MarginPropsPanel(this._editorWindow,"MarginPropsPanel");
         this.textInputProps = new TextInputPropsPanel(this._editorWindow,"TextInputPropsPanel");
         this.fillProps = new FillPropsPanel(this._editorWindow,"FillPropsPanel");
         this.filterProps = new FilterPropsPanel(this._editorWindow,"FilterPropsPanel");
         this.listLayoutProps = new ListLayoutPropsPanel(this._editorWindow,"ListLayoutPropsPanel");
         this.playTransActionProps = new PlayTransActionPropsPanel(this._editorWindow,"PlayTransActionPropsPanel");
         this._selectObject = new SelectObjectPanel(this._editorWindow);
         this._multiSelection = new MultiSelectionPanel(this._editorWindow);
         this.propsDragonBone = new DragonBonePropsPanel(this._editorWindow,"DragonBonePropsPanel");
      }
      
      public function refresh() : void
      {
         var _loc10_:EGComponent = null;
         var _loc15_:ComExtention = null;
         var _loc16_:EGObject = null;
         var _loc19_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc20_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:EGObject = null;
         var _loc5_:TimelinePanel = null;
         if(this._lastObj != null)
         {
            this._lastObj.propPanelScrollPos = this.self.scrollPane.posY;
            this._lastObj = null;
         }
         this.self.removeChildren();
         var _loc12_:ComDocument = this._editorWindow.activeComDocument;
         if(_loc12_ == null)
         {
            if(this.self.visible)
            {
               this.self.visible = false;
               this.self.x = this.self.x + this.self.width;
            }
            this.self.scrollPane.scrollTop();
            return;
         }
         if(!this.self.visible)
         {
            this.self.visible = true;
            this.self.x = this.self.x - this.self.width;
         }
         var _loc11_:Vector.<EGObject> = _loc12_.getSelections();
         if(_loc12_.isSelectingObject)
         {
            this.self.addChild(this._selectObject);
            this._selectObject.update(_loc11_.length == 0?_loc12_.editingContent:_loc11_[0]);
            this.self.scrollPane.scrollTop();
            return;
         }
         var _loc8_:int = _loc11_.length;
         if(_loc8_ == 0)
         {
            _loc10_ = _loc12_.editingContent;
            _loc11_ = this.helperArray;
            _loc11_[0] = _loc10_;
            this._lastObj = _loc10_;
            if(_loc10_.editingTransition != null)
            {
               this.self.addChild(this.propsTransition);
               this.propsTransition.update(_loc11_);
               this.self.addChild(this.propsBasicInTrans);
               this.propsBasicInTrans.update(_loc11_);
               if(this._editorWindow.mainPanel.editPanel.timelinePanel.onKeyFrame)
               {
                  this.self.addChild(this.propsTransitionFrame);
                  this.propsTransitionFrame.update(_loc11_);
               }
               this.self.scrollPane.scrollTop();
               return;
            }
            this.self.addChild(this.propsCom);
            this.propsCom.update(_loc11_);
            _loc15_ = _loc10_.extention;
            if(_loc15_ != null)
            {
               if(_loc15_ is EGButton)
               {
                  this.self.addChild(this.propsButton2);
                  this.propsButton2.update(_loc11_);
               }
               else if(_loc15_ is EGProgressBar)
               {
                  this.self.addChild(this.propsProgressBar2);
                  this.propsProgressBar2.update(_loc11_);
               }
               else if(_loc15_ is EGScrollBar)
               {
                  this.self.addChild(this.propsScrollBar2);
                  this.propsScrollBar2.update(_loc11_);
               }
               else if(_loc15_ is EGSlider)
               {
                  this.self.addChild(this.propsSlider2);
                  this.propsSlider2.update(_loc11_);
               }
               else if(_loc15_ is EGComboBox)
               {
                  this.self.addChild(this.propsComboBox2);
                  this.propsComboBox2.update(_loc11_);
               }
               else if(_loc15_ is EGLabel)
               {
                  this.self.addChild(this.propsLabel2);
                  this.propsLabel.update(_loc11_);
               }
               else
               {
                  this.self.addChild(this.propsButton2);
                  this.propsButton2.update(_loc11_);
               }
            }
            this.self.addChild(this.propsRelation);
            this.propsRelation.update(_loc11_);
            this.self.addChild(this.propsComDesign);
            this.propsComDesign.update(_loc11_);
            this.self.ensureBoundsCorrect();
            this.self.scrollPane.posY = _loc10_.propPanelScrollPos;
         }
         else
         {
            _loc16_ = _loc11_[0];
            this._lastObj = _loc16_;
            if(_loc12_.editingTransition != null)
            {
               this.self.addChild(this.propsTransition);
               this.propsTransition.update(_loc11_);
               this.self.addChild(this.propsBasicInTrans);
               this.propsBasicInTrans.update(_loc11_);
               _loc5_ = this._editorWindow.mainPanel.editPanel.timelinePanel;
               if(_loc5_.onKeyFrame)
               {
                  this.self.addChild(this.propsTransitionFrame);
                  this.propsTransitionFrame.update(_loc11_);
               }
               this.self.scrollPane.scrollTop();
               return;
            }
            if(_loc8_ > 1)
            {
               this.self.addChild(this._multiSelection);
               this._multiSelection.update(_loc11_);
            }
            _loc19_ = 0;
            _loc17_ = 0;
            _loc18_ = 0;
            _loc2_ = 0;
            _loc4_ = 0;
            _loc3_ = 0;
            _loc6_ = 0;
            _loc1_ = 0;
            _loc13_ = 0;
            _loc14_ = 0;
            _loc20_ = 0;
            _loc7_ = 0;
            var _loc22_:int = 0;
            var _loc21_:* = _loc11_;
            for each(_loc9_ in _loc11_)
            {
               if(_loc9_ is EGRichTextField)
               {
                  _loc17_++;
               }
               else if(_loc9_ is EGTextField)
               {
                  _loc19_++;
               }
               else if(_loc9_ is EGGraph)
               {
                  _loc3_++;
               }
               else if(_loc9_ is EGMovieClip)
               {
                  _loc2_++;
               }
               else if(_loc9_ is EGImage)
               {
                  _loc18_++;
               }
               else if(_loc9_ is EGLoader)
               {
                  _loc4_++;
               }
               else if(_loc9_ is EGGroup)
               {
                  _loc6_++;
               }
               else if(_loc9_ is EGList)
               {
                  _loc1_++;
               }
               else if(_loc9_ is EGSwfObject)
               {
                  _loc13_++;
               }
               else if(_loc9_ is EGComponent)
               {
                  _loc14_++;
               }
               else if(_loc9_ is EGVideo)
               {
                  _loc20_++;
               }
               else if(_loc9_ is EGDragonBone)
               {
                  _loc7_++;
               }
            }
            if(_loc6_ == _loc8_)
            {
               this.self.addChild(this.propsGroup);
               this.propsGroup.update(_loc11_);
               if(_loc6_ > 1 || !EGGroup(_loc16_).advanced)
               {
                  this.self.scrollPane.scrollTop();
                  return;
               }
            }
            else
            {
               this.self.addChild(this.propsBasic);
               this.propsBasic.update(_loc11_);
            }
            if(_loc17_ == _loc8_)
            {
               this.self.addChild(this.propsRichText);
               this.propsRichText.update(_loc11_);
            }
            else if(_loc19_ == _loc8_)
            {
               this.self.addChild(this.propsText);
               this.propsText.update(_loc11_);
            }
            else if(_loc3_ == _loc8_)
            {
               this.self.addChild(this.propsGraph);
               this.propsGraph.update(_loc11_);
            }
            else if(_loc20_ == _loc8_)
            {
               this.self.addChild(this.propsVideo);
               this.propsVideo.update(_loc11_);
            }
            else if(_loc7_ == _loc8_)
            {
               this.self.addChild(this.propsDragonBone);
               this.propsDragonBone.update(_loc11_);
            }
            else if(_loc1_ == _loc8_)
            {
               this.self.addChild(this.propsList);
               this.propsList.update(_loc11_);
               this.self.addChild(this.propsEvent);
               this.propsEvent.update(_loc11_);
            }
            else if(_loc4_ == _loc8_)
            {
               this.self.addChild(this.propsLoader);
               this.propsLoader.update(_loc11_);
            }
            else if(_loc13_ == _loc8_)
            {
               this.self.addChild(this.propsSwf);
               this.propsSwf.update(_loc11_);
            }
            else if(_loc2_ == _loc8_)
            {
               this.self.addChild(this.propsMovieClip);
               this.propsMovieClip.update(_loc11_);
            }
            else if(_loc18_ == _loc8_)
            {
               this.self.addChild(this.propsImage);
               this.propsImage.update(_loc11_);
            }
            else if(_loc14_ == _loc8_)
            {
               _loc15_ = EGComponent(_loc16_).extention;
               if(_loc15_ != null)
               {
                  if(_loc15_ is EGButton)
                  {
                     this.self.addChild(this.propsButton);
                     this.propsButton.update(_loc11_);
                     this.self.addChild(this.propsEvent);
                     this.propsEvent.update(_loc11_);
                  }
                  else if(_loc15_ is EGProgressBar)
                  {
                     this.self.addChild(this.propsProgressBar);
                     this.propsProgressBar.update(_loc11_);
                  }
                  else if(_loc15_ is EGSlider)
                  {
                     this.self.addChild(this.propsSlider);
                     this.propsSlider.update(_loc11_);
                  }
                  else if(_loc15_ is EGComboBox)
                  {
                     this.self.addChild(this.propsComboBox);
                     this.propsComboBox.update(_loc11_);
                  }
                  else if(_loc15_ is EGLabel)
                  {
                     this.self.addChild(this.propsLabel);
                     this.propsLabel.update(_loc11_);
                  }
                  else
                  {
                     this.self.addChild(this.propsButton);
                     this.propsButton.update(_loc11_);
                     this.self.addChild(this.propsEvent);
                     this.propsEvent.update(_loc11_);
                  }
               }
               else
               {
                  this.self.addChild(this.propsCom2);
                  this.propsCom2.update(_loc11_);
                  this.self.addChild(this.propsEvent);
                  this.propsEvent.update(_loc11_);
               }
            }
            if(_loc8_ == 1)
            {
               this.self.addChild(this.propsGear);
               this.propsGear.update(_loc11_);
               this.self.addChild(this.propsRelation);
               this.propsRelation.update(_loc11_);
               if(!(_loc16_ is EGGroup))
               {
                  this.self.addChild(this.propsEffect);
                  this.propsEffect.update(_loc11_);
               }
               if(!(_loc16_ is EGTextField) && !(_loc16_ is EGImage) && !(_loc16_ is EGMovieClip) && !(_loc16_ is EGGroup))
               {
                  this.self.addChild(this.propsEtc);
                  this.propsEtc.update(_loc11_);
               }
               this.self.ensureBoundsCorrect();
               this.self.scrollPane.posY = _loc16_.propPanelScrollPos;
            }
            else
            {
               this.self.scrollPane.scrollTop();
            }
         }
      }
   }
}

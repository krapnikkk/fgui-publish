package fairygui.editor.gui
{
   import fairygui.editor.ComDocument;
   import fairygui.editor.gui.gear.EGearBase;
   import fairygui.editor.gui.gear.EGearDisplay;
   import fairygui.utils.GTimers;
   
   public class ActionHistory
   {
       
      
      private var _doc:ComDocument;
      
      private var _undoList:Array;
      
      private var _redoList:Array;
      
      private var _batch:Array;
      
      private var _transition:ETransition;
      
      private var _enabled:Boolean;
      
      private var _handling:Boolean;
      
      private var _backupUndoList:Array;
      
      public function ActionHistory(param1:ComDocument)
      {
         super();
         this._doc = param1;
         this._undoList = [];
         this._redoList = [];
         this._batch = [];
         this._enabled = true;
      }
      
      public function reset() : void
      {
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         _loc6_ = this._undoList.length;
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc1_ = this._undoList[_loc3_];
            _loc5_ = _loc1_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc2_ = _loc1_[_loc4_];
               if(_loc2_.obj is EGObject)
               {
                  EGObject(_loc2_.obj).dispose();
               }
               _loc4_++;
            }
            _loc3_++;
         }
         _loc6_ = this._redoList.length;
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc1_ = this._redoList[_loc3_];
            _loc5_ = _loc1_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc2_ = _loc1_[_loc4_];
               if(_loc2_.obj is EGObject)
               {
                  EGObject(_loc2_.obj).dispose();
               }
               _loc4_++;
            }
            _loc3_++;
         }
         this._undoList.length = 0;
         this._redoList.length = 0;
         this._batch.length = 0;
         if(this._backupUndoList != null)
         {
            this._backupUndoList.length = 0;
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this._enabled != param1)
         {
            this.doPack();
            GTimers.inst.remove(this.pack);
            this._enabled = param1;
         }
      }
      
      public function enterTransition(param1:ETransition) : void
      {
         this.doPack();
         GTimers.inst.remove(this.pack);
         if(this._backupUndoList == null)
         {
            this._backupUndoList = [];
         }
         this._backupUndoList = this._undoList;
         this._undoList = [];
         this._transition = param1;
      }
      
      public function leaveTransition() : void
      {
         this._transition = null;
         this._undoList = this._backupUndoList;
         this._backupUndoList = null;
         this._redoList.length = 0;
         this._batch.length = 0;
         GTimers.inst.remove(this.pack);
      }
      
      public function action_propertySet(param1:EGObject, param2:String, param3:*, param4:*) : void
      {
         var _loc6_:Object = null;
         var _loc5_:int = this._batch.length - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = this._batch[_loc5_];
            if(_loc6_.type == "propertySet" && _loc6_.obj == param1 && _loc6_.name == param2)
            {
               this._batch.splice(_loc5_,1);
               param3 = _loc6_.oldValue;
            }
            _loc5_--;
         }
         if(param3 == param4)
         {
            return;
         }
         this.addAction({
            "type":"propertySet",
            "objId":param1.id,
            "name":param2,
            "oldValue":param3,
            "newValue":param4
         });
      }
      
      public function action_gearSet(param1:EGObject, param2:int, param3:String, param4:*, param5:*) : void
      {
         this.addAction({
            "type":"gearSet",
            "objId":param1.id,
            "gearIndex":param2,
            "name":param3,
            "oldValue":param4,
            "newValue":param5
         });
      }
      
      public function action_relationSet(param1:EGObject, param2:*, param3:*) : void
      {
         this.addAction({
            "type":"relationSet",
            "objId":param1.id,
            "oldValue":param2,
            "newValue":param3
         });
      }
      
      public function action_extentionSet(param1:EGObject, param2:String, param3:*, param4:*) : void
      {
         this.addAction({
            "type":"extentionSet",
            "objId":param1.id,
            "name":param2,
            "oldValue":param3,
            "newValue":param4
         });
      }
      
      public function action_controllerPageSet(param1:EController, param2:*, param3:*) : void
      {
         this.addAction({
            "type":"controllerPageSet",
            "controller":param1,
            "oldValue":param2,
            "newValue":param3
         });
      }
      
      public function action_childAdd(param1:EGObject) : void
      {
         this.addAction({
            "type":"childAdd",
            "obj":param1,
            "index":param1.parent.getChildIndex(param1)
         });
      }
      
      public function action_childDelete(param1:EGObject) : void
      {
         var _loc2_:int = this._doc.editingContent.getChildIndex(param1);
         this.addAction({
            "type":"childDelete",
            "obj":param1,
            "index":_loc2_
         });
      }
      
      public function action_childReplace(param1:EGObject, param2:EGObject) : void
      {
         this.addAction({
            "type":"childReplace",
            "source":param1,
            "target":param2
         });
      }
      
      public function action_childIndex(param1:EGObject, param2:int) : void
      {
         var _loc3_:int = this._doc.editingContent.getChildIndex(param1);
         this.addAction({
            "type":"childIndex",
            "objId":param1.id,
            "oldIndex":_loc3_,
            "newIndex":param2
         });
      }
      
      public function action_controllerSwitched(param1:EController, param2:int, param3:int) : void
      {
         this.addAction({
            "type":"controllerSwitched",
            "controller":param1,
            "oldIndex":param2,
            "newIndex":param3
         });
      }
      
      public function action_controllerChanged(param1:EController, param2:*, param3:*) : void
      {
         this.addAction({
            "type":"controllerChanged",
            "controller":param1,
            "oldValue":param2,
            "newValue":param3
         });
      }
      
      public function action_controllerAdd(param1:EController) : void
      {
         this.addAction({
            "type":"controllerAdd",
            "controller":param1
         });
      }
      
      public function action_controllerRemove(param1:EController) : void
      {
         this.addAction({
            "type":"controllerRemove",
            "controller":param1
         });
      }
      
      public function action_selectionAdd(param1:EGObject) : void
      {
         this.addAction({
            "type":"selectionAdd",
            "objId":param1.id
         });
      }
      
      public function action_selectionRemove(param1:EGObject) : void
      {
         this.addAction({
            "type":"selectionRemove",
            "objId":param1.id
         });
      }
      
      public function action_transitionsChanged(param1:EGObject, param2:*, param3:*) : void
      {
         this.addAction({
            "type":"transitionsChanged",
            "objId":param1.id,
            "oldValue":param2,
            "newValue":param3
         });
      }
      
      public function action_transitionChanged(param1:*, param2:*) : void
      {
         if(this._transition == null)
         {
            return;
         }
         this.addAction({
            "type":"transitionChanged",
            "oldValue":param1,
            "newValue":param2
         });
      }
      
      public function action_transitionSet(param1:String, param2:*, param3:*) : void
      {
         var _loc4_:Object = null;
         if(this._transition == null)
         {
            return;
         }
         var _loc5_:int = this._batch.length - 1;
         while(_loc5_ >= 0)
         {
            _loc4_ = this._batch[_loc5_];
            if(_loc4_.type == "transitionSet" && _loc4_.name == param1)
            {
               this._batch.splice(_loc5_,1);
               param2 = _loc4_.oldValue;
            }
            _loc5_--;
         }
         if(param2 == param3)
         {
            return;
         }
         this.addAction({
            "type":"transitionSet",
            "name":param1,
            "oldValue":param2,
            "newValue":param3
         });
      }
      
      public function action_transItemSet(param1:ETransitionItem, param2:String, param3:*, param4:*) : void
      {
         var _loc6_:Object = null;
         if(this._transition == null)
         {
            return;
         }
         var _loc5_:int = this._batch.length - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = this._batch[_loc5_];
            if(_loc6_.type == "transItemSet" && _loc6_.item == param1 && _loc6_.name == param2)
            {
               this._batch.splice(_loc5_,1);
               param3 = _loc6_.oldValue;
            }
            _loc5_--;
         }
         if(param3 == param4)
         {
            return;
         }
         this.addAction({
            "type":"transItemSet",
            "item":param1,
            "name":param2,
            "oldValue":param3,
            "newValue":param4
         });
      }
      
      public function action_transItemAdd(param1:ETransitionItem) : void
      {
         if(this._transition == null)
         {
            return;
         }
         this.addAction({
            "type":"transItemAdd",
            "item":param1
         });
      }
      
      public function action_transItemDelete(param1:ETransitionItem) : void
      {
         if(this._transition == null)
         {
            return;
         }
         this.addAction({
            "type":"transItemDelete",
            "item":param1
         });
      }
      
      public function action_transItemsDelete(param1:Array) : void
      {
         if(this._transition == null)
         {
            return;
         }
         this.addAction({
            "type":"transItemsDelete",
            "items":param1
         });
      }
      
      public function canUndo() : Boolean
      {
         return this._undoList.length > 0;
      }
      
      public function canRedo() : Boolean
      {
         return this._redoList.length > 0;
      }
      
      private function addAction(param1:Object) : void
      {
         if(this._handling)
         {
            return;
         }
         this._batch.push(param1);
         GTimers.inst.add(250,1,this.pack);
      }
      
      private function pack() : void
      {
         if(this._batch.length == 0 || this._doc.editorWindow.groot.buttonDown || this._doc.editorWindow.mainPanel.arrowKeyDown)
         {
            GTimers.inst.add(250,1,this.pack);
            return;
         }
         this.doPack();
      }
      
      private function doPack() : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc1_:String = null;
         this._redoList.length = 0;
         if(this._enabled)
         {
            _loc3_ = this._batch.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this._batch[_loc2_].type;
               if(_loc1_ != "selectionAdd" && _loc1_ != "selectionRemove" && _loc1_ != "controllerSwitched")
               {
                  this._doc.editingContent.setModified();
                  break;
               }
               _loc2_++;
            }
            if(this._undoList.length > 100)
            {
               this._undoList.shift();
            }
            this._undoList.push(this._batch);
         }
         this._batch = [];
      }
      
      public function undo() : Boolean
      {
         var _loc4_:Array = null;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         this._handling = true;
         while(!(this._undoList.length == 0 || !this._enabled))
         {
            _loc4_ = this._undoList.pop();
            _loc3_ = _loc4_.length;
            if(_loc3_ != 0)
            {
               this._redoList.push(_loc4_);
               _loc1_ = _loc3_ - 1;
               while(_loc1_ >= 0)
               {
                  _loc2_ = _loc4_[_loc1_];
                  if(_loc2_.type != "selectionAdd" && _loc2_.type != "selectionRemove" && _loc2_.type != "controllerSwitched")
                  {
                     this._doc.editingContent.setModified();
                  }
                  this.undoItem(_loc4_[_loc1_]);
                  _loc1_--;
               }
               this._handling = false;
               return true;
            }
         }
         this._handling = false;
         return false;
      }
      
      public function redo() : Boolean
      {
         var _loc4_:Array = null;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         this._handling = true;
         while(!(this._redoList.length == 0 || !this._enabled))
         {
            _loc4_ = this._redoList.pop();
            _loc3_ = _loc4_.length;
            if(_loc3_ != 0)
            {
               this._undoList.push(_loc4_);
               _loc1_ = 0;
               while(_loc1_ < _loc3_)
               {
                  _loc2_ = _loc4_[_loc1_];
                  if(_loc2_.type != "selectionAdd" && _loc2_.type != "selectionRemove" && _loc2_.type != "controllerSwitched")
                  {
                     this._doc.editingContent.setModified();
                  }
                  this.redoItem(_loc2_);
                  _loc1_++;
               }
               this._handling = false;
               return true;
            }
         }
         this._handling = false;
         return false;
      }
      
      private function undoItem(param1:Object) : void
      {
         var _loc5_:EGObject = null;
         var _loc3_:EGearBase = null;
         var _loc4_:int = 0;
         var _loc2_:ETransitionItem = null;
         var _loc6_:* = param1.type;
         if("propertySet" !== _loc6_)
         {
            if("gearSet" !== _loc6_)
            {
               if("relationSet" !== _loc6_)
               {
                  if("extentionSet" !== _loc6_)
                  {
                     if("controllerPageSet" !== _loc6_)
                     {
                        if("childAdd" !== _loc6_)
                        {
                           if("childDelete" !== _loc6_)
                           {
                              if("childReplace" !== _loc6_)
                              {
                                 if("childIndex" !== _loc6_)
                                 {
                                    if("selectionAdd" !== _loc6_)
                                    {
                                       if("selectionRemove" !== _loc6_)
                                       {
                                          if("controllerChanged" !== _loc6_)
                                          {
                                             if("controllerAdd" !== _loc6_)
                                             {
                                                if("controllerRemove" !== _loc6_)
                                                {
                                                   if("controllerSwitched" !== _loc6_)
                                                   {
                                                      if("transitionsChanged" !== _loc6_)
                                                      {
                                                         if("transitionChanged" !== _loc6_)
                                                         {
                                                            if("transitionSet" !== _loc6_)
                                                            {
                                                               if("transItemSet" !== _loc6_)
                                                               {
                                                                  if("transItemAdd" !== _loc6_)
                                                                  {
                                                                     if("transItemDelete" !== _loc6_)
                                                                     {
                                                                        if("transItemsDelete" === _loc6_)
                                                                        {
                                                                           this._transition.addItems(param1.items);
                                                                           this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimelines();
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        _loc2_ = param1.item;
                                                                        this._transition.addItem(_loc2_);
                                                                        this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimeline2(_loc2_.targetId,_loc2_.type);
                                                                        this._doc.setTimelineUpdateFlag();
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     _loc2_ = param1.item;
                                                                     this._transition.deleteItem(_loc2_);
                                                                     this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimeline2(_loc2_.targetId,_loc2_.type);
                                                                     this._doc.setTimelineUpdateFlag();
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  _loc2_ = param1.item;
                                                                  if(param1.name != null)
                                                                  {
                                                                     _loc2_[param1.name] = param1.oldValue;
                                                                  }
                                                                  else
                                                                  {
                                                                     _loc2_.value.decode(_loc2_.type,param1.oldValue);
                                                                  }
                                                                  if(param1.name == "targetId")
                                                                  {
                                                                     this._transition.arrangeItems();
                                                                     this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimelines();
                                                                  }
                                                                  else if(param1.name == "tween" || param1.name == "frame")
                                                                  {
                                                                     this._transition.arrangeItems();
                                                                     this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimeline2(_loc2_.targetId,_loc2_.type);
                                                                  }
                                                                  else
                                                                  {
                                                                     this._doc.editorWindow.mainPanel.editPanel.timelinePanel.selectKeyFrame(_loc2_.targetId,_loc2_.type,_loc2_.frame);
                                                                  }
                                                               }
                                                            }
                                                            else
                                                            {
                                                               this._transition[param1.name] = param1.oldValue;
                                                               if(param1.name == "name")
                                                               {
                                                                  this._doc.editorWindow.mainPanel.editPanel.updateTransitionListPanel();
                                                               }
                                                            }
                                                         }
                                                         else
                                                         {
                                                            this._transition.fromXML(param1.oldValue);
                                                            this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimelines();
                                                         }
                                                      }
                                                      else
                                                      {
                                                         _loc5_ = !!param1.objId?this._doc.editingContent.getChildById(param1.objId):this._doc.editingContent;
                                                         if(!_loc5_)
                                                         {
                                                            return;
                                                         }
                                                         (_loc5_ as EGComponent).transitions.fromXML(param1.oldValue);
                                                         this._doc.editorWindow.mainPanel.editPanel.updateTransitionListPanel();
                                                      }
                                                   }
                                                   else
                                                   {
                                                      param1.controller.selectedIndex = param1.oldIndex;
                                                      this._doc.editorWindow.mainPanel.editPanel.updateControllerSelection(param1.controller);
                                                   }
                                                }
                                                else
                                                {
                                                   this._doc.editingContent.addController(param1.controller);
                                                   this._doc.editorWindow.mainPanel.editPanel.updateControllerPanel();
                                                }
                                             }
                                             else
                                             {
                                                this._doc.editingContent.removeController(param1.controller);
                                                this._doc.editorWindow.mainPanel.editPanel.updateControllerPanel();
                                             }
                                          }
                                          else
                                          {
                                             param1.controller.fromXML(param1.oldValue);
                                             param1.controller.parent.applyController(param1.controller);
                                             this._doc.editorWindow.mainPanel.editPanel.updateControllerPanel(param1.controller);
                                          }
                                       }
                                       else
                                       {
                                          _loc5_ = this._doc.editingContent.getChildById(param1.objId);
                                          if(!_loc5_)
                                          {
                                             return;
                                          }
                                          if(_loc5_.groupInst)
                                          {
                                             this._doc.openGroup(_loc5_.groupInst);
                                          }
                                          this._doc.addSelection(_loc5_,true,true);
                                       }
                                    }
                                    else
                                    {
                                       _loc5_ = this._doc.editingContent.getChildById(param1.objId);
                                       if(!_loc5_)
                                       {
                                          return;
                                       }
                                       this._doc.removeSelection(_loc5_,true);
                                    }
                                 }
                                 else
                                 {
                                    _loc5_ = this._doc.editingContent.getChildById(param1.objId);
                                    if(!_loc5_)
                                    {
                                       return;
                                    }
                                    this._doc.editingContent.setChildIndex(_loc5_,param1.oldIndex);
                                 }
                              }
                              else
                              {
                                 _loc4_ = this._doc.editingContent.getChildIndex(param1.target);
                                 if(_loc4_ != -1)
                                 {
                                    this._doc.editingContent.removeChildAt(_loc4_);
                                    this._doc.editingContent.addChildAt(param1.source,_loc4_);
                                 }
                              }
                           }
                           else
                           {
                              _loc5_ = param1.obj;
                              this._doc.editingContent.addChildAt(_loc5_,param1.index);
                              if(_loc5_.deprecated)
                              {
                                 _loc5_.recreate();
                              }
                           }
                        }
                        else
                        {
                           _loc5_ = this._doc.editingContent.getChildById(param1.obj.id);
                           if(!_loc5_)
                           {
                              return;
                           }
                           this._doc.editingContent.removeChild(_loc5_);
                           if(_loc5_ is EGGroup)
                           {
                              this._doc.notifyGroupRemoved(EGGroup(_loc5_));
                           }
                        }
                     }
                     else
                     {
                        param1.controller.selectedPageId = param1.oldValue;
                     }
                  }
                  else
                  {
                     _loc5_ = !!param1.objId?this._doc.editingContent.getChildById(param1.objId):this._doc.editingContent;
                     if(!_loc5_)
                     {
                        return;
                     }
                     (_loc5_ as EGComponent).extention[param1.name] = param1.oldValue;
                  }
               }
               else
               {
                  _loc5_ = !!param1.objId?this._doc.editingContent.getChildById(param1.objId):this._doc.editingContent;
                  if(!_loc5_)
                  {
                     return;
                  }
                  _loc5_.relations.fromXML(param1.oldValue,_loc5_ == this._doc.editingContent);
               }
            }
            else
            {
               _loc5_ = this._doc.editingContent.getChildById(param1.objId);
               if(!_loc5_)
               {
                  return;
               }
               _loc3_ = _loc5_.getGear(param1.gearIndex);
               if(param1.name == "controller")
               {
                  _loc3_.fromXML(param1.oldValue);
                  if(_loc3_.controllerObject)
                  {
                     _loc3_.apply();
                  }
               }
               else if(param1.name == "pages")
               {
                  EGearDisplay(_loc3_).pages = param1.oldValue.split(",");
               }
               else
               {
                  _loc3_[param1.name] = param1.oldValue;
               }
            }
         }
         else
         {
            _loc5_ = !!param1.objId?this._doc.editingContent.getChildById(param1.objId):this._doc.editingContent;
            if(!_loc5_)
            {
               return;
            }
            _loc5_[param1.name] = param1.oldValue;
         }
      }
      
      private function redoItem(param1:Object) : void
      {
         var _loc5_:EGObject = null;
         var _loc3_:EGearBase = null;
         var _loc4_:int = 0;
         var _loc2_:ETransitionItem = null;
         var _loc6_:* = param1.type;
         if("propertySet" !== _loc6_)
         {
            if("gearSet" !== _loc6_)
            {
               if("relationSet" !== _loc6_)
               {
                  if("extentionSet" !== _loc6_)
                  {
                     if("controllerPageSet" !== _loc6_)
                     {
                        if("childAdd" !== _loc6_)
                        {
                           if("childDelete" !== _loc6_)
                           {
                              if("childReplace" !== _loc6_)
                              {
                                 if("childIndex" !== _loc6_)
                                 {
                                    if("selectionAdd" !== _loc6_)
                                    {
                                       if("selectionRemove" !== _loc6_)
                                       {
                                          if("controllerChanged" !== _loc6_)
                                          {
                                             if("controllerAdd" !== _loc6_)
                                             {
                                                if("controllerRemove" !== _loc6_)
                                                {
                                                   if("controllerSwitched" !== _loc6_)
                                                   {
                                                      if("transitionsChanged" !== _loc6_)
                                                      {
                                                         if("transitionChanged" !== _loc6_)
                                                         {
                                                            if("transitionSet" !== _loc6_)
                                                            {
                                                               if("transItemSet" !== _loc6_)
                                                               {
                                                                  if("transItemAdd" !== _loc6_)
                                                                  {
                                                                     if("transItemDelete" !== _loc6_)
                                                                     {
                                                                        if("transItemsDelete" === _loc6_)
                                                                        {
                                                                           this._transition.deleteItems(param1.items[0].targetId,param1.items[0].type);
                                                                           this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimelines();
                                                                        }
                                                                     }
                                                                     else
                                                                     {
                                                                        _loc2_ = param1.item;
                                                                        this._transition.deleteItem(_loc2_);
                                                                        this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimeline2(_loc2_.targetId,_loc2_.type);
                                                                        this._doc.setTimelineUpdateFlag();
                                                                     }
                                                                  }
                                                                  else
                                                                  {
                                                                     _loc2_ = param1.item;
                                                                     this._transition.addItem(_loc2_);
                                                                     this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimeline2(_loc2_.targetId,_loc2_.type);
                                                                     this._doc.setTimelineUpdateFlag();
                                                                  }
                                                               }
                                                               else
                                                               {
                                                                  _loc2_ = param1.item;
                                                                  if(param1.name != null)
                                                                  {
                                                                     _loc2_[param1.name] = param1.newValue;
                                                                  }
                                                                  else
                                                                  {
                                                                     _loc2_.value.decode(_loc2_.type,param1.newValue);
                                                                  }
                                                                  if(param1.name == "targetId")
                                                                  {
                                                                     this._transition.arrangeItems();
                                                                     this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimelines();
                                                                  }
                                                                  else if(param1.name == "tween" || param1.name == "frame")
                                                                  {
                                                                     this._transition.arrangeItems();
                                                                     this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimeline2(_loc2_.targetId,_loc2_.type);
                                                                  }
                                                                  else
                                                                  {
                                                                     this._doc.editorWindow.mainPanel.editPanel.timelinePanel.selectKeyFrame(_loc2_.targetId,_loc2_.type,_loc2_.frame);
                                                                  }
                                                               }
                                                            }
                                                            else
                                                            {
                                                               this._transition[param1.name] = param1.newValue;
                                                               if(param1.name == "name")
                                                               {
                                                                  this._doc.editorWindow.mainPanel.editPanel.updateTransitionListPanel();
                                                               }
                                                            }
                                                         }
                                                         else
                                                         {
                                                            this._transition.fromXML(param1.newValue);
                                                            this._doc.editorWindow.mainPanel.editPanel.timelinePanel.refreshTimelines();
                                                         }
                                                      }
                                                      else
                                                      {
                                                         _loc5_ = !!param1.objId?this._doc.editingContent.getChildById(param1.objId):this._doc.editingContent;
                                                         if(!_loc5_)
                                                         {
                                                            return;
                                                         }
                                                         (_loc5_ as EGComponent).transitions.fromXML(param1.newValue);
                                                         this._doc.editorWindow.mainPanel.editPanel.updateTransitionListPanel();
                                                      }
                                                   }
                                                   else
                                                   {
                                                      param1.controller.selectedIndex = param1.newIndex;
                                                      this._doc.editorWindow.mainPanel.editPanel.updateControllerSelection(param1.controller);
                                                   }
                                                }
                                                else
                                                {
                                                   this._doc.editingContent.removeController(param1.controller);
                                                   this._doc.editorWindow.mainPanel.editPanel.updateControllerPanel();
                                                }
                                             }
                                             else
                                             {
                                                this._doc.editingContent.addController(param1.controller);
                                                this._doc.editorWindow.mainPanel.editPanel.updateControllerPanel();
                                             }
                                          }
                                          else
                                          {
                                             param1.controller.fromXML(param1.newValue);
                                             param1.controller.parent.applyController(param1.controller);
                                             this._doc.editorWindow.mainPanel.editPanel.updateControllerPanel(param1.controller);
                                          }
                                       }
                                       else
                                       {
                                          _loc5_ = this._doc.editingContent.getChildById(param1.objId);
                                          if(!_loc5_)
                                          {
                                             return;
                                          }
                                          this._doc.removeSelection(_loc5_,true);
                                       }
                                    }
                                    else
                                    {
                                       _loc5_ = this._doc.editingContent.getChildById(param1.objId);
                                       if(!_loc5_)
                                       {
                                          return;
                                       }
                                       this._doc.addSelection(_loc5_,true,true);
                                    }
                                 }
                                 else
                                 {
                                    _loc5_ = this._doc.editingContent.getChildById(param1.objId);
                                    if(!_loc5_)
                                    {
                                       return;
                                    }
                                    this._doc.editingContent.setChildIndex(_loc5_,param1.newIndex);
                                 }
                              }
                              else
                              {
                                 _loc4_ = this._doc.editingContent.getChildIndex(param1.source);
                                 if(_loc4_ != -1)
                                 {
                                    this._doc.editingContent.removeChildAt(_loc4_);
                                    this._doc.editingContent.addChildAt(param1.target,_loc4_);
                                    this._doc.editingContent.notifyChildReplaced(param1.target,param1.source);
                                 }
                              }
                           }
                           else
                           {
                              _loc5_ = this._doc.editingContent.getChildById(param1.obj.id);
                              if(!_loc5_)
                              {
                                 return;
                              }
                              this._doc.editingContent.removeChild(_loc5_);
                              if(_loc5_ is EGGroup)
                              {
                                 this._doc.notifyGroupRemoved(EGGroup(_loc5_));
                              }
                           }
                        }
                        else
                        {
                           _loc5_ = param1.obj;
                           this._doc.editingContent.addChildAt(_loc5_,param1.index);
                           if(_loc5_.deprecated)
                           {
                              _loc5_.recreate();
                           }
                        }
                     }
                     else
                     {
                        param1.controller.selectedPageId = param1.newValue;
                     }
                  }
                  else
                  {
                     _loc5_ = !!param1.objId?this._doc.editingContent.getChildById(param1.objId):this._doc.editingContent;
                     if(!_loc5_)
                     {
                        return;
                     }
                     (_loc5_ as EGComponent).extention[param1.name] = param1.newValue;
                  }
               }
               else
               {
                  _loc5_ = !!param1.objId?this._doc.editingContent.getChildById(param1.objId):this._doc.editingContent;
                  if(!_loc5_)
                  {
                     return;
                  }
                  _loc5_.relations.fromXML(param1.newValue,_loc5_ == this._doc.editingContent);
               }
            }
            else
            {
               _loc5_ = this._doc.editingContent.getChildById(param1.objId);
               if(!_loc5_)
               {
                  return;
               }
               _loc3_ = _loc5_.getGear(param1.gearIndex);
               if(param1.name == "controller")
               {
                  _loc3_.fromXML(param1.newValue);
                  if(_loc3_.controllerObject)
                  {
                     _loc3_.apply();
                  }
               }
               else if(param1.name == "pages")
               {
                  EGearDisplay(_loc3_).pages = param1.newValue.split(",");
               }
               else
               {
                  _loc3_[param1.name] = param1.newValue;
               }
            }
         }
         else
         {
            _loc5_ = !!param1.objId?this._doc.editingContent.getChildById(param1.objId):this._doc.editingContent;
            if(!_loc5_)
            {
               return;
            }
            _loc5_[param1.name] = param1.newValue;
         }
      }
   }
}

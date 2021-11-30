package fairygui.editor.dialogs
{
   import fairygui.UIPackage;
   import fairygui.editor.ComDocument;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.gui.EGComponent;
   import fairygui.editor.gui.EGGraph;
   import fairygui.editor.gui.EGImage;
   import fairygui.editor.gui.EGLoader;
   import fairygui.editor.gui.EGMovieClip;
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.EGRichTextField;
   import fairygui.editor.gui.EGSwfObject;
   import fairygui.editor.gui.EGTextField;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIObjectFactory;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.fysheji.EGDragonBone;
   
   public class ExchangeDialog extends WindowBase
   {
       
      
      private var _source:Vector.<EGObject>;
      
      public function ExchangeDialog(param1:EditorWindow)
      {
         param1 = param1;
         var win:EditorWindow = param1;
         super();
         _editorWindow = win;
         this.contentPane = UIPackage.createObject("Builder","ExchangeDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         var func:Function = function(param1:String):void
         {
            contentPane.getChild("target").text = param1;
         };
         this.contentPane.getChild("text").addClickListener(function():void
         {
         });
         this.contentPane.getChild("richtext").addClickListener(function():void
         {
         });
         this.contentPane.getChild("graph").addClickListener(function():void
         {
         });
         this.contentPane.getChild("loader").addClickListener(function():void
         {
         });
         this.contentPane.getChild("ok").addClickListener(__actionHandler);
         this.contentPane.getChild("cancel").addClickListener(closeEventHandler);
      }
      
      public function open(param1:Vector.<EGObject>) : void
      {
         this._source = param1.concat();
         show();
      }
      
      override protected function onHide() : void
      {
         _editorWindow.mainPanel.editPanel.self.requestFocus();
      }
      
      override public function actionHandler() : void
      {
         var _loc6_:EGObject = null;
         var _loc8_:EGObject = null;
         var _loc4_:ComDocument = null;
         var _loc2_:int = 0;
         var _loc7_:XML = null;
         var _loc9_:EPackageItem = null;
         var _loc3_:String = contentPane.getChild("target").text;
         var _loc1_:EGComponent = this._source[0].parent;
         var _loc5_:EUIPackage = _loc1_.pkg;
         try
         {
            var _loc11_:* = this._source;
            for each(_loc8_ in this._source)
            {
               if(!UtilsStr.startsWith(_loc3_,"ui://"))
               {
                  _loc6_ = EUIObjectFactory.createObject2(_loc5_,_loc3_,_loc8_.editMode);
                  if(_loc6_ == null)
                  {
                     throw new Error("invalid object type");
                  }
               }
               else
               {
                  _loc9_ = _editorWindow.project.getItemByURL(_loc3_);
                  if(_loc9_.owner != _loc5_ && !_loc9_.exported)
                  {
                     _editorWindow.alert(Consts.g.text12);
                     return;
                  }
                  if(_loc9_.owner == _loc5_ && _loc9_.id == _loc1_.packageItem.id)
                  {
                     _editorWindow.alert(Consts.g.text76);
                     return;
                  }
                  _loc6_ = EUIObjectFactory.createObject(_loc9_,_loc8_.editMode);
                  if(_loc6_ is EGComponent && (_loc6_ as EGComponent).containsComponent(_loc1_.packageItem))
                  {
                     _loc6_.dispose();
                     _editorWindow.alert(Consts.g.text76);
                     return;
                  }
               }
               _loc4_ = _editorWindow.mainPanel.editPanel.findComDocument(_loc5_,_loc1_.packageItem.id);
               _loc2_ = _loc1_.getChildIndex(_loc8_);
               _loc7_ = _loc8_.toXML();
               _loc4_.removeSelection(_loc8_);
               _loc1_.removeChild(_loc8_);
               if(!(_loc6_ is EGComponent || _loc6_ is EGImage || _loc6_ is EGMovieClip || _loc6_ is EGSwfObject))
               {
                  _loc7_.@size = int(_loc8_.width) + "," + int(_loc8_.height);
               }
               if(_loc6_ is EGGraph)
               {
                  _loc7_.@type = "rect";
               }
               else if(_loc6_ is EGTextField || _loc6_ is EGRichTextField)
               {
                  _loc7_.@autoSize = "none";
               }
               else if(_loc6_ is EGLoader)
               {
                  if(_loc8_ is EGImage)
                  {
                     _loc7_.@url = _loc8_.resourceURL;
                  }
               }
               if(_loc6_ is EGDragonBone)
               {
                  _loc7_.@size = "0,0";
               }
               _loc6_.fromXML_beforeAdd(_loc7_);
               _loc1_.addChildAt(_loc6_,_loc2_);
               _loc6_.relations.fromXML(_loc7_);
               _loc6_.fromXML_afterAdd(_loc7_);
               _loc1_.notifyChildReplaced(_loc8_,_loc6_);
               _loc4_.actionHistory.action_childReplace(_loc8_,_loc6_);
               _loc4_.setUpdateChildrenPanelFlag();
               _loc4_.addSelection(_loc6_);
            }
            _editorWindow.mainPanel.editPanel.self.requestFocus();
         }
         catch(err:Error)
         {
            _editorWindow.alertError(err);
            return;
         }
         this.hide();
      }
   }
}

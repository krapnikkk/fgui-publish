package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.event.ItemEvent;
   import fairygui.tree.ITreeListener;
   import fairygui.tree.TreeNode;
   import fairygui.tree.TreeView;
   
   public class ChooseFolderDialog extends WindowBase implements ITreeListener
   {
       
      
      private var _treeView:TreeView;
      
      private var _treeItemUrl:String;
      
      private var _callback:Function;
      
      public function ChooseFolderDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ChooseFolderDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.modal = true;
         this._treeItemUrl = UIPackage.getItemURL("Basic","TreeItem");
         this._treeView = new TreeView(contentPane.getChild("list").asList);
         this._treeView.listener = this;
         contentPane.getChild("n40").addClickListener(__actionHandler);
         contentPane.getChild("n41").addClickListener(closeEventHandler);
      }
      
      public function open(param1:EUIPackage, param2:String, param3:Function) : void
      {
         var _loc4_:EPackageItem = null;
         var _loc5_:Vector.<EPackageItem> = null;
         var _loc6_:EPackageItem = null;
         this._callback = param3;
         this._treeView.root.removeChildren();
         var _loc7_:TreeNode = new TreeNode(true);
         _loc7_.data = param1.rootItem;
         this._treeView.root.addChild(_loc7_);
         this.addFolder(_loc7_,param1.rootItem);
         _loc7_.expanded = true;
         if(param2 != null)
         {
            _loc4_ = param1.getItem(param2);
            if(_loc4_ != null)
            {
               _loc5_ = param1.getItemPath(_loc4_);
               var _loc9_:int = 0;
               var _loc8_:* = _loc5_;
               for each(_loc6_ in _loc5_)
               {
                  _loc7_ = this.findChildNode(_loc7_,_loc6_);
                  if(_loc7_ != null)
                  {
                     _loc7_.expanded = true;
                     continue;
                  }
                  break;
               }
            }
            if(_loc7_ != null)
            {
               this._treeView.addSelection(_loc7_);
               this._treeView.list.scrollPane.scrollToView(_loc7_.cell);
            }
         }
         show();
      }
      
      override public function actionHandler() : void
      {
         var _loc2_:Function = this._callback;
         this._callback = null;
         var _loc1_:TreeNode = this._treeView.getSelectedNode();
         if(_loc1_ != null)
         {
            _loc2_(EPackageItem(_loc1_.data).id);
         }
         this.hide();
      }
      
      private function addFolder(param1:TreeNode, param2:EPackageItem) : void
      {
         var _loc5_:EPackageItem = null;
         var _loc3_:TreeNode = null;
         var _loc4_:Vector.<EPackageItem> = param2.owner.getFolderContent(param2,["folder"]);
         var _loc7_:int = 0;
         var _loc6_:* = _loc4_;
         for each(_loc5_ in _loc4_)
         {
            _loc3_ = new TreeNode(true);
            _loc3_.data = _loc5_;
            param1.addChild(_loc3_);
            if(_loc5_.type == "folder")
            {
               this.addFolder(_loc3_,_loc5_);
            }
         }
      }
      
      private function findChildNode(param1:TreeNode, param2:EPackageItem) : TreeNode
      {
         var _loc3_:TreeNode = null;
         var _loc4_:EPackageItem = null;
         var _loc5_:int = param1.numChildren;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = param1.getChildAt(_loc6_);
            _loc4_ = EPackageItem(_loc3_.data);
            if(_loc4_ == param2)
            {
               return _loc3_;
            }
            _loc6_++;
         }
         return null;
      }
      
      public function treeNodeCreateCell(param1:TreeNode) : GComponent
      {
         return this._treeView.list.getFromPool(this._treeItemUrl).asCom;
      }
      
      public function treeNodeRender(param1:TreeNode, param2:GComponent) : void
      {
         var _loc3_:GButton = param2.asButton;
         var _loc4_:EPackageItem = param1.data as EPackageItem;
         _loc3_.title = _loc4_.name;
         if(param1.isFolder)
         {
            if(_loc4_.id == "/")
            {
               _loc3_.icon = Icons.all["package"];
            }
            else
            {
               _loc3_.icon = Icons.all.folder;
            }
         }
         else
         {
            _loc3_.icon = Icons.all[_loc4_.type];
         }
      }
      
      public function treeNodeWillExpand(param1:TreeNode, param2:Boolean) : void
      {
      }
      
      public function treeNodeClick(param1:TreeNode, param2:ItemEvent) : void
      {
         if(param2.clickCount == 2)
         {
            param1.expanded = !param1.expanded;
         }
      }
   }
}

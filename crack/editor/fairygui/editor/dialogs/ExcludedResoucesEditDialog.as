package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.LibPanel;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.DropEvent;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.event.ItemEvent;
   import fairygui.tree.TreeNode;
   import flash.events.Event;
   
   public class ExcludedResoucesEditDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _itemList:GList;
      
      private var _listData:Array;
      
      public function ExcludedResoucesEditDialog(param1:EditorWindow)
      {
         param1 = param1;
         var win:EditorWindow = param1;
         super();
         _editorWindow = win;
         this.contentPane = UIPackage.createObject("Builder","ExcludedResourcesEditDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._listData = [];
         this._itemList = contentPane.getChild("n19").asList;
         this._itemList.addEventListener("__drop",this.__drop);
         this._itemList.addEventListener("itemClick",this.__clickItem);
         contentPane.getChild("n13").addClickListener(this.__save);
         contentPane.getChild("n14").addClickListener(closeEventHandler);
         contentPane.getChild("btnDelete").addClickListener(function():void
         {
            var _loc1_:int = _itemList.selectedIndex;
            if(_loc1_ != -1)
            {
               _itemList.removeChildToPoolAt(_loc1_);
               _listData.splice(_loc1_,1);
               if(_loc1_ >= _itemList.numChildren)
               {
                  _loc1_ = _itemList.numChildren - 1;
               }
               _itemList.selectedIndex = _loc1_;
            }
         });
      }
      
      public function open(param1:EUIPackage) : void
      {
         var _loc3_:GButton = null;
         this._pkg = param1;
         show();
         var _loc4_:PublishSettings = this._pkg.publishSettings;
         this._listData.length = 0;
         this._itemList.removeChildrenToPool();
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_.excludedList.length)
         {
            _loc3_ = this._itemList.addItemFromPool().asButton;
            _loc3_.text = "ui://" + this._pkg.id + _loc4_.excludedList[_loc2_];
            this._listData.push(_loc4_.excludedList[_loc2_]);
            _loc2_++;
         }
      }
      
      private function __save(param1:Event) : void
      {
         var _loc2_:PublishSettings = this._pkg.publishSettings;
         _loc2_.excludedList = this._listData.concat();
         this._pkg.save();
         this.hide();
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
               if(_loc4_.owner != this._pkg)
               {
                  _editorWindow.alert(Consts.g.text79);
                  return;
               }
               if(this._listData.indexOf(_loc4_.id) == -1)
               {
                  this._listData.push(_loc4_.id);
                  this._itemList.addItemFromPool().text = "ui://" + this._pkg.id + _loc4_.id;
               }
            }
            _loc3_++;
         }
         this.requestFocus();
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         var _loc2_:EPackageItem = null;
         if(param1.clickCount == 2)
         {
            _loc2_ = this._pkg.getItem(this._listData[this._itemList.getChildIndex(param1.itemObject)]);
            if(_loc2_)
            {
               _editorWindow.mainPanel.libPanel.highlightItem(_loc2_);
            }
         }
      }
   }
}

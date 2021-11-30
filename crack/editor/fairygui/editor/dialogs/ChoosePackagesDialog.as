package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.GTextField;
   import fairygui.UIPackage;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.extui.Icons;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.settings.WorkSpace;
   import fairygui.event.ItemEvent;
   import flash.events.Event;
   
   public class ChoosePackagesDialog extends WindowBase
   {
       
      
      private var _list:GList;
      
      private var _countText:GTextField;
      
      public function ChoosePackagesDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","ChoosePackagesDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this._list = contentPane.getChild("list").asList;
         this._list.selectionMode = 2;
         this._list.addEventListener("itemClick",this.__clickItem);
         this._countText = contentPane.getChild("count").asTextField;
         contentPane.getChild("n14").addClickListener(closeEventHandler);
         contentPane.getChild("n40").addClickListener(this.__selectAll);
         contentPane.getChild("n41").addClickListener(this.__selectNone);
      }
      
      override protected function onShown() : void
      {
         var _loc3_:EUIPackage = null;
         var _loc1_:GButton = null;
         var _loc5_:Vector.<EUIPackage> = _editorWindow.project.getPackageList();
         this._list.removeChildrenToPool();
         var _loc4_:Array = _editorWindow.project.settingsCenter.workspace.hidden_packages;
         var _loc2_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:* = _loc5_;
         for each(_loc3_ in _loc5_)
         {
            _loc1_ = this._list.addItemFromPool().asButton;
            _loc1_.icon = Icons.all["package"];
            _loc1_.title = _loc3_.name;
            _loc1_.name = _loc3_.id;
            _loc1_.selected = _loc4_.indexOf(_loc3_.id) == -1;
            if(_loc1_.selected)
            {
               _loc2_++;
            }
         }
         this._countText.text = _loc2_ + "/" + _loc5_.length;
      }
      
      private function __clickItem(param1:ItemEvent) : void
      {
         this.applyChange();
      }
      
      private function __selectAll(param1:Event) : void
      {
         this._list.selectAll();
         this.applyChange();
      }
      
      private function __selectNone(param1:Event) : void
      {
         this._list.selectNone();
         this.applyChange();
      }
      
      private function applyChange() : void
      {
         var _loc2_:GButton = null;
         var _loc6_:WorkSpace = _editorWindow.project.settingsCenter.workspace;
         var _loc5_:Array = _loc6_.hidden_packages;
         _loc5_.length = 0;
         var _loc3_:int = this._list.numChildren;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this._list.getChildAt(_loc1_).asButton;
            if(!_loc2_.selected)
            {
               _loc5_.push(_loc2_.name);
            }
            else
            {
               _loc4_++;
            }
            _loc1_++;
         }
         _loc6_.hidden_packages = _loc5_;
         _editorWindow.mainPanel.libPanel.updatePackages();
         this._countText.text = _loc4_ + "/" + _loc3_;
      }
   }
}

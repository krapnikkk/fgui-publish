package fairygui.editor.dialogs
{
   import fairygui.GComboBox;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.settings.ImageSetting;
   import flash.events.Event;
   
   public class MultiImageEditDialog extends WindowBase
   {
       
      
      private var _items:Vector.<EPackageItem>;
      
      public function MultiImageEditDialog(param1:EditorWindow)
      {
         var _loc2_:GComboBox = null;
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","MultiImageEditDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         _loc2_ = contentPane.getChild("n18").asComboBox;
         _loc2_.items = [Consts.g.text82,Consts.g.text83,Consts.g.text84];
         _loc2_.values = ["default","source","custom"];
         _loc2_.addEventListener("stateChanged",this.__qualityChanged);
         _loc2_ = contentPane.getChild("n33").asComboBox;
         _loc2_.items = [Consts.g.text161,Consts.g.text162];
         _loc2_.values = ["false","true"];
         this.contentPane.getChild("n21").addClickListener(this.__action);
         this.contentPane.getChild("n23").addClickListener(closeEventHandler);
      }
      
      public function open(param1:Vector.<EPackageItem>) : void
      {
         this._items = param1;
         contentPane.getController("c1").selectedIndex = 0;
         contentPane.getChild("n18").asComboBox.selectedIndex = 0;
         contentPane.getChild("n25").text = "";
         var _loc2_:GComboBox = contentPane.getChild("n20").asComboBox;
         this._items[0].owner.publishSettings.fillCombo(_loc2_,this._items[0].owner);
         _loc2_.selectedIndex = 0;
         this.__qualityChanged(null);
         contentPane.getChild("n33").asComboBox.value = "true";
         contentPane.getChild("n39").asButton.selected = false;
         contentPane.getChild("n40").asButton.selected = false;
         contentPane.getChild("n41").asButton.selected = false;
         contentPane.getChild("n42").asButton.selected = false;
         show();
      }
      
      private function apply(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:EPackageItem = null;
         var _loc2_:ImageSetting = null;
         var _loc5_:int = this._items.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = this._items[_loc3_];
            if(!(_loc4_.type != "image" && _loc4_.type != "movieclip"))
            {
               _loc2_ = _loc4_.imageSetting;
               if(contentPane.getChild("n42").asButton.selected)
               {
                  _loc2_.atlas = contentPane.getChild("n20").asComboBox.value;
               }
               if(contentPane.getChild("n39").asButton.selected)
               {
                  _loc2_.scaleOption = contentPane.getController("c1").selectedPage;
               }
               if(contentPane.getChild("n40").asButton.selected)
               {
                  _loc2_.smoothing = contentPane.getChild("n33").asComboBox.selectedIndex == 1;
               }
               if(contentPane.getChild("n41").asButton.selected)
               {
                  _loc2_.qualityOption = contentPane.getChild("n18").asComboBox.value;
                  _loc2_.quality = parseInt(contentPane.getChild("n25").text);
               }
            }
            _loc3_++;
         }
         this._items[0].owner.save();
         hide();
         _editorWindow.mainPanel.editPanel.refreshDocument();
      }
      
      private function __action(param1:Event) : void
      {
         this.apply(true);
      }
      
      private function __apply(param1:Event) : void
      {
         this.apply(false);
      }
      
      private function __qualityChanged(param1:Event) : void
      {
         contentPane.getChild("n25").enabled = contentPane.getChild("n18").asComboBox.selectedIndex == 2;
      }
   }
}

package fairygui.editor.dialogs
{
   import fairygui.GButton;
   import fairygui.GList;
   import fairygui.UIPackage;
   import fairygui.editor.Consts;
   import fairygui.editor.EditorWindow;
   import fairygui.editor.WindowBase;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.settings.AtlasSettings;
   import fairygui.editor.settings.PublishSettings;
   import flash.events.Event;
   
   public class AtlasSettingsDialog extends WindowBase
   {
       
      
      private var _pkg:EUIPackage;
      
      private var _list:GList;
      
      private var _compression:GButton;
      
      public function AtlasSettingsDialog(param1:EditorWindow)
      {
         super();
         _editorWindow = param1;
         this.contentPane = UIPackage.createObject("Builder","AtlasSettingsDialog").asCom;
         this.centerOn(_editorWindow.groot,true);
         this.modal = true;
         this._list = contentPane.getChild("list").asList;
         this._list.selectionMode = 3;
         this._compression = contentPane.getChild("header").asCom.getChild("compression").asButton;
         this._compression.addEventListener("stateChanged",this.__compressionChanged);
         contentPane.getChild("ok").addClickListener(this.__save);
         contentPane.getChild("cancel").addClickListener(closeEventHandler);
      }
      
      public function open(param1:EUIPackage) : void
      {
         var _loc2_:Boolean = false;
         var _loc5_:AtlasSettings = null;
         var _loc4_:GButton = null;
         this._pkg = param1;
         var _loc8_:PublishSettings = param1.publishSettings;
         var _loc6_:AtlasSettings = _loc8_.atlasList[0];
         if(PlugInManager.EX1024)
         {
            contentPane.getChild("maxAtlasSize").asComboBox.items = [256,512,1024];
         }
         else
         {
            contentPane.getChild("maxAtlasSize").asComboBox.items = [256,512,1024,2048,4096,8196];
         }
         contentPane.getChild("maxAtlasSize").asComboBox.value = "" + _loc6_.maxWidth;
         contentPane.getChild("npot").asButton.selected = !_loc6_.pot;
         contentPane.getChild("square").asButton.selected = _loc6_.square;
         contentPane.getChild("rotation").asButton.selected = _loc6_.rotation;
         contentPane.getChild("extractAlpha").asButton.selected = _loc6_.extractAlpha;
         contentPane.getChild("multiPage").asButton.selected = _loc6_.multiPage;
         var _loc7_:Vector.<AtlasSettings> = _loc8_.atlasList;
         this._list.removeChildrenToPool();
         var _loc3_:int = 0;
         while(_loc3_ < _loc7_.length)
         {
            _loc5_ = _loc7_[_loc3_];
            _loc4_ = this._list.addItemFromPool().asButton;
            _loc4_.getChild("index").text = "" + _loc3_;
            if(_loc3_ == 0 && !_loc5_.name)
            {
               _loc4_.getChild("name").text = Consts.g.text80;
            }
            else
            {
               _loc4_.getChild("name").text = _loc5_.name;
            }
            _loc4_.getChild("compression").asButton.selected = _loc5_.compression;
            if(!_loc5_.compression)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         this._compression.selected = !_loc2_;
         show();
      }
      
      private function __save(param1:Event) : void
      {
         var _loc6_:AtlasSettings = null;
         var _loc5_:GButton = null;
         var _loc12_:PublishSettings = this._pkg.publishSettings;
         var _loc10_:int = parseInt(contentPane.getChild("maxAtlasSize").asComboBox.value);
         var _loc11_:* = !contentPane.getChild("npot").asButton.selected;
         var _loc2_:Boolean = contentPane.getChild("square").asButton.selected;
         var _loc4_:Boolean = contentPane.getChild("rotation").asButton.selected;
         var _loc9_:Boolean = contentPane.getChild("extractAlpha").asButton.selected;
         var _loc8_:Boolean = contentPane.getChild("multiPage").asButton.selected;
         var _loc7_:Vector.<AtlasSettings> = _loc12_.atlasList;
         var _loc3_:int = 0;
         while(_loc3_ < _loc7_.length)
         {
            _loc6_ = _loc7_[_loc3_];
            _loc5_ = this._list.getChildAt(_loc3_).asButton;
            _loc6_.name = _loc5_.getChild("name").text;
            var _loc13_:* = _loc10_;
            _loc6_.maxHeight = _loc13_;
            _loc6_.maxWidth = _loc13_;
            _loc6_.pot = _loc11_;
            _loc6_.square = _loc2_;
            _loc6_.rotation = _loc4_;
            _loc6_.extractAlpha = _loc9_;
            _loc6_.compression = _loc5_.getChild("compression").asButton.selected;
            _loc6_.multiPage = _loc8_;
            _loc3_++;
         }
         this._pkg.save();
         this.hide();
      }
      
      private function __compressionChanged(param1:Event) : void
      {
         var _loc5_:Boolean = GButton(param1.currentTarget).selected;
         var _loc3_:PublishSettings = this._pkg.publishSettings;
         var _loc4_:Vector.<AtlasSettings> = _loc3_.atlasList;
         var _loc2_:int = 0;
         while(_loc2_ < _loc4_.length)
         {
            this._list.getChildAt(_loc2_).asCom.getChild("compression").asButton.selected = _loc5_;
            _loc2_++;
         }
      }
   }
}

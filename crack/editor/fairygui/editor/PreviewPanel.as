package fairygui.editor
{
   import fairygui.GButton;
   import fairygui.GComponent;
   import fairygui.GGraph;
   import fairygui.editor.gui.EGLoader;
   import fairygui.editor.gui.EPackageItem;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PreviewPanel
   {
       
      
      public var self:GComponent;
      
      private var _container:Sprite;
      
      private var _item:EPackageItem;
      
      private var _holder:GGraph;
      
      private var _editorWindow:EditorWindow;
      
      private var _previewLoader:EGLoader;
      
      private var _titleBar:GButton;
      
      public function PreviewPanel(param1:EditorWindow, param2:GComponent)
      {
         super();
         this.self = param2;
         this._editorWindow = param1;
         this._container = new Sprite();
         this._holder = this.self.getChild("holder").asGraph;
         this._holder.setNativeObject(this._container);
         this._previewLoader = new EGLoader();
         this._previewLoader.fill = "scaleFree";
         this._previewLoader.useToPreview = true;
         this._previewLoader.align = "center";
         this._previewLoader.verticalAlign = "middle";
         this._previewLoader.setSize(this._holder.width,this._holder.height);
         this._container.addChild(this._previewLoader.displayObject);
         this._titleBar = this.self.getChild("titleBar").asButton;
         this._titleBar.addEventListener("stateChanged",this.__expandStateChanged);
      }
      
      public function refresh(param1:Boolean = false) : void
      {
         var _loc2_:EPackageItem = this._editorWindow.mainPanel.libPanel.getSelectedItem();
         if(_loc2_ != null)
         {
            if(_loc2_.type == "folder")
            {
               return;
            }
            if(this._item == _loc2_ && !param1)
            {
               return;
            }
            this.open(_loc2_);
         }
         else if(this._item != null)
         {
            this.clear();
         }
      }
      
      private function open(param1:EPackageItem) : void
      {
         this.clear();
         this._item = param1;
         this._previewLoader.pkg = this._item.owner;
         if(this._item.type == "image" || this._item.type == "movieclip" || this._item.type == "swf" || this._item.type == "dragonbone")
         {
            this._previewLoader.url = "ui://" + this._item.owner.id + this._item.id;
            this.self.getChild("desc").text = this._item.width + "x" + this._item.height;
         }
         else if(this._item.type == "font")
         {
            this._previewLoader.url = this._item.owner.getBitmapFont(this._item).getPreviewURL();
            this.self.getChild("desc").text = "";
         }
         else
         {
            this._previewLoader.url = null;
            this.self.getChild("desc").text = "";
         }
      }
      
      private function clear() : void
      {
         this._previewLoader.url = null;
         this.self.getChild("desc").text = "";
         this._item = null;
      }
      
      public function set expanded(param1:Boolean) : void
      {
         this.self.getChild("expandButton").asButton.selected = !param1;
         this.__expandStateChanged(null);
      }
      
      public function get expanded() : Boolean
      {
         return !this.self.getChild("expandButton").asButton.selected;
      }
      
      private function __clickTitleBar(param1:Event) : void
      {
         this.expanded = !this.expanded;
      }
      
      private function __expandStateChanged(param1:Event) : void
      {
         if(this._titleBar.selected)
         {
            this.self.height = this._titleBar.height;
         }
         else
         {
            this.self.height = this.self.initHeight;
         }
      }
   }
}

package fairygui.editor.settings
{
   import fairygui.editor.Consts;
   import fairygui.editor.utils.UtilsStr;
   
   public class CommonSettings extends ISerializedSettings
   {
       
      
      public var font:String;
      
      public var fontSize:int;
      
      public var textColor:uint;
      
      public var fontAdjustment:Boolean;
      
      public var colorScheme:Array;
      
      public var fontSizeScheme:Array;
      
      public var horizontalScrollBar:String;
      
      public var verticalScrollBar:String;
      
      public var defaultScrollBarDisplay:String;
      
      public var tipsRes:String;
      
      public var buttonClickSound:String;
      
      public function CommonSettings()
      {
         super();
         _fileName = "Common";
         this.colorScheme = [];
         this.fontSizeScheme = [];
      }
      
      override public function load() : void
      {
         var _loc2_:Object = loadFile();
         this.font = _loc2_.font;
         this.fontSize = _loc2_.fontSize;
         this.textColor = UtilsStr.convertFromHtmlColor(_loc2_.textColor);
         if(_loc2_.fontAdjustment != undefined && _project.isH5)
         {
            this.fontAdjustment = _loc2_.fontAdjustment;
         }
         else
         {
            this.fontAdjustment = true;
         }
         if(!this.font)
         {
            this.font = "_sans";
         }
         if(this.fontSize == 0)
         {
            this.fontSize = 12;
         }
         this.colorScheme = _loc2_.colorScheme;
         if(!this.colorScheme)
         {
            this.colorScheme = [Consts.g.text118 + " #FF0000"];
         }
         this.fontSizeScheme = _loc2_.fontSizeScheme;
         if(!this.fontSizeScheme)
         {
            this.fontSizeScheme = [Consts.g.text119 + " 30"];
         }
         var _loc1_:Object = _loc2_.scrollBars;
         if(_loc1_)
         {
            this.verticalScrollBar = _loc1_.vertical;
            this.horizontalScrollBar = _loc1_.horizontal;
            this.defaultScrollBarDisplay = _loc1_.defaultDisplay;
            if(!this.defaultScrollBarDisplay)
            {
               this.defaultScrollBarDisplay = "visible";
            }
         }
         else
         {
            this.defaultScrollBarDisplay = "visible";
         }
         this.tipsRes = _loc2_.tipsRes;
         this.buttonClickSound = _loc2_.buttonClickSound;
      }
      
      override public function save() : void
      {
         var _loc2_:Object = {};
         _loc2_.font = this.font;
         _loc2_.fontSize = this.fontSize;
         _loc2_.textColor = UtilsStr.convertToHtmlColor(this.textColor);
         if(!this.fontAdjustment && _project.isH5)
         {
            _loc2_.fontAdjustment = this.fontAdjustment;
         }
         _loc2_.colorScheme = this.colorScheme;
         _loc2_.fontSizeScheme = this.fontSizeScheme;
         var _loc1_:Object = {};
         _loc2_.scrollBars = _loc1_;
         _loc1_.vertical = this.verticalScrollBar;
         _loc1_.horizontal = this.horizontalScrollBar;
         _loc1_.defaultDisplay = this.defaultScrollBarDisplay;
         _loc2_.tipsRes = this.tipsRes;
         _loc2_.buttonClickSound = this.buttonClickSound;
         saveFile(_loc2_);
         _project.editorWindow.colorPresetMenu.needUpdate = true;
         _project.editorWindow.fontSizePresetMenu.needUpdate = true;
      }
   }
}

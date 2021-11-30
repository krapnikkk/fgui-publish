package fairygui.editor.settings
{
   import fairygui.editor.Consts;
   import fairygui.editor.api.IUIProject;
   import fairygui.editor.gui.ScrollBarDisplayConst;
   import fairygui.utils.UtilsStr;
   
   public class CommonSettings extends SettingsBase
   {
       
      
      public var font:String;
      
      public var fontSize:int;
      
      public var textColor:uint;
      
      public var fontAdjustment:Boolean;
      
      public var colorScheme:Array;
      
      public var fontSizeScheme:Array;
      
      public var fontScheme:Array;
      
      public var horizontalScrollBar:String;
      
      public var verticalScrollBar:String;
      
      public var defaultScrollBarDisplay:String;
      
      public var tipsRes:String;
      
      public var buttonClickSound:String;
      
      public var pivot:String;
      
      public function CommonSettings(param1:IUIProject)
      {
         super(param1);
         _fileName = "Common";
         this.colorScheme = [];
         this.fontSizeScheme = [];
         this.fontScheme = [];
         this.pivot = "default";
      }
      
      override protected function read(param1:Object) : void
      {
         this.font = param1.font;
         this.fontSize = param1.fontSize;
         this.textColor = UtilsStr.convertFromHtmlColor(param1.textColor);
         if(param1.fontAdjustment != undefined && _project.isH5)
         {
            this.fontAdjustment = param1.fontAdjustment;
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
         this.colorScheme = param1.colorScheme;
         if(!this.colorScheme)
         {
            this.colorScheme = [Consts.strings.text118 + " #FF0000"];
         }
         this.fontSizeScheme = param1.fontSizeScheme;
         if(!this.fontSizeScheme)
         {
            this.fontSizeScheme = [Consts.strings.text119 + " 30"];
         }
         this.fontScheme = param1.fontScheme;
         if(!this.fontScheme)
         {
            this.fontScheme = [Consts.strings.text343];
         }
         var _loc2_:Object = param1.scrollBars;
         if(_loc2_)
         {
            this.verticalScrollBar = _loc2_.vertical;
            this.horizontalScrollBar = _loc2_.horizontal;
            this.defaultScrollBarDisplay = _loc2_.defaultDisplay;
            if(!this.defaultScrollBarDisplay)
            {
               this.defaultScrollBarDisplay = ScrollBarDisplayConst.VISIBLE;
            }
         }
         else
         {
            this.defaultScrollBarDisplay = ScrollBarDisplayConst.VISIBLE;
         }
         this.tipsRes = param1.tipsRes;
         this.buttonClickSound = param1.buttonClickSound;
         this.pivot = param1.pivot;
         if(!this.pivot)
         {
            this.pivot = "default";
         }
      }
      
      override protected function write() : Object
      {
         var _loc1_:Object = {};
         _loc1_.font = this.font;
         _loc1_.fontSize = this.fontSize;
         _loc1_.textColor = UtilsStr.convertToHtmlColor(this.textColor);
         if(!this.fontAdjustment && _project.isH5)
         {
            _loc1_.fontAdjustment = this.fontAdjustment;
         }
         _loc1_.colorScheme = this.colorScheme;
         _loc1_.fontSizeScheme = this.fontSizeScheme;
         _loc1_.fontScheme = this.fontScheme;
         var _loc2_:Object = {};
         _loc1_.scrollBars = _loc2_;
         _loc2_.vertical = this.verticalScrollBar;
         _loc2_.horizontal = this.horizontalScrollBar;
         _loc2_.defaultDisplay = this.defaultScrollBarDisplay;
         _loc1_.tipsRes = this.tipsRes;
         _loc1_.buttonClickSound = this.buttonClickSound;
         _loc1_.pivot = this.pivot;
         _project.setVar("ColorPresetMenu",undefined);
         _project.setVar("FontPresetMenu",undefined);
         _project.setVar("FontSizePresetMenu",undefined);
         return _loc1_;
      }
   }
}

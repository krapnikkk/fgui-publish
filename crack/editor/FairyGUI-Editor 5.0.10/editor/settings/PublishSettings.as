package fairygui.editor.settings
{
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   
   public class PublishSettings
   {
       
      
      private var _path:String;
      
      private var _fileName:String;
      
      private var _packageCount:int;
      
      private var _genCode:Boolean;
      
      private var _codePath:String;
      
      private var §_-LC§:String;
      
      public var useGlobalAtlasSettings:Boolean;
      
      private var _atlasList:Vector.<AtlasSettings>;
      
      private var _excludedList:Vector.<String>;
      
      public function PublishSettings()
      {
         super();
         this._atlasList = new Vector.<AtlasSettings>();
         this._excludedList = new Vector.<String>();
      }
      
      public function get fileName() : String
      {
         return this._fileName;
      }
      
      public function set fileName(param1:String) : void
      {
         this._fileName = param1;
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function set path(param1:String) : void
      {
         this._path = param1;
      }
      
      public function get branchPath() : String
      {
         return this.§_-LC§;
      }
      
      public function set branchPath(param1:String) : void
      {
         this.§_-LC§ = param1;
      }
      
      public function get packageCount() : int
      {
         return this._packageCount;
      }
      
      public function set packageCount(param1:int) : void
      {
         this._packageCount = param1;
      }
      
      public function get genCode() : Boolean
      {
         return this._genCode;
      }
      
      public function set genCode(param1:Boolean) : void
      {
         this._genCode = param1;
      }
      
      public function get codePath() : String
      {
         return this._codePath;
      }
      
      public function set codePath(param1:String) : void
      {
         this._codePath = param1;
      }
      
      public function get excludedList() : Vector.<String>
      {
         return this._excludedList;
      }
      
      public function get atlasList() : Vector.<AtlasSettings>
      {
         return this._atlasList;
      }
      
      public function fillCombo(param1:GComboBox) : void
      {
         var _loc2_:Array = param1.items;
         var _loc3_:Array = param1.values;
         _loc2_.length = 0;
         _loc3_.length = 0;
         _loc2_.push(Consts.strings.text80,Consts.strings.text81,Consts.strings.text81 + "(NPOT)",Consts.strings.text81 + "(" + Consts.strings.text439 + ")");
         _loc3_.push("default","alone","alone_npot","alone_mof");
         var _loc4_:int = 0;
         while(_loc4_ < this._atlasList.length)
         {
            if(this._atlasList[_loc4_].name)
            {
               _loc2_.push(_loc4_ + ": " + this._atlasList[_loc4_].name);
            }
            else
            {
               _loc2_.push("" + _loc4_);
            }
            _loc3_.push("" + _loc4_);
            _loc4_++;
         }
         param1.items = _loc2_;
         param1.values = _loc3_;
         param1.visibleItemCount = 20;
      }
   }
}

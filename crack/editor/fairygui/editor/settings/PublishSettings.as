package fairygui.editor.settings
{
   import fairygui.GComboBox;
   import fairygui.editor.Consts;
   import fairygui.editor.gui.EUIPackage;
   
   public class PublishSettings
   {
       
      
      public var filePath:String;
      
      public var fileName:String;
      
      public var packageCount:int;
      
      public var genCode:Boolean;
      
      public var atlasList:Vector.<AtlasSettings>;
      
      public var excludedList:Array;
      
      public function PublishSettings()
      {
         var _loc1_:AtlasSettings = null;
         super();
         this.atlasList = new Vector.<AtlasSettings>(11);
         var _loc2_:int = 0;
         while(_loc2_ < this.atlasList.length)
         {
            _loc1_ = new AtlasSettings();
            _loc1_.name = "";
            this.atlasList[_loc2_] = _loc1_;
            _loc2_++;
         }
         this.excludedList = [];
      }
      
      public function fillCombo(param1:GComboBox, param2:EUIPackage) : void
      {
         var _loc5_:Array = param1.items;
         var _loc6_:Array = param1.values;
         var _loc3_:Vector.<AtlasSettings> = param2.publishSettings.atlasList;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].name)
            {
               _loc5_[_loc4_] = _loc4_ + ":" + _loc3_[_loc4_].name;
            }
            else if(_loc4_ == 0)
            {
               _loc5_[_loc4_] = Consts.g.text80;
            }
            else
            {
               _loc5_[_loc4_] = _loc4_;
            }
            _loc6_[_loc4_] = "" + _loc4_;
            _loc4_++;
         }
         _loc5_.splice(1,0,Consts.g.text81,Consts.g.text81 + "(NPOT)");
         _loc6_.splice(1,0,"alone","alone_npot");
         _loc5_.length = _loc3_.length + 2;
         _loc6_.length = _loc3_.length + 2;
         param1.items = _loc5_;
         param1.values = _loc6_;
         param1.visibleItemCount = 2147483647;
      }
   }
}

package fairygui.editor.settings
{
   import fairygui.GComboBox;
   
   public class AdaptationSettings extends ISerializedSettings
   {
       
      
      public var scaleMode:String;
      
      public var screenMathMode:String;
      
      public var designResolutionX:int;
      
      public var designResolutionY:int;
      
      public var defaultResolution:String;
      
      public var resolutions:Array;
      
      public function AdaptationSettings()
      {
         super();
         _fileName = "Adaptation";
         this.resolutions = [{
            "name":"iPhone 5",
            "isMobile":true,
            "resolutionX":1136,
            "resolutionY":640
         },{
            "name":"iPhone 6/7/8",
            "isMobile":true,
            "resolutionX":1334,
            "resolutionY":750
         },{
            "name":"iPhone 6/7/8 Plus",
            "isMobile":true,
            "resolutionX":1920,
            "resolutionY":1080
         },{
            "name":"iPhone X",
            "isMobile":true,
            "resolutionX":2436,
            "resolutionY":1125
         },{
            "name":"iPad",
            "isMobile":true,
            "resolutionX":1024,
            "resolutionY":768
         },{
            "name":"720p Phone",
            "isMobile":true,
            "resolutionX":1280,
            "resolutionY":720
         },{
            "name":"1080p Phone",
            "isMobile":true,
            "resolutionX":1920,
            "resolutionY":1080
         },{
            "name":"华为 Mate9",
            "isMobile":true,
            "resolutionX":2560,
            "resolutionY":1440
         },{
            "name":"小米 MIX2",
            "isMobile":true,
            "resolutionX":2160,
            "resolutionY":1080
         },{
            "name":"三星 S8",
            "isMobile":true,
            "resolutionX":2960,
            "resolutionY":1440
         },{
            "name":"LG G6",
            "isMobile":true,
            "resolutionX":2880,
            "resolutionY":1440
         },{
            "name":"1080p PC",
            "isMobile":false,
            "resolutionX":1920,
            "resolutionY":1080
         }];
      }
      
      override public function load() : void
      {
         var _loc1_:Object = loadFile();
         this.scaleMode = _loc1_.scaleMode;
         if(!this.scaleMode)
         {
            this.scaleMode = "ConstantPixelSize";
         }
         this.screenMathMode = _loc1_.screenMathMode;
         if(!this.screenMathMode)
         {
            this.screenMathMode = "MatchWidthOrHeight";
         }
         this.designResolutionX = parseInt(_loc1_.designResolutionX);
         this.designResolutionY = parseInt(_loc1_.designResolutionY);
         this.defaultResolution = _loc1_.defaultResolution;
         if(!this.defaultResolution)
         {
            this.defaultResolution = "1136,640";
         }
      }
      
      override public function save() : void
      {
         var _loc1_:Object = {};
         _loc1_.scaleMode = this.scaleMode;
         _loc1_.screenMathMode = this.screenMathMode;
         _loc1_.designResolutionX = this.designResolutionX;
         _loc1_.designResolutionY = this.designResolutionY;
         _loc1_.defaultResolution = this.defaultResolution;
         saveFile(_loc1_);
      }
      
      public function fillCombo(param1:GComboBox) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = param1.items;
         var _loc2_:Array = param1.values;
         var _loc6_:int = 0;
         var _loc5_:* = this.resolutions;
         for each(_loc3_ in this.resolutions)
         {
            if(_loc3_.isMobile)
            {
               _loc4_.push(_loc3_.name + " (Landscape)");
            }
            else
            {
               _loc4_.push(_loc3_.name);
            }
            if(_loc3_.isMobile)
            {
               _loc2_.push(_loc3_.resolutionX + "," + _loc3_.resolutionY);
            }
            else
            {
               _loc2_.push(_loc3_.resolutionX + "," + _loc3_.resolutionY + ",0");
            }
         }
         var _loc8_:int = 0;
         var _loc7_:* = this.resolutions;
         for each(_loc3_ in this.resolutions)
         {
            if(_loc3_.isMobile)
            {
               _loc4_.push(_loc3_.name + " (Portrait)");
               _loc2_.push(_loc3_.resolutionY + "," + _loc3_.resolutionX);
            }
         }
         param1.items = _loc4_;
         param1.values = _loc2_;
         param1.visibleItemCount = 2147483647;
      }
   }
}

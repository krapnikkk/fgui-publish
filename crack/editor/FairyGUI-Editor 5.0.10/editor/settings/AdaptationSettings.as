package fairygui.editor.settings
{
   import fairygui.GComboBox;
   import fairygui.editor.api.IUIProject;
   
   public class AdaptationSettings extends SettingsBase
   {
      
      private static const DEFAULT_DEVICES:Array = [{
         "name":"iPhone Xs Max",
         "resolutionX":2688,
         "resolutionY":1242
      },{
         "name":"iPhone Xs",
         "resolutionX":2436,
         "resolutionY":1125
      },{
         "name":"iPhone XR",
         "resolutionX":1792,
         "resolutionY":828
      },{
         "name":"iPhone 8",
         "resolutionX":1334,
         "resolutionY":750
      },{
         "name":"iPhone 8 Plus",
         "resolutionX":1920,
         "resolutionY":1080
      },{
         "name":"iPhone 5",
         "resolutionX":1136,
         "resolutionY":640
      },{
         "name":"iPad",
         "resolutionX":2048,
         "resolutionY":1536
      },{
         "name":"iPad Pro",
         "resolutionX":2388,
         "resolutionY":1668
      },{
         "name":"Huawei Mate20",
         "resolutionX":2244,
         "resolutionY":1080
      },{
         "name":"Huawei Mate20 Pro",
         "resolutionX":3120,
         "resolutionY":1440
      },{
         "name":"Huawei P30",
         "resolutionX":2340,
         "resolutionY":1080
      },{
         "name":"Xiaomi 9",
         "resolutionX":2340,
         "resolutionY":1080
      },{
         "name":"Galaxy S10",
         "resolutionX":3040,
         "resolutionY":1440
      },{
         "name":"720p Phone",
         "resolutionX":1280,
         "resolutionY":720
      },{
         "name":"1080p Phone",
         "resolutionX":1920,
         "resolutionY":1080
      }];
       
      
      public var scaleMode:String;
      
      public var screenMathMode:String;
      
      public var designResolutionX:int;
      
      public var designResolutionY:int;
      
      public var devices:Array;
      
      public function AdaptationSettings(param1:IUIProject)
      {
         super(param1);
         _fileName = "Adaptation";
      }
      
      override protected function read(param1:Object) : void
      {
         this.scaleMode = param1.scaleMode;
         if(!this.scaleMode)
         {
            this.scaleMode = "ConstantPixelSize";
         }
         this.screenMathMode = param1.screenMathMode;
         if(!this.screenMathMode)
         {
            this.screenMathMode = "MatchWidthOrHeight";
         }
         this.designResolutionX = parseInt(param1.designResolutionX);
         this.designResolutionY = parseInt(param1.designResolutionY);
         this.devices = param1.devices as Array;
         if(!this.devices)
         {
            this.devices = [];
         }
      }
      
      override protected function write() : Object
      {
         var _loc1_:Object = {};
         _loc1_.scaleMode = this.scaleMode;
         _loc1_.screenMathMode = this.screenMathMode;
         _loc1_.designResolutionX = this.designResolutionX;
         _loc1_.designResolutionY = this.designResolutionY;
         _loc1_.devices = this.devices;
         return _loc1_;
      }
      
      public function getDeviceResolution(param1:String) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc3_ = this.devices.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.devices[_loc2_];
            if(_loc4_.name == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         _loc3_ = DEFAULT_DEVICES.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = DEFAULT_DEVICES[_loc2_];
            if(_loc4_.name == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return DEFAULT_DEVICES[0];
      }
      
      public function fillCombo(param1:GComboBox) : void
      {
         var _loc5_:Object = null;
         var _loc2_:Array = param1.items;
         var _loc3_:Array = param1.values;
         var _loc4_:int = 0;
         for each(_loc5_ in this.devices)
         {
            _loc2_[_loc4_] = _loc5_.name + " (" + _loc5_.resolutionX + "x" + _loc5_.resolutionY + ")";
            _loc3_[_loc4_] = _loc5_.name;
            _loc4_++;
         }
         for each(_loc5_ in DEFAULT_DEVICES)
         {
            _loc2_[_loc4_] = _loc5_.name + " (" + _loc5_.resolutionX + "x" + _loc5_.resolutionY + ")";
            _loc3_[_loc4_] = _loc5_.name;
            _loc4_++;
         }
         _loc2_.length = _loc4_;
         _loc3_.length = _loc4_;
         param1.items = _loc2_;
         param1.values = _loc3_;
         param1.visibleItemCount = int.MAX_VALUE;
      }
   }
}

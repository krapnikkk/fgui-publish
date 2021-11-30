package fairygui.editor.settings
{
   import flash.geom.Rectangle;
   
   public class ImageSetting
   {
      
      public static const QUALITY_DEFAULT:String = "default";
      
      public static const QUALITY_SOURCE:String = "source";
      
      public static const QUALITY_CUSTOM:String = "custom";
      
      public static const SCALE_9GRID:String = "9grid";
      
      public static const SCALE_TILE:String = "tile";
       
      
      public var scale9Grid:Rectangle;
      
      public var scaleOption:String;
      
      public var qualityOption:String;
      
      public var quality:int;
      
      public var smoothing:Boolean;
      
      public var gridTile:int;
      
      public var atlas:String;
      
      public function ImageSetting()
      {
         super();
         this.scale9Grid = new Rectangle();
         this.scaleOption = "none";
         this.qualityOption = "default";
         this.quality = 80;
         this.atlas = "0";
         this.smoothing = true;
      }
      
      public function copyFrom(param1:ImageSetting) : void
      {
         this.scale9Grid = param1.scale9Grid.clone();
         this.scaleOption = param1.scaleOption;
         this.qualityOption = param1.qualityOption;
         this.quality = param1.quality;
         this.smoothing = param1.smoothing;
         this.gridTile = param1.gridTile;
         this.atlas = param1.atlas;
      }
   }
}

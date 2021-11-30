package fairygui.editor.settings
{
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.gui.FPackageItemType;
   import fairygui.utils.XData;
   import flash.geom.Rectangle;
   
   public class ImageSettings
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
      
      public var duplicatePadding:Boolean;
      
      public var width:int;
      
      public var height:int;
      
      public function ImageSettings()
      {
         super();
         this.scale9Grid = new Rectangle();
         this.scaleOption = "none";
         this.qualityOption = QUALITY_DEFAULT;
         this.quality = 80;
         this.smoothing = true;
         this.gridTile = 0;
         this.atlas = "default";
         this.duplicatePadding = false;
      }
      
      public function copyFrom(param1:ImageSettings) : void
      {
         this.scale9Grid = param1.scale9Grid.clone();
         this.scaleOption = param1.scaleOption;
         this.qualityOption = param1.qualityOption;
         this.quality = param1.quality;
         this.smoothing = param1.smoothing;
         this.gridTile = param1.gridTile;
         this.atlas = param1.atlas;
         this.duplicatePadding = param1.duplicatePadding;
         this.width = param1.width;
         this.height = param1.height;
      }
      
      public function read(param1:FPackageItem, param2:XData) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(param1.type == FPackageItemType.MOVIECLIP)
         {
            this.smoothing = param2.getAttributeBool("smoothing",true);
            this.atlas = param2.getAttribute("atlas","default");
         }
         else
         {
            this.scaleOption = param2.getAttribute("scale","none");
            _loc3_ = param2.getAttribute("scale9grid");
            if(_loc3_)
            {
               _loc4_ = _loc3_.split(",");
               this.scale9Grid.x = _loc4_[0];
               this.scale9Grid.y = _loc4_[1];
               this.scale9Grid.width = _loc4_[2];
               this.scale9Grid.height = _loc4_[3];
            }
            else
            {
               this.scale9Grid.setEmpty();
            }
            this.gridTile = param2.getAttributeInt("gridTile");
            this.qualityOption = param2.getAttribute("qualityOption",QUALITY_DEFAULT);
            this.quality = param2.getAttributeInt("quality",80);
            this.smoothing = param2.getAttributeBool("smoothing",true);
            this.atlas = param2.getAttribute("atlas","default");
            this.duplicatePadding = param2.getAttributeBool("duplicatePadding");
            this.width = param2.getAttributeInt("width");
            this.height = param2.getAttributeInt("height");
         }
      }
      
      public function write(param1:FPackageItem, param2:XData, param3:Boolean) : void
      {
         if(param1.type == FPackageItemType.MOVIECLIP)
         {
            if(!this.smoothing)
            {
               param2.setAttribute("smoothing",false);
            }
            if(this.atlas != "default" && !param3)
            {
               param2.setAttribute("atlas",this.atlas);
            }
         }
         else
         {
            if(this.scaleOption != "none")
            {
               param2.setAttribute("scale",this.scaleOption);
            }
            if(!this.scale9Grid.isEmpty())
            {
               param2.setAttribute("scale9grid",this.scale9Grid.x + "," + this.scale9Grid.y + "," + this.scale9Grid.width + "," + this.scale9Grid.height);
            }
            if(this.gridTile != 0)
            {
               param2.setAttribute("gridTile",this.gridTile);
            }
            if(this.qualityOption != "default" && !param3)
            {
               param2.setAttribute("qualityOption",this.qualityOption);
            }
            if(this.qualityOption == "custom" && !param3)
            {
               param2.setAttribute("quality",this.quality);
            }
            if(!this.smoothing)
            {
               param2.setAttribute("smoothing",false);
            }
            if(this.atlas != "default" && !param3)
            {
               param2.setAttribute("atlas",this.atlas);
            }
            if(this.duplicatePadding && !param3)
            {
               param2.setAttribute("duplicatePadding",this.duplicatePadding);
            }
            if(param1.imageInfo.format == "svg")
            {
               param2.setAttribute("width",this.width);
               param2.setAttribute("height",this.height);
            }
         }
      }
   }
}

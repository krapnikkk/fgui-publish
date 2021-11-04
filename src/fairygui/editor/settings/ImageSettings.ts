import FPackageItem from "src/fairygui/gui/FPackageItem";
import FPackageItemType from "src/fairygui/gui/FPackageItemType";
import Rectangle from "src/fairygui/utils/Rectangle";
import XData from "src/fairygui/utils/XData";


export default class ImageSettings {

   public static QUALITY_DEFAULT: string = "default";

   public static QUALITY_SOURCE: string = "source";

   public static QUALITY_CUSTOM: string = "custom";

   public static SCALE_9GRID: string = "9grid";

   public static SCALE_TILE: string = "tile";


   public scale9Grid: Rectangle;

   public scaleOption: string;

   public qualityOption: string;

   public quality: number;

   public smoothing:boolean;

   public gridTile: number;

   public atlas: string;

   public duplicatePadding:boolean;

   public width: number;

   public height: number;

   public constructor() {
      this.scale9Grid = new Rectangle();
      this.scaleOption = "none";
      this.qualityOption = ImageSettings.QUALITY_DEFAULT;
      this.quality = 80;
      this.smoothing = true;
      this.gridTile = 0;
      this.atlas = "default";
      this.duplicatePadding = false;
   }

   public copyFrom(param1: ImageSettings): void {
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

   public read(param1: FPackageItem, param2: XData): void {
      var _loc3_: string = "";
      var _loc4_: Array<string> = [];
      if (param1.type == FPackageItemType.MOVIECLIP) {
         this.smoothing = param2.getAttributeBool("smoothing", true);
         this.atlas = param2.getAttribute("atlas", "default");
      }
      else {
         this.scaleOption = param2.getAttribute("scale", "none");
         _loc3_ = param2.getAttribute("scale9grid");
         if (_loc3_) {
            _loc4_ = _loc3_.split(",");
            this.scale9Grid.x = +_loc4_[0];
            this.scale9Grid.y = +_loc4_[1];
            this.scale9Grid.width = +_loc4_[2];
            this.scale9Grid.height = +_loc4_[3];
         }
         else {
            this.scale9Grid.setEmpty();
         }
         this.gridTile = param2.getAttributeInt("gridTile");
         this.qualityOption = param2.getAttribute("qualityOption", ImageSettings.QUALITY_DEFAULT);
         this.quality = param2.getAttributeInt("quality", 80);
         this.smoothing = param2.getAttributeBool("smoothing", true);
         this.atlas = param2.getAttribute("atlas", "default");
         this.duplicatePadding = param2.getAttributeBool("duplicatePadding");
         this.width = param2.getAttributeInt("width");
         this.height = param2.getAttributeInt("height");
      }
   }

   public write(param1: FPackageItem, param2: XData, param3:boolean): void {
      if (param1.type == FPackageItemType.MOVIECLIP) {
         if (!this.smoothing) {
            param2.setAttribute("smoothing", false);
         }
         if (this.atlas != "default" && !param3) {
            param2.setAttribute("atlas", this.atlas);
         }
      }
      else {
         if (this.scaleOption != "none") {
            param2.setAttribute("scale", this.scaleOption);
         }
         if (!this.scale9Grid.isEmpty()) {
            param2.setAttribute("scale9grid", this.scale9Grid.x + "," + this.scale9Grid.y + "," + this.scale9Grid.width + "," + this.scale9Grid.height);
         }
         if (this.gridTile != 0) {
            param2.setAttribute("gridTile", this.gridTile);
         }
         if (this.qualityOption != "default" && !param3) {
            param2.setAttribute("qualityOption", this.qualityOption);
         }
         if (this.qualityOption == "custom" && !param3) {
            param2.setAttribute("quality", this.quality);
         }
         if (!this.smoothing) {
            param2.setAttribute("smoothing", false);
         }
         if (this.atlas != "default" && !param3) {
            param2.setAttribute("atlas", this.atlas);
         }
         if (this.duplicatePadding && !param3) {
            param2.setAttribute("duplicatePadding", this.duplicatePadding);
         }
         if (param1.imageInfo.format == "svg") {
            param2.setAttribute("width", this.width);
            param2.setAttribute("height", this.height);
         }
      }
   }
}

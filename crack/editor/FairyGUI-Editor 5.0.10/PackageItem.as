package fairygui
{
   import fairygui.display.Frame;
   import fairygui.text.BitmapFont;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   
   public class PackageItem
   {
       
      
      public var owner:UIPackage;
      
      public var type:int;
      
      public var id:String;
      
      public var name:String;
      
      public var width:int;
      
      public var height:int;
      
      public var file:String;
      
      public var lastVisitTime:int;
      
      public var callbacks:Array;
      
      public var loading:int;
      
      public var loaded:Boolean;
      
      public var highResolution:Array;
      
      public var branches:Array;
      
      public var scale9Grid:Rectangle;
      
      public var scaleByTile:Boolean;
      
      public var smoothing:Boolean;
      
      public var tileGridIndice:int;
      
      public var image:BitmapData;
      
      public var interval:Number;
      
      public var repeatDelay:Number;
      
      public var swing:Boolean;
      
      public var frames:Vector.<Frame>;
      
      public var componentData:XML;
      
      public var displayList:Vector.<DisplayListItem>;
      
      public var extensionType:Object;
      
      public var sound:Sound;
      
      public var bitmapFont:BitmapFont;
      
      public function PackageItem()
      {
         callbacks = [];
         super();
      }
      
      public function addCallback(param1:Function) : void
      {
         var _loc2_:int = callbacks.indexOf(param1);
         if(_loc2_ == -1)
         {
            callbacks.push(param1);
         }
      }
      
      public function removeCallback(param1:Function) : Function
      {
         var _loc2_:int = callbacks.indexOf(param1);
         if(_loc2_ != -1)
         {
            callbacks.splice(_loc2_,1);
            return param1;
         }
         return null;
      }
      
      public function completeLoading() : void
      {
         loading = 0;
         loaded = true;
         var _loc1_:Array = callbacks.slice();
         var _loc4_:int = 0;
         var _loc3_:* = _loc1_;
         for each(var _loc2_ in _loc1_)
         {
            _loc2_(this);
         }
         callbacks.length = 0;
      }
      
      public function getBranch() : PackageItem
      {
         var _loc1_:* = null;
         if(branches && owner._branchIndex != -1)
         {
            _loc1_ = branches[owner._branchIndex];
            if(_loc1_)
            {
               return owner.getItemById(_loc1_);
            }
         }
         return this;
      }
      
      public function getHighResolution() : PackageItem
      {
         var _loc1_:* = null;
         if(highResolution && GRoot.contentScaleLevel > 0)
         {
            _loc1_ = highResolution[GRoot.contentScaleLevel - 1];
            if(_loc1_)
            {
               return owner.getItemById(_loc1_);
            }
         }
         return this;
      }
      
      public function toString() : String
      {
         return name;
      }
   }
}

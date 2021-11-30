package fairygui.editor.gui.animation
{
   import fairygui.utils.BulkTasks;
   import fairygui.utils.Callback;
   import fairygui.utils.ImageTool;
   import fairygui.utils.loader.EasyLoader;
   import fairygui.utils.loader.LoaderExt;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PNGEncoderOptions;
   import flash.filesystem.File;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class ImportTask
   {
       
      
      public var texture:AniTexture;
      
      public var frame:AniFrame;
      
      public var source:String;
      
      public var compressPNG:Boolean;
      
      public var unionRect:Rectangle;
      
      private var tempFile:File;
      
      private var owner:BulkTasks;
      
      public function ImportTask()
      {
         super();
      }
      
      public function handle(param1:BulkTasks) : void
      {
         this.owner = param1;
         EasyLoader.load(this.source,null,this.__imageLoaded);
      }
      
      private function __imageLoaded(param1:LoaderExt) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:BitmapData = null;
         if(param1.content == null)
         {
            this.setFrame(null);
            return;
         }
         var _loc2_:BitmapData = Bitmap(param1.content).bitmapData;
         if(this.unionRect.isEmpty())
         {
            this.unionRect.copyFrom(_loc2_.rect);
         }
         else
         {
            this.unionRect.copyFrom(this.unionRect.union(_loc2_.rect));
         }
         if(_loc2_.transparent)
         {
            _loc3_ = _loc2_.getColorBoundsRect(4278190080,0,false);
            if(_loc3_.isEmpty())
            {
               _loc2_.dispose();
               _loc2_ = null;
            }
            else
            {
               _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
               _loc4_.copyPixels(_loc2_,_loc3_,new Point(0,0));
               _loc3_.x = _loc3_.x - int(_loc2_.width / 2);
               _loc3_.y = _loc3_.y - int(_loc2_.height / 2);
               _loc2_.dispose();
               _loc2_ = _loc4_;
            }
         }
         else
         {
            _loc3_ = _loc2_.rect;
            _loc3_.x = _loc3_.x - int(_loc2_.width / 2);
            _loc3_.y = _loc3_.y - int(_loc2_.height / 2);
         }
         this.frame.rect.x = _loc3_.x;
         this.frame.rect.y = _loc3_.y;
         this.frame.rect.width = _loc3_.width;
         this.frame.rect.height = _loc3_.height;
         this.setFrame(_loc2_);
      }
      
      protected function setFrame(param1:BitmapData) : void
      {
         var _loc2_:Callback = null;
         if(param1 == null)
         {
            this.texture.raw = null;
            this.texture.bitmapData = null;
            this.owner.finishItem();
            return;
         }
         if(this.compressPNG)
         {
            _loc2_ = new Callback();
            _loc2_.success = this.__success;
            _loc2_.failed = this.__failed;
            ImageTool.compressBitmapData(param1,_loc2_);
            param1.dispose();
         }
         else
         {
            this.texture.raw = param1.encode(param1.rect,new PNGEncoderOptions());
            this.texture.bitmapData = param1;
            this.owner.finishItem();
         }
      }
      
      private function __success(param1:Callback) : void
      {
         var _loc2_:BitmapData = BitmapData(param1.result[0]);
         var _loc3_:ByteArray = ByteArray(param1.result[1]);
         this.texture.raw = _loc3_;
         this.texture.bitmapData = _loc2_;
         this.owner.finishItem();
      }
      
      private function __failed(param1:Callback) : void
      {
         this.owner.addErrorMsgs(param1.msgs);
         this.texture.raw = null;
         this.texture.bitmapData = null;
         this.owner.finishItem();
      }
   }
}

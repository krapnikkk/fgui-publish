package fairygui.editor.animation
{
   import fairygui.editor.loader.EasyLoader;
   import fairygui.editor.loader.LoaderExt;
   import fairygui.editor.utils.BulkTasks;
   import fairygui.editor.utils.Callback;
   import fairygui.editor.utils.ImageTool;
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
         var _loc2_:Rectangle = null;
         var _loc4_:BitmapData = null;
         if(param1.content == null)
         {
            this.setFrame(null);
            return;
         }
         var _loc5_:* = Bitmap(param1.content).bitmapData;
         var _loc3_:Number = _loc5_.width;
         var _loc6_:Number = _loc5_.height;
         if(this.unionRect.isEmpty())
         {
            this.unionRect.copyFrom(_loc5_.rect);
         }
         else
         {
            this.unionRect.copyFrom(this.unionRect.union(_loc5_.rect));
         }
         if(_loc5_.transparent)
         {
            _loc2_ = new Rectangle(0,0,_loc5_.width,_loc5_.height);
            if(_loc2_.isEmpty())
            {
               _loc5_.dispose();
               _loc5_ = null;
            }
            else
            {
               _loc4_ = new BitmapData(_loc2_.width,_loc2_.height);
               _loc4_.copyPixels(_loc5_,_loc2_,new Point(0,0));
               _loc2_.x = _loc2_.x - int(_loc5_.width / 2);
               _loc2_.y = _loc2_.y - int(_loc5_.height / 2);
               _loc5_.dispose();
               _loc5_ = _loc4_;
            }
         }
         else
         {
            _loc2_ = _loc5_.rect;
            _loc2_.x = _loc2_.x - int(_loc5_.width / 2);
            _loc2_.y = _loc2_.y - int(_loc5_.height / 2);
         }
         this.frame.rect.x = _loc2_.x;
         this.frame.rect.y = _loc2_.y;
         this.frame.rect.width = _loc2_.width;
         this.frame.rect.height = _loc2_.height;
         this.setFrame(_loc5_);
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
         var _loc3_:BitmapData = BitmapData(param1.result);
         var _loc2_:ByteArray = ByteArray(param1.result2);
         this.texture.raw = _loc2_;
         this.texture.bitmapData = _loc3_;
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

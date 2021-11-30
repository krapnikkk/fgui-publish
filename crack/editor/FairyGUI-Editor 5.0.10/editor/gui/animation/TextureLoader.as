package fairygui.editor.gui.animation
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class TextureLoader
   {
      
      public static var pool:Array = [];
      
      public static var runnings:Dictionary = new Dictionary();
       
      
      private var callback:Function;
      
      private var ani:AniDef;
      
      private var texture:AniTexture;
      
      private var image:BitmapData;
      
      private var loader:Loader;
      
      private var context:LoaderContext;
      
      public function TextureLoader()
      {
         super();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
      }
      
      public static function load(param1:AniDef, param2:AniTexture, param3:ByteArray, param4:Function) : void
      {
         var _loc5_:TextureLoader = null;
         if(pool.length)
         {
            _loc5_ = pool.pop();
         }
         else
         {
            _loc5_ = new TextureLoader();
         }
         _loc5_.load(param1,param2,param3,param4);
      }
      
      public static function clearPool() : void
      {
         pool.length = 0;
      }
      
      public function load(param1:AniDef, param2:AniTexture, param3:ByteArray, param4:Function) : void
      {
         this.ani = param1;
         this.texture = param2;
         this.callback = param4;
         this.image = null;
         this.loader.loadBytes(param3,this.context);
         param3 = null;
         runnings[this] = this;
      }
      
      private function onLoaded(param1:Event) : void
      {
         var evt:Event = param1;
         var bmd:BitmapData = Bitmap(this.loader.content).bitmapData;
         try
         {
            this.loader.unload();
         }
         catch(e:*)
         {
         }
         this.image = bmd;
         delete runnings[this];
         this.callback(this.ani,this.texture,this.image);
         pool.push(this);
         this.image = null;
         this.ani = null;
         this.texture = null;
      }
   }
}

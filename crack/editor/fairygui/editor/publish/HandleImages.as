package fairygui.editor.publish
{
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.utils.BulkTasks;
   
   public class HandleImages extends PublishStep
   {
       
      
      private var _loadTasks:BulkTasks;
      
      public function HandleImages()
      {
         super();
      }
      
      override public function run() : void
      {
         var pi:EPackageItem = null;
         this._loadTasks = new BulkTasks(40);
         var _loc3_:int = 0;
         var _loc2_:* = publishData.items;
         for each(pi in publishData.items)
         {
            if(pi.type == "image" && pi.errorStatus == 0)
            {
               this._loadTasks.addTask(this.loadImage,pi);
            }
         }
         this._loadTasks.start(function():void
         {
            stepCallback.callOnSuccessImmediately();
         });
      }
      
      private function loadImage() : void
      {
         var _loc1_:EPackageItem = EPackageItem(this._loadTasks.taskData);
         publishData.pkg.getImage(_loc1_,this.onLoaded,false);
      }
      
      private function onLoaded(param1:EPackageItem) : void
      {
         this._loadTasks.finishItem();
      }
   }
}

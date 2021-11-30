package fairygui.editor.gui
{
   import fairygui.editor.gui.animation.DecodeSupport;
   import fairygui.utils.GTimers;
   import flash.utils.getTimer;
   
   public class AsyncCreation
   {
      
      private static var frameTimeForAsyncUIConstruction:int = 2;
       
      
      public var callback:Function;
      
      private var _pkg:FPackage;
      
      private var _itemList:Vector.<FDisplayListItem>;
      
      private var _objectPool:Vector.<FObject>;
      
      private var _loadingImages:Vector.<FPackageItem>;
      
      private var _index:int;
      
      private var _flags:int;
      
      public function AsyncCreation()
      {
         super();
         this._itemList = new Vector.<FDisplayListItem>();
         this._objectPool = new Vector.<FObject>();
         this._loadingImages = new Vector.<FPackageItem>();
      }
      
      public function cancel() : void
      {
         var _loc1_:FDisplayListItem = null;
         var _loc2_:FObject = null;
         GTimers.inst.remove(this.run);
         GTimers.inst.remove(this.wait);
         GTimers.inst.remove(this.complete);
         this._loadingImages.length = 0;
         this.callback = null;
         if(this._itemList.length > 0)
         {
            for each(_loc1_ in this._itemList)
            {
               if(_loc1_.packageItem)
               {
                  _loc1_.packageItem.releaseRef();
               }
            }
            this._itemList.length = 0;
         }
         if(this._objectPool.length > 0)
         {
            for each(_loc2_ in this._objectPool)
            {
               _loc2_.dispose();
            }
            this._objectPool.length = 0;
         }
      }
      
      public function createObject(param1:FPackageItem, param2:int = 0) : void
      {
         var _loc3_:FDisplayListItem = null;
         this._itemList.length = 0;
         this._objectPool.length = 0;
         this._loadingImages.length = 0;
         this._flags = param2;
         this._pkg = param1.owner;
         this.collectComponentChildren(param1);
         this._itemList.push(new FDisplayListItem(param1,null,null));
         for each(_loc3_ in this._itemList)
         {
            if(_loc3_.packageItem)
            {
               _loc3_.packageItem.addRef();
            }
         }
         this._index = 0;
         GTimers.inst.add(1,0,this.run);
      }
      
      private function collectComponentChildren(param1:FPackageItem) : void
      {
         var _loc6_:FDisplayListItem = null;
         var _loc2_:FPackage = param1.owner;
         var _loc3_:ComponentData = param1.getComponentData();
         var _loc4_:int = _loc3_.displayList.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_.displayList[_loc5_];
            if(_loc6_.packageItem != null && _loc6_.packageItem.type == FPackageItemType.COMPONENT)
            {
               this.collectComponentChildren(_loc6_.packageItem);
            }
            this._itemList.push(_loc6_);
            _loc5_++;
         }
      }
      
      private function run() : void
      {
         var obj:FObject = null;
         var di:FDisplayListItem = null;
         var poolStart:int = 0;
         var k:int = 0;
         var f:Function = null;
         if(!this._pkg.project || !this._pkg.project.editor)
         {
            this.cancel();
            return;
         }
         var t:int = getTimer();
         var totalItems:int = this._itemList.length;
         while(this._index < totalItems)
         {
            di = this._itemList[this._index];
            if(this._index == totalItems - 1)
            {
               FObjectFactory.constructingDepth = 1;
               obj = FObjectFactory.newObject3(di,this._flags);
            }
            else
            {
               FObjectFactory.constructingDepth = 2;
               obj = FObjectFactory.newObject3(di,this._flags & 255);
            }
            if(di.packageItem != null)
            {
               this._objectPool.push(obj);
               if(di.packageItem.type == FPackageItemType.COMPONENT)
               {
                  poolStart = this._objectPool.length - di.packageItem.getComponentData().displayList.length - 1;
                  obj._res.displayItem.getComponentData().setInstances(this._objectPool,poolStart);
                  try
                  {
                     obj.create();
                  }
                  catch(err:Error)
                  {
                     _pkg.project.editor.consoleView.logError("AsyncCreate",err);
                  }
                  finally
                  {
                     obj._res.displayItem.getComponentData().setInstances(null,0);
                  }
                  this._objectPool.splice(poolStart,di.packageItem.getComponentData().displayList.length);
               }
               else
               {
                  obj.create();
               }
            }
            else
            {
               obj.create();
               this._objectPool.push(obj);
            }
            FObjectFactory.constructingDepth = 0;
            this._index++;
            if(this._index % 5 == 0 && getTimer() - t >= frameTimeForAsyncUIConstruction)
            {
               return;
            }
         }
         var result:FComponent = FComponent(this._objectPool[0]);
         this._objectPool.length = 0;
         if((this._flags & FObjectFlags.IN_PREVIEW) != 0)
         {
            result.collectLoadingImages(this._loadingImages);
            this._index = 0;
            GTimers.inst.remove(this.run);
            GTimers.inst.add(1,0,this.wait,result);
         }
         else
         {
            f = this.callback;
            this.cancel();
            f(result);
         }
      }
      
      private function wait(param1:FObject) : void
      {
         while(this._index < this._loadingImages.length)
         {
            if(this._loadingImages[this._index].loading)
            {
               return;
            }
            this._index++;
         }
         if(DecodeSupport.inst.busy)
         {
            return;
         }
         GTimers.inst.remove(this.wait);
         GTimers.inst.add(1,1,this.complete,param1);
      }
      
      private function complete(param1:FObject) : void
      {
         var _loc2_:Function = this.callback;
         this.cancel();
         _loc2_(param1);
      }
   }
}

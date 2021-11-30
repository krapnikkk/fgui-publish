package fairygui.editor.utils
{
   import fairygui.utils.GTimers;
   
   public class BulkTasks
   {
       
      
      private var _numConcurrent:int;
      
      private var _items:Vector.<Function>;
      
      private var _itemDatas:Vector.<Object>;
      
      private var _runningCount:int;
      
      private var _running:Boolean;
      
      private var _onCompleted:Function;
      
      private var _errorMsgs:Vector.<String>;
      
      private var _itemData:Object;
      
      public function BulkTasks(param1:int = 2)
      {
         super();
         this._numConcurrent = param1;
         this._items = new Vector.<Function>();
         this._itemDatas = new Vector.<Object>();
         this._errorMsgs = new Vector.<String>();
      }
      
      public function addTask(param1:Function, param2:Object = null) : void
      {
         this._items.push(param1);
         this._itemDatas.push(param2);
      }
      
      public function get itemCount() : int
      {
         return this._items.length;
      }
      
      public function get taskData() : Object
      {
         return this._itemData;
      }
      
      public function clear() : void
      {
         this._items.length = 0;
         this._errorMsgs.length = 0;
         this._runningCount = 0;
         this._running = false;
         this._onCompleted = null;
         this._itemData = null;
         this._itemDatas.length = 0;
         GTimers.inst.remove(this.run);
      }
      
      public function start(param1:Function) : void
      {
         this._onCompleted = param1;
         this._running = true;
         GTimers.inst.add(50,0,this.run);
      }
      
      public function addErrorMsg(param1:String) : void
      {
         if(param1)
         {
            this._errorMsgs.push(param1);
         }
      }
      
      public function addErrorMsgs(param1:Vector.<String>) : void
      {
         if(param1.length > 0)
         {
            this._errorMsgs = this._errorMsgs.concat(param1);
         }
      }
      
      public function get errorMsgs() : Vector.<String>
      {
         return this._errorMsgs;
      }
      
      public function finishItem() : void
      {
         this._runningCount--;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      private function run() : void
      {
         var _loc1_:Function = null;
         while(this._runningCount < this._numConcurrent && this._items.length > 0)
         {
            _loc1_ = this._items.pop();
            this._itemData = this._itemDatas.pop();
            this._runningCount++;
            if(_loc1_.length == 1)
            {
               _loc1_(this);
            }
            else
            {
               _loc1_();
            }
         }
         if(this._runningCount == 0)
         {
            this._running = false;
            GTimers.inst.remove(this.run);
            _loc1_ = this._onCompleted;
            this._onCompleted = null;
            if(_loc1_ != null)
            {
               if(_loc1_.length == 1)
               {
                  _loc1_(this);
               }
               else
               {
                  _loc1_();
               }
            }
         }
      }
   }
}

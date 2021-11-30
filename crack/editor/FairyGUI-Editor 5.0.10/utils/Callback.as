package fairygui.utils
{
   import fairygui.editor.plugin.ICallback;
   
   public class Callback implements ICallback
   {
       
      
      private var _success:Function;
      
      private var _failed:Function;
      
      private var _param:Object;
      
      private var _result:Object;
      
      private var _msgs:Vector.<String>;
      
      public function Callback()
      {
         super();
         this._msgs = new Vector.<String>();
      }
      
      public function get failed() : Function
      {
         return this._failed;
      }
      
      public function set failed(param1:Function) : void
      {
         this._failed = param1;
      }
      
      public function get success() : Function
      {
         return this._success;
      }
      
      public function set success(param1:Function) : void
      {
         this._success = param1;
      }
      
      public function get param() : Object
      {
         return this._param;
      }
      
      public function set param(param1:Object) : void
      {
         this._param = param1;
      }
      
      public function get result() : Object
      {
         return this._result;
      }
      
      public function set result(param1:Object) : void
      {
         this._result = param1;
      }
      
      public function callOnSuccess() : void
      {
         if(this._success == null)
         {
            return;
         }
         GTimers.inst.callLater(this.callOnSuccessImmediately);
      }
      
      public function callOnSuccessImmediately() : void
      {
         if(this._success != null)
         {
            if(this._success.length == 0)
            {
               this._success();
            }
            else
            {
               this._success(this);
            }
         }
      }
      
      public function callOnFail() : void
      {
         if(this._failed == null)
         {
            return;
         }
         GTimers.inst.callLater(this.callOnFailImmediately);
      }
      
      public function callOnFailImmediately() : void
      {
         if(this._failed != null)
         {
            if(this._failed.length == 0)
            {
               this._failed();
            }
            else
            {
               this._failed(this);
            }
         }
      }
      
      public function addMsg(param1:String) : void
      {
         if(param1)
         {
            this._msgs.push(param1);
         }
      }
      
      public function addMsgs(param1:Vector.<String>) : void
      {
         if(param1.length > 0)
         {
            this._msgs = this._msgs.concat(param1);
         }
      }
      
      public function get msgs() : Vector.<String>
      {
         return this._msgs;
      }
      
      public function clearMsgs() : void
      {
         this._msgs.length = 0;
      }
   }
}

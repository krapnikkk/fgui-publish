package fairygui.editor.utils
{
   import fairygui.editor.plugin.ICallback;
   import fairygui.utils.GTimers;
   
   public class Callback implements ICallback
   {
       
      
      public var success:Function;
      
      public var failed:Function;
      
      public var param:Object;
      
      public var param2:Object;
      
      public var result:Object;
      
      public var result2:Object;
      
      private var _msgs:Vector.<String>;
      
      public function Callback()
      {
         super();
         this._msgs = new Vector.<String>();
      }
      
      public function callOnSuccess() : void
      {
         if(this.success == null)
         {
            return;
         }
         GTimers.inst.callLater(this.callOnSuccessImmediately);
      }
      
      public function callOnSuccessImmediately() : void
      {
         if(this.success == null)
         {
            return;
         }
         if(this.success.length == 0)
         {
            this.success();
         }
         else
         {
            this.success(this);
         }
      }
      
      public function callOnFail() : void
      {
         if(this.failed == null)
         {
            return;
         }
         GTimers.inst.callLater(this.callOnFailImmediately);
      }
      
      public function callOnFailImmediately() : void
      {
         if(this.failed == null)
         {
            return;
         }
         if(this.failed.length == 0)
         {
            this.failed();
         }
         else
         {
            this.failed(this);
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
   }
}

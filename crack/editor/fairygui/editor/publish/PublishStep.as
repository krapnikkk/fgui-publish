package fairygui.editor.publish
{
   import fairygui.editor.utils.Callback;
   
   public class PublishStep
   {
       
      
      public var _publishData:PublishData;
      
      public var stepCallback:Callback;
      
      public function PublishStep()
      {
         super();
      }
      
      public function set publishData(param1:PublishData) : void
      {
         this._publishData = param1;
      }
      
      public function get publishData() : PublishData
      {
         return this._publishData;
      }
      
      public function run() : void
      {
      }
   }
}

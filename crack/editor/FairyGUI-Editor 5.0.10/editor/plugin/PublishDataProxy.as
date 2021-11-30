package fairygui.editor.plugin
{
   import fairygui.editor.§_-1L§;
   import fairygui.editor.publish.§_-4Z§;
   
   public class PublishDataProxy implements IPublishData
   {
       
      
      private var _data:§_-4Z§;
      
      private var _pkg:IEditorUIPackage;
      
      public function PublishDataProxy(param1:§_-4Z§)
      {
         super();
         this._data = param1;
         this._pkg = §_-1L§(this._data.project.editor).plugInManager.legacyProxy.getPackage(param1.pkg.name);
      }
      
      public function get fileName() : String
      {
         return this._data.fileName;
      }
      
      public function get singlePackage() : Boolean
      {
         return this._data.singlePackage;
      }
      
      public function get extractAlpha() : Boolean
      {
         return this._data.extractAlpha;
      }
      
      public function get filePath() : String
      {
         return this._data.path;
      }
      
      public function get sprites() : String
      {
         return this._data.sprites;
      }
      
      public function set sprites(param1:String) : void
      {
         this._data.sprites = param1;
      }
      
      public function get exportDescOnly() : Boolean
      {
         return this._data.exportDescOnly;
      }
      
      public function get outputClasses() : Object
      {
         return this._data.outputClasses;
      }
      
      public function set outputClasses(param1:Object) : void
      {
         this._data.outputClasses = param1;
      }
      
      public function get outputRes() : Object
      {
         return this._data.outputRes;
      }
      
      public function set outputRes(param1:Object) : void
      {
         this._data.outputRes = param1;
      }
      
      public function get fileExtention() : String
      {
         return this._data.fileExtension;
      }
      
      public function get targetUIPackage() : IEditorUIPackage
      {
         return this._pkg;
      }
      
      public function get outputDesc() : Object
      {
         return this._data.outputDesc;
      }
      
      public function set outputDesc(param1:Object) : void
      {
         this._data.outputDesc = param1;
      }
      
      public function preventDefault() : void
      {
         this._data.defaultPrevented = true;
      }
   }
}

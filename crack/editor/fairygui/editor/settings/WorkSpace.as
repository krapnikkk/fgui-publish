package fairygui.editor.settings
{
   import fairygui.editor.utils.UtilsFile;
   import flash.filesystem.File;
   
   public class WorkSpace extends ISerializedSettings
   {
       
      
      public var active_doc:Array;
      
      public var docs:Array;
      
      public var expanded_nodes:Array;
      
      public var hidden_packages:Array;
      
      public function WorkSpace()
      {
         super();
      }
      
      override public function load() : void
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = UtilsFile.loadJSON(new File(_project.objsPath + "/workspace.json"));
         }
         catch(err:Error)
         {
         }
         if(!_loc1_)
         {
            _loc1_ = {};
         }
         this.docs = _loc1_.docs;
         if(!this.docs)
         {
            this.docs = [];
         }
         this.expanded_nodes = _loc1_.expanded_nodes;
         if(!this.expanded_nodes)
         {
            this.expanded_nodes = [];
         }
         this.hidden_packages = _loc1_.hidden_packages;
         if(!this.hidden_packages)
         {
            this.hidden_packages = [];
         }
         this.active_doc = _loc1_.active_doc;
      }
      
      override public function save() : void
      {
         var _loc1_:Object = {};
         _loc1_.docs = this.docs;
         _loc1_.expanded_nodes = this.expanded_nodes;
         _loc1_.hidden_packages = this.hidden_packages;
         _loc1_.active_doc = this.active_doc;
         UtilsFile.saveJSON(new File(_project.objsPath + "/workspace.json"),_loc1_);
      }
   }
}

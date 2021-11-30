package fairygui.editor.publish
{
   import fairygui.editor.PackagesPanel;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.plugin.IEditorUIPackage;
   import fairygui.editor.plugin.IEditorUIProject;
   import fairygui.editor.plugin.IPublishData;
   import fairygui.editor.plugin.PlugInManager;
   import flash.utils.ByteArray;
   
   public class PublishData implements IPublishData
   {
       
      
      public var pkg:EUIPackage;
      
      public var items:Array;
      
      public var usingAtlas:Boolean;
      
      public var atlases:Vector.<AtlasItem>;
      
      public var atlasOutput:Vector.<AtlasOutput>;
      
      public var _project:EUIProject;
      
      public var _exportDescOnly:Boolean;
      
      public var _filePath:String;
      
      private var _fileName:String;
      
      public var _fileExtension:String;
      
      public var _singlePackage:Boolean;
      
      public var _extractAlpha:Boolean;
      
      public var _genCode:Boolean;
      
      public var _outputDesc:Object;
      
      public var _outputFyData:Object;
      
      public var _outputFyDataBy:Object;
      
      public var _outputRes:Object;
      
      public var _outputClasses:Object;
      
      public var _sprites:String;
      
      public var _hitTestImages:Array;
      
      public var _hitTestData:ByteArray;
      
      public var _fontTextures:Object;
      
      public var _defaultPrevented:Boolean;
      
      public var _dependentPackages:Object;
      
      public var _spritesInfo:Array;
      
      public function PublishData()
      {
         super();
         this.items = [];
         this._outputDesc = {};
         this._outputFyData = {};
         this._outputFyDataBy = {};
         this._outputRes = {};
         this._outputClasses = {};
         this._hitTestImages = [];
         this._hitTestData = new ByteArray();
         this._fontTextures = {};
         this.atlases = new Vector.<AtlasItem>();
         this.atlasOutput = new Vector.<AtlasOutput>();
         this._spritesInfo = [];
      }
      
      public function get project() : IEditorUIProject
      {
         return this._project;
      }
      
      public function get targetUIPackage() : IEditorUIPackage
      {
         return this.pkg;
      }
      
      public function get exportDescOnly() : Boolean
      {
         return this._exportDescOnly;
      }
      
      public function get filePath() : String
      {
         return this._filePath;
      }
      
      public function get fileName() : String
      {
         return this._fileName;
      }
      
      public function get fileNameEtx() : String
      {
         if(PackagesPanel.PUBLIC_OK && PackagesPanel.PUBLIC_COMPONENT_OBJECT && PackagesPanel.PUBLIC_COMPONENT_OBJECT.pacakgeName != "")
         {
            return PackagesPanel.PUBLIC_COMPONENT_OBJECT.pacakgeName + "_" + (PlugInManager.FYOUT_Ext == -1?PlugInManager.FYOUT:PlugInManager.FYOUT_Ext);
         }
         return this._fileName + "_" + (PlugInManager.FYOUT_Ext == -1?PlugInManager.FYOUT:PlugInManager.FYOUT_Ext);
      }
      
      public function set fileName(param1:String) : void
      {
         this._fileName = param1;
      }
      
      public function get singlePackage() : Boolean
      {
         return this._singlePackage;
      }
      
      public function get extractAlpha() : Boolean
      {
         return this._extractAlpha;
      }
      
      public function get fileExtention() : String
      {
         return this._fileExtension;
      }
      
      public function get outputDesc() : Object
      {
         return this._outputDesc;
      }
      
      public function set outputDesc(param1:Object) : void
      {
         this._outputDesc = param1;
      }
      
      public function get outputFyData() : Object
      {
         return this._outputFyData;
      }
      
      public function set outputFyData(param1:Object) : void
      {
         this._outputFyData = param1;
      }
      
      public function get outputFyDataBy() : Object
      {
         return this._outputFyDataBy;
      }
      
      public function set outputFyDataBy(param1:Object) : void
      {
         this._outputFyDataBy = param1;
      }
      
      public function get outputRes() : Object
      {
         return this._outputRes;
      }
      
      public function set outputRes(param1:Object) : void
      {
         this._outputRes = param1;
      }
      
      public function get outputClasses() : Object
      {
         return this._outputClasses;
      }
      
      public function set outputClasses(param1:Object) : void
      {
         this._outputClasses = param1;
      }
      
      public function get sprites() : String
      {
         return this._sprites;
      }
      
      public function set sprites(param1:String) : void
      {
         this._sprites = param1;
      }
      
      public function get hitTestData() : ByteArray
      {
         return this._hitTestData;
      }
      
      public function preventDefault() : void
      {
         this._defaultPrevented = true;
      }
      
      public function getItemById(param1:String) : EPackageItem
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.items.length)
         {
            if(this.items[_loc2_].id == param1)
            {
               return this.items[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}

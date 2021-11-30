package fairygui.editor.settings
{
   public class GlobalPublishSettings extends ISerializedSettings
   {
       
      
      public var filePath:String;
      
      public var fileExtension:String;
      
      public var packageCount:int;
      
      public var unityDataFormat:int;
      
      public var compressDesc:Boolean;
      
      public var codePath:String;
      
      public var classNamePrefix:String;
      
      public var memberNamePrefix:String;
      
      public var packageName:String;
      
      public var ignoreNoname:Boolean;
      
      public var getMemberByName:Boolean;
      
      public var codeType:String;
      
      public var binaryFormat:Boolean;
      
      public function GlobalPublishSettings()
      {
         super();
         _fileName = "Publish";
      }
      
      override public function load() : void
      {
         var _loc2_:Object = loadFile();
         this.filePath = _loc2_.path;
         this.fileExtension = _loc2_.fileExtension;
         this.packageCount = _loc2_.packageCount;
         if(this.packageCount == 0)
         {
            this.packageCount = 2;
         }
         if(_loc2_.unityDataFormat == undefined)
         {
            if(project.version != "3")
            {
               this.unityDataFormat = 1;
            }
            else
            {
               this.unityDataFormat = 0;
            }
         }
         else
         {
            this.unityDataFormat = _loc2_.unityDataFormat;
         }
         if(_loc2_.compressDesc == undefined)
         {
            this.compressDesc = true;
         }
         else
         {
            this.compressDesc = _loc2_.compressDesc;
         }
         if(_loc2_.binaryFormat == undefined)
         {
            if(project.version == "3.9")
            {
               this.binaryFormat = true;
            }
            else
            {
               this.binaryFormat = false;
            }
            this.binaryFormat = true;
         }
         else
         {
            this.binaryFormat = _loc2_.binaryFormat;
         }
         var _loc1_:Object = _loc2_.codeGeneration;
         if(_loc1_)
         {
            this.codePath = _loc1_.codePath;
            this.classNamePrefix = _loc1_.classNamePrefix;
            this.memberNamePrefix = _loc1_.memberNamePrefix;
            this.packageName = _loc1_.packageName;
            this.ignoreNoname = _loc1_.ignoreNoname == undefined || _loc1_.ignoreNoname;
            this.getMemberByName = _loc1_.getMemberByName;
            this.codeType = _loc1_.codeType;
            if(this.codeType == null)
            {
               this.codeType = "";
            }
         }
         else
         {
            this.classNamePrefix = "UI_";
            this.memberNamePrefix = "m_";
            this.ignoreNoname = false;
            this.codeType = "";
         }
      }
      
      override public function save() : void
      {
         var _loc2_:Object = {};
         _loc2_.path = this.filePath;
         _loc2_.fileExtension = this.fileExtension;
         _loc2_.packageCount = this.packageCount;
         if(project.version != "3" && _loc2_.unityDataFormat == 0 || project.version == "3" && _loc2_.unityDataFormat == 1)
         {
            _loc2_.unityDataFormat = this.unityDataFormat;
         }
         _loc2_.compressDesc = this.compressDesc;
         _loc2_.binaryFormat = this.binaryFormat;
         var _loc1_:Object = {};
         _loc2_.codeGeneration = _loc1_;
         _loc1_.codePath = this.codePath;
         _loc1_.classNamePrefix = this.classNamePrefix;
         _loc1_.memberNamePrefix = this.memberNamePrefix;
         _loc1_.packageName = this.packageName;
         _loc1_.ignoreNoname = this.ignoreNoname;
         _loc1_.getMemberByName = this.getMemberByName;
         _loc1_.codeType = this.codeType;
         saveFile(_loc2_);
      }
   }
}

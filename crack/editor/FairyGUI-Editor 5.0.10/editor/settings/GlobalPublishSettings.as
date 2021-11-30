package fairygui.editor.settings
{
   import fairygui.editor.api.IUIProject;
   import fairygui.editor.api.ProjectType;
   
   public class GlobalPublishSettings extends SettingsBase
   {
       
      
      public var path:String;
      
      public var branchPath:String;
      
      public var fileExtension:String;
      
      public var packageCount:int;
      
      public var compressDesc:Boolean;
      
      public var binaryFormat:Boolean;
      
      public var jpegQuality:int;
      
      public var compressPNG:Boolean;
      
      public var allowGenCode:Boolean;
      
      public var codePath:String;
      
      public var classNamePrefix:String;
      
      public var memberNamePrefix:String;
      
      public var packageName:String;
      
      public var ignoreNoname:Boolean;
      
      public var getMemberByName:Boolean;
      
      public var codeType:String;
      
      public var includeHighResolution:int;
      
      public var branchProcessing:int;
      
      public var atlasMaxSize:int;
      
      public var atlasPaging:Boolean;
      
      public var atlasSizeOption:String;
      
      public var atlasForceSquare:Boolean;
      
      public var atlasAllowRotation:Boolean;
      
      public var atlasTrimImage:Boolean;
      
      public function GlobalPublishSettings(param1:IUIProject)
      {
         super(param1);
         _fileName = "Publish";
      }
      
      public function get include2x() : Boolean
      {
         return (this.includeHighResolution & 1) != 0;
      }
      
      public function set include2x(param1:Boolean) : void
      {
         if(param1)
         {
            this.includeHighResolution = this.includeHighResolution | 1;
         }
         else
         {
            this.includeHighResolution = this.includeHighResolution & 14;
         }
      }
      
      public function get include3x() : Boolean
      {
         return (this.includeHighResolution & 2) != 0;
      }
      
      public function set include3x(param1:Boolean) : void
      {
         if(param1)
         {
            this.includeHighResolution = this.includeHighResolution | 2;
         }
         else
         {
            this.includeHighResolution = this.includeHighResolution & 13;
         }
      }
      
      public function get include4x() : Boolean
      {
         return (this.includeHighResolution & 4) != 0;
      }
      
      public function set include4x(param1:Boolean) : void
      {
         if(param1)
         {
            this.includeHighResolution = this.includeHighResolution | 4;
         }
         else
         {
            this.includeHighResolution = this.includeHighResolution & 11;
         }
      }
      
      override protected function read(param1:Object) : void
      {
         this.path = param1.path;
         if(!this.path)
         {
            this.path = "";
         }
         this.branchPath = param1.branchPath;
         if(!this.branchPath)
         {
            this.branchPath = "";
         }
         this.packageCount = param1.packageCount;
         if(this.packageCount == 0)
         {
            this.packageCount = 2;
         }
         if(param1.compressDesc != undefined)
         {
            this.compressDesc = param1.compressDesc;
         }
         else
         {
            this.compressDesc = true;
         }
         if(param1.binaryFormat != undefined)
         {
            this.binaryFormat = param1.binaryFormat;
         }
         else
         {
            this.binaryFormat = true;
         }
         if(_project.type == ProjectType.UNITY)
         {
            this.fileExtension = "bytes";
         }
         else if(_project.type == ProjectType.COCOS2DX || _project.type == ProjectType.VISION)
         {
            if(this.binaryFormat)
            {
               this.fileExtension = "fui";
            }
            else
            {
               this.fileExtension = "bytes";
            }
         }
         else if(_project.type == ProjectType.CRY || _project.type == ProjectType.MONOGAME || _project.type == ProjectType.CORONA)
         {
            this.fileExtension = "fui";
         }
         else
         {
            this.fileExtension = param1.fileExtension;
            if(!this.fileExtension)
            {
               if(_project.type == ProjectType.COCOSCREATOR)
               {
                  this.fileExtension = "bin";
               }
               else if(_project.isH5)
               {
                  this.fileExtension = "fui";
               }
               else
               {
                  this.fileExtension = "zip";
               }
            }
         }
         this.includeHighResolution = parseInt(param1.includeHighResolution);
         if(isNaN(this.includeHighResolution))
         {
            this.includeHighResolution = 0;
         }
         this.branchProcessing = parseInt(param1.branchProcessing);
         if(isNaN(this.branchProcessing))
         {
            this.branchProcessing = 0;
         }
         var _loc2_:Object = param1.codeGeneration;
         if(_loc2_)
         {
            if(_loc2_.allowGenCode != undefined)
            {
               this.allowGenCode = _loc2_.allowGenCode;
            }
            else
            {
               this.allowGenCode = true;
            }
            this.codePath = _loc2_.codePath;
            this.classNamePrefix = _loc2_.classNamePrefix;
            this.memberNamePrefix = _loc2_.memberNamePrefix;
            this.packageName = _loc2_.packageName;
            this.ignoreNoname = _loc2_.ignoreNoname == undefined || _loc2_.ignoreNoname;
            this.getMemberByName = _loc2_.getMemberByName;
            this.codeType = _loc2_.codeType;
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
            this.allowGenCode = true;
         }
         var _loc3_:Object = param1.atlasSetting;
         if(_loc3_)
         {
            if(_loc3_.maxSize)
            {
               this.atlasMaxSize = parseInt(_loc3_.maxSize);
               if(isNaN(this.atlasMaxSize))
               {
                  this.atlasMaxSize = 2048;
               }
            }
            else
            {
               this.atlasMaxSize = 2048;
            }
            if(_loc3_.paging != undefined)
            {
               this.atlasPaging = _loc3_.paging;
            }
            else
            {
               this.atlasPaging = true;
            }
            this.atlasSizeOption = _loc3_.sizeOption;
            if(!this.atlasSizeOption)
            {
               this.atlasSizeOption = "pot";
            }
            if(_loc3_.forceSquare != undefined)
            {
               this.atlasForceSquare = _loc3_.forceSquare;
            }
            else
            {
               this.atlasForceSquare = false;
            }
            if(_loc3_.allowRotation != undefined)
            {
               this.atlasAllowRotation = _loc3_.allowRotation;
            }
            else
            {
               this.atlasAllowRotation = false;
            }
            if(_loc3_.trimImage != undefined)
            {
               this.atlasTrimImage = _loc3_.trimImage;
            }
            else
            {
               this.atlasTrimImage = _project.versionCode >= 500;
            }
         }
         else
         {
            this.atlasMaxSize = 2048;
            this.atlasPaging = true;
            this.atlasSizeOption = "pot";
            this.atlasForceSquare = false;
            this.atlasAllowRotation = false;
            this.atlasTrimImage = false;
         }
         if(_project.supportAtlas)
         {
            this.compressPNG = false;
            this.jpegQuality = 80;
         }
         else
         {
            this.compressPNG = param1.compressPNG;
            this.jpegQuality = param1.jpegQuality;
            if(this.jpegQuality == 0)
            {
               this.jpegQuality = 80;
            }
         }
      }
      
      override protected function write() : Object
      {
         var _loc1_:Object = {};
         _loc1_.path = this.path;
         if(this.branchPath)
         {
            _loc1_.branchPath = this.branchPath;
         }
         if(_project.supportCustomFileExtension)
         {
            _loc1_.fileExtension = this.fileExtension;
         }
         _loc1_.packageCount = this.packageCount;
         _loc1_.compressDesc = this.compressDesc;
         _loc1_.binaryFormat = this.binaryFormat;
         if(this.includeHighResolution > 0)
         {
            _loc1_.includeHighResolution = this.includeHighResolution;
         }
         if(this.branchProcessing > 0)
         {
            _loc1_.branchProcessing = this.branchProcessing;
         }
         var _loc2_:Object = {};
         _loc1_.codeGeneration = _loc2_;
         if(!this.allowGenCode)
         {
            _loc2_.allowGenCode = false;
         }
         _loc2_.codePath = this.codePath;
         _loc2_.classNamePrefix = this.classNamePrefix;
         _loc2_.memberNamePrefix = this.memberNamePrefix;
         _loc2_.packageName = this.packageName;
         _loc2_.ignoreNoname = this.ignoreNoname;
         _loc2_.getMemberByName = this.getMemberByName;
         _loc2_.codeType = this.codeType;
         var _loc3_:Object = {};
         _loc1_.atlasSetting = _loc3_;
         if(this.atlasMaxSize != 2048)
         {
            _loc3_.maxSize = this.atlasMaxSize;
         }
         if(this.atlasPaging)
         {
            _loc3_.paging = true;
         }
         if(this.atlasSizeOption)
         {
            _loc3_.sizeOption = this.atlasSizeOption;
         }
         if(this.atlasForceSquare)
         {
            _loc3_.forceSquare = this.atlasForceSquare;
         }
         if(this.atlasAllowRotation)
         {
            _loc3_.allowRotation = this.atlasAllowRotation;
         }
         if(this.atlasTrimImage)
         {
            _loc3_.trimImage = this.atlasTrimImage;
         }
         if(!_project.supportAtlas)
         {
            _loc1_.compressPNG = this.compressPNG;
            _loc1_.jpegQuality = this.jpegQuality;
         }
         return _loc1_;
      }
   }
}

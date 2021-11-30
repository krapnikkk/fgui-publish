package fairygui.editor.gui
{
   public class ResourceRef
   {
       
      
      private var _main:FPackageItem;
      
      private var _mainVer:int;
      
      private var _branch:FPackageItem;
      
      private var _branchVer:int;
      
      private var _display:FPackageItem;
      
      private var _displayVer:int;
      
      private var _sourceWidth:int;
      
      private var _sourceHeight:int;
      
      private var _missingInfo:MissingInfo;
      
      private var _flags:int;
      
      public function ResourceRef(param1:FPackageItem = null, param2:MissingInfo = null, param3:int = 0)
      {
         super();
         this._missingInfo = param2;
         this.setPackageItem(param1,param3);
      }
      
      public function get packageItem() : FPackageItem
      {
         return this._main;
      }
      
      public function setPackageItem(param1:FPackageItem, param2:int = 0) : void
      {
         var _loc3_:* = 0;
         if(this._main == param1)
         {
            return;
         }
         this._flags = param2;
         if(this._main)
         {
            this._display.releaseRef();
            this._display = null;
         }
         this._main = param1;
         if(this._main)
         {
            this._main.touch();
            this._mainVer = this._main.version;
            if((param2 & FObjectFlags.IN_PREVIEW) == 0 && (param2 & FObjectFlags.ROOT) == 0 && this._main.branch.length == 0)
            {
               this._branch = this._main.getBranch();
               if(this._branch != this._main)
               {
                  this._branch.touch();
               }
            }
            else
            {
               this._branch = this._main;
            }
            this._branchVer = this._branch.version;
            this._sourceWidth = this._branch.width;
            this._sourceHeight = this._branch.height;
            this._display = this._branch;
            if(this._branch.imageInfo)
            {
               _loc3_ = param2 & 15;
               if(_loc3_ > 0)
               {
                  this._display = this._branch.getHighResolution(_loc3_);
                  if(this._display != this._branch)
                  {
                     this._display.touch();
                  }
               }
            }
            this._display.addRef();
            this._displayVer = this._display.version;
         }
         else
         {
            this._sourceWidth = this._sourceHeight = 0;
         }
      }
      
      public function get displayItem() : FPackageItem
      {
         return this._display;
      }
      
      public function get deprecated() : Boolean
      {
         var _loc1_:FPackageItem = null;
         var _loc2_:* = 0;
         if(!this._main)
         {
            return false;
         }
         this._main.touch();
         if(this._branch != this._main)
         {
            this._branch.touch();
         }
         if(this._display != this._branch)
         {
            this._display.touch();
         }
         if(this._main.version != this._mainVer || this._branch.version != this._branchVer || this._display.version != this._displayVer)
         {
            return true;
         }
         if((this._flags & FObjectFlags.ROOT) == 0 && this._main.branch.length == 0)
         {
            _loc1_ = this._main.getBranch();
         }
         else
         {
            _loc1_ = this._main;
         }
         if(_loc1_.imageInfo)
         {
            _loc2_ = this._flags & 15;
            if(_loc2_ > 0)
            {
               _loc1_ = _loc1_.getHighResolution(_loc2_);
            }
         }
         if(_loc1_ != this._display)
         {
            return true;
         }
         return false;
      }
      
      public function get name() : String
      {
         return !!this._display?this._display.name:"";
      }
      
      public function get desc() : String
      {
         if(this._display)
         {
            return this._display.name + " @" + this._display.owner.name;
         }
         if(this._missingInfo)
         {
            return this._missingInfo.fileName + " @" + (!!this._missingInfo.pkg?this._missingInfo.pkg.name:this._missingInfo.pkgId);
         }
         return "";
      }
      
      public function get isMissing() : Boolean
      {
         return this._main == null;
      }
      
      public function get missingInfo() : MissingInfo
      {
         return this._missingInfo;
      }
      
      public function getURL() : String
      {
         return this._display.getURL();
      }
      
      public function get sourceWidth() : int
      {
         return this._sourceWidth;
      }
      
      public function get sourceHeight() : int
      {
         return this._sourceHeight;
      }
      
      public function update() : void
      {
         var _loc1_:FPackageItem = null;
         if(this._main)
         {
            _loc1_ = this._main;
            this._main = null;
            if(_loc1_ && _loc1_.isDisposed && !this._missingInfo)
            {
               this._missingInfo = MissingInfo.create(_loc1_.owner,_loc1_.owner.id,_loc1_.id,_loc1_.fileName);
            }
            else
            {
               this.setPackageItem(_loc1_,this._flags);
            }
         }
      }
      
      public function release() : void
      {
         if(this._main)
         {
            this._display.releaseRef();
            this._main = null;
            this._branch = null;
            this._display = null;
         }
      }
   }
}

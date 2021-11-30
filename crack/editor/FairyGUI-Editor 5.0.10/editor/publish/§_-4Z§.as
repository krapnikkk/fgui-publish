package fairygui.editor.publish
{
   import fairygui.editor.gui.FPackage;
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.gui.FProject;
   import flash.utils.ByteArray;
   
   public class §_-4Z§
   {
       
      
      public var project:FProject;
      
      public var pkg:FPackage;
      
      public var §_-O4§:Boolean;
      
      public var exportDescOnly:Boolean;
      
      public var path:String;
      
      public var fileName:String;
      
      public var fileExtension:String;
      
      public var singlePackage:Boolean;
      
      public var extractAlpha:Boolean;
      
      public var genCode:Boolean;
      
      public var codePath:String;
      
      public var includeHighResolution:int;
      
      public var trimImage:Boolean;
      
      public var branch:String;
      
      public var §_-GR§:Object;
      
      public var §_-1e§:int;
      
      public var includeBranches:Boolean;
      
      public var §_-Ho§:int;
      
      public var items:Vector.<FPackageItem>;
      
      public var atlases:Vector.<AtlasItem>;
      
      public var §_-F8§:Vector.<§_-4E§>;
      
      public var outputDesc:Object;
      
      public var outputRes:Object;
      
      public var outputClasses:Object;
      
      public var sprites:String;
      
      public var hitTestImages:Vector.<FPackageItem>;
      
      public var hitTestData:ByteArray;
      
      public var §_-BD§:Object;
      
      public var §_-Fc§:Array;
      
      public var §_-DJ§:Object;
      
      public var §_-BH§:int;
      
      public var defaultPrevented:Boolean;
      
      public function §_-4Z§()
      {
         super();
         this.items = new Vector.<FPackageItem>();
         this.outputDesc = {};
         this.outputRes = {};
         this.outputClasses = {};
         this.hitTestImages = new Vector.<FPackageItem>();
         this.hitTestData = new ByteArray();
         this.§_-BD§ = {};
         this.§_-Fc§ = [];
         this.§_-DJ§ = {};
         this.§_-GR§ = {};
         this.§_-1e§ = 0;
         this.atlases = new Vector.<AtlasItem>();
         this.§_-F8§ = new Vector.<§_-4E§>();
      }
   }
}

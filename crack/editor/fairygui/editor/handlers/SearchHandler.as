package fairygui.editor.handlers
{
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.utils.UtilsFile;
   import flash.filesystem.File;
   import flash.system.System;
   
   public class SearchHandler
   {
       
      
      private var _index:int;
      
      private var _key:String;
      
      private var _results:Vector.<EPackageItem>;
      
      public function SearchHandler()
      {
         super();
         this._results = new Vector.<EPackageItem>();
      }
      
      public function search(param1:EUIProject, param2:String) : void
      {
         var _loc6_:EUIPackage = null;
         var _loc7_:XML = null;
         var _loc4_:XMLList = null;
         var _loc5_:* = null;
         var _loc9_:XML = null;
         var _loc10_:EPackageItem = null;
         var _loc3_:* = param1;
         var _loc11_:* = param2;
         this._results.length = 0;
         _loc11_ = _loc11_.toLowerCase();
         var _loc8_:Vector.<EUIPackage> = _loc3_.getPackageList();
         var _loc19_:int = 0;
         var _loc18_:* = _loc8_;
         for each(_loc6_ in _loc8_)
         {
            if(_loc6_.rootItem.treeNode)
            {
               if(_loc6_.name.toLowerCase().search(_loc11_) != -1)
               {
                  this._results.push(_loc6_.rootItem);
               }
               _loc7_ = UtilsFile.loadXML(new File(_loc6_.basePath + "/package.xml"));
               _loc4_ = _loc7_.resources.elements();
               var _loc12_:* = _loc4_;
               var _loc13_:int = 0;
               var _loc15_:* = new XMLList("");
               _loc5_ = _loc4_.(@name.toString().toLowerCase().search(_loc11_) != -1);
               if(_loc5_.length() > 0)
               {
                  _loc6_.ensureOpen();
                  var _loc17_:int = 0;
                  var _loc16_:* = _loc5_;
                  for each(_loc9_ in _loc5_)
                  {
                     _loc10_ = _loc6_.getItem(_loc9_.@id);
                     if(_loc10_)
                     {
                        this._results.push(_loc10_);
                     }
                  }
               }
               System.disposeXML(_loc7_);
            }
         }
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      public function get resultCount() : int
      {
         return this._results.length;
      }
      
      public function get nextResult() : EPackageItem
      {
         this._index++;
         if(this._index >= this._results.length)
         {
            this._index = 0;
         }
         return this._results[this._index];
      }
      
      public function get prevResult() : EPackageItem
      {
         var _loc1_:EPackageItem = this._results[this._index];
         this._index--;
         if(this._index < 0)
         {
            this._index = this._results.length - 1;
         }
         return _loc1_;
      }
   }
}

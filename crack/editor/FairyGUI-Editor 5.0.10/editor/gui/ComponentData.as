package fairygui.editor.gui
{
   import fairygui.editor.api.IDocument;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   
   public class ComponentData
   {
      
      private static var helperComPropertyList:Vector.<ComProperty> = new Vector.<ComProperty>();
       
      
      private var _packageItem:FPackageItem;
      
      private var _xml:XData;
      
      private var _displayList:Vector.<FDisplayListItem>;
      
      public function ComponentData(param1:FPackageItem)
      {
         super();
         this._packageItem = param1;
      }
      
      public function get packageItem() : FPackageItem
      {
         return this._packageItem;
      }
      
      public function get xml() : XData
      {
         if(!this._xml)
         {
            this.loadXML();
         }
         return this._xml;
      }
      
      private function loadXML() : void
      {
         var doc:IDocument = this._packageItem.getVar("doc");
         if(doc && doc.isModified && doc.content)
         {
            this._xml = XData(doc.serialize());
         }
         else if(this._packageItem.file.exists)
         {
            try
            {
               this._xml = UtilsFile.loadXData(this._packageItem.file);
               return;
            }
            catch(err:Error)
            {
               return;
            }
         }
      }
      
      public function get displayList() : Vector.<FDisplayListItem>
      {
         if(!this._displayList)
         {
            this.loadChildren();
         }
         return this._displayList;
      }
      
      private function loadChildren() : void
      {
         var _loc4_:FDisplayListItem = null;
         var _loc6_:XData = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:FPackage = null;
         var _loc11_:FPackageItem = null;
         if(!this._xml)
         {
            this.loadXML();
         }
         if(this._xml == null)
         {
            this._displayList = new Vector.<FDisplayListItem>(0);
            return;
         }
         var _loc1_:XData = this._xml.getChild("displayList");
         if(_loc1_ == null)
         {
            this._displayList = new Vector.<FDisplayListItem>(0);
            return;
         }
         var _loc2_:Vector.<XData> = _loc1_.getChildren();
         var _loc3_:int = _loc2_.length;
         this._displayList = new Vector.<FDisplayListItem>(_loc3_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc7_ = _loc6_.getName();
            _loc8_ = _loc6_.getAttribute("src");
            if(_loc8_)
            {
               _loc9_ = _loc6_.getAttribute("pkg");
               if(_loc9_ && _loc9_ != this._packageItem.owner.id)
               {
                  _loc10_ = this._packageItem.owner.project.getPackage(_loc9_) as FPackage;
               }
               else
               {
                  _loc10_ = this._packageItem.owner;
               }
               _loc11_ = !!_loc10_?_loc10_.getItem(_loc8_):null;
               _loc4_ = new FDisplayListItem(_loc11_,!!_loc10_?_loc10_:this._packageItem.owner,_loc7_);
               if(_loc11_ == null)
               {
                  _loc4_.missingInfo = MissingInfo.create(this._packageItem.owner,!!_loc10_?_loc10_.id:_loc9_,_loc8_,_loc6_.getAttribute("fileName"));
               }
            }
            else
            {
               _loc4_ = new FDisplayListItem(null,this._packageItem.owner,_loc7_);
            }
            _loc4_.desc = _loc6_;
            this._displayList[_loc5_] = _loc4_;
            _loc5_++;
         }
      }
      
      public function setInstances(param1:Vector.<FObject>, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = this.displayList.length;
         if(param1)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               this._displayList[_loc4_].existingInstance = param1[param2 + _loc4_];
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               this._displayList[_loc4_].existingInstance = null;
               _loc4_++;
            }
         }
      }
      
      public function getCustomProperties() : Vector.<ComProperty>
      {
         if(!this._xml)
         {
            this.loadXML();
         }
         if(!this._xml)
         {
            return null;
         }
         helperComPropertyList.length = 0;
         var _loc1_:XDataEnumerator = this._xml.getEnumerator("controller");
         while(_loc1_.moveNext())
         {
            if(_loc1_.current.getAttributeBool("exported"))
            {
               helperComPropertyList.push(new ComProperty(_loc1_.current.getAttribute("name"),-1,_loc1_.current.getAttribute("alias")));
            }
         }
         _loc1_ = this._xml.getEnumerator("customProperty");
         while(_loc1_.moveNext())
         {
            helperComPropertyList.push(new ComProperty(_loc1_.current.getAttribute("target"),_loc1_.current.getAttributeInt("propertyId"),_loc1_.current.getAttribute("label")));
         }
         if(helperComPropertyList.length > 0)
         {
            return helperComPropertyList.concat();
         }
         return null;
      }
      
      public function getControllerPages(param1:String, param2:Array, param3:Array) : void
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!this._xml)
         {
            this.loadXML();
         }
         if(!this._xml)
         {
            return;
         }
         var _loc4_:XDataEnumerator = this._xml.getEnumerator("controller");
         while(_loc4_.moveNext())
         {
            if(_loc4_.current.getAttribute("name") == param1)
            {
               _loc5_ = _loc4_.current.getAttribute("pages");
               if(_loc5_)
               {
                  _loc6_ = _loc5_.split(",");
                  _loc7_ = _loc6_.length / 2;
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_)
                  {
                     param3.push(_loc6_[_loc8_ * 2]);
                     _loc5_ = _loc6_[_loc8_ * 2 + 1];
                     if(_loc5_)
                     {
                        _loc5_ = _loc8_ + ":" + _loc5_;
                     }
                     else
                     {
                        _loc5_ = "" + _loc8_;
                     }
                     param2.push(_loc5_);
                     _loc8_++;
                  }
               }
               break;
            }
         }
      }
      
      public function dispose() : void
      {
         if(this._xml)
         {
            this._xml.dispose();
            this._xml = null;
         }
         this._displayList = null;
      }
   }
}

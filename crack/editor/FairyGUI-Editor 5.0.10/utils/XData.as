package fairygui.utils
{
   import flash.system.System;
   
   public class XData
   {
       
      
      private var _children:Vector.<XData>;
      
      private var _xml:XML;
      
      public function XData()
      {
         super();
      }
      
      public static function parse(param1:String) : XData
      {
         var _loc2_:XData = new XData();
         XML.ignoreWhitespace = true;
         _loc2_._xml = new XML(param1);
         return _loc2_;
      }
      
      public static function create(param1:String) : XData
      {
         var _loc2_:XData = new XData();
         _loc2_._xml = new XML("<" + param1 + "/>");
         return _loc2_;
      }
      
      public static function attach(param1:XML) : XData
      {
         var _loc2_:XData = new XData();
         _loc2_._xml = param1;
         return _loc2_;
      }
      
      public function getName() : String
      {
         return this._xml.name().localName;
      }
      
      public function setName(param1:String) : void
      {
         this._xml.setLocalName(param1);
      }
      
      public function getText() : String
      {
         return this._xml.text();
      }
      
      public function setText(param1:String) : void
      {
         this._xml.setChildren(param1);
      }
      
      public function getAttribute(param1:String, param2:String = null) : String
      {
         var _loc3_:XMLList = this._xml.attribute(param1);
         if(_loc3_ && _loc3_.length())
         {
            return _loc3_.toString();
         }
         return param2;
      }
      
      public function getAttributeInt(param1:String, param2:int = 0) : int
      {
         var _loc3_:String = this.getAttribute(param1);
         if(_loc3_ == null)
         {
            return param2;
         }
         return parseInt(_loc3_);
      }
      
      public function getAttributeFloat(param1:String, param2:Number = 0) : Number
      {
         var _loc3_:String = this.getAttribute(param1);
         if(_loc3_ == null)
         {
            return param2;
         }
         return parseFloat(_loc3_);
      }
      
      public function getAttributeBool(param1:String, param2:Boolean = false) : Boolean
      {
         var _loc3_:String = this.getAttribute(param1);
         if(_loc3_ == null)
         {
            return param2;
         }
         return _loc3_ == "true";
      }
      
      public function getAttributeColor(param1:String, param2:Boolean, param3:uint = 0) : uint
      {
         var _loc4_:String = this.getAttribute(param1);
         if(_loc4_ == null)
         {
            return param3;
         }
         return UtilsStr.convertFromHtmlColor(_loc4_,param2);
      }
      
      public function setAttribute(param1:String, param2:*) : void
      {
         this._xml[param1] = param2;
      }
      
      public function removeAttribute(param1:String) : void
      {
         delete this._xml[param1];
      }
      
      public function hasAttribute(param1:String) : Boolean
      {
         var _loc2_:XMLList = this._xml.attribute(param1);
         return _loc2_ && _loc2_.length() > 0;
      }
      
      public function hasAttributes() : Boolean
      {
         return this._xml.attributes().length() > 0;
      }
      
      private function buildChildrenList() : void
      {
         var _loc2_:XML = null;
         var _loc3_:XData = null;
         var _loc1_:XMLList = this._xml.children();
         this._children = new Vector.<XData>();
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = new XData();
            _loc3_._xml = _loc2_;
            this._children.push(_loc3_);
         }
      }
      
      public function getChild(param1:String) : XData
      {
         var _loc2_:XData = null;
         if(this._children == null)
         {
            this.buildChildrenList();
         }
         for each(_loc2_ in this._children)
         {
            if(_loc2_.getName() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getChildAt(param1:int) : XData
      {
         if(this._children == null)
         {
            this.buildChildrenList();
         }
         if(param1 >= 0 && param1 < this._children.length)
         {
            return this._children[param1];
         }
         throw new Error("index out of bounds!");
      }
      
      public function getChildren() : Vector.<XData>
      {
         if(this._children == null)
         {
            this.buildChildrenList();
         }
         return this._children;
      }
      
      public function appendChild(param1:XData) : XData
      {
         var _loc2_:XData = null;
         if(param1._xml.parent() == this._xml)
         {
            return param1;
         }
         this._xml.appendChild(param1._xml);
         if(this._children != null)
         {
            _loc2_ = new XData();
            _loc2_._xml = param1._xml;
            this._children.push(_loc2_);
         }
         return param1;
      }
      
      public function removeChild(param1:XData) : void
      {
         var _loc2_:int = 0;
         if(param1._xml.parent() == this._xml)
         {
            delete this._xml.children()[param1._xml.childIndex()];
            if(this._children != null)
            {
               _loc2_ = this._children.indexOf(param1);
               if(_loc2_ != -1)
               {
                  this._children.removeAt(_loc2_);
               }
            }
         }
      }
      
      public function removeChildAt(param1:int) : void
      {
         if(param1 >= 0 && param1 < this._xml.children().length())
         {
            delete this._xml.children()[param1];
            if(this._children != null)
            {
               this._children.removeAt(param1);
            }
            return;
         }
         throw new Error("index out of bounds!");
      }
      
      public function removeChildren(param1:String = null) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            this._xml.setChildren("");
            if(this._children != null)
            {
               this._children.length = 0;
            }
         }
         else
         {
            _loc2_ = this._xml[param1];
            _loc3_ = _loc2_.length();
            if(_loc3_)
            {
               _loc4_ = _loc3_;
               while(_loc4_ >= 0)
               {
                  delete _loc2_[_loc4_];
                  if(this._children)
                  {
                     this._children.splice(_loc4_,1);
                  }
                  _loc4_--;
               }
            }
         }
      }
      
      public function getEnumerator(param1:String = null) : XDataEnumerator
      {
         return new XDataEnumerator(this,param1);
      }
      
      public function copy() : XData
      {
         var _loc1_:XData = new XData();
         _loc1_._xml = this._xml.copy();
         return _loc1_;
      }
      
      public function equals(param1:XData) : Boolean
      {
         return param1 && this._xml.toXMLString() == param1._xml.toXMLString();
      }
      
      public function toXML() : XML
      {
         return this._xml;
      }
      
      public function dispose() : void
      {
         if(this._xml)
         {
            System.disposeXML(this._xml);
            this._xml = null;
         }
      }
   }
}

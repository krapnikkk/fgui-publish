package fairygui.editor.publish
{
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.gui.FButton;
   import fairygui.editor.gui.FObjectType;
   import fairygui.editor.gui.FPackage;
   import fairygui.editor.gui.FPackageItemType;
   import fairygui.editor.gui.FTransitionValue;
   import fairygui.editor.gui.gear.FGearBase;
   import fairygui.tween.CurveType;
   import fairygui.tween.EaseType;
   import fairygui.utils.ToolSet;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   import flash.utils.ByteArray;
   
   public class §_-4n§
   {
      
      private static var §_-J9§:FTransitionValue = new FTransitionValue();
      
      private static var §_-H8§:Object = {
         "left-left":0,
         "left-center":1,
         "left-right":2,
         "center-center":3,
         "right-left":4,
         "right-center":5,
         "right-right":6,
         "top-top":7,
         "top-middle":8,
         "top-bottom":9,
         "middle-middle":10,
         "bottom-top":11,
         "bottom-middle":12,
         "bottom-bottom":13,
         "width-width":14,
         "height-height":15,
         "leftext-left":16,
         "leftext-right":17,
         "rightext-left":18,
         "rightext-right":19,
         "topext-top":20,
         "topext-bottom":21,
         "bottomext-top":22,
         "bottomext-bottom":23
      };
       
      
      public var §_-FV§:Array;
      
      private var §_-59§:Object;
      
      private var §_-P4§:int;
      
      private var displayList:Object;
      
      private var §_-67§:Object;
      
      private var §_-Ck§:int;
      
      private var publishData:§_-4Z§;
      
      private var helperIntList:Vector.<int>;
      
      public function §_-4n§()
      {
         super();
         this.§_-FV§ = [];
         this.§_-67§ = {};
         this.helperIntList = new Vector.<int>();
      }
      
      private static function comparePackage(param1:FPackage, param2:FPackage) : int
      {
         return param1.rootItem.sortKey.localeCompare(param2.rootItem.sortKey);
      }
      
      public function encode(param1:§_-4Z§, param2:Boolean = false) : ByteArray
      {
         var ba:ByteArray = null;
         var ba2:ByteArray = null;
         var arr:Array = null;
         var cnt:int = 0;
         var str:String = null;
         var cntPos:int = 0;
         var element:XData = null;
         var longStrings:ByteArray = null;
         var i:int = 0;
         var pkg:IUIPackage = null;
         var itemId:String = null;
         var atlasId:String = null;
         var binIndex:int = 0;
         var pos:int = 0;
         var len:int = 0;
         var publishData:§_-4Z§ = param1;
         var compress:Boolean = param2;
         this.publishData = publishData;
         var outputDesc:Object = publishData.outputDesc;
         ba = new ByteArray();
         var xml:XData = XData.attach(outputDesc["package.xml"]);
         var resources:Vector.<XData> = xml.getChild("resources").getChildren();
         this.startSegments(ba,6,false);
         this.writeSegmentPos(ba,0);
         var pkgs:Vector.<IUIPackage> = new Vector.<IUIPackage>();
         for(str in publishData.§_-DJ§)
         {
            pkg = publishData.project.getPackage(str);
            if(pkg)
            {
               pkgs.push(pkg);
            }
         }
         pkgs.sort(comparePackage);
         ba.writeShort(pkgs.length);
         i = 0;
         while(i < pkgs.length)
         {
            this.writeString(ba,pkgs[i].id);
            this.writeString(ba,pkgs[i].name);
            i++;
         }
         str = xml.getAttribute("branches");
         if(str)
         {
            arr = str.split(",");
            ba.writeShort(arr.length);
            i = 0;
            while(i < arr.length)
            {
               this.writeString(ba,arr[i]);
               i++;
            }
         }
         else
         {
            ba.writeShort(0);
         }
         this.writeSegmentPos(ba,1);
         ba.writeShort(resources.length);
         for each(element in resources)
         {
            ba2 = this.§_-Ab§(element); // mark
            ba.writeInt(ba2.length);
            ba.writeBytes(ba2);
            ba2.clear();
         }
         this.writeSegmentPos(ba,2);
         cnt = publishData.§_-Fc§.length;
         ba.writeShort(cnt);
         i = 0;
         while(i < cnt)
         {
            arr = publishData.§_-Fc§[i];
            ba2 = new ByteArray();
            itemId = arr[0];
            this.writeString(ba2,itemId);
            binIndex = parseInt(arr[1]);
            if(binIndex >= 0)
            {
               atlasId = "atlas" + binIndex;
            }
            else
            {
               pos = itemId.indexOf("_");
               if(pos == -1)
               {
                  atlasId = "atlas_" + itemId;
               }
               else
               {
                  atlasId = "atlas_" + itemId.substring(0,pos);
               }
            }
            this.writeString(ba2,atlasId);
            ba2.writeInt(arr[2]);
            ba2.writeInt(arr[3]);
            ba2.writeInt(arr[4]);
            ba2.writeInt(arr[5]);
            ba2.writeBoolean(arr[6]);
            if(arr[7] != undefined && (arr[7] != 0 || arr[8] != 0 || arr[9] != arr[4] || arr[10] != arr[5]))
            {
               ba2.writeBoolean(true);
               ba2.writeInt(arr[7]);
               ba2.writeInt(arr[8]);
               ba2.writeInt(arr[9]);
               ba2.writeInt(arr[10]);
            }
            else
            {
               ba2.writeBoolean(false);
            }
            ba.writeShort(ba2.length);
            ba.writeBytes(ba2);
            ba2.clear();
            i++;
         }
         if(publishData.hitTestData.length > 0)
         {
            this.writeSegmentPos(ba,3);
            ba2 = publishData.hitTestData;
            ba2.position = 0;
            cntPos = ba.position;
            ba.writeShort(0);
            cnt = 0;
            while(ba2.bytesAvailable)
            {
               str = ba2.readUTF();
               pos = ba2.position;
               ba2.position = ba2.position + 9;
               len = ba2.readInt();
               ba.writeInt(len + 15);
               this.writeString(ba,str);
               ba.writeBytes(ba2,pos,len + 13);
               ba2.position = pos + 13 + len;
               cnt++;
            }
            this.§_-4J§(ba,cntPos,cnt);
         }
         this.writeSegmentPos(ba,4);
         var longStringsCnt:int = 0;
         cnt = this.§_-FV§.length;
         ba.writeInt(cnt);
         i = 0;
         while(i < cnt)
         {
            try
            {
               ba.writeUTF(this.§_-FV§[i]);
            }
            catch(err:RangeError)
            {
               ba.writeShort(0);
               if(longStrings == null)
               {
                  longStrings = new ByteArray();
               }
               longStrings.writeShort(i);
               pos = longStrings.position;
               longStrings.writeInt(0);
               longStrings.writeUTFBytes(§_-FV§[i]);
               len = longStrings.position - pos - 4;
               longStrings.position = pos;
               longStrings.writeInt(len);
               longStrings.position = longStrings.length;
               longStringsCnt++;
            }
            i++;
         }
         if(longStringsCnt > 0)
         {
            this.writeSegmentPos(ba,5);
            ba.writeInt(longStringsCnt);
            ba.writeBytes(longStrings);
            longStrings.clear();
         }
         ba2 = ba;
         ba = new ByteArray();
         ba.writeByte("F".charCodeAt(0));
         ba.writeByte("G".charCodeAt(0));
         ba.writeByte("U".charCodeAt(0));
         ba.writeByte("I".charCodeAt(0));
         ba.writeInt(2);
         ba.writeBoolean(compress);
         ba.writeUTF(xml.getAttribute("id"));
         ba.writeUTF(xml.getAttribute("name"));
         i = 0;
         while(i < 20)
         {
            ba.writeByte(0);
            i++;
         }
         if(compress)
         {
            ba2.deflate();
         }
         ba.writeBytes(ba2);
         ba2.clear();
         return ba;
      }
      
      private function §_-Ab§(param1:XData) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc8_:String = null;
         var _loc9_:XML = null;
         var _loc10_:String = null;
         var _loc2_:ByteArray = new ByteArray();
         var _loc7_:String = param1.getName();
         switch(_loc7_)
         {
            case FPackageItemType.IMAGE:
               _loc2_.writeByte(0);
               break;
            case FPackageItemType.MOVIECLIP:
               _loc2_.writeByte(1);
               break;
            case FPackageItemType.SOUND:
               _loc2_.writeByte(2);
               break;
            case FPackageItemType.COMPONENT:
               _loc2_.writeByte(3);
               break;
            case FPackageItemType.ATLAS:
               _loc2_.writeByte(4);
               break;
            case FPackageItemType.FONT:
               _loc2_.writeByte(5);
               break;
            case FPackageItemType.SWF:
               _loc2_.writeByte(6);
               break;
            case FPackageItemType.MISC:
               _loc2_.writeByte(7);
               break;
            default:
               _loc2_.writeByte(8);
         }
         _loc8_ = param1.getAttribute("id");
         this.writeString(_loc2_,_loc8_);
         this.writeString(_loc2_,param1.getAttribute("name",""));
         this.writeString(_loc2_,param1.getAttribute("path",""));
         if(_loc7_ == FPackageItemType.SOUND || _loc7_ == FPackageItemType.SWF || _loc7_ == FPackageItemType.ATLAS || _loc7_ == FPackageItemType.MISC)
         {
            this.writeString(_loc2_,param1.getAttribute("file",""));
         }
         else
         {
            this.writeString(_loc2_,null);
         }
         _loc2_.writeBoolean(param1.getAttributeBool("exported"));
         _loc4_ = param1.getAttribute("size","");
         _loc5_ = _loc4_.split(",");
         _loc2_.writeInt(parseInt(_loc5_[0]));
         _loc2_.writeInt(parseInt(_loc5_[1]));
         switch(param1.getName())
         {
            case FPackageItemType.IMAGE:
               _loc4_ = param1.getAttribute("scale");
               if(_loc4_ == "9grid")
               {
                  _loc2_.writeByte(1);
                  _loc4_ = param1.getAttribute("scale9grid");
                  if(_loc4_)
                  {
                     _loc5_ = _loc4_.split(",");
                     _loc2_.writeInt(parseInt(_loc5_[0]));
                     _loc2_.writeInt(parseInt(_loc5_[1]));
                     _loc2_.writeInt(parseInt(_loc5_[2]));
                     _loc2_.writeInt(parseInt(_loc5_[3]));
                  }
                  else
                  {
                     _loc2_.writeInt(0);
                     _loc2_.writeInt(0);
                     _loc2_.writeInt(0);
                     _loc2_.writeInt(0);
                  }
                  _loc2_.writeInt(param1.getAttributeInt("gridTile"));
               }
               else if(_loc4_ == "tile")
               {
                  _loc2_.writeByte(2);
               }
               else
               {
                  _loc2_.writeByte(0);
               }
               _loc2_.writeBoolean(param1.getAttributeBool("smoothing",true));
               break;
            case FPackageItemType.MOVIECLIP:
               _loc2_.writeBoolean(param1.getAttributeBool("smoothing",true));
               _loc9_ = this.publishData.outputDesc[_loc8_ + ".xml"];
               if(_loc9_)
               {
                  _loc3_ = this.§_-3y§(_loc8_,_loc9_);
                  _loc2_.writeInt(_loc3_.length);
                  _loc2_.writeBytes(_loc3_);
                  _loc3_.clear();
               }
               else
               {
                  _loc2_.writeInt(0);
               }
               break;
            case FPackageItemType.FONT:
               _loc4_ = this.publishData.outputDesc[_loc8_ + ".fnt"];
               if(_loc4_)
               {
                  _loc3_ = this.§_-Ox§(_loc8_,_loc4_); // mark
                  _loc2_.writeInt(_loc3_.length);
                  _loc2_.writeBytes(_loc3_);
                  _loc3_.clear();
               }
               else
               {
                  _loc2_.writeInt(0);
               }
               break;
            case FPackageItemType.COMPONENT:
               _loc9_ = this.publishData.outputDesc[_loc8_ + ".xml"];
               if(_loc9_)
               {
                  _loc10_ = _loc9_.@extention;
                  if(_loc10_)
                  {
                     switch(_loc10_)
                     {
                        case FObjectType.EXT_LABEL:
                           _loc2_.writeByte(11);
                           break;
                        case FObjectType.EXT_BUTTON:
                           _loc2_.writeByte(12);
                           break;
                        case FObjectType.EXT_COMBOBOX:
                           _loc2_.writeByte(13);
                           break;
                        case FObjectType.EXT_PROGRESS_BAR:
                           _loc2_.writeByte(14);
                           break;
                        case FObjectType.EXT_SLIDER:
                           _loc2_.writeByte(15);
                           break;
                        case FObjectType.EXT_SCROLLBAR:
                           _loc2_.writeByte(16);
                           break;
                        default:
                           _loc2_.writeByte(0);
                     }
                  }
                  else
                  {
                     _loc2_.writeByte(0);
                  }
                  _loc3_ = this.§_-KC§(_loc8_,XData.attach(_loc9_)); // mark
                  _loc2_.writeInt(_loc3_.length);
                  _loc2_.writeBytes(_loc3_);
                  _loc3_.clear();
               }
               else
               {
                  _loc2_.writeByte(0);
                  _loc2_.writeInt(0);
               }
         }
         _loc4_ = param1.getAttribute("branch");
         this.writeString(_loc2_,_loc4_);
         _loc4_ = param1.getAttribute("branches");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc2_.writeByte(_loc5_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               this.writeString(_loc2_,_loc5_[_loc6_]);
               _loc6_++;
            }
         }
         else
         {
            _loc2_.writeByte(0);
         }
         _loc4_ = param1.getAttribute("highRes");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc2_.writeByte(_loc5_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               this.writeString(_loc2_,_loc5_[_loc6_]);
               _loc6_++;
            }
         }
         else
         {
            _loc2_.writeByte(0);
         }
         return _loc2_;
      }
      
      private function §_-KC§(param1:String, param2:XData) : ByteArray
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<XData> = null;
         var _loc9_:XData = null;
         var _loc10_:ByteArray = null;
         var _loc11_:int = 0;
         var _loc15_:XData = null;
         var _loc3_:ByteArray = new ByteArray();
         this.§_-59§ = {};
         this.§_-P4§ = 0;
         this.displayList = {};
         _loc9_ = param2.getChild("displayList");
         if(_loc9_ != null)
         {
            _loc8_ = _loc9_.getChildren();
            _loc7_ = _loc8_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               this.displayList[_loc8_[_loc6_].getAttribute("id")] = _loc6_;
               _loc6_++;
            }
         }
         this.startSegments(_loc3_,8,false);
         this.writeSegmentPos(_loc3_,0);
         _loc4_ = param2.getAttribute("size","");
         _loc5_ = _loc4_.split(",");
         _loc3_.writeInt(parseInt(_loc5_[0]));
         _loc3_.writeInt(parseInt(_loc5_[1]));
         _loc4_ = param2.getAttribute("restrictSize");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc3_.writeBoolean(true);
            _loc3_.writeInt(parseInt(_loc5_[0]));
            _loc3_.writeInt(parseInt(_loc5_[1]));
            _loc3_.writeInt(parseInt(_loc5_[2]));
            _loc3_.writeInt(parseInt(_loc5_[3]));
         }
         else
         {
            _loc3_.writeBoolean(false);
         }
         _loc4_ = param2.getAttribute("pivot");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc3_.writeBoolean(true);
            _loc3_.writeFloat(parseFloat(_loc5_[0]));
            _loc3_.writeFloat(parseFloat(_loc5_[1]));
            _loc3_.writeBoolean(param2.getAttributeBool("anchor"));
         }
         else
         {
            _loc3_.writeBoolean(false);
         }
         _loc4_ = param2.getAttribute("margin");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc3_.writeBoolean(true);
            _loc3_.writeInt(parseInt(_loc5_[0]));
            _loc3_.writeInt(parseInt(_loc5_[1]));
            _loc3_.writeInt(parseInt(_loc5_[2]));
            _loc3_.writeInt(parseInt(_loc5_[3]));
         }
         else
         {
            _loc3_.writeBoolean(false);
         }
         var _loc12_:Boolean = false;
         _loc4_ = param2.getAttribute("overflow");
         if(_loc4_ == "hidden")
         {
            _loc3_.writeByte(1);
         }
         else if(_loc4_ == "scroll")
         {
            _loc3_.writeByte(2);
            _loc12_ = true;
         }
         else
         {
            _loc3_.writeByte(0);
         }
         _loc4_ = param2.getAttribute("clipSoftness");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc3_.writeBoolean(true);
            _loc3_.writeInt(parseInt(_loc5_[0]));
            _loc3_.writeInt(parseInt(_loc5_[1]));
         }
         else
         {
            _loc3_.writeBoolean(false);
         }
         this.writeSegmentPos(_loc3_,1);
         _loc7_ = 0;
         _loc11_ = _loc3_.position;
         _loc3_.writeShort(0);
         var _loc13_:XDataEnumerator = param2.getEnumerator("controller");
         while(_loc13_.moveNext())
         {
            _loc10_ = this.§_-66§(_loc13_.current);
            _loc3_.writeShort(_loc10_.length);
            _loc3_.writeBytes(_loc10_);
            _loc10_.clear();
            _loc7_++;
         }
         this.§_-4J§(_loc3_,_loc11_,_loc7_);
         this.writeSegmentPos(_loc3_,2);
         if(_loc9_ != null)
         {
            _loc8_ = _loc9_.getChildren();
            _loc7_ = _loc8_.length;
            _loc3_.writeShort(_loc7_);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc10_ = this.§_-2N§(_loc8_[_loc6_]); // mark
               _loc3_.writeShort(_loc10_.length);
               _loc3_.writeBytes(_loc10_);
               _loc10_.clear();
               _loc6_++;
            }
         }
         else
         {
            _loc3_.writeShort(0);
         }
         this.writeSegmentPos(_loc3_,3);
         this.§_-57§(param2,_loc3_,true);
         this.writeSegmentPos(_loc3_,4);
         this.writeString(_loc3_,param2.getAttribute("customData"),true);
         _loc3_.writeBoolean(param2.getAttributeBool("opaque",true));
         _loc4_ = param2.getAttribute("mask");
         if(this.displayList[_loc4_] != undefined)
         {
            _loc3_.writeShort(this.displayList[_loc4_]);
            _loc3_.writeBoolean(param2.getAttributeBool("reversedMask"));
         }
         else
         {
            _loc3_.writeShort(-1);
         }
         _loc4_ = param2.getAttribute("hitTest");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            if(_loc5_.length == 1)
            {
               this.writeString(_loc3_,null);
               _loc3_.writeInt(1);
               if(this.displayList[_loc5_[0]] != undefined)
               {
                  _loc3_.writeInt(this.displayList[_loc5_[0]]);
               }
               else
               {
                  _loc3_.writeInt(-1);
               }
            }
            else
            {
               this.writeString(_loc3_,_loc5_[0]);
               _loc3_.writeInt(parseInt(_loc5_[1]));
               _loc3_.writeInt(parseInt(_loc5_[2]));
            }
         }
         else
         {
            this.writeString(_loc3_,null);
            _loc3_.writeInt(0);
            _loc3_.writeInt(0);
         }
         this.writeSegmentPos(_loc3_,5);
         _loc7_ = 0;
         _loc11_ = _loc3_.position;
         _loc3_.writeShort(0);
         _loc13_ = param2.getEnumerator("transition");
         while(_loc13_.moveNext())
         {
            _loc10_ = this.§_-70§(_loc13_.current);
            _loc3_.writeShort(_loc10_.length);
            _loc3_.writeBytes(_loc10_);
            _loc10_.clear();
            _loc7_++;
         }
         this.§_-4J§(_loc3_,_loc11_,_loc7_);
         var _loc14_:String = param2.getAttribute("extention");
         if(_loc14_)
         {
            this.writeSegmentPos(_loc3_,6);
            _loc15_ = param2.getChild(_loc14_);
            if(!_loc15_)
            {
               _loc15_ = XData.create(_loc14_);
            }
            switch(_loc14_)
            {
               case FObjectType.EXT_LABEL:
                  break;
               case FObjectType.EXT_BUTTON:
                  _loc4_ = _loc15_.getAttribute("mode");
                  if(_loc4_ == FButton.CHECK)
                  {
                     _loc3_.writeByte(1);
                  }
                  else if(_loc4_ == FButton.RADIO)
                  {
                     _loc3_.writeByte(2);
                  }
                  else
                  {
                     _loc3_.writeByte(0);
                  }
                  this.writeString(_loc3_,_loc15_.getAttribute("sound"));
                  _loc3_.writeFloat(_loc15_.getAttributeInt("volume",100) / 100);
                  _loc4_ = _loc15_.getAttribute("downEffect","none");
                  if(_loc4_ == "dark")
                  {
                     _loc3_.writeByte(1);
                  }
                  else if(_loc4_ == "scale")
                  {
                     _loc3_.writeByte(2);
                  }
                  else
                  {
                     _loc3_.writeByte(0);
                  }
                  _loc3_.writeFloat(_loc15_.getAttributeFloat("downEffectValue",0.8));
                  break;
               case FObjectType.EXT_COMBOBOX:
                  this.writeString(_loc3_,_loc15_.getAttribute("dropdown"));
                  break;
               case FObjectType.EXT_PROGRESS_BAR:
                  _loc4_ = _loc15_.getAttribute("titleType");
                  switch(_loc4_)
                  {
                     case "percent":
                        _loc3_.writeByte(0);
                        break;
                     case "valueAndmax":
                        _loc3_.writeByte(1);
                        break;
                     case "value":
                        _loc3_.writeByte(2);
                        break;
                     case "max":
                        _loc3_.writeByte(3);
                        break;
                     default:
                        _loc3_.writeByte(0);
                  }
                  _loc3_.writeBoolean(_loc15_.getAttributeBool("reverse"));
                  break;
               case FObjectType.EXT_SLIDER:
                  _loc4_ = _loc15_.getAttribute("titleType");
                  switch(_loc4_)
                  {
                     case "percent":
                        _loc3_.writeByte(0);
                        break;
                     case "valueAndmax":
                        _loc3_.writeByte(1);
                        break;
                     case "value":
                        _loc3_.writeByte(2);
                        break;
                     case "max":
                        _loc3_.writeByte(3);
                        break;
                     default:
                        _loc3_.writeByte(0);
                  }
                  _loc3_.writeBoolean(_loc15_.getAttributeBool("reverse"));
                  _loc3_.writeBoolean(_loc15_.getAttributeBool("wholeNumbers"));
                  _loc3_.writeBoolean(_loc15_.getAttributeBool("changeOnClick",true));
                  break;
               case FObjectType.EXT_SCROLLBAR:
                  _loc3_.writeBoolean(_loc15_.getAttributeBool("fixedGripSize"));
            }
         }
         if(_loc12_)
         {
            this.writeSegmentPos(_loc3_,7);
            _loc10_ = this.§_-Nu§(param2);
            _loc3_.writeBytes(_loc10_);
            _loc10_.clear();
         }
         return _loc3_;
      }
      
      private function §_-66§(param1:XData) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:XData = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         this.startSegments(_loc2_,3,true);
         this.writeSegmentPos(_loc2_,0);
         _loc4_ = param1.getAttribute("name");
         this.writeString(_loc2_,_loc4_);
         this.§_-59§[_loc4_] = this.§_-P4§++;
         _loc2_.writeBoolean(param1.getAttributeBool("autoRadioGroupDepth"));
         this.writeSegmentPos(_loc2_,1);
         _loc4_ = param1.getAttribute("pages");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc7_ = _loc5_.length / 2;
            _loc2_.writeShort(_loc7_);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               this.writeString(_loc2_,_loc5_[_loc6_ * 2],false,false);
               this.writeString(_loc2_,_loc5_[_loc6_ * 2 + 1],false,false);
               _loc6_++;
            }
            _loc11_ = param1.getAttribute("homePageType","default");
            _loc12_ = param1.getAttribute("homePage","");
            _loc13_ = 0;
            if(_loc11_ == "specific")
            {
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(_loc5_[_loc6_ * 2] == _loc12_)
                  {
                     _loc13_ = _loc6_;
                     break;
                  }
                  _loc6_++;
               }
            }
            switch(_loc11_)
            {
               case "specific":
                  _loc2_.writeByte(1);
                  _loc2_.writeShort(_loc13_);
                  break;
               case "branch":
                  _loc2_.writeByte(2);
                  break;
               case "variable":
                  _loc2_.writeByte(3);
                  this.writeString(_loc2_,_loc12_);
                  break;
               default:
                  _loc2_.writeByte(0);
            }
         }
         else
         {
            _loc2_.writeShort(0);
            _loc2_.writeByte(0);
         }
         this.writeSegmentPos(_loc2_,2);
         var _loc9_:Vector.<XData> = param1.getChildren();
         _loc7_ = 0;
         _loc8_ = _loc2_.position;
         _loc2_.writeShort(0);
         for each(_loc10_ in _loc9_)
         {
            if(_loc10_.getName() == "action")
            {
               _loc4_ = _loc10_.getAttribute("type");
               _loc3_ = this.§_-KY§(_loc4_,_loc10_);
               _loc2_.writeShort(_loc3_.length + 1);
               if(_loc4_ == "play_transition")
               {
                  _loc2_.writeByte(0);
               }
               else if(_loc4_ == "change_page")
               {
                  _loc2_.writeByte(1);
               }
               else
               {
                  _loc2_.writeByte(0);
               }
               _loc2_.writeBytes(_loc3_);
               _loc7_++;
            }
         }
         this.§_-4J§(_loc2_,_loc8_,_loc7_);
         return _loc2_;
      }
      
      private function §_-KY§(param1:String, param2:XData) : ByteArray
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:ByteArray = new ByteArray();
         _loc4_ = param2.getAttribute("fromPage");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc6_ = _loc5_.length;
            _loc3_.writeShort(_loc6_);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               this.writeString(_loc3_,_loc5_[_loc7_]);
               _loc7_++;
            }
         }
         else
         {
            _loc3_.writeShort(0);
         }
         _loc4_ = param2.getAttribute("toPage");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc6_ = _loc5_.length;
            _loc3_.writeShort(_loc6_);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               this.writeString(_loc3_,_loc5_[_loc7_]);
               _loc7_++;
            }
         }
         else
         {
            _loc3_.writeShort(0);
         }
         if(param1 == "play_transition")
         {
            this.writeString(_loc3_,param2.getAttribute("transition"));
            _loc3_.writeInt(param2.getAttributeInt("repeat",1));
            _loc3_.writeFloat(param2.getAttributeFloat("delay"));
            _loc3_.writeBoolean(param2.getAttributeBool("stopOnExit"));
         }
         else if(param1 == "change_page")
         {
            this.writeString(_loc3_,param2.getAttribute("objectId"));
            this.writeString(_loc3_,param2.getAttribute("controller"));
            this.writeString(_loc3_,param2.getAttribute("targetPage"));
         }
         return _loc3_;
      }
      
      private function §_-57§(param1:XData, param2:ByteArray, param3:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc9_:XData = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:int = 0;
         var _loc17_:* = undefined;
         var _loc6_:Array = [];
         var _loc7_:Object = {};
         var _loc8_:XDataEnumerator = param1.getEnumerator("relation");
         while(_loc8_.moveNext())
         {
            _loc9_ = _loc8_.current;
            _loc4_ = _loc9_.getAttribute("target");
            _loc10_ = -1;
            if(_loc4_)
            {
               if(this.displayList[_loc4_] != undefined)
               {
                  _loc10_ = this.displayList[_loc4_];
               }
               else
               {
                  continue;
               }
            }
            else if(param3)
            {
               continue;
            }
            _loc4_ = _loc9_.getAttribute("sidePair");
            if(_loc4_)
            {
               _loc11_ = _loc7_[_loc10_];
               if(!_loc11_)
               {
                  _loc6_.push(_loc10_);
                  _loc11_ = [];
                  _loc7_[_loc10_] = _loc11_;
               }
               _loc5_ = _loc4_.split(",");
               _loc16_ = 0;
               while(_loc16_ < _loc5_.length)
               {
                  _loc12_ = _loc5_[_loc16_];
                  if(_loc12_)
                  {
                     if(_loc12_.charAt(_loc12_.length - 1) == "%")
                     {
                        _loc12_ = _loc12_.substr(0,_loc12_.length - 1);
                        _loc15_ = true;
                     }
                     else
                     {
                        _loc15_ = false;
                     }
                     _loc17_ = §_-H8§[_loc12_];
                     if(_loc17_ != undefined)
                     {
                        _loc11_.push(!!_loc15_?10000 + _loc17_:_loc17_);
                     }
                  }
                  _loc16_++;
               }
            }
         }
         param2.writeByte(_loc6_.length);
         for each(_loc10_ in _loc6_)
         {
            param2.writeShort(_loc10_);
            _loc11_ = _loc7_[_loc10_];
            param2.writeByte(_loc11_.length);
            for each(_loc16_ in _loc11_)
            {
               if(_loc16_ >= 10000)
               {
                  param2.writeByte(_loc16_ - 10000);
                  param2.writeBoolean(true);
               }
               else
               {
                  param2.writeByte(_loc16_);
                  param2.writeBoolean(false);
               }
            }
         }
      }
      
      private function §_-Nu§(param1:XData) : ByteArray
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc2_:ByteArray = new ByteArray();
         _loc3_ = param1.getAttribute("scroll");
         if(_loc3_ == "horizontal")
         {
            _loc2_.writeByte(0);
         }
         else if(_loc3_ == "both")
         {
            _loc2_.writeByte(2);
         }
         else
         {
            _loc2_.writeByte(1);
         }
         _loc3_ = param1.getAttribute("scrollBar");
         if(_loc3_ == "visible")
         {
            _loc2_.writeByte(1);
         }
         else if(_loc3_ == "auto")
         {
            _loc2_.writeByte(2);
         }
         else if(_loc3_ == "hidden")
         {
            _loc2_.writeByte(3);
         }
         else
         {
            _loc2_.writeByte(0);
         }
         _loc2_.writeInt(param1.getAttributeInt("scrollBarFlags"));
         _loc3_ = param1.getAttribute("scrollBarMargin");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            _loc2_.writeBoolean(true);
            _loc2_.writeInt(parseInt(_loc4_[0]));
            _loc2_.writeInt(parseInt(_loc4_[1]));
            _loc2_.writeInt(parseInt(_loc4_[2]));
            _loc2_.writeInt(parseInt(_loc4_[3]));
         }
         else
         {
            _loc2_.writeBoolean(false);
         }
         _loc3_ = param1.getAttribute("scrollBarRes");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            this.writeString(_loc2_,_loc4_[0]);
            this.writeString(_loc2_,_loc4_[1]);
         }
         else
         {
            this.writeString(_loc2_,null);
            this.writeString(_loc2_,null);
         }
         _loc3_ = param1.getAttribute("ptrRes");
         if(_loc3_)
         {
            _loc4_ = _loc3_.split(",");
            this.writeString(_loc2_,_loc4_[0]);
            this.writeString(_loc2_,_loc4_[1]);
         }
         else
         {
            this.writeString(_loc2_,null);
            this.writeString(_loc2_,null);
         }
         return _loc2_;
      }
      
      private function §_-70§(param1:XData) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc11_:XData = null;
         var _loc12_:String = null;
         var _loc13_:* = undefined;
         var _loc2_:ByteArray = new ByteArray();
         this.writeString(_loc2_,param1.getAttribute("name"));
         _loc2_.writeInt(param1.getAttributeInt("options"));
         _loc2_.writeBoolean(param1.getAttributeBool("autoPlay"));
         _loc2_.writeInt(param1.getAttributeInt("autoPlayRepeat",1));
         _loc2_.writeFloat(param1.getAttributeFloat("autoPlayDelay"));
         _loc4_ = param1.getAttribute("frameRate");
         if(_loc4_)
         {
            _loc9_ = 1 / parseInt(_loc4_);
         }
         else
         {
            _loc9_ = 1 / 24;
         }
         _loc8_ = _loc2_.position;
         _loc2_.writeShort(0);
         _loc7_ = 0;
         var _loc10_:XDataEnumerator = param1.getEnumerator("item");
         while(_loc10_.moveNext())
         {
            _loc11_ = _loc10_.current;
            _loc3_ = new ByteArray();
            this.startSegments(_loc3_,4,true);
            this.writeSegmentPos(_loc3_,0);
            _loc12_ = _loc11_.getAttribute("type");
            this.§_-Gc§(_loc3_,_loc12_);
            _loc3_.writeFloat(_loc11_.getAttributeInt("time") * _loc9_);
            _loc4_ = _loc11_.getAttribute("target");
            if(!_loc4_)
            {
               _loc3_.writeShort(-1);
            }
            else
            {
               _loc13_ = this.displayList[_loc4_];
               if(_loc13_ == undefined)
               {
                  _loc3_.clear();
                  continue;
               }
               _loc3_.writeShort(int(_loc13_));
            }
            this.writeString(_loc3_,_loc11_.getAttribute("label"));
            _loc4_ = _loc11_.getAttribute("endValue");
            if(_loc11_.getAttributeBool("tween") && _loc4_ != null)
            {
               _loc3_.writeBoolean(true);
               this.writeSegmentPos(_loc3_,1);
               _loc3_.writeFloat(_loc11_.getAttributeInt("duration") * _loc9_);
               _loc3_.writeByte(EaseType.parseEaseType(_loc11_.getAttribute("ease")));
               _loc3_.writeInt(_loc11_.getAttributeInt("repeat"));
               _loc3_.writeBoolean(_loc11_.getAttributeBool("yoyo"));
               this.writeString(_loc3_,_loc11_.getAttribute("label2"));
               this.writeSegmentPos(_loc3_,2);
               _loc4_ = _loc11_.getAttribute("startValue");
               this.§_-Ok§(_loc3_,_loc12_,_loc4_);
               this.writeSegmentPos(_loc3_,3);
               _loc4_ = _loc11_.getAttribute("endValue");
               this.§_-Ok§(_loc3_,_loc12_,_loc4_);
               _loc4_ = _loc11_.getAttribute("path");
               this.§_-Pk§(_loc4_,_loc3_);
            }
            else
            {
               _loc3_.writeBoolean(false);
               this.writeSegmentPos(_loc3_,2);
               _loc4_ = _loc11_.getAttribute("value");
               if(_loc4_ == null)
               {
                  _loc4_ = _loc11_.getAttribute("startValue");
               }
               this.§_-Ok§(_loc3_,_loc12_,_loc4_);
            }
            _loc2_.writeShort(_loc3_.length);
            _loc2_.writeBytes(_loc3_);
            _loc3_.clear();
            _loc7_++;
         }
         this.§_-4J§(_loc2_,_loc8_,_loc7_);
         return _loc2_;
      }
      
      private function §_-Pk§(param1:String, param2:ByteArray) : void
      {
         var _loc9_:int = 0;
         if(!param1)
         {
            param2.writeInt(0);
            return;
         }
         var _loc3_:int = param2.position;
         param2.writeInt(0);
         var _loc4_:Array = param1.split(",");
         var _loc5_:int = _loc4_.length;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_++;
            _loc9_ = parseInt(_loc4_[_loc7_++]);
            param2.writeByte(_loc9_);
            switch(_loc9_)
            {
               case CurveType.Bezier:
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  continue;
               case CurveType.CubicBezier:
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  _loc7_++;
                  continue;
               default:
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                  continue;
            }
         }
         var _loc8_:int = param2.position;
         param2.position = _loc3_;
         param2.writeInt(_loc6_);
         param2.position = _loc8_;
      }
      
      private function §_-9Z§(param1:XData, param2:ByteArray) : void
      {
         var _loc3_:int = param2.position;
         param2.writeShort(0);
         var _loc4_:int = 0;
         var _loc5_:XDataEnumerator = param1.getEnumerator("property");
         while(_loc5_.moveNext())
         {
            this.writeString(param2,_loc5_.current.getAttribute("target"));
            param2.writeShort(_loc5_.current.getAttributeInt("propertyId"));
            this.writeString(param2,_loc5_.current.getAttribute("value"),true,true);
            _loc4_++;
         }
         this.§_-4J§(param2,_loc3_,_loc4_);
      }
      
      private function §_-2N§(param1:XData) : ByteArray
      {
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<XData> = null;
         var _loc9_:XData = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:XData = null;
         var _loc15_:int = 0;
         var _loc16_:* = undefined;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Boolean = false;
         var _loc27_:XData = null;
         var _loc28_:XDataEnumerator = null;
         var _loc29_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         var _loc12_:String = param1.getName();
         switch(_loc12_)
         {
            case FObjectType.IMAGE:
               _loc11_ = 0;
               break;
            case FObjectType.MOVIECLIP:
               _loc11_ = 1;
               break;
            case FObjectType.SWF:
               _loc11_ = 2;
               break;
            case FObjectType.GRAPH:
               _loc11_ = 3;
               break;
            case FObjectType.LOADER:
               _loc11_ = 4;
               break;
            case FObjectType.GROUP:
               _loc11_ = 5;
               break;
            case FObjectType.TEXT:
               if(param1.getAttributeBool("input"))
               {
                  _loc11_ = 8;
               }
               else
               {
                  _loc11_ = 6;
               }
               break;
            case FObjectType.RICHTEXT:
               _loc11_ = 7;
               break;
            case FObjectType.COMPONENT:
               _loc11_ = 9;
               break;
            case FObjectType.LIST:
               if(param1.getAttributeBool("treeView"))
               {
                  _loc11_ = 17;
               }
               else
               {
                  _loc11_ = 10;
               }
               break;
            default:
               _loc11_ = 0;
         }
         if(_loc11_ == 17)
         {
            _loc13_ = 10;
         }
         else if(_loc11_ == 10)
         {
            _loc13_ = 9;
         }
         else
         {
            _loc13_ = 7;
         }
         this.startSegments(_loc2_,_loc13_,true);
         this.writeSegmentPos(_loc2_,0);
         _loc2_.writeByte(_loc11_);
         this.writeString(_loc2_,param1.getAttribute("src"));
         this.writeString(_loc2_,param1.getAttribute("pkg"));
         this.writeString(_loc2_,param1.getAttribute("id",""));
         this.writeString(_loc2_,param1.getAttribute("name",""));
         _loc4_ = param1.getAttribute("xy");
         _loc5_ = _loc4_.split(",");
         _loc2_.writeInt(int(_loc5_[0]));
         _loc2_.writeInt(int(_loc5_[1]));
         _loc4_ = param1.getAttribute("size");
         if(_loc4_)
         {
            _loc2_.writeBoolean(true);
            _loc5_ = _loc4_.split(",");
            _loc2_.writeInt(parseInt(_loc5_[0]));
            _loc2_.writeInt(parseInt(_loc5_[1]));
         }
         else
         {
            _loc2_.writeBoolean(false);
         }
         _loc4_ = param1.getAttribute("restrictSize");
         if(_loc4_)
         {
            _loc2_.writeBoolean(true);
            _loc5_ = _loc4_.split(",");
            _loc2_.writeInt(parseInt(_loc5_[0]));
            _loc2_.writeInt(parseInt(_loc5_[1]));
            _loc2_.writeInt(parseInt(_loc5_[2]));
            _loc2_.writeInt(parseInt(_loc5_[3]));
         }
         else
         {
            _loc2_.writeBoolean(false);
         }
         _loc4_ = param1.getAttribute("scale");
         if(_loc4_)
         {
            _loc2_.writeBoolean(true);
            _loc5_ = _loc4_.split(",");
            _loc2_.writeFloat(parseFloat(_loc5_[0]));
            _loc2_.writeFloat(parseFloat(_loc5_[1]));
         }
         else
         {
            _loc2_.writeBoolean(false);
         }
         _loc4_ = param1.getAttribute("skew");
         if(_loc4_)
         {
            _loc2_.writeBoolean(true);
            _loc5_ = _loc4_.split(",");
            _loc2_.writeFloat(parseFloat(_loc5_[0]));
            _loc2_.writeFloat(parseFloat(_loc5_[1]));
         }
         else
         {
            _loc2_.writeBoolean(false);
         }
         _loc4_ = param1.getAttribute("pivot");
         if(_loc4_)
         {
            _loc5_ = _loc4_.split(",");
            _loc2_.writeBoolean(true);
            _loc2_.writeFloat(parseFloat(_loc5_[0]));
            _loc2_.writeFloat(parseFloat(_loc5_[1]));
            _loc2_.writeBoolean(param1.getAttributeBool("anchor"));
         }
         else
         {
            _loc2_.writeBoolean(false);
         }
         _loc2_.writeFloat(param1.getAttributeFloat("alpha",1));
         _loc2_.writeFloat(param1.getAttributeFloat("rotation"));
         _loc2_.writeBoolean(param1.getAttributeBool("visible",true));
         _loc2_.writeBoolean(param1.getAttributeBool("touchable",true));
         _loc2_.writeBoolean(param1.getAttributeBool("grayed"));
         _loc4_ = param1.getAttribute("blend");
         switch(_loc4_)
         {
            case "add":
               _loc2_.writeByte(2);
               break;
            case "multiply":
               _loc2_.writeByte(3);
               break;
            case "none":
               _loc2_.writeByte(1);
               break;
            case "screen":
               _loc2_.writeByte(4);
               break;
            case "erase":
               _loc2_.writeByte(5);
               break;
            default:
               _loc2_.writeByte(0);
         }
         _loc4_ = param1.getAttribute("filter");
         if(_loc4_)
         {
            if(_loc4_ == "color")
            {
               _loc2_.writeByte(1);
               _loc4_ = param1.getAttribute("filterData");
               _loc5_ = _loc4_.split(",");
               _loc2_.writeFloat(parseFloat(_loc5_[0]));
               _loc2_.writeFloat(parseFloat(_loc5_[1]));
               _loc2_.writeFloat(parseFloat(_loc5_[2]));
               _loc2_.writeFloat(parseFloat(_loc5_[3]));
            }
            else
            {
               _loc2_.writeByte(0);
            }
         }
         else
         {
            _loc2_.writeByte(0);
         }
         this.writeString(_loc2_,param1.getAttribute("customData"),true);
         this.writeSegmentPos(_loc2_,1);
         this.writeString(_loc2_,param1.getAttribute("tooltips"),true);
         _loc4_ = param1.getAttribute("group");
         if(_loc4_ && this.displayList[_loc4_] != undefined)
         {
            _loc2_.writeShort(this.displayList[_loc4_]);
         }
         else
         {
            _loc2_.writeShort(-1);
         }
         this.writeSegmentPos(_loc2_,2);
         _loc8_ = param1.getChildren();
         _loc7_ = 0;
         _loc10_ = _loc2_.position;
         _loc2_.writeShort(0);
         for each(_loc14_ in _loc8_)
         {
            _loc15_ = FGearBase.getIndexByName(_loc14_.getName());
            if(_loc15_ != -1)
            {
               _loc3_ = this.§_-7Q§(int(_loc15_),_loc14_); // mark
               if(_loc3_ != null)
               {
                  _loc7_++;
                  _loc2_.writeShort(_loc3_.length + 1);
                  _loc2_.writeByte(_loc15_);
                  _loc2_.writeBytes(_loc3_);
                  _loc3_.clear();
               }
            }
         }
         this.§_-4J§(_loc2_,_loc10_,_loc7_);
         this.writeSegmentPos(_loc2_,3);
         this.§_-57§(param1,_loc2_,false);
         if(_loc12_ == FObjectType.COMPONENT || _loc12_ == FObjectType.LIST)
         {
            this.writeSegmentPos(_loc2_,4);
            _loc16_ = this.§_-59§[param1.getAttribute("pageController")];
            if(_loc16_ != undefined)
            {
               _loc2_.writeShort(_loc16_);
            }
            else
            {
               _loc2_.writeShort(-1);
            }
            _loc4_ = param1.getAttribute("controller");
            if(_loc4_)
            {
               _loc10_ = _loc2_.position;
               _loc2_.writeShort(0);
               _loc5_ = _loc4_.split(",");
               _loc7_ = 0;
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  if(_loc5_[_loc6_])
                  {
                     this.writeString(_loc2_,_loc5_[_loc6_]);
                     this.writeString(_loc2_,_loc5_[_loc6_ + 1]);
                     _loc7_++;
                  }
                  _loc6_ = _loc6_ + 2;
               }
               this.§_-4J§(_loc2_,_loc10_,_loc7_);
            }
            else
            {
               _loc2_.writeShort(0);
            }
            this.§_-9Z§(param1,_loc2_);
         }
         else if(_loc11_ == 8)
         {
            this.writeSegmentPos(_loc2_,4);
            this.writeString(_loc2_,param1.getAttribute("prompt"));
            this.writeString(_loc2_,param1.getAttribute("restrict"));
            _loc2_.writeInt(param1.getAttributeInt("maxLength"));
            _loc2_.writeInt(param1.getAttributeInt("keyboardType"));
            _loc2_.writeBoolean(param1.getAttributeBool("password"));
         }
         this.writeSegmentPos(_loc2_,5);
         switch(_loc12_)
         {
            case FObjectType.IMAGE:
               _loc4_ = param1.getAttribute("color");
               if(_loc4_)
               {
                  _loc2_.writeBoolean(true);
                  this.§_-5g§(_loc2_,_loc4_,false);
               }
               else
               {
                  _loc2_.writeBoolean(false);
               }
               _loc4_ = param1.getAttribute("flip");
               switch(_loc4_)
               {
                  case "both":
                     _loc2_.writeByte(3);
                     break;
                  case "hz":
                     _loc2_.writeByte(1);
                     break;
                  case "vt":
                     _loc2_.writeByte(2);
                     break;
                  default:
                     _loc2_.writeByte(0);
               }
               _loc4_ = param1.getAttribute("fillMethod");
               this.§_-Hl§(_loc2_,_loc4_);
               if(_loc4_ && _loc4_ != "none")
               {
                  _loc2_.writeByte(param1.getAttributeInt("fillOrigin"));
                  _loc2_.writeBoolean(param1.getAttributeBool("fillClockwise",true));
                  _loc2_.writeFloat(param1.getAttributeInt("fillAmount",100) / 100);
               }
               break;
            case FObjectType.MOVIECLIP:
               _loc4_ = param1.getAttribute("color");
               if(_loc4_)
               {
                  _loc2_.writeBoolean(true);
                  this.§_-5g§(_loc2_,_loc4_,false);
               }
               else
               {
                  _loc2_.writeBoolean(false);
               }
               _loc2_.writeByte(0);
               _loc2_.writeInt(param1.getAttributeInt("frame"));
               _loc2_.writeBoolean(param1.getAttributeBool("playing",true));
               break;
            case FObjectType.GRAPH:
               _loc4_ = param1.getAttribute("type");
               _loc17_ = this.§_-H3§(_loc2_,_loc4_);
               _loc2_.writeInt(param1.getAttributeInt("lineSize",1));
               this.§_-5g§(_loc2_,param1.getAttribute("lineColor"));
               this.§_-5g§(_loc2_,param1.getAttribute("fillColor"),true,4294967295);
               _loc4_ = param1.getAttribute("corner","");
               if(_loc4_)
               {
                  _loc2_.writeBoolean(true);
                  _loc5_ = _loc4_.split(",");
                  _loc18_ = parseInt(_loc5_[0]);
                  _loc2_.writeFloat(_loc18_);
                  if(_loc5_[1])
                  {
                     _loc2_.writeFloat(parseInt(_loc5_[1]));
                  }
                  else
                  {
                     _loc2_.writeFloat(_loc18_);
                  }
                  if(_loc5_[2])
                  {
                     _loc2_.writeFloat(parseInt(_loc5_[2]));
                  }
                  else
                  {
                     _loc2_.writeFloat(_loc18_);
                  }
                  if(_loc5_[3])
                  {
                     _loc2_.writeFloat(parseInt(_loc5_[3]));
                  }
                  else
                  {
                     _loc2_.writeFloat(_loc18_);
                  }
               }
               else
               {
                  _loc2_.writeBoolean(false);
               }
               if(_loc17_ == 3)
               {
                  _loc4_ = param1.getAttribute("points");
                  _loc5_ = _loc4_.split(",");
                  _loc7_ = _loc5_.length;
                  _loc2_.writeShort(_loc7_);
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     _loc2_.writeFloat(parseFloat(_loc5_[_loc6_]));
                     _loc6_++;
                  }
               }
               else if(_loc17_ == 4)
               {
                  _loc2_.writeShort(param1.getAttributeInt("sides"));
                  _loc2_.writeFloat(param1.getAttributeFloat("startAngle"));
                  _loc4_ = param1.getAttribute("distances");
                  if(_loc4_)
                  {
                     _loc5_ = _loc4_.split(",");
                     _loc7_ = _loc5_.length;
                     _loc2_.writeShort(_loc7_);
                     _loc6_ = 0;
                     while(_loc6_ < _loc7_)
                     {
                        if(_loc5_[_loc6_])
                        {
                           _loc2_.writeFloat(parseFloat(_loc5_[_loc6_]));
                        }
                        else
                        {
                           _loc2_.writeFloat(1);
                        }
                        _loc6_++;
                     }
                  }
                  else
                  {
                     _loc2_.writeShort(0);
                  }
               }
               break;
            case FObjectType.LOADER:
               this.writeString(_loc2_,param1.getAttribute("url",""));
               this.§_-6R§(_loc2_,param1.getAttribute("align"));
               this.§_-N7§(_loc2_,param1.getAttribute("vAlign"));
               _loc4_ = param1.getAttribute("fill");
               switch(_loc4_)
               {
                  case "none":
                     _loc2_.writeByte(0);
                     break;
                  case "scale":
                     _loc2_.writeByte(1);
                     break;
                  case "scaleMatchHeight":
                     _loc2_.writeByte(2);
                     break;
                  case "scaleMatchWidth":
                     _loc2_.writeByte(3);
                     break;
                  case "scaleFree":
                     _loc2_.writeByte(4);
                     break;
                  case "scaleNoBorder":
                     _loc2_.writeByte(5);
                     break;
                  default:
                     _loc2_.writeByte(0);
               }
               _loc2_.writeBoolean(param1.getAttributeBool("shrinkOnly"));
               _loc2_.writeBoolean(param1.getAttributeBool("autoSize"));
               _loc2_.writeBoolean(param1.getAttributeBool("errorSign"));
               _loc2_.writeBoolean(param1.getAttributeBool("playing",true));
               _loc2_.writeInt(param1.getAttributeInt("frame"));
               _loc4_ = param1.getAttribute("color");
               if(_loc4_)
               {
                  _loc2_.writeBoolean(true);
                  this.§_-5g§(_loc2_,_loc4_,false);
               }
               else
               {
                  _loc2_.writeBoolean(false);
               }
               _loc4_ = param1.getAttribute("fillMethod");
               this.§_-Hl§(_loc2_,_loc4_);
               if(_loc4_ && _loc4_ != "none")
               {
                  _loc2_.writeByte(param1.getAttributeInt("fillOrigin"));
                  _loc2_.writeBoolean(param1.getAttributeBool("fillClockwise",true));
                  _loc2_.writeFloat(param1.getAttributeInt("fillAmount",100) / 100);
               }
               break;
            case FObjectType.GROUP:
               _loc4_ = param1.getAttribute("layout");
               switch(_loc4_)
               {
                  case "hz":
                     _loc2_.writeByte(1);
                     break;
                  case "vt":
                     _loc2_.writeByte(2);
                     break;
                  default:
                     _loc2_.writeByte(0);
               }
               _loc2_.writeInt(param1.getAttributeInt("lineGap"));
               _loc2_.writeInt(param1.getAttributeInt("colGap"));
               _loc2_.writeBoolean(param1.getAttributeBool("excludeInvisibles"));
               _loc2_.writeBoolean(param1.getAttributeBool("autoSizeDisabled"));
               _loc2_.writeShort(param1.getAttributeInt("mainGridIndex",-1));
               break;
            case FObjectType.TEXT:
            case FObjectType.RICHTEXT:
               this.writeString(_loc2_,param1.getAttribute("font"));
               _loc2_.writeShort(param1.getAttributeInt("fontSize"));
               this.§_-5g§(_loc2_,param1.getAttribute("color"),false);
               this.§_-6R§(_loc2_,param1.getAttribute("align"));
               this.§_-N7§(_loc2_,param1.getAttribute("vAlign"));
               _loc2_.writeShort(param1.getAttributeInt("leading",3));
               _loc2_.writeShort(param1.getAttributeInt("letterSpacing"));
               _loc2_.writeBoolean(param1.getAttributeBool("ubb"));
               this.§_-Bu§(_loc2_,param1.getAttribute("autoSize","both"));
               _loc2_.writeBoolean(param1.getAttributeBool("underline"));
               _loc2_.writeBoolean(param1.getAttributeBool("italic"));
               _loc2_.writeBoolean(param1.getAttributeBool("bold"));
               _loc2_.writeBoolean(param1.getAttributeBool("singleLine"));
               _loc4_ = param1.getAttribute("strokeColor");
               if(_loc4_)
               {
                  _loc2_.writeBoolean(true);
                  this.§_-5g§(_loc2_,_loc4_);
                  _loc2_.writeFloat(param1.getAttributeInt("strokeSize",1));
               }
               else
               {
                  _loc2_.writeBoolean(false);
               }
               _loc4_ = param1.getAttribute("shadowColor");
               if(_loc4_)
               {
                  _loc2_.writeBoolean(true);
                  this.§_-5g§(_loc2_,param1.getAttribute("shadowColor"));
                  _loc4_ = param1.getAttribute("shadowOffset");
                  if(_loc4_)
                  {
                     _loc5_ = _loc4_.split(",");
                     _loc2_.writeFloat(parseFloat(_loc5_[0]));
                     _loc2_.writeFloat(parseFloat(_loc5_[1]));
                  }
                  else
                  {
                     _loc2_.writeFloat(1);
                     _loc2_.writeFloat(1);
                  }
               }
               else
               {
                  _loc2_.writeBoolean(false);
               }
               _loc2_.writeBoolean(param1.getAttributeBool("vars"));
               break;
            case FObjectType.COMPONENT:
               break;
            case FObjectType.LIST:
               _loc19_ = param1.getAttribute("layout");
               switch(_loc19_)
               {
                  case "column":
                     _loc2_.writeByte(0);
                     break;
                  case "row":
                     _loc2_.writeByte(1);
                     break;
                  case "flow_hz":
                     _loc2_.writeByte(2);
                     break;
                  case "flow_vt":
                     _loc2_.writeByte(3);
                     break;
                  case "pagination":
                     _loc2_.writeByte(4);
                     break;
                  default:
                     _loc2_.writeByte(0);
               }
               _loc4_ = param1.getAttribute("selectionMode");
               switch(_loc4_)
               {
                  case "single":
                     _loc2_.writeByte(0);
                     break;
                  case "multiple":
                     _loc2_.writeByte(1);
                     break;
                  case "multipleSingleClick":
                     _loc2_.writeByte(2);
                     break;
                  case "none":
                     _loc2_.writeByte(3);
                     break;
                  default:
                     _loc2_.writeByte(0);
               }
               this.§_-6R§(_loc2_,param1.getAttribute("align"));
               this.§_-N7§(_loc2_,param1.getAttribute("vAlign"));
               _loc2_.writeShort(param1.getAttributeInt("lineGap"));
               _loc2_.writeShort(param1.getAttributeInt("colGap"));
               _loc20_ = param1.getAttributeInt("lineItemCount");
               _loc21_ = param1.getAttributeInt("lineItemCount2");
               if(_loc19_ == "flow_hz")
               {
                  _loc2_.writeShort(0);
                  _loc2_.writeShort(_loc20_);
               }
               else if(_loc19_ == "flow_vt")
               {
                  _loc2_.writeShort(_loc20_);
                  _loc2_.writeShort(0);
               }
               else if(_loc19_ == "pagination")
               {
                  _loc2_.writeShort(_loc21_);
                  _loc2_.writeShort(_loc20_);
               }
               else
               {
                  _loc2_.writeShort(0);
                  _loc2_.writeShort(0);
               }
               if(!_loc19_ || _loc19_ == "row" || _loc19_ == "column")
               {
                  _loc2_.writeBoolean(param1.getAttributeBool("autoItemSize",true));
               }
               else
               {
                  _loc2_.writeBoolean(param1.getAttributeBool("autoItemSize",false));
               }
               _loc4_ = param1.getAttribute("renderOrder");
               switch(_loc4_)
               {
                  case "ascent":
                     _loc2_.writeByte(0);
                     break;
                  case "descent":
                     _loc2_.writeByte(1);
                     break;
                  case "arch":
                     _loc2_.writeByte(2);
                     break;
                  default:
                     _loc2_.writeByte(0);
               }
               _loc2_.writeShort(param1.getAttributeInt("apex"));
               _loc4_ = param1.getAttribute("margin");
               if(_loc4_)
               {
                  _loc5_ = _loc4_.split(",");
                  _loc2_.writeBoolean(true);
                  _loc2_.writeInt(parseInt(_loc5_[0]));
                  _loc2_.writeInt(parseInt(_loc5_[1]));
                  _loc2_.writeInt(parseInt(_loc5_[2]));
                  _loc2_.writeInt(parseInt(_loc5_[3]));
               }
               else
               {
                  _loc2_.writeBoolean(false);
               }
               _loc4_ = param1.getAttribute("overflow");
               if(_loc4_ == "hidden")
               {
                  _loc2_.writeByte(1);
               }
               else if(_loc4_ == "scroll")
               {
                  _loc2_.writeByte(2);
               }
               else
               {
                  _loc2_.writeByte(0);
               }
               _loc4_ = param1.getAttribute("clipSoftness");
               if(_loc4_)
               {
                  _loc5_ = _loc4_.split(",");
                  _loc2_.writeBoolean(true);
                  _loc2_.writeInt(parseInt(_loc5_[0]));
                  _loc2_.writeInt(parseInt(_loc5_[1]));
               }
               else
               {
                  _loc2_.writeBoolean(false);
               }
               _loc2_.writeBoolean(param1.getAttributeBool("scrollItemToViewOnClick",true));
               _loc2_.writeBoolean(param1.getAttributeBool("foldInvisibleItems"));
               break;
            case FObjectType.SWF:
               _loc2_.writeBoolean(param1.getAttributeBool("playing",true));
         }
         this.writeSegmentPos(_loc2_,6);
         switch(_loc12_)
         {
            case FObjectType.TEXT:
            case FObjectType.RICHTEXT:
               this.writeString(_loc2_,param1.getAttribute("text"),true);
               break;
            case FObjectType.COMPONENT:
               _loc8_ = param1.getChildren();
               for each(_loc14_ in _loc8_)
               {
                  switch(_loc14_.getName())
                  {
                     case FObjectType.EXT_LABEL:
                        _loc2_.writeByte(11);
                        this.writeString(_loc2_,_loc14_.getAttribute("title"),true);
                        this.writeString(_loc2_,_loc14_.getAttribute("icon"));
                        _loc4_ = _loc14_.getAttribute("titleColor");
                        if(_loc4_)
                        {
                           _loc2_.writeBoolean(true);
                           this.§_-5g§(_loc2_,_loc4_);
                        }
                        else
                        {
                           _loc2_.writeBoolean(false);
                        }
                        _loc2_.writeInt(_loc14_.getAttributeInt("titleFontSize"));
                        _loc22_ = _loc14_.getAttribute("prompt");
                        _loc23_ = _loc14_.getAttribute("restrict");
                        _loc24_ = _loc14_.getAttributeInt("maxLength");
                        _loc25_ = _loc14_.getAttributeInt("keyboardType");
                        _loc26_ = _loc14_.getAttributeBool("password");
                        if(_loc22_ || _loc23_ || _loc24_ || _loc25_ || _loc26_)
                        {
                           _loc2_.writeBoolean(true);
                           this.writeString(_loc2_,_loc22_,true);
                           this.writeString(_loc2_,_loc23_);
                           _loc2_.writeInt(_loc24_);
                           _loc2_.writeInt(_loc25_);
                           _loc2_.writeBoolean(_loc26_);
                        }
                        else
                        {
                           _loc2_.writeBoolean(false);
                        }
                        continue;
                     case FObjectType.EXT_BUTTON:
                        _loc2_.writeByte(12);
                        this.writeString(_loc2_,_loc14_.getAttribute("title"),true);
                        this.writeString(_loc2_,_loc14_.getAttribute("selectedTitle"),true);
                        this.writeString(_loc2_,_loc14_.getAttribute("icon"));
                        this.writeString(_loc2_,_loc14_.getAttribute("selectedIcon"));
                        _loc4_ = _loc14_.getAttribute("titleColor");
                        if(_loc4_)
                        {
                           _loc2_.writeBoolean(true);
                           this.§_-5g§(_loc2_,_loc4_);
                        }
                        else
                        {
                           _loc2_.writeBoolean(false);
                        }
                        _loc2_.writeInt(_loc14_.getAttributeInt("titleFontSize"));
                        _loc4_ = _loc14_.getAttribute("controller");
                        if(_loc4_)
                        {
                           _loc16_ = this.§_-59§[_loc4_];
                           if(_loc16_ != undefined)
                           {
                              _loc2_.writeShort(_loc16_);
                           }
                           else
                           {
                              _loc2_.writeShort(-1);
                           }
                        }
                        else
                        {
                           _loc2_.writeShort(-1);
                        }
                        this.writeString(_loc2_,_loc14_.getAttribute("page"));
                        this.writeString(_loc2_,_loc14_.getAttribute("sound"),false,false);
                        _loc4_ = _loc14_.getAttribute("volume");
                        if(_loc4_)
                        {
                           _loc2_.writeBoolean(true);
                           _loc2_.writeFloat(parseInt(_loc4_) / 100);
                        }
                        else
                        {
                           _loc2_.writeBoolean(false);
                        }
                        _loc2_.writeBoolean(_loc14_.getAttributeBool("checked"));
                        continue;
                     case FObjectType.EXT_COMBOBOX:
                        _loc2_.writeByte(13);
                        _loc10_ = _loc2_.position;
                        _loc2_.writeShort(0);
                        _loc28_ = _loc14_.getEnumerator("item");
                        _loc7_ = 0;
                        while(_loc28_.moveNext())
                        {
                           _loc7_++;
                           _loc27_ = _loc28_.current;
                           _loc3_ = new ByteArray();
                           this.writeString(_loc3_,_loc27_.getAttribute("title"),true,false);
                           this.writeString(_loc3_,_loc27_.getAttribute("value"),false,false);
                           this.writeString(_loc3_,_loc27_.getAttribute("icon"));
                           _loc2_.writeShort(_loc3_.length);
                           _loc2_.writeBytes(_loc3_);
                           _loc3_.clear();
                        }
                        this.§_-4J§(_loc2_,_loc10_,_loc7_);
                        this.writeString(_loc2_,_loc14_.getAttribute("title"),true);
                        this.writeString(_loc2_,_loc14_.getAttribute("icon"));
                        _loc4_ = _loc14_.getAttribute("titleColor");
                        if(_loc4_)
                        {
                           _loc2_.writeBoolean(true);
                           this.§_-5g§(_loc2_,_loc4_);
                        }
                        else
                        {
                           _loc2_.writeBoolean(false);
                        }
                        _loc2_.writeInt(_loc14_.getAttributeInt("visibleItemCount"));
                        _loc4_ = _loc14_.getAttribute("direction");
                        switch(_loc4_)
                        {
                           case "down":
                              _loc2_.writeByte(2);
                              break;
                           case "up":
                              _loc2_.writeByte(1);
                              break;
                           default:
                              _loc2_.writeByte(0);
                        }
                        _loc4_ = _loc14_.getAttribute("selectionController");
                        if(_loc4_)
                        {
                           _loc16_ = this.§_-59§[_loc4_];
                           if(_loc16_ != undefined)
                           {
                              _loc2_.writeShort(_loc16_);
                           }
                           else
                           {
                              _loc2_.writeShort(-1);
                           }
                        }
                        else
                        {
                           _loc2_.writeShort(-1);
                        }
                        continue;
                     case FObjectType.EXT_PROGRESS_BAR:
                        _loc2_.writeByte(14);
                        _loc2_.writeInt(_loc14_.getAttributeInt("value"));
                        _loc2_.writeInt(_loc14_.getAttributeInt("max",100));
                        _loc2_.writeInt(_loc14_.getAttributeInt("min"));
                        continue;
                     case FObjectType.EXT_SLIDER:
                        _loc2_.writeByte(15);
                        _loc2_.writeInt(_loc14_.getAttributeInt("value"));
                        _loc2_.writeInt(_loc14_.getAttributeInt("max",100));
                        _loc2_.writeInt(_loc14_.getAttributeInt("min"));
                        continue;
                     case FObjectType.EXT_SCROLLBAR:
                        _loc2_.writeByte(16);
                        continue;
                     default:
                        continue;
                  }
               }
               break;
            case FObjectType.LIST:
               _loc4_ = param1.getAttribute("selectionController");
               if(_loc4_)
               {
                  _loc16_ = this.§_-59§[_loc4_];
                  if(_loc16_ != undefined)
                  {
                     _loc2_.writeShort(_loc16_);
                  }
                  else
                  {
                     _loc2_.writeShort(-1);
                  }
               }
               else
               {
                  _loc2_.writeShort(-1);
               }
         }
         if(_loc12_ == FObjectType.LIST)
         {
            if(param1.getAttribute("overflow") == "scroll")
            {
               this.writeSegmentPos(_loc2_,7);
               _loc3_ = this.§_-Nu§(param1);
               _loc2_.writeBytes(_loc3_);
               _loc3_.clear();
            }
            this.writeSegmentPos(_loc2_,8);
            this.writeString(_loc2_,param1.getAttribute("defaultItem"));
            _loc28_ = param1.getEnumerator("item");
            _loc7_ = 0;
            this.helperIntList.length = _loc7_;
            while(_loc28_.moveNext())
            {
               _loc14_ = _loc28_.current;
               _loc29_ = _loc14_.getAttributeInt("level",0);
               this.helperIntList[_loc7_] = _loc29_;
               _loc7_++;
            }
            _loc28_.reset();
            _loc6_ = 0;
            _loc2_.writeShort(_loc7_);
            while(_loc28_.moveNext())
            {
               _loc14_ = _loc28_.current;
               _loc3_ = new ByteArray();
               this.writeString(_loc3_,_loc14_.getAttribute("url"));
               if(_loc11_ == 17)
               {
                  _loc29_ = this.helperIntList[_loc6_];
                  if(_loc6_ != _loc7_ - 1 && this.helperIntList[_loc6_ + 1] > _loc29_)
                  {
                     _loc3_.writeBoolean(true);
                  }
                  else
                  {
                     _loc3_.writeBoolean(false);
                  }
                  _loc3_.writeByte(_loc29_);
               }
               this.writeString(_loc3_,_loc14_.getAttribute("title"),true);
               this.writeString(_loc3_,_loc14_.getAttribute("selectedTitle"),true);
               this.writeString(_loc3_,_loc14_.getAttribute("icon"));
               this.writeString(_loc3_,_loc14_.getAttribute("selectedIcon"));
               this.writeString(_loc3_,_loc14_.getAttribute("name"));
               _loc4_ = _loc14_.getAttribute("controllers");
               if(_loc4_)
               {
                  _loc5_ = _loc4_.split(",");
                  _loc3_.writeShort(_loc5_.length / 2);
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_.length)
                  {
                     this.writeString(_loc3_,_loc5_[_loc6_]);
                     this.writeString(_loc3_,_loc5_[_loc6_ + 1]);
                     _loc6_ = _loc6_ + 2;
                  }
               }
               else
               {
                  _loc3_.writeShort(0);
               }
               this.§_-9Z§(_loc14_,_loc3_); // mark
               _loc2_.writeShort(_loc3_.length);
               _loc2_.writeBytes(_loc3_);
               _loc3_.clear();
               _loc6_++;
            }
         }
         if(_loc11_ == 17)
         {
            this.writeSegmentPos(_loc2_,9);
            _loc2_.writeInt(param1.getAttributeInt("indent",15));
            _loc2_.writeByte(param1.getAttributeInt("clickToExpand"));
         }
         return _loc2_;
      }
      
      private function §_-7Q§(param1:int, param2:XData) : ByteArray
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:* = undefined;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         _loc3_ = param2.getAttribute("controller");
         if(_loc3_)
         {
            _loc9_ = this.§_-59§[_loc3_];
            if(_loc9_ == undefined)
            {
               return null;
            }
            var _loc8_:ByteArray = new ByteArray();
            _loc8_.writeShort(_loc9_);
            if(param1 == 0 || param1 == 8)
            {
               _loc3_ = param2.getAttribute("pages");
               if(_loc3_)
               {
                  _loc4_ = _loc3_.split(",");
                  _loc5_ = _loc4_.length;
                  if(_loc5_ == 0)
                  {
                     return null;
                  }
                  _loc8_.writeShort(_loc5_);
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     this.writeString(_loc8_,_loc4_[_loc6_],false,false);
                     _loc6_++;
                  }
               }
               else
               {
                  _loc8_.writeShort(0);
               }
            }
            else
            {
               _loc3_ = param2.getAttribute("pages");
               if(_loc3_)
               {
                  _loc10_ = _loc3_.split(",");
               }
               else
               {
                  _loc10_ = [];
               }
               _loc3_ = param2.getAttribute("values");
               if(_loc3_)
               {
                  _loc11_ = _loc3_.split("|");
               }
               else
               {
                  _loc11_ = [];
               }
               _loc5_ = _loc10_.length;
               _loc8_.writeShort(_loc5_);
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc3_ = _loc11_[_loc6_];
                  if(param1 != 6 && param1 != 7 && (!_loc3_ || _loc3_ == "-"))
                  {
                     this.writeString(_loc8_,null);
                  }
                  else
                  {
                     this.writeString(_loc8_,_loc10_[_loc6_],false,false);
                     this.§_-8h§(param1,_loc3_,_loc8_);
                  }
                  _loc6_++;
               }
               _loc3_ = param2.getAttribute("default");
               if(_loc3_)
               {
                  _loc8_.writeBoolean(true);
                  this.§_-8h§(param1,_loc3_,_loc8_);
               }
               else
               {
                  _loc8_.writeBoolean(false);
               }
            }
            if(param2.getAttributeBool("tween"))
            {
               _loc8_.writeBoolean(true);
               _loc8_.writeByte(EaseType.parseEaseType(param2.getAttribute("ease")));
               _loc8_.writeFloat(param2.getAttributeFloat("duration",0.3));
               _loc8_.writeFloat(param2.getAttributeFloat("delay"));
            }
            else
            {
               _loc8_.writeBoolean(false);
            }
            if(param1 == 1)
            {
               _loc12_ = param2.getAttributeBool("positionsInPercent");
               _loc8_.writeBoolean(_loc12_);
               if(_loc12_)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     _loc3_ = _loc11_[_loc6_];
                     if(_loc3_ && _loc3_ != "-")
                     {
                        this.writeString(_loc8_,_loc10_[_loc6_],false,false);
                        _loc4_ = _loc3_.split(",");
                        _loc8_.writeFloat(parseFloat(_loc4_[2]));
                        _loc8_.writeFloat(parseFloat(_loc4_[3]));
                     }
                     _loc6_++;
                  }
                  _loc3_ = param2.getAttribute("default");
                  if(_loc3_)
                  {
                     _loc8_.writeBoolean(true);
                     _loc4_ = _loc3_.split(",");
                     _loc8_.writeFloat(parseFloat(_loc4_[2]));
                     _loc8_.writeFloat(parseFloat(_loc4_[3]));
                  }
                  else
                  {
                     _loc8_.writeBoolean(false);
                  }
               }
            }
            if(param1 == 8)
            {
               _loc13_ = param2.getAttributeInt("condition");
               _loc8_.writeByte(_loc13_);
            }
            return _loc8_;
         }
         return null;
      }
      
      private function §_-8h§(param1:int, param2:String, param3:ByteArray) : void
      {
         var _loc4_:Array = null;
         switch(param1)
         {
            case 1:
               _loc4_ = param2.split(",");
               param3.writeInt(parseInt(_loc4_[0]));
               param3.writeInt(parseInt(_loc4_[1]));
               break;
            case 2:
               _loc4_ = param2.split(",");
               param3.writeInt(parseInt(_loc4_[0]));
               param3.writeInt(parseInt(_loc4_[1]));
               if(_loc4_.length > 2)
               {
                  param3.writeFloat(parseFloat(_loc4_[2]));
                  param3.writeFloat(parseFloat(_loc4_[3]));
               }
               else
               {
                  param3.writeFloat(1);
                  param3.writeFloat(1);
               }
               break;
            case 3:
               _loc4_ = param2.split(",");
               param3.writeFloat(parseFloat(_loc4_[0]));
               param3.writeFloat(parseFloat(_loc4_[1]));
               param3.writeBoolean(_loc4_[2] == "1");
               param3.writeBoolean(_loc4_.length < 4 || _loc4_[3] == "1");
               break;
            case 4:
               _loc4_ = param2.split(",");
               if(_loc4_.length < 2)
               {
                  this.§_-5g§(param3,_loc4_[0]);
                  this.§_-5g§(param3,"#000000");
               }
               else
               {
                  this.§_-5g§(param3,_loc4_[0]);
                  this.§_-5g§(param3,_loc4_[1]);
               }
               break;
            case 5:
               _loc4_ = param2.split(",");
               param3.writeBoolean(_loc4_[1] == "p");
               param3.writeInt(parseInt(_loc4_[0]));
               break;
            case 6:
               this.writeString(param3,param2,true);
               break;
            case 7:
               this.writeString(param3,param2);
               break;
            case 9:
               param3.writeInt(parseInt(param2));
         }
      }
      
      private function §_-3y§(param1:String, param2:XML) : ByteArray
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:ByteArray = null;
         var _loc10_:XData = null;
         var _loc11_:int = 0;
         var _loc3_:XData = XData.attach(param2);
         var _loc4_:ByteArray = new ByteArray();
         this.startSegments(_loc4_,2,false);
         this.writeSegmentPos(_loc4_,0);
         _loc4_.writeInt(_loc3_.getAttributeInt("interval"));
         _loc4_.writeBoolean(_loc3_.getAttributeBool("swing"));
         _loc4_.writeInt(_loc3_.getAttributeInt("repeatDelay"));
         this.writeSegmentPos(_loc4_,1);
         var _loc8_:XDataEnumerator = _loc3_.getChild("frames").getEnumerator("frame");
         _loc4_.writeShort(_loc3_.getAttributeInt("frameCount"));
         var _loc9_:int = 0;
         while(_loc8_.moveNext())
         {
            _loc10_ = _loc8_.current;
            _loc5_ = _loc10_.getAttribute("rect");
            _loc6_ = _loc5_.split(",");
            _loc7_ = new ByteArray();
            _loc7_.writeInt(parseInt(_loc6_[0]));
            _loc7_.writeInt(parseInt(_loc6_[1]));
            _loc11_ = parseInt(_loc6_[2]);
            _loc7_.writeInt(_loc11_);
            _loc7_.writeInt(parseInt(_loc6_[3]));
            _loc7_.writeInt(_loc10_.getAttributeInt("addDelay"));
            _loc5_ = _loc10_.getAttribute("sprite");
            if(_loc5_)
            {
               this.writeString(_loc7_,param1 + "_" + _loc5_);
            }
            else if(_loc11_)
            {
               this.writeString(_loc7_,param1 + "_" + _loc9_);
            }
            else
            {
               this.writeString(_loc7_,null);
            }
            _loc4_.writeShort(_loc7_.length);
            _loc4_.writeBytes(_loc7_);
            _loc7_.clear();
            _loc9_++;
         }
         return _loc4_;
      }
      
      private function §_-Ox§(param1:String, param2:String) : ByteArray
      {
         var _loc4_:ByteArray = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:String = null;
         var _loc24_:Array = null;
         var _loc25_:int = 0;
         var _loc26_:Array = null;
         var _loc27_:String = null;
         var _loc28_:int = 0;
         var _loc3_:ByteArray = new ByteArray();
         var _loc5_:Array = param2.split("\n");
         var _loc6_:int = _loc5_.length;
         var _loc9_:* = false;
         var _loc10_:* = false;
         var _loc11_:* = false;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         _loc7_ = 0;
         for(; _loc7_ < _loc6_; _loc7_++)
         {
            _loc23_ = _loc5_[_loc7_];
            if(_loc23_)
            {
               _loc23_ = UtilsStr.trim(_loc23_);
               _loc24_ = _loc23_.split(" ");
               _loc8_ = {};
               _loc25_ = 1;
               while(_loc25_ < _loc24_.length)
               {
                  _loc26_ = _loc24_[_loc25_].split("=");
                  _loc8_[_loc26_[0]] = _loc26_[1];
                  _loc25_++;
               }
               _loc23_ = _loc24_[0];
               if(_loc23_ == "char")
               {
                  _loc27_ = _loc8_["img"];
                  if(!_loc9_)
                  {
                     if(!_loc27_)
                     {
                        continue;
                     }
                  }
                  _loc28_ = _loc8_["id"];
                  if(_loc28_ != 0)
                  {
                     _loc17_ = _loc8_["xoffset"];
                     _loc18_ = _loc8_["yoffset"];
                     _loc19_ = _loc8_["width"];
                     _loc20_ = _loc8_["height"];
                     _loc21_ = _loc8_["xadvance"];
                     _loc22_ = _loc8_["chnl"];
                     if(_loc22_ != 0 && _loc22_ != 15)
                     {
                        _loc12_ = true;
                     }
                     _loc4_ = new ByteArray();
                     _loc4_.writeShort(_loc28_);
                     this.writeString(_loc4_,_loc27_);
                     _loc4_.writeInt(_loc8_["x"]);
                     _loc4_.writeInt(_loc8_["y"]);
                     _loc4_.writeInt(_loc17_);
                     _loc4_.writeInt(_loc18_);
                     _loc4_.writeInt(_loc19_);
                     _loc4_.writeInt(_loc20_);
                     _loc4_.writeInt(_loc21_);
                     _loc4_.writeByte(_loc22_);
                     _loc3_.writeShort(_loc4_.length);
                     _loc3_.writeBytes(_loc4_);
                     _loc4_.clear();
                     _loc16_++;
                  }
               }
               else if(_loc23_ == "info")
               {
                  _loc9_ = _loc8_.face != null;
                  _loc10_ = Boolean(_loc9_);
                  _loc13_ = _loc8_.size;
                  _loc11_ = _loc8_.resizable == "true";
                  if(_loc8_.colored != undefined)
                  {
                     _loc10_ = _loc8_.colored == "true";
                  }
               }
               else if(_loc23_ == "common")
               {
                  _loc14_ = _loc8_.lineHeight;
                  _loc15_ = _loc8_.xadvance;
                  if(_loc13_ == 0)
                  {
                     _loc13_ = _loc14_;
                  }
                  else if(_loc14_ == 0)
                  {
                     _loc14_ = _loc13_;
                     continue;
                  }
                  continue;
               }
            }
         }
         _loc4_ = _loc3_;
         _loc3_ = new ByteArray();
         this.startSegments(_loc3_,2,false);
         this.writeSegmentPos(_loc3_,0);
         _loc3_.writeBoolean(_loc9_);
         _loc3_.writeBoolean(_loc10_);
         _loc3_.writeBoolean(_loc13_ > 0?Boolean(_loc11_):false);
         _loc3_.writeBoolean(_loc12_);
         _loc3_.writeInt(_loc13_);
         _loc3_.writeInt(_loc15_);
         _loc3_.writeInt(_loc14_);
         this.writeSegmentPos(_loc3_,1);
         _loc3_.writeInt(_loc16_);
         _loc3_.writeBytes(_loc4_);
         _loc4_.clear();
         return _loc3_;
      }
      
      private function startSegments(param1:ByteArray, param2:int, param3:Boolean) : void
      {
         param1.writeByte(param2);
         param1.writeBoolean(param3);
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            if(param3)
            {
               param1.writeShort(0);
            }
            else
            {
               param1.writeInt(0);
            }
            _loc4_++;
         }
      }
      
      private function writeSegmentPos(param1:ByteArray, param2:int) : void
      {
         var _loc3_:int = param1.position;
         param1.position = 1;
         var _loc4_:Boolean = param1.readBoolean();
         param1.position = 2 + param2 * (!!_loc4_?2:4);
         if(_loc4_)
         {
            param1.writeShort(_loc3_);
         }
         else
         {
            param1.writeInt(_loc3_);
         }
         param1.position = _loc3_;
      }
      
      private function §_-4J§(param1:ByteArray, param2:int, param3:int) : void
      {
         var _loc4_:int = param1.position;
         param1.position = param2;
         param1.writeShort(param3);
         param1.position = _loc4_;
      }
      
      private function writeString(param1:ByteArray, param2:String, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc5_:* = undefined;
         if(param4)
         {
            if(!param2)
            {
               param1.writeShort(65534);
               return;
            }
         }
         else
         {
            if(param2 == null)
            {
               param1.writeShort(65534);
               return;
            }
            if(param2.length == 0)
            {
               param1.writeShort(65533);
               return;
            }
         }
         if(!param3)
         {
            _loc5_ = this.§_-67§[param2];
            if(_loc5_ != undefined)
            {
               param1.writeShort(int(_loc5_));
               return;
            }
         }
         this.§_-FV§.push(param2);
         if(!param3)
         {
            this.§_-67§[param2] = this.§_-FV§.length - 1;
         }
         param1.writeShort(this.§_-FV§.length - 1);
      }
      
      private function §_-5g§(param1:ByteArray, param2:String, param3:Boolean = true, param4:uint = 4.27819008E9) : void
      {
         var _loc5_:uint = 0;
         if(param2)
         {
            _loc5_ = ToolSet.convertFromHtmlColor(param2,param3);
         }
         else
         {
            _loc5_ = param4;
         }
         param1.writeByte(_loc5_ >> 16 & 255);
         param1.writeByte(_loc5_ >> 8 & 255);
         param1.writeByte(_loc5_ & 255);
         if(param3)
         {
            param1.writeByte(_loc5_ >> 24 & 255);
         }
         else
         {
            param1.writeByte(255);
         }
      }
      
      private function §_-6R§(param1:ByteArray, param2:String) : void
      {
         switch(param2)
         {
            case "left":
               param1.writeByte(0);
               break;
            case "center":
               param1.writeByte(1);
               break;
            case "right":
               param1.writeByte(2);
               break;
            default:
               param1.writeByte(0);
         }
      }
      
      private function §_-N7§(param1:ByteArray, param2:String) : void
      {
         switch(param2)
         {
            case "top":
               param1.writeByte(0);
               break;
            case "middle":
               param1.writeByte(1);
               break;
            case "bottom":
               param1.writeByte(2);
               break;
            default:
               param1.writeByte(0);
         }
      }
      
      private function §_-Hl§(param1:ByteArray, param2:String) : void
      {
         switch(param2)
         {
            case "none":
               param1.writeByte(0);
               break;
            case "hz":
               param1.writeByte(1);
               break;
            case "vt":
               param1.writeByte(2);
               break;
            case "radial90":
               param1.writeByte(3);
               break;
            case "radial180":
               param1.writeByte(4);
               break;
            case "radial360":
               param1.writeByte(5);
               break;
            default:
               param1.writeByte(0);
         }
      }
      
      private function §_-Bu§(param1:ByteArray, param2:String) : void
      {
         switch(param2)
         {
            case "none":
               param1.writeByte(0);
               break;
            case "both":
               param1.writeByte(1);
               break;
            case "height":
               param1.writeByte(2);
               break;
            case "shrink":
               param1.writeByte(3);
               break;
            default:
               param1.writeByte(0);
         }
      }
      
      private function §_-Gc§(param1:ByteArray, param2:String) : void
      {
         switch(param2)
         {
            case "XY":
               param1.writeByte(0);
               break;
            case "Size":
               param1.writeByte(1);
               break;
            case "Scale":
               param1.writeByte(2);
               break;
            case "Pivot":
               param1.writeByte(3);
               break;
            case "Alpha":
               param1.writeByte(4);
               break;
            case "Rotation":
               param1.writeByte(5);
               break;
            case "Color":
               param1.writeByte(6);
               break;
            case "Animation":
               param1.writeByte(7);
               break;
            case "Visible":
               param1.writeByte(8);
               break;
            case "Sound":
               param1.writeByte(9);
               break;
            case "Transition":
               param1.writeByte(10);
               break;
            case "Shake":
               param1.writeByte(11);
               break;
            case "ColorFilter":
               param1.writeByte(12);
               break;
            case "Skew":
               param1.writeByte(13);
               break;
            case "Text":
               param1.writeByte(14);
               break;
            case "Icon":
               param1.writeByte(15);
               break;
            default:
               param1.writeByte(16);
         }
      }
      
      private function §_-H3§(param1:ByteArray, param2:String) : int
      {
         switch(param2)
         {
            case "rect":
               param1.writeByte(1);
               return 1;
            case "ellipse":
            case "eclipse":
               param1.writeByte(2);
               return 2;
            case "polygon":
               param1.writeByte(3);
               return 3;
            case "regular_polygon":
               param1.writeByte(4);
               return 4;
            default:
               return 0;
         }
      }
      
      private function §_-Ok§(param1:ByteArray, param2:String, param3:String) : void
      {
         §_-J9§.decode(param2,param3);
         §_-J9§.encodeBinary(param2,param1,this.writeString);
      }
   }
}

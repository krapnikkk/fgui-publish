package fairygui.editor.publish
{
   import fairygui.editor.gui.EGObject;
   import fairygui.editor.gui.ETransitionValue;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.publish.exporter.LayaExporter;
   import fairygui.editor.utils.UtilsStr;
   import fairygui.editor.utils.XData;
   import fairygui.editor.utils.XDataEnumerator;
   import fairygui.tween.EaseType;
   import fairygui.utils.ToolSet;
   import flash.utils.ByteArray;
   
   public class BinaryEncoder
   {
      
      private static var helperValue:ETransitionValue = new ETransitionValue();
      
      private static var RelationNameToID:Object = {
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
       
      
      public var stringTable:Array;
      
      private var controllerCache:Object;
      
      private var controllerCnt:int;
      
      private var displayList:Object;
      
      private var stringMap:Object;
      
      private var writeCountPos:int;
      
      private var publishData:PublishData;
      
      public function BinaryEncoder()
      {
         super();
         this.stringTable = [];
         this.stringMap = {};
      }
      
      public function encode(param1:PublishData, param2:Boolean = false) : ByteArray
      {
         var _loc7_:ByteArray = null;
         var _loc16_:* = null;
         var _loc9_:Array = null;
         var _loc8_:int = 0;
         var _loc21_:* = null;
         var _loc3_:int = 0;
         var _loc5_:XData = null;
         var _loc10_:ByteArray = null;
         var _loc17_:int = 0;
         var _loc11_:EUIPackage = null;
         var _loc14_:String = null;
         var _loc6_:String = null;
         var _loc19_:int = 0;
         var _loc15_:int = 0;
         var _loc13_:int = 0;
         var _loc22_:* = param1;
         var _loc18_:* = param2;
         this.publishData = _loc22_;
         var _loc23_:Object = _loc22_.outputDesc;
         _loc7_ = new ByteArray();
         var _loc12_:XData = XData.attach(_loc23_["package.xml"]);
         var _loc4_:Vector.<XData> = _loc12_.getChild("resources").getChildren();
         this.startSegments(_loc7_,6,false);
         this.writeSegmentPos(_loc7_,0);
         _loc9_ = [];
         var _loc26_:int = 0;
         var _loc25_:* = _loc22_._dependentPackages;
         for(_loc21_ in _loc22_._dependentPackages)
         {
            _loc9_.push(_loc21_);
         }
         _loc9_.sort();
         _loc7_.writeShort(_loc9_.length);
         _loc17_ = 0;
         while(_loc17_ < _loc9_.length)
         {
            this.writeString(_loc7_,_loc9_[_loc17_]);
            _loc11_ = _loc22_._project.getPackage(_loc9_[_loc17_]);
            if(_loc11_)
            {
               this.writeString(_loc7_,_loc11_.name);
            }
            else
            {
               this.writeString(_loc7_,"");
            }
            _loc17_++;
         }
         this.writeSegmentPos(_loc7_,1);
         _loc7_.writeShort(_loc4_.length);
         var _loc28_:int = 0;
         var _loc27_:* = _loc4_;
         for each(_loc5_ in _loc4_)
         {
            _loc16_ = this.writeResourceItem(_loc5_);
            _loc7_.writeInt(_loc16_.length);
            _loc7_.writeBytes(_loc16_);
            _loc16_.clear();
         }
         this.writeSegmentPos(_loc7_,2);
         _loc8_ = _loc22_._spritesInfo.length;
         _loc7_.writeShort(_loc8_);
         _loc17_ = 0;
         while(_loc17_ < _loc8_)
         {
            _loc9_ = _loc22_._spritesInfo[_loc17_];
            _loc16_ = new ByteArray();
            _loc14_ = _loc9_[0];
            this.writeString(_loc16_,_loc14_);
            _loc19_ = parseInt(_loc9_[1]);
            if(_loc19_ >= 0)
            {
               _loc6_ = "atlas" + _loc19_;
            }
            else
            {
               _loc15_ = _loc14_.indexOf("_");
               if(_loc15_ == -1)
               {
                  _loc6_ = "atlas_" + _loc14_;
               }
               else
               {
                  _loc6_ = "atlas_" + _loc14_.substring(0,_loc15_);
               }
            }
            this.writeString(_loc16_,_loc6_);
            _loc16_.writeInt(_loc9_[2]);
            _loc16_.writeInt(_loc9_[3]);
            _loc16_.writeInt(_loc9_[4]);
            _loc16_.writeInt(_loc9_[5]);
            _loc16_.writeBoolean(_loc9_[6]);
            _loc7_.writeShort(_loc16_.length);
            _loc7_.writeBytes(_loc16_);
            _loc16_.clear();
            _loc17_++;
         }
         if(_loc22_._hitTestData.length > 0)
         {
            this.writeSegmentPos(_loc7_,3);
            _loc16_ = _loc22_._hitTestData;
            _loc16_.position = 0;
            _loc3_ = _loc7_.position;
            _loc7_.writeShort(0);
            _loc8_ = 0;
            while(_loc16_.bytesAvailable)
            {
               _loc21_ = _loc16_.readUTF();
               _loc15_ = _loc16_.position;
               _loc16_.position = _loc16_.position + 9;
               _loc13_ = _loc16_.readInt();
               _loc7_.writeInt(_loc13_ + 15);
               this.writeString(_loc7_,_loc21_);
               _loc7_.writeBytes(_loc16_,_loc15_,_loc13_ + 13);
               _loc16_.position = _loc15_ + 13 + _loc13_;
               _loc8_++;
            }
            this.writeCount(_loc7_,_loc3_,_loc8_);
         }
         this.writeSegmentPos(_loc7_,4);
         var _loc20_:int = 0;
         _loc8_ = this.stringTable.length;
         _loc7_.writeInt(_loc8_);
         _loc17_ = 0;
         while(_loc17_ < _loc8_)
         {
            try
            {
               _loc7_.writeUTF(this.stringTable[_loc17_]);
            }
            catch(err:RangeError)
            {
               _loc7_.writeShort(0);
               if(_loc10_ == null)
               {
                  _loc10_ = new ByteArray();
               }
               _loc10_.writeShort(_loc17_);
               _loc15_ = _loc10_.position;
               _loc10_.writeInt(0);
               _loc10_.writeUTFBytes(stringTable[_loc17_]);
               _loc13_ = _loc10_.position - _loc15_ - 4;
               _loc10_.position = _loc15_;
               _loc10_.writeInt(_loc13_);
               _loc10_.position = _loc10_.length;
               _loc20_++;
            }
            _loc17_++;
         }
         if(_loc20_ > 0)
         {
            this.writeSegmentPos(_loc7_,5);
            _loc7_.writeInt(_loc20_);
            _loc7_.writeBytes(_loc10_);
            _loc10_.clear();
         }
         _loc16_ = _loc7_;
         _loc7_ = new ByteArray();
         var _loc24_:String = "";
         _loc7_.writeByte("F".charCodeAt(0));
         _loc7_.writeByte("G".charCodeAt(0));
         _loc7_.writeByte("U".charCodeAt(0));
         _loc7_.writeByte("I".charCodeAt(0));
         _loc7_.writeInt(1);
         _loc7_.writeBoolean(_loc18_);
         _loc7_.writeUTF(_loc12_.getAttribute("id"));
         _loc7_.writeUTF(_loc12_.getAttribute("name"));
         _loc17_ = 0;
         while(_loc17_ < 20)
         {
            _loc7_.writeByte(0);
            _loc17_++;
         }
         if(_loc18_)
         {
            _loc16_.deflate();
         }
         _loc7_.writeBytes(_loc16_);
         _loc16_.clear();
         return _loc7_;
      }
      
      private function writeResourceItem(param1:XData) : ByteArray
      {
         var _loc6_:int = 0;
         var _loc8_:ByteArray = null;
         var _loc9_:String = null;
         var _loc2_:Array = null;
         var _loc7_:String = null;
         var _loc5_:XML = null;
         var _loc4_:String = null;
         var _loc10_:ByteArray = new ByteArray();
         var _loc3_:String = param1.getName();
         var _loc11_:* = _loc3_;
         if("image" !== _loc11_)
         {
            if("movieclip" !== _loc11_)
            {
               if("sound" !== _loc11_)
               {
                  if("component" !== _loc11_)
                  {
                     if("atlas" !== _loc11_)
                     {
                        if("font" !== _loc11_)
                        {
                           if("swf" !== _loc11_)
                           {
                              if("misc" !== _loc11_)
                              {
                                 if("dragonbone" !== _loc11_)
                                 {
                                    if("video" !== _loc11_)
                                    {
                                       _loc10_.writeByte(10);
                                    }
                                    else
                                    {
                                       _loc10_.writeByte(9);
                                    }
                                 }
                                 else
                                 {
                                    _loc10_.writeByte(8);
                                 }
                              }
                              else
                              {
                                 _loc10_.writeByte(7);
                              }
                           }
                           else
                           {
                              _loc10_.writeByte(6);
                           }
                        }
                        else
                        {
                           _loc10_.writeByte(5);
                        }
                     }
                     else
                     {
                        _loc10_.writeByte(4);
                     }
                  }
                  else
                  {
                     _loc10_.writeByte(3);
                  }
               }
               else
               {
                  _loc10_.writeByte(2);
               }
            }
            else
            {
               _loc10_.writeByte(1);
            }
         }
         else
         {
            _loc10_.writeByte(0);
         }
         _loc7_ = param1.getAttribute("id");
         this.writeString(_loc10_,_loc7_);
         this.writeString(_loc10_,param1.getAttribute("name",""));
         this.writeString(_loc10_,param1.getAttribute("path",""));
         if(_loc3_ == "sound" || _loc3_ == "swf" || _loc3_ == "atlas" || _loc3_ == "misc")
         {
            this.writeString(_loc10_,param1.getAttribute("file",""));
         }
         else
         {
            this.writeString(_loc10_,null);
         }
         _loc10_.writeBoolean(param1.getAttributeBool("exported"));
         _loc9_ = param1.getAttribute("size","");
         _loc2_ = _loc9_.split(",");
         _loc10_.writeInt(parseInt(_loc2_[0]));
         _loc10_.writeInt(parseInt(_loc2_[1]));
         _loc11_ = param1.getName();
         if("image" !== _loc11_)
         {
            if("movieclip" !== _loc11_)
            {
               if("font" !== _loc11_)
               {
                  if("component" !== _loc11_)
                  {
                     if("dragonbone" !== _loc11_)
                     {
                     }
                  }
                  else
                  {
                     _loc5_ = this.publishData.outputDesc[_loc7_ + ".xml"];
                     if(_loc5_)
                     {
                        _loc4_ = _loc5_.@extention;
                        if(_loc4_)
                        {
                           _loc11_ = _loc4_;
                           if("Label" !== _loc11_)
                           {
                              if("Button" !== _loc11_)
                              {
                                 if("ComboBox" !== _loc11_)
                                 {
                                    if("ProgressBar" !== _loc11_)
                                    {
                                       if("Slider" !== _loc11_)
                                       {
                                          if("ScrollBar" !== _loc11_)
                                          {
                                             _loc10_.writeByte(0);
                                          }
                                          else
                                          {
                                             _loc10_.writeByte(16);
                                          }
                                       }
                                       else
                                       {
                                          _loc10_.writeByte(15);
                                       }
                                    }
                                    else
                                    {
                                       _loc10_.writeByte(14);
                                    }
                                 }
                                 else
                                 {
                                    _loc10_.writeByte(13);
                                 }
                              }
                              else
                              {
                                 _loc10_.writeByte(12);
                              }
                           }
                           else
                           {
                              _loc10_.writeByte(11);
                           }
                        }
                        else
                        {
                           _loc10_.writeByte(0);
                        }
                        _loc8_ = this.addComponent(_loc7_,XData.attach(_loc5_));
                        _loc10_.writeInt(_loc8_.length);
                        _loc10_.writeBytes(_loc8_);
                        _loc8_.clear();
                     }
                     else
                     {
                        _loc10_.writeByte(0);
                        _loc10_.writeInt(0);
                     }
                  }
               }
               else
               {
                  _loc9_ = this.publishData.outputDesc[_loc7_ + ".fnt"];
                  if(_loc9_)
                  {
                     _loc8_ = this.addFont(_loc7_,_loc9_);
                     _loc10_.writeInt(_loc8_.length);
                     _loc10_.writeBytes(_loc8_);
                     _loc8_.clear();
                  }
                  else
                  {
                     _loc10_.writeInt(0);
                  }
               }
            }
            else
            {
               _loc10_.writeBoolean(param1.getAttributeBool("smoothing",true));
               _loc5_ = this.publishData.outputDesc[_loc7_ + ".xml"];
               if(_loc5_)
               {
                  _loc8_ = this.addMovieClip(_loc7_,_loc5_);
                  _loc10_.writeInt(_loc8_.length);
                  _loc10_.writeBytes(_loc8_);
                  _loc8_.clear();
               }
               else
               {
                  _loc10_.writeInt(0);
               }
            }
         }
         else
         {
            _loc9_ = param1.getAttribute("scale");
            if(_loc9_ == "9grid")
            {
               _loc10_.writeByte(1);
               _loc9_ = param1.getAttribute("scale9grid");
               if(_loc9_)
               {
                  _loc2_ = _loc9_.split(",");
                  _loc10_.writeInt(parseInt(_loc2_[0]));
                  _loc10_.writeInt(parseInt(_loc2_[1]));
                  _loc10_.writeInt(parseInt(_loc2_[2]));
                  _loc10_.writeInt(parseInt(_loc2_[3]));
               }
               else
               {
                  _loc10_.writeInt(0);
                  _loc10_.writeInt(0);
                  _loc10_.writeInt(0);
                  _loc10_.writeInt(0);
               }
               _loc10_.writeInt(param1.getAttributeInt("gridTile"));
            }
            else if(_loc9_ == "tile")
            {
               _loc10_.writeByte(2);
            }
            else
            {
               _loc10_.writeByte(0);
            }
            _loc10_.writeBoolean(param1.getAttributeBool("smoothing",true));
         }
         if(param1.getName() == "component")
         {
            this.writeString(_loc10_,param1.getAttribute("customExtention",""));
         }
         if(param1.getName() == "dragonbone")
         {
            this.writeString(_loc10_,param1.getAttribute("boneName",""));
            this.writeString(_loc10_,param1.getAttribute("armatureName",""));
            _loc6_ = 1;
            if(param1.getAttribute("boneType") != undefined)
            {
               _loc6_ = param1.getAttribute("boneType");
            }
            _loc10_.writeInt(_loc6_);
         }
         return _loc10_;
      }
      
      private function addComponent(param1:String, param2:XData) : ByteArray
      {
         var _loc9_:String = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc15_:* = 0;
         var _loc13_:Vector.<XData> = null;
         var _loc14_:XData = null;
         var _loc4_:ByteArray = null;
         var _loc6_:* = 0;
         var _loc10_:XData = null;
         var _loc8_:ByteArray = new ByteArray();
         this.controllerCache = {};
         this.controllerCnt = 0;
         this.displayList = {};
         _loc14_ = param2.getChild("displayList");
         if(_loc14_ != null)
         {
            _loc13_ = _loc14_.getChildren();
            _loc15_ = _loc13_.length;
            _loc12_ = 0;
            while(_loc12_ < _loc15_)
            {
               this.displayList[_loc13_[_loc12_].getAttribute("id")] = _loc12_;
               _loc12_++;
            }
         }
         this.startSegments(_loc8_,8,false);
         this.writeSegmentPos(_loc8_,0);
         _loc9_ = param2.getAttribute("size","");
         _loc11_ = _loc9_.split(",");
         _loc8_.writeInt(parseInt(_loc11_[0]));
         _loc8_.writeInt(parseInt(_loc11_[1]));
         _loc9_ = param2.getAttribute("restrictSize");
         if(_loc9_)
         {
            _loc11_ = _loc9_.split(",");
            _loc8_.writeBoolean(true);
            _loc8_.writeInt(parseInt(_loc11_[0]));
            _loc8_.writeInt(parseInt(_loc11_[1]));
            _loc8_.writeInt(parseInt(_loc11_[2]));
            _loc8_.writeInt(parseInt(_loc11_[3]));
         }
         else
         {
            _loc8_.writeBoolean(false);
         }
         _loc9_ = param2.getAttribute("pivot");
         if(_loc9_)
         {
            _loc11_ = _loc9_.split(",");
            _loc8_.writeBoolean(true);
            _loc8_.writeFloat(parseFloat(_loc11_[0]));
            _loc8_.writeFloat(parseFloat(_loc11_[1]));
            _loc8_.writeBoolean(param2.getAttributeBool("anchor"));
         }
         else
         {
            _loc8_.writeBoolean(false);
         }
         _loc9_ = param2.getAttribute("margin");
         if(_loc9_)
         {
            _loc11_ = _loc9_.split(",");
            _loc8_.writeBoolean(true);
            _loc8_.writeInt(parseInt(_loc11_[0]));
            _loc8_.writeInt(parseInt(_loc11_[1]));
            _loc8_.writeInt(parseInt(_loc11_[2]));
            _loc8_.writeInt(parseInt(_loc11_[3]));
         }
         else
         {
            _loc8_.writeBoolean(false);
         }
         var _loc5_:Boolean = false;
         _loc9_ = param2.getAttribute("overflow");
         if(_loc9_ == "hidden")
         {
            _loc8_.writeByte(1);
         }
         else if(_loc9_ == "scroll")
         {
            _loc8_.writeByte(2);
            _loc5_ = true;
         }
         else
         {
            _loc8_.writeByte(0);
         }
         _loc9_ = param2.getAttribute("clipSoftness");
         if(_loc9_)
         {
            _loc11_ = _loc9_.split(",");
            _loc8_.writeBoolean(true);
            _loc8_.writeInt(parseInt(_loc11_[0]));
            _loc8_.writeInt(parseInt(_loc11_[1]));
         }
         else
         {
            _loc8_.writeBoolean(false);
         }
         this.writeSegmentPos(_loc8_,1);
         _loc15_ = 0;
         _loc6_ = _loc8_.position;
         _loc8_.writeShort(0);
         var _loc7_:XDataEnumerator = param2.getEnumerator("controller");
         while(_loc7_.moveNext())
         {
            _loc4_ = this.encodeController(_loc7_.current);
            _loc8_.writeShort(_loc4_.length);
            _loc8_.writeBytes(_loc4_);
            _loc4_.clear();
            _loc15_++;
         }
         this.writeCount(_loc8_,_loc6_,_loc15_);
         this.writeSegmentPos(_loc8_,2);
         if(_loc14_ != null)
         {
            _loc13_ = _loc14_.getChildren();
            _loc15_ = _loc13_.length;
            _loc8_.writeShort(_loc15_);
            _loc12_ = 0;
            while(_loc12_ < _loc15_)
            {
               _loc4_ = this.encodeObject(_loc13_[_loc12_]);
               _loc8_.writeShort(_loc4_.length);
               _loc8_.writeBytes(_loc4_);
               _loc4_.clear();
               _loc12_++;
            }
         }
         else
         {
            _loc8_.writeShort(0);
         }
         this.writeSegmentPos(_loc8_,3);
         this.encodeRelations(param2,_loc8_,true);
         this.writeSegmentPos(_loc8_,4);
         this.writeString(_loc8_,param2.getAttribute("customData"),true);
         _loc8_.writeBoolean(param2.getAttributeBool("opaque",true));
         _loc9_ = param2.getAttribute("mask");
         if(this.displayList[_loc9_] != undefined)
         {
            _loc8_.writeShort(this.displayList[_loc9_]);
            _loc8_.writeBoolean(param2.getAttributeBool("reversedMask"));
         }
         else
         {
            _loc8_.writeShort(-1);
         }
         _loc9_ = param2.getAttribute("hitTest");
         if(_loc9_)
         {
            _loc11_ = _loc9_.split(",");
            this.writeString(_loc8_,_loc11_[0]);
            _loc8_.writeInt(parseInt(_loc11_[1]));
            _loc8_.writeInt(parseInt(_loc11_[2]));
         }
         else
         {
            this.writeString(_loc8_,null);
            _loc8_.writeInt(0);
            _loc8_.writeInt(0);
         }
         this.writeSegmentPos(_loc8_,5);
         _loc15_ = 0;
         _loc6_ = _loc8_.position;
         _loc8_.writeShort(0);
         _loc7_ = param2.getEnumerator("transition");
         while(_loc7_.moveNext())
         {
            _loc4_ = this.encodeTransition(_loc7_.current);
            _loc8_.writeShort(_loc4_.length);
            _loc8_.writeBytes(_loc4_);
            _loc4_.clear();
            _loc15_++;
         }
         this.writeCount(_loc8_,_loc6_,_loc15_);
         var _loc3_:String = param2.getAttribute("extention");
         if(_loc3_)
         {
            this.writeSegmentPos(_loc8_,6);
            _loc10_ = param2.getChild(_loc3_);
            if(!_loc10_)
            {
               _loc10_ = XData.create(_loc3_);
            }
            var _loc16_:* = _loc3_;
            if("Label" !== _loc16_)
            {
               if("Button" !== _loc16_)
               {
                  if("ComboBox" !== _loc16_)
                  {
                     if("ProgressBar" !== _loc16_)
                     {
                        if("Slider" !== _loc16_)
                        {
                           if("ScrollBar" === _loc16_)
                           {
                              _loc8_.writeBoolean(_loc10_.getAttributeBool("fixedGripSize"));
                           }
                        }
                        else
                        {
                           _loc9_ = _loc10_.getAttribute("titleType");
                           _loc16_ = _loc9_;
                           if("percent" !== _loc16_)
                           {
                              if("valueAndmax" !== _loc16_)
                              {
                                 if("value" !== _loc16_)
                                 {
                                    if("max" !== _loc16_)
                                    {
                                       _loc8_.writeByte(0);
                                    }
                                    else
                                    {
                                       _loc8_.writeByte(3);
                                    }
                                 }
                                 else
                                 {
                                    _loc8_.writeByte(2);
                                 }
                              }
                              else
                              {
                                 _loc8_.writeByte(1);
                              }
                           }
                           else
                           {
                              _loc8_.writeByte(0);
                           }
                           _loc8_.writeBoolean(_loc10_.getAttributeBool("reverse"));
                        }
                     }
                     else
                     {
                        _loc9_ = _loc10_.getAttribute("titleType");
                        _loc16_ = _loc9_;
                        if("percent" !== _loc16_)
                        {
                           if("valueAndmax" !== _loc16_)
                           {
                              if("value" !== _loc16_)
                              {
                                 if("max" !== _loc16_)
                                 {
                                    _loc8_.writeByte(0);
                                 }
                                 else
                                 {
                                    _loc8_.writeByte(3);
                                 }
                              }
                              else
                              {
                                 _loc8_.writeByte(2);
                              }
                           }
                           else
                           {
                              _loc8_.writeByte(1);
                           }
                        }
                        else
                        {
                           _loc8_.writeByte(0);
                        }
                        _loc8_.writeBoolean(_loc10_.getAttributeBool("reverse"));
                     }
                  }
                  else
                  {
                     this.writeString(_loc8_,_loc10_.getAttribute("dropdown"));
                  }
               }
               else
               {
                  _loc9_ = _loc10_.getAttribute("mode");
                  if(_loc9_ == "Check")
                  {
                     _loc8_.writeByte(1);
                  }
                  else if(_loc9_ == "Radio")
                  {
                     _loc8_.writeByte(2);
                  }
                  else
                  {
                     _loc8_.writeByte(0);
                  }
                  this.writeString(_loc8_,_loc10_.getAttribute("sound"));
                  _loc8_.writeFloat(_loc10_.getAttributeInt("volume",100) / 100);
                  _loc9_ = _loc10_.getAttribute("downEffect","none");
                  if(_loc9_ == "dark")
                  {
                     _loc8_.writeByte(1);
                  }
                  else if(_loc9_ == "scale")
                  {
                     _loc8_.writeByte(2);
                  }
                  else
                  {
                     _loc8_.writeByte(0);
                  }
                  _loc8_.writeFloat(_loc10_.getAttributeFloat("downEffectValue",0.8));
               }
            }
         }
         if(_loc5_)
         {
            this.writeSegmentPos(_loc8_,7);
            _loc4_ = this.encodeScrollPane(param2);
            _loc8_.writeBytes(_loc4_);
            _loc4_.clear();
         }
         return _loc8_;
      }
      
      private function encodeController(param1:XData) : ByteArray
      {
         var _loc8_:ByteArray = null;
         var _loc9_:String = null;
         var _loc2_:Array = null;
         var _loc4_:* = 0;
         var _loc7_:* = 0;
         var _loc6_:* = 0;
         var _loc3_:XData = null;
         var _loc10_:ByteArray = new ByteArray();
         this.startSegments(_loc10_,3,true);
         this.writeSegmentPos(_loc10_,0);
         _loc9_ = param1.getAttribute("name");
         this.writeString(_loc10_,_loc9_);
         var _loc11_:Number = this.controllerCnt;
         this.controllerCnt++;
         this.controllerCache[_loc9_] = _loc11_;
         _loc10_.writeBoolean(param1.getAttributeBool("autoRadioGroupDepth"));
         this.writeSegmentPos(_loc10_,1);
         _loc9_ = param1.getAttribute("pages");
         if(_loc9_)
         {
            _loc2_ = _loc9_.split(",");
            _loc7_ = _loc2_.length;
            _loc10_.writeShort(_loc7_ / 2);
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               this.writeString(_loc10_,_loc2_[_loc4_],false,false);
               this.writeString(_loc10_,_loc2_[_loc4_ + 1],false,false);
               _loc4_ = _loc4_ + 2;
            }
         }
         else
         {
            _loc10_.writeShort(0);
         }
         this.writeSegmentPos(_loc10_,2);
         var _loc5_:Vector.<XData> = param1.getChildren();
         _loc7_ = 0;
         _loc6_ = _loc10_.position;
         _loc10_.writeShort(0);
         var _loc13_:int = 0;
         var _loc12_:* = _loc5_;
         for each(_loc3_ in _loc5_)
         {
            if(_loc3_.getName() == "action")
            {
               _loc9_ = _loc3_.getAttribute("type");
               _loc8_ = this.encodeControllerAction(_loc9_,_loc3_);
               _loc10_.writeShort(_loc8_.length + 1);
               if(_loc9_ == "play_transition")
               {
                  _loc10_.writeByte(0);
               }
               else if(_loc9_ == "change_page")
               {
                  _loc10_.writeByte(1);
               }
               else
               {
                  _loc10_.writeByte(0);
               }
               _loc10_.writeBytes(_loc8_);
               _loc7_++;
            }
         }
         this.writeCount(_loc10_,_loc6_,_loc7_);
         return _loc10_;
      }
      
      private function encodeControllerAction(param1:String, param2:XData) : ByteArray
      {
         var _loc7_:String = null;
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = new ByteArray();
         _loc7_ = param2.getAttribute("fromPage");
         if(_loc7_)
         {
            _loc3_ = _loc7_.split(",");
            _loc4_ = _loc3_.length;
            _loc6_.writeShort(_loc4_);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.writeString(_loc6_,_loc3_[_loc5_]);
               _loc5_++;
            }
         }
         else
         {
            _loc6_.writeShort(0);
         }
         _loc7_ = param2.getAttribute("toPage");
         if(_loc7_)
         {
            _loc3_ = _loc7_.split(",");
            _loc4_ = _loc3_.length;
            _loc6_.writeShort(_loc4_);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.writeString(_loc6_,_loc3_[_loc5_]);
               _loc5_++;
            }
         }
         else
         {
            _loc6_.writeShort(0);
         }
         if(param1 == "play_transition")
         {
            this.writeString(_loc6_,param2.getAttribute("transition"));
            _loc6_.writeInt(param2.getAttributeInt("repeat",1));
            _loc6_.writeFloat(param2.getAttributeFloat("delay"));
            _loc6_.writeBoolean(param2.getAttributeBool("stopOnExit"));
         }
         else if(param1 == "change_page")
         {
            this.writeString(_loc6_,param2.getAttribute("objectId"));
            this.writeString(_loc6_,param2.getAttribute("controller"));
            this.writeString(_loc6_,param2.getAttribute("targetPage"));
         }
         return _loc6_;
      }
      
      private function encodeRelations(param1:XData, param2:ByteArray, param3:Boolean) : void
      {
         var _loc10_:String = null;
         var _loc13_:Array = null;
         var _loc16_:XData = null;
         var _loc5_:* = 0;
         var _loc7_:Array = null;
         var _loc6_:String = null;
         var _loc8_:String = null;
         var _loc4_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc9_:* = undefined;
         var _loc14_:Array = [];
         var _loc17_:Object = {};
         var _loc15_:XDataEnumerator = param1.getEnumerator("relation");
         while(_loc15_.moveNext())
         {
            _loc16_ = _loc15_.current;
            _loc10_ = _loc16_.getAttribute("target");
            _loc5_ = -1;
            if(_loc10_)
            {
               if(this.displayList[_loc10_] != undefined)
               {
                  _loc5_ = this.displayList[_loc10_];
               }
               else
               {
                  continue;
               }
            }
            else
            {
               if(param3)
               {
               }
               continue;
            }
            _loc10_ = _loc16_.getAttribute("sidePair");
            if(_loc10_)
            {
               _loc7_ = _loc17_[_loc5_];
               if(!_loc7_)
               {
                  _loc14_.push(_loc5_);
                  _loc7_ = [];
                  _loc17_[_loc5_] = _loc7_;
               }
               _loc13_ = _loc10_.split(",");
               _loc12_ = 0;
               while(_loc12_ < 2)
               {
                  _loc6_ = _loc13_[_loc12_];
                  if(_loc6_)
                  {
                     if(_loc6_.charAt(_loc6_.length - 1) == "%")
                     {
                        _loc6_ = _loc6_.substr(0,_loc6_.length - 1);
                        _loc11_ = true;
                     }
                     else
                     {
                        _loc11_ = false;
                     }
                     _loc9_ = RelationNameToID[_loc6_];
                     if(_loc9_ != undefined)
                     {
                        _loc7_.push(!!_loc11_?10000 + _loc9_:_loc9_);
                     }
                  }
                  _loc12_++;
               }
               continue;
            }
         }
         param2.writeByte(_loc14_.length);
         var _loc21_:int = 0;
         var _loc20_:* = _loc14_;
         for each(_loc5_ in _loc14_)
         {
            param2.writeShort(_loc5_);
            _loc7_ = _loc17_[_loc5_];
            param2.writeByte(_loc7_.length);
            var _loc19_:int = 0;
            var _loc18_:* = _loc7_;
            for each(_loc12_ in _loc7_)
            {
               if(_loc12_ >= 10000)
               {
                  param2.writeByte(_loc12_ - 10000);
                  param2.writeBoolean(true);
               }
               else
               {
                  param2.writeByte(_loc12_);
                  param2.writeBoolean(false);
               }
            }
         }
      }
      
      private function encodeScrollPane(param1:XData) : ByteArray
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:ByteArray = new ByteArray();
         _loc2_ = param1.getAttribute("scroll");
         if(_loc2_ == "horizontal")
         {
            _loc4_.writeByte(0);
         }
         else if(_loc2_ == "both")
         {
            _loc4_.writeByte(2);
         }
         else
         {
            _loc4_.writeByte(1);
         }
         _loc2_ = param1.getAttribute("scrollBar");
         if(_loc2_ == "visible")
         {
            _loc4_.writeByte(1);
         }
         else if(_loc2_ == "auto")
         {
            _loc4_.writeByte(2);
         }
         else if(_loc2_ == "hidden")
         {
            _loc4_.writeByte(3);
         }
         else
         {
            _loc4_.writeByte(0);
         }
         _loc4_.writeInt(param1.getAttributeInt("scrollBarFlags"));
         _loc2_ = param1.getAttribute("scrollBarMargin");
         if(_loc2_)
         {
            _loc3_ = _loc2_.split(",");
            _loc4_.writeBoolean(true);
            _loc4_.writeInt(parseInt(_loc3_[0]));
            _loc4_.writeInt(parseInt(_loc3_[1]));
            _loc4_.writeInt(parseInt(_loc3_[2]));
            _loc4_.writeInt(parseInt(_loc3_[3]));
         }
         else
         {
            _loc4_.writeBoolean(false);
         }
         _loc2_ = param1.getAttribute("scrollBarRes");
         if(_loc2_)
         {
            _loc3_ = _loc2_.split(",");
            this.writeString(_loc4_,_loc3_[0]);
            this.writeString(_loc4_,_loc3_[1]);
         }
         else
         {
            this.writeString(_loc4_,null);
            this.writeString(_loc4_,null);
         }
         _loc2_ = param1.getAttribute("ptrRes");
         if(_loc2_)
         {
            _loc3_ = _loc2_.split(",");
            this.writeString(_loc4_,_loc3_[0]);
            this.writeString(_loc4_,_loc3_[1]);
         }
         else
         {
            this.writeString(_loc4_,null);
            this.writeString(_loc4_,null);
         }
         return _loc4_;
      }
      
      private function encodeTransition(param1:XData) : ByteArray
      {
         var _loc10_:ByteArray = null;
         var _loc11_:String = null;
         var _loc2_:Array = null;
         var _loc5_:int = 0;
         var _loc9_:int = 0;
         var _loc8_:* = 0;
         var _loc4_:XData = null;
         var _loc6_:String = null;
         var _loc3_:* = undefined;
         var _loc12_:ByteArray = new ByteArray();
         this.writeString(_loc12_,param1.getAttribute("name"));
         _loc12_.writeInt(param1.getAttributeInt("options"));
         _loc12_.writeBoolean(param1.getAttributeBool("autoPlay"));
         _loc12_.writeInt(param1.getAttributeInt("autoPlayRepeat",1));
         _loc12_.writeFloat(param1.getAttributeFloat("autoPlayDelay"));
         _loc8_ = _loc12_.position;
         _loc12_.writeShort(0);
         _loc9_ = 0;
         var _loc7_:XDataEnumerator = param1.getEnumerator("item");
         while(_loc7_.moveNext())
         {
            _loc4_ = _loc7_.current;
            _loc10_ = new ByteArray();
            this.startSegments(_loc10_,4,true);
            this.writeSegmentPos(_loc10_,0);
            _loc6_ = _loc4_.getAttribute("type");
            this.writeTransitionActionType(_loc10_,_loc6_);
            _loc10_.writeFloat(_loc4_.getAttributeInt("time") / 24);
            _loc11_ = _loc4_.getAttribute("target");
            if(!_loc11_)
            {
               _loc10_.writeShort(-1);
            }
            else
            {
               _loc3_ = this.displayList[_loc11_];
               if(_loc3_ == undefined)
               {
                  _loc10_.clear();
                  continue;
               }
               _loc10_.writeShort(int(_loc3_));
            }
            this.writeString(_loc10_,_loc4_.getAttribute("label"));
            _loc11_ = _loc4_.getAttribute("endValue");
            if(_loc4_.getAttributeBool("tween") && _loc11_ != null)
            {
               _loc10_.writeBoolean(true);
               this.writeSegmentPos(_loc10_,1);
               _loc10_.writeFloat(_loc4_.getAttributeInt("duration") / 24);
               _loc10_.writeByte(EaseType.parseEaseType(_loc4_.getAttribute("ease")));
               _loc10_.writeInt(_loc4_.getAttributeInt("repeat"));
               _loc10_.writeBoolean(_loc4_.getAttributeBool("yoyo"));
               this.writeString(_loc10_,_loc4_.getAttribute("label2"));
               this.writeSegmentPos(_loc10_,2);
               _loc11_ = _loc4_.getAttribute("startValue");
               this.writeTransitionValue(_loc10_,_loc6_,_loc11_);
               this.writeSegmentPos(_loc10_,3);
               _loc11_ = _loc4_.getAttribute("endValue");
               this.writeTransitionValue(_loc10_,_loc6_,_loc11_);
            }
            else
            {
               _loc10_.writeBoolean(false);
               this.writeSegmentPos(_loc10_,2);
               _loc11_ = _loc4_.getAttribute("value");
               if(_loc11_ == null)
               {
                  _loc11_ = _loc4_.getAttribute("startValue");
               }
               this.writeTransitionValue(_loc10_,_loc6_,_loc11_);
            }
            _loc12_.writeShort(_loc10_.length);
            _loc12_.writeBytes(_loc10_);
            _loc10_.clear();
            _loc9_++;
         }
         this.writeCount(_loc12_,_loc8_,_loc9_);
         return _loc12_;
      }
      
      private function encodeObject(param1:XData) : ByteArray
      {
         var _loc3_:* = null;
         var _loc19_:* = null;
         var _loc17_:int = 0;
         var _loc13_:Boolean = false;
         var _loc24_:ByteArray = null;
         var _loc8_:String = null;
         var _loc28_:Array = null;
         var _loc11_:* = 0;
         var _loc30_:int = 0;
         var _loc12_:Vector.<XData> = null;
         var _loc29_:XData = null;
         var _loc21_:* = 0;
         var _loc20_:int = 0;
         var _loc4_:XData = null;
         var _loc18_:* = undefined;
         var _loc10_:* = undefined;
         var _loc27_:* = 0;
         var _loc5_:String = null;
         var _loc22_:* = 0;
         var _loc14_:* = 0;
         var _loc23_:String = null;
         var _loc31_:String = null;
         var _loc15_:* = 0;
         var _loc6_:* = 0;
         var _loc26_:* = false;
         var _loc7_:XData = null;
         var _loc25_:XDataEnumerator = null;
         var _loc9_:ByteArray = new ByteArray();
         var _loc2_:String = param1.getName();
         if(_loc2_ == "list")
         {
            _loc20_ = 9;
         }
         else
         {
            _loc20_ = 7;
         }
         this.startSegments(_loc9_,_loc20_,true);
         this.writeSegmentPos(_loc9_,0);
         var _loc32_:* = _loc2_;
         if("image" !== _loc32_)
         {
            if("movieclip" !== _loc32_)
            {
               if("swf" !== _loc32_)
               {
                  if("graph" !== _loc32_)
                  {
                     if("loader" !== _loc32_)
                     {
                        if("group" !== _loc32_)
                        {
                           if("text" !== _loc32_)
                           {
                              if("richtext" !== _loc32_)
                              {
                                 if("component" !== _loc32_)
                                 {
                                    if("list" !== _loc32_)
                                    {
                                       if("dragonbone" !== _loc32_)
                                       {
                                          _loc9_.writeByte(0);
                                       }
                                       else
                                       {
                                          _loc9_.writeByte(18);
                                       }
                                    }
                                    else
                                    {
                                       _loc9_.writeByte(10);
                                    }
                                 }
                                 else
                                 {
                                    _loc9_.writeByte(9);
                                 }
                              }
                              else
                              {
                                 _loc9_.writeByte(7);
                              }
                           }
                           else if(param1.getAttributeBool("input"))
                           {
                              _loc9_.writeByte(8);
                           }
                           else
                           {
                              _loc9_.writeByte(6);
                           }
                        }
                        else
                        {
                           _loc9_.writeByte(5);
                        }
                     }
                     else
                     {
                        _loc9_.writeByte(4);
                     }
                  }
                  else
                  {
                     _loc9_.writeByte(3);
                  }
               }
               else
               {
                  _loc9_.writeByte(2);
               }
            }
            else
            {
               _loc9_.writeByte(1);
            }
         }
         else
         {
            _loc9_.writeByte(0);
         }
         this.writeString(_loc9_,param1.getAttribute("src"));
         this.writeString(_loc9_,param1.getAttribute("pkg"));
         this.writeString(_loc9_,param1.getAttribute("id",""));
         this.writeString(_loc9_,param1.getAttribute("name",""));
         if(param1.getName() == "component")
         {
            _loc3_ = param1.getAttribute("events");
            this.writeString(_loc9_,_loc3_,true);
         }
         if(param1.getName() == "dragonbone")
         {
            _loc19_ = param1.getAttribute("aniName");
            this.writeString(_loc9_,_loc19_,true);
            _loc17_ = 0;
            if(param1.getAttribute("frame") != undefined)
            {
               _loc17_ = parseInt(param1.getAttribute("frame"));
            }
            _loc9_.writeInt(_loc17_);
            _loc13_ = false;
            if(param1.getAttribute("playing") != undefined && param1.getAttribute("playing") == "true")
            {
               _loc13_ = true;
            }
            _loc9_.writeBoolean(_loc13_);
         }
         _loc8_ = param1.getAttribute("xy");
         _loc28_ = _loc8_.split(",");
         _loc9_.writeInt(int(_loc28_[0]));
         _loc9_.writeInt(int(_loc28_[1]));
         _loc8_ = param1.getAttribute("size");
         if(_loc8_)
         {
            _loc9_.writeBoolean(true);
            _loc28_ = _loc8_.split(",");
            _loc9_.writeInt(parseInt(_loc28_[0]));
            _loc9_.writeInt(parseInt(_loc28_[1]));
         }
         else
         {
            _loc9_.writeBoolean(false);
         }
         _loc8_ = param1.getAttribute("restrictSize");
         if(_loc8_)
         {
            _loc9_.writeBoolean(true);
            _loc28_ = _loc8_.split(",");
            _loc9_.writeInt(parseInt(_loc28_[0]));
            _loc9_.writeInt(parseInt(_loc28_[1]));
            _loc9_.writeInt(parseInt(_loc28_[2]));
            _loc9_.writeInt(parseInt(_loc28_[3]));
         }
         else
         {
            _loc9_.writeBoolean(false);
         }
         _loc8_ = param1.getAttribute("scale");
         if(_loc8_)
         {
            _loc9_.writeBoolean(true);
            _loc28_ = _loc8_.split(",");
            _loc9_.writeFloat(parseFloat(_loc28_[0]));
            _loc9_.writeFloat(parseFloat(_loc28_[1]));
         }
         else
         {
            _loc9_.writeBoolean(false);
         }
         _loc8_ = param1.getAttribute("skew");
         if(_loc8_)
         {
            _loc9_.writeBoolean(true);
            _loc28_ = _loc8_.split(",");
            _loc9_.writeFloat(parseFloat(_loc28_[0]));
            _loc9_.writeFloat(parseFloat(_loc28_[1]));
         }
         else
         {
            _loc9_.writeBoolean(false);
         }
         _loc8_ = param1.getAttribute("pivot");
         if(_loc8_)
         {
            _loc28_ = _loc8_.split(",");
            _loc9_.writeBoolean(true);
            _loc9_.writeFloat(parseFloat(_loc28_[0]));
            _loc9_.writeFloat(parseFloat(_loc28_[1]));
            _loc9_.writeBoolean(param1.getAttributeBool("anchor"));
         }
         else
         {
            _loc9_.writeBoolean(false);
         }
         _loc9_.writeFloat(param1.getAttributeFloat("alpha",1));
         _loc9_.writeFloat(param1.getAttributeFloat("rotation"));
         _loc9_.writeBoolean(param1.getAttributeBool("visible",true));
         _loc9_.writeBoolean(param1.getAttributeBool("touchable",true));
         _loc9_.writeBoolean(param1.getAttributeBool("grayed"));
         _loc8_ = param1.getAttribute("blend");
         _loc32_ = _loc8_;
         if("add" !== _loc32_)
         {
            if("multiply" !== _loc32_)
            {
               if("none" !== _loc32_)
               {
                  if("screen" !== _loc32_)
                  {
                     if("erase" !== _loc32_)
                     {
                        _loc9_.writeByte(0);
                     }
                     else
                     {
                        _loc9_.writeByte(5);
                     }
                  }
                  else
                  {
                     _loc9_.writeByte(4);
                  }
               }
               else
               {
                  _loc9_.writeByte(1);
               }
            }
            else
            {
               _loc9_.writeByte(3);
            }
         }
         else
         {
            _loc9_.writeByte(2);
         }
         _loc8_ = param1.getAttribute("filter");
         if(_loc8_)
         {
            if(_loc8_ == "color")
            {
               _loc9_.writeByte(1);
               _loc8_ = param1.getAttribute("filterData");
               _loc28_ = _loc8_.split(",");
               _loc9_.writeFloat(parseFloat(_loc28_[0]));
               _loc9_.writeFloat(parseFloat(_loc28_[1]));
               _loc9_.writeFloat(parseFloat(_loc28_[2]));
               _loc9_.writeFloat(parseFloat(_loc28_[3]));
            }
            else
            {
               _loc9_.writeByte(0);
            }
         }
         else
         {
            _loc9_.writeByte(0);
         }
         this.writeString(_loc9_,param1.getAttribute("customData"),true);
         this.writeSegmentPos(_loc9_,1);
         var _loc16_:String = param1.getName();
         this.writeString(_loc9_,param1.getAttribute("tooltips"),true);
         _loc8_ = param1.getAttribute("group");
         if(_loc8_ && this.displayList[_loc8_] != undefined)
         {
            _loc9_.writeShort(this.displayList[_loc8_]);
         }
         else
         {
            _loc9_.writeShort(-1);
         }
         this.writeSegmentPos(_loc9_,2);
         _loc12_ = param1.getChildren();
         _loc30_ = 0;
         _loc21_ = _loc9_.position;
         _loc9_.writeShort(0);
         var _loc34_:* = 0;
         var _loc33_:* = _loc12_;
         for each(_loc4_ in _loc12_)
         {
            _loc18_ = EGObject.GearKeys[_loc4_.getName()];
            if(_loc18_ != undefined)
            {
               _loc24_ = this.encodeGear(int(_loc18_),_loc4_);
               if(_loc24_ != null)
               {
                  _loc30_++;
                  _loc9_.writeShort(_loc24_.length + 1);
                  _loc9_.writeByte(_loc18_);
                  _loc9_.writeBytes(_loc24_);
                  _loc24_.clear();
               }
            }
         }
         this.writeCount(_loc9_,_loc21_,_loc30_);
         this.writeSegmentPos(_loc9_,3);
         this.encodeRelations(param1,_loc9_,false);
         if(_loc2_ == "component" || _loc2_ == "list")
         {
            this.writeSegmentPos(_loc9_,4);
            _loc10_ = this.controllerCache[param1.getAttribute("pageController")];
            if(_loc10_ != undefined)
            {
               _loc9_.writeShort(_loc10_);
            }
            else
            {
               _loc9_.writeShort(-1);
            }
            _loc8_ = param1.getAttribute("controller");
            if(_loc8_)
            {
               _loc21_ = _loc9_.position;
               _loc9_.writeShort(0);
               _loc28_ = _loc8_.split(",");
               _loc30_ = 0;
               _loc11_ = 0;
               while(_loc11_ < _loc28_.length)
               {
                  if(_loc28_[_loc11_])
                  {
                     this.writeString(_loc9_,_loc28_[_loc11_]);
                     this.writeString(_loc9_,_loc28_[_loc11_ + 1]);
                     _loc30_++;
                  }
                  _loc11_ = _loc11_ + 2;
               }
               this.writeCount(_loc9_,_loc21_,_loc30_);
            }
            else
            {
               _loc9_.writeShort(0);
            }
         }
         else if(_loc2_ == "text" && param1.getAttributeBool("input"))
         {
            this.writeSegmentPos(_loc9_,4);
            this.writeString(_loc9_,param1.getAttribute("prompt"));
            this.writeString(_loc9_,param1.getAttribute("restrict"));
            _loc9_.writeInt(param1.getAttributeInt("maxLength"));
            _loc9_.writeInt(param1.getAttributeInt("keyboardType"));
            _loc9_.writeBoolean(param1.getAttributeBool("password"));
         }
         this.writeSegmentPos(_loc9_,5);
         _loc32_ = _loc2_;
         if("image" !== _loc32_)
         {
            if("movieclip" !== _loc32_)
            {
               if("graph" !== _loc32_)
               {
                  if("loader" !== _loc32_)
                  {
                     if("group" !== _loc32_)
                     {
                        if("text" !== _loc32_)
                        {
                           if("richtext" !== _loc32_)
                           {
                              if("component" !== _loc32_)
                              {
                                 if("list" !== _loc32_)
                                 {
                                    if("swf" === _loc32_)
                                    {
                                       _loc9_.writeBoolean(param1.getAttributeBool("playing",true));
                                    }
                                 }
                                 else
                                 {
                                    _loc5_ = param1.getAttribute("layout");
                                    _loc32_ = _loc5_;
                                    if("column" !== _loc32_)
                                    {
                                       if("row" !== _loc32_)
                                       {
                                          if("flow_hz" !== _loc32_)
                                          {
                                             if("flow_vt" !== _loc32_)
                                             {
                                                if("pagination" !== _loc32_)
                                                {
                                                   _loc9_.writeByte(0);
                                                }
                                                else
                                                {
                                                   _loc9_.writeByte(4);
                                                }
                                             }
                                             else
                                             {
                                                _loc9_.writeByte(3);
                                             }
                                          }
                                          else
                                          {
                                             _loc9_.writeByte(2);
                                          }
                                       }
                                       else
                                       {
                                          _loc9_.writeByte(1);
                                       }
                                    }
                                    else
                                    {
                                       _loc9_.writeByte(0);
                                    }
                                    _loc8_ = param1.getAttribute("selectionMode");
                                    _loc34_ = _loc8_;
                                    if("single" !== _loc34_)
                                    {
                                       if("multiple" !== _loc34_)
                                       {
                                          if("multipleSingleClick" !== _loc34_)
                                          {
                                             if("none" !== _loc34_)
                                             {
                                                _loc9_.writeByte(0);
                                             }
                                             else
                                             {
                                                _loc9_.writeByte(3);
                                             }
                                          }
                                          else
                                          {
                                             _loc9_.writeByte(2);
                                          }
                                       }
                                       else
                                       {
                                          _loc9_.writeByte(1);
                                       }
                                    }
                                    else
                                    {
                                       _loc9_.writeByte(0);
                                    }
                                    this.writeAlign(_loc9_,param1.getAttribute("align"));
                                    this.writeVertAlign(_loc9_,param1.getAttribute("vAlign"));
                                    _loc9_.writeShort(param1.getAttributeInt("lineGap"));
                                    _loc9_.writeShort(param1.getAttributeInt("colGap"));
                                    _loc22_ = param1.getAttributeInt("lineItemCount");
                                    _loc14_ = param1.getAttributeInt("lineItemCount2");
                                    if(_loc5_ == "flow_hz")
                                    {
                                       _loc9_.writeShort(0);
                                       _loc9_.writeShort(_loc22_);
                                    }
                                    else if(_loc5_ == "flow_vt")
                                    {
                                       _loc9_.writeShort(_loc22_);
                                       _loc9_.writeShort(0);
                                    }
                                    else if(_loc5_ == "pagination")
                                    {
                                       _loc9_.writeShort(_loc14_);
                                       _loc9_.writeShort(_loc22_);
                                    }
                                    else
                                    {
                                       _loc9_.writeShort(0);
                                       _loc9_.writeShort(0);
                                    }
                                    if(!_loc5_ || _loc5_ == "row" || _loc5_ == "column")
                                    {
                                       _loc9_.writeBoolean(param1.getAttributeBool("autoItemSize",true));
                                    }
                                    else
                                    {
                                       _loc9_.writeBoolean(param1.getAttributeBool("autoItemSize",false));
                                    }
                                    _loc8_ = param1.getAttribute("renderOrder");
                                    _loc33_ = _loc8_;
                                    if("ascent" !== _loc33_)
                                    {
                                       if("descent" !== _loc33_)
                                       {
                                          if("arch" !== _loc33_)
                                          {
                                             _loc9_.writeByte(0);
                                          }
                                          else
                                          {
                                             _loc9_.writeByte(2);
                                          }
                                       }
                                       else
                                       {
                                          _loc9_.writeByte(1);
                                       }
                                    }
                                    else
                                    {
                                       _loc9_.writeByte(0);
                                    }
                                    _loc9_.writeShort(param1.getAttributeInt("apex"));
                                    _loc8_ = param1.getAttribute("margin");
                                    if(_loc8_)
                                    {
                                       _loc28_ = _loc8_.split(",");
                                       _loc9_.writeBoolean(true);
                                       _loc9_.writeInt(parseInt(_loc28_[0]));
                                       _loc9_.writeInt(parseInt(_loc28_[1]));
                                       _loc9_.writeInt(parseInt(_loc28_[2]));
                                       _loc9_.writeInt(parseInt(_loc28_[3]));
                                    }
                                    else
                                    {
                                       _loc9_.writeBoolean(false);
                                    }
                                    _loc8_ = param1.getAttribute("overflow");
                                    if(_loc8_ == "hidden")
                                    {
                                       _loc9_.writeByte(1);
                                    }
                                    else if(_loc8_ == "scroll")
                                    {
                                       _loc9_.writeByte(2);
                                    }
                                    else
                                    {
                                       _loc9_.writeByte(0);
                                    }
                                    _loc8_ = param1.getAttribute("clipSoftness");
                                    if(_loc8_)
                                    {
                                       _loc28_ = _loc8_.split(",");
                                       _loc9_.writeBoolean(true);
                                       _loc9_.writeInt(parseInt(_loc28_[0]));
                                       _loc9_.writeInt(parseInt(_loc28_[1]));
                                    }
                                    else
                                    {
                                       _loc9_.writeBoolean(false);
                                    }
                                 }
                              }
                           }
                        }
                        this.writeString(_loc9_,param1.getAttribute("font"));
                        _loc9_.writeShort(param1.getAttributeInt("fontSize"));
                        this.writeColor(_loc9_,param1.getAttribute("color"),false);
                        this.writeAlign(_loc9_,param1.getAttribute("align"));
                        this.writeVertAlign(_loc9_,param1.getAttribute("vAlign"));
                        _loc9_.writeShort(param1.getAttributeInt("leading",3));
                        _loc9_.writeShort(param1.getAttributeInt("letterSpacing"));
                        _loc9_.writeBoolean(param1.getAttributeBool("ubb"));
                        this.writeAutoSizeType(_loc9_,param1.getAttribute("autoSize","both"));
                        _loc9_.writeBoolean(param1.getAttributeBool("underline"));
                        _loc9_.writeBoolean(param1.getAttributeBool("italic"));
                        _loc9_.writeBoolean(param1.getAttributeBool("bold"));
                        _loc9_.writeBoolean(param1.getAttributeBool("singleLine"));
                        _loc8_ = param1.getAttribute("strokeColor");
                        if(_loc8_)
                        {
                           _loc9_.writeBoolean(true);
                           this.writeColor(_loc9_,_loc8_);
                           _loc9_.writeFloat(param1.getAttributeInt("strokeSize",1));
                        }
                        else
                        {
                           _loc9_.writeBoolean(false);
                        }
                        _loc8_ = param1.getAttribute("shadowColor");
                        if(_loc8_)
                        {
                           _loc9_.writeBoolean(true);
                           this.writeColor(_loc9_,param1.getAttribute("shadowColor"));
                           _loc8_ = param1.getAttribute("shadowOffset");
                           if(_loc8_)
                           {
                              _loc28_ = _loc8_.split(",");
                              _loc9_.writeFloat(parseFloat(_loc28_[0]));
                              _loc9_.writeFloat(parseFloat(_loc28_[1]));
                           }
                           else
                           {
                              _loc9_.writeFloat(1);
                              _loc9_.writeFloat(1);
                           }
                        }
                        else
                        {
                           _loc9_.writeBoolean(false);
                        }
                        _loc9_.writeBoolean(param1.getAttributeBool("vars"));
                     }
                     else
                     {
                        _loc8_ = param1.getAttribute("layout");
                        _loc33_ = _loc8_;
                        if("hz" !== _loc33_)
                        {
                           if("vt" !== _loc33_)
                           {
                              _loc9_.writeByte(0);
                           }
                           else
                           {
                              _loc9_.writeByte(2);
                           }
                        }
                        else
                        {
                           _loc9_.writeByte(1);
                        }
                        _loc9_.writeInt(param1.getAttributeInt("lineGap"));
                        _loc9_.writeInt(param1.getAttributeInt("colGap"));
                     }
                  }
                  else
                  {
                     this.writeString(_loc9_,param1.getAttribute("url",""));
                     this.writeAlign(_loc9_,param1.getAttribute("align"));
                     this.writeVertAlign(_loc9_,param1.getAttribute("vAlign"));
                     _loc8_ = param1.getAttribute("fill");
                     _loc34_ = _loc8_;
                     if("none" !== _loc34_)
                     {
                        if("scale" !== _loc34_)
                        {
                           if("scaleMatchHeight" !== _loc34_)
                           {
                              if("scaleMatchWidth" !== _loc34_)
                              {
                                 if("scaleFree" !== _loc34_)
                                 {
                                    if("scaleNoBorder" !== _loc34_)
                                    {
                                       _loc9_.writeByte(0);
                                    }
                                    else
                                    {
                                       _loc9_.writeByte(5);
                                    }
                                 }
                                 else
                                 {
                                    _loc9_.writeByte(4);
                                 }
                              }
                              else
                              {
                                 _loc9_.writeByte(3);
                              }
                           }
                           else
                           {
                              _loc9_.writeByte(2);
                           }
                        }
                        else
                        {
                           _loc9_.writeByte(1);
                        }
                     }
                     else
                     {
                        _loc9_.writeByte(0);
                     }
                     _loc9_.writeBoolean(param1.getAttributeBool("shrinkOnly"));
                     _loc9_.writeBoolean(param1.getAttributeBool("autoSize"));
                     _loc9_.writeBoolean(param1.getAttributeBool("errorSign"));
                     _loc9_.writeBoolean(param1.getAttributeBool("playing",true));
                     _loc9_.writeInt(param1.getAttributeInt("frame"));
                     _loc8_ = param1.getAttribute("color");
                     if(_loc8_)
                     {
                        _loc9_.writeBoolean(true);
                        this.writeColor(_loc9_,_loc8_,false);
                     }
                     else
                     {
                        _loc9_.writeBoolean(false);
                     }
                     _loc8_ = param1.getAttribute("fillMethod");
                     this.writeFillMethod(_loc9_,_loc8_);
                     if(_loc8_ && _loc8_ != "none")
                     {
                        _loc9_.writeByte(param1.getAttributeInt("fillOrigin"));
                        _loc9_.writeBoolean(param1.getAttributeBool("fillClockwise",true));
                        _loc9_.writeFloat(param1.getAttributeInt("fillAmount",100) / 100);
                     }
                  }
               }
               else
               {
                  _loc8_ = param1.getAttribute("type");
                  if(_loc8_ == "rect")
                  {
                     _loc9_.writeByte(1);
                  }
                  else if(_loc8_ == "eclipse")
                  {
                     _loc9_.writeByte(2);
                  }
                  else
                  {
                     _loc9_.writeByte(0);
                  }
                  _loc9_.writeInt(param1.getAttributeInt("lineSize",1));
                  this.writeColor(_loc9_,param1.getAttribute("lineColor"));
                  this.writeColor(_loc9_,param1.getAttribute("fillColor"),true,4294967295);
                  _loc8_ = param1.getAttribute("corner","");
                  if(_loc8_)
                  {
                     _loc9_.writeBoolean(true);
                     _loc28_ = _loc8_.split(",");
                     _loc27_ = parseInt(_loc28_[0]);
                     _loc9_.writeFloat(_loc27_);
                     if(_loc28_[1])
                     {
                        _loc9_.writeFloat(parseInt(_loc28_[1]));
                     }
                     else
                     {
                        _loc9_.writeFloat(_loc27_);
                     }
                     if(_loc28_[2])
                     {
                        _loc9_.writeFloat(parseInt(_loc28_[2]));
                     }
                     else
                     {
                        _loc9_.writeFloat(_loc27_);
                     }
                     if(_loc28_[3])
                     {
                        _loc9_.writeFloat(parseInt(_loc28_[3]));
                     }
                     else
                     {
                        _loc9_.writeFloat(_loc27_);
                     }
                  }
                  else
                  {
                     _loc9_.writeBoolean(false);
                  }
               }
            }
            else
            {
               _loc8_ = param1.getAttribute("color");
               if(_loc8_)
               {
                  _loc9_.writeBoolean(true);
                  this.writeColor(_loc9_,_loc8_,false);
               }
               else
               {
                  _loc9_.writeBoolean(false);
               }
               _loc9_.writeByte(0);
               _loc9_.writeInt(param1.getAttributeInt("frame"));
               _loc9_.writeBoolean(param1.getAttributeBool("playing",true));
            }
         }
         else
         {
            _loc8_ = param1.getAttribute("color");
            if(_loc8_)
            {
               _loc9_.writeBoolean(true);
               this.writeColor(_loc9_,_loc8_,false);
            }
            else
            {
               _loc9_.writeBoolean(false);
            }
            _loc8_ = param1.getAttribute("flip");
            _loc32_ = _loc8_;
            if("both" !== _loc32_)
            {
               if("hz" !== _loc32_)
               {
                  if("vt" !== _loc32_)
                  {
                     _loc9_.writeByte(0);
                  }
                  else
                  {
                     _loc9_.writeByte(2);
                  }
               }
               else
               {
                  _loc9_.writeByte(1);
               }
            }
            else
            {
               _loc9_.writeByte(3);
            }
            _loc8_ = param1.getAttribute("fillMethod");
            this.writeFillMethod(_loc9_,_loc8_);
            if(_loc8_ && _loc8_ != "none")
            {
               _loc9_.writeByte(param1.getAttributeInt("fillOrigin"));
               _loc9_.writeBoolean(param1.getAttributeBool("fillClockwise",true));
               _loc9_.writeFloat(param1.getAttributeInt("fillAmount",100) / 100);
            }
         }
         this.writeSegmentPos(_loc9_,6);
         _loc32_ = _loc2_;
         if("text" !== _loc32_)
         {
            if("richtext" !== _loc32_)
            {
               if("component" !== _loc32_)
               {
                  if("list" === _loc32_)
                  {
                     _loc8_ = param1.getAttribute("selectionController");
                     if(_loc8_)
                     {
                        _loc10_ = this.controllerCache[_loc8_];
                        if(_loc10_ != undefined)
                        {
                           _loc9_.writeShort(_loc10_);
                        }
                        else
                        {
                           _loc9_.writeShort(-1);
                        }
                     }
                     else
                     {
                        _loc9_.writeShort(-1);
                     }
                  }
               }
               else
               {
                  _loc12_ = param1.getChildren();
                  var _loc36_:int = 0;
                  var _loc35_:* = _loc12_;
                  for each(_loc4_ in _loc12_)
                  {
                     _loc33_ = _loc4_.getName();
                     if("Label" !== _loc33_)
                     {
                        if("Button" !== _loc33_)
                        {
                           if("ComboBox" !== _loc33_)
                           {
                              if("ProgressBar" !== _loc33_)
                              {
                                 if("Slider" !== _loc33_)
                                 {
                                    if("ScrollBar" !== _loc33_)
                                    {
                                       if("Tree" === _loc33_)
                                       {
                                          _loc9_.writeByte(17);
                                       }
                                    }
                                    else
                                    {
                                       _loc9_.writeByte(16);
                                    }
                                 }
                                 else
                                 {
                                    _loc9_.writeByte(15);
                                    _loc9_.writeInt(_loc4_.getAttributeInt("value"));
                                    _loc9_.writeInt(_loc4_.getAttributeInt("max",100));
                                 }
                              }
                              else
                              {
                                 _loc9_.writeByte(14);
                                 _loc9_.writeInt(_loc4_.getAttributeInt("value"));
                                 _loc9_.writeInt(_loc4_.getAttributeInt("max",100));
                              }
                           }
                           else
                           {
                              _loc9_.writeByte(13);
                              _loc21_ = _loc9_.position;
                              _loc9_.writeShort(0);
                              _loc25_ = _loc4_.getEnumerator("item");
                              _loc30_ = 0;
                              while(_loc25_.moveNext())
                              {
                                 _loc30_++;
                                 _loc7_ = _loc25_.current;
                                 _loc24_ = new ByteArray();
                                 this.writeString(_loc24_,_loc7_.getAttribute("title"),true,false);
                                 this.writeString(_loc24_,_loc7_.getAttribute("value"),false,false);
                                 this.writeString(_loc24_,_loc7_.getAttribute("icon"));
                                 _loc9_.writeShort(_loc24_.length);
                                 _loc9_.writeBytes(_loc24_);
                                 _loc24_.clear();
                              }
                              this.writeCount(_loc9_,_loc21_,_loc30_);
                              this.writeString(_loc9_,_loc4_.getAttribute("title"),true);
                              this.writeString(_loc9_,_loc4_.getAttribute("icon"));
                              _loc8_ = _loc4_.getAttribute("titleColor");
                              if(_loc8_)
                              {
                                 _loc9_.writeBoolean(true);
                                 this.writeColor(_loc9_,_loc8_);
                              }
                              else
                              {
                                 _loc9_.writeBoolean(false);
                              }
                              _loc9_.writeInt(_loc4_.getAttributeInt("visibleItemCount"));
                              _loc8_ = _loc4_.getAttribute("direction");
                              _loc34_ = _loc8_;
                              if("down" !== _loc34_)
                              {
                                 if("up" !== _loc34_)
                                 {
                                    _loc9_.writeByte(0);
                                 }
                                 else
                                 {
                                    _loc9_.writeByte(1);
                                 }
                              }
                              else
                              {
                                 _loc9_.writeByte(2);
                              }
                              _loc8_ = _loc4_.getAttribute("selectionController");
                              if(_loc8_)
                              {
                                 _loc10_ = this.controllerCache[_loc8_];
                                 if(_loc10_ != undefined)
                                 {
                                    _loc9_.writeShort(_loc10_);
                                 }
                                 else
                                 {
                                    _loc9_.writeShort(-1);
                                 }
                              }
                              else
                              {
                                 _loc9_.writeShort(-1);
                              }
                           }
                        }
                        else
                        {
                           _loc9_.writeByte(12);
                           this.writeString(_loc9_,_loc4_.getAttribute("title"),true);
                           this.writeString(_loc9_,_loc4_.getAttribute("selectedTitle"),true);
                           this.writeString(_loc9_,_loc4_.getAttribute("icon"));
                           this.writeString(_loc9_,_loc4_.getAttribute("selectedIcon"));
                           _loc8_ = _loc4_.getAttribute("titleColor");
                           if(_loc8_)
                           {
                              _loc9_.writeBoolean(true);
                              this.writeColor(_loc9_,_loc8_);
                           }
                           else
                           {
                              _loc9_.writeBoolean(false);
                           }
                           _loc9_.writeInt(_loc4_.getAttributeInt("titleFontSize"));
                           _loc8_ = _loc4_.getAttribute("controller");
                           if(_loc8_)
                           {
                              _loc10_ = this.controllerCache[_loc8_];
                              if(_loc10_ != undefined)
                              {
                                 _loc9_.writeShort(_loc10_);
                              }
                              else
                              {
                                 _loc9_.writeShort(-1);
                              }
                           }
                           else
                           {
                              _loc9_.writeShort(-1);
                           }
                           this.writeString(_loc9_,_loc4_.getAttribute("page"));
                           this.writeString(_loc9_,_loc4_.getAttribute("sound"),false,false);
                           _loc8_ = _loc4_.getAttribute("volume");
                           if(_loc8_)
                           {
                              _loc9_.writeBoolean(true);
                              _loc9_.writeFloat(parseInt(_loc8_) / 100);
                           }
                           else
                           {
                              _loc9_.writeBoolean(false);
                           }
                           _loc9_.writeBoolean(_loc4_.getAttributeBool("checked"));
                        }
                     }
                     else
                     {
                        _loc9_.writeByte(11);
                        this.writeString(_loc9_,_loc4_.getAttribute("title"),true);
                        this.writeString(_loc9_,_loc4_.getAttribute("icon"));
                        _loc8_ = _loc4_.getAttribute("titleColor");
                        if(_loc8_)
                        {
                           _loc9_.writeBoolean(true);
                           this.writeColor(_loc9_,_loc8_);
                        }
                        else
                        {
                           _loc9_.writeBoolean(false);
                        }
                        _loc9_.writeInt(_loc4_.getAttributeInt("titleFontSize"));
                        _loc23_ = _loc4_.getAttribute("prompt");
                        _loc31_ = _loc4_.getAttribute("restrict");
                        _loc15_ = _loc4_.getAttributeInt("maxLength");
                        _loc6_ = _loc4_.getAttributeInt("keyboardType");
                        _loc26_ = _loc4_.getAttributeBool("password");
                        if(_loc23_ || _loc31_ || _loc15_ || _loc6_ || _loc26_)
                        {
                           _loc9_.writeBoolean(true);
                           this.writeString(_loc9_,_loc23_,true);
                           this.writeString(_loc9_,_loc31_);
                           _loc9_.writeInt(_loc15_);
                           _loc9_.writeInt(_loc6_);
                           _loc9_.writeBoolean(_loc26_);
                        }
                        else
                        {
                           _loc9_.writeBoolean(false);
                        }
                     }
                  }
               }
            }
            addr2511:
            if(_loc2_ == "list")
            {
               if(param1.getAttribute("overflow") == "scroll")
               {
                  this.writeSegmentPos(_loc9_,7);
                  _loc24_ = this.encodeScrollPane(param1);
                  _loc9_.writeBytes(_loc24_);
                  _loc24_.clear();
               }
               this.writeSegmentPos(_loc9_,8);
               this.writeString(_loc9_,param1.getAttribute("defaultItem"));
               _loc21_ = _loc9_.position;
               _loc9_.writeShort(0);
               _loc25_ = param1.getEnumerator("item");
               _loc30_ = 0;
               while(_loc25_.moveNext())
               {
                  _loc30_++;
                  _loc4_ = _loc25_.current;
                  _loc24_ = new ByteArray();
                  this.writeString(_loc24_,_loc4_.getAttribute("url"));
                  this.writeString(_loc24_,_loc4_.getAttribute("title"),true);
                  this.writeString(_loc24_,_loc4_.getAttribute("selectedTitle"),true);
                  this.writeString(_loc24_,_loc4_.getAttribute("icon"));
                  this.writeString(_loc24_,_loc4_.getAttribute("selectedIcon"));
                  this.writeString(_loc24_,_loc4_.getAttribute("name"));
                  _loc8_ = _loc4_.getAttribute("controllers");
                  if(_loc8_)
                  {
                     _loc28_ = _loc8_.split(",");
                     _loc24_.writeShort(_loc28_.length / 2);
                     _loc11_ = 0;
                     while(_loc11_ < _loc28_.length)
                     {
                        this.writeString(_loc24_,_loc28_[_loc11_]);
                        this.writeString(_loc24_,_loc28_[_loc11_ + 1]);
                        _loc11_ = _loc11_ + 2;
                     }
                  }
                  else
                  {
                     _loc24_.writeShort(0);
                  }
                  _loc9_.writeShort(_loc24_.length);
                  _loc9_.writeBytes(_loc24_);
                  _loc24_.clear();
               }
               this.writeCount(_loc9_,_loc21_,_loc30_);
            }
            return _loc9_;
         }
         this.writeString(_loc9_,param1.getAttribute("text"),true);
         if(param1.getAttributeBool("input"))
         {
            _loc9_.writeBoolean(true);
            this.writeString(_loc9_,param1.getAttribute("prompt"),true);
            this.writeString(_loc9_,param1.getAttribute("restrict"));
            _loc9_.writeInt(param1.getAttributeInt("maxLength"));
            _loc9_.writeInt(param1.getAttributeInt("keyboardType"));
            _loc9_.writeBoolean(param1.getAttributeBool("password"));
         }
         else
         {
            _loc9_.writeBoolean(false);
         }
         §§goto(addr2511);
      }
      
      private function encodeGear(param1:int, param2:XData) : ByteArray
      {
         var _loc8_:* = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc3_:* = 0;
         var _loc6_:int = 0;
         var _loc10_:int = 0;
         var _loc9_:* = undefined;
         var _loc5_:Array = null;
         var _loc7_:Array = null;
         var _loc4_:Object = null;
         _loc11_ = param2.getAttribute("controller");
         if(_loc11_)
         {
            _loc9_ = this.controllerCache[_loc11_];
            if(_loc9_ == undefined)
            {
               return null;
            }
            _loc8_ = new ByteArray();
            _loc8_.writeShort(_loc9_);
            if(param1 == 0)
            {
               _loc11_ = param2.getAttribute("pages");
               if(_loc11_)
               {
                  _loc12_ = _loc11_.split(",");
                  _loc3_ = _loc12_.length;
                  if(_loc3_ == 0)
                  {
                     return null;
                  }
                  _loc8_.writeShort(_loc3_);
                  _loc6_ = 0;
                  while(_loc6_ < _loc3_)
                  {
                     this.writeString(_loc8_,_loc12_[_loc6_],false,false);
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
               _loc11_ = param2.getAttribute("pages");
               if(_loc11_)
               {
                  _loc5_ = _loc11_.split(",");
               }
               else
               {
                  _loc5_ = [];
               }
               _loc11_ = param2.getAttribute("values");
               if(_loc11_)
               {
                  _loc7_ = _loc11_.split("|");
               }
               else
               {
                  _loc7_ = [];
               }
               _loc3_ = _loc5_.length;
               _loc8_.writeShort(_loc3_);
               _loc6_ = 0;
               while(_loc6_ < _loc3_)
               {
                  _loc11_ = _loc7_[_loc6_];
                  if(param1 != 6 && param1 != 7 && (!_loc11_ || _loc11_ == "-"))
                  {
                     this.writeString(_loc8_,null);
                  }
                  else
                  {
                     this.writeString(_loc8_,_loc5_[_loc6_],false,false);
                     this.writeGearValue(param1,_loc11_,_loc8_);
                  }
                  _loc6_++;
               }
               _loc11_ = param2.getAttribute("default");
               if(_loc11_)
               {
                  _loc8_.writeBoolean(true);
                  this.writeGearValue(param1,_loc11_,_loc8_);
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
            return _loc8_;
         }
         return null;
      }
      
      private function writeGearValue(param1:int, param2:String, param3:ByteArray) : void
      {
         var _loc4_:Array = null;
         switch(int(param1) - 1)
         {
            case 0:
               _loc4_ = param2.split(",");
               param3.writeInt(parseInt(_loc4_[0]));
               param3.writeInt(parseInt(_loc4_[1]));
               break;
            case 1:
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
            case 2:
               _loc4_ = param2.split(",");
               param3.writeFloat(parseFloat(_loc4_[0]));
               param3.writeFloat(parseFloat(_loc4_[1]));
               param3.writeBoolean(_loc4_[2] == "1");
               param3.writeBoolean(_loc4_.length < 4 || _loc4_[3] == "1");
               break;
            case 3:
               _loc4_ = param2.split(",");
               if(_loc4_.length < 2)
               {
                  this.writeColor(param3,_loc4_[0]);
                  this.writeColor(param3,"#000000");
               }
               else
               {
                  this.writeColor(param3,_loc4_[0]);
                  this.writeColor(param3,_loc4_[1]);
               }
               break;
            case 4:
               _loc4_ = param2.split(",");
               param3.writeBoolean(_loc4_[1] == "p");
               param3.writeInt(parseInt(_loc4_[0]));
               break;
            case 5:
               this.writeString(param3,param2,true);
               break;
            case 6:
               this.writeString(param3,param2);
         }
      }
      
      private function addMovieClip(param1:String, param2:XML) : ByteArray
      {
         var _loc3_:String = null;
         var _loc5_:Array = null;
         var _loc9_:ByteArray = null;
         var _loc4_:XData = null;
         var _loc6_:* = 0;
         var _loc10_:XData = XData.attach(param2);
         var _loc11_:ByteArray = new ByteArray();
         this.startSegments(_loc11_,2,false);
         this.writeSegmentPos(_loc11_,0);
         _loc11_.writeInt(_loc10_.getAttributeInt("interval"));
         _loc11_.writeBoolean(_loc10_.getAttributeBool("swing"));
         _loc11_.writeInt(_loc10_.getAttributeInt("repeatDelay"));
         this.writeSegmentPos(_loc11_,1);
         var _loc8_:XDataEnumerator = _loc10_.getChild("frames").getEnumerator("frame");
         _loc11_.writeShort(_loc10_.getAttributeInt("frameCount"));
         var _loc7_:int = 0;
         while(_loc8_.moveNext())
         {
            _loc4_ = _loc8_.current;
            _loc3_ = _loc4_.getAttribute("rect");
            _loc3_ = LayaExporter.floor_scaseScale9grid(_loc3_);
            _loc5_ = _loc3_.split(",");
            _loc9_ = new ByteArray();
            _loc9_.writeInt(parseInt(_loc5_[0]));
            _loc9_.writeInt(parseInt(_loc5_[1]));
            _loc6_ = parseInt(_loc5_[2]);
            _loc9_.writeInt(_loc6_);
            _loc9_.writeInt(parseInt(_loc5_[3]));
            _loc9_.writeInt(_loc4_.getAttributeInt("addDelay"));
            _loc3_ = _loc4_.getAttribute("sprite");
            if(_loc3_)
            {
               this.writeString(_loc9_,param1 + "_" + _loc3_);
            }
            else if(_loc6_)
            {
               this.writeString(_loc9_,param1 + "_" + _loc7_);
            }
            else
            {
               this.writeString(_loc9_,null);
            }
            _loc11_.writeShort(_loc9_.length);
            _loc11_.writeBytes(_loc9_);
            _loc9_.clear();
            _loc7_++;
         }
         return _loc11_;
      }
      
      private function addFont(param1:String, param2:String) : ByteArray
      {
         var _loc9_:* = null;
         var _loc27_:int = 0;
         var _loc12_:Object = null;
         var _loc7_:* = 0;
         var _loc18_:* = 0;
         var _loc13_:* = 0;
         var _loc20_:* = 0;
         var _loc28_:* = 0;
         var _loc14_:* = 0;
         var _loc6_:String = null;
         var _loc23_:Array = null;
         var _loc8_:int = 0;
         var _loc22_:Array = null;
         var _loc4_:String = null;
         var _loc19_:* = 0;
         var _loc21_:ByteArray = new ByteArray();
         var _loc25_:Array = param2.split("\n");
         var _loc11_:int = _loc25_.length;
         var _loc26_:* = false;
         var _loc16_:* = false;
         var _loc3_:* = false;
         var _loc17_:Boolean = false;
         var _loc5_:* = 0;
         var _loc15_:* = 0;
         var _loc10_:* = 0;
         var _loc24_:int = 0;
         _loc27_ = 0;
         for(; _loc27_ < _loc11_; _loc27_++)
         {
            _loc6_ = _loc25_[_loc27_];
            if(_loc6_)
            {
               _loc6_ = UtilsStr.trim(_loc6_);
               _loc23_ = _loc6_.split(" ");
               _loc12_ = {};
               _loc8_ = 1;
               while(_loc8_ < _loc23_.length)
               {
                  _loc22_ = _loc23_[_loc8_].split("=");
                  _loc12_[_loc22_[0]] = _loc22_[1];
                  _loc8_++;
               }
               _loc6_ = _loc23_[0];
               if(_loc6_ == "char")
               {
                  _loc4_ = _loc12_["img"];
                  if(!_loc26_)
                  {
                     if(!_loc4_)
                     {
                     }
                     continue;
                  }
                  _loc19_ = _loc12_["id"];
                  if(_loc19_ != 0)
                  {
                     _loc7_ = _loc12_["xoffset"];
                     _loc18_ = _loc12_["yoffset"];
                     _loc13_ = _loc12_["width"];
                     _loc20_ = _loc12_["height"];
                     _loc28_ = _loc12_["xadvance"];
                     _loc14_ = _loc12_["chnl"];
                     if(_loc14_ != 0 && _loc14_ != 15)
                     {
                        _loc17_ = true;
                     }
                     _loc9_ = new ByteArray();
                     _loc9_.writeShort(_loc19_);
                     this.writeString(_loc9_,_loc4_);
                     _loc9_.writeInt(_loc12_["x"]);
                     _loc9_.writeInt(_loc12_["y"]);
                     _loc9_.writeInt(_loc7_);
                     _loc9_.writeInt(_loc18_);
                     _loc9_.writeInt(_loc13_);
                     _loc9_.writeInt(_loc20_);
                     _loc9_.writeInt(_loc28_);
                     _loc9_.writeByte(_loc14_);
                     _loc21_.writeShort(_loc9_.length);
                     _loc21_.writeBytes(_loc9_);
                     _loc9_.clear();
                     _loc24_++;
                  }
               }
               else if(_loc6_ == "info")
               {
                  _loc26_ = _loc12_.face != null;
                  _loc16_ = _loc26_;
                  _loc5_ = _loc12_.size;
                  _loc3_ = _loc12_.resizable == "true";
                  if(_loc12_.colored != undefined)
                  {
                     _loc16_ = _loc12_.colored == "true";
                  }
               }
               else if(_loc6_ == "common")
               {
                  _loc15_ = _loc12_.lineHeight;
                  _loc10_ = _loc12_.xadvance;
                  if(_loc5_ == 0)
                  {
                     _loc5_ = _loc15_;
                  }
                  else if(_loc15_ == 0)
                  {
                     _loc15_ = _loc5_;
                     continue;
                  }
                  continue;
               }
               continue;
            }
         }
         _loc9_ = _loc21_;
         _loc21_ = new ByteArray();
         this.startSegments(_loc21_,2,false);
         this.writeSegmentPos(_loc21_,0);
         _loc21_.writeBoolean(_loc26_);
         _loc21_.writeBoolean(_loc16_);
         _loc21_.writeBoolean(_loc5_ > 0?_loc3_:false);
         _loc21_.writeBoolean(_loc17_);
         _loc21_.writeInt(_loc5_);
         _loc21_.writeInt(_loc10_);
         _loc21_.writeInt(_loc15_);
         this.writeSegmentPos(_loc21_,1);
         _loc21_.writeInt(_loc24_);
         _loc21_.writeBytes(_loc9_);
         _loc9_.clear();
         return _loc21_;
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
            _loc5_ = this.stringMap[param2];
            if(_loc5_ != undefined)
            {
               param1.writeShort(int(_loc5_));
               return;
            }
         }
         this.stringTable.push(param2);
         if(!param3)
         {
            this.stringMap[param2] = this.stringTable.length - 1;
         }
         param1.writeShort(this.stringTable.length - 1);
      }
      
      private function writeColor(param1:ByteArray, param2:String, param3:Boolean = true, param4:uint = 4278190080) : void
      {
         var _loc5_:* = uint(0);
         if(param2)
         {
            _loc5_ = uint(ToolSet.convertFromHtmlColor(param2,param3));
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
      
      private function writeCount(param1:ByteArray, param2:int, param3:int) : void
      {
         var _loc4_:int = param1.position;
         param1.position = param2;
         param1.writeShort(param3);
         param1.position = _loc4_;
      }
      
      private function writeAlign(param1:ByteArray, param2:String) : void
      {
         var _loc3_:* = param2;
         if("left" !== _loc3_)
         {
            if("center" !== _loc3_)
            {
               if("right" !== _loc3_)
               {
                  param1.writeByte(0);
               }
               else
               {
                  param1.writeByte(2);
               }
            }
            else
            {
               param1.writeByte(1);
            }
         }
         else
         {
            param1.writeByte(0);
         }
      }
      
      private function writeVertAlign(param1:ByteArray, param2:String) : void
      {
         var _loc3_:* = param2;
         if("top" !== _loc3_)
         {
            if("middle" !== _loc3_)
            {
               if("bottom" !== _loc3_)
               {
                  param1.writeByte(0);
               }
               else
               {
                  param1.writeByte(2);
               }
            }
            else
            {
               param1.writeByte(1);
            }
         }
         else
         {
            param1.writeByte(0);
         }
      }
      
      private function writeFillMethod(param1:ByteArray, param2:String) : void
      {
         var _loc3_:* = param2;
         if("none" !== _loc3_)
         {
            if("hz" !== _loc3_)
            {
               if("vt" !== _loc3_)
               {
                  if("radial90" !== _loc3_)
                  {
                     if("radial180" !== _loc3_)
                     {
                        if("radial360" !== _loc3_)
                        {
                           param1.writeByte(0);
                        }
                        else
                        {
                           param1.writeByte(5);
                        }
                     }
                     else
                     {
                        param1.writeByte(4);
                     }
                  }
                  else
                  {
                     param1.writeByte(3);
                  }
               }
               else
               {
                  param1.writeByte(2);
               }
            }
            else
            {
               param1.writeByte(1);
            }
         }
         else
         {
            param1.writeByte(0);
         }
      }
      
      private function writeAutoSizeType(param1:ByteArray, param2:String) : void
      {
         var _loc3_:* = param2;
         if("none" !== _loc3_)
         {
            if("both" !== _loc3_)
            {
               if("height" !== _loc3_)
               {
                  if("shrink" !== _loc3_)
                  {
                     param1.writeByte(0);
                  }
                  else
                  {
                     param1.writeByte(3);
                  }
               }
               else
               {
                  param1.writeByte(2);
               }
            }
            else
            {
               param1.writeByte(1);
            }
         }
         else
         {
            param1.writeByte(0);
         }
      }
      
      private function writeTransitionActionType(param1:ByteArray, param2:String) : void
      {
         var _loc3_:* = param2;
         if("XY" !== _loc3_)
         {
            if("Size" !== _loc3_)
            {
               if("Scale" !== _loc3_)
               {
                  if("Pivot" !== _loc3_)
                  {
                     if("Alpha" !== _loc3_)
                     {
                        if("Rotation" !== _loc3_)
                        {
                           if("Color" !== _loc3_)
                           {
                              if("Animation" !== _loc3_)
                              {
                                 if("Visible" !== _loc3_)
                                 {
                                    if("Sound" !== _loc3_)
                                    {
                                       if("Transition" !== _loc3_)
                                       {
                                          if("Shake" !== _loc3_)
                                          {
                                             if("ColorFilter" !== _loc3_)
                                             {
                                                if("Skew" !== _loc3_)
                                                {
                                                   if("Text" !== _loc3_)
                                                   {
                                                      if("Icon" !== _loc3_)
                                                      {
                                                         param1.writeByte(16);
                                                      }
                                                      else
                                                      {
                                                         param1.writeByte(15);
                                                      }
                                                   }
                                                   else
                                                   {
                                                      param1.writeByte(14);
                                                   }
                                                }
                                                else
                                                {
                                                   param1.writeByte(13);
                                                }
                                             }
                                             else
                                             {
                                                param1.writeByte(12);
                                             }
                                          }
                                          else
                                          {
                                             param1.writeByte(11);
                                          }
                                       }
                                       else
                                       {
                                          param1.writeByte(10);
                                       }
                                    }
                                    else
                                    {
                                       param1.writeByte(9);
                                    }
                                 }
                                 else
                                 {
                                    param1.writeByte(8);
                                 }
                              }
                              else
                              {
                                 param1.writeByte(7);
                              }
                           }
                           else
                           {
                              param1.writeByte(6);
                           }
                        }
                        else
                        {
                           param1.writeByte(5);
                        }
                     }
                     else
                     {
                        param1.writeByte(4);
                     }
                  }
                  else
                  {
                     param1.writeByte(3);
                  }
               }
               else
               {
                  param1.writeByte(2);
               }
            }
            else
            {
               param1.writeByte(1);
            }
         }
         else
         {
            param1.writeByte(0);
         }
      }
      
      private function writeTransitionValue(param1:ByteArray, param2:String, param3:String) : void
      {
         helperValue.decode1(param2,param3);
         var _loc4_:* = param2;
         if("XY" !== _loc4_)
         {
            if("Size" !== _loc4_)
            {
               if("Pivot" !== _loc4_)
               {
                  if("Skew" !== _loc4_)
                  {
                     if("Alpha" !== _loc4_)
                     {
                        if("Rotation" !== _loc4_)
                        {
                           if("Scale" !== _loc4_)
                           {
                              if("Color" !== _loc4_)
                              {
                                 if("Animation" !== _loc4_)
                                 {
                                    if("Sound" !== _loc4_)
                                    {
                                       if("Transition" !== _loc4_)
                                       {
                                          if("Shake" !== _loc4_)
                                          {
                                             if("Visible" !== _loc4_)
                                             {
                                                if("ColorFilter" !== _loc4_)
                                                {
                                                   if("Text" !== _loc4_)
                                                   {
                                                      if("Icon" === _loc4_)
                                                      {
                                                         this.writeString(param1,helperValue.sText);
                                                      }
                                                   }
                                                   else
                                                   {
                                                      this.writeString(param1,helperValue.sText,true);
                                                   }
                                                }
                                                else
                                                {
                                                   param1.writeFloat(helperValue.filter_cb);
                                                   param1.writeFloat(helperValue.filter_cc);
                                                   param1.writeFloat(helperValue.filter_cs);
                                                   param1.writeFloat(helperValue.filter_ch);
                                                }
                                             }
                                             else
                                             {
                                                param1.writeBoolean(helperValue.visible);
                                             }
                                          }
                                          else
                                          {
                                             param1.writeFloat(helperValue.shakeAmplitude);
                                             param1.writeFloat(helperValue.shakePeriod);
                                          }
                                       }
                                       else
                                       {
                                          this.writeString(param1,helperValue.transName,false,false);
                                          param1.writeInt(helperValue.transTimes);
                                       }
                                    }
                                    else
                                    {
                                       this.writeString(param1,helperValue.sound,false,false);
                                       param1.writeFloat(helperValue.volume / 100);
                                    }
                                 }
                                 else
                                 {
                                    param1.writeBoolean(helperValue.playing);
                                    param1.writeInt(!!helperValue.aEnabled?helperValue.frame:-1);
                                    this.writeString(param1,helperValue.aniName,false,false);
                                 }
                              }
                              else
                              {
                                 param1.writeByte(helperValue.color >> 16 & 255);
                                 param1.writeByte(helperValue.color >> 8 & 255);
                                 param1.writeByte(helperValue.color & 255);
                                 param1.writeByte(255);
                              }
                           }
                           else
                           {
                              param1.writeFloat(helperValue.a);
                              param1.writeFloat(helperValue.b);
                           }
                        }
                        else
                        {
                           param1.writeFloat(helperValue.rotation);
                        }
                     }
                     else
                     {
                        param1.writeFloat(helperValue.alpha);
                     }
                  }
                  addr226:
                  return;
               }
               addr12:
               param1.writeBoolean(helperValue.aEnabled);
               param1.writeBoolean(helperValue.bEnabled);
               param1.writeFloat(helperValue.a);
               param1.writeFloat(helperValue.b);
               §§goto(addr226);
            }
            addr11:
            §§goto(addr12);
         }
         §§goto(addr11);
      }
   }
}

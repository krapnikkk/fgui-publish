package fairygui.editor.handlers
{
   import fairygui.editor.Consts;
   import fairygui.editor.gui.EPackageItem;
   import fairygui.editor.gui.EUIPackage;
   import fairygui.editor.gui.EUIProject;
   import fairygui.editor.utils.UtilsFile;
   import fairygui.editor.utils.UtilsStr;
   import flash.filesystem.File;
   import flash.system.System;
   
   public class StringsHandler
   {
       
      
      private var _result:Array;
      
      private var _refValues:Object;
      
      public function StringsHandler()
      {
         super();
      }
      
      public function exportStrings(param1:Vector.<EUIPackage>, param2:File, param3:Boolean) : void
      {
         var _loc4_:EUIPackage = null;
         var _loc5_:Vector.<EPackageItem> = null;
         var _loc8_:EPackageItem = null;
         var _loc7_:XML = null;
         var _loc6_:Object = null;
         if(param3 && param2.exists)
         {
            this.readRefs(param2);
         }
         this._result = [];
         var _loc9_:XML = <resources/>;
         var _loc15_:int = 0;
         var _loc14_:* = param1;
         for each(_loc4_ in param1)
         {
            _loc4_.ensureOpen();
            _loc5_ = _loc4_.resources.concat();
            _loc5_.sort(this.compareItem);
            var _loc13_:int = 0;
            var _loc12_:* = _loc5_;
            for each(_loc8_ in _loc5_)
            {
               if(_loc8_.type == "component")
               {
                  this._result.length = 0;
                  this.analyseItem(_loc8_);
                  if(this._result.length > 0)
                  {
                     XML.ignoreComments = false;
                     _loc7_ = new XML("<!-- " + _loc8_.owner.name + " - " + _loc8_.name + " -->");
                     _loc9_.appendChild(_loc7_);
                     XML.ignoreComments = true;
                     var _loc11_:int = 0;
                     var _loc10_:* = this._result;
                     for each(_loc6_ in this._result)
                     {
                        _loc7_ = <string/>;
                        _loc7_.@name = _loc6_.name;
                        _loc7_.@mz = _loc6_.mz;
                        _loc7_.appendChild(new XML(UtilsStr.encodeHTML(_loc6_.text)));
                        _loc9_.appendChild(_loc7_);
                     }
                     continue;
                  }
                  continue;
               }
            }
         }
         UtilsFile.saveXML(param2,_loc9_);
         System.disposeXML(_loc9_);
      }
      
      public function parseImport(param1:File, param2:EUIProject) : Vector.<String>
      {
         var _loc9_:XML = null;
         var _loc8_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc5_:EUIPackage = null;
         var _loc11_:Vector.<String> = new Vector.<String>();
         var _loc12_:XML = UtilsFile.loadXML(param1);
         var _loc3_:XMLList = _loc12_.string;
         var _loc4_:Object = {};
         var _loc10_:Vector.<String> = new Vector.<String>();
         var _loc14_:int = 0;
         var _loc13_:* = _loc3_;
         for each(_loc9_ in _loc3_)
         {
            _loc8_ = _loc9_.@name;
            _loc6_ = _loc8_.substr(0,8);
            _loc7_ = _loc4_[_loc6_];
            if(_loc7_ == 0)
            {
               _loc10_.push(_loc6_);
            }
            _loc7_++;
            _loc4_[_loc6_] = _loc7_;
         }
         var _loc16_:int = 0;
         var _loc15_:* = _loc10_;
         for each(_loc6_ in _loc10_)
         {
            _loc5_ = param2.getPackage(_loc6_);
            _loc11_.push(_loc5_.name + "(" + _loc4_[_loc6_] + ")");
         }
         return _loc11_;
      }
      
      public function importStrings(param1:File, param2:Vector.<String>, param3:EUIProject) : void
      {
         var _loc25_:XML = null;
         var _loc23_:XML = null;
         var _loc6_:* = null;
         var _loc27_:Object = null;
         var _loc17_:EUIPackage = null;
         var _loc16_:* = null;
         var _loc9_:Object = null;
         var _loc26_:EPackageItem = null;
         var _loc7_:XMLList = null;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc20_:int = 0;
         var _loc4_:String = null;
         var _loc19_:String = null;
         var _loc12_:String = null;
         var _loc5_:Object = null;
         var _loc24_:String = null;
         var _loc22_:XMLList = null;
         var _loc13_:int = 0;
         var _loc10_:* = param1;
         var _loc11_:* = param2;
         var _loc21_:* = param3;
         var _loc18_:XML = UtilsFile.loadXML(_loc10_);
         var _loc8_:Object = this.parseXML(_loc18_);
         var _loc35_:int = 0;
         var _loc34_:* = _loc8_;
         for(_loc6_ in _loc8_)
         {
            _loc27_ = _loc8_[_loc6_];
            _loc17_ = _loc21_.getPackage(_loc6_);
            var _loc33_:int = 0;
            var _loc32_:* = _loc27_;
            for(_loc16_ in _loc27_)
            {
               _loc9_ = _loc27_[_loc16_];
               _loc26_ = _loc17_.getItem(_loc16_);
               if(_loc26_ == null)
               {
                  _loc11_.push(Consts.g.text188 + " " + _loc16_);
                  return;
               }
               _loc18_ = _loc17_.getComponentXML(_loc26_,false);
               if(_loc18_ == null)
               {
                  _loc11_.push(Consts.g.text188 + " " + _loc26_.name);
                  return;
               }
               _loc7_ = _loc18_.displayList.elements();
               _loc14_ = _loc9_.length;
               _loc20_ = 0;
               while(_loc20_ < _loc14_)
               {
                  _loc4_ = _loc9_[_loc20_ + 1];
                  _loc19_ = _loc9_[_loc20_ + 2];
                  _loc12_ = _loc9_[_loc20_ + 3];
                  _loc15_ = false;
                  var _loc28_:* = _loc7_;
                  var _loc29_:int = 0;
                  var _loc31_:* = new XMLList("");
                  _loc5_ = _loc7_.(@id == _loc4_);
                  if(_loc5_.length() == 0)
                  {
                     _loc11_.push(Consts.g.text188 + " " + _loc9_[_loc20_] + " " + _loc12_);
                  }
                  else
                  {
                     _loc25_ = _loc5_[0];
                     _loc24_ = _loc25_.name().localName;
                     if(_loc19_ == "tips")
                     {
                        _loc25_.@tooltips = _loc12_;
                     }
                     else if(_loc19_ == "texts")
                     {
                        _loc23_ = _loc25_.gearText[0];
                        if(_loc25_.gearText[0] != null)
                        {
                           _loc23_.@values = _loc12_;
                        }
                     }
                     else if(_loc19_ == "texts_def")
                     {
                        _loc23_ = _loc25_.gearText[0];
                        if(_loc25_.gearText[0] != null)
                        {
                           _loc23_["default"] = _loc12_;
                        }
                     }
                     else
                     {
                        if(_loc24_ == "text" || _loc24_ == "richtext")
                        {
                           if(_loc19_ == "prompt")
                           {
                              _loc25_.@prompt = _loc12_;
                           }
                           else
                           {
                              _loc25_.@text = _loc12_;
                           }
                           _loc15_ = true;
                        }
                        else if(_loc24_ == "list")
                        {
                           _loc22_ = _loc25_.item;
                           _loc13_ = _loc19_;
                           if(_loc13_ < _loc22_.length())
                           {
                              _loc22_[_loc13_].@title = _loc12_;
                              _loc15_ = true;
                           }
                        }
                        else if(_loc24_ == "component")
                        {
                           _loc23_ = _loc25_.Button[0];
                           if(_loc25_.Button[0] != null)
                           {
                              if(_loc19_ == "0")
                              {
                                 _loc23_.@selectedTitle = _loc12_;
                              }
                              else
                              {
                                 _loc23_.@title = _loc12_;
                              }
                              _loc15_ = true;
                           }
                           else
                           {
                              _loc23_ = _loc25_.Label[0];
                              if(_loc25_.Label[0] != null)
                              {
                                 if(_loc19_ == "prompt")
                                 {
                                    _loc23_.@prompt = _loc12_;
                                 }
                                 else
                                 {
                                    _loc23_.@title = _loc12_;
                                 }
                                 _loc15_ = true;
                              }
                              else
                              {
                                 _loc23_ = _loc25_.ComboBox[0];
                                 if(_loc25_.ComboBox[0] != null)
                                 {
                                    if(!_loc19_)
                                    {
                                       _loc23_.@title = _loc12_;
                                       _loc15_ = true;
                                    }
                                    else
                                    {
                                       _loc22_ = _loc23_.item;
                                       _loc13_ = _loc19_;
                                       if(_loc13_ < _loc22_.length())
                                       {
                                          _loc22_[_loc13_].@title = _loc12_;
                                          _loc15_ = true;
                                       }
                                    }
                                 }
                              }
                           }
                        }
                        if(!_loc15_)
                        {
                           _loc11_.push(Consts.g.text188 + " " + _loc9_[_loc20_] + " " + _loc12_);
                        }
                     }
                  }
                  _loc20_ = _loc20_ + 4;
               }
               UtilsFile.saveXML(_loc26_.file,_loc18_);
               _loc26_.invalidate();
            }
         }
      }
      
      private function parseXML(param1:XML) : Object
      {
         var _loc7_:XML = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc13_:String = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc3_:Object = null;
         var _loc5_:Array = null;
         var _loc8_:XMLList = param1.string;
         var _loc6_:Object = {};
         var _loc15_:int = 0;
         var _loc14_:* = _loc8_;
         for each(_loc7_ in _loc8_)
         {
            _loc9_ = _loc7_.@name;
            _loc10_ = _loc7_.toString();
            _loc13_ = _loc9_.substr(0,8);
            _loc11_ = _loc9_.substr(8);
            _loc12_ = _loc11_.split("-");
            _loc11_ = _loc12_[0];
            _loc2_ = _loc12_[1];
            _loc4_ = _loc12_[2];
            _loc3_ = _loc6_[_loc13_];
            if(!_loc3_)
            {
               _loc3_ = {};
               _loc6_[_loc13_] = _loc3_;
            }
            _loc5_ = _loc3_[_loc11_];
            if(!_loc5_)
            {
               _loc5_ = [];
               _loc3_[_loc11_] = _loc5_;
            }
            _loc5_.push(_loc9_,_loc2_,_loc4_,_loc10_);
         }
         return _loc6_;
      }
      
      private function addResult(param1:EPackageItem, param2:String, param3:String, param4:String, param5:String) : void
      {
         var _loc7_:String = null;
         if(!this.validateText(param5))
         {
            return;
         }
         var _loc6_:Object = {};
         var _loc8_:String = param1.owner.id + param1.id + "-" + param2 + (!!param4?"-" + param4:"");
         _loc6_.name = _loc8_;
         _loc6_.mz = param3;
         if(this._refValues)
         {
            _loc7_ = this._refValues[_loc8_];
            if(_loc7_ != null)
            {
               param5 = _loc7_;
            }
         }
         _loc6_.text = param5;
         this._result.push(_loc6_);
      }
      
      private function analyseItem(param1:EPackageItem) : void
      {
         var _loc3_:Object = null;
         var _loc13_:XML = null;
         var _loc10_:XML = null;
         var _loc6_:XML = null;
         var _loc5_:XML = null;
         var _loc12_:String = null;
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc9_:XMLList = null;
         var _loc7_:int = 0;
         var _loc14_:* = param1;
         var _loc11_:File = _loc14_.file;
         if(!_loc11_.exists)
         {
            return;
         }
         var _loc8_:String = UtilsFile.loadString(_loc11_);
         try
         {
            _loc5_ = new XML(_loc8_);
         }
         catch(err:Error)
         {
            return;
         }
         _loc3_ = _loc5_.displayList.elements();
         var _loc22_:int = 0;
         var _loc21_:* = _loc3_;
         for each(_loc13_ in _loc3_)
         {
            _loc12_ = _loc13_.name().localName;
            _loc2_ = _loc13_.@id;
            _loc4_ = _loc13_.@name;
            this.addResult(_loc14_,_loc2_,_loc4_,"tips",_loc13_.@tooltips);
            if(_loc12_ == "text" || _loc12_ == "richtext")
            {
               this.addResult(_loc14_,_loc2_,_loc4_,null,_loc13_.@text);
               this.addResult(_loc14_,_loc2_,_loc4_,"prompt",_loc13_.@prompt);
            }
            else if(_loc12_ == "list")
            {
               _loc9_ = _loc13_.item;
               _loc7_ = 0;
               var _loc18_:int = 0;
               var _loc17_:* = _loc9_;
               for each(_loc6_ in _loc9_)
               {
                  this.addResult(_loc14_,_loc2_,_loc4_,"" + _loc7_,_loc6_.@title);
                  _loc7_++;
               }
            }
            else if(_loc12_ == "component")
            {
               _loc10_ = _loc13_.Button[0];
               if(_loc13_.Button[0] != null)
               {
                  this.addResult(_loc14_,_loc2_,_loc4_,null,_loc10_.@title);
                  this.addResult(_loc14_,_loc2_,_loc4_,"0",_loc10_.@selectedTitle);
               }
               else
               {
                  _loc10_ = _loc13_.Label[0];
                  if(_loc13_.Label[0] != null)
                  {
                     this.addResult(_loc14_,_loc2_,_loc4_,null,_loc10_.@title);
                     this.addResult(_loc14_,_loc2_,_loc4_,"prompt",_loc10_.@prompt);
                  }
                  else
                  {
                     _loc10_ = _loc13_.ComboBox[0];
                     if(_loc13_.ComboBox[0] != null)
                     {
                        this.addResult(_loc14_,_loc2_,_loc4_,null,_loc10_.@title);
                        _loc9_ = _loc10_.item;
                        _loc7_ = 0;
                        var _loc20_:int = 0;
                        var _loc19_:* = _loc9_;
                        for each(_loc6_ in _loc9_)
                        {
                           this.addResult(_loc14_,_loc2_,_loc4_,"" + _loc7_,_loc6_.@title);
                           _loc7_++;
                        }
                     }
                  }
               }
            }
            _loc10_ = _loc13_.gearText[0];
            if(_loc13_.gearText[0] != null)
            {
               _loc8_ = _loc10_.@values;
               this.addResult(_loc14_,_loc2_,_loc4_,"texts",_loc8_);
               _loc8_ = _loc10_["default"];
               this.addResult(_loc14_,_loc2_,_loc4_,"texts_def",_loc8_);
            }
         }
      }
      
      private function validateText(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            return false;
         }
         var _loc5_:int = param1.length;
         var _loc3_:Boolean = true;
         var _loc4_:int = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = param1.charCodeAt(_loc4_);
            if(_loc2_ >= 65)
            {
               _loc3_ = false;
            }
            _loc4_++;
         }
         return !_loc3_;
      }
      
      private function readRefs(param1:File) : void
      {
         var _loc4_:XML = null;
         var _loc2_:String = null;
         this._refValues = {};
         var _loc5_:XML = UtilsFile.loadXML(param1);
         var _loc3_:XMLList = _loc5_.string;
         var _loc7_:int = 0;
         var _loc6_:* = _loc3_;
         for each(_loc4_ in _loc3_)
         {
            _loc2_ = _loc4_.@name;
            this._refValues[_loc2_] = _loc4_.toString();
         }
         System.disposeXML(_loc5_);
      }
      
      private function compareItem(param1:EPackageItem, param2:EPackageItem) : int
      {
         return param1.sortKey.localeCompare(param2.sortKey);
      }
   }
}

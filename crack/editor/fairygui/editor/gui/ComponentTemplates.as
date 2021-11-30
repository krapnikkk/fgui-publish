package fairygui.editor.gui
{
   import fairygui.editor.utils.UtilsFile;
   import flash.geom.Point;
   
   public class ComponentTemplates
   {
       
      
      public function ComponentTemplates()
      {
         super();
      }
      
      public static function createNewLabel(param1:EUIPackage, param2:String, param3:int, param4:int, param5:String) : EPackageItem
      {
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         var _loc6_:EPackageItem = param1.createNewComponent(param2,param3,param4,param5,"Label");
         var _loc11_:XML = param1.getComponentXML(_loc6_);
         var _loc10_:XML = <displayList/>;
         _loc11_.appendChild(_loc10_);
         var _loc9_:int = 1;
         _loc7_ = <text/>;
         _loc9_++;
         _loc7_.@id = "n" + _loc9_;
         _loc7_.@name = "title";
         _loc7_.@xy = "0,0";
         _loc7_.@size = param3 + "," + param4;
         _loc7_.@fontSize = "12";
         _loc7_.@autoSize = "none";
         _loc7_.@align = "center";
         _loc7_.@vAlign = "middle";
         _loc7_.@singleLine = "true";
         _loc8_ = <relation/>;
         _loc8_.@target = "";
         _loc8_.@sidePair = "width,height";
         _loc7_.appendChild(_loc8_);
         _loc10_.appendChild(_loc7_);
         UtilsFile.saveXML(_loc6_.file,_loc11_);
         return _loc6_;
      }
      
      public static function createNewButton(param1:EUIPackage, param2:String, param3:String, param4:String, param5:Array, param6:Point, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean, param11:Boolean, param12:String) : EPackageItem
      {
         var _loc13_:XML = null;
         var _loc20_:XML = null;
         var _loc17_:XML = null;
         var _loc24_:XML = null;
         var _loc14_:int = 0;
         var _loc21_:int = 0;
         var _loc25_:int = 0;
         var _loc19_:int = 0;
         var _loc15_:String = null;
         var _loc23_:EPackageItem = null;
         var _loc16_:Array = null;
         if(param5 != null)
         {
            _loc25_ = 0;
            _loc19_ = 0;
            while(_loc19_ < 4)
            {
               _loc15_ = param5[_loc19_];
               if(!_loc15_)
               {
                  if(_loc19_ == 3 && param5[1])
                  {
                     param5[1].push(_loc19_);
                  }
                  else if(param5[0])
                  {
                     param5[0].push(_loc19_);
                  }
                  param5[_loc19_] = null;
               }
               else
               {
                  _loc23_ = param1.project.getItemByURL(_loc15_);
                  if(!_loc23_)
                  {
                     throw new Error("Resource not found \'" + _loc15_ + "\'");
                  }
                  _loc25_++;
                  param5[_loc19_] = [_loc23_,_loc19_];
               }
               _loc19_++;
            }
         }
         if(param6 == null)
         {
            if(param5 != null && param5[0])
            {
               _loc14_ = param5[0][0].width;
               _loc21_ = param5[0][0].height;
            }
         }
         else
         {
            _loc14_ = param6.x;
            _loc21_ = param6.y;
         }
         if(_loc14_ == 0)
         {
            _loc14_ = 100;
         }
         if(_loc21_ == 0)
         {
            _loc21_ = 20;
         }
         var _loc18_:EPackageItem = param1.createNewComponent(param2,_loc14_,_loc21_,param12,param3,null,param11);
         _loc13_ = param1.getComponentXML(_loc18_);
         _loc20_ = <controller/>;
         _loc20_.@name = "button";
         _loc20_.@pages = "0,up,1,down,2,over,3,selectedOver";
         _loc13_.appendChild(_loc20_);
         _loc20_ = <displayList/>;
         _loc13_.appendChild(_loc20_);
         var _loc22_:int = 1;
         if(param5 != null && _loc25_ > 0)
         {
            _loc19_ = 0;
            while(_loc19_ < 4)
            {
               _loc16_ = param5[_loc19_];
               if(_loc16_)
               {
                  _loc23_ = _loc16_[0];
                  _loc17_ = new XML("<" + _loc23_.type + "/>");
                  _loc22_++;
                  _loc17_.@id = "n" + _loc22_;
                  if(_loc23_.owner != param1)
                  {
                     _loc17_.@pkg = _loc23_.owner.id;
                  }
                  _loc17_.@src = _loc23_.id;
                  _loc17_.@name = _loc17_.@id;
                  _loc17_.@xy = int((_loc14_ - _loc23_.width) / 2) + "," + int((_loc21_ - _loc23_.height) / 2);
                  if(_loc25_ > 1)
                  {
                     _loc24_ = <gearDisplay/>;
                     _loc24_.@controller = "button";
                     _loc24_.@pages = _loc16_.slice(1).join(",");
                     _loc17_.appendChild(_loc24_);
                  }
                  if(param8)
                  {
                     _loc24_ = <relation/>;
                     _loc24_.@target = "";
                     _loc24_.@sidePair = "width,height";
                     _loc17_.appendChild(_loc24_);
                  }
                  _loc20_.appendChild(_loc17_);
               }
               _loc19_++;
            }
         }
         else
         {
            if(!param7)
            {
               _loc17_ = <graph/>;
               _loc22_++;
               _loc17_.@id = "n" + _loc22_;
               _loc17_.@name = _loc17_.@id;
               _loc17_.@xy = "0,0";
               _loc17_.@size = _loc14_ + "," + _loc21_;
               _loc17_.@type = "rect";
               _loc17_.@lineSize = 0;
               _loc17_.@fillColor = "#F0F0F0";
               _loc17_.@touchable = "false";
               _loc24_ = <gearDisplay/>;
               _loc24_.@controller = "button";
               _loc24_.@pages = "0";
               _loc17_.appendChild(_loc24_);
               _loc24_ = <relation/>;
               _loc24_.@target = "";
               _loc24_.@sidePair = "width,height";
               _loc17_.appendChild(_loc24_);
               _loc20_.appendChild(_loc17_);
            }
            _loc17_ = <graph/>;
            _loc22_++;
            _loc17_.@id = "n" + _loc22_;
            _loc17_.@name = _loc17_.@id;
            _loc17_.@xy = "0,0";
            _loc17_.@size = _loc14_ + "," + _loc21_;
            _loc17_.@type = "rect";
            _loc17_.@lineSize = 0;
            if(param7)
            {
               _loc17_.@fillColor = "#3399FF";
            }
            else
            {
               _loc17_.@fillColor = "#FAFAFA";
            }
            _loc17_.@touchable = "false";
            _loc24_ = <gearDisplay/>;
            _loc24_.@controller = "button";
            _loc24_.@pages = "2";
            _loc17_.appendChild(_loc24_);
            _loc24_ = <relation/>;
            _loc24_.@target = "";
            _loc24_.@sidePair = "width,height";
            _loc17_.appendChild(_loc24_);
            _loc20_.appendChild(_loc17_);
            _loc17_ = <graph/>;
            _loc22_++;
            _loc17_.@id = "n" + _loc22_;
            _loc17_.@name = _loc17_.@id;
            _loc17_.@xy = "0,0";
            _loc17_.@size = _loc14_ + "," + _loc21_;
            _loc17_.@type = "rect";
            _loc17_.@lineSize = 0;
            _loc17_.@fillColor = "#CCCCCC";
            _loc17_.@touchable = "false";
            _loc24_ = <gearDisplay/>;
            _loc24_.@controller = "button";
            _loc24_.@pages = "1,3";
            _loc17_.appendChild(_loc24_);
            _loc24_ = <relation/>;
            _loc24_.@target = "";
            _loc24_.@sidePair = "width,height";
            _loc17_.appendChild(_loc24_);
            _loc20_.appendChild(_loc17_);
         }
         if(param9)
         {
            _loc17_ = <text/>;
            _loc22_++;
            _loc17_.@id = "n" + _loc22_;
            _loc17_.@name = "title";
            _loc17_.@xy = "0,0";
            _loc17_.@size = _loc14_ + "," + _loc21_;
            _loc17_.@fontSize = "12";
            _loc17_.@autoSize = "none";
            _loc17_.@align = "center";
            _loc17_.@vAlign = "middle";
            _loc17_.@singleLine = "true";
            _loc24_ = <relation/>;
            _loc24_.@target = "";
            _loc24_.@sidePair = "width,height";
            _loc17_.appendChild(_loc24_);
            _loc20_.appendChild(_loc17_);
         }
         if(param10)
         {
            _loc17_ = <loader/>;
            _loc22_++;
            _loc17_.@id = "n" + _loc22_;
            _loc17_.@name = "icon";
            _loc17_.@xy = "0,0";
            _loc17_.@size = _loc14_ + "," + _loc21_;
            _loc17_.@align = "center";
            _loc17_.@vAlign = "middle";
            _loc24_ = <relation/>;
            _loc24_.@target = "";
            _loc24_.@sidePair = "width,height";
            _loc17_.appendChild(_loc24_);
            _loc20_.appendChild(_loc17_);
         }
         if(param4 != null && param4 != "Common")
         {
            _loc20_ = _loc13_[param3][0];
            _loc20_.@mode = param4;
         }
         UtilsFile.saveXML(_loc18_.file,_loc13_);
         return _loc18_;
      }
      
      public static function createNewComboBox(param1:EUIPackage, param2:String, param3:Array, param4:String, param5:Array, param6:String) : EPackageItem
      {
         var _loc18_:XML = null;
         var _loc16_:XML = null;
         var _loc17_:XML = null;
         var _loc8_:XML = null;
         var _loc9_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:EPackageItem = null;
         var _loc10_:EPackageItem = createNewButton(param1,param2 + "_item","Button","Radio",param5,null,true,true,true,false,false,param6);
         _loc18_ = param1.getComponentXML(_loc10_);
         _loc17_ = _loc18_.displayList[0].text[0];
         delete _loc17_.@align;
         UtilsFile.saveXML(_loc10_.file,_loc18_);
         _loc9_ = 150;
         _loc11_ = 200;
         var _loc7_:EPackageItem = param1.createNewComponent(param2 + "_popup",_loc9_,_loc11_,param6);
         _loc18_ = param1.getComponentXML(_loc7_);
         _loc16_ = <displayList/>;
         _loc18_.appendChild(_loc16_);
         var _loc14_:int = 1;
         if(param4)
         {
            _loc12_ = param1.project.getItemByURL(param4);
            if(!_loc12_)
            {
               throw new Error("Resource not found \'" + param4 + "\'");
            }
            _loc17_ = new XML("<" + _loc12_.type + "/>");
            _loc14_++;
            _loc17_.@id = "n" + _loc14_;
            if(_loc12_.owner != param1)
            {
               _loc17_.@pkg = _loc12_.owner.id;
            }
            _loc17_.@src = _loc12_.id;
            _loc17_.@name = _loc17_.@id;
            _loc17_.@xy = "0,0";
            _loc17_.@size = _loc9_ + "," + _loc11_;
            _loc8_ = <relation/>;
            _loc8_.@target = "";
            _loc8_.@sidePair = "width,height";
            _loc17_.appendChild(_loc8_);
            _loc16_.appendChild(_loc17_);
         }
         else
         {
            _loc17_ = <graph/>;
            _loc14_++;
            _loc17_.@id = "n" + _loc14_;
            _loc17_.@name = _loc17_.@id;
            _loc17_.@xy = "0,0";
            _loc17_.@size = _loc9_ + "," + _loc11_;
            _loc17_.@type = "rect";
            _loc17_.@lineSize = 1;
            _loc17_.@lineColor = "#A0A0A0";
            _loc17_.@fillColor = "#F0F0F0";
            _loc17_.@touchable = "false";
            _loc8_ = <relation/>;
            _loc8_.@target = "";
            _loc8_.@sidePair = "width,height";
            _loc17_.appendChild(_loc8_);
            _loc16_.appendChild(_loc17_);
         }
         _loc17_ = <list/>;
         _loc14_++;
         var _loc15_:String = "n" + _loc14_;
         _loc17_.@id = _loc15_;
         _loc17_.@name = "list";
         _loc17_.@xy = "0,0";
         _loc17_.@size = _loc9_ + "," + _loc11_;
         _loc17_.@overflow = "scroll";
         _loc17_.@defaultItem = "ui://" + _loc10_.owner.id + _loc10_.id;
         _loc8_ = <relation/>;
         _loc8_.@target = "";
         _loc8_.@sidePair = "width";
         _loc17_.appendChild(_loc8_);
         _loc16_.appendChild(_loc17_);
         _loc16_ = <relation/>;
         _loc16_.@target = _loc15_;
         _loc16_.@sidePair = "height";
         _loc18_.appendChild(_loc16_);
         UtilsFile.saveXML(_loc7_.file,_loc18_);
         var _loc13_:EPackageItem = createNewButton(param1,param2,"ComboBox",null,param3,null,false,true,true,false,true,param6);
         _loc18_ = param1.getComponentXML(_loc13_);
         _loc9_ = _loc13_.width;
         _loc11_ = _loc13_.height;
         _loc17_ = _loc18_.displayList[0].text[0];
         _loc17_.@size = _loc9_ - 20 + "," + _loc11_;
         delete _loc17_.@align;
         _loc16_ = _loc18_.ComboBox[0];
         _loc16_.@dropdown = "ui://" + _loc7_.owner.id + _loc7_.id;
         UtilsFile.saveXML(_loc13_.file,_loc18_);
         return _loc13_;
      }
      
      public static function createNewScrollBar(param1:EUIPackage, param2:String, param3:int, param4:Boolean, param5:Array, param6:Array, param7:String, param8:Array, param9:String) : EPackageItem
      {
         var _loc11_:XML = null;
         var _loc13_:XML = null;
         var _loc12_:XML = null;
         var _loc15_:XML = null;
         var _loc10_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Point = null;
         var _loc16_:EPackageItem = null;
         var _loc21_:EPackageItem = null;
         var _loc22_:EPackageItem = null;
         if(param7)
         {
            _loc16_ = param1.project.getItemByURL(param7);
            if(!_loc16_)
            {
               throw new Error("Resource not found \'" + param7 + "\'");
            }
         }
         if(_loc16_)
         {
            if(param3 == 0)
            {
               _loc10_ = _loc16_.width;
               _loc18_ = 200;
            }
            else
            {
               _loc10_ = 200;
               _loc18_ = _loc16_.height;
            }
         }
         else if(param3 == 0)
         {
            _loc10_ = 17;
            _loc18_ = 200;
         }
         else
         {
            _loc10_ = 200;
            _loc18_ = 17;
         }
         if(param3 == 0)
         {
            _loc19_ = new Point(_loc10_,20);
         }
         else
         {
            _loc19_ = new Point(20,_loc18_);
         }
         if(param4)
         {
            _loc21_ = createNewButton(param1,param2 + "_arrow1","Button","Common",param5,_loc19_,false,false,false,false,false,param9);
            _loc11_ = param1.getComponentXML(_loc21_);
            if(_loc11_.displayList.graph[0])
            {
               _loc11_.displayList.graph[0].@fillColor = "#A9DBF6";
               UtilsFile.saveXML(_loc21_.file,_loc11_);
            }
            _loc22_ = createNewButton(param1,param2 + "_arrow2","Button","Common",param6,_loc19_,false,false,false,false,false,param9);
            _loc11_ = param1.getComponentXML(_loc22_);
            if(_loc11_.displayList.graph[0])
            {
               _loc11_.displayList.graph[0].@fillColor = "#A9DBF6";
               UtilsFile.saveXML(_loc22_.file,_loc11_);
            }
         }
         var _loc17_:EPackageItem = createNewButton(param1,param2 + "_grip","Button","Common",param8,_loc19_,false,true,false,false,false,param9);
         _loc11_ = param1.getComponentXML(_loc17_);
         if(_loc11_.displayList.graph[0])
         {
            _loc11_.displayList.graph[0].@fillColor = "#D0D1D7";
            _loc11_.displayList.graph[1].@fillColor = "#888888";
            _loc11_.displayList.graph[2].@fillColor = "#6A6A6A";
            UtilsFile.saveXML(_loc17_.file,_loc11_);
         }
         var _loc14_:EPackageItem = param1.createNewComponent(param2,_loc10_,_loc18_,param9,"ScrollBar",null,true);
         _loc11_ = param1.getComponentXML(_loc14_);
         _loc13_ = <displayList/>;
         _loc11_.appendChild(_loc13_);
         var _loc20_:int = 1;
         if(_loc16_)
         {
            _loc12_ = new XML("<" + _loc16_.type + "/>");
            _loc20_++;
            _loc12_.@id = "n" + _loc20_;
            if(_loc16_.owner != param1)
            {
               _loc12_.@pkg = _loc16_.owner.id;
            }
            _loc12_.@src = _loc16_.id;
            _loc12_.@name = _loc12_.@id;
            _loc12_.@xy = "0,0";
            _loc12_.@size = _loc10_ + "," + _loc18_;
            _loc15_ = <relation/>;
            _loc15_.@target = "";
            if(param3 == 0)
            {
               _loc15_.@sidePair = "height";
            }
            else
            {
               _loc15_.@sidePair = "width";
            }
            _loc12_.appendChild(_loc15_);
            _loc13_.appendChild(_loc12_);
         }
         else
         {
            _loc12_ = <graph/>;
            _loc20_++;
            _loc12_.@id = "n" + _loc20_;
            _loc12_.@name = _loc12_.@id;
            _loc12_.@xy = "0,0";
            _loc12_.@size = _loc10_ + "," + _loc18_;
            _loc12_.@type = "rect";
            _loc12_.@lineSize = 0;
            _loc12_.@fillColor = "#F0F0F0";
            _loc12_.@touchable = "false";
            _loc15_ = <relation/>;
            _loc15_.@target = "";
            _loc15_.@sidePair = "width,height";
            _loc12_.appendChild(_loc15_);
            _loc13_.appendChild(_loc12_);
         }
         _loc12_ = <graph/>;
         _loc20_++;
         _loc12_.@id = "n" + _loc20_;
         _loc12_.@name = "bar";
         if(param4)
         {
            if(param3 == 0)
            {
               _loc12_.@xy = "0," + _loc19_.y;
               _loc12_.@size = _loc10_ + "," + (_loc18_ - _loc19_.y * 2);
            }
            else
            {
               _loc12_.@xy = _loc19_.x + ",0";
               _loc12_.@size = _loc10_ - _loc19_.x * 2 + "," + _loc18_;
            }
         }
         else
         {
            _loc12_.@xy = "0,0";
            _loc12_.@size = _loc10_ + "," + _loc18_;
         }
         _loc15_ = <relation/>;
         _loc15_.@target = "";
         if(param3 == 0)
         {
            _loc15_.@sidePair = "height";
         }
         else
         {
            _loc15_.@sidePair = "width";
         }
         _loc12_.appendChild(_loc15_);
         _loc13_.appendChild(_loc12_);
         if(param4)
         {
            _loc12_ = <component/>;
            _loc20_++;
            _loc12_.@id = "n" + _loc20_;
            _loc12_.@name = "arrow1";
            _loc12_.@xy = "0,0";
            _loc12_.@src = _loc21_.id;
            _loc13_.appendChild(_loc12_);
            _loc12_ = <component/>;
            _loc20_++;
            _loc12_.@id = "n" + _loc20_;
            _loc12_.@name = "arrow2";
            if(param3 == 0)
            {
               _loc12_.@xy = "0," + (_loc18_ - _loc19_.y);
            }
            else
            {
               _loc12_.@xy = _loc10_ - _loc19_.x + ",0";
            }
            _loc12_.@src = _loc22_.id;
            _loc15_ = <relation/>;
            _loc15_.@target = "";
            if(param3 == 0)
            {
               _loc15_.@sidePair = "bottom-bottom";
            }
            else
            {
               _loc15_.@sidePair = "right-right";
            }
            _loc12_.appendChild(_loc15_);
            _loc13_.appendChild(_loc12_);
         }
         _loc12_ = <component/>;
         _loc20_++;
         _loc12_.@id = "n" + _loc20_;
         _loc12_.@name = "grip";
         if(param3 == 0)
         {
            _loc12_.@xy = "0," + _loc19_.y;
         }
         else
         {
            _loc12_.@xy = _loc19_.x + ",0";
         }
         _loc12_.@src = _loc17_.id;
         _loc13_.appendChild(_loc12_);
         UtilsFile.saveXML(_loc14_.file,_loc11_);
         return _loc14_;
      }
      
      public static function createNewProgressBar(param1:EUIPackage, param2:String, param3:String, param4:String, param5:String, param6:Boolean, param7:String) : EPackageItem
      {
         var _loc16_:XML = null;
         var _loc17_:XML = null;
         var _loc9_:XML = null;
         var _loc11_:XML = null;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         var _loc15_:EPackageItem = null;
         var _loc13_:EPackageItem = null;
         if(param3)
         {
            _loc15_ = param1.project.getItemByURL(param3);
            if(!_loc15_)
            {
               throw new Error("Resource not found \'" + param3 + "\'");
            }
         }
         if(param4)
         {
            _loc13_ = param1.project.getItemByURL(param4);
            if(!_loc13_)
            {
               throw new Error("Resource not found \'" + param4 + "\'");
            }
         }
         if(_loc15_ && _loc13_)
         {
            _loc10_ = Math.max(_loc15_.width,_loc13_.width);
            _loc12_ = Math.max(_loc15_.height,_loc13_.height);
         }
         else if(_loc15_)
         {
            _loc10_ = _loc15_.width;
            _loc12_ = _loc15_.height;
         }
         else if(_loc13_)
         {
            _loc10_ = _loc13_.width;
            _loc12_ = _loc13_.height;
         }
         _loc10_ = Math.max(50,_loc10_);
         _loc12_ = Math.max(10,_loc12_);
         var _loc8_:EPackageItem = param1.createNewComponent(param2,_loc10_,_loc12_,param7,"ProgressBar");
         _loc16_ = param1.getComponentXML(_loc8_);
         _loc17_ = <displayList/>;
         _loc16_.appendChild(_loc17_);
         var _loc14_:int = 1;
         if(_loc15_)
         {
            _loc9_ = new XML("<" + _loc15_.type + "/>");
            _loc14_++;
            _loc9_.@id = "n" + _loc14_;
            if(_loc15_.owner != param1)
            {
               _loc9_.@pkg = _loc15_.owner.id;
            }
            _loc9_.@src = _loc15_.id;
            _loc9_.@name = _loc9_.@id;
            _loc9_.@xy = "0,0";
            _loc9_.@size = _loc10_ + "," + _loc12_;
            _loc11_ = <relation/>;
            _loc11_.@target = "";
            _loc11_.@sidePair = "width,height";
            _loc9_.appendChild(_loc11_);
            _loc17_.appendChild(_loc9_);
         }
         else
         {
            _loc9_ = <graph/>;
            _loc14_++;
            _loc9_.@id = "n" + _loc14_;
            _loc9_.@name = _loc9_.@id;
            _loc9_.@xy = "0,0";
            _loc9_.@size = _loc10_ + "," + _loc12_;
            _loc9_.@type = "rect";
            _loc9_.@lineSize = 1;
            _loc9_.@lineColor = "#A0A0A0";
            _loc9_.@fillColor = "#F0F0F0";
            _loc11_ = <relation/>;
            _loc11_.@target = "";
            _loc11_.@sidePair = "width,height";
            _loc9_.appendChild(_loc11_);
            _loc17_.appendChild(_loc9_);
         }
         if(_loc13_)
         {
            _loc9_ = new XML("<" + _loc13_.type + "/>");
            _loc14_++;
            _loc9_.@id = "n" + _loc14_;
            if(_loc13_.owner != param1)
            {
               _loc9_.@pkg = _loc13_.owner.id;
            }
            _loc9_.@src = _loc13_.id;
            _loc9_.@name = "bar";
            _loc9_.@xy = "0," + int((_loc12_ - _loc13_.height) / 2);
            _loc9_.@size = _loc10_ + "," + _loc13_.height;
            _loc17_.appendChild(_loc9_);
         }
         else
         {
            _loc9_ = <graph/>;
            _loc14_++;
            _loc9_.@id = "n" + _loc14_;
            _loc9_.@name = "bar";
            _loc9_.@xy = "0," + int((_loc12_ - 4) / 2);
            _loc9_.@size = _loc10_ + ",4";
            _loc9_.@type = "rect";
            _loc9_.@lineSize = 0;
            _loc9_.@fillColor = "#3399FF";
            _loc17_.appendChild(_loc9_);
         }
         if(param5 != "none")
         {
            _loc9_ = <text/>;
            _loc14_++;
            _loc9_.@id = "n" + _loc14_;
            _loc9_.@name = "title";
            _loc9_.@xy = "0," + int((_loc12_ - 16) / 2);
            _loc9_.@size = _loc10_ + "," + _loc12_;
            _loc9_.@autoSize = "none";
            _loc9_.@align = "center";
            _loc9_.@vAlign = "middle";
            _loc9_.@fontSize = "12";
            _loc11_ = <relation/>;
            _loc11_.@target = "";
            _loc11_.@sidePair = "width,height";
            _loc9_.appendChild(_loc11_);
            _loc17_.appendChild(_loc9_);
         }
         _loc17_ = _loc16_.ProgressBar[0];
         if(param5 != "none")
         {
            _loc17_.@titleType = param5;
         }
         if(param6)
         {
            _loc17_.@reverse = param6;
         }
         UtilsFile.saveXML(_loc8_.file,_loc16_);
         return _loc8_;
      }
      
      private static function isEmptyImages(param1:Array) : Boolean
      {
         return !param1[0] && !param1[1] && !param1[2] && !param1[3];
      }
      
      public static function createNewSlider(param1:EUIPackage, param2:String, param3:int, param4:String, param5:String, param6:Array, param7:String, param8:String) : EPackageItem
      {
         var _loc19_:Point = null;
         var _loc12_:int = 0;
         var _loc11_:int = 0;
         var _loc18_:XML = null;
         var _loc16_:XML = null;
         var _loc15_:EPackageItem = null;
         var _loc21_:EPackageItem = null;
         if(isEmptyImages(param6))
         {
            if(param3 == 0)
            {
               _loc19_ = new Point(10,19);
            }
            else
            {
               _loc19_ = new Point(19,10);
            }
         }
         var _loc10_:EPackageItem = createNewButton(param1,param2 + "_grip","Button","Common",param6,_loc19_,false,false,false,false,false,param8);
         if(param4)
         {
            _loc15_ = param1.project.getItemByURL(param4);
            if(!_loc15_)
            {
               throw new Error("Resource not found \'" + param4 + "\'");
            }
         }
         if(param5)
         {
            _loc21_ = param1.project.getItemByURL(param5);
            if(!_loc21_)
            {
               throw new Error("Resource not found \'" + param5 + "\'");
            }
         }
         if(_loc15_ && _loc21_)
         {
            _loc12_ = Math.max(_loc15_.width,_loc21_.width);
            _loc11_ = Math.max(_loc15_.height,_loc21_.height);
         }
         else if(_loc15_)
         {
            _loc12_ = _loc15_.width;
            _loc11_ = _loc15_.height;
         }
         else if(_loc21_)
         {
            _loc12_ = _loc21_.width;
            _loc11_ = _loc21_.height;
         }
         if(param3 == 0)
         {
            _loc12_ = Math.max(50,_loc12_);
            _loc11_ = Math.max(10,_loc11_);
         }
         else
         {
            _loc12_ = Math.max(10,_loc12_);
            _loc11_ = Math.max(50,_loc11_);
         }
         var _loc14_:EPackageItem = param1.createNewComponent(param2,_loc12_,_loc11_,param8,"Slider");
         var _loc9_:XML = param1.getComponentXML(_loc14_);
         var _loc17_:XML = <displayList/>;
         _loc9_.appendChild(_loc17_);
         var _loc13_:int = 1;
         if(_loc15_)
         {
            _loc18_ = new XML("<" + _loc15_.type + "/>");
            _loc13_++;
            _loc18_.@id = "n" + _loc13_;
            if(_loc15_.owner != param1)
            {
               _loc18_.@pkg = _loc15_.owner.id;
            }
            _loc18_.@src = _loc15_.id;
            _loc18_.@name = _loc18_.@id;
            _loc18_.@xy = "0,0";
            _loc18_.@size = _loc12_ + "," + _loc11_;
            _loc16_ = <relation/>;
            _loc16_.@target = "";
            _loc16_.@sidePair = "width,height";
            _loc18_.appendChild(_loc16_);
            _loc17_.appendChild(_loc18_);
         }
         else
         {
            _loc18_ = <graph/>;
            _loc13_++;
            _loc18_.@id = "n" + _loc13_;
            _loc18_.@name = _loc18_.@id;
            _loc18_.@xy = "0,0";
            _loc18_.@size = _loc12_ + "," + _loc11_;
            _loc18_.@type = "rect";
            _loc18_.@lineSize = 1;
            _loc18_.@lineColor = "#A0A0A0";
            _loc18_.@fillColor = "#F0F0F0";
            _loc16_ = <relation/>;
            _loc16_.@target = "";
            _loc16_.@sidePair = "width,height";
            _loc18_.appendChild(_loc16_);
            _loc17_.appendChild(_loc18_);
         }
         _loc13_++;
         var _loc20_:String = "n" + _loc13_;
         if(_loc21_)
         {
            _loc18_ = new XML("<" + _loc21_.type + "/>");
            _loc18_.@id = _loc20_;
            if(_loc21_.owner != param1)
            {
               _loc18_.@pkg = _loc21_.owner.id;
            }
            _loc18_.@src = _loc21_.id;
            if(param3 == 0)
            {
               _loc18_.@name = "bar";
            }
            else
            {
               _loc18_.@name = "bar_v";
            }
            if(param3 == 0)
            {
               _loc18_.@xy = Math.ceil(_loc10_.width / 2) + "," + int((_loc11_ - _loc21_.height) / 2);
               _loc18_.@size = _loc12_ - _loc10_.width + "," + _loc21_.height;
            }
            else
            {
               _loc18_.@xy = int((_loc12_ - _loc21_.width) / 2) + "," + Math.ceil(_loc10_.width / 2);
               _loc18_.@size = _loc21_.width + "," + (_loc11_ - _loc10_.height);
            }
            _loc17_.appendChild(_loc18_);
         }
         else
         {
            _loc18_ = <graph/>;
            _loc18_.@id = _loc20_;
            if(param3 == 0)
            {
               _loc18_.@name = "bar";
            }
            else
            {
               _loc18_.@name = "bar_v";
            }
            if(param3 == 0)
            {
               _loc18_.@xy = Math.ceil(_loc10_.width / 2) + "," + int((_loc11_ - 4) / 2);
               _loc18_.@size = _loc12_ - _loc10_.width + "," + 4;
            }
            else
            {
               _loc18_.@xy = int((_loc12_ - 4) / 2) + "," + Math.ceil(_loc10_.width / 2);
               _loc18_.@size = "4," + (_loc11_ - _loc10_.height);
            }
            _loc18_.@type = "rect";
            _loc18_.@lineSize = 0;
            _loc18_.@fillColor = "#3399FF";
            _loc17_.appendChild(_loc18_);
         }
         if(param7 != "none")
         {
            _loc18_ = <text/>;
            _loc13_++;
            _loc18_.@id = "n" + _loc13_;
            _loc18_.@name = "title";
            _loc18_.@xy = "0," + int((_loc11_ - 16) / 2);
            _loc18_.@size = _loc12_ + ",16";
            _loc18_.@autoSize = "none";
            _loc18_.@align = "center";
            _loc18_.@fontSize = "12";
            _loc16_ = <relation/>;
            _loc16_.@target = "";
            _loc16_.@sidePair = "width";
            _loc18_.appendChild(_loc16_);
            _loc17_.appendChild(_loc18_);
         }
         _loc18_ = <component/>;
         _loc13_++;
         _loc18_.@id = "n" + _loc13_;
         _loc18_.@name = "grip";
         if(param3 == 0)
         {
            _loc18_.@xy = _loc12_ - _loc10_.width + "," + int((_loc11_ - _loc10_.height) / 2);
         }
         else
         {
            _loc18_.@xy = int((_loc12_ - _loc10_.width) / 2) + "," + (_loc11_ - _loc10_.height);
         }
         _loc18_.@src = _loc10_.id;
         _loc16_ = <relation/>;
         _loc16_.@target = _loc20_;
         if(param3 == 0)
         {
            _loc16_.@sidePair = "right-right";
         }
         else
         {
            _loc16_.@sidePair = "bottom-bottom";
         }
         _loc18_.appendChild(_loc16_);
         _loc17_.appendChild(_loc18_);
         _loc17_ = _loc9_.Slider[0];
         if(param7 != "none")
         {
            _loc17_.@titleType = param7;
         }
         UtilsFile.saveXML(_loc14_.file,_loc9_);
         return _loc14_;
      }
      
      public static function createNewPopupMenu(param1:EUIPackage, param2:String, param3:String, param4:Array, param5:String) : EPackageItem
      {
         var _loc14_:int = 0;
         var _loc8_:int = 0;
         var _loc6_:EPackageItem = null;
         var _loc11_:XML = null;
         var _loc12_:XML = null;
         var _loc13_:EPackageItem = createNewButton(param1,param2 + "_item","Button","Radio",param4,null,true,true,true,false,false,param5);
         var _loc16_:XML = param1.getComponentXML(_loc13_);
         var _loc15_:XML = <controller/>;
         _loc15_.@name = "checked";
         _loc15_.@pages = "0,no,1,yes";
         _loc16_.appendChild(_loc15_);
         UtilsFile.saveXML(_loc13_.file,_loc16_);
         if(param3)
         {
            _loc6_ = param1.project.getItemByURL(param3);
            if(!_loc6_)
            {
               throw new Error("Resource not found \'" + param3 + "\'");
            }
         }
         if(_loc6_)
         {
            _loc14_ = _loc6_.width;
            _loc8_ = _loc6_.height;
         }
         _loc14_ = Math.max(50,Math.max(_loc13_.width,_loc14_));
         _loc8_ = Math.max(100,_loc8_);
         var _loc9_:EPackageItem = param1.createNewComponent(param2,_loc14_,_loc8_,param5,null,null,true);
         _loc16_ = param1.getComponentXML(_loc9_);
         _loc15_ = <displayList/>;
         _loc16_.appendChild(_loc15_);
         var _loc7_:int = 1;
         if(_loc6_ != null)
         {
            _loc11_ = new XML("<" + _loc6_.type + "/>");
            _loc7_++;
            _loc11_.@id = "n" + _loc7_;
            if(_loc6_.owner != param1)
            {
               _loc11_.@pkg = _loc6_.owner.id;
            }
            _loc11_.@src = _loc6_.id;
            _loc11_.@name = _loc11_.@id;
            _loc11_.@xy = "0,0";
            _loc11_.@size = _loc14_ + "," + _loc8_;
            _loc12_ = <relation/>;
            _loc12_.@target = "";
            _loc12_.@sidePair = "width,height";
            _loc11_.appendChild(_loc12_);
            _loc15_.appendChild(_loc11_);
         }
         else
         {
            _loc11_ = <graph/>;
            _loc7_++;
            _loc11_.@id = "n" + _loc7_;
            _loc11_.@name = _loc11_.@id;
            _loc11_.@xy = "0,0";
            _loc11_.@size = _loc14_ + "," + _loc8_;
            _loc11_.@type = "rect";
            _loc11_.@lineSize = 1;
            _loc11_.@lineColor = "#A0A0A0";
            _loc11_.@fillColor = "#F0F0F0";
            _loc12_ = <relation/>;
            _loc12_.@target = "";
            _loc12_.@sidePair = "width,height";
            _loc11_.appendChild(_loc12_);
            _loc15_.appendChild(_loc11_);
         }
         _loc11_ = <list/>;
         _loc7_++;
         var _loc10_:String = "n" + _loc7_;
         _loc11_.@id = _loc10_;
         _loc11_.@name = "list";
         _loc11_.@xy = "0,0";
         _loc11_.@size = _loc14_ + "," + _loc8_;
         _loc11_.@defaultItem = "ui://" + _loc13_.owner.id + _loc13_.id;
         _loc12_ = <relation/>;
         _loc12_.@target = "";
         _loc12_.@sidePair = "width";
         _loc11_.appendChild(_loc12_);
         _loc15_.appendChild(_loc11_);
         _loc15_ = <relation/>;
         _loc15_.@target = _loc10_;
         _loc15_.@sidePair = "height";
         _loc16_.appendChild(_loc15_);
         UtilsFile.saveXML(_loc9_.file,_loc16_);
         return _loc9_;
      }
   }
}

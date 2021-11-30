package fairygui
{
   import fairygui.display.UISprite;
   import fairygui.utils.PointList;
   import fairygui.utils.ToolSet;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class GGraph extends GObject
   {
      
      private static var helperCmds:Vector.<int> = new Vector.<int>();
      
      private static var helperPointList:PointList = new PointList();
       
      
      private var _graphics:Graphics;
      
      private var _type:int;
      
      private var _lineSize:int;
      
      private var _lineColor:int;
      
      private var _lineAlpha:Number;
      
      private var _fillColor:int;
      
      private var _fillAlpha:Number;
      
      private var _fillBitmapData:BitmapData;
      
      private var _corner:Array;
      
      private var _sides:int;
      
      private var _startAngle:Number;
      
      private var _polygonPoints:PointList;
      
      private var _distances:Array;
      
      public function GGraph()
      {
         super();
         _lineSize = 1;
         _lineAlpha = 1;
         _fillAlpha = 1;
         _fillColor = 16777215;
         _startAngle = 0;
      }
      
      public function get graphics() : Graphics
      {
         if(_graphics)
         {
            return _graphics;
         }
         delayCreateDisplayObject();
         _graphics = Sprite(displayObject).graphics;
         return _graphics;
      }
      
      public function get color() : uint
      {
         return _fillColor;
      }
      
      public function set color(param1:uint) : void
      {
         if(_fillColor != param1)
         {
            _fillColor = param1;
            updateGear(4);
            if(_type != 0)
            {
               updateGraph();
            }
         }
      }
      
      public function drawRect(param1:int, param2:int, param3:Number, param4:int, param5:Number, param6:Array = null) : void
      {
         _type = 1;
         _lineSize = param1;
         _lineColor = param2;
         _lineAlpha = param3;
         _fillColor = param4;
         _fillAlpha = param5;
         _fillBitmapData = null;
         _corner = param6;
         updateGraph();
      }
      
      public function drawRectWithBitmap(param1:int, param2:int, param3:Number, param4:BitmapData) : void
      {
         _type = 1;
         _lineSize = param1;
         _lineColor = param2;
         _lineAlpha = param3;
         _fillBitmapData = param4;
         updateGraph();
      }
      
      public function drawEllipse(param1:int, param2:int, param3:Number, param4:int, param5:Number) : void
      {
         _type = 2;
         _lineSize = param1;
         _lineColor = param2;
         _lineAlpha = param3;
         _fillColor = param4;
         _fillAlpha = param5;
         _corner = null;
         updateGraph();
      }
      
      public function drawRegularPolygon(param1:int, param2:int, param3:Number, param4:int, param5:Number, param6:int, param7:Number = 0, param8:Array = null) : void
      {
         _type = 3;
         _lineSize = param1;
         _lineColor = param2;
         _lineAlpha = param3;
         _fillColor = param4;
         _fillAlpha = param5;
         _corner = null;
         _sides = param6;
         _startAngle = param7;
         _distances = param8;
         updateGraph();
      }
      
      public function get distances() : Array
      {
         return _distances;
      }
      
      public function set distances(param1:Array) : void
      {
         _distances = param1;
         if(_type == 3)
         {
            updateGraph();
         }
      }
      
      public function drawPolygon(param1:int, param2:int, param3:Number, param4:int, param5:Number, param6:PointList) : void
      {
         _type = 4;
         _lineSize = param1;
         _lineColor = param2;
         _lineAlpha = param3;
         _fillColor = param4;
         _fillAlpha = param5;
         _corner = null;
         _polygonPoints = param6;
         updateGraph();
      }
      
      public function clearGraphics() : void
      {
         if(_graphics)
         {
            _type = 0;
            _graphics.clear();
         }
      }
      
      private function updateGraph() : void
      {
         var _loc8_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc6_:* = NaN;
         var _loc7_:int = 0;
         var _loc10_:Number = NaN;
         var _loc9_:Number = NaN;
         this.graphics;
         _graphics.clear();
         var _loc3_:int = Math.ceil(this.width);
         var _loc4_:int = Math.ceil(this.height);
         if(_loc3_ == 0 || _loc4_ == 0)
         {
            return;
         }
         if(_lineSize == 0)
         {
            _graphics.lineStyle(0,0,0,true,"normal");
         }
         else
         {
            _graphics.lineStyle(_lineSize,_lineColor,_lineAlpha,true,"normal");
         }
         var _loc1_:* = 0;
         if(_lineSize > 0)
         {
            if(_loc3_ > 0)
            {
               _loc3_ = _loc3_ - _lineSize;
            }
            if(_loc4_ > 0)
            {
               _loc4_ = _loc4_ - _lineSize;
            }
            _loc1_ = Number(_lineSize * 0.5);
         }
         if(_fillBitmapData != null)
         {
            _graphics.beginBitmapFill(_fillBitmapData);
         }
         else
         {
            _graphics.beginFill(_fillColor,_fillAlpha);
         }
         if(_type == 1)
         {
            if(_corner)
            {
               if(_corner.length == 1)
               {
                  _graphics.drawRoundRectComplex(_loc1_,_loc1_,_loc3_,_loc4_,int(_corner[0]),int(_corner[0]),int(_corner[0]),int(_corner[0]));
               }
               else
               {
                  _graphics.drawRoundRectComplex(_loc1_,_loc1_,_loc3_,_loc4_,int(_corner[0]),int(_corner[1]),int(_corner[2]),int(_corner[3]));
               }
            }
            else
            {
               _graphics.drawRect(_loc1_,_loc1_,_loc3_,_loc4_);
            }
         }
         else if(_type == 2)
         {
            _graphics.drawEllipse(_loc1_,_loc1_,_loc3_,_loc4_);
         }
         else if(_type == 3 || _type == 4)
         {
            if(_type == 3)
            {
               if(!_polygonPoints)
               {
                  _polygonPoints = new PointList();
               }
               _loc8_ = Math.min(_width,_height) / 2;
               _polygonPoints.length = _sides;
               _loc5_ = 0.0174532925199433 * _startAngle;
               _loc2_ = 2 * 3.14159265358979 / _sides;
               _loc7_ = 0;
               while(_loc7_ < _sides)
               {
                  if(_distances)
                  {
                     _loc6_ = Number(_distances[_loc7_]);
                     if(isNaN(_loc6_))
                     {
                        _loc6_ = 1;
                     }
                  }
                  else
                  {
                     _loc6_ = 1;
                  }
                  _loc10_ = _loc8_ + _loc8_ * _loc6_ * Math.cos(_loc5_);
                  _loc9_ = _loc8_ + _loc8_ * _loc6_ * Math.sin(_loc5_);
                  _polygonPoints.set(_loc7_,_loc10_,_loc9_);
                  _loc5_ = _loc5_ + _loc2_;
                  _loc7_++;
               }
            }
            helperCmds.length = 0;
            helperCmds.push(1);
            _loc7_ = 1;
            while(_loc7_ <= _polygonPoints.length)
            {
               helperCmds.push(2);
               _loc7_++;
            }
            helperPointList.length = 0;
            helperPointList.addRange(_polygonPoints);
            helperPointList.push3(_polygonPoints,0);
            _graphics.drawPath(helperCmds,helperPointList.rawList);
         }
         _graphics.endFill();
      }
      
      public function replaceMe(param1:GObject) : void
      {
         if(!_parent)
         {
            throw new Error("parent not set");
         }
         param1.name = this.name;
         param1.alpha = this.alpha;
         param1.rotation = this.rotation;
         param1.visible = this.visible;
         param1.touchable = this.touchable;
         param1.grayed = this.grayed;
         param1.setXY(this.x,this.y);
         param1.setSize(this.width,this.height);
         var _loc2_:int = _parent.getChildIndex(this);
         _parent.addChildAt(param1,_loc2_);
         param1.relations.copyFrom(this.relations);
         _parent.removeChild(this,true);
      }
      
      public function addBeforeMe(param1:GObject) : void
      {
         if(_parent == null)
         {
            throw new Error("parent not set");
         }
         var _loc2_:int = _parent.getChildIndex(this);
         _parent.addChildAt(param1,_loc2_);
      }
      
      public function addAfterMe(param1:GObject) : void
      {
         if(_parent == null)
         {
            throw new Error("parent not set");
         }
         var _loc2_:int = _parent.getChildIndex(this);
         _loc2_++;
         _parent.addChildAt(param1,_loc2_);
      }
      
      public function setNativeObject(param1:DisplayObject) : void
      {
         delayCreateDisplayObject();
         Sprite(displayObject).addChild(param1);
      }
      
      private function delayCreateDisplayObject() : void
      {
         if(!displayObject)
         {
            setDisplayObject(new UISprite(this));
            if(_parent)
            {
               _parent.childStateChanged(this);
            }
            handlePositionChanged();
            displayObject.alpha = this.alpha;
            displayObject.rotation = this.normalizeRotation;
            displayObject.visible = this.visible;
            Sprite(displayObject).mouseEnabled = this.touchable;
            Sprite(displayObject).mouseChildren = this.touchable;
         }
         else
         {
            Sprite(displayObject).graphics.clear();
            Sprite(displayObject).removeChildren();
            _graphics = null;
         }
      }
      
      override protected function handleSizeChanged() : void
      {
         if(_graphics)
         {
            if(_type != 0)
            {
               updateGraph();
            }
         }
      }
      
      override public function getProp(param1:int) : *
      {
         if(param1 == 2)
         {
            return this.color;
         }
         return super.getProp(param1);
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         if(param1 == 2)
         {
            this.color = param2;
         }
         else
         {
            super.setProp(param1,param2);
         }
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = param1.@type;
         if(_loc7_ && _loc7_ != "empty")
         {
            setDisplayObject(new UISprite(this));
         }
         super.setup_beforeAdd(param1);
         if(displayObject != null)
         {
            _graphics = Sprite(this.displayObject).graphics;
            _loc2_ = param1.@lineSize;
            if(_loc2_)
            {
               _lineSize = parseInt(_loc2_);
            }
            _loc2_ = param1.@lineColor;
            if(_loc2_)
            {
               _loc4_ = uint(ToolSet.convertFromHtmlColor(_loc2_,true));
               _lineColor = _loc4_ & 16777215;
               _lineAlpha = (_loc4_ >> 24 & 255) / 255;
            }
            _loc2_ = param1.@fillColor;
            if(_loc2_)
            {
               _loc4_ = uint(ToolSet.convertFromHtmlColor(_loc2_,true));
               _fillColor = _loc4_ & 16777215;
               _fillAlpha = (_loc4_ >> 24 & 255) / 255;
            }
            _loc2_ = param1.@corner;
            if(_loc2_)
            {
               _corner = _loc2_.split(",");
            }
            if(_loc7_ == "rect")
            {
               _type = 1;
            }
            else if(_loc7_ == "ellipse" || _loc7_ == "eclipse")
            {
               _type = 2;
            }
            else if(_loc7_ == "regular_polygon")
            {
               _type = 3;
               _loc2_ = param1.@sides;
               _sides = parseInt(_loc2_);
               _loc2_ = param1.@startAngle;
               if(_loc2_)
               {
                  _startAngle = parseFloat(_loc2_);
               }
               _loc2_ = param1.@distances;
               if(_loc2_)
               {
                  _loc3_ = _loc2_.split(",");
                  _loc5_ = _loc3_.length;
                  _distances = [];
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     if(_loc3_[_loc6_])
                     {
                        _distances[_loc6_] = 1;
                     }
                     else
                     {
                        _distances[_loc6_] = parseFloat(_loc3_[_loc6_]);
                     }
                     _loc6_++;
                  }
               }
            }
            else if(_loc7_ == "polygon")
            {
               _type = 4;
               _polygonPoints = new PointList();
               _loc2_ = param1.@points;
               if(_loc2_)
               {
                  _loc3_ = _loc2_.split(",");
                  _loc5_ = _loc3_.length;
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     _polygonPoints.push(_loc3_[_loc6_],_loc3_[_loc6_ + 1]);
                     _loc6_ = _loc6_ + 2;
                  }
               }
            }
            updateGraph();
         }
      }
   }
}

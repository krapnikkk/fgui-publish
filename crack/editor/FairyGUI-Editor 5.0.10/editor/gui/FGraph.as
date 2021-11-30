package fairygui.editor.gui
{
   import fairygui.ObjectPropID;
   import fairygui.utils.PointList;
   import fairygui.utils.ToolSet;
   import fairygui.utils.Utils;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import flash.display.Graphics;
   import flash.display.GraphicsPathCommand;
   import flash.display.LineScaleMode;
   import flash.geom.Rectangle;
   
   public class FGraph extends FObject
   {
      
      public static const EMPTY:String = "empty";
      
      public static const RECT:String = "rect";
      
      public static const ELLIPSE:String = "ellipse";
      
      public static const POLYGON:String = "polygon";
      
      public static const REGULAR_POLYGON:String = "regular_polygon";
      
      public static const TYPE_CHANGED:int = 100;
      
      private static var helperCmds:Vector.<int> = new Vector.<int>();
      
      private static var helperPointList:PointList = new PointList();
       
      
      private var _type:String;
      
      private var _cornerRadius:String;
      
      private var _lineColor:uint;
      
      private var _lineSize:int;
      
      private var _fillColor:uint;
      
      private var _fillAlpha:int;
      
      private var _polygonPoints:PointList;
      
      private var _verticesDistance:Vector.<Number>;
      
      private var _startAngle:Number;
      
      private var _shapeLocked:Boolean;
      
      private var _backupPoints:Vector.<Number>;
      
      public function FGraph()
      {
         super();
         this._objectType = FObjectType.GRAPH;
         this._type = "rect";
         this._lineSize = 1;
         this._lineColor = 4278190080;
         this._fillColor = 4294967295;
         this._fillAlpha = 255;
         this._cornerRadius = "";
         this._startAngle = 0;
         _useSourceSize = false;
         this._polygonPoints = new PointList();
         this._verticesDistance = new Vector.<Number>();
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         if(this._type != param1)
         {
            if(this._type == POLYGON)
            {
               this._backupPoints = this._polygonPoints.rawList.concat();
            }
            this._type = param1;
            if(this._type == POLYGON)
            {
               if(this._backupPoints)
               {
                  this._polygonPoints.rawList = this._backupPoints;
               }
               this.validatePolygonPoints();
            }
            else if(this._type == REGULAR_POLYGON)
            {
               this.validateRegularPolygonPoints();
            }
            if((_flags & FObjectFlags.INSPECTING) != 0)
            {
               _dispatcher.emit(this,TYPE_CHANGED);
            }
            _outlineVersion++;
            if(!_underConstruct)
            {
               this.updateGraph();
            }
         }
      }
      
      public function get isVerticesEditable() : Boolean
      {
         return this._type == POLYGON || this._type == REGULAR_POLYGON;
      }
      
      public function get shapeLocked() : Boolean
      {
         return this._shapeLocked;
      }
      
      public function set shapeLocked(param1:Boolean) : void
      {
         this._shapeLocked = param1;
      }
      
      public function get cornerRadius() : String
      {
         return this._cornerRadius;
      }
      
      public function set cornerRadius(param1:String) : void
      {
         this._cornerRadius = param1;
         if(!_underConstruct)
         {
            this.updateGraph();
         }
      }
      
      public function get lineColor() : uint
      {
         return this._lineColor;
      }
      
      public function set lineColor(param1:uint) : void
      {
         this._lineColor = param1;
         if(!_underConstruct)
         {
            this.updateGraph();
         }
      }
      
      public function get lineSize() : int
      {
         return this._lineSize;
      }
      
      public function set lineSize(param1:int) : void
      {
         this._lineSize = param1;
         if(!_underConstruct)
         {
            this.updateGraph();
         }
      }
      
      public function get color() : uint
      {
         return this._fillColor & 16777215;
      }
      
      public function set color(param1:uint) : void
      {
         this.fillColor = (param1 & 16777215) + (this._fillAlpha << 24);
      }
      
      public function get fillColor() : uint
      {
         return this._fillColor;
      }
      
      public function set fillColor(param1:uint) : void
      {
         if(this._fillColor != param1)
         {
            this._fillColor = param1;
            this._fillAlpha = (this._fillColor & 4278190080) >> 24;
            updateGear(4);
            if(!_underConstruct)
            {
               this.updateGraph();
            }
         }
      }
      
      public function get polygonPoints() : PointList
      {
         return this._polygonPoints;
      }
      
      public function get verticesDistance() : Vector.<Number>
      {
         return this._verticesDistance;
      }
      
      public function get sides() : int
      {
         return this._verticesDistance.length;
      }
      
      public function set sides(param1:int) : void
      {
         var _loc3_:int = 0;
         if(param1 < 3)
         {
            param1 = 3;
         }
         var _loc2_:int = this._verticesDistance.length;
         if(_loc2_ != param1)
         {
            this._verticesDistance.length = param1;
            _loc3_ = _loc2_;
            while(_loc3_ < param1)
            {
               this._verticesDistance[_loc3_] = 1;
               _loc3_++;
            }
            this.validateRegularPolygonPoints();
            _outlineVersion++;
            this.updateGraph();
         }
      }
      
      public function get startAngle() : Number
      {
         return this._startAngle;
      }
      
      public function set startAngle(param1:Number) : void
      {
         if(this._startAngle != param1)
         {
            this._startAngle = param1;
            this.validateRegularPolygonPoints();
            _outlineVersion++;
            this.updateGraph();
         }
      }
      
      public function set polygonData(param1:Vector.<Number>) : void
      {
         if(this._type == POLYGON)
         {
            this._polygonPoints.rawList = param1;
            this.validatePolygonPoints();
         }
         else
         {
            this._verticesDistance = param1;
            this.validateRegularPolygonPoints();
         }
         _outlineVersion++;
         this.updateGraph();
      }
      
      public function get polygonData() : Vector.<Number>
      {
         if(this._type == POLYGON)
         {
            return this._polygonPoints.rawList;
         }
         return this._verticesDistance;
      }
      
      public function addVertex(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(param3)
         {
            _loc4_ = this._polygonPoints.length;
            _loc5_ = int.MAX_VALUE;
            _loc6_ = -1;
            _loc8_ = 0;
            while(_loc8_ < _loc4_)
            {
               _loc9_ = this._polygonPoints.get_x(_loc8_);
               _loc10_ = this._polygonPoints.get_y(_loc8_);
               if(_loc8_ == 0)
               {
                  _loc7_ = ToolSet.pointLineDistance(param1,param2,this._polygonPoints.get_x(_loc4_ - 1),this._polygonPoints.get_y(_loc4_ - 1),this._polygonPoints.get_x(_loc8_),this._polygonPoints.get_y(_loc8_),true);
               }
               else
               {
                  _loc7_ = ToolSet.pointLineDistance(param1,param2,this._polygonPoints.get_x(_loc8_ - 1),this._polygonPoints.get_y(_loc8_ - 1),this._polygonPoints.get_x(_loc8_),this._polygonPoints.get_y(_loc8_),true);
               }
               if(_loc7_ < _loc5_)
               {
                  _loc6_ = _loc8_;
                  _loc5_ = _loc7_;
               }
               _loc8_++;
            }
            this._polygonPoints.insert(_loc6_,param1,param2);
            if(this._type == REGULAR_POLYGON)
            {
               this._verticesDistance.splice(_loc6_,0,1);
               this.validateRegularPolygonPoints();
            }
         }
         else
         {
            this._polygonPoints.push(param1,param2);
            if(this._type == REGULAR_POLYGON)
            {
               this._verticesDistance.push(1);
               this.validateRegularPolygonPoints();
            }
         }
         _outlineVersion++;
         this.updateGraph();
      }
      
      public function removeVertex(param1:int) : void
      {
         this._polygonPoints.remove(param1);
         if(this._type == REGULAR_POLYGON)
         {
            this._verticesDistance.splice(param1,1);
            this.validateRegularPolygonPoints();
         }
         _outlineVersion++;
         this.updateGraph();
      }
      
      public function updateVertex(param1:int, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(this._type == REGULAR_POLYGON)
         {
            _loc4_ = Math.min(_width,_height) / 2;
            _loc5_ = Math.sqrt(Math.pow(param2 - _loc4_,2) + Math.pow(param3 - _loc4_,2)) / _loc4_;
            if(_loc5_ > 1)
            {
               _loc5_ = 1;
            }
            this._verticesDistance[param1] = _loc5_;
            _loc6_ = Utils.DEG_TO_RAD * this._startAngle + param1 * 2 * Math.PI / this._polygonPoints.length;
            param2 = _loc4_ + _loc4_ * _loc5_ * Math.cos(_loc6_);
            param3 = _loc4_ + _loc4_ * _loc5_ * Math.sin(_loc6_);
            this._polygonPoints.set(param1,param2,param3);
         }
         else if(this._shapeLocked)
         {
            _loc7_ = param2 - this._polygonPoints.get_x(param1);
            _loc8_ = param3 - this._polygonPoints.get_y(param1);
            _loc9_ = this._polygonPoints.length;
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               param2 = this._polygonPoints.get_x(_loc10_) + _loc7_;
               param3 = this._polygonPoints.get_y(_loc10_) + _loc8_;
               this._polygonPoints.set(_loc10_,param2,param3);
               _loc10_++;
            }
         }
         else
         {
            this._polygonPoints.set(param1,param2,param3);
         }
         _outlineVersion++;
         this.updateGraph();
      }
      
      public function updateVertexDistance(param1:int, param2:Number) : void
      {
         this._verticesDistance[param1] = param2;
         this.validateRegularPolygonPoints();
         _outlineVersion++;
         this.updateGraph();
      }
      
      private function validatePolygonPoints() : void
      {
         if(this._polygonPoints.length < 3)
         {
            this._polygonPoints.length = 0;
            this._polygonPoints.push(0,0);
            this._polygonPoints.push(_width,0);
            this._polygonPoints.push(_width,_height);
            this._polygonPoints.push(0,_height);
         }
      }
      
      private function validateRegularPolygonPoints() : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Number = Math.min(_width,_height) / 2;
         if(this._verticesDistance.length < 3)
         {
            this._verticesDistance.length = 0;
            this._verticesDistance.push(1);
            this._verticesDistance.push(1);
            this._verticesDistance.push(1);
         }
         var _loc2_:int = this._verticesDistance.length;
         this._polygonPoints.length = _loc2_;
         var _loc3_:Number = Utils.DEG_TO_RAD * this._startAngle;
         var _loc4_:Number = 2 * Math.PI / _loc2_;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc6_ = this._verticesDistance[_loc5_];
            _loc7_ = _loc1_ + _loc1_ * _loc6_ * Math.cos(_loc3_);
            _loc8_ = _loc1_ + _loc1_ * _loc6_ * Math.sin(_loc3_);
            this._polygonPoints.set(_loc5_,_loc7_,_loc8_);
            _loc3_ = _loc3_ + _loc4_;
            _loc5_++;
         }
      }
      
      public function calculatePolygonBounds(param1:Rectangle = null) : Rectangle
      {
         var _loc6_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:int = int.MAX_VALUE;
         var _loc3_:int = int.MAX_VALUE;
         var _loc4_:int = int.MIN_VALUE;
         var _loc5_:int = int.MIN_VALUE;
         var _loc7_:int = this._polygonPoints.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = this._polygonPoints.get_x(_loc6_);
            _loc9_ = this._polygonPoints.get_y(_loc6_);
            if(_loc8_ < _loc2_)
            {
               _loc2_ = _loc8_;
            }
            if(_loc9_ < _loc3_)
            {
               _loc3_ = _loc9_;
            }
            if(_loc8_ > _loc4_)
            {
               _loc4_ = _loc8_;
            }
            if(_loc9_ > _loc5_)
            {
               _loc5_ = _loc9_;
            }
            _loc6_++;
         }
         if(!param1)
         {
            param1 = new Rectangle();
         }
         param1.setTo(_loc2_,_loc3_,_loc4_ - _loc2_,_loc5_ - _loc3_);
         return param1;
      }
      
      override protected function handleCreate() : void
      {
         if(_width > 0 && _height > 0)
         {
            this.updateGraph();
         }
      }
      
      override public function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         if(this._type == REGULAR_POLYGON)
         {
            this.validateRegularPolygonPoints();
         }
         if(!_underConstruct)
         {
            this.updateGraph();
         }
      }
      
      override public function getProp(param1:int) : *
      {
         if(param1 == ObjectPropID.Color)
         {
            return this.color;
         }
         return super.getProp(param1);
      }
      
      override public function setProp(param1:int, param2:*) : void
      {
         if(param1 == ObjectPropID.Color)
         {
            this.color = param2;
         }
         else
         {
            super.setProp(param1,param2);
         }
      }
      
      override public function read_beforeAdd(param1:XData, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         super.read_beforeAdd(param1,param2);
         this._type = param1.getAttribute("type","empty");
         if(this._type == "eclipse")
         {
            this._type = ELLIPSE;
         }
         this._lineSize = param1.getAttributeInt("lineSize",1);
         this._lineColor = param1.getAttributeColor("lineColor",true,4278190080);
         this._fillColor = param1.getAttributeColor("fillColor",true,4294967295);
         this._fillAlpha = (this._fillColor & 4278190080) >> 24;
         this._cornerRadius = param1.getAttribute("corner","");
         if(this._type == POLYGON)
         {
            _loc3_ = param1.getAttribute("points");
            if(_loc3_)
            {
               _loc4_ = _loc3_.split(",");
               _loc5_ = _loc4_.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  this._polygonPoints.push(_loc4_[_loc6_],_loc4_[_loc6_ + 1]);
                  _loc6_ = _loc6_ + 2;
               }
            }
            else
            {
               this._polygonPoints.length = 0;
            }
            this.validatePolygonPoints();
         }
         else if(this._type == REGULAR_POLYGON)
         {
            _loc7_ = param1.getAttributeInt("sides");
            this._verticesDistance.length = _loc7_;
            this._startAngle = param1.getAttributeFloat("startAngle");
            _loc3_ = param1.getAttribute("distances");
            if(_loc3_)
            {
               _loc4_ = _loc3_.split(",");
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(!_loc4_[_loc6_])
                  {
                     this._verticesDistance[_loc6_] = 1;
                  }
                  else
                  {
                     this._verticesDistance[_loc6_] = parseFloat(_loc4_[_loc6_]);
                  }
                  _loc6_++;
               }
            }
            else
            {
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  this._verticesDistance[_loc6_] = 1;
                  _loc6_++;
               }
            }
            this.validateRegularPolygonPoints();
         }
      }
      
      override public function read_afterAdd(param1:XData, param2:Object) : void
      {
         super.read_afterAdd(param1,param2);
         if(param1.getAttributeBool("forHitTest"))
         {
            _parent.hitTestSource = this;
         }
         if(param1.getAttributeBool("forMask"))
         {
            _parent.mask = this;
         }
         this.updateGraph();
      }
      
      override public function write() : XData
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<String> = null;
         var _loc1_:XData = super.write();
         if(this._type != "empty")
         {
            _loc1_.setAttribute("type",this._type == "ellipse"?"eclipse":this._type);
         }
         if(this._lineSize != 1)
         {
            _loc1_.setAttribute("lineSize",this._lineSize);
         }
         if(this._lineColor != 4278190080)
         {
            _loc1_.setAttribute("lineColor",UtilsStr.convertToHtmlColor(this._lineColor,true));
         }
         if(this._fillColor != 4294967295)
         {
            _loc1_.setAttribute("fillColor",UtilsStr.convertToHtmlColor(this._fillColor,true));
         }
         if(this._cornerRadius && this._cornerRadius != "0")
         {
            _loc1_.setAttribute("corner",this._cornerRadius);
         }
         if(this.type == POLYGON)
         {
            _loc1_.setAttribute("points",this._polygonPoints.join(","));
         }
         else if(this.type == REGULAR_POLYGON)
         {
            _loc1_.setAttribute("sides",this._polygonPoints.length);
            if(this._startAngle != 0)
            {
               _loc1_.setAttribute("startAngle",this._startAngle);
            }
            _loc2_ = this._verticesDistance.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(this._verticesDistance[_loc3_] < 0.99)
               {
                  break;
               }
               _loc3_++;
            }
            if(_loc3_ != _loc2_)
            {
               _loc4_ = new Vector.<String>(_loc2_,true);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  if(this._verticesDistance[_loc3_] > 0.99)
                  {
                     _loc4_[_loc3_] = "";
                  }
                  else
                  {
                     _loc4_[_loc3_] = UtilsStr.toFixed(this._verticesDistance[_loc3_],2);
                  }
                  _loc3_++;
               }
               _loc1_.setAttribute("distances",_loc4_.join(","));
            }
         }
         return _loc1_;
      }
      
      public function updateGraph() : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:Graphics = _displayObject.container.graphics;
         _loc1_.clear();
         if(this._type == "empty")
         {
            return;
         }
         var _loc2_:Number = Math.ceil(_width);
         var _loc3_:Number = Math.ceil(_height);
         if(_loc2_ == 0 || _loc3_ == 0)
         {
            return;
         }
         var _loc4_:Number = 0;
         if(this._lineSize > 0)
         {
            if(_loc2_ > 0)
            {
               _loc2_ = _loc2_ - this._lineSize;
            }
            if(_loc3_ > 0)
            {
               _loc3_ = _loc3_ - this._lineSize;
            }
            _loc4_ = this._lineSize * 0.5;
         }
         if(this._lineSize == 0)
         {
            _loc1_.lineStyle(0,0,0,true,LineScaleMode.NORMAL);
         }
         else
         {
            _loc1_.lineStyle(this._lineSize,this._lineColor & 16777215,(this._lineColor >> 24 & 255) / 255,true,LineScaleMode.NORMAL);
         }
         _loc1_.beginFill(this._fillColor & 16777215,(this._fillColor >> 24 & 255) / 255);
         if(this.type == "rect")
         {
            if(this._cornerRadius)
            {
               _loc5_ = this._cornerRadius.split(",");
               if(_loc5_.length == 1)
               {
                  _loc1_.drawRoundRectComplex(_loc4_,_loc4_,_loc2_,_loc3_,int(_loc5_[0]),int(_loc5_[0]),int(_loc5_[0]),int(_loc5_[0]));
               }
               else
               {
                  _loc1_.drawRoundRectComplex(_loc4_,_loc4_,_loc2_,_loc3_,int(_loc5_[0]),int(_loc5_[1]),int(_loc5_[2]),int(_loc5_[3]));
               }
            }
            else
            {
               _loc1_.drawRect(_loc4_,_loc4_,_loc2_,_loc3_);
            }
         }
         else if(this.type == "ellipse")
         {
            _loc1_.drawEllipse(_loc4_,_loc4_,_loc2_,_loc3_);
         }
         else if(this.type == "polygon" || this.type == "regular_polygon")
         {
            _loc6_ = this._polygonPoints.length;
            helperCmds.length = 0;
            helperCmds.push(GraphicsPathCommand.MOVE_TO);
            _loc7_ = 1;
            while(_loc7_ <= _loc6_)
            {
               helperCmds.push(GraphicsPathCommand.LINE_TO);
               _loc7_++;
            }
            helperPointList.length = 0;
            helperPointList.addRange(this._polygonPoints);
            helperPointList.push3(this._polygonPoints,0);
            _loc1_.drawPath(helperCmds,helperPointList.rawList);
         }
         _loc1_.endFill();
         if(!_underConstruct && _parent && !FObjectFlags.isDocRoot(_parent._flags))
         {
            if(_parent.hitTestSource == this)
            {
               _parent.displayObject.setHitArea(this);
            }
            if(_parent.mask == this)
            {
               _parent.displayObject.setMask(this);
            }
         }
      }
   }
}

package fairygui
{
   import fairygui.display.UISprite;
   import fairygui.utils.ToolSet;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class GGraph extends GObject implements IColorGear
   {
       
      
      private var _graphics:Graphics;
      
      private var _type:int;
      
      private var _lineSize:int;
      
      private var _lineColor:int;
      
      private var _lineAlpha:Number;
      
      private var _fillColor:int;
      
      private var _fillAlpha:Number;
      
      private var _fillBitmapData:BitmapData;
      
      private var _corner:Array;
      
      public function GGraph()
      {
         super();
         _lineSize = 1;
         _lineAlpha = 1;
         _fillAlpha = 1;
         _fillColor = 16777215;
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
               drawCommon();
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
         drawCommon();
      }
      
      public function drawRectWithBitmap(param1:int, param2:int, param3:Number, param4:BitmapData) : void
      {
         _type = 1;
         _lineSize = param1;
         _lineColor = param2;
         _lineAlpha = param3;
         _fillBitmapData = param4;
         drawCommon();
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
         drawCommon();
      }
      
      public function clearGraphics() : void
      {
         if(_graphics)
         {
            _type = 0;
            _graphics.clear();
         }
      }
      
      private function drawCommon() : void
      {
         this.graphics;
         _graphics.clear();
         var _loc1_:int = Math.ceil(this.width);
         var _loc2_:int = Math.ceil(this.height);
         if(_loc1_ == 0 || _loc2_ == 0)
         {
            return;
         }
         if(_lineSize == 0)
         {
            _graphics.lineStyle(0,0,0,true,"none");
         }
         else
         {
            _graphics.lineStyle(_lineSize,_lineColor,_lineAlpha,true,"none");
         }
         if(_lineSize == 1)
         {
            if(_loc1_ > 0)
            {
               _loc1_ = _loc1_ - _lineSize;
            }
            if(_loc2_ > 0)
            {
               _loc2_ = _loc2_ - _lineSize;
            }
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
                  _graphics.drawRoundRect(0,0,_loc1_,_loc2_,int(_corner[0]),int(_corner[0]));
               }
               else
               {
                  _graphics.drawRoundRectComplex(0,0,_loc1_,_loc2_,int(_corner[0]),int(_corner[1]),int(_corner[2]),int(_corner[3]));
               }
            }
            else
            {
               _graphics.drawRect(0,0,_loc1_,_loc2_);
            }
         }
         else
         {
            _graphics.drawEllipse(0,0,_loc1_,_loc2_);
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
               drawCommon();
            }
         }
      }
      
      override public function setup_beforeAdd(param1:XML) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:String = param1.@type;
         if(_loc4_ && _loc4_ != "empty")
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
               _loc3_ = uint(ToolSet.convertFromHtmlColor(_loc2_,true));
               _lineColor = _loc3_ & 16777215;
               _lineAlpha = (_loc3_ >> 24 & 255) / 255;
            }
            _loc2_ = param1.@fillColor;
            if(_loc2_)
            {
               _loc3_ = uint(ToolSet.convertFromHtmlColor(_loc2_,true));
               _fillColor = _loc3_ & 16777215;
               _fillAlpha = (_loc3_ >> 24 & 255) / 255;
            }
            _loc2_ = param1.@corner;
            if(_loc2_)
            {
               _corner = _loc2_.split(",");
            }
            if(_loc4_ == "rect")
            {
               _type = 1;
            }
            else
            {
               _type = 2;
            }
            drawCommon();
         }
      }
   }
}

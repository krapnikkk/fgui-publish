package fairygui.editor.gui
{
   import fairygui.editor.gui.gear.EIColorGear;
   import fairygui.editor.utils.UtilsStr;
   import flash.display.Graphics;
   
   public class EGVideo extends EGObject implements EIColorGear
   {
      
      public static const EMPTY:String = "empty";
      
      public static const RECT:String = "rect";
      
      public static const ECLIPSE:String = "eclipse";
       
      
      private var _type:String;
      
      private var _cornerRadius:String;
      
      private var _lineColor:uint;
      
      private var _lineSize:int;
      
      private var _fillColor:uint;
      
      private var _fillAlpha:int;
      
      protected var _showCtrol:Boolean;
      
      protected var _autoPlay:Boolean;
      
      protected var _fullScreen:Boolean;
      
      protected var _videSrc:String;
      
      public function EGVideo()
      {
         super();
         this._type = "rect";
         this._lineSize = 1;
         this._lineColor = UtilsStr.convertFromHtmlColor("#FF0000",true);
         this._fillColor = UtilsStr.convertFromHtmlColor("#FFFFFF",true);
         this._fillAlpha = 255;
         this._cornerRadius = "";
         this._videSrc = "";
         this._autoPlay = false;
         this._fullScreen = false;
         _useSourceSize = false;
         this._showCtrol = false;
         this.objectType = "video";
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
         if(editMode == 2)
         {
            if(this._type == "empty")
            {
               _displayObject.setDashedRect(true,"Graph");
            }
            else
            {
               _displayObject.setDashedRect(false,null);
            }
         }
         if(!underConstruct)
         {
            this.updateGraph();
         }
      }
      
      public function get showCtrol() : Boolean
      {
         return this._showCtrol;
      }
      
      public function set showCtrol(param1:Boolean) : void
      {
         this._showCtrol = param1;
      }
      
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         this._autoPlay = param1;
      }
      
      public function get fullScreen() : Boolean
      {
         return this._fullScreen;
      }
      
      public function set fullScreen(param1:Boolean) : void
      {
         this._fullScreen = param1;
      }
      
      public function get videSrc() : String
      {
         return this._videSrc;
      }
      
      public function set videSrc(param1:String) : void
      {
         this._videSrc = param1;
      }
      
      public function get cornerRadius() : String
      {
         return this._cornerRadius;
      }
      
      public function set cornerRadius(param1:String) : void
      {
         this._cornerRadius = param1;
         if(!underConstruct)
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
         if(!underConstruct)
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
         if(!underConstruct)
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
            if(!underConstruct)
            {
               this.updateGraph();
            }
         }
      }
      
      override public function create() : void
      {
         this.updateGraph();
      }
      
      override protected function handleSizeChanged() : void
      {
         super.handleSizeChanged();
         this.updateGraph();
      }
      
      override public function fromXML_beforeAdd(param1:XML) : void
      {
         this._videSrc = param1.@videSrc;
         this._autoPlay = param1.@autoPlay == "true";
         this._fullScreen = param1.@fullScreen == "true";
         this._showCtrol = param1.@showCtrol == "true";
         this._type = param1.@type;
         super.fromXML_beforeAdd(param1);
      }
      
      override public function fromXML_afterAdd(param1:XML) : void
      {
         super.fromXML_afterAdd(param1);
         if(param1.@forHitTest == "true")
         {
            parent.hitTestSource = this;
         }
         if(param1.@forMask == "true")
         {
            parent.mask = this;
         }
      }
      
      override public function toXML() : XML
      {
         var _loc1_:XML = super.toXML();
         _loc1_.@videSrc = this._videSrc;
         _loc1_.@autoPlay = this._autoPlay;
         _loc1_.@fullScreen = this._fullScreen;
         _loc1_.@showCtrol = this._showCtrol;
         _loc1_.@type = this._type;
         return _loc1_;
      }
      
      public function updateGraph() : void
      {
         var _loc2_:Array = null;
         var _loc4_:Graphics = _displayObject.container.graphics;
         _loc4_.clear();
         if(this._type == "empty")
         {
            if(editMode == 2)
            {
               _displayObject.setDashedRect(true,"Graph");
            }
            return;
         }
         if(editMode == 2)
         {
            _displayObject.setDashedRect(false,null);
         }
         var _loc3_:int = Math.ceil(_width);
         var _loc1_:int = Math.ceil(_height);
         if(_loc3_ == 0 || _loc1_ == 0)
         {
            return;
         }
         if(this._lineSize == 1)
         {
            if(_loc3_ > 0)
            {
               _loc3_--;
            }
            if(_loc1_ > 0)
            {
               _loc1_--;
            }
         }
         _loc4_.beginFill(this._fillColor & 16777215,(this._fillColor >> 24 & 255) / 255);
         if(this.type == "rect")
         {
            if(this._lineSize == 0)
            {
               _loc4_.lineStyle(0,0,0,true,"normal");
            }
            else
            {
               _loc4_.lineStyle(this._lineSize,this._lineColor & 16777215,(this._lineColor >> 24 & 255) / 255,true,"normal");
            }
            if(this._cornerRadius)
            {
               _loc2_ = this._cornerRadius.split(",");
               if(_loc2_.length == 1)
               {
                  _loc4_.drawRoundRect(0,0,_loc3_,_loc1_,int(_loc2_[0]),int(_loc2_[0]));
               }
               else
               {
                  _loc4_.drawRoundRectComplex(0,0,_loc3_,_loc1_,int(_loc2_[0]),int(_loc2_[1]),int(_loc2_[2]),int(_loc2_[3]));
               }
            }
            else
            {
               _loc4_.drawRect(0,0,_loc3_,_loc1_);
            }
         }
         else
         {
            if(this._lineSize == 0)
            {
               _loc4_.lineStyle(0,0,0,true,"normal");
            }
            else
            {
               _loc4_.lineStyle(this._lineSize,this._lineColor & 16777215,(this._lineColor >> 24 & 255) / 255,true,"normal");
            }
            _loc4_.drawEllipse(0,0,_loc3_,_loc1_);
         }
         _loc4_.endFill();
         if(!underConstruct && parent && parent.editMode != 3)
         {
            if(parent.hitTestSource == this)
            {
               parent.displayObject.setHitArea(this);
            }
            if(parent.mask == this)
            {
               parent.displayObject.setMask(this);
            }
         }
      }
   }
}

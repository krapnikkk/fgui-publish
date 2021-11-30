package fairygui.utils
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class CharSize
   {
      
      private static var testTextField:TextField;
      
      private static var testTextField2:TextField;
      
      private static var testTextFormat:TextFormat;
      
      private static var results:Object;
      
      private static var boldResults:Object;
      
      private static var holderResults:Object;
      
      private static var helperBmd:BitmapData;
      
      public static var TEST_STRING:String = "fj|_我案爱";
       
      
      public function CharSize()
      {
         super();
      }
      
      public static function getSize(param1:int, param2:String, param3:Boolean) : Object
      {
         if(!testTextField)
         {
            testTextField = new TextField();
            testTextField.autoSize = "left";
            testTextField.text = TEST_STRING;
            if(!testTextFormat)
            {
               testTextFormat = new TextFormat();
            }
            results = {};
            boldResults = {};
         }
         var _loc5_:Object = !!param3?boldResults[param2]:results[param2];
         if(!_loc5_)
         {
            _loc5_ = {};
            if(param3)
            {
               boldResults[param2] = _loc5_;
            }
            else
            {
               results[param2] = _loc5_;
            }
         }
         var _loc4_:Object = _loc5_[param1];
         if(_loc4_)
         {
            return _loc4_;
         }
         _loc4_ = {};
         _loc5_[param1] = _loc4_;
         testTextFormat.font = param2;
         testTextFormat.size = param1;
         testTextFormat.bold = param3;
         testTextField.setTextFormat(testTextFormat);
         testTextField.embedFonts = FontUtils.isEmbeddedFont(testTextFormat);
         _loc4_.height = testTextField.textHeight;
         if(_loc4_.height == 0)
         {
            _loc4_.height = param1;
         }
         if(helperBmd == null || helperBmd.width < testTextField.width || helperBmd.height < testTextField.height)
         {
            helperBmd = new BitmapData(Math.max(128,testTextField.width),Math.max(128,testTextField.height),true,0);
         }
         else
         {
            helperBmd.fillRect(helperBmd.rect,0);
         }
         helperBmd.draw(testTextField);
         var _loc6_:Rectangle = helperBmd.getColorBoundsRect(4278190080,0,false);
         _loc4_.yIndent = _loc6_.top - 2 - int((_loc4_.height - Math.max(_loc6_.height,param1)) / 2);
         if(_loc4_.yIndent < 0)
         {
            _loc4_.yIndent = 0;
         }
         return _loc4_;
      }
      
      public static function getHolderWidth(param1:String, param2:int) : int
      {
         if(!testTextField2)
         {
            testTextField2 = new TextField();
            testTextField2.autoSize = "left";
            testTextField2.text = "　";
            if(!testTextFormat)
            {
               testTextFormat = new TextFormat();
            }
            holderResults = {};
         }
         var _loc4_:Object = holderResults[param1];
         if(!_loc4_)
         {
            _loc4_ = {};
            holderResults[param1] = _loc4_;
         }
         var _loc3_:Object = _loc4_[param2];
         if(_loc3_ == null)
         {
            testTextFormat.font = param1;
            testTextFormat.size = param2;
            testTextFormat.bold = false;
            testTextField2.setTextFormat(testTextFormat);
            testTextField2.embedFonts = FontUtils.isEmbeddedFont(testTextFormat);
            _loc3_ = testTextField2.textWidth;
            _loc4_[param2] = _loc3_;
         }
         return int(_loc3_);
      }
      
      public static function getFontSizeByHeight(param1:Number, param2:String) : int
      {
         var _loc3_:Number = NaN;
         var _loc6_:* = 0;
         var _loc5_:* = int(param1);
         var _loc4_:int = param1 / 2;
         while(_loc5_ - _loc6_ > 1)
         {
            _loc3_ = getSize(_loc4_,param2,false).height;
            if(Math.abs(param1 - _loc3_) < 1)
            {
               return _loc4_;
            }
            if(_loc3_ > param1)
            {
               _loc5_ = _loc4_;
            }
            else
            {
               _loc6_ = _loc4_;
            }
            _loc4_ = _loc6_ + (_loc5_ - _loc6_) / 2;
         }
         return _loc4_;
      }
   }
}

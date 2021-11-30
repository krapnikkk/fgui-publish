package fairygui.editor.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ImageFillUtils
   {
      
      private static var helperBitmap:Bitmap;
      
      private static var helperBmd:BitmapData = new BitmapData(512,512,true,0);
      
      private static var helperMatrix:Matrix = new Matrix();
      
      private static var helperRect:Rectangle = new Rectangle();
       
      
      public function ImageFillUtils()
      {
         super();
      }
      
      public static function fillImage(param1:String, param2:Number, param3:int, param4:Boolean, param5:BitmapData) : BitmapData
      {
         var _loc7_:BitmapData = null;
         if(param2 >= 0.999)
         {
            return param5;
         }
         if(!param5.transparent)
         {
            _loc7_ = new BitmapData(param5.width,param5.height,true,0);
            _loc7_.copyPixels(param5,param5.rect,new Point(0,0));
            param5.dispose();
            param5 = _loc7_;
         }
         if(param2 <= 0.001)
         {
            param5.fillRect(param5.rect,0);
            return param5;
         }
         if(helperBitmap == null)
         {
            helperBitmap = new Bitmap();
            helperBitmap.blendMode = "layer";
            helperBitmap.bitmapData = helperBmd;
         }
         var _loc6_:int = Math.ceil(Math.sqrt(Math.pow(param5.width * 2,2) + Math.pow(param5.height * 2,2)));
         if(_loc6_ % 2 != 0)
         {
            _loc6_++;
         }
         if(_loc6_ > helperBmd.width)
         {
            helperBmd.dispose();
            helperBmd = new BitmapData(_loc6_,_loc6_,true,0);
            helperBitmap.bitmapData = helperBmd;
         }
         var _loc8_:* = param1;
         if("hz" !== _loc8_)
         {
            if("vt" !== _loc8_)
            {
               if("radial90" !== _loc8_)
               {
                  if("radial180" !== _loc8_)
                  {
                     if("radial360" === _loc8_)
                     {
                        fillRadial360(param3,param2,param4,param5);
                     }
                  }
                  else
                  {
                     fillRadial180(param3,param2,param4,param5);
                  }
               }
               else
               {
                  fillRadial90(param3,param2,param4,param5);
               }
            }
            else
            {
               fillVertical(param3,param2,param5);
            }
         }
         else
         {
            fillHorizontal(param3,param2,param5);
         }
         return param5;
      }
      
      public static function fillHorizontal(param1:int, param2:Number, param3:BitmapData) : void
      {
         if(param1 == 0)
         {
            param3.fillRect(new Rectangle(param3.width * param2,0,param3.width * (1 - param2),param3.height),0);
         }
         else
         {
            param3.fillRect(new Rectangle(0,0,param3.width * (1 - param2),param3.height),0);
         }
      }
      
      public static function fillVertical(param1:int, param2:Number, param3:BitmapData) : void
      {
         if(param1 == 0)
         {
            param3.fillRect(new Rectangle(0,param3.height * param2,param3.width,param3.height * (1 - param2)),0);
         }
         else
         {
            param3.fillRect(new Rectangle(0,0,param3.width,param3.height * (1 - param2)),0);
         }
      }
      
      public static function fillRadial90(param1:int, param2:Number, param3:Boolean, param4:BitmapData) : void
      {
         var _loc5_:Point = null;
         helperMatrix.identity();
         switch(int(param1))
         {
            case 0:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979 / 2);
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979 / 2);
               }
               break;
            case 1:
               if(param3)
               {
                  helperMatrix.rotate((1 + param2) * 3.14159265358979 / 2);
               }
               else
               {
                  helperMatrix.rotate((1 - param2) * 3.14159265358979 / 2);
               }
               helperMatrix.translate(param4.width,0);
               break;
            case 2:
               if(param3)
               {
                  helperMatrix.rotate(-(1 - param2) * 3.14159265358979 / 2);
                  helperMatrix.translate(0,param4.height);
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979 / 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(0,helperBmd.height));
                  helperMatrix.translate(-_loc5_.x,param4.height - _loc5_.y);
               }
               break;
            case 3:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979 / 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width,helperBmd.height));
                  helperMatrix.translate(param4.width - _loc5_.x,param4.height - _loc5_.y);
                  break;
               }
               helperMatrix.rotate((1 - param2) * 3.14159265358979 / 2);
               _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width,0));
               helperMatrix.translate(param4.width - _loc5_.x,param4.height - _loc5_.y);
               break;
         }
         applyMask(param4);
      }
      
      public static function fillRadial180(param1:int, param2:Number, param3:Boolean, param4:BitmapData) : void
      {
         var _loc5_:Point = null;
         helperMatrix.identity();
         switch(int(param1))
         {
            case 0:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,0));
               }
               else
               {
                  helperMatrix.rotate((1 - param2) * 3.14159265358979);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,helperBmd.height));
               }
               helperMatrix.translate(param4.width / 2 - _loc5_.x,-_loc5_.y);
               break;
            case 1:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,helperBmd.height));
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,helperBmd.height));
               }
               helperMatrix.translate(param4.width / 2 - _loc5_.x,param4.height - _loc5_.y);
               break;
            case 2:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979 - 3.14159265358979 / 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,0));
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979 + 3.14159265358979 / 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,helperBmd.height));
               }
               helperMatrix.translate(-_loc5_.x,param4.height / 2 - _loc5_.y);
               break;
            case 3:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979 - 3.14159265358979 / 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,helperBmd.height));
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979 + 3.14159265358979 / 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,0));
               }
               helperMatrix.translate(param4.width - _loc5_.x,param4.height / 2 - _loc5_.y);
         }
         applyMask(param4);
      }
      
      public static function fillRadial360(param1:int, param2:Number, param3:Boolean, param4:BitmapData) : void
      {
         var _loc5_:Point = null;
         helperMatrix.identity();
         switch(int(param1))
         {
            case 0:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979 * 2 - 3.14159265358979 / 2);
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979 * 2 + 3.14159265358979 / 2);
               }
               _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,0));
               helperMatrix.translate(param4.width / 2 - _loc5_.x,param4.height / 2 - _loc5_.y);
               if(param2 < 0.5)
               {
                  applyMask(param4,!!param3?1:0,true);
               }
               else
               {
                  applyMask(param4,!!param3?0:1,false);
               }
               break;
            case 1:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979 * 2 - 3.14159265358979 / 2);
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979 * 2 + 3.14159265358979 / 2);
               }
               _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,helperBmd.height));
               helperMatrix.translate(param4.width / 2 - _loc5_.x,param4.height / 2 - _loc5_.y);
               if(param2 < 0.5)
               {
                  applyMask(param4,!!param3?0:1,true);
               }
               else
               {
                  applyMask(param4,!!param3?1:0,false);
               }
               break;
            case 2:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979 * 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,helperBmd.height));
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979 * 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,0));
               }
               helperMatrix.translate(param4.width / 2 - _loc5_.x,param4.height / 2 - _loc5_.y);
               if(param2 < 0.5)
               {
                  applyMask(param4,!!param3?2:3,true);
               }
               else
               {
                  applyMask(param4,!!param3?3:2,false);
               }
               break;
            case 3:
               if(param3)
               {
                  helperMatrix.rotate(param2 * 3.14159265358979 * 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,0));
               }
               else
               {
                  helperMatrix.rotate(-param2 * 3.14159265358979 * 2);
                  _loc5_ = helperMatrix.transformPoint(new Point(helperBmd.width / 2,helperBmd.height));
               }
               helperMatrix.translate(param4.width / 2 - _loc5_.x,param4.height / 2 - _loc5_.y);
               if(param2 < 0.5)
               {
                  applyMask(param4,!!param3?3:2,true);
                  break;
               }
               applyMask(param4,!!param3?2:3,false);
               break;
         }
      }
      
      private static function applyMask(param1:BitmapData, param2:int = -1, param3:Boolean = false) : void
      {
         switch(int(param2))
         {
            case 0:
               helperRect.setTo(0,0,param1.width / 2,param1.height);
               break;
            case 1:
               helperRect.setTo(param1.width / 2,0,param1.width / 2,param1.height);
               break;
            case 2:
               helperRect.setTo(0,0,param1.width,param1.height / 2);
               break;
            case 3:
               helperRect.setTo(0,param1.height / 2,param1.width,param1.height / 2);
         }
         param1.draw(helperBitmap,helperMatrix,null,"alpha",helperRect);
         if(param3)
         {
            switch(int(param2))
            {
               case 0:
                  helperRect.setTo(param1.width / 2,0,param1.width / 2,param1.height);
                  break;
               case 1:
                  helperRect.setTo(0,0,param1.width / 2,param1.height);
                  break;
               case 2:
                  helperRect.setTo(0,param1.height / 2,param1.width,param1.height / 2);
                  break;
               case 3:
                  helperRect.setTo(0,0,param1.width,param1.height / 2);
            }
            param1.fillRect(helperRect,0);
         }
      }
   }
}

package fairygui.editor.gui
{
   import fairygui.editor.plugin.PlugInManager;
   import fairygui.editor.utils.UtilsStr;
   
   public class ETransitionValue
   {
       
      
      public var a:Number;
      
      public var b:Number;
      
      public var alpha:Number;
      
      public var rotation:Number;
      
      public var color:uint;
      
      public var playing:Boolean;
      
      public var frame:int;
      
      public var aniName:String;
      
      public var sound:String;
      
      public var volume:int;
      
      public var label:String;
      
      public var transName:String;
      
      public var transTimes:int;
      
      public var shakeAmplitude:int;
      
      public var shakePeriod:Number;
      
      public var visible:Boolean;
      
      public var c:Number;
      
      public var d:Number;
      
      public var aEnabled:Boolean;
      
      public var bEnabled:Boolean;
      
      public var filter_cb:Number = 0;
      
      public var filter_cc:Number = 0;
      
      public var filter_cs:Number = 0;
      
      public var filter_ch:Number = 0;
      
      public var sText:String;
      
      public function ETransitionValue()
      {
         super();
         this.aEnabled = true;
         this.bEnabled = true;
         this.transTimes = 1;
      }
      
      public function assign(param1:ETransitionValue) : void
      {
         this.a = param1.a;
         this.b = param1.b;
         this.alpha = param1.alpha;
         this.rotation = param1.rotation;
         this.color = param1.color;
         this.playing = param1.playing;
         this.frame = param1.frame;
         this.aEnabled = param1.aEnabled;
         this.bEnabled = param1.bEnabled;
         this.sound = param1.sound;
         this.volume = param1.volume;
         this.transName = param1.transName;
         this.transTimes = param1.transTimes;
         this.shakeAmplitude = param1.shakeAmplitude;
         this.shakePeriod = param1.shakePeriod;
         this.c = param1.c;
         this.d = param1.d;
         this.visible = param1.visible;
         this.filter_cb = param1.filter_cb;
         this.filter_cc = param1.filter_cc;
         this.filter_cs = param1.filter_cs;
         this.filter_ch = param1.filter_ch;
         this.aniName = param1.aniName;
      }
      
      public function decode(param1:String, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = param1;
         if("XY" !== _loc4_)
         {
            if("XYV" !== _loc4_)
            {
               if("Size" !== _loc4_)
               {
                  if("Pivot" !== _loc4_)
                  {
                     if("Alpha" !== _loc4_)
                     {
                        if("Rotation" !== _loc4_)
                        {
                           if("Scale" !== _loc4_)
                           {
                              if("Skew" !== _loc4_)
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
                                                         if("Icon" !== _loc4_)
                                                         {
                                                         }
                                                      }
                                                      addr389:
                                                      this.sText = param2;
                                                   }
                                                   else
                                                   {
                                                      _loc3_ = param2.split(",");
                                                      if(_loc3_.length >= 4)
                                                      {
                                                         this.filter_cb = parseFloat(_loc3_[0]);
                                                         this.filter_cc = parseFloat(_loc3_[1]);
                                                         this.filter_cs = parseFloat(_loc3_[2]);
                                                         this.filter_ch = parseFloat(_loc3_[3]);
                                                      }
                                                   }
                                                   §§goto(addr389);
                                                }
                                                else
                                                {
                                                   this.visible = param2 == "true";
                                                }
                                             }
                                             else
                                             {
                                                _loc3_ = param2.split(",");
                                                this.shakeAmplitude = parseInt(_loc3_[0]);
                                                this.shakePeriod = parseFloat(_loc3_[1]);
                                                if(isNaN(this.shakePeriod))
                                                {
                                                   this.shakePeriod = 0.3;
                                                }
                                             }
                                          }
                                          else
                                          {
                                             _loc3_ = param2.split(",");
                                             this.transName = _loc3_[0];
                                             if(_loc3_.length > 1)
                                             {
                                                this.transTimes = parseInt(_loc3_[1]);
                                             }
                                             else
                                             {
                                                this.transTimes = 1;
                                             }
                                          }
                                       }
                                       else
                                       {
                                          _loc3_ = param2.split(",");
                                          this.sound = _loc3_[0];
                                          if(_loc3_.length > 1)
                                          {
                                             this.volume = parseInt(_loc3_[1]);
                                          }
                                          else
                                          {
                                             this.volume = 0;
                                          }
                                       }
                                    }
                                    else
                                    {
                                       _loc3_ = param2.split(",");
                                       if(_loc3_[0] == "-")
                                       {
                                          this.aEnabled = false;
                                       }
                                       else
                                       {
                                          this.frame = parseInt(_loc3_[0]);
                                          this.aEnabled = true;
                                       }
                                       this.playing = _loc3_.length == 1 || _loc3_[1] == "p";
                                       this.aniName = !!_loc3_[2]?_loc3_[2]:"";
                                    }
                                 }
                                 else
                                 {
                                    this.color = UtilsStr.convertFromHtmlColor(param2,false);
                                 }
                              }
                              else
                              {
                                 _loc3_ = param2.split(",");
                                 this.a = parseFloat(_loc3_[0]);
                                 this.b = parseFloat(_loc3_[1]);
                                 if(isNaN(this.a))
                                 {
                                    this.a = 0;
                                 }
                                 if(isNaN(this.b))
                                 {
                                    this.b = 0;
                                 }
                              }
                           }
                           else
                           {
                              _loc3_ = param2.split(",");
                              this.a = parseFloat(_loc3_[0]);
                              this.b = parseFloat(_loc3_[1]);
                              if(isNaN(this.a))
                              {
                                 this.a = 1;
                              }
                              if(isNaN(this.b))
                              {
                                 this.b = 1;
                              }
                           }
                        }
                        else
                        {
                           this.rotation = parseInt(param2);
                        }
                     }
                     else
                     {
                        this.alpha = parseFloat(param2);
                        if(isNaN(this.alpha))
                        {
                           this.alpha = 1;
                        }
                     }
                  }
                  addr445:
                  return;
               }
               addr11:
               _loc3_ = param2.split(",");
               if(_loc3_[0] == "-")
               {
                  this.aEnabled = false;
               }
               else
               {
                  this.a = parseFloat(_loc3_[0]);
                  this.aEnabled = true;
               }
               if(_loc3_.length == 1 || _loc3_[1] == "-")
               {
                  this.bEnabled = false;
               }
               else
               {
                  this.b = parseFloat(_loc3_[1]);
                  this.bEnabled = true;
               }
               if(isNaN(this.a))
               {
                  this.a = 0;
               }
               if(isNaN(this.b))
               {
                  this.b = 0;
               }
               §§goto(addr445);
            }
            addr10:
            §§goto(addr11);
         }
         §§goto(addr10);
      }
      
      public function decode1(param1:String, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = param1;
         if("XY" !== _loc4_)
         {
            if("XYV" !== _loc4_)
            {
               if("Size" !== _loc4_)
               {
                  if("Pivot" !== _loc4_)
                  {
                     if("Alpha" !== _loc4_)
                     {
                        if("Rotation" !== _loc4_)
                        {
                           if("Scale" !== _loc4_)
                           {
                              if("Skew" !== _loc4_)
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
                                                         if("Icon" !== _loc4_)
                                                         {
                                                         }
                                                      }
                                                      addr397:
                                                      this.sText = param2;
                                                   }
                                                   else
                                                   {
                                                      _loc3_ = param2.split(",");
                                                      if(_loc3_.length >= 4)
                                                      {
                                                         this.filter_cb = parseFloat(_loc3_[0]);
                                                         this.filter_cc = parseFloat(_loc3_[1]);
                                                         this.filter_cs = parseFloat(_loc3_[2]);
                                                         this.filter_ch = parseFloat(_loc3_[3]);
                                                      }
                                                   }
                                                   §§goto(addr397);
                                                }
                                                else
                                                {
                                                   this.visible = param2 == "true";
                                                }
                                             }
                                             else
                                             {
                                                _loc3_ = param2.split(",");
                                                this.shakeAmplitude = parseInt(_loc3_[0]);
                                                this.shakePeriod = parseFloat(_loc3_[1]);
                                                if(isNaN(this.shakePeriod))
                                                {
                                                   this.shakePeriod = 0.3;
                                                }
                                             }
                                          }
                                          else
                                          {
                                             _loc3_ = param2.split(",");
                                             this.transName = _loc3_[0];
                                             if(_loc3_.length > 1)
                                             {
                                                this.transTimes = parseInt(_loc3_[1]);
                                             }
                                             else
                                             {
                                                this.transTimes = 1;
                                             }
                                          }
                                       }
                                       else
                                       {
                                          _loc3_ = param2.split(",");
                                          this.sound = _loc3_[0];
                                          if(_loc3_.length > 1)
                                          {
                                             this.volume = parseInt(_loc3_[1]);
                                          }
                                          else
                                          {
                                             this.volume = 0;
                                          }
                                       }
                                    }
                                    else
                                    {
                                       _loc3_ = param2.split(",");
                                       if(_loc3_[0] == "-")
                                       {
                                          this.aEnabled = false;
                                       }
                                       else
                                       {
                                          this.frame = parseInt(_loc3_[0]);
                                          this.aEnabled = true;
                                       }
                                       this.playing = _loc3_.length == 1 || _loc3_[1] == "p";
                                       this.aniName = !!_loc3_[2]?_loc3_[2]:"";
                                    }
                                 }
                                 else
                                 {
                                    this.color = UtilsStr.convertFromHtmlColor(param2,false);
                                 }
                              }
                              else
                              {
                                 _loc3_ = param2.split(",");
                                 this.a = parseFloat(_loc3_[0]);
                                 this.b = parseFloat(_loc3_[1]);
                                 if(isNaN(this.a))
                                 {
                                    this.a = 0;
                                 }
                                 if(isNaN(this.b))
                                 {
                                    this.b = 0;
                                 }
                              }
                           }
                           else
                           {
                              _loc3_ = param2.split(",");
                              this.a = parseFloat(_loc3_[0]);
                              this.b = parseFloat(_loc3_[1]);
                              if(isNaN(this.a))
                              {
                                 this.a = 1;
                              }
                              if(isNaN(this.b))
                              {
                                 this.b = 1;
                              }
                           }
                        }
                        else
                        {
                           this.rotation = parseInt(param2);
                        }
                     }
                     else
                     {
                        this.alpha = parseFloat(param2);
                        if(isNaN(this.alpha))
                        {
                           this.alpha = 1;
                        }
                     }
                  }
                  addr453:
                  return;
               }
               addr11:
               if(param1 != "Pivot")
               {
                  param2 = PlugInManager.scaseXY(param2);
               }
               _loc3_ = param2.split(",");
               if(_loc3_[0] == "-")
               {
                  this.aEnabled = false;
               }
               else
               {
                  this.a = parseFloat(_loc3_[0]);
                  this.aEnabled = true;
               }
               if(_loc3_.length == 1 || _loc3_[1] == "-")
               {
                  this.bEnabled = false;
               }
               else
               {
                  this.b = parseFloat(_loc3_[1]);
                  this.bEnabled = true;
               }
               if(isNaN(this.a))
               {
                  this.a = 0;
               }
               if(isNaN(this.b))
               {
                  this.b = 0;
               }
               §§goto(addr453);
            }
            addr10:
            §§goto(addr11);
         }
         §§goto(addr10);
      }
      
      public function encode(param1:String) : String
      {
         var _loc2_:* = null;
         var _loc3_:* = param1;
         if("XY" !== _loc3_)
         {
            if("XYV" !== _loc3_)
            {
               if("Size" !== _loc3_)
               {
                  if("Pivot" !== _loc3_)
                  {
                     if("Alpha" !== _loc3_)
                     {
                        if("Rotation" !== _loc3_)
                        {
                           if("Scale" !== _loc3_)
                           {
                              if("Skew" !== _loc3_)
                              {
                                 if("Color" !== _loc3_)
                                 {
                                    if("Animation" !== _loc3_)
                                    {
                                       if("Sound" !== _loc3_)
                                       {
                                          if("Transition" !== _loc3_)
                                          {
                                             if("Shake" !== _loc3_)
                                             {
                                                if("Visible" !== _loc3_)
                                                {
                                                   if("ColorFilter" !== _loc3_)
                                                   {
                                                      return null;
                                                   }
                                                   return this.filter_cb.toFixed(2) + "," + this.filter_cc.toFixed(2) + "," + this.filter_cs.toFixed(2) + "," + this.filter_ch.toFixed(2);
                                                }
                                                return "" + this.visible;
                                             }
                                             return "" + this.shakeAmplitude + "," + UtilsStr.toFixed(this.shakePeriod);
                                          }
                                          if(this.transTimes != 1)
                                          {
                                             return this.transName + "," + this.transTimes;
                                          }
                                          return this.transName;
                                       }
                                       if(this.volume != 0)
                                       {
                                          return this.sound + "," + this.volume;
                                       }
                                       return this.sound;
                                    }
                                    _loc2_ = "";
                                    if(this.aEnabled)
                                    {
                                       _loc2_ = _loc2_ + this.frame;
                                    }
                                    else
                                    {
                                       _loc2_ = _loc2_ + "-";
                                    }
                                    _loc2_ = _loc2_ + ("," + (!!this.playing?"p":"s"));
                                    _loc2_ = _loc2_ + ("," + this.aniName);
                                    return _loc2_;
                                 }
                                 return UtilsStr.convertToHtmlColor(this.color,false);
                              }
                           }
                           return "" + UtilsStr.toFixed(this.a) + "," + UtilsStr.toFixed(this.b);
                        }
                        return "" + Math.floor(this.rotation);
                     }
                     return "" + UtilsStr.toFixed(this.alpha);
                  }
               }
               addr10:
               _loc2_ = "";
               if(this.aEnabled)
               {
                  _loc2_ = _loc2_ + UtilsStr.toFixed(this.a);
               }
               else
               {
                  _loc2_ = _loc2_ + "-";
               }
               _loc2_ = _loc2_ + ",";
               if(this.bEnabled)
               {
                  _loc2_ = _loc2_ + UtilsStr.toFixed(this.b);
               }
               else
               {
                  _loc2_ = _loc2_ + "-";
               }
               return _loc2_;
            }
            addr9:
            §§goto(addr10);
         }
         §§goto(addr9);
      }
   }
}

package fairygui.editor
{
   import §_-Gs§.§_-44§;
   import §_-Gs§.§_-7k§;
   import §_-NY§.§_-GM§;
   import fairygui.GObject;
   import fairygui.GRoot;
   import fairygui.UIConfig;
   import fairygui.UIPackage;
   import fairygui.editor.settings.Preferences;
   import fairygui.editor.settings.§_-D§;
   import flash.desktop.DockIcon;
   import flash.desktop.NativeApplication;
   import flash.desktop.NativeProcess;
   import flash.desktop.NativeProcessStartupInfo;
   import flash.display.NativeMenu;
   import flash.display.NativeMenuItem;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowInitOptions;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.InvokeEvent;
   import flash.filesystem.File;
   import flash.system.Capabilities;
   
   public class FairyGUIEditor extends Sprite
   {
      
      private static var §_-8b§:NativeMenu;
      
      private static var §_-Pa§:Vector.<§_-1L§>;
      
      static var §_-PI§:Boolean;
      
      private static var §_-Iz§:Boolean;
      
      private static var §_-Fs§:Boolean;
      
      private static var §_-O0§:Class = §_-Db§;
      
      private static var §_-Pn§:Class = §_-3X§;
       
      
      public function FairyGUIEditor()
      {
         var _loc2_:NativeMenuItem = null;
         super();
         stage.frameRate = 24;
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.color = 3684408;
         §_-Pa§ = new Vector.<§_-1L§>();
         XML.ignoreWhitespace = true;
         var _loc1_:UIPackage = UIPackage.addPackage(new §_-O0§(),null);
         _loc1_.loadAllImages();
         _loc1_ = UIPackage.addPackage(new §_-Pn§(),null);
         _loc1_.loadAllImages();
         Preferences.load();
         §_-D§.load();
         Consts.init();
         Consts.auxLineSize = stage.contentsScaleFactor;
         §_-44§.init();
         if(Consts.isMacOS)
         {
            §_-8b§ = new NativeMenu();
            DockIcon(NativeApplication.nativeApplication.icon).menu = §_-8b§;
            §_-8b§.addItem(new NativeMenuItem("",true));
            _loc2_ = new NativeMenuItem(Consts.strings.text311);
            _loc2_.data = -1;
            §_-8b§.addItem(_loc2_);
            §_-8b§.addEventListener(Event.SELECT,this.§_-J1§);
            §_-8b§.addEventListener(Event.PREPARING,this.§_-Q0§);
            UIPackage.setVar("os","mac");
         }
         UIPackage.waitToLoadCompleted(this.§_-B2§);
         §_-Iz§ = true;
      }
      
      public static function get §_-8Y§() : Vector.<§_-1L§>
      {
         return §_-Pa§;
      }
      
      public static function §_-BW§(param1:String, param2:Boolean = false) : §_-1L§
      {
         var _loc3_:§_-1L§ = null;
         var _loc6_:int = 0;
         if(param1)
         {
            if(!param2)
            {
               _loc3_ = §_-C§(param1);
               if(_loc3_)
               {
                  _loc3_.nativeWindow.activate();
                  NativeApplication.nativeApplication.activate(_loc3_.nativeWindow);
                  return _loc3_;
               }
            }
            _loc6_ = 0;
            while(_loc6_ < §_-8Y§.length)
            {
               _loc3_ = §_-8Y§[_loc6_];
               if(!_loc3_.project)
               {
                  _loc3_.openProject(param1);
                  if(param2)
                  {
                     _loc3_.nativeWindow.visible = false;
                     _loc3_.forPublish = true;
                  }
                  else
                  {
                     _loc3_.nativeWindow.activate();
                     NativeApplication.nativeApplication.activate(_loc3_.nativeWindow);
                  }
                  return _loc3_;
               }
               _loc6_++;
            }
         }
         var _loc4_:NativeWindowInitOptions = new NativeWindowInitOptions();
         _loc4_.resizable = true;
         _loc4_.maximizable = true;
         _loc4_.minimizable = true;
         var _loc5_:NativeWindow = new NativeWindow(_loc4_);
         _loc5_.width = 1000;
         _loc5_.height = 600;
         _loc5_.x = Math.max(0,(Capabilities.screenResolutionX - _loc5_.width) / 2);
         _loc5_.y = Math.max(0,(Capabilities.screenResolutionY - _loc5_.height) / 2);
         _loc5_.title = Consts.strings.text84;
         _loc5_.addEventListener(Event.CLOSE,§_-MW§);
         _loc3_ = new §_-1L§();
         _loc5_.stage.addChild(_loc3_);
         §_-8Y§.push(_loc3_);
         _loc3_.create(param1,param2);
         if(!param2)
         {
            _loc5_.activate();
            NativeApplication.nativeApplication.activate(_loc5_);
         }
         else
         {
            _loc5_.visible = false;
         }
         return _loc3_;
      }
      
      public static function §_-C§(param1:String) : §_-1L§
      {
         var _loc2_:File = null;
         var _loc3_:int = 0;
         var _loc4_:§_-1L§ = null;
         if(param1)
         {
            _loc2_ = new File(param1);
            if(!_loc2_.isDirectory)
            {
               _loc2_ = _loc2_.parent;
            }
            _loc2_.canonicalize();
            param1 = _loc2_.nativePath;
            _loc3_ = 0;
            while(_loc3_ < §_-8Y§.length)
            {
               _loc4_ = §_-8Y§[_loc3_];
               if(_loc4_.project && _loc4_.project.basePath == param1)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < §_-8Y§.length)
            {
               _loc4_ = §_-8Y§[_loc3_];
               if(!_loc4_.project)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      public static function §_-Eb§(param1:GObject) : §_-1L§
      {
         var _loc4_:§_-1L§ = null;
         var _loc2_:GRoot = param1.root;
         var _loc3_:int = 0;
         while(_loc3_ < §_-8Y§.length)
         {
            _loc4_ = §_-8Y§[_loc3_];
            if(_loc4_.groot == _loc2_)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function §_-A9§() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < §_-8Y§.length)
         {
            §_-8Y§[_loc1_].queryToClose();
            _loc1_++;
         }
      }
      
      public static function §_-GC§() : void
      {
         §_-PI§ = true;
         §_-A9§();
      }
      
      private static function §_-MW§(param1:Event) : void
      {
         var _loc4_:File = null;
         var _loc5_:File = null;
         var _loc6_:NativeProcessStartupInfo = null;
         var _loc7_:NativeProcess = null;
         var _loc2_:NativeWindow = NativeWindow(param1.currentTarget);
         var _loc3_:int = 0;
         while(_loc3_ < §_-8Y§.length)
         {
            if(§_-8Y§[_loc3_].nativeWindow == _loc2_)
            {
               §_-8Y§.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         if(§_-8Y§.length == 0)
         {
            if(§_-PI§)
            {
               _loc4_ = new File(new File(File.applicationDirectory.url).nativePath);
               if(Consts.isMacOS)
               {
                  _loc5_ = _loc4_.resolvePath("../MacOS/FairyGUI-Editor");
               }
               else
               {
                  _loc5_ = _loc4_.resolvePath("FairyGUI-Editor.exe");
               }
               _loc6_ = new NativeProcessStartupInfo();
               _loc6_.executable = _loc5_;
               _loc7_ = new NativeProcess();
               _loc7_.start(_loc6_);
            }
            NativeApplication.nativeApplication.exit();
         }
      }
      
      private function §_-B2§() : void
      {
         if(stage.contentsScaleFactor != 1 && !Consts.isMacOS)
         {
            UIConfig.defaultFont = "MicroSoft YaHei,Tahoma,_sans";
         }
         else
         {
            UIConfig.defaultFont = "Tahoma,_sans";
         }
         UIConfig.defaultScrollBounceEffect = false;
         UIConfig.defaultScrollTouchEffect = false;
         UIConfig.modalLayerAlpha = 0;
         UIConfig.verticalScrollBar = "ui://Basic/ScrollBar_VT";
         UIConfig.horizontalScrollBar = "ui://Basic/ScrollBar_HZ";
         UIConfig.popupMenu = "ui://Basic/PopupMenu";
         UIConfig.popupMenu_seperator = "ui://Basic/MenuSeperator";
         UIConfig.tooltipsWin = "ui://Basic/TooltipsWin";
         UIConfig.defaultComboBoxVisibleItemCount = int.MAX_VALUE;
         §_-7k§.§_-DL§();
         §_-3n§.start();
         NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,this.§_-Ep§);
         NativeApplication.nativeApplication.addEventListener(Event.EXITING,this.§_-DF§);
         if(§_-Fs§)
         {
            §_-GM§.run();
         }
         else
         {
            §_-BW§(null);
         }
         §_-Iz§ = false;
      }
      
      private function §_-Ep§(param1:InvokeEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:File = null;
         if(param1.arguments.length > 0)
         {
            _loc4_ = param1.arguments[0];
            if(_loc4_.charAt(0) != "-")
            {
               if(param1.currentDirectory != null)
               {
                  _loc5_ = param1.currentDirectory.resolvePath(_loc4_);
                  if(_loc5_.exists)
                  {
                     §_-BW§(_loc5_.nativePath);
                     return;
                  }
               }
            }
            else if(§_-GM§.parse(param1))
            {
               if(§_-Iz§)
               {
                  §_-Fs§ = true;
               }
               else
               {
                  §_-GM§.run();
               }
               return;
            }
         }
         if(Consts.isMacOS)
         {
            return;
         }
         var _loc3_:§_-1L§ = §_-C§(null);
         if(_loc3_)
         {
            _loc3_.nativeWindow.activate();
            NativeApplication.nativeApplication.activate(_loc3_.nativeWindow);
         }
         else
         {
            §_-BW§(null);
         }
      }
      
      private function §_-DF§(param1:Event) : void
      {
         NativeApplication.nativeApplication.activate();
         §_-A9§();
      }
      
      private function §_-J1§(param1:Event) : void
      {
         var _loc3_:NativeWindow = null;
         var _loc2_:int = int(param1.target.data);
         if(_loc2_ == -1)
         {
            §_-BW§(null);
         }
         else
         {
            _loc3_ = §_-8Y§[_loc2_].nativeWindow;
            _loc3_.activate();
            NativeApplication.nativeApplication.activate(_loc3_);
         }
      }
      
      private function §_-Q0§(param1:Event) : void
      {
         var _loc4_:NativeMenuItem = null;
         var _loc7_:§_-1L§ = null;
         var _loc8_:String = null;
         var _loc2_:int = §_-8b§.numItems - 2;
         var _loc3_:int = 0;
         var _loc5_:NativeWindow = NativeApplication.nativeApplication.activeWindow;
         var _loc6_:int = 0;
         while(_loc6_ < §_-8Y§.length)
         {
            _loc7_ = §_-8Y§[_loc6_];
            if(!_loc7_.forPublish)
            {
               if(_loc7_.project)
               {
                  _loc8_ = _loc7_.project.name;
               }
               else
               {
                  _loc8_ = Consts.strings.text427;
               }
               if(_loc3_ >= _loc2_)
               {
                  _loc4_ = new NativeMenuItem(_loc8_);
                  §_-8b§.addItemAt(_loc4_,_loc3_);
                  _loc4_.data = _loc6_;
               }
               else
               {
                  _loc4_ = §_-8b§.getItemAt(_loc3_);
                  _loc4_.label = _loc8_;
                  _loc4_.data = _loc6_;
               }
               _loc4_.checked = _loc7_.active;
               _loc3_++;
            }
            _loc6_++;
         }
         if(_loc3_ < _loc2_)
         {
            _loc6_ = _loc3_;
            while(_loc6_ < _loc2_)
            {
               §_-8b§.removeItemAt(_loc6_);
               _loc6_++;
            }
         }
      }
   }
}

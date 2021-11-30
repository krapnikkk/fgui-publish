package fairygui.editor.animation
{
   import dragonBones.flash.FlashArmatureDisplay;
   import dragonBones.flash.FlashFactory;
   import dragonBones.objects.AnimationData;
   import dragonBones.objects.DragonBonesData;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.utils.Dictionary;
   import spine.SkeletonData;
   import spine.SkeletonJson;
   import spine.animation.AnimationStateData;
   import spine.atlas.Atlas;
   import spine.attachments.AtlasAttachmentLoader;
   import spine.flash.FlashTextureLoader;
   import spine.flash.SkeletonAnimation;
   
   public class BaseBone extends Sprite
   {
       
      
      private var _def:BoneDef;
      
      public var actionsName:Array;
      
      public var selectActionIndex:int = -1;
      
      private var spinActionInfo:Dictionary = null;
      
      private var _armatureDisplay = null;
      
      private var _loader1:URLLoader;
      
      private var _loader2:URLLoader;
      
      private var _loader3:Loader;
      
      private var isPlay:Boolean = false;
      
      private var frame:int = 0;
      
      public var _selectActionName:String = "";
      
      private var ok1:Boolean = false;
      
      private var ok2:Boolean = false;
      
      private var ok3:Boolean = false;
      
      public function BaseBone()
      {
         actionsName = [];
         super();
      }
      
      public function get def() : BoneDef
      {
         return this._def;
      }
      
      public function removeSelf() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         if(_armatureDisplay)
         {
            if(this._armatureDisplay is FlashArmatureDisplay)
            {
               this._armatureDisplay.dispose();
            }
            if(_armatureDisplay.parent)
            {
               this.removeChild(_armatureDisplay);
            }
         }
         _armatureDisplay = null;
         this._def = null;
      }
      
      public function get aniFrameCount() : int
      {
         if(_armatureDisplay is FlashArmatureDisplay)
         {
            return (_armatureDisplay.animation.animations[this.selectActionName] as AnimationData).frameCount;
         }
         return this.spinActionInfo[this.selectActionName];
      }
      
      public function set def(param1:BoneDef) : void
      {
         var _loc2_:* = null;
         this._def = param1;
         if(this._def.skeJson && this._def.texture && this._def.skeJson)
         {
            _loc2_ = JSON.parse(this._def.skeJson);
            if(this._def.movieTye == 1)
            {
               this.createDragon(_loc2_);
            }
            else if(this._def.movieTye == 2)
            {
               this.createSpine(_loc2_);
            }
         }
      }
      
      private function createDragon(param1:Object) : void
      {
         var _loc6_:int = 0;
         var _loc3_:* = undefined;
         this._def.boneName = param1.name;
         var _loc4_:String = param1.armature[0].name;
         var _loc5_:String = param1.armature[0].animation[0].name;
         this.actionsName = [];
         _loc6_ = 0;
         while(_loc6_ < param1.armature[0].animation.length)
         {
            this.actionsName.push(param1.armature[0].animation[_loc6_].name);
            _loc6_++;
         }
         var _loc2_:DragonBonesData = FlashFactory.factory.getDragonBonesData(this._def.boneName);
         if(_loc2_ == null)
         {
            _loc2_ = FlashFactory.factory.parseDragonBonesData(JSON.parse(this._def.skeJson));
            FlashFactory.factory.parseTextureAtlasData(JSON.parse(this._def.texJson),this._def.texture.bitmapData);
         }
         if(_loc2_)
         {
            _loc3_ = _loc2_.armatureNames;
            _armatureDisplay = FlashFactory.factory.buildArmatureDisplay(_loc4_);
            _armatureDisplay.x = 0;
            _armatureDisplay.y = 0;
            this.addChild(_armatureDisplay);
            _armatureDisplay.animation.play(_loc5_,0);
         }
      }
      
      private function createSpine(param1:Object) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Atlas = new Atlas(this._def.texJson,new FlashTextureLoader(this._def.texture.bitmapData));
         var _loc3_:SkeletonJson = new SkeletonJson(new AtlasAttachmentLoader(_loc7_));
         var _loc2_:SkeletonData = _loc3_.readSkeletonData(JSON.parse(this._def.skeJson));
         var _loc5_:String = _loc2_.animations[0].name;
         this.actionsName = [];
         this.spinActionInfo = new Dictionary();
         _loc6_ = 0;
         while(_loc6_ < _loc2_.animations.length)
         {
            this.actionsName.push(_loc2_.animations[_loc6_].name);
            this.spinActionInfo[_loc2_.animations[_loc6_].name] = int(_loc2_.animations[_loc6_].duration / 0.0416666666666667);
            _loc6_++;
         }
         var _loc4_:AnimationStateData = new AnimationStateData(_loc2_);
         this._armatureDisplay = new SkeletonAnimation(_loc2_,_loc4_);
         if(_loc2_ && _loc4_)
         {
            _armatureDisplay = new SkeletonAnimation(_loc2_,_loc4_);
            _armatureDisplay.x = 0;
            _armatureDisplay.y = 0;
            this.addChild(_armatureDisplay);
            _armatureDisplay.state.setAnimationByName(0,_loc5_,true);
         }
      }
      
      public function get selectActionName() : String
      {
         return this._selectActionName;
      }
      
      public function set selectActionName(param1:String) : void
      {
         this._selectActionName = param1;
         if(_armatureDisplay && _selectActionName == "" || _selectActionName == null)
         {
            _selectActionName = this.actionsName[0];
         }
      }
      
      public function setPlay(param1:Boolean, param2:int) : void
      {
         this.isPlay = param1;
         this.frame = param2;
         if(_armatureDisplay)
         {
            if(this.isPlay)
            {
               if(_armatureDisplay is FlashArmatureDisplay)
               {
                  _armatureDisplay.animation.play(this.selectActionName,0);
               }
               else
               {
                  _armatureDisplay.state.setAnimationByName(0,this.selectActionName,true);
               }
            }
            else if(_armatureDisplay is FlashArmatureDisplay)
            {
               _armatureDisplay.animation.gotoAndStopByFrame(this.selectActionName,param2);
            }
            else
            {
               _armatureDisplay.state.setAnimationByName(0,this.selectActionName,false);
               _armatureDisplay.state.getCurrent(0).animationStart = 0.0416666666666667 * param2;
               _armatureDisplay.state.getCurrent(0).animationEnd = 0.0416666666666667 * param2;
            }
         }
      }
      
      private function onLoadComplete1(param1:Event) : void
      {
         ok1 = true;
         doshow();
      }
      
      private function onLoadComplete2(param1:Event) : void
      {
         ok2 = true;
         doshow();
      }
      
      private function onLoadComplete3(param1:Event) : void
      {
         ok3 = true;
         doshow();
      }
      
      private function doshow() : void
      {
         var _loc1_:* = null;
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         if(ok1 && ok2 && ok3)
         {
            _loc1_ = FlashFactory.factory.getDragonBonesData("skeleton");
            if(_loc1_ == null)
            {
               _loc1_ = FlashFactory.factory.parseDragonBonesData(JSON.parse(_loader1.data));
               FlashFactory.factory.parseTextureAtlasData(JSON.parse(_loader2.data),_loader3.content);
            }
            if(_loc1_)
            {
               _loc3_ = _loc1_.armatureNames;
               _loc2_ = _loc3_[0];
               _armatureDisplay = FlashFactory.factory.buildArmatureDisplay(_loc2_);
               _armatureDisplay.x = 0;
               _armatureDisplay.y = 0;
               this.addChild(_armatureDisplay);
               _armatureDisplay.animation.play("melee",0);
            }
         }
      }
   }
}

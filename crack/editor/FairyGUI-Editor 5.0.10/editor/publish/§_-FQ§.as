package fairygui.editor.publish
{
   import fairygui.editor.api.IUIPackage;
   import fairygui.editor.gui.ComProperty;
   import fairygui.editor.gui.FPackageItem;
   import fairygui.editor.gui.FPackageItemType;
   import fairygui.editor.gui.animation.AniDef;
   import fairygui.editor.gui.animation.AniFrame;
   import fairygui.editor.gui.animation.AniTexture;
   import fairygui.editor.settings.PublishSettings;
   import fairygui.utils.UtilsFile;
   import fairygui.utils.UtilsStr;
   import fairygui.utils.XData;
   import fairygui.utils.XDataEnumerator;
   
   public class §_-FQ§ extends taskRun
   {
      
      private static var §_-4G§:Vector.<String> = new Vector.<String>(3,true);
       
      
      private var §_-c§:Object;
      
      private var §_-Ns§:Object;
      
      private var §_-7d§:Vector.<FPackageItem>;
      
      public function §_-FQ§()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc3_:FPackageItem = null;
         var _loc4_:String = null;
         this.§_-Ns§ = {};
         this.§_-7d§ = new Vector.<FPackageItem>();
         var _loc1_:Vector.<String> = PublishSettings(publishData.pkg.publishSettings).excludedList;
         if(_loc1_.length > 0)
         {
            this.§_-c§ = {};
            for each(_loc4_ in _loc1_)
            {
               this.§_-c§[_loc4_] = false;
            }
         }
         var _loc2_:Vector.<FPackageItem> = publishData.pkg.items;
         for each(_loc3_ in _loc2_)
         {
            _loc3_.setVar("pubInfo.added",undefined);
            _loc3_.setVar("pubInfo.highRes",undefined);
            _loc3_.setVar("pubInfo.branch",undefined);
            _loc3_.setVar("pubInfo.isFontLetter",undefined);
            _loc3_.setVar("pubInfo.keepOriginal",undefined);
            _loc3_.§_-e§ = _loc3_.id;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.exported)
            {
               this.addItem(_loc3_);
            }
         }
         while(this.§_-7d§.length > 0)
         {
            _loc3_ = this.§_-7d§.pop();
            this.§_-E1§(_loc3_);
         }
         publishData.items.sort(this.§_-NF§);
         publishData.hitTestImages.sort(this.§_-NF§);
         for each(_loc3_ in publishData.items)
         {
            _loc3_.touch();
            if(_loc3_.isError)
            {
               §_-J2§("file not exists, resource=[url=event:open]" + _loc3_.name + "[/url]",_loc3_);
            }
            _loc3_.addRef();
         }
         for each(_loc3_ in publishData.hitTestImages)
         {
            _loc3_.addRef();
         }
         _stepCallback.callOnSuccess();
      }
      
      private function §_-NF§(param1:FPackageItem, param2:FPackageItem) : int
      {
         var _loc3_:int = 0;
         if(param1.exported && !param2.exported)
         {
            return 1;
         }
         if(!param1.exported && param2.exported)
         {
            return -1;
         }
         _loc3_ = param1.type.localeCompare(param2.type);
         if(_loc3_ == 0)
         {
            _loc3_ = param1.id.localeCompare(param2.id);
         }
         return _loc3_;
      }
      
      private function addItem(param1:FPackageItem, param2:Boolean = false) : void
      {
         if(param1.getVar("pubInfo.added"))
         {
            return;
         }
         if(this.§_-c§ && this.§_-c§[param1.id] != undefined)
         {
            if(this.§_-c§[param1.id] == false)
            {
               this.§_-c§[param1.id] = true;
               publishData.§_-BH§++;
            }
            return;
         }
         param1.setVar("pubInfo.added",true);
         if(!param2 && publishData.§_-Ho§ > 0)
         {
            if(publishData.includeBranches)
            {
               if(param1.branch.length == 0)
               {
                  this.§_-HA§(param1);
               }
            }
            else if(this.mergeBranch(param1))
            {
               return;
            }
         }
         publishData.items.push(param1);
         if(param1.imageInfo)
         {
            if(publishData.§_-O4§)
            {
               this.§_-Ee§(param1);
            }
            if(param1.type == FPackageItemType.MOVIECLIP)
            {
               this.§_-ED§(param1);
            }
            if(!param2)
            {
               this.§_-Iv§(param1);
            }
         }
         else if(param1.type == FPackageItemType.COMPONENT)
         {
            this.§_-7d§.push(param1);
         }
         else if(param1.type == FPackageItemType.FONT)
         {
            this.§_-Po§(param1);
         }
      }
      
      private function §_-Iv§(param1:FPackageItem) : void
      {
         var _loc6_:FPackageItem = null;
         var _loc7_:int = 0;
         var _loc2_:int = publishData.includeHighResolution;
         var _loc3_:String = param1.path + param1.name;
         var _loc4_:int = 3;
         var _loc5_:int = 0;
         while(_loc4_ > 0)
         {
            _loc7_ = _loc4_ - 1;
            §_-4G§[_loc7_] = "";
            if((_loc2_ & 1 >> _loc7_) != 0)
            {
               _loc6_ = param1.owner.getItemByPath(_loc3_ + "@" + (_loc4_ + 1) + "x");
               if(_loc6_ && _loc6_.type == param1.type)
               {
                  this.addItem(_loc6_,true);
                  §_-4G§[_loc7_] = _loc6_.id;
                  _loc5_++;
                  break;
               }
            }
            _loc4_--;
         }
         if(_loc5_ > 0)
         {
            if(_loc5_ == 1 && §_-4G§[0])
            {
               param1.setVar("pubInfo.highRes",§_-4G§[0]);
            }
            else
            {
               param1.setVar("pubInfo.highRes",§_-4G§.join(","));
            }
         }
      }
      
      private function §_-HA§(param1:FPackageItem) : void
      {
         var _loc2_:String = null;
         var _loc3_:FPackageItem = null;
         var _loc4_:Object = null;
         var _loc8_:String = null;
         var _loc9_:* = undefined;
         var _loc5_:Vector.<String> = publishData.project.allBranches;
         var _loc6_:int = _loc5_.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc5_[_loc7_];
            _loc2_ = "/:" + _loc8_ + param1.path + param1.name;
            _loc3_ = param1.owner.getItemByPath(_loc2_);
            if(_loc3_ && _loc3_.type == param1.type)
            {
               _loc9_ = publishData.§_-GR§[_loc8_];
               if(_loc9_ == undefined)
               {
                  _loc9_ = publishData.§_-1e§;
                  publishData.§_-GR§[_loc8_] = _loc9_;
                  publishData.§_-1e§++;
               }
               if(!_loc4_)
               {
                  _loc4_ = [];
               }
               _loc4_[_loc9_] = _loc3_.id;
               this.addItem(_loc3_);
            }
            _loc7_++;
         }
         if(_loc4_)
         {
            param1.setVar("pubInfo.branch",_loc4_);
         }
      }
      
      private function mergeBranch(param1:FPackageItem) : Boolean
      {
         var _loc2_:FPackageItem = null;
         if(param1.branch.length == 0)
         {
            _loc2_ = param1.getVar("pubInfo.branch");
            if(!_loc2_)
            {
               _loc2_ = publishData.pkg.getItemByPath("/:" + publishData.branch + param1.path + param1.name);
               if(_loc2_ && _loc2_.type == param1.type)
               {
                  _loc2_.§_-e§ = param1.id;
                  param1.setVar("pubInfo.branch",_loc2_);
                  _loc2_.setVar("pubInfo.branch",param1);
                  this.addItem(_loc2_);
                  return true;
               }
               return false;
            }
            return true;
         }
         _loc2_ = param1.getVar("pubInfo.branch");
         if(!_loc2_)
         {
            _loc2_ = publishData.pkg.getItemByPath(param1.path.substr(param1.branch.length + 2) + param1.name);
            if(_loc2_ && _loc2_.type == param1.type)
            {
               param1.§_-e§ = _loc2_.id;
               param1.setVar("pubInfo.branch",_loc2_);
               _loc2_.setVar("pubInfo.branch",param1);
            }
         }
         return false;
      }
      
      private function §_-ED§(param1:FPackageItem) : void
      {
         var _loc3_:int = 0;
         var _loc4_:AniTexture = null;
         var _loc5_:int = 0;
         var _loc6_:AniFrame = null;
         var _loc7_:XData = null;
         var _loc8_:XData = null;
         var _loc9_:XData = null;
         var _loc2_:AniDef = param1.getAnimation();
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.frameCount;
            for each(_loc4_ in _loc2_.textureList)
            {
               _loc4_.exportFrame = -1;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc6_ = _loc2_.frameList[_loc5_];
               if(_loc6_.textureIndex != -1)
               {
                  _loc4_ = _loc2_.textureList[_loc6_.textureIndex];
                  if(_loc4_.raw != null && _loc4_.exportFrame == -1)
                  {
                     _loc4_.exportFrame = _loc5_;
                  }
               }
               _loc5_++;
            }
            _loc7_ = XData.create("movieclip");
            _loc7_.setAttribute("interval",int(1000 / _loc2_.fps * (_loc2_.speed != 0?_loc2_.speed:1)));
            if(_loc2_.repeatDelay)
            {
               _loc7_.setAttribute("repeatDelay",int(1000 / _loc2_.fps * _loc2_.repeatDelay));
            }
            if(_loc2_.swing)
            {
               _loc7_.setAttribute("swing",_loc2_.swing);
            }
            _loc7_.setAttribute("frameCount",_loc3_);
            _loc8_ = XData.create("frames");
            _loc7_.appendChild(_loc8_);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc6_ = _loc2_.frameList[_loc5_];
               _loc9_ = XData.create("frame");
               _loc8_.appendChild(_loc9_);
               _loc9_.setAttribute("rect",_loc6_.rect.x + "," + _loc6_.rect.y + "," + _loc6_.rect.width + "," + _loc6_.rect.height);
               if(_loc6_.delay)
               {
                  _loc9_.setAttribute("addDelay",int(1000 / _loc2_.fps * _loc6_.delay));
               }
               if(_loc6_.textureIndex != -1)
               {
                  _loc4_ = _loc2_.textureList[_loc6_.textureIndex];
                  if(_loc4_.exportFrame != -1 && _loc4_.exportFrame != _loc5_)
                  {
                     _loc9_.setAttribute("sprite",_loc4_.exportFrame);
                  }
               }
               _loc5_++;
            }
            publishData.outputDesc[param1.§_-e§ + ".xml"] = _loc7_.toXML();
            if(!publishData.§_-O4§)
            {
               for each(_loc4_ in _loc2_.textureList)
               {
                  if(_loc4_.exportFrame != -1 && _loc4_.raw)
                  {
                     publishData.outputRes[param1.§_-e§ + "_" + _loc4_.exportFrame + ".png"] = _loc4_.raw;
                  }
               }
            }
         }
      }
      
      private function §_-Ee§(param1:FPackageItem) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = param1.getAtlasIndex();
         if(_loc3_ < 0)
         {
            _loc2_ = "atlas_" + param1.§_-e§;
         }
         else
         {
            _loc2_ = "atlas" + _loc3_;
         }
         var _loc4_:AtlasItem = this.§_-Ns§[_loc2_];
         if(!_loc4_)
         {
            _loc4_ = new AtlasItem();
            _loc4_.id = _loc2_;
            _loc4_.index = _loc3_ < 0?-1:int(_loc3_);
            if(_loc3_ == -2)
            {
               _loc4_.npot = true;
            }
            else if(_loc3_ == -3)
            {
               _loc4_.mof = true;
            }
            publishData.atlases.push(_loc4_);
            this.§_-Ns§[_loc2_] = _loc4_;
         }
         _loc4_.items.push(param1);
         if(param1.imageInfo.format != "jpg")
         {
            _loc4_.alphaChannel = true;
         }
         if(_loc4_.index == -1 && _loc4_.npot)
         {
            param1.setVar("pubInfo.keepOriginal",true);
         }
      }
      
      private function §_-JW§(param1:String) : FPackageItem
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:IUIPackage = null;
         var _loc5_:String = null;
         var _loc6_:FPackageItem = null;
         if(param1 && UtilsStr.startsWith(param1,"ui://"))
         {
            _loc2_ = param1.indexOf(",");
            if(_loc2_ != -1)
            {
               param1 = param1.substr(0,_loc2_);
            }
            _loc3_ = param1.substr(5,8);
            _loc4_ = publishData.project.getPackage(_loc3_);
            if(!_loc4_)
            {
               return null;
            }
            if(_loc4_ != publishData.pkg)
            {
               publishData.§_-DJ§[_loc4_.id] = true;
               return null;
            }
            _loc5_ = param1.substr(13);
            _loc6_ = _loc4_.getItem(_loc5_);
            if(_loc6_)
            {
               this.addItem(_loc6_);
            }
            return _loc6_;
         }
         return null;
      }
      
      private function §_-E1§(param1:FPackageItem) : void
      {
         var cxml:XData = null;
         var dxml:XData = null;
         var it:XDataEnumerator = null;
         var ename:String = null;
         var cname:String = null;
         var str:String = null;
         var arr:Array = null;
         var src:String = null;
         var srcItem:FPackageItem = null;
         var hitTestXml:XData = null;
         var pkgId:String = null;
         var xml:XData = null;
         var col:Vector.<XData> = null;
         var cnt:int = 0;
         var index:int = 0;
         var defaultItem:String = null;
         var url:String = null;
         var listItem:FPackageItem = null;
         var gid:String = null;
         var pgid:String = null;
         var tp:String = null;
         var hitTestItem:FPackageItem = null;
         var pi:FPackageItem = param1;
         try
         {
            xml = UtilsFile.loadXData(pi.file);
            if(!xml)
            {
               return;
            }
         }
         catch(err:Error)
         {
            §_-J2§("XML format error, resource=[url=event:open]" + pi.name + "[/url]",pi);
            return;
         }
         xml.removeAttribute("resolution");
         xml.removeAttribute("copies");
         xml.removeAttribute("designImage");
         xml.removeAttribute("designImageOffsetX");
         xml.removeAttribute("designImageOffsetY");
         xml.removeAttribute("designImageAlpha");
         xml.removeAttribute("designImageLayer");
         xml.removeAttribute("designImageForTest");
         xml.removeAttribute("initName");
         xml.removeAttribute("bgColor");
         xml.removeAttribute("bgColorEnabled");
         xml.removeChildren("customProperty");
         var toDelete:Vector.<XData> = new Vector.<XData>();
         var classInfo:Object = {};
         classInfo.classId = pi.§_-e§;
         classInfo.className = pi.name;
         classInfo.superClassName = "G" + xml.getAttribute("extention","Component");
         if(str != "ScrollBar")
         {
            publishData.outputClasses[pi.§_-e§] = classInfo;
         }
         str = xml.getAttribute("customExtention");
         if(str)
         {
            classInfo.customSuperClassName = str;
            xml.removeAttribute("customExtention");
         }
         str = xml.getAttribute("remark");
         if(str)
         {
            classInfo.remark = str;
            xml.removeAttribute("remark");
            xml.setAttribute("customData",str);
         }
         var displayListNode:XData = xml.getChild("displayList");
         str = xml.getAttribute("hitTest");
         if(str && displayListNode)
         {
            it = displayListNode.getEnumerator();
            while(it.moveNext())
            {
               cxml = it.current;
               if(cxml.getAttribute("id") == str)
               {
                  hitTestXml = cxml;
                  break;
               }
            }
         }
         var members:Array = [];
         classInfo.members = members;
         it = xml.getEnumerator("controller");
         while(it.moveNext())
         {
            cxml = it.current;
            cxml.removeAttribute("exported");
            cxml.removeAttribute("alias");
            cxml.removeChildren("remark");
            members.push({
               "name":cxml.getAttribute("name"),
               "type":"Controller",
               "index":it.index
            });
         }
         if(displayListNode)
         {
            col = displayListNode.getChildren();
            cnt = col.length;
            index = 0;
            while(index < cnt)
            {
               cxml = col[index];
               cxml.removeAttribute("aspect");
               cxml.removeAttribute("locked");
               cxml.removeAttribute("hideByEditor");
               cxml.removeAttribute("fileName");
               ename = cxml.getName();
               cname = cxml.getAttribute("name");
               src = cxml.getAttribute("src");
               if(src)
               {
                  pkgId = cxml.getAttribute("pkg");
                  if(pkgId == publishData.pkg.id)
                  {
                     cxml.removeAttribute("pkg");
                     pkgId = null;
                  }
                  if(!pkgId)
                  {
                     srcItem = publishData.pkg.getItem(src);
                     if(srcItem)
                     {
                        this.addItem(srcItem);
                     }
                     else
                     {
                        §_-J2§("child resource missing: " + src + ", resource=[url=event:open]" + pi.name + "[/url]",pi);
                     }
                  }
                  else
                  {
                     srcItem = publishData.project.getItem(pkgId,src);
                     if(srcItem)
                     {
                        publishData.§_-DJ§[pkgId] = true;
                     }
                     else
                     {
                        §_-J2§("child resource missing: " + src + "@" + pkgId + ", resource=[url=event:open]" + pi.name + "[/url]");
                     }
                  }
               }
               switch(ename)
               {
                  case "loader":
                     if(cxml.getAttributeBool("clearOnPublish"))
                     {
                        cxml.removeAttribute("clearOnPublish");
                        cxml.removeAttribute("url");
                     }
                     else
                     {
                        this.§_-JW§(cxml.getAttribute("url"));
                     }
                     members.push({
                        "name":cname,
                        "type":"GLoader",
                        "index":index
                     });
                     break;
                  case "list":
                     if(cxml.getAttributeBool("treeView"))
                     {
                        members.push({
                           "name":cname,
                           "type":"GTree",
                           "index":index
                        });
                     }
                     else
                     {
                        members.push({
                           "name":cname,
                           "type":"GList",
                           "index":index
                        });
                     }
                     defaultItem = cxml.getAttribute("defaultItem");
                     this.§_-JW§(defaultItem);
                     if(cxml.getAttributeBool("autoClearItems"))
                     {
                        cxml.removeAttribute("autoClearItems");
                        cxml.removeChildren("item");
                     }
                     else
                     {
                        it = cxml.getEnumerator("item");
                        while(it.moveNext())
                        {
                           dxml = it.current;
                           url = dxml.getAttribute("url");
                           if(url)
                           {
                              this.§_-JW§(url);
                           }
                           str = dxml.getAttribute("icon");
                           if(str)
                           {
                              this.§_-JW§(str);
                           }
                           str = dxml.getAttribute("selectedIcon");
                           if(str)
                           {
                              this.§_-JW§(str);
                           }
                           if(dxml.getChild("property") || dxml.hasAttribute("controllers"))
                           {
                              listItem = publishData.project.getItemByURL(!!url?url:defaultItem);
                              if(listItem && listItem.type == FPackageItemType.COMPONENT)
                              {
                                 this.§_-5p§(dxml,listItem);
                              }
                              else
                              {
                                 dxml.removeChildren("property");
                                 dxml.removeAttribute("controllers");
                              }
                           }
                        }
                     }
                     str = cxml.getAttribute("scrollBarRes");
                     if(str)
                     {
                        arr = str.split(",");
                        this.§_-JW§(arr[0]);
                        this.§_-JW§(arr[1]);
                     }
                     str = cxml.getAttribute("ptrRes");
                     if(str)
                     {
                        arr = str.split(",");
                        this.§_-JW§(arr[0]);
                        this.§_-JW§(arr[1]);
                     }
                     break;
                  case "group":
                     if(!cxml.getAttributeBool("advanced"))
                     {
                        toDelete.push(cxml);
                        gid = cxml.getAttribute("id");
                        pgid = cxml.getAttribute("group");
                        for each(dxml in col)
                        {
                           if(dxml.getAttribute("group") == gid)
                           {
                              if(pgid)
                              {
                                 dxml.setAttribute("group",pgid);
                              }
                              else
                              {
                                 dxml.removeAttribute("group");
                              }
                           }
                        }
                     }
                     else
                     {
                        cxml.removeAttribute("collapsed");
                        members.push({
                           "name":cname,
                           "type":"GGroup",
                           "index":index
                        });
                     }
                     break;
                  case "text":
                  case "richtext":
                     if(ename == "text")
                     {
                        if(cxml.getAttributeBool("input"))
                        {
                           members.push({
                              "name":cname,
                              "type":"GTextInput",
                              "index":index
                           });
                        }
                        else
                        {
                           members.push({
                              "name":cname,
                              "type":"GTextField",
                              "index":index
                           });
                        }
                     }
                     else
                     {
                        members.push({
                           "name":cname,
                           "type":"GRichTextField",
                           "index":index
                        });
                     }
                     if(cxml.getAttributeBool("autoClearText"))
                     {
                        cxml.removeAttribute("autoClearText");
                        cxml.removeAttribute("text");
                     }
                     str = cxml.getAttribute("font");
                     if(str && UtilsStr.startsWith(str,"ui://") && str.length > 13)
                     {
                        pkgId = str.substr(5,8);
                        publishData.§_-DJ§[pkgId] = true;
                     }
                     break;
                  case "movieclip":
                     members.push({
                        "name":cname,
                        "type":"GMovieClip",
                        "index":index
                     });
                     break;
                  case "jta":
                     cxml.setName("movieclip");
                     members.push({
                        "name":cname,
                        "type":"GMovieClip",
                        "index":index
                     });
                     break;
                  case "image":
                     if(cxml.getAttributeBool("forHitTest"))
                     {
                        hitTestXml = cxml;
                        cxml.removeAttribute("forHitTest");
                     }
                     if(cxml.getAttributeBool("forMask"))
                     {
                        xml.setAttribute("mask",cxml.getAttribute("id"));
                        cxml.removeAttribute("forMask");
                     }
                     members.push({
                        "name":cname,
                        "type":"GImage",
                        "index":index
                     });
                     break;
                  case "swf":
                     members.push({
                        "name":cname,
                        "type":"GSwfObject",
                        "index":index
                     });
                     break;
                  case "graph":
                     if(cxml.getAttributeBool("forMask"))
                     {
                        xml.setAttribute("mask",cxml.getAttribute("id"));
                        cxml.removeAttribute("forMask");
                     }
                     members.push({
                        "name":cname,
                        "type":"GGraph",
                        "index":index
                     });
                     break;
                  case "component":
                     if(srcItem)
                     {
                        if(srcItem.owner == publishData.pkg)
                        {
                           members.push({
                              "name":cname,
                              "type":"GComponent",
                              "index":index,
                              "src":srcItem.name,
                              "src_id":src
                           });
                        }
                        else
                        {
                           members.push({
                              "name":cname,
                              "type":"GComponent",
                              "index":index,
                              "src":srcItem.name,
                              "src_id":src,
                              "pkg":srcItem.owner.name,
                              "pkg_id":srcItem.owner.id
                           });
                        }
                     }
                     else
                     {
                        members.push({
                           "name":cname,
                           "type":"GComponent",
                           "index":index,
                           "src":null,
                           "src_id":src
                        });
                     }
                     dxml = cxml.getChild("Button");
                     if(dxml)
                     {
                        this.§_-JW§(dxml.getAttribute("icon"));
                        this.§_-JW§(dxml.getAttribute("selectedIcon"));
                        this.§_-JW§(dxml.getAttribute("sound"));
                     }
                     dxml = cxml.getChild("Label");
                     if(dxml)
                     {
                        this.§_-JW§(dxml.getAttribute("icon"));
                     }
                     dxml = cxml.getChild("ComboBox");
                     if(dxml)
                     {
                        it = dxml.getEnumerator("item");
                        while(it.moveNext())
                        {
                           this.§_-JW§(it.current.getAttribute("icon"));
                        }
                        if(dxml.getAttributeBool("autoClearItems"))
                        {
                           dxml.removeAttribute("autoClearItems");
                           dxml.removeChildren("item");
                        }
                     }
                     break;
                  default:
                     §_-J2§("unknown display list item type: " + ename + ", resource=[url=event:open]" + pi.name + "[/url]");
               }
               if(srcItem && ename == "component")
               {
                  this.§_-5p§(cxml,srcItem);
               }
               dxml = cxml.getChild("gearIcon");
               if(dxml)
               {
                  str = dxml.getAttribute("values");
                  if(str)
                  {
                     arr = str.split("|");
                     for each(str in arr)
                     {
                        this.§_-JW§(str);
                     }
                  }
                  this.§_-JW§(dxml.getAttribute("default"));
               }
               index++;
            }
            for each(cxml in toDelete)
            {
               displayListNode.removeChild(cxml);
            }
         }
         cxml = xml.getChild("Button");
         if(cxml)
         {
            this.§_-JW§(cxml.getAttribute("sound"));
         }
         cxml = xml.getChild("ComboBox");
         if(cxml)
         {
            this.§_-JW§(cxml.getAttribute("dropdown"));
         }
         var transIt:XDataEnumerator = xml.getEnumerator("transition");
         while(transIt.moveNext())
         {
            cxml = transIt.current;
            cname = cxml.getAttribute("name");
            members.push({
               "name":cname,
               "type":"Transition",
               "index":transIt.index
            });
            it = cxml.getEnumerator("item");
            while(it.moveNext())
            {
               tp = it.current.getAttribute("type");
               if(tp == "Sound" || tp == "Icon")
               {
                  this.§_-JW§(it.current.getAttribute("value"));
               }
            }
         }
         str = xml.getAttribute("scrollBarRes");
         if(str)
         {
            arr = str.split(",");
            this.§_-JW§(arr[0]);
            this.§_-JW§(arr[1]);
         }
         str = xml.getAttribute("ptrRes");
         if(str)
         {
            arr = str.split(",");
            this.§_-JW§(arr[0]);
            this.§_-JW§(arr[1]);
         }
         if(hitTestXml)
         {
            src = hitTestXml.getAttribute("src");
            if(src)
            {
               pkgId = hitTestXml.getAttribute("pkg");
               if(!pkgId || pkgId == publishData.pkg.id)
               {
                  xml.setAttribute("hitTest",src + "," + hitTestXml.getAttribute("xy"));
                  hitTestItem = publishData.pkg.getItem(src);
                  if(hitTestItem)
                  {
                     if(publishData.hitTestImages.indexOf(hitTestItem) == -1)
                     {
                        publishData.hitTestImages.push(hitTestItem);
                     }
                  }
               }
               else
               {
                  §_-J2§("HitTest image in another pakcage! resource=[url=event:open]" + pi.name + "[/url]");
               }
            }
            else
            {
               xml.setAttribute("hitTest",hitTestXml.getAttribute("id"));
            }
         }
         publishData.outputDesc[pi.§_-e§ + ".xml"] = xml.toXML();
      }
      
      private function §_-5p§(param1:XData, param2:FPackageItem) : void
      {
         var _loc6_:String = null;
         var _loc7_:XData = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc3_:Vector.<ComProperty> = null;
         var _loc4_:XDataEnumerator = param1.getEnumerator("property");
         var _loc5_:String = param1.getName() == "item"?"controllers":"controller";
         while(_loc4_.moveNext())
         {
            _loc7_ = _loc4_.current;
            if(!_loc3_)
            {
               _loc3_ = param2.getComponentData().getCustomProperties();
               if(!_loc3_)
               {
                  param1.removeChildren("property");
                  param1.removeAttribute(_loc5_);
                  break;
               }
            }
            _loc8_ = _loc7_.getAttribute("target");
            _loc9_ = _loc7_.getAttributeInt("propertyId");
            if(this.getCustomProperty(_loc3_,_loc8_,_loc9_))
            {
               if(_loc9_ == 1)
               {
                  _loc6_ = _loc7_.getAttribute("value");
                  if(_loc6_)
                  {
                     this.§_-JW§(_loc6_);
                  }
               }
            }
            else
            {
               _loc4_.erase();
            }
         }
         _loc6_ = param1.getAttribute(_loc5_);
         if(_loc6_)
         {
            if(!_loc3_)
            {
               _loc3_ = param2.getComponentData().getCustomProperties();
               if(!_loc3_)
               {
                  param1.removeAttribute(_loc5_);
               }
            }
            if(_loc3_)
            {
               _loc10_ = _loc6_.split(",");
               _loc11_ = _loc10_.length;
               _loc12_ = 0;
               _loc13_ = false;
               while(_loc12_ < _loc11_)
               {
                  if(!this.getCustomProperty(_loc3_,_loc10_[_loc12_],-1))
                  {
                     _loc10_.splice(_loc12_,2);
                     _loc11_ = _loc11_ - 2;
                     _loc13_ = true;
                  }
                  else
                  {
                     _loc12_ = _loc12_ + 2;
                  }
               }
               if(_loc13_)
               {
                  if(_loc11_ == 0)
                  {
                     param1.removeAttribute(_loc5_);
                  }
                  else
                  {
                     param1.setAttribute(_loc5_,_loc10_.join(","));
                  }
               }
            }
         }
      }
      
      private function getCustomProperty(param1:Vector.<ComProperty>, param2:String, param3:int) : ComProperty
      {
         var _loc6_:ComProperty = null;
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            if(_loc6_.target == param2 && _loc6_.propertyId == param3)
            {
               return _loc6_;
            }
            _loc5_++;
         }
         return null;
      }
      
      private function §_-Po§(param1:FPackageItem) : void
      {
         var _loc5_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:FPackageItem = null;
         var _loc2_:String = UtilsFile.loadString(param1.file);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Array = _loc2_.split("\n");
         var _loc4_:int = _loc3_.length;
         var _loc6_:Object = {};
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = _loc3_[_loc5_];
            if(_loc7_)
            {
               _loc8_ = _loc7_.split(" ");
               _loc9_ = 1;
               while(_loc9_ < _loc8_.length)
               {
                  _loc10_ = _loc8_[_loc9_].split("=");
                  _loc6_[_loc10_[0]] = _loc10_[1];
                  _loc9_++;
               }
               _loc7_ = _loc8_[0];
               if(_loc7_ == "char")
               {
                  _loc11_ = this.§_-JW§("ui://" + publishData.pkg.id + _loc6_.img);
                  if(_loc11_)
                  {
                     _loc11_.setVar("pubInfo.isFontLetter",true);
                  }
               }
               else if(_loc7_ == "info")
               {
                  if(_loc6_.face != undefined)
                  {
                     break;
                  }
               }
            }
            _loc5_++;
         }
         if(param1.fontSettings.texture)
         {
            _loc11_ = publishData.pkg.getItem(param1.fontSettings.texture);
            if(_loc11_)
            {
               publishData.§_-BD§[param1.fontSettings.texture] = param1;
               this.addItem(_loc11_);
               _loc11_.setVar("pubInfo.isFontLetter",true);
            }
         }
      }
   }
}

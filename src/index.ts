import ByteArray from "./utils/ByteArray";
import fs from "fs";
import { parse } from "fast-xml-parser";
import ProjectType from "./fairygui/editor/api/ProjectType";
import { type } from "os";
import { convertFromHtmlColor, isH5 } from "./utils/utils";
import FObjectType from "./fairygui/editor/api/FObjectType";
import { CurveType, EaseType, FButton, FGearBase, FPackageItemType } from "./constants";

process.on('uncaughtException', function (e) {
    console.log(e);
});



const id: string = "id",
    compress: boolean = false, // todo 从配置文件读取
    basePath = "./UIProject/",
    projectName = "example",
    extName = ".fairy",
    packageName = "package.xml",
    assetsPath = "assets/",
    hasBranch = false, // todo 
    branches = 0,
    targetPath = "./output"; // todo 从配置文件读取
let controllerCnt = 0, controllerCache: { [key: string]: any } = {}, displayList: { [key: string]: any } = {};
const stringMap: { [key: string]: number } = {},
    stringTable: string[] = [],
    xmlFileMap: { [key: string]: IComponentFile } = {},
    resourceMap: Map<string, IResource> = new Map;

const helperIntList: number[] = [];
const RelationNameToID: { [key: string]: number } = {
    "left-left": 0,
    "left-center": 1,
    "left-right": 2,
    "center-center": 3,
    "right-left": 4,
    "right-center": 5,
    "right-right": 6,
    "top-top": 7,
    "top-middle": 8,
    "top-bottom": 9,
    "middle-middle": 10,
    "bottom-top": 11,
    "bottom-middle": 12,
    "bottom-bottom": 13,
    "width-width": 14,
    "height-height": 15,
    "leftext-left": 16,
    "leftext-right": 17,
    "rightext-left": 18,
    "rightext-right": 19,
    "topext-top": 20,
    "topext-bottom": 21,
    "bottomext-top": 22,
    "bottomext-bottom": 23
};
const dependentElements = ["image", "component", "movieclip"];

let binaryFormat = false,
    projectType = ProjectType.UNITY,
    pkgId = "",
    pkgName = "Bag",
    version: number = 2,
    spriteMap: Map<string, IBaseResource> = new Map();

const xmlOptions = {
    attributeNamePrefix: "",
    // attrNodeName: "attr", //default is 'false'
    textNodeName: "#text",
    ignoreAttributes: false,
    ignoreNameSpace: false,
    allowBooleanAttributes: false,
    parseNodeValue: true,
    parseAttributeValue: false,
    trimValues: true,
    cdataTagName: "__cdata", //default is 'false'
    cdataPositionChar: "\\c",
    parseTrueNumberOnly: false,
    numParseOptions: {
        hex: true,
        leadingZeros: true,
    },
    arrayMode: false, //"strict"
    stopNodes: ["parse-me-as-string"],
    alwaysCreateTextNode: false
};

function getProjectConfig() {
    console.log("getProjectConfig");
    let xml = fs.readFileSync(`${basePath}${projectName}${extName}`).toString();
    let data = parse(xml, xmlOptions).projectDescription as IProjectDescription;
    let { type } = data;
    [projectType, version] = [type, +data.version];
}

function writeHead(ba: ByteArray, data: IPackageHeader) {
    let { version, pkgId, pkgName } = data;
    ba.writeByte("F".charCodeAt(0));
    ba.writeByte("G".charCodeAt(0));
    ba.writeByte("U".charCodeAt(0));
    ba.writeByte("I".charCodeAt(0));
    ba.writeInt(version);
    ba.writeBoolean(compress);// compress
    ba.writeUTF(pkgId);
    ba.writeUTF(pkgName); let i = 0;
    while (i < 20) {
        ba.writeByte(0);
        i++;
    }
}

function getFileExtension(projectType: string): string {
    let fileExtension = "fui"; // todo 从配置中获取
    if (projectType == ProjectType.UNITY) {
        fileExtension = "bytes";
    }
    else if (projectType == ProjectType.COCOS2DX || projectType == ProjectType.VISION) {
        if (binaryFormat) {
            fileExtension = "fui";
        } else {
            fileExtension = "bytes";
        }
    }
    else if (projectType == ProjectType.CRY || projectType == ProjectType.MONOGAME || projectType == ProjectType.CORONA) {
        fileExtension = "fui";
    } else {
        if (!fileExtension) {
            if (projectType == ProjectType.COCOSCREATOR) {
                fileExtension = "bin";
            }
            else if (isH5(projectType)) {
                fileExtension = "fui";
            }
            else {
                fileExtension = "zip";
            }
        }
    }
    return fileExtension;
}


function getPackagesResource(resource: IResource): IPackageResource {
    let dependentMap = new Map();
    let resourceArr = [];
    for (let [key, value] of Object.entries(resource)) {
        // 资源列表存在数组和单个的情况
        if (Array.isArray(value)) {
            for (let i = 0; i < value.length; i++) {
                let item = value[i];
                item.type = key;
                resourceArr.push(item);
                resourceMap.set(item.id, item);
                if (key == "component") { // conponent组件
                    readXMLResource(item, dependentMap); // todo 非组件文件也需要被解析
                } else if (key == "image") {
                    spriteMap.set(item.id, item);
                }
            }
        } else {
            value.type = key;
            resourceArr.push(value);
            resourceMap.set(value.id, value);
            if (key == "component") {
                readXMLResource(value, dependentMap);
            } else if (key == "image") {
                spriteMap.set(value.id, value);
            }
        }
    }
    console.log(spriteMap);
    return { dependentMap, resourceArr };
}

// 根据资源列表读取跨包资源情况
function readXMLResource(component: IComponentResource, dependentMap: Map<string, string>) {
    let { name, path, id } = component;
    let xml = fs.readFileSync(`${basePath}${assetsPath}${pkgName}${path}${name}`).toString();
    let data = parse(xml, xmlOptions).component as IComponentFile;
    xmlFileMap[id] = data;
    Object.assign(resourceMap.get(id), data);
    // 从package.xml中获取resources，然后从displayList中寻找跨包资源
    let { displayList } = data;
    console.log(data);

    // 遍历解析跨包资源
    for (let [key, value] of Object.entries(displayList)) {
        if (dependentElements.includes(key)) {
            if (Array.isArray(value)) {
                for (let j = 0; j < value.length; j++) {
                    let element = value[j] as IBaseElement;
                    let { id, name, pkg } = element;
                    if (pkg) {
                        dependentMap.set(id, name);
                    }
                }
            } else {
                let { id, name, pkg } = value as IBaseElement;
                if (pkg) {
                    dependentMap.set(id, name);
                }
            }
        } else {
            // console.log(key);
        }
    }
}

// 根据package.xml获取碎图情况
function getSpritesInfo() {
    // todo 从movieclip 中获取碎图

}

function encode(compress: boolean = false): ByteArray {
    // 处理图集资源
    let headByteArray = new ByteArray();
    writeHead(headByteArray, { version, pkgId, pkgName });

    let ba = new ByteArray();
    let i = 0;
    let itemId: string = "";
    var atlasId: string = "";
    var binIndex: number = 0;
    var pos: number = 0;
    var len: number = 0;
    let longStrings:ByteArray;

    startSegments(ba, 6, false);
    writeSegmentPos(ba, 0);

    console.log("packageDescription");
    let xml = fs.readFileSync(`${basePath}${assetsPath}${pkgName}/${packageName}`).toString();
    let packageDescription = parse(xml, xmlOptions).packageDescription as IPackageDescription;
    let resources = packageDescription.resources;
    // console.log("resources:", resources);

    // dependencies
    let { dependentMap, resourceArr } = getPackagesResource(resources);

    ba.writeShort(dependentMap.size); // 写入依赖包的数目

    dependentMap.forEach(([id, name]) => {
        writeString(ba, id);
        writeString(ba, name);
    })

    // branches
    // str = xml.getAttribute("branches");
    //      if(str)
    //      {
    //         arr = str.split(",");
    //         ba.writeShort(arr.length);
    //         i = 0;
    //         while(i < arr.length)
    //         {
    //            writeString(ba,arr[i]);
    //            i++;
    //         }
    //      }
    //      else
    //      {
    //         ba.writeShort(0);
    //      }
    ba.writeShort(0);

    writeSegmentPos(ba, 1);
    // ba.writeShort(resourceArr.length); 
    ba.writeShort(resourceArr.length);
    // console.log(resourceArr);
 
    resourceArr.forEach((element) => {
        let byteBuffer = writeResourceItem(element); // 资源中的
        ba.writeInt(byteBuffer.length);
        ba.writeBytes(byteBuffer);
        byteBuffer.clear();
    })

    writeSegmentPos(ba, 2);

    // 写入纹理数据
    let cnt = spriteMap.size;
    ba.writeShort(cnt);
    i = 0;
    let arr = [];
    let ba2 = new ByteArray();
    while (i < cnt) {
        arr = spriteMap[i];
        ba2 = new ByteArray();
        itemId = arr[0];
        writeString(ba2, itemId);
        binIndex = parseInt(arr[1]);
        if (binIndex >= 0) {
            atlasId = "atlas" + binIndex;
        }
        else {
            pos = itemId.indexOf("_");
            if (pos == -1) {
                atlasId = "atlas_" + itemId;
            }
            else {
                atlasId = "atlas_" + itemId.substring(0, pos);
            }
        }
        writeString(ba2, atlasId);
        ba2.writeInt(arr[2]);
        ba2.writeInt(arr[3]);
        ba2.writeInt(arr[4]);
        ba2.writeInt(arr[5]);
        ba2.writeBoolean(arr[6]);
        if (arr[7] != undefined && (arr[7] != 0 || arr[8] != 0 || arr[9] != arr[4] || arr[10] != arr[5])) {
            ba2.writeBoolean(true);
            ba2.writeInt(arr[7]);
            ba2.writeInt(arr[8]);
            ba2.writeInt(arr[9]);
            ba2.writeInt(arr[10]);
        }
        else {
            ba2.writeBoolean(false);
        }
        ba.writeShort(ba2.length);
        ba.writeBytes(ba2);
        ba2.clear();
        i++;
    }

    // hitTestData
    if(publishData.hitTestData.length > 0)
         {
            writeSegmentPos(ba,3);
            ba2 = publishData.hitTestData;
            ba2.position = 0;
            cntPos = ba.position;
            ba.writeShort(0);
            cnt = 0;
            while(ba2.bytesAvailable)
            {
               str = ba2.readUTF();
               pos = ba2.position;
               ba2.position = ba2.position + 9;
               len = ba2.readInt();
               ba.writeInt(len + 15);
               writeString(ba,str);
               ba.writeBytes(ba2,pos,len + 13);
               ba2.position = pos + 13 + len;
               cnt++;
            }
            writeCount(ba,cntPos,cnt);
         }

         writeSegmentPos(ba,4);
         var longStringsCnt:int = 0;
         cnt = stringTable.length;
         ba.writeInt(cnt);
         i = 0;
         while(i < cnt)
         {
            try
            {
               ba.writeUTF(stringTable[i]);
            }
            catch(err:RangeError)
            {
               ba.writeShort(0);
               if(longStrings == null)
               {
                  longStrings = new ByteArray();
               }
               longStrings.writeShort(i);
               pos = longStrings.position;
               longStrings.writeInt(0);
            //    longStrings.writeUTFBytes(§_-FV§[i]); // todo what's this?
               longStrings.writeUTFBytes(stringTable[i]); // todo what's this?
               len = longStrings.position - pos - 4;
               longStrings.position = pos;
               longStrings.writeInt(len);
               longStrings.position = longStrings.length;
               longStringsCnt++;
            }
            i++;
         }
         if(longStringsCnt > 0)
         {
            writeSegmentPos(ba,5);
            ba.writeInt(longStringsCnt);
            ba.writeBytes(longStrings);
            longStrings.clear();
         }
         ba2 = ba;
         if(compress)
         {
            // ba2.deflate();
         }
         headByteArray.writeBytes(ba2);
         ba2.clear();
         

    return headByteArray;
}

function publish() {
    getProjectConfig();
    console.log(`Publish start: ${pkgName}`)
    let ba = encode();

    let fileExtension = getFileExtension(projectType);

    fs.writeFileSync(`${targetPath}/${pkgName}.${fileExtension}`, ba.data)
}

function writeResourceItem(resource: ResourceType): ByteArray {
    let _loc3_: ByteArray = null;
    let _loc4_: string = "";
    let _loc5_: Array<string> = [];
    let _loc6_: number = 0;
    let value: string = "";
    let _loc9_: any = null;
    let _loc10_: string = "";
    let ba: ByteArray = new ByteArray();
    let type: string = resource.type;
    switch (type) {
        case FPackageItemType.IMAGE:
            ba.writeByte(0);
            break;
        case FPackageItemType.MOVIECLIP:
            ba.writeByte(1);
            break;
        case FPackageItemType.SOUND:
            ba.writeByte(2);
            break;
        case FPackageItemType.COMPONENT:
            ba.writeByte(3);
            break;
        case FPackageItemType.ATLAS:
            ba.writeByte(4);
            break;
        case FPackageItemType.FONT:
            ba.writeByte(5);
            break;
        case FPackageItemType.SWF:
            ba.writeByte(6);
            break;
        case FPackageItemType.MISC:
            ba.writeByte(7);
            break;
        default:
            ba.writeByte(8);
    }
    value = resource["id"];
    writeString(ba, value);
    writeString(ba, resource.name || "");
    writeString(ba, resource.path || "");
    if (type == FPackageItemType.SOUND || type == FPackageItemType.SWF || type == FPackageItemType.ATLAS || type == FPackageItemType.MISC) {
        writeString(ba, resource.file);
    }
    else {
        writeString(ba, null);
    }
    ba.writeBoolean(Boolean(resource.exported));
    _loc4_ = resource.size || ""; // todo
    _loc5_ = _loc4_.split(",");
    ba.writeInt(parseInt(_loc5_[0]));
    ba.writeInt(parseInt(_loc5_[1]));
    switch (type) {
        case FPackageItemType.IMAGE:
            _loc4_ = resource.scale;
            if (_loc4_ == "9grid") {
                ba.writeByte(1);
                _loc4_ = resource.scale9grid;
                if (_loc4_) {
                    _loc5_ = _loc4_.split(",");
                    ba.writeInt(parseInt(_loc5_[0]));
                    ba.writeInt(parseInt(_loc5_[1]));
                    ba.writeInt(parseInt(_loc5_[2]));
                    ba.writeInt(parseInt(_loc5_[3]));
                }
                else {
                    ba.writeInt(0);
                    ba.writeInt(0);
                    ba.writeInt(0);
                    ba.writeInt(0);
                }
                ba.writeInt(+resource.gridTile);
            }
            else if (_loc4_ == "tile") {
                ba.writeByte(2);
            }
            else {
                ba.writeByte(0);
            }
            ba.writeBoolean(Boolean(resource.smoothing));
            break;
        case FPackageItemType.MOVIECLIP:
            // todo
            ba.writeBoolean(Boolean(resource.smoothing));
            _loc9_ = xmlFileMap[value];
            // if (_loc9_) {
            //     _loc3_ = this.writeMovieClipData(value, _loc9_);
            //     ba.writeInt(_loc3_.length);
            //     ba.writeBytes(_loc3_);
            //     _loc3_.clear();
            // }
            // else {
            ba.writeInt(0);
            // }
            break;
        case FPackageItemType.FONT:
            // _loc4_ = xmlFileMap[value + ".fnt"];
            // if (_loc4_) {
            //     _loc3_ = this.writeFontData(value, _loc4_);
            //     ba.writeInt(_loc3_.length);
            //     ba.writeBytes(_loc3_);
            //     _loc3_.clear();
            // }
            // else {
            //     ba.writeInt(0);
            // }
            break;
        case FPackageItemType.COMPONENT:
            _loc9_ = xmlFileMap[value];

            if (_loc9_) {
                _loc10_ = _loc9_.extention;
                if (_loc10_) {
                    switch (_loc10_) {
                        case FObjectType.EXT_LABEL:
                            ba.writeByte(11);
                            break;
                        case FObjectType.EXT_BUTTON:
                            ba.writeByte(12);
                            break;
                        case FObjectType.EXT_COMBOBOX:
                            ba.writeByte(13);
                            break;
                        case FObjectType.EXT_PROGRESS_BAR:
                            ba.writeByte(14);
                            break;
                        case FObjectType.EXT_SLIDER:
                            ba.writeByte(15);
                            break;
                        case FObjectType.EXT_SCROLLBAR:
                            ba.writeByte(16);
                            break;
                        default:
                            ba.writeByte(0);
                    }
                }
                else {
                    ba.writeByte(0);
                }
                // _loc3_ = writeGObjectData(value, any.attach(_loc9_));
                // ba.writeInt(_loc3_.length);
                // ba.writeBytes(_loc3_);
                // _loc3_.clear();
            }
            else {
                ba.writeByte(0);
                ba.writeInt(0);
            }
    }
    // branch
    _loc4_ = "";
    // _loc4_ = resource.getAttribute("branch");
    writeString(ba, _loc4_);
    // _loc4_ = resource.getAttribute("branches");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        ba.writeByte(_loc5_.length);
        _loc6_ = 0;
        while (_loc6_ < _loc5_.length) {
            writeString(ba, _loc5_[_loc6_]);
            _loc6_++;
        }
    }
    else {
        ba.writeByte(0);
    }

    // highRes
    // _loc4_ = resource.getAttribute("highRes");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        ba.writeByte(_loc5_.length);
        _loc6_ = 0;
        while (_loc6_ < _loc5_.length) {
            writeString(ba, _loc5_[_loc6_]);
            _loc6_++;
        }
    } else {
        ba.writeByte(0);
    }
    return ba;
}

function writeGObjectData(param1: string, param2: any): ByteArray {
    var _loc4_: string = null;
    var _loc5_: Array<any> = null;
    var _loc6_: number = 0;
    var _loc7_: number = 0;
    var _loc8_: Array<any> = null;
    var _loc9_: any = null;
    var _loc10_: ByteArray = null;
    var _loc11_: number = 0;
    var _loc15_: any = null;
    var _loc3_: ByteArray = new ByteArray();
    controllerCache = {};
    controllerCnt = 0;
    displayList = {};
    _loc9_ = param2.getChild("displayList");
    if (_loc9_ != null) {
        _loc8_ = _loc9_.getChildren();
        _loc7_ = _loc8_.length;
        _loc6_ = 0;
        while (_loc6_ < _loc7_) {
            displayList[_loc8_[_loc6_].getAttribute("id")] = _loc6_;
            _loc6_++;
        }
    }
    startSegments(_loc3_, 8, false);
    writeSegmentPos(_loc3_, 0);
    _loc4_ = param2.getAttribute("size", "");
    _loc5_ = _loc4_.split(",");
    _loc3_.writeInt(parseInt(_loc5_[0]));
    _loc3_.writeInt(parseInt(_loc5_[1]));
    _loc4_ = param2.getAttribute("restrictSize");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        _loc3_.writeBoolean(true);
        _loc3_.writeInt(parseInt(_loc5_[0]));
        _loc3_.writeInt(parseInt(_loc5_[1]));
        _loc3_.writeInt(parseInt(_loc5_[2]));
        _loc3_.writeInt(parseInt(_loc5_[3]));
    }
    else {
        _loc3_.writeBoolean(false);
    }
    _loc4_ = param2.getAttribute("pivot");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        _loc3_.writeBoolean(true);
        _loc3_.writeFloat(parseFloat(_loc5_[0]));
        _loc3_.writeFloat(parseFloat(_loc5_[1]));
        _loc3_.writeBoolean(param2.getAttributeBool("anchor"));
    }
    else {
        _loc3_.writeBoolean(false);
    }
    _loc4_ = param2.getAttribute("margin");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        _loc3_.writeBoolean(true);
        _loc3_.writeInt(parseInt(_loc5_[0]));
        _loc3_.writeInt(parseInt(_loc5_[1]));
        _loc3_.writeInt(parseInt(_loc5_[2]));
        _loc3_.writeInt(parseInt(_loc5_[3]));
    }
    else {
        _loc3_.writeBoolean(false);
    }
    var _loc12_: Boolean = false;
    _loc4_ = param2.getAttribute("overflow");
    if (_loc4_ == "hidden") {
        _loc3_.writeByte(1);
    }
    else if (_loc4_ == "scroll") {
        _loc3_.writeByte(2);
        _loc12_ = true;
    }
    else {
        _loc3_.writeByte(0);
    }
    _loc4_ = param2.getAttribute("clipSoftness");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        _loc3_.writeBoolean(true);
        _loc3_.writeInt(parseInt(_loc5_[0]));
        _loc3_.writeInt(parseInt(_loc5_[1]));
    }
    else {
        _loc3_.writeBoolean(false);
    }
    writeSegmentPos(_loc3_, 1);
    _loc7_ = 0;
    _loc11_ = _loc3_.position;
    _loc3_.writeShort(0);
    var _loc13_: any = param2.getEnumerator("controller");
    while (_loc13_.moveNext()) {
        _loc10_ = writeControllerData(_loc13_.current);
        _loc3_.writeShort(_loc10_.length);
        _loc3_.writeBytes(_loc10_);
        _loc10_.clear();
        _loc7_++;
    }
    writeCount(_loc3_, _loc11_, _loc7_);
    writeSegmentPos(_loc3_, 2);
    if (_loc9_ != null) {
        _loc8_ = _loc9_.getChildren();
        _loc7_ = _loc8_.length;
        _loc3_.writeShort(_loc7_);
        _loc6_ = 0;
        while (_loc6_ < _loc7_) {
            _loc10_ = addComponent(_loc8_[_loc6_]);
            _loc3_.writeShort(_loc10_.length);
            _loc3_.writeBytes(_loc10_);
            _loc10_.clear();
            _loc6_++;
        }
    }
    else {
        _loc3_.writeShort(0);
    }
    writeSegmentPos(_loc3_, 3);
    writeRelation(param2, _loc3_, true);
    writeSegmentPos(_loc3_, 4);
    writeString(_loc3_, param2.getAttribute("customData"), true);
    _loc3_.writeBoolean(param2.getAttributeBool("opaque", true));
    _loc4_ = param2.getAttribute("mask");
    if (displayList[_loc4_] != undefined) {
        _loc3_.writeShort(displayList[_loc4_]);
        _loc3_.writeBoolean(param2.getAttributeBool("reversedMask"));
    }
    else {
        _loc3_.writeShort(-1);
    }
    _loc4_ = param2.getAttribute("hitTest");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        if (_loc5_.length == 1) {
            writeString(_loc3_, null);
            _loc3_.writeInt(1);
            if (displayList[_loc5_[0]] != undefined) {
                _loc3_.writeInt(displayList[_loc5_[0]]);
            }
            else {
                _loc3_.writeInt(-1);
            }
        }
        else {
            writeString(_loc3_, _loc5_[0]);
            _loc3_.writeInt(parseInt(_loc5_[1]));
            _loc3_.writeInt(parseInt(_loc5_[2]));
        }
    }
    else {
        writeString(_loc3_, null);
        _loc3_.writeInt(0);
        _loc3_.writeInt(0);
    }
    writeSegmentPos(_loc3_, 5);
    _loc7_ = 0;
    _loc11_ = _loc3_.position;
    _loc3_.writeShort(0);
    _loc13_ = param2.getEnumerator("transition");
    while (_loc13_.moveNext()) {
        _loc10_ = writeTransitionData(_loc13_.current);
        _loc3_.writeShort(_loc10_.length);
        _loc3_.writeBytes(_loc10_);
        _loc10_.clear();
        _loc7_++;
    }
    writeCount(_loc3_, _loc11_, _loc7_);
    var _loc14_: string = param2.getAttribute("extention");
    if (_loc14_) {
        writeSegmentPos(_loc3_, 6);
        _loc15_ = param2.getChild(_loc14_);
        if (!_loc15_) {
            // _loc15_ = any.create(_loc14_);
        }
        switch (_loc14_) {
            case FObjectType.EXT_LABEL:
                break;
            case FObjectType.EXT_BUTTON:
                _loc4_ = _loc15_.getAttribute("mode");
                if (_loc4_ == FButton.CHECK) {
                    _loc3_.writeByte(1);
                }
                else if (_loc4_ == FButton.RADIO) {
                    _loc3_.writeByte(2);
                }
                else {
                    _loc3_.writeByte(0);
                }
                writeString(_loc3_, _loc15_.getAttribute("sound"));
                _loc3_.writeFloat(_loc15_.getAttributeInt("volume", 100) / 100);
                _loc4_ = _loc15_.getAttribute("downEffect", "none");
                if (_loc4_ == "dark") {
                    _loc3_.writeByte(1);
                }
                else if (_loc4_ == "scale") {
                    _loc3_.writeByte(2);
                }
                else {
                    _loc3_.writeByte(0);
                }
                _loc3_.writeFloat(_loc15_.getAttributeFloat("downEffectValue", 0.8));
                break;
            case FObjectType.EXT_COMBOBOX:
                writeString(_loc3_, _loc15_.getAttribute("dropdown"));
                break;
            case FObjectType.EXT_PROGRESS_BAR:
                _loc4_ = _loc15_.getAttribute("titleType");
                switch (_loc4_) {
                    case "percent":
                        _loc3_.writeByte(0);
                        break;
                    case "valueAndmax":
                        _loc3_.writeByte(1);
                        break;
                    case "value":
                        _loc3_.writeByte(2);
                        break;
                    case "max":
                        _loc3_.writeByte(3);
                        break;
                    default:
                        _loc3_.writeByte(0);
                }
                _loc3_.writeBoolean(_loc15_.getAttributeBool("reverse"));
                break;
            case FObjectType.EXT_SLIDER:
                _loc4_ = _loc15_.getAttribute("titleType");
                switch (_loc4_) {
                    case "percent":
                        _loc3_.writeByte(0);
                        break;
                    case "valueAndmax":
                        _loc3_.writeByte(1);
                        break;
                    case "value":
                        _loc3_.writeByte(2);
                        break;
                    case "max":
                        _loc3_.writeByte(3);
                        break;
                    default:
                        _loc3_.writeByte(0);
                }
                _loc3_.writeBoolean(_loc15_.getAttributeBool("reverse"));
                _loc3_.writeBoolean(_loc15_.getAttributeBool("wholeNumbers"));
                _loc3_.writeBoolean(_loc15_.getAttributeBool("changeOnClick", true));
                break;
            case FObjectType.EXT_SCROLLBAR:
                _loc3_.writeBoolean(_loc15_.getAttributeBool("fixedGripSize"));
        }
    }
    if (_loc12_) {
        writeSegmentPos(_loc3_, 7);
        _loc10_ = writeScrollData(param2);
        _loc3_.writeBytes(_loc10_);
        _loc10_.clear();
    }
    return _loc3_;
}

function writeScrollData(param1: any): ByteArray {
    var _loc3_: String = null;
    var _loc4_: Array<any>;
    var _loc2_: ByteArray = new ByteArray();
    _loc3_ = param1.getAttribute("scroll");
    if (_loc3_ == "horizontal") {
        _loc2_.writeByte(0);
    }
    else if (_loc3_ == "both") {
        _loc2_.writeByte(2);
    }
    else {
        _loc2_.writeByte(1);
    }
    _loc3_ = param1.getAttribute("scrollBar");
    if (_loc3_ == "visible") {
        _loc2_.writeByte(1);
    }
    else if (_loc3_ == "auto") {
        _loc2_.writeByte(2);
    }
    else if (_loc3_ == "hidden") {
        _loc2_.writeByte(3);
    }
    else {
        _loc2_.writeByte(0);
    }
    _loc2_.writeInt(param1.getAttributeInt("scrollBarFlags"));
    _loc3_ = param1.getAttribute("scrollBarMargin");
    if (_loc3_) {
        _loc4_ = _loc3_.split(",");
        _loc2_.writeBoolean(true);
        _loc2_.writeInt(parseInt(_loc4_[0]));
        _loc2_.writeInt(parseInt(_loc4_[1]));
        _loc2_.writeInt(parseInt(_loc4_[2]));
        _loc2_.writeInt(parseInt(_loc4_[3]));
    }
    else {
        _loc2_.writeBoolean(false);
    }
    _loc3_ = param1.getAttribute("scrollBarRes");
    if (_loc3_) {
        _loc4_ = _loc3_.split(",");
        writeString(_loc2_, _loc4_[0]);
        writeString(_loc2_, _loc4_[1]);
    }
    else {
        writeString(_loc2_, null);
        writeString(_loc2_, null);
    }
    _loc3_ = param1.getAttribute("ptrRes");
    if (_loc3_) {
        _loc4_ = _loc3_.split(",");
        writeString(_loc2_, _loc4_[0]);
        writeString(_loc2_, _loc4_[1]);
    }
    else {
        writeString(_loc2_, null);
        writeString(_loc2_, null);
    }
    return _loc2_;
}

function writeControllerData(param1: any): ByteArray {
    var _loc3_: ByteArray = null;
    var _loc4_: string = null;
    var _loc5_: Array<any> = [];
    var _loc6_: number = 0;
    var _loc7_: number = 0;
    var _loc8_: number = 0;
    var _loc10_: any;
    var _loc11_: string = null;
    var _loc12_: string = null;
    var _loc13_: number = 0;
    var _loc2_: ByteArray = new ByteArray();
    startSegments(_loc2_, 3, true);
    writeSegmentPos(_loc2_, 0);
    _loc4_ = param1.getAttribute("name");
    writeString(_loc2_, _loc4_);
    controllerCache[_loc4_] = controllerCnt++;
    _loc2_.writeBoolean(param1.getAttributeBool("autoRadioGroupDepth"));
    writeSegmentPos(_loc2_, 1);
    _loc4_ = param1.getAttribute("pages");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        _loc7_ = _loc5_.length / 2;
        _loc2_.writeShort(_loc7_);
        _loc6_ = 0;
        while (_loc6_ < _loc7_) {
            writeString(_loc2_, _loc5_[_loc6_ * 2], false, false);
            writeString(_loc2_, _loc5_[_loc6_ * 2 + 1], false, false);
            _loc6_++;
        }
        _loc11_ = param1.getAttribute("homePageType", "default");
        _loc12_ = param1.getAttribute("homePage", "");
        _loc13_ = 0;
        if (_loc11_ == "specific") {
            _loc6_ = 0;
            while (_loc6_ < _loc7_) {
                if (_loc5_[_loc6_ * 2] == _loc12_) {
                    _loc13_ = _loc6_;
                    break;
                }
                _loc6_++;
            }
        }
        switch (_loc11_) {
            case "specific":
                _loc2_.writeByte(1);
                _loc2_.writeShort(_loc13_);
                break;
            case "branch":
                _loc2_.writeByte(2);
                break;
            case "variable":
                _loc2_.writeByte(3);
                writeString(_loc2_, _loc12_);
                break;
            default:
                _loc2_.writeByte(0);
        }
    } else {
        _loc2_.writeShort(0);
        _loc2_.writeByte(0);
    }
    writeSegmentPos(_loc2_, 2);
    var _loc9_: Array<any> = param1.getChildren();
    _loc7_ = 0;
    _loc8_ = _loc2_.position;
    _loc2_.writeShort(0);
    for (_loc10_ in _loc9_) {
        if (_loc10_.getName() == "action") {
            _loc4_ = _loc10_.getAttribute("type");
            _loc3_ = writeActionData(_loc4_, _loc10_);
            _loc2_.writeShort(_loc3_.length + 1);
            if (_loc4_ == "play_transition") {
                _loc2_.writeByte(0);
            }
            else if (_loc4_ == "change_page") {
                _loc2_.writeByte(1);
            }
            else {
                _loc2_.writeByte(0);
            }
            _loc2_.writeBytes(_loc3_);
            _loc7_++;
        }
    }
    writeCount(_loc2_, _loc8_, _loc7_);
    return _loc2_;
}

function writeActionData(param1: string, param2: any): ByteArray {
    var _loc4_: string = null;
    var _loc5_: Array<any> = [];
    var _loc6_: number = 0;
    var _loc7_: number = 0;
    var _loc3_: ByteArray = new ByteArray();
    _loc4_ = param2.getAttribute("fromPage");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        _loc6_ = _loc5_.length;
        _loc3_.writeShort(_loc6_);
        _loc7_ = 0;
        while (_loc7_ < _loc6_) {
            writeString(_loc3_, _loc5_[_loc7_]);
            _loc7_++;
        }
    } else {
        _loc3_.writeShort(0);
    }
    _loc4_ = param2.getAttribute("toPage");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        _loc6_ = _loc5_.length;
        _loc3_.writeShort(_loc6_);
        _loc7_ = 0;
        while (_loc7_ < _loc6_) {
            writeString(_loc3_, _loc5_[_loc7_]);
            _loc7_++;
        }
    } else {
        _loc3_.writeShort(0);
    }
    if (param1 == "play_transition") {
        writeString(_loc3_, param2.getAttribute("transition"));
        _loc3_.writeInt(param2.getAttributeInt("repeat", 1));
        _loc3_.writeFloat(param2.getAttributeFloat("delay"));
        _loc3_.writeBoolean(param2.getAttributeBool("stopOnExit"));
    } else if (param1 == "change_page") {
        writeString(_loc3_, param2.getAttribute("objectId"));
        writeString(_loc3_, param2.getAttribute("controller"));
        writeString(_loc3_, param2.getAttribute("targetPage"));
    }
    return _loc3_;
}

function writeRelation(param1: any, ba: ByteArray, param3: boolean): void {
    var _loc4_: string = null;
    var _loc5_: Array<any> = [];
    var _loc9_: any;
    var _loc10_: number = 0;
    var _loc11_: Array<any> = [];
    var _loc12_: string = null;
    var _loc13_: string = null;
    var _loc14_: string = null;
    var _loc15_: boolean = false;
    var _loc16_: number = 0;
    var _loc17_: any = undefined;
    var _loc6_: Array<any> = [];
    var _loc7_: { [key: string]: any } = {};
    var _loc8_: any = param1.getEnumerator("relation");
    while (_loc8_.moveNext()) {
        _loc9_ = _loc8_.current;
        _loc4_ = _loc9_.getAttribute("target");
        _loc10_ = -1;
        if (_loc4_) {
            if (displayList[_loc4_] != undefined) {
                _loc10_ = displayList[_loc4_];
            }
            else {
                continue;
            }
        }
        else if (param3) {
            continue;
        }
        _loc4_ = _loc9_.getAttribute("sidePair");
        if (_loc4_) {
            _loc11_ = _loc7_[_loc10_];
            if (!_loc11_) {
                _loc6_.push(_loc10_);
                _loc11_ = [];
                _loc7_[_loc10_] = _loc11_;
            }
            _loc5_ = _loc4_.split(",");
            _loc16_ = 0;
            while (_loc16_ < _loc5_.length) {
                _loc12_ = _loc5_[_loc16_];
                if (_loc12_) {
                    if (_loc12_.charAt(_loc12_.length - 1) == "%") {
                        _loc12_ = _loc12_.substr(0, _loc12_.length - 1);
                        _loc15_ = true;
                    }
                    else {
                        _loc15_ = false;
                    }
                    _loc17_ = RelationNameToID[_loc12_];
                    if (_loc17_ != undefined) {
                        _loc11_.push(!!_loc15_ ? 10000 + _loc17_ : _loc17_);
                    }
                }
                _loc16_++;
            }
        }
    }
    ba.writeByte(_loc6_.length);
    // for (_loc10_ in _loc6_) {
    //     ba.writeShort(_loc10_);
    //     _loc11_ = _loc7_[_loc10_];
    //     ba.writeByte(_loc11_.length);
    //     for (_loc16_ in _loc11_) {
    //         if (_loc16_ >= 10000) {
    //             ba.writeByte(_loc16_ - 10000);
    //             ba.writeBoolean(true);
    //         }
    //         else {
    //             ba.writeByte(_loc16_);
    //             ba.writeBoolean(false);
    //         }
    //     }
    // }
}

function writeTransitionData(param1: any): ByteArray {
    var _loc3_: ByteArray = null;
    var _loc4_: string = null;
    var _loc5_: Array<any> = [];
    var _loc6_: number = 0;
    var _loc7_: number = 0;
    var _loc8_: number = 0;
    var _loc9_: number;
    var _loc11_: any;
    var _loc12_: string = null;
    var _loc13_: any = undefined;
    var _loc2_: ByteArray = new ByteArray();
    writeString(_loc2_, param1.getAttribute("name"));
    _loc2_.writeInt(param1.getAttributeInt("options"));
    _loc2_.writeBoolean(param1.getAttributeBool("autoPlay"));
    _loc2_.writeInt(param1.getAttributeInt("autoPlayRepeat", 1));
    _loc2_.writeFloat(param1.getAttributeFloat("autoPlayDelay"));
    _loc4_ = param1.getAttribute("frameRate");
    if (_loc4_) {
        _loc9_ = 1 / parseInt(_loc4_);
    } else {
        _loc9_ = 1 / 24;
    }
    _loc8_ = _loc2_.position;
    _loc2_.writeShort(0);
    _loc7_ = 0;
    var _loc10_: any = param1.getEnumerator("item");
    while (_loc10_.moveNext()) {
        _loc11_ = _loc10_.current;
        _loc3_ = new ByteArray();
        startSegments(_loc3_, 4, true);
        writeSegmentPos(_loc3_, 0);
        _loc12_ = _loc11_.getAttribute("type");
        writeTransitionTypeData(_loc3_, _loc12_);
        _loc3_.writeFloat(_loc11_.getAttributeInt("time") * _loc9_);
        _loc4_ = _loc11_.getAttribute("target");
        if (!_loc4_) {
            _loc3_.writeShort(-1);
        }
        else {
            _loc13_ = displayList[_loc4_];
            if (_loc13_ == undefined) {
                _loc3_.clear();
                continue;
            }
            _loc3_.writeShort(Number(_loc13_));
        }
        writeString(_loc3_, _loc11_.getAttribute("label"));
        _loc4_ = _loc11_.getAttribute("endValue");
        if (_loc11_.getAttributeBool("tween") && _loc4_ != null) {
            _loc3_.writeBoolean(true);
            writeSegmentPos(_loc3_, 1);
            _loc3_.writeFloat(_loc11_.getAttributeInt("duration") * _loc9_);
            _loc3_.writeByte(EaseType.parseEaseType(_loc11_.getAttribute("ease")));
            _loc3_.writeInt(_loc11_.getAttributeInt("repeat"));
            _loc3_.writeBoolean(_loc11_.getAttributeBool("yoyo"));
            writeString(_loc3_, _loc11_.getAttribute("label2"));
            writeSegmentPos(_loc3_, 2);
            _loc4_ = _loc11_.getAttribute("startValue");
            writeTransitionValue(_loc3_, _loc12_, _loc4_);
            writeSegmentPos(_loc3_, 3);
            _loc4_ = _loc11_.getAttribute("endValue");
            writeTransitionValue(_loc3_, _loc12_, _loc4_);
            _loc4_ = _loc11_.getAttribute("path");
            writeCurve(_loc4_, _loc3_);
        }
        else {
            _loc3_.writeBoolean(false);
            writeSegmentPos(_loc3_, 2);
            _loc4_ = _loc11_.getAttribute("value");
            if (_loc4_ == null) {
                _loc4_ = _loc11_.getAttribute("startValue");
            }
            writeTransitionValue(_loc3_, _loc12_, _loc4_);
        }
        _loc2_.writeShort(_loc3_.length);
        _loc2_.writeBytes(_loc3_);
        _loc3_.clear();
        _loc7_++;
    }
    writeCount(_loc2_, _loc8_, _loc7_);
    return _loc2_;
}

function writeCurve(param1: string, param2: ByteArray): void {
    var _loc9_: number = 0;
    if (!param1) {
        param2.writeInt(0);
        return;
    }
    var _loc3_: number = param2.position;
    param2.writeInt(0);
    var _loc4_: Array<string> = param1.split(",");
    var _loc5_: number = _loc4_.length;
    var _loc6_: number = 0;
    var _loc7_: number = 0;
    while (_loc7_ < _loc5_) {
        _loc6_++;
        _loc9_ = parseInt(_loc4_[_loc7_++]);
        param2.writeByte(_loc9_);
        switch (_loc9_) {
            case CurveType.Bezier:
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                continue;
            case CurveType.CubicBezier:
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                _loc7_++;
                continue;
            default:
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                param2.writeFloat(parseFloat(_loc4_[_loc7_++]));
                continue;
        }
    }
    var _loc8_: number = param2.position;
    param2.position = _loc3_;
    param2.writeInt(_loc6_);
    param2.position = _loc8_;
}

function writeControllerItem(param1: any, ba: ByteArray): void {
    var position: number = ba.position;
    ba.writeShort(0);
    var _loc4_: number = 0;
    var _loc5_: any = param1.getEnumerator("property");
    while (_loc5_.moveNext()) {
        writeString(ba, _loc5_.current.getAttribute("target"));
        ba.writeShort(_loc5_.current.getAttributeInt("propertyId"));
        writeString(ba, _loc5_.current.getAttribute("value"), true, true);
        _loc4_++;
    }
    writeCount(ba, position, _loc4_);
}

function addComponent(param1: any): ByteArray {
    var _loc3_: ByteArray = null;
    var _loc4_: string = null;
    var _loc5_: Array<any> = [];
    var _loc6_: number = 0;
    var _loc7_: number = 0;
    var _loc8_: Array<any> = null;
    var _loc9_: any;
    var _loc10_: number = 0;
    var _loc11_: number = 0;
    var _loc13_: number = 0;
    var _loc14_: any;
    var _loc15_: number = 0;
    var _loc16_: any = undefined;
    var _loc17_: number = 0;
    var _loc18_: number = 0;
    var _loc19_: string = null;
    var _loc20_: number = 0;
    var _loc21_: number = 0;
    var _loc22_: string = null;
    var _loc23_: string = null;
    var _loc24_: number = 0;
    var _loc25_: number = 0;
    var _loc26_: boolean = false;
    var _loc27_: any;
    var _loc28_: any = null;
    var _loc29_: number = 0;
    var _loc2_: ByteArray = new ByteArray();
    var _loc12_: string = param1.getName();
    switch (_loc12_) {
        case FObjectType.IMAGE:
            _loc11_ = 0;
            break;
        case FObjectType.MOVIECLIP:
            _loc11_ = 1;
            break;
        case FObjectType.SWF:
            _loc11_ = 2;
            break;
        case FObjectType.GRAPH:
            _loc11_ = 3;
            break;
        case FObjectType.LOADER:
            _loc11_ = 4;
            break;
        case FObjectType.GROUP:
            _loc11_ = 5;
            break;
        case FObjectType.TEXT:
            if (param1.getAttributeBool("input")) {
                _loc11_ = 8;
            }
            else {
                _loc11_ = 6;
            }
            break;
        case FObjectType.RICHTEXT:
            _loc11_ = 7;
            break;
        case FObjectType.COMPONENT:
            _loc11_ = 9;
            break;
        case FObjectType.LIST:
            if (param1.getAttributeBool("treeView")) {
                _loc11_ = 17;
            }
            else {
                _loc11_ = 10;
            }
            break;
        default:
            _loc11_ = 0;
    }
    if (_loc11_ == 17) {
        _loc13_ = 10;
    } else if (_loc11_ == 10) {
        _loc13_ = 9;
    } else {
        _loc13_ = 7;
    }
    startSegments(_loc2_, _loc13_, true);
    writeSegmentPos(_loc2_, 0);
    _loc2_.writeByte(_loc11_);
    writeString(_loc2_, param1.getAttribute("src"));
    writeString(_loc2_, param1.getAttribute("pkg"));
    writeString(_loc2_, param1.getAttribute("id", ""));
    writeString(_loc2_, param1.getAttribute("name", ""));
    _loc4_ = param1.getAttribute("xy");
    _loc5_ = _loc4_.split(",");
    _loc2_.writeInt(Number(_loc5_[0]));
    _loc2_.writeInt(Number(_loc5_[1]));
    _loc4_ = param1.getAttribute("size");
    if (_loc4_) {
        _loc2_.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        _loc2_.writeInt(parseInt(_loc5_[0]));
        _loc2_.writeInt(parseInt(_loc5_[1]));
    } else {
        _loc2_.writeBoolean(false);
    }
    _loc4_ = param1.getAttribute("restrictSize");
    if (_loc4_) {
        _loc2_.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        _loc2_.writeInt(parseInt(_loc5_[0]));
        _loc2_.writeInt(parseInt(_loc5_[1]));
        _loc2_.writeInt(parseInt(_loc5_[2]));
        _loc2_.writeInt(parseInt(_loc5_[3]));
    } else {
        _loc2_.writeBoolean(false);
    }
    _loc4_ = param1.getAttribute("scale");
    if (_loc4_) {
        _loc2_.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        _loc2_.writeFloat(parseFloat(_loc5_[0]));
        _loc2_.writeFloat(parseFloat(_loc5_[1]));
    } else {
        _loc2_.writeBoolean(false);
    }
    _loc4_ = param1.getAttribute("skew");
    if (_loc4_) {
        _loc2_.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        _loc2_.writeFloat(parseFloat(_loc5_[0]));
        _loc2_.writeFloat(parseFloat(_loc5_[1]));
    } else {
        _loc2_.writeBoolean(false);
    }
    _loc4_ = param1.getAttribute("pivot");
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        _loc2_.writeBoolean(true);
        _loc2_.writeFloat(parseFloat(_loc5_[0]));
        _loc2_.writeFloat(parseFloat(_loc5_[1]));
        _loc2_.writeBoolean(param1.getAttributeBool("anchor"));
    } else {
        _loc2_.writeBoolean(false);
    }
    _loc2_.writeFloat(param1.getAttributeFloat("alpha", 1));
    _loc2_.writeFloat(param1.getAttributeFloat("rotation"));
    _loc2_.writeBoolean(param1.getAttributeBool("visible", true));
    _loc2_.writeBoolean(param1.getAttributeBool("touchable", true));
    _loc2_.writeBoolean(param1.getAttributeBool("grayed"));
    _loc4_ = param1.getAttribute("blend");
    switch (_loc4_) {
        case "add":
            _loc2_.writeByte(2);
            break;
        case "multiply":
            _loc2_.writeByte(3);
            break;
        case "none":
            _loc2_.writeByte(1);
            break;
        case "screen":
            _loc2_.writeByte(4);
            break;
        case "erase":
            _loc2_.writeByte(5);
            break;
        default:
            _loc2_.writeByte(0);
    }
    _loc4_ = param1.getAttribute("filter");
    if (_loc4_) {
        if (_loc4_ == "color") {
            _loc2_.writeByte(1);
            _loc4_ = param1.getAttribute("filterData");
            _loc5_ = _loc4_.split(",");
            _loc2_.writeFloat(parseFloat(_loc5_[0]));
            _loc2_.writeFloat(parseFloat(_loc5_[1]));
            _loc2_.writeFloat(parseFloat(_loc5_[2]));
            _loc2_.writeFloat(parseFloat(_loc5_[3]));
        }
        else {
            _loc2_.writeByte(0);
        }
    } else {
        _loc2_.writeByte(0);
    }
    writeString(_loc2_, param1.getAttribute("customData"), true);
    writeSegmentPos(_loc2_, 1);
    writeString(_loc2_, param1.getAttribute("tooltips"), true);
    _loc4_ = param1.getAttribute("group");
    if (_loc4_ && displayList[_loc4_] != undefined) {
        _loc2_.writeShort(displayList[_loc4_]);
    } else {
        _loc2_.writeShort(-1);
    }
    writeSegmentPos(_loc2_, 2);
    _loc8_ = param1.getChildren();
    _loc7_ = 0;
    _loc10_ = _loc2_.position;
    _loc2_.writeShort(0);
    for (_loc14_ in _loc8_) {
        _loc15_ = FGearBase.getIndexByName(_loc14_.getName());
        if (_loc15_ != -1) {
            _loc3_ = writeGearData(Number(_loc15_), _loc14_);
            if (_loc3_ != null) {
                _loc7_++;
                _loc2_.writeShort(_loc3_.length + 1);
                _loc2_.writeByte(_loc15_);
                _loc2_.writeBytes(_loc3_);
                _loc3_.clear();
            }
        }
    }
    writeCount(_loc2_, _loc10_, _loc7_);
    writeSegmentPos(_loc2_, 3);
    writeRelation(param1, _loc2_, false);
    if (_loc12_ == FObjectType.COMPONENT || _loc12_ == FObjectType.LIST) {
        writeSegmentPos(_loc2_, 4);
        _loc16_ = controllerCache[param1.getAttribute("pageController")];
        if (_loc16_ != undefined) {
            _loc2_.writeShort(_loc16_);
        }
        else {
            _loc2_.writeShort(-1);
        }
        _loc4_ = param1.getAttribute("controller");
        if (_loc4_) {
            _loc10_ = _loc2_.position;
            _loc2_.writeShort(0);
            _loc5_ = _loc4_.split(",");
            _loc7_ = 0;
            _loc6_ = 0;
            while (_loc6_ < _loc5_.length) {
                if (_loc5_[_loc6_]) {
                    writeString(_loc2_, _loc5_[_loc6_]);
                    writeString(_loc2_, _loc5_[_loc6_ + 1]);
                    _loc7_++;
                }
                _loc6_ = _loc6_ + 2;
            }
            writeCount(_loc2_, _loc10_, _loc7_);
        }
        else {
            _loc2_.writeShort(0);
        }
        writeControllerItem(param1, _loc2_);
    } else if (_loc11_ == 8) {
        writeSegmentPos(_loc2_, 4);
        writeString(_loc2_, param1.getAttribute("prompt"));
        writeString(_loc2_, param1.getAttribute("restrict"));
        _loc2_.writeInt(param1.getAttributeInt("maxLength"));
        _loc2_.writeInt(param1.getAttributeInt("keyboardType"));
        _loc2_.writeBoolean(param1.getAttributeBool("password"));
    }
    writeSegmentPos(_loc2_, 5);
    switch (_loc12_) {
        case FObjectType.IMAGE:
            _loc4_ = param1.getAttribute("color");
            if (_loc4_) {
                _loc2_.writeBoolean(true);
                writeColorData(_loc2_, _loc4_, false);
            }
            else {
                _loc2_.writeBoolean(false);
            }
            _loc4_ = param1.getAttribute("flip");
            switch (_loc4_) {
                case "both":
                    _loc2_.writeByte(3);
                    break;
                case "hz":
                    _loc2_.writeByte(1);
                    break;
                case "vt":
                    _loc2_.writeByte(2);
                    break;
                default:
                    _loc2_.writeByte(0);
            }
            _loc4_ = param1.getAttribute("fillMethod");
            writeFillMethodData(_loc2_, _loc4_);
            if (_loc4_ && _loc4_ != "none") {
                _loc2_.writeByte(param1.getAttributeInt("fillOrigin"));
                _loc2_.writeBoolean(param1.getAttributeBool("fillClockwise", true));
                _loc2_.writeFloat(param1.getAttributeInt("fillAmount", 100) / 100);
            }
            break;
        case FObjectType.MOVIECLIP:
            _loc4_ = param1.getAttribute("color");
            if (_loc4_) {
                _loc2_.writeBoolean(true);
                writeColorData(_loc2_, _loc4_, false);
            }
            else {
                _loc2_.writeBoolean(false);
            }
            _loc2_.writeByte(0);
            _loc2_.writeInt(param1.getAttributeInt("frame"));
            _loc2_.writeBoolean(param1.getAttributeBool("playing", true));
            break;
        case FObjectType.GRAPH:
            _loc4_ = param1.getAttribute("type");
            _loc17_ = writeGraphData(_loc2_, _loc4_);
            _loc2_.writeInt(param1.getAttributeInt("lineSize", 1));
            writeColorData(_loc2_, param1.getAttribute("lineColor"));
            writeColorData(_loc2_, param1.getAttribute("fillColor"), true, 4294967295);
            _loc4_ = param1.getAttribute("corner", "");
            if (_loc4_) {
                _loc2_.writeBoolean(true);
                _loc5_ = _loc4_.split(",");
                _loc18_ = parseInt(_loc5_[0]);
                _loc2_.writeFloat(_loc18_);
                if (_loc5_[1]) {
                    _loc2_.writeFloat(parseInt(_loc5_[1]));
                }
                else {
                    _loc2_.writeFloat(_loc18_);
                }
                if (_loc5_[2]) {
                    _loc2_.writeFloat(parseInt(_loc5_[2]));
                }
                else {
                    _loc2_.writeFloat(_loc18_);
                }
                if (_loc5_[3]) {
                    _loc2_.writeFloat(parseInt(_loc5_[3]));
                }
                else {
                    _loc2_.writeFloat(_loc18_);
                }
            }
            else {
                _loc2_.writeBoolean(false);
            }
            if (_loc17_ == 3) {
                _loc4_ = param1.getAttribute("points");
                _loc5_ = _loc4_.split(",");
                _loc7_ = _loc5_.length;
                _loc2_.writeShort(_loc7_);
                _loc6_ = 0;
                while (_loc6_ < _loc7_) {
                    _loc2_.writeFloat(parseFloat(_loc5_[_loc6_]));
                    _loc6_++;
                }
            }
            else if (_loc17_ == 4) {
                _loc2_.writeShort(param1.getAttributeInt("sides"));
                _loc2_.writeFloat(param1.getAttributeFloat("startAngle"));
                _loc4_ = param1.getAttribute("distances");
                if (_loc4_) {
                    _loc5_ = _loc4_.split(",");
                    _loc7_ = _loc5_.length;
                    _loc2_.writeShort(_loc7_);
                    _loc6_ = 0;
                    while (_loc6_ < _loc7_) {
                        if (_loc5_[_loc6_]) {
                            _loc2_.writeFloat(parseFloat(_loc5_[_loc6_]));
                        }
                        else {
                            _loc2_.writeFloat(1);
                        }
                        _loc6_++;
                    }
                }
                else {
                    _loc2_.writeShort(0);
                }
            }
            break;
        case FObjectType.LOADER:
            writeString(_loc2_, param1.getAttribute("url", ""));
            writeAlignData(_loc2_, param1.getAttribute("align"));
            writeValignData(_loc2_, param1.getAttribute("vAlign"));
            _loc4_ = param1.getAttribute("fill");
            switch (_loc4_) {
                case "none":
                    _loc2_.writeByte(0);
                    break;
                case "scale":
                    _loc2_.writeByte(1);
                    break;
                case "scaleMatchHeight":
                    _loc2_.writeByte(2);
                    break;
                case "scaleMatchWidth":
                    _loc2_.writeByte(3);
                    break;
                case "scaleFree":
                    _loc2_.writeByte(4);
                    break;
                case "scaleNoBorder":
                    _loc2_.writeByte(5);
                    break;
                default:
                    _loc2_.writeByte(0);
            }
            _loc2_.writeBoolean(param1.getAttributeBool("shrinkOnly"));
            _loc2_.writeBoolean(param1.getAttributeBool("autoSize"));
            _loc2_.writeBoolean(param1.getAttributeBool("errorSign"));
            _loc2_.writeBoolean(param1.getAttributeBool("playing", true));
            _loc2_.writeInt(param1.getAttributeInt("frame"));
            _loc4_ = param1.getAttribute("color");
            if (_loc4_) {
                _loc2_.writeBoolean(true);
                writeColorData(_loc2_, _loc4_, false);
            }
            else {
                _loc2_.writeBoolean(false);
            }
            _loc4_ = param1.getAttribute("fillMethod");
            writeFillMethodData(_loc2_, _loc4_);
            if (_loc4_ && _loc4_ != "none") {
                _loc2_.writeByte(param1.getAttributeInt("fillOrigin"));
                _loc2_.writeBoolean(param1.getAttributeBool("fillClockwise", true));
                _loc2_.writeFloat(param1.getAttributeInt("fillAmount", 100) / 100);
            }
            break;
        case FObjectType.GROUP:
            _loc4_ = param1.getAttribute("layout");
            switch (_loc4_) {
                case "hz":
                    _loc2_.writeByte(1);
                    break;
                case "vt":
                    _loc2_.writeByte(2);
                    break;
                default:
                    _loc2_.writeByte(0);
            }
            _loc2_.writeInt(param1.getAttributeInt("lineGap"));
            _loc2_.writeInt(param1.getAttributeInt("colGap"));
            _loc2_.writeBoolean(param1.getAttributeBool("excludeInvisibles"));
            _loc2_.writeBoolean(param1.getAttributeBool("autoSizeDisabled"));
            _loc2_.writeShort(param1.getAttributeInt("mainGridIndex", -1));
            break;
        case FObjectType.TEXT:
        case FObjectType.RICHTEXT:
            writeString(_loc2_, param1.getAttribute("font"));
            _loc2_.writeShort(param1.getAttributeInt("fontSize"));
            writeColorData(_loc2_, param1.getAttribute("color"), false);
            writeAlignData(_loc2_, param1.getAttribute("align"));
            writeValignData(_loc2_, param1.getAttribute("vAlign"));
            _loc2_.writeShort(param1.getAttributeInt("leading", 3));
            _loc2_.writeShort(param1.getAttributeInt("letterSpacing"));
            _loc2_.writeBoolean(param1.getAttributeBool("ubb"));
            writeTextSizeData(_loc2_, param1.getAttribute("autoSize", "both"));
            _loc2_.writeBoolean(param1.getAttributeBool("underline"));
            _loc2_.writeBoolean(param1.getAttributeBool("italic"));
            _loc2_.writeBoolean(param1.getAttributeBool("bold"));
            _loc2_.writeBoolean(param1.getAttributeBool("singleLine"));
            _loc4_ = param1.getAttribute("strokeColor");
            if (_loc4_) {
                _loc2_.writeBoolean(true);
                writeColorData(_loc2_, _loc4_);
                _loc2_.writeFloat(param1.getAttributeInt("strokeSize", 1));
            }
            else {
                _loc2_.writeBoolean(false);
            }
            _loc4_ = param1.getAttribute("shadowColor");
            if (_loc4_) {
                _loc2_.writeBoolean(true);
                writeColorData(_loc2_, param1.getAttribute("shadowColor"));
                _loc4_ = param1.getAttribute("shadowOffset");
                if (_loc4_) {
                    _loc5_ = _loc4_.split(",");
                    _loc2_.writeFloat(parseFloat(_loc5_[0]));
                    _loc2_.writeFloat(parseFloat(_loc5_[1]));
                }
                else {
                    _loc2_.writeFloat(1);
                    _loc2_.writeFloat(1);
                }
            }
            else {
                _loc2_.writeBoolean(false);
            }
            _loc2_.writeBoolean(param1.getAttributeBool("vars"));
            break;
        case FObjectType.COMPONENT:
            break;
        case FObjectType.LIST:
            _loc19_ = param1.getAttribute("layout");
            switch (_loc19_) {
                case "column":
                    _loc2_.writeByte(0);
                    break;
                case "row":
                    _loc2_.writeByte(1);
                    break;
                case "flow_hz":
                    _loc2_.writeByte(2);
                    break;
                case "flow_vt":
                    _loc2_.writeByte(3);
                    break;
                case "pagination":
                    _loc2_.writeByte(4);
                    break;
                default:
                    _loc2_.writeByte(0);
            }
            _loc4_ = param1.getAttribute("selectionMode");
            switch (_loc4_) {
                case "single":
                    _loc2_.writeByte(0);
                    break;
                case "multiple":
                    _loc2_.writeByte(1);
                    break;
                case "multipleSingleClick":
                    _loc2_.writeByte(2);
                    break;
                case "none":
                    _loc2_.writeByte(3);
                    break;
                default:
                    _loc2_.writeByte(0);
            }
            writeAlignData(_loc2_, param1.getAttribute("align"));
            writeValignData(_loc2_, param1.getAttribute("vAlign"));
            _loc2_.writeShort(param1.getAttributeInt("lineGap"));
            _loc2_.writeShort(param1.getAttributeInt("colGap"));
            _loc20_ = param1.getAttributeInt("lineItemCount");
            _loc21_ = param1.getAttributeInt("lineItemCount2");
            if (_loc19_ == "flow_hz") {
                _loc2_.writeShort(0);
                _loc2_.writeShort(_loc20_);
            }
            else if (_loc19_ == "flow_vt") {
                _loc2_.writeShort(_loc20_);
                _loc2_.writeShort(0);
            }
            else if (_loc19_ == "pagination") {
                _loc2_.writeShort(_loc21_);
                _loc2_.writeShort(_loc20_);
            }
            else {
                _loc2_.writeShort(0);
                _loc2_.writeShort(0);
            }
            if (!_loc19_ || _loc19_ == "row" || _loc19_ == "column") {
                _loc2_.writeBoolean(param1.getAttributeBool("autoItemSize", true));
            }
            else {
                _loc2_.writeBoolean(param1.getAttributeBool("autoItemSize", false));
            }
            _loc4_ = param1.getAttribute("renderOrder");
            switch (_loc4_) {
                case "ascent":
                    _loc2_.writeByte(0);
                    break;
                case "descent":
                    _loc2_.writeByte(1);
                    break;
                case "arch":
                    _loc2_.writeByte(2);
                    break;
                default:
                    _loc2_.writeByte(0);
            }
            _loc2_.writeShort(param1.getAttributeInt("apex"));
            _loc4_ = param1.getAttribute("margin");
            if (_loc4_) {
                _loc5_ = _loc4_.split(",");
                _loc2_.writeBoolean(true);
                _loc2_.writeInt(parseInt(_loc5_[0]));
                _loc2_.writeInt(parseInt(_loc5_[1]));
                _loc2_.writeInt(parseInt(_loc5_[2]));
                _loc2_.writeInt(parseInt(_loc5_[3]));
            }
            else {
                _loc2_.writeBoolean(false);
            }
            _loc4_ = param1.getAttribute("overflow");
            if (_loc4_ == "hidden") {
                _loc2_.writeByte(1);
            }
            else if (_loc4_ == "scroll") {
                _loc2_.writeByte(2);
            }
            else {
                _loc2_.writeByte(0);
            }
            _loc4_ = param1.getAttribute("clipSoftness");
            if (_loc4_) {
                _loc5_ = _loc4_.split(",");
                _loc2_.writeBoolean(true);
                _loc2_.writeInt(parseInt(_loc5_[0]));
                _loc2_.writeInt(parseInt(_loc5_[1]));
            }
            else {
                _loc2_.writeBoolean(false);
            }
            _loc2_.writeBoolean(param1.getAttributeBool("scrollItemToViewOnClick", true));
            _loc2_.writeBoolean(param1.getAttributeBool("foldInvisibleItems"));
            break;
        case FObjectType.SWF:
            _loc2_.writeBoolean(param1.getAttributeBool("playing", true));
    }
    writeSegmentPos(_loc2_, 6);
    switch (_loc12_) {
        case FObjectType.TEXT:
        case FObjectType.RICHTEXT:
            writeString(_loc2_, param1.getAttribute("text"), true);
            break;
        case FObjectType.COMPONENT:
            _loc8_ = param1.getChildren();
            for (_loc14_ in _loc8_) {
                switch (_loc14_.getName()) {
                    case FObjectType.EXT_LABEL:
                        _loc2_.writeByte(11);
                        writeString(_loc2_, _loc14_.getAttribute("title"), true);
                        writeString(_loc2_, _loc14_.getAttribute("icon"));
                        _loc4_ = _loc14_.getAttribute("titleColor");
                        if (_loc4_) {
                            _loc2_.writeBoolean(true);
                            writeColorData(_loc2_, _loc4_);
                        }
                        else {
                            _loc2_.writeBoolean(false);
                        }
                        _loc2_.writeInt(_loc14_.getAttributeInt("titleFontSize"));
                        _loc22_ = _loc14_.getAttribute("prompt");
                        _loc23_ = _loc14_.getAttribute("restrict");
                        _loc24_ = _loc14_.getAttributeInt("maxLength");
                        _loc25_ = _loc14_.getAttributeInt("keyboardType");
                        _loc26_ = _loc14_.getAttributeBool("password");
                        if (_loc22_ || _loc23_ || _loc24_ || _loc25_ || _loc26_) {
                            _loc2_.writeBoolean(true);
                            writeString(_loc2_, _loc22_, true);
                            writeString(_loc2_, _loc23_);
                            _loc2_.writeInt(_loc24_);
                            _loc2_.writeInt(_loc25_);
                            _loc2_.writeBoolean(_loc26_);
                        }
                        else {
                            _loc2_.writeBoolean(false);
                        }
                        continue;
                    case FObjectType.EXT_BUTTON:
                        _loc2_.writeByte(12);
                        writeString(_loc2_, _loc14_.getAttribute("title"), true);
                        writeString(_loc2_, _loc14_.getAttribute("selectedTitle"), true);
                        writeString(_loc2_, _loc14_.getAttribute("icon"));
                        writeString(_loc2_, _loc14_.getAttribute("selectedIcon"));
                        _loc4_ = _loc14_.getAttribute("titleColor");
                        if (_loc4_) {
                            _loc2_.writeBoolean(true);
                            writeColorData(_loc2_, _loc4_);
                        }
                        else {
                            _loc2_.writeBoolean(false);
                        }
                        _loc2_.writeInt(_loc14_.getAttributeInt("titleFontSize"));
                        _loc4_ = _loc14_.getAttribute("controller");
                        if (_loc4_) {
                            _loc16_ = controllerCache[_loc4_];
                            if (_loc16_ != undefined) {
                                _loc2_.writeShort(_loc16_);
                            }
                            else {
                                _loc2_.writeShort(-1);
                            }
                        }
                        else {
                            _loc2_.writeShort(-1);
                        }
                        writeString(_loc2_, _loc14_.getAttribute("page"));
                        writeString(_loc2_, _loc14_.getAttribute("sound"), false, false);
                        _loc4_ = _loc14_.getAttribute("volume");
                        if (_loc4_) {
                            _loc2_.writeBoolean(true);
                            _loc2_.writeFloat(parseInt(_loc4_) / 100);
                        }
                        else {
                            _loc2_.writeBoolean(false);
                        }
                        _loc2_.writeBoolean(_loc14_.getAttributeBool("checked"));
                        continue;
                    case FObjectType.EXT_COMBOBOX:
                        _loc2_.writeByte(13);
                        _loc10_ = _loc2_.position;
                        _loc2_.writeShort(0);
                        _loc28_ = _loc14_.getEnumerator("item");
                        _loc7_ = 0;
                        while (_loc28_.moveNext()) {
                            _loc7_++;
                            _loc27_ = _loc28_.current;
                            _loc3_ = new ByteArray();
                            writeString(_loc3_, _loc27_.getAttribute("title"), true, false);
                            writeString(_loc3_, _loc27_.getAttribute("value"), false, false);
                            writeString(_loc3_, _loc27_.getAttribute("icon"));
                            _loc2_.writeShort(_loc3_.length);
                            _loc2_.writeBytes(_loc3_);
                            _loc3_.clear();
                        }
                        writeCount(_loc2_, _loc10_, _loc7_);
                        writeString(_loc2_, _loc14_.getAttribute("title"), true);
                        writeString(_loc2_, _loc14_.getAttribute("icon"));
                        _loc4_ = _loc14_.getAttribute("titleColor");
                        if (_loc4_) {
                            _loc2_.writeBoolean(true);
                            writeColorData(_loc2_, _loc4_);
                        }
                        else {
                            _loc2_.writeBoolean(false);
                        }
                        _loc2_.writeInt(_loc14_.getAttributeInt("visibleItemCount"));
                        _loc4_ = _loc14_.getAttribute("direction");
                        switch (_loc4_) {
                            case "down":
                                _loc2_.writeByte(2);
                                break;
                            case "up":
                                _loc2_.writeByte(1);
                                break;
                            default:
                                _loc2_.writeByte(0);
                        }
                        _loc4_ = _loc14_.getAttribute("selectionController");
                        if (_loc4_) {
                            _loc16_ = controllerCache[_loc4_];
                            if (_loc16_ != undefined) {
                                _loc2_.writeShort(_loc16_);
                            }
                            else {
                                _loc2_.writeShort(-1);
                            }
                        }
                        else {
                            _loc2_.writeShort(-1);
                        }
                        continue;
                    case FObjectType.EXT_PROGRESS_BAR:
                        _loc2_.writeByte(14);
                        _loc2_.writeInt(_loc14_.getAttributeInt("value"));
                        _loc2_.writeInt(_loc14_.getAttributeInt("max", 100));
                        _loc2_.writeInt(_loc14_.getAttributeInt("min"));
                        continue;
                    case FObjectType.EXT_SLIDER:
                        _loc2_.writeByte(15);
                        _loc2_.writeInt(_loc14_.getAttributeInt("value"));
                        _loc2_.writeInt(_loc14_.getAttributeInt("max", 100));
                        _loc2_.writeInt(_loc14_.getAttributeInt("min"));
                        continue;
                    case FObjectType.EXT_SCROLLBAR:
                        _loc2_.writeByte(16);
                        continue;
                    default:
                        continue;
                }
            }
            break;
        case FObjectType.LIST:
            _loc4_ = param1.getAttribute("selectionController");
            if (_loc4_) {
                _loc16_ = controllerCache[_loc4_];
                if (_loc16_ != undefined) {
                    _loc2_.writeShort(_loc16_);
                }
                else {
                    _loc2_.writeShort(-1);
                }
            }
            else {
                _loc2_.writeShort(-1);
            }
    }
    if (_loc12_ == FObjectType.LIST) {
        if (param1.getAttribute("overflow") == "scroll") {
            writeSegmentPos(_loc2_, 7);
            _loc3_ = writeScrollData(param1);
            _loc2_.writeBytes(_loc3_);
            _loc3_.clear();
        }
        writeSegmentPos(_loc2_, 8);
        writeString(_loc2_, param1.getAttribute("defaultItem"));
        _loc28_ = param1.getEnumerator("item");
        _loc7_ = 0;
        helperIntList.length = _loc7_;
        while (_loc28_.moveNext()) {
            _loc14_ = _loc28_.current;
            _loc29_ = _loc14_.getAttributeInt("level", 0);
            helperIntList[_loc7_] = _loc29_;
            _loc7_++;
        }
        _loc28_.reset();
        _loc6_ = 0;
        _loc2_.writeShort(_loc7_);
        while (_loc28_.moveNext()) {
            _loc14_ = _loc28_.current;
            _loc3_ = new ByteArray();
            writeString(_loc3_, _loc14_.getAttribute("url"));
            if (_loc11_ == 17) {
                _loc29_ = helperIntList[_loc6_];
                if (_loc6_ != _loc7_ - 1 && helperIntList[_loc6_ + 1] > _loc29_) {
                    _loc3_.writeBoolean(true);
                }
                else {
                    _loc3_.writeBoolean(false);
                }
                _loc3_.writeByte(_loc29_);
            }
            writeString(_loc3_, _loc14_.getAttribute("title"), true);
            writeString(_loc3_, _loc14_.getAttribute("selectedTitle"), true);
            writeString(_loc3_, _loc14_.getAttribute("icon"));
            writeString(_loc3_, _loc14_.getAttribute("selectedIcon"));
            writeString(_loc3_, _loc14_.getAttribute("name"));
            _loc4_ = _loc14_.getAttribute("controllers");
            if (_loc4_) {
                _loc5_ = _loc4_.split(",");
                _loc3_.writeShort(_loc5_.length / 2);
                _loc6_ = 0;
                while (_loc6_ < _loc5_.length) {
                    writeString(_loc3_, _loc5_[_loc6_]);
                    writeString(_loc3_, _loc5_[_loc6_ + 1]);
                    _loc6_ = _loc6_ + 2;
                }
            }
            else {
                _loc3_.writeShort(0);
            }
            writeControllerItem(_loc14_, _loc3_);
            _loc2_.writeShort(_loc3_.length);
            _loc2_.writeBytes(_loc3_);
            _loc3_.clear();
            _loc6_++;
        }
    }
    if (_loc11_ == 17) {
        writeSegmentPos(_loc2_, 9);
        _loc2_.writeInt(param1.getAttributeInt("indent", 15));
        _loc2_.writeByte(param1.getAttributeInt("clickToExpand"));
    }
    return _loc2_;
}

function writeGearData(param1: number, param2: any): ByteArray {
    var _loc3_: string = null;
    var _loc4_: Array<any> = [];
    var _loc5_: number = 0;
    var _loc6_: number = 0;
    var _loc7_: number = 0;
    var _loc9_: any = undefined;
    var _loc10_: Array<any> = [];
    var _loc11_: Array<any> = [];
    var _loc12_: boolean = false;
    var _loc13_: number = 0;
    _loc3_ = param2.getAttribute("controller");
    if (_loc3_) {
        _loc9_ = controllerCache[_loc3_];
        if (_loc9_ == undefined) {
            return null;
        }
        var _loc8_: ByteArray = new ByteArray();
        _loc8_.writeShort(_loc9_);
        if (param1 == 0 || param1 == 8) {
            _loc3_ = param2.getAttribute("pages");
            if (_loc3_) {
                _loc4_ = _loc3_.split(",");
                _loc5_ = _loc4_.length;
                if (_loc5_ == 0) {
                    return null;
                }
                _loc8_.writeShort(_loc5_);
                _loc6_ = 0;
                while (_loc6_ < _loc5_) {
                    writeString(_loc8_, _loc4_[_loc6_], false, false);
                    _loc6_++;
                }
            }
            else {
                _loc8_.writeShort(0);
            }
        }
        else {
            _loc3_ = param2.getAttribute("pages");
            if (_loc3_) {
                _loc10_ = _loc3_.split(",");
            }
            else {
                _loc10_ = [];
            }
            _loc3_ = param2.getAttribute("values");
            if (_loc3_) {
                _loc11_ = _loc3_.split("|");
            }
            else {
                _loc11_ = [];
            }
            _loc5_ = _loc10_.length;
            _loc8_.writeShort(_loc5_);
            _loc6_ = 0;
            while (_loc6_ < _loc5_) {
                _loc3_ = _loc11_[_loc6_];
                if (param1 != 6 && param1 != 7 && (!_loc3_ || _loc3_ == "-")) {
                    writeString(_loc8_, null);
                }
                else {
                    writeString(_loc8_, _loc10_[_loc6_], false, false);
                    writeGearValue(param1, _loc3_, _loc8_);
                }
                _loc6_++;
            }
            _loc3_ = param2.getAttribute("default");
            if (_loc3_) {
                _loc8_.writeBoolean(true);
                writeGearValue(param1, _loc3_, _loc8_);
            }
            else {
                _loc8_.writeBoolean(false);
            }
        }
        if (param2.getAttributeBool("tween")) {
            _loc8_.writeBoolean(true);
            _loc8_.writeByte(EaseType.parseEaseType(param2.getAttribute("ease")));
            _loc8_.writeFloat(param2.getAttributeFloat("duration", 0.3));
            _loc8_.writeFloat(param2.getAttributeFloat("delay"));
        }
        else {
            _loc8_.writeBoolean(false);
        }
        if (param1 == 1) {
            _loc12_ = param2.getAttributeBool("positionsInPercent");
            _loc8_.writeBoolean(_loc12_);
            if (_loc12_) {
                _loc6_ = 0;
                while (_loc6_ < _loc5_) {
                    _loc3_ = _loc11_[_loc6_];
                    if (_loc3_ && _loc3_ != "-") {
                        writeString(_loc8_, _loc10_[_loc6_], false, false);
                        _loc4_ = _loc3_.split(",");
                        _loc8_.writeFloat(parseFloat(_loc4_[2]));
                        _loc8_.writeFloat(parseFloat(_loc4_[3]));
                    }
                    _loc6_++;
                }
                _loc3_ = param2.getAttribute("default");
                if (_loc3_) {
                    _loc8_.writeBoolean(true);
                    _loc4_ = _loc3_.split(",");
                    _loc8_.writeFloat(parseFloat(_loc4_[2]));
                    _loc8_.writeFloat(parseFloat(_loc4_[3]));
                }
                else {
                    _loc8_.writeBoolean(false);
                }
            }
        }
        if (param1 == 8) {
            _loc13_ = param2.getAttributeInt("condition");
            _loc8_.writeByte(_loc13_);
        }
        return _loc8_;
    }
    return null;
}

function writeGearValue(type: number, value: string, ba: ByteArray): void {
    var _loc4_: Array<any> = [];
    switch (type) {
        case 1:
            _loc4_ = value.split(",");
            ba.writeInt(parseInt(_loc4_[0]));
            ba.writeInt(parseInt(_loc4_[1]));
            break;
        case 2:
            _loc4_ = value.split(",");
            ba.writeInt(parseInt(_loc4_[0]));
            ba.writeInt(parseInt(_loc4_[1]));
            if (_loc4_.length > 2) {
                ba.writeFloat(parseFloat(_loc4_[2]));
                ba.writeFloat(parseFloat(_loc4_[3]));
            }
            else {
                ba.writeFloat(1);
                ba.writeFloat(1);
            }
            break;
        case 3:
            _loc4_ = value.split(",");
            ba.writeFloat(parseFloat(_loc4_[0]));
            ba.writeFloat(parseFloat(_loc4_[1]));
            ba.writeBoolean(_loc4_[2] == "1");
            ba.writeBoolean(_loc4_.length < 4 || _loc4_[3] == "1");
            break;
        case 4:
            _loc4_ = value.split(",");
            if (_loc4_.length < 2) {
                writeColorData(ba, _loc4_[0]);
                writeColorData(ba, "#000000");
            }
            else {
                writeColorData(ba, _loc4_[0]);
                writeColorData(ba, _loc4_[1]);
            }
            break;
        case 5:
            _loc4_ = value.split(",");
            ba.writeBoolean(_loc4_[1] == "p");
            ba.writeInt(parseInt(_loc4_[0]));
            break;
        case 6:
            writeString(ba, value, true);
            break;
        case 7:
            writeString(ba, value);
            break;
        case 9:
            ba.writeInt(parseInt(value));
    }
}

function writeMovieClipData(param1: string, param2: any): ByteArray {
    //  var _loc5_:string = null;
    //  var _loc6_:Array<any> = [];
    //  var _loc7_:ByteArray = null;
    //  var _loc10_:any;
    //  var _loc11_:number = 0;
    //  var _loc3_:any = any.attach(param2);
    var _loc4_: ByteArray = new ByteArray();
    //  startSegments(_loc4_,2,false);
    //  writeSegmentPos(_loc4_,0);
    //  _loc4_.writeInt(_loc3_.getAttributeInt("interval"));
    //  _loc4_.writeBoolean(_loc3_.getAttributeBool("swing"));
    //  _loc4_.writeInt(_loc3_.getAttributeInt("repeatDelay"));
    //  writeSegmentPos(_loc4_,1);
    //  var _loc8_:any = _loc3_.getChild("frames").getEnumerator("frame");
    //  _loc4_.writeShort(_loc3_.getAttributeInt("frameCount"));
    //  var _loc9_:number = 0;
    //  while(_loc8_.moveNext())
    //  {
    //     _loc10_ = _loc8_.current;
    //     _loc5_ = _loc10_.getAttribute("rect");
    //     _loc6_ = _loc5_.split(",");
    //     _loc7_ = new ByteArray();
    //     _loc7_.writeInt(parseInt(_loc6_[0]));
    //     _loc7_.writeInt(parseInt(_loc6_[1]));
    //     _loc11_ = parseInt(_loc6_[2]);
    //     _loc7_.writeInt(_loc11_);
    //     _loc7_.writeInt(parseInt(_loc6_[3]));
    //     _loc7_.writeInt(_loc10_.getAttributeInt("addDelay"));
    //     _loc5_ = _loc10_.getAttribute("sprite");
    //     if(_loc5_)
    //     {
    //        writeString(_loc7_,param1 + "_" + _loc5_);
    //     }
    //     else if(_loc11_)
    //     {
    //        writeString(_loc7_,param1 + "_" + _loc9_);
    //     }
    //     else
    //     {
    //        writeString(_loc7_,null);
    //     }
    //     _loc4_.writeShort(_loc7_.length);
    //     _loc4_.writeBytes(_loc7_);
    //     _loc7_.clear();
    //     _loc9_++;
    //  }
    return _loc4_;
}

function writeFontData(param1: string, param2: string): ByteArray {
    var _loc4_: ByteArray = null;
    var _loc7_: number = 0;
    var _loc8_: { [key: string]: any } = {};
    var _loc17_: number = 0;
    var _loc18_: number = 0;
    var _loc19_: number = 0;
    var _loc20_: number = 0;
    var _loc21_: number = 0;
    var _loc22_: number = 0;
    var _loc23_: string = null;
    var _loc24_: Array<any> = [];
    var _loc25_: number = 0;
    var _loc26_: Array<any> = [];
    var _loc27_: string = null;
    var _loc28_: number = 0;
    var _loc3_: ByteArray = new ByteArray();
    var _loc5_: Array<any> = param2.split("\n");
    var _loc6_: number = _loc5_.length;
    var _loc9_: any = false;
    var _loc10_: any = false;
    var _loc11_: any = false;
    var _loc12_: boolean = false;
    var _loc13_: number = 0;
    var _loc14_: number = 0;
    var _loc15_: number = 0;
    var _loc16_: number = 0;
    _loc7_ = 0;
    for (; _loc7_ < _loc6_; _loc7_++) {
        _loc23_ = _loc5_[_loc7_];
        if (_loc23_) {
            _loc23_ = _loc23_.trim();
            _loc24_ = _loc23_.split(" ");
            _loc8_ = {};
            _loc25_ = 1;
            while (_loc25_ < _loc24_.length) {
                _loc26_ = _loc24_[_loc25_].split("=");
                _loc8_[_loc26_[0]] = _loc26_[1];
                _loc25_++;
            }
            _loc23_ = _loc24_[0];
            if (_loc23_ == "char") {
                _loc27_ = _loc8_["img"];
                if (!_loc9_) {
                    if (!_loc27_) {
                        continue;
                    }
                }
                _loc28_ = _loc8_["id"];
                if (_loc28_ != 0) {
                    _loc17_ = _loc8_["xoffset"];
                    _loc18_ = _loc8_["yoffset"];
                    _loc19_ = _loc8_["width"];
                    _loc20_ = _loc8_["height"];
                    _loc21_ = _loc8_["xadvance"];
                    _loc22_ = _loc8_["chnl"];
                    if (_loc22_ != 0 && _loc22_ != 15) {
                        _loc12_ = true;
                    }
                    _loc4_ = new ByteArray();
                    _loc4_.writeShort(_loc28_);
                    writeString(_loc4_, _loc27_);
                    _loc4_.writeInt(_loc8_["x"]);
                    _loc4_.writeInt(_loc8_["y"]);
                    _loc4_.writeInt(_loc17_);
                    _loc4_.writeInt(_loc18_);
                    _loc4_.writeInt(_loc19_);
                    _loc4_.writeInt(_loc20_);
                    _loc4_.writeInt(_loc21_);
                    _loc4_.writeByte(_loc22_);
                    _loc3_.writeShort(_loc4_.length);
                    _loc3_.writeBytes(_loc4_);
                    _loc4_.clear();
                    _loc16_++;
                }
            }
            else if (_loc23_ == "info") {
                _loc9_ = _loc8_.face != null;
                _loc10_ = Boolean(_loc9_);
                _loc13_ = _loc8_.size;
                _loc11_ = _loc8_.resizable == "true";
                if (_loc8_.colored != undefined) {
                    _loc10_ = _loc8_.colored == "true";
                }
            }
            else if (_loc23_ == "common") {
                _loc14_ = _loc8_.lineHeight;
                _loc15_ = _loc8_.xadvance;
                if (_loc13_ == 0) {
                    _loc13_ = _loc14_;
                }
                else if (_loc14_ == 0) {
                    _loc14_ = _loc13_;
                    continue;
                }
                continue;
            }
        }
    }
    _loc4_ = _loc3_;
    _loc3_ = new ByteArray();
    startSegments(_loc3_, 2, false);
    writeSegmentPos(_loc3_, 0);
    _loc3_.writeBoolean(_loc9_);
    _loc3_.writeBoolean(_loc10_);
    _loc3_.writeBoolean(_loc13_ > 0 ? Boolean(_loc11_) : false);
    _loc3_.writeBoolean(_loc12_);
    _loc3_.writeInt(_loc13_);
    _loc3_.writeInt(_loc15_);
    _loc3_.writeInt(_loc14_);
    writeSegmentPos(_loc3_, 1);
    _loc3_.writeInt(_loc16_);
    _loc3_.writeBytes(_loc4_);
    _loc4_.clear();
    return _loc3_;
}

function writeColorData(ba: ByteArray, color: string, alpha: boolean = true, param4: number = 4.27819008E9): void {
    var _loc5_: number = 0;
    if (color) {
        _loc5_ = convertFromHtmlColor(color, alpha);
    } else {
        _loc5_ = param4;
    }
    ba.writeByte(_loc5_ >> 16 & 255);
    ba.writeByte(_loc5_ >> 8 & 255);
    ba.writeByte(_loc5_ & 255);
    if (alpha) {
        ba.writeByte(_loc5_ >> 24 & 255);
    } else {
        ba.writeByte(255);
    }
}

function writeAlignData(ba: ByteArray, type: string): void {
    switch (type) {
        case "left":
            ba.writeByte(0);
            break;
        case "center":
            ba.writeByte(1);
            break;
        case "right":
            ba.writeByte(2);
            break;
        default:
            ba.writeByte(0);
    }
}

function writeValignData(ba: ByteArray, type: string): void {
    switch (type) {
        case "top":
            ba.writeByte(0);
            break;
        case "middle":
            ba.writeByte(1);
            break;
        case "bottom":
            ba.writeByte(2);
            break;
        default:
            ba.writeByte(0);
    }
}

function writeFillMethodData(ba: ByteArray, type: string): void {
    switch (type) {
        case "none":
            ba.writeByte(0);
            break;
        case "hz":
            ba.writeByte(1);
            break;
        case "vt":
            ba.writeByte(2);
            break;
        case "radial90":
            ba.writeByte(3);
            break;
        case "radial180":
            ba.writeByte(4);
            break;
        case "radial360":
            ba.writeByte(5);
            break;
        default:
            ba.writeByte(0);
    }
}

function writeTextSizeData(ba: ByteArray, type: string): void {
    switch (type) {
        case "none":
            ba.writeByte(0);
            break;
        case "both":
            ba.writeByte(1);
            break;
        case "height":
            ba.writeByte(2);
            break;
        case "shrink":
            ba.writeByte(3);
            break;
        default:
            ba.writeByte(0);
    }
}

function writeTransitionTypeData(ba: ByteArray, type: string): void {
    switch (type) {
        case "XY":
            ba.writeByte(0);
            break;
        case "Size":
            ba.writeByte(1);
            break;
        case "Scale":
            ba.writeByte(2);
            break;
        case "Pivot":
            ba.writeByte(3);
            break;
        case "Alpha":
            ba.writeByte(4);
            break;
        case "Rotation":
            ba.writeByte(5);
            break;
        case "Color":
            ba.writeByte(6);
            break;
        case "Animation":
            ba.writeByte(7);
            break;
        case "Visible":
            ba.writeByte(8);
            break;
        case "Sound":
            ba.writeByte(9);
            break;
        case "Transition":
            ba.writeByte(10);
            break;
        case "Shake":
            ba.writeByte(11);
            break;
        case "ColorFilter":
            ba.writeByte(12);
            break;
        case "Skew":
            ba.writeByte(13);
            break;
        case "Text":
            ba.writeByte(14);
            break;
        case "Icon":
            ba.writeByte(15);
            break;
        default:
            ba.writeByte(16);
    }
}

function writeGraphData(ba: ByteArray, type: string): number {
    switch (type) {
        case "rect":
            ba.writeByte(1);
            return 1;
        case "ellipse":
        case "eclipse":
            ba.writeByte(2);
            return 2;
        case "polygon":
            ba.writeByte(3);
            return 3;
        case "regular_polygon":
            ba.writeByte(4);
            return 4;
        default:
            return 0;
    }
}

function writeTransitionValue(param1: ByteArray, param2: string, param3: string): void {
    //  encodeTransition(param2,param3);
    //  encodeBinaryTransition(param2,param1,writeString);
}

//   function encodeTransition(param1:String) : String
//   {
//      var _loc2_:any = null;
//      switch(param1)
//      {
//         case "XY":
//         case "Size":
//         case "Pivot":
//            _loc2_ = "";
//            if(this.b1)
//            {
//               _loc2_ = _loc2_ + UtilsStr.toFixed(this.f1);
//            }
//            else
//            {
//               _loc2_ = _loc2_ + "-";
//            }
//            _loc2_ = _loc2_ + ",";
//            if(this.b2)
//            {
//               _loc2_ = _loc2_ + UtilsStr.toFixed(this.f2);
//            }
//            else
//            {
//               _loc2_ = _loc2_ + "-";
//            }
//            if(this.b3)
//            {
//               _loc2_ = _loc2_ + ("," + UtilsStr.toFixed(this.f3,3) + "," + UtilsStr.toFixed(this.f4,3));
//            }
//            return _loc2_;
//         case "Alpha":
//            return "" + UtilsStr.toFixed(this.f1);
//         case "Rotation":
//            return "" + UtilsStr.toFixed(this.f1);
//         case "Scale":
//         case "Skew":
//            return "" + UtilsStr.toFixed(this.f1) + "," + UtilsStr.toFixed(this.f2);
//         case "Color":
//            return UtilsStr.convertToHtmlColor(this.iu,false);
//         case "Animation":
//            _loc2_ = "";
//            if(this.b1)
//            {
//               _loc2_ = _loc2_ + this.i;
//            }
//            else
//            {
//               _loc2_ = _loc2_ + "-";
//            }
//            _loc2_ = _loc2_ + ("," + (!!this.b2?"p":"s"));
//            return _loc2_;
//         case "Sound":
//            if(this.i != 0)
//            {
//               return this.s + "," + this.i;
//            }
//            return this.s;
//         case "Transition":
//            if(this.i != 1)
//            {
//               return this.s + "," + this.i;
//            }
//            return this.s;
//         case "Shake":
//            return "" + UtilsStr.toFixed(this.f1) + "," + UtilsStr.toFixed(this.f2);
//         case "Visible":
//            return "" + this.b1;
//         case "ColorFilter":
//            return this.f1.toFixed(2) + "," + this.f2.toFixed(2) + "," + this.f3.toFixed(2) + "," + this.f4.toFixed(2);
//         case "Text":
//         case "Icon":
//            return this.s;
//         default:
//            return null;
//      }
//   }

function encodeBinaryTransition(param1: string, param2: ByteArray, param3: Function): void {
    //  switch(param1)
    //  {
    //     case "XY":
    //        param2.writeBoolean(this.b1);
    //        param2.writeBoolean(this.b2);
    //        if(this.b3)
    //        {
    //           param2.writeFloat(this.f3);
    //           param2.writeFloat(this.f4);
    //        }
    //        else
    //        {
    //           param2.writeFloat(this.f1);
    //           param2.writeFloat(this.f2);
    //        }
    //        param2.writeBoolean(this.b3);
    //        break;
    //     case "Size":
    //     case "Pivot":
    //     case "Skew":
    //        param2.writeBoolean(this.b1);
    //        param2.writeBoolean(this.b2);
    //        param2.writeFloat(this.f1);
    //        param2.writeFloat(this.f2);
    //        break;
    //     case "Alpha":
    //     case "Rotation":
    //        param2.writeFloat(this.f1);
    //        break;
    //     case "Scale":
    //        param2.writeFloat(this.f1);
    //        param2.writeFloat(this.f2);
    //        break;
    //     case "Color":
    //        param2.writeByte(this.iu >> 16 & 255);
    //        param2.writeByte(this.iu >> 8 & 255);
    //        param2.writeByte(this.iu & 255);
    //        param2.writeByte(255);
    //        break;
    //     case "Animation":
    //        param2.writeBoolean(this.b2);
    //        param2.writeInt(!!this.b1?int(this.i):-1);
    //        break;
    //     case "Sound":
    //        param3(param2,this.s,false,false);
    //        param2.writeFloat(this.i / 100);
    //        break;
    //     case "Transition":
    //        param3(param2,this.s,false,false);
    //        param2.writeInt(this.i);
    //        break;
    //     case "Shake":
    //        param2.writeFloat(this.f1);
    //        param2.writeFloat(this.f2);
    //        break;
    //     case "Visible":
    //        param2.writeBoolean(this.b1);
    //        break;
    //     case "ColorFilter":
    //        param2.writeFloat(this.f1);
    //        param2.writeFloat(this.f2);
    //        param2.writeFloat(this.f3);
    //        param2.writeFloat(this.f4);
    //        break;
    //     case "Text":
    //        param3(param2,this.s,true);
    //        break;
    //     case "Icon":
    //        param3(param2,this.s);
}


function startSegments(ba: ByteArray, segment: number, bool: boolean): void {
    ba.writeByte(segment);
    ba.writeBoolean(bool);
    let idx = 0;
    while (idx < segment) {
        if (bool) {
            ba.writeShort(0);
        }
        else {
            ba.writeInt(0);
        }
        idx++;
    }
}

function writeSegmentPos(ba: ByteArray, pos: number) {
    let position = ba.position;
    ba.position = 1;
    let _loc4_ = ba.readBoolean();
    ba.position = 2 + pos * (_loc4_ ? 2 : 4);
    if (_loc4_) {
        ba.writeShort(position);
    }
    else {
        ba.writeInt(position);
    }
    ba.position = position;
}

function writeString(ba: ByteArray, str: string, param3: boolean = false, param4: boolean = true): void {
    let value;
    if (param4) {
        if (!str) {
            ba.writeShort(65534);
            return;
        }
    } else {
        if (str == null) {
            ba.writeShort(65534);
            return;
        }
        if (str.length == 0) {
            ba.writeShort(65533);
            return;
        }
    }
    if (!param3) {
        value = stringMap[str];
        if (value != undefined) {
            ba.writeShort(Number(value));
            return;
        }
    }
    stringTable.push(str);
    if (!param3) {
        stringMap[str] = stringTable.length - 1;
    }
    ba.writeShort(stringTable.length - 1);
}

function writeCount(ba: ByteArray, position: number, count: number): void {
    var _loc4_: number = ba.position;
    ba.position = position;
    ba.writeShort(count);
    ba.position = _loc4_;
}

publish();



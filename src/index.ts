import ByteArray from "./utils/ByteArray";
import fs from "fs";
import { parse } from "fast-xml-parser";
import ProjectType from "./fairygui/editor/api/ProjectType";
import { type } from "os";
import { convertFromHtmlColor, encodeHTML, getAttribute, getAttributeBool, getAttributeFloat, getAttributeInt, isH5 } from "./utils/utils";
import FObjectType from "./fairygui/editor/api/FObjectType";
import { CurveType, EaseType, FButton, FGearBase, FPackageItemType } from "./constants";

process.on('uncaughtException', function (e) {
    debugger;
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
let controllerCnt = 0,
    controllerCache: { [key: string]: any } = {},
    displayList: { [key: string]: any } = {};
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
    pkgName = "Basics",
    version: number = 2,
    spriteMap: Map<string, IBaseResource> = new Map();
let hitTestData = new ByteArray();
let hitTestImages: Array<IHitTestImage> = [];
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
    } else if (projectType == ProjectType.COCOS2DX || projectType == ProjectType.VISION) {
        if (binaryFormat) {
            fileExtension = "fui";
        } else {
            fileExtension = "bytes";
        }
    } else if (projectType == ProjectType.CRY || projectType == ProjectType.MONOGAME || projectType == ProjectType.CORONA) {
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
    name = encodeHTML(name);
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
    let ba = new ByteArray();
    let ba2 = new ByteArray();
    let i = 0;
    let itemId: string = "";
    var atlasId: string = "";
    var binIndex: number = 0;
    let str: string = "";
    var pos: number = 0;
    var len: number = 0;
    let longStrings: ByteArray;
    let cntPos: number = 0;

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
    ba.writeShort(resourceArr.length);
    console.log(resourceArr);

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

    while (i < cnt) {
        // arr = spriteMap[i];
        // ba2 = new ByteArray();
        // itemId = arr[0];
        // writeString(ba2, itemId);
        // binIndex = parseInt(arr[1]);
        // if (binIndex >= 0) {
        //     atlasId = "atlas" + binIndex;
        // }
        // else {
        //     pos = itemId.indexOf("_");
        //     if (pos == -1) {
        //         atlasId = "atlas_" + itemId;
        //     }
        //     else {
        //         atlasId = "atlas_" + itemId.substring(0, pos);
        //     }
        // }
        // writeString(ba2, atlasId);
        // ba2.writeInt(arr[2]);
        // ba2.writeInt(arr[3]);
        // ba2.writeInt(arr[4]);
        // ba2.writeInt(arr[5]);
        // ba2.writeBoolean(arr[6]);
        // if (arr[7] != undefined && (arr[7] != 0 || arr[8] != 0 || arr[9] != arr[4] || arr[10] != arr[5])) {
        //     ba2.writeBoolean(true);
        //     ba2.writeInt(arr[7]);
        //     ba2.writeInt(arr[8]);
        //     ba2.writeInt(arr[9]);
        //     ba2.writeInt(arr[10]);
        // }
        // else {
        //     ba2.writeBoolean(false);
        // }
        // ba.writeShort(ba2.length);
        // ba.writeBytes(ba2);
        // ba2.clear();
        // i++;
    }

    // hitTestData
    if (hitTestData.length > 0) {
        writeSegmentPos(ba, 3);
        ba2 = hitTestData; // writeHitTestImages
        ba2.position = 0;
        cntPos = ba.position;
        ba.writeShort(0);
        cnt = 0;
        while (ba2.bytesAvailable) {
            str = ba2.readUTF();
            pos = ba2.position;
            ba2.position = ba2.position + 9;
            len = ba2.readInt();
            ba.writeInt(len + 15);
            writeString(ba, str);
            ba.writeBytes(ba2, pos, len + 13);
            ba2.position = pos + 13 + len;
            cnt++;
        }
        writeCount(ba, cntPos, cnt);
    }

    writeSegmentPos(ba, 4);
    var longStringsCnt: number = 0;
    cnt = stringTable.length;
    ba.writeInt(cnt);
    i = 0;
    while (i < cnt) {
        // try
        // {
        ba.writeUTF(stringTable[i]);
        // }
        // catch(err:RangeError)
        // {
        ba.writeShort(0);
        if (longStrings == null) {
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
        // }
        i++;
    }
    if (longStringsCnt > 0) {
        writeSegmentPos(ba, 5);
        ba.writeInt(longStringsCnt);
        ba.writeBytes(longStrings);
        longStrings.clear();
    }
    ba2 = ba;

    if (compress) {
        // ba2.deflate();
    }
    ba = new ByteArray();
    writeHead(ba, { version, pkgId, pkgName });
    ba.writeBytes(ba2);
    ba2.clear();

    return ba;
}

function publish() {
    getProjectConfig();
    console.log(`Publish start: ${pkgName}`)
    let ba = encode();

    let fileExtension = getFileExtension(projectType);

    fs.writeFileSync(`${targetPath}/${pkgName}.${fileExtension}`, ba.data);
}

function writeResourceItem(resource: ResourceType): ByteArray {
    let _loc3_: ByteArray = null;
    let _loc4_: string = "";
    let _loc5_: Array<string> = [];
    let _loc6_: number = 0;
    let value: string = "";
    let _loc9_: IComponentFile = null;
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
    } else {
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
                _loc3_ = writeGObjectData(value, _loc9_);
                ba.writeInt(_loc3_.length);
                ba.writeBytes(_loc3_);
                _loc3_.clear();
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
    } else {
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

function writeGObjectData(value: string, xml: IComponentFile): ByteArray {
    var str: string = null;
    var strArr: Array<string> = null;
    var idx: number = 0;
    var childrenLen: number = 0;
    var children: Array<IBaseElement> = null;
    var _loc9_: any = null;
    var tempByteArray: ByteArray = null;
    var position: number = 0;
    var child: any = null;
    var ba: ByteArray = new ByteArray();
    controllerCache = {};
    controllerCnt = 0;
    displayList = {};
    _loc9_ = xml.displayList;
    if (_loc9_ != null) {
        children = getChildren(_loc9_);
        childrenLen = children.length;
        idx = 0;
        while (idx < childrenLen) {
            displayList[children[idx].id] = idx;
            idx++;
        }
    }
    startSegments(ba, 8, false);
    writeSegmentPos(ba, 0);
    str = xml.size || "";
    strArr = str.split(",");
    ba.writeInt(parseInt(strArr[0]));
    ba.writeInt(parseInt(strArr[1]));
    str = xml.restrictSize; // 最小&最大尺寸
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeInt(parseInt(strArr[0]));
        ba.writeInt(parseInt(strArr[1]));
        ba.writeInt(parseInt(strArr[2]));
        ba.writeInt(parseInt(strArr[3]));
    } else {
        ba.writeBoolean(false);
    }
    str = xml.pivot;
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeFloat(parseFloat(strArr[0]));
        ba.writeFloat(parseFloat(strArr[1]));
        ba.writeBoolean(xml.anchor == "true");
    } else {
        ba.writeBoolean(false);
    }
    str = xml.margin;
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeInt(parseInt(strArr[0]));
        ba.writeInt(parseInt(strArr[1]));
        ba.writeInt(parseInt(strArr[2]));
        ba.writeInt(parseInt(strArr[3]));
    } else {
        ba.writeBoolean(false);
    }
    var _loc12_: Boolean = false;
    str = xml.overflow;
    if (str == "hidden") {
        ba.writeByte(1);
    } else if (str == "scroll") {
        ba.writeByte(2);
        _loc12_ = true;
    } else {
        ba.writeByte(0);
    }
    str = xml.clipSoftness;
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeInt(parseInt(strArr[0]));
        ba.writeInt(parseInt(strArr[1]));
    } else {
        ba.writeBoolean(false);
    }
    writeSegmentPos(ba, 1);
    childrenLen = 0;
    position = ba.position;
    ba.writeShort(0);
    var controllers: IController | IController[] = xml.controller;
    if (controllers) {
        let controllerIdx = 0, controllerTotal = 0;
        if (Array.isArray(controllers)) {
            for (let controller of controllers) {
                controllerIdx = 0;
                controllerTotal = controller.pages.split(",").length / 2;
                while (controllerIdx < controllerTotal) {
                    tempByteArray = writeControllerData(controller);
                    ba.writeShort(tempByteArray.length);
                    ba.writeBytes(tempByteArray);
                    tempByteArray.clear();
                    controllerIdx++;
                    childrenLen++;
                }
            }
        } else {
            controllerIdx = 0;
            controllerTotal = controllers.pages.split(",").length / 2;
            while (controllerIdx < controllerTotal) {
                tempByteArray = writeControllerData(controllers);
                ba.writeShort(tempByteArray.length);
                ba.writeBytes(tempByteArray);
                tempByteArray.clear();
                controllerIdx++;
                childrenLen++;
            }
        }
    }
    writeCount(ba, position, childrenLen);
    writeSegmentPos(ba, 2);
    if (_loc9_ != null) {
        children = getChildren(_loc9_);
        childrenLen = children.length;
        ba.writeShort(childrenLen);
        idx = 0;
        while (idx < childrenLen) {
            tempByteArray = addComponent(children[idx]);
            ba.writeShort(tempByteArray.length);
            ba.writeBytes(tempByteArray);
            tempByteArray.clear();
            idx++;
        }
    } else {
        ba.writeShort(0);
    }
    writeSegmentPos(ba, 3);
    writeRelation(xml, ba, true);
    writeSegmentPos(ba, 4);
    writeString(ba, xml.customData, true);
    let opaque = xml.opaque ? Boolean(xml.opaque) : true;
    ba.writeBoolean(opaque);
    str = xml.mask;
    if (displayList[str] != undefined) {
        ba.writeShort(displayList[str]);
        let reversedMask = Boolean(xml.reversedMask);
        ba.writeBoolean(reversedMask);
    } else {
        ba.writeShort(-1);
    }
    str = xml.hitTest;
    if (str) {
        strArr = str.split(",");
        if (strArr.length == 1) {
            writeString(ba, null);
            ba.writeInt(1);
            if (displayList[strArr[0]] != undefined) {
                ba.writeInt(displayList[strArr[0]]);
            }
            else {
                ba.writeInt(-1);
            }
        }
        else {
            writeString(ba, strArr[0]);
            ba.writeInt(parseInt(strArr[1]));
            ba.writeInt(parseInt(strArr[2]));
        }
    } else {
        writeString(ba, null);
        ba.writeInt(0);
        ba.writeInt(0);
    }
    writeSegmentPos(ba, 5);
    childrenLen = 0;
    position = ba.position;
    ba.writeShort(0);
    // _loc13_ = xml.getEnumerator("transition");
    // while (_loc13_.moveNext()) {
    //     tempByteArray = writeTransitionData(_loc13_.current);
    //     ba.writeShort(tempByteArray.length);
    //     ba.writeBytes(tempByteArray);
    //     tempByteArray.clear();
    //     childrenLen++;
    // }
    // writeCount(ba, position, childrenLen);
    // var _loc14_: string = xml.getAttribute("extention");
    // if (_loc14_) {
    //     writeSegmentPos(ba, 6);
    //     child = xml.getChild(_loc14_);
    //     if (!child) {
    //         // child = any.create(_loc14_);
    //     }
    //     switch (_loc14_) {
    //         case FObjectType.EXT_LABEL:
    //             break;
    //         case FObjectType.EXT_BUTTON:
    //             str = child.getAttribute("mode");
    //             if (str == FButton.CHECK) {
    //                 ba.writeByte(1);
    //             }
    //             else if (str == FButton.RADIO) {
    //                 ba.writeByte(2);
    //             }
    //             else {
    //                 ba.writeByte(0);
    //             }
    //             writeString(ba, child.getAttribute("sound"));
    //             ba.writeFloat(child.getAttributeInt("volume", 100) / 100);
    //             str = child.getAttribute("downEffect", "none");
    //             if (str == "dark") {
    //                 ba.writeByte(1);
    //             }
    //             else if (str == "scale") {
    //                 ba.writeByte(2);
    //             }
    //             else {
    //                 ba.writeByte(0);
    //             }
    //             ba.writeFloat(child.getAttributeFloat("downEffectValue", 0.8));
    //             break;
    //         case FObjectType.EXT_COMBOBOX:
    //             writeString(ba, child.getAttribute("dropdown"));
    //             break;
    //         case FObjectType.EXT_PROGRESS_BAR:
    //             str = child.getAttribute("titleType");
    //             switch (str) {
    //                 case "percent":
    //                     ba.writeByte(0);
    //                     break;
    //                 case "valueAndmax":
    //                     ba.writeByte(1);
    //                     break;
    //                 case "value":
    //                     ba.writeByte(2);
    //                     break;
    //                 case "max":
    //                     ba.writeByte(3);
    //                     break;
    //                 default:
    //                     ba.writeByte(0);
    //             }
    //             ba.writeBoolean(child.getAttributeBool("reverse"));
    //             break;
    //         case FObjectType.EXT_SLIDER:
    //             str = child.getAttribute("titleType");
    //             switch (str) {
    //                 case "percent":
    //                     ba.writeByte(0);
    //                     break;
    //                 case "valueAndmax":
    //                     ba.writeByte(1);
    //                     break;
    //                 case "value":
    //                     ba.writeByte(2);
    //                     break;
    //                 case "max":
    //                     ba.writeByte(3);
    //                     break;
    //                 default:
    //                     ba.writeByte(0);
    //             }
    //             ba.writeBoolean(child.getAttributeBool("reverse"));
    //             ba.writeBoolean(child.getAttributeBool("wholeNumbers"));
    //             ba.writeBoolean(child.getAttributeBool("changeOnClick", true));
    //             break;
    //         case FObjectType.EXT_SCROLLBAR:
    //             ba.writeBoolean(child.getAttributeBool("fixedGripSize"));
    //     }
    // }
    // if (_loc12_) {
    //     writeSegmentPos(ba, 7);
    //     tempByteArray = writeScrollData(xml);
    //     ba.writeBytes(tempByteArray);
    //     tempByteArray.clear();
    // }
    return ba;
}

function writeScrollData(element: any): ByteArray {
    var str: string = "";
    var strArr: Array<string>;
    var ba: ByteArray = new ByteArray();
    str = getAttribute(element,"scroll");
    if (str == "horizontal") {
        ba.writeByte(0);
    } else if (str == "both") {
        ba.writeByte(2);
    } else {
        ba.writeByte(1);
    }
    str = getAttribute(element,"scrollBar");
    if (str == "visible") {
        ba.writeByte(1);
    } else if (str == "auto") {
        ba.writeByte(2);
    } else if (str == "hidden") {
        ba.writeByte(3);
    } else {
        ba.writeByte(0);
    }
    ba.writeInt(getAttributeInt(element,"scrollBarFlags"));
    str = getAttribute(element,"scrollBarMargin");
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeInt(parseInt(strArr[0]));
        ba.writeInt(parseInt(strArr[1]));
        ba.writeInt(parseInt(strArr[2]));
        ba.writeInt(parseInt(strArr[3]));
    } else {
        ba.writeBoolean(false);
    }
    str = getAttribute(element,"scrollBarRes");
    if (str) {
        strArr = str.split(",");
        writeString(ba, strArr[0]);
        writeString(ba, strArr[1]);
    } else {
        writeString(ba, null);
        writeString(ba, null);
    }
    str = getAttribute(element,"ptrRes");
    if (str) {
        strArr = str.split(",");
        writeString(ba, strArr[0]);
        writeString(ba, strArr[1]);
    } else {
        writeString(ba, null);
        writeString(ba, null);
    }
    return ba;
}


function writeControllerData(controller: IController): ByteArray {
    var _loc3_: ByteArray = null;
    var str: string = null;
    var strArr: Array<string> = [];
    var _loc6_: number = 0;
    var pageIdx: number = 0;
    var _loc8_: number = 0;
    var homePageType: string = null;
    var homePage: string = null;
    var _loc13_: number = 0;
    var ba: ByteArray = new ByteArray();
    startSegments(ba, 3, true);
    writeSegmentPos(ba, 0);
    str = controller.name;
    writeString(ba, str);
    controllerCache[str] = controllerCnt++;
    let autoRadioGroupDepth = getAttributeBool(controller, "autoRadioGroupDepth");
    ba.writeBoolean(autoRadioGroupDepth);
    writeSegmentPos(ba, 1);
    str = controller.pages;
    if (str) {
        strArr = str.split(",");
        pageIdx = strArr.length / 2;
        ba.writeShort(pageIdx);
        _loc6_ = 0;
        while (_loc6_ < pageIdx) {
            writeString(ba, strArr[_loc6_ * 2], false, false);
            writeString(ba, strArr[_loc6_ * 2 + 1], false, false);
            _loc6_++;
        }
        homePageType = controller.homePageType || "default";
        homePage = controller.homePage || "";
        _loc13_ = 0;
        if (homePageType == "specific") {
            _loc6_ = 0;
            while (_loc6_ < pageIdx) {
                if (strArr[_loc6_ * 2] == homePage) {
                    _loc13_ = _loc6_;
                    break;
                }
                _loc6_++;
            }
        }
        switch (homePageType) {
            case "specific":
                ba.writeByte(1);
                ba.writeShort(_loc13_);
                break;
            case "branch":
                ba.writeByte(2);
                break;
            case "variable":
                ba.writeByte(3);
                writeString(ba, homePage);
                break;
            default:
                ba.writeByte(0);
        }
    } else {
        ba.writeShort(0);
        ba.writeByte(0);
    }
    writeSegmentPos(ba, 2);
    var actions: IControllerActionType | IControllerActionType[] = controller.action; // feat. 后续应该会增加其他行为
    pageIdx = 0;
    _loc8_ = ba.position;
    ba.writeShort(0);
    // for (_loc10_ in action) {
    if (actions) {
        if (Array.isArray(actions)) {
            for (let action of actions) {
                str = action.type;
                _loc3_ = writeActionData(action);
                ba.writeShort(_loc3_.length + 1);
                if (str == "play_transition") {
                    ba.writeByte(0);
                }
                else if (str == "change_page") {
                    ba.writeByte(1);
                }
                else {
                    ba.writeByte(0);
                }
                ba.writeBytes(_loc3_);
                pageIdx++;
            }
        } else {
            str = actions.type;
            _loc3_ = writeActionData(actions);
            ba.writeShort(_loc3_.length + 1);
            if (str == "play_transition") {
                ba.writeByte(0);
            }
            else if (str == "change_page") {
                ba.writeByte(1);
            }
            else {
                ba.writeByte(0);
            }
            ba.writeBytes(_loc3_);
            pageIdx++;
        }

    }
    // }
    writeCount(ba, _loc8_, pageIdx);
    return ba;
}

function writeActionData(action: IControllerActionType): ByteArray {
    var fromPage: string = "";
    var strArr: Array<any> = [];
    var strLength: number = 0;
    var idx: number = 0;
    var ba: ByteArray = new ByteArray();
    fromPage = action.fromPage;
    if (fromPage) {
        strArr = fromPage.split(",");
        strLength = strArr.length;
        ba.writeShort(strLength);
        idx = 0;
        while (idx < strLength) {
            writeString(ba, strArr[idx]);
            idx++;
        }
    } else {
        ba.writeShort(0);
    }
    fromPage = action.toPage;
    if (fromPage) {
        strArr = fromPage.split(",");
        strLength = strArr.length;
        ba.writeShort(strLength);
        idx = 0;
        while (idx < strLength) {
            writeString(ba, strArr[idx]);
            idx++;
        }
    } else {
        ba.writeShort(0);
    }
    if (action.type == "play_transition") {
        writeString(ba, action.transition);
        let repeat = getAttributeInt(action, "repeat", 1)
        ba.writeInt(repeat);
        let delay = getAttributeFloat(action, "delay")
        ba.writeFloat(delay);
        let stopOnExit = getAttributeBool(action, "stopOnExit");
        ba.writeBoolean(stopOnExit);
    } else if (action.type == "change_page") {
        writeString(ba, action.objectId); // objectId is null
        writeString(ba, action.controller);
        writeString(ba, action.targetPage);
    }
    return ba;
}

function writeRelation(relations: any, ba: ByteArray, param3: boolean): void {
    var _loc4_: string = null;
    var _loc5_: Array<any> = [];
    var relation: any;
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
    let relationLen = relations.length;
    let relationIdx = 0;
    while (relationIdx < relationLen) {
        relation = relations[relationIdx];
        _loc4_ = relation.target;
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
        _loc4_ = relation.sidePair;
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
        relationIdx++;
    }
    ba.writeByte(_loc6_.length);
    for (let item of _loc6_) {
        ba.writeShort(item);
        _loc11_ = _loc7_[item];
        ba.writeByte(_loc11_.length);
        for (let i of _loc11_) {
            if (i >= 10000) {
                ba.writeByte(i - 10000);
                ba.writeBoolean(true);
            }
            else {
                ba.writeByte(i);
                ba.writeBoolean(false);
            }
        }
    }
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
    // todo
    // var _loc5_: any = param1.getEnumerator("property");
    // while (_loc5_.moveNext()) {
    //     writeString(ba, _loc5_.current.getAttribute("target"));
    //     ba.writeShort(_loc5_.current.getAttributeInt("propertyId"));
    //     writeString(ba, _loc5_.current.getAttribute("value"), true, true);
    //     _loc4_++;
    // }
    // writeCount(ba, position, _loc4_);
}

function addComponent(element: IBaseElement): ByteArray {
    var tempByteBuffer: ByteArray;
    var _loc4_: string = null;
    var _loc5_: Array<any> = [];
    var _loc6_: number = 0;
    var idx: number = 0;
    var gears: Array<IGearBase> = [];
    var _loc9_: any;
    var position: number = 0;
    var type: number = 0;
    var _loc13_: number = 0;
    var _loc14_: any;
    var gearType: number = 0;
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
    var ba: ByteArray = new ByteArray();
    var objectType: string = element.type;
    switch (objectType) {
        case FObjectType.IMAGE:
            type = 0;
            break;
        case FObjectType.MOVIECLIP:
            type = 1;
            break;
        case FObjectType.SWF:
            type = 2;
            break;
        case FObjectType.GRAPH:
            type = 3;
            break;
        case FObjectType.LOADER:
            type = 4;
            break;
        case FObjectType.GROUP:
            type = 5;
            break;
        case FObjectType.TEXT:
            if (getAttributeBool(element, "input")) {
                type = 8;
            }
            else {
                type = 6;
            }
            break;
        case FObjectType.RICHTEXT:
            type = 7;
            break;
        case FObjectType.COMPONENT:
            type = 9;
            break;
        case FObjectType.LIST:
            if (getAttributeBool(element, "treeView")) {
                type = 17;
            }
            else {
                type = 10;
            }
            break;
        default:
            type = 0;
    }
    if (type == 17) {
        _loc13_ = 10;
    } else if (type == 10) {
        _loc13_ = 9;
    } else {
        _loc13_ = 7;
    }
    startSegments(ba, _loc13_, true);
    writeSegmentPos(ba, 0);
    ba.writeByte(type);
    writeString(ba, element.src);
    writeString(ba, element.pkg);
    writeString(ba, element.id || "");
    writeString(ba, element.name || "");
    _loc4_ = element.xy;
    _loc5_ = _loc4_.split(",");
    ba.writeInt(Number(_loc5_[0]));
    ba.writeInt(Number(_loc5_[1]));
    _loc4_ = element.size;
    if (_loc4_) {
        ba.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        ba.writeInt(parseInt(_loc5_[0]));
        ba.writeInt(parseInt(_loc5_[1]));
    } else {
        ba.writeBoolean(false);
    }
    _loc4_ = element.restrictSize;
    if (_loc4_) {
        ba.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        ba.writeInt(parseInt(_loc5_[0]));
        ba.writeInt(parseInt(_loc5_[1]));
        ba.writeInt(parseInt(_loc5_[2]));
        ba.writeInt(parseInt(_loc5_[3]));
    } else {
        ba.writeBoolean(false);
    }
    _loc4_ = element.scale;
    if (_loc4_) {
        ba.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        ba.writeFloat(parseFloat(_loc5_[0]));
        ba.writeFloat(parseFloat(_loc5_[1]));
    } else {
        ba.writeBoolean(false);
    }
    _loc4_ = element.skew;
    if (_loc4_) {
        ba.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        ba.writeFloat(parseFloat(_loc5_[0]));
        ba.writeFloat(parseFloat(_loc5_[1]));
    } else {
        ba.writeBoolean(false);
    }
    _loc4_ = element.pivot;
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        ba.writeBoolean(true);
        ba.writeFloat(parseFloat(_loc5_[0]));
        ba.writeFloat(parseFloat(_loc5_[1]));
        ba.writeBoolean(getAttributeBool(element, "anchor"));
    } else {
        ba.writeBoolean(false);
    }
    ba.writeFloat(getAttributeFloat(element, "alpha", 1));
    ba.writeFloat(getAttributeFloat(element, "rotation"));
    ba.writeBoolean(getAttributeBool(element, "visible", true));
    ba.writeBoolean(getAttributeBool(element, "touchable", true));
    ba.writeBoolean(getAttributeBool(element, "grayed"));
    _loc4_ = element.blend;
    switch (_loc4_) {
        case "add":
            ba.writeByte(2);
            break;
        case "multiply":
            ba.writeByte(3);
            break;
        case "none":
            ba.writeByte(1);
            break;
        case "screen":
            ba.writeByte(4);
            break;
        case "erase":
            ba.writeByte(5);
            break;
        default:
            ba.writeByte(0);
    }
    _loc4_ = element.filter;
    if (_loc4_) {
        if (_loc4_ == "color") {
            ba.writeByte(1);
            _loc4_ = element.filterData;
            _loc5_ = _loc4_.split(",");
            ba.writeFloat(parseFloat(_loc5_[0]));
            ba.writeFloat(parseFloat(_loc5_[1]));
            ba.writeFloat(parseFloat(_loc5_[2]));
            ba.writeFloat(parseFloat(_loc5_[3]));
        }
        else {
            ba.writeByte(0);
        }
    } else {
        ba.writeByte(0);
    }
    writeString(ba, element.customData, true);
    writeSegmentPos(ba, 1);
    writeString(ba, element.tooltips, true);
    _loc4_ = element.group;
    if (_loc4_ && displayList[_loc4_] != undefined) {
        ba.writeShort(displayList[_loc4_]);
    } else {
        ba.writeShort(-1);
    }
    writeSegmentPos(ba, 2);
    gears = getChildren(element, "gear");
    idx = 0;
    position = ba.position;
    ba.writeShort(0);
    for (let gear of gears) {
        gearType = FGearBase.getIndexByName(gear.type);
        if (gearType != -1) {
            tempByteBuffer = writeGearData(Number(gearType), gear);
            if (tempByteBuffer != null) {
                idx++;
                ba.writeShort(tempByteBuffer.length + 1);
                ba.writeByte(gearType);
                ba.writeBytes(tempByteBuffer);
                tempByteBuffer.clear();
            }
        }
    }
    writeCount(ba, position, idx);
    writeSegmentPos(ba, 3);
    let relations = getChildren(element, "relation");
    writeRelation(relations, ba, false);
    if (objectType == FObjectType.COMPONENT || objectType == FObjectType.LIST) {
        writeSegmentPos(ba, 4);
        _loc16_ = controllerCache[element.pageController];
        if (_loc16_ != undefined) {
            ba.writeShort(_loc16_);
        }
        else {
            ba.writeShort(-1);
        }
        _loc4_ = element.controller;
        if (_loc4_) {
            position = ba.position;
            ba.writeShort(0);
            _loc5_ = _loc4_.split(",");
            idx = 0;
            _loc6_ = 0;
            while (_loc6_ < _loc5_.length) {
                if (_loc5_[_loc6_]) {
                    writeString(ba, _loc5_[_loc6_]);
                    writeString(ba, _loc5_[_loc6_ + 1]);
                    idx++;
                }
                _loc6_ = _loc6_ + 2;
            }
            writeCount(ba, position, idx);
        }
        else {
            ba.writeShort(0);
        }
        writeControllerItem(element, ba);
    } else if (type == 8) { // input
        writeSegmentPos(ba, 4);
        writeString(ba, getAttribute(element, "prompt"));
        writeString(ba, getAttribute(element, "restrict"));
        ba.writeInt(getAttributeInt(element, "maxLength"));
        ba.writeInt(getAttributeInt(element, "keyboardType"));
        ba.writeBoolean(getAttributeBool(element, "password"));
    }
    writeSegmentPos(ba, 5);
    switch (objectType) {
        case FObjectType.IMAGE:
            _loc4_ = (element as IImageElement).color;
            if (_loc4_) {
                ba.writeBoolean(true);
                writeColorData(ba, _loc4_, false);
            }
            else {
                ba.writeBoolean(false);
            }
            _loc4_ = (element as IImageElement).flip;
            switch (_loc4_) {
                case "both":
                    ba.writeByte(3);
                    break;
                case "hz":
                    ba.writeByte(1);
                    break;
                case "vt":
                    ba.writeByte(2);
                    break;
                default:
                    ba.writeByte(0);
            }
            _loc4_ = (element as IImageElement).fillMethod;
            writeFillMethodData(ba, _loc4_);
            if (_loc4_ && _loc4_ != "none") {
                ba.writeByte(getAttributeInt(element, "fillOrigin"));
                ba.writeBoolean(getAttributeBool(element, "fillClockwise", true));
                ba.writeFloat(getAttributeInt(element, "fillAmount", 100) / 100);
            }
            break;
        case FObjectType.MOVIECLIP:
            _loc4_ = getAttribute(element, "color");
            if (_loc4_) {
                ba.writeBoolean(true);
                writeColorData(ba, _loc4_, false);
            }
            else {
                ba.writeBoolean(false);
            }
            ba.writeByte(0);
            ba.writeInt(getAttributeInt(element, "frame"));
            ba.writeBoolean(getAttributeBool(element, "playing", true));
            break;
        case FObjectType.GRAPH:
            _loc4_ = getAttribute(element, "type");
            _loc17_ = writeGraphData(ba, _loc4_);
            ba.writeInt(getAttributeInt(element, "lineSize", 1));
            writeColorData(ba, getAttribute(element, "lineColor"));
            writeColorData(ba, getAttribute(element, "fillColor"), true, 4294967295);
            _loc4_ = getAttribute(element, "corner", "");
            if (_loc4_) {
                ba.writeBoolean(true);
                _loc5_ = _loc4_.split(",");
                _loc18_ = parseInt(_loc5_[0]);
                ba.writeFloat(_loc18_);
                if (_loc5_[1]) {
                    ba.writeFloat(parseInt(_loc5_[1]));
                }
                else {
                    ba.writeFloat(_loc18_);
                }
                if (_loc5_[2]) {
                    ba.writeFloat(parseInt(_loc5_[2]));
                }
                else {
                    ba.writeFloat(_loc18_);
                }
                if (_loc5_[3]) {
                    ba.writeFloat(parseInt(_loc5_[3]));
                }
                else {
                    ba.writeFloat(_loc18_);
                }
            }
            else {
                ba.writeBoolean(false);
            }
            if (_loc17_ == 3) {
                _loc4_ = getAttribute(element, "points");
                _loc5_ = _loc4_.split(",");
                idx = _loc5_.length;
                ba.writeShort(idx);
                _loc6_ = 0;
                while (_loc6_ < idx) {
                    ba.writeFloat(parseFloat(_loc5_[_loc6_]));
                    _loc6_++;
                }
            }
            else if (_loc17_ == 4) {
                ba.writeShort(getAttributeInt(element, "sides"));
                ba.writeFloat(getAttributeFloat(element, "startAngle"));
                _loc4_ = getAttribute(element, "distances");
                if (_loc4_) {
                    _loc5_ = _loc4_.split(",");
                    idx = _loc5_.length;
                    ba.writeShort(idx);
                    _loc6_ = 0;
                    while (_loc6_ < idx) {
                        if (_loc5_[_loc6_]) {
                            ba.writeFloat(parseFloat(_loc5_[_loc6_]));
                        }
                        else {
                            ba.writeFloat(1);
                        }
                        _loc6_++;
                    }
                }
                else {
                    ba.writeShort(0);
                }
            }
            break;
        case FObjectType.LOADER:
            writeString(ba, getAttribute(element, "url", ""));
            writeAlignData(ba, getAttribute(element, "align"));
            writeValignData(ba, getAttribute(element, "vAlign"));
            _loc4_ = getAttribute(element, "fill");
            switch (_loc4_) {
                case "none":
                    ba.writeByte(0);
                    break;
                case "scale":
                    ba.writeByte(1);
                    break;
                case "scaleMatchHeight":
                    ba.writeByte(2);
                    break;
                case "scaleMatchWidth":
                    ba.writeByte(3);
                    break;
                case "scaleFree":
                    ba.writeByte(4);
                    break;
                case "scaleNoBorder":
                    ba.writeByte(5);
                    break;
                default:
                    ba.writeByte(0);
            }
            ba.writeBoolean(getAttributeBool(element, "shrinkOnly"));
            ba.writeBoolean(getAttributeBool(element, "autoSize"));
            ba.writeBoolean(getAttributeBool(element, "errorSign"));
            ba.writeBoolean(getAttributeBool(element, "playing", true));
            ba.writeInt(getAttributeInt(element, "frame"));
            _loc4_ = getAttribute(element, "color");
            if (_loc4_) {
                ba.writeBoolean(true);
                writeColorData(ba, _loc4_, false);
            }
            else {
                ba.writeBoolean(false);
            }
            _loc4_ = getAttribute(element, "fillMethod");
            writeFillMethodData(ba, _loc4_);
            if (_loc4_ && _loc4_ != "none") {
                ba.writeByte(getAttributeInt(element, "fillOrigin"));
                ba.writeBoolean(getAttributeBool(element, "fillClockwise", true));
                ba.writeFloat(getAttributeInt(element, "fillAmount", 100) / 100);
            }
            break;
        case FObjectType.GROUP:
            _loc4_ = getAttribute(element, "layout");
            switch (_loc4_) {
                case "hz":
                    ba.writeByte(1);
                    break;
                case "vt":
                    ba.writeByte(2);
                    break;
                default:
                    ba.writeByte(0);
            }
            ba.writeInt(getAttributeInt(element, "lineGap"));
            ba.writeInt(getAttributeInt(element, "colGap"));
            ba.writeBoolean(getAttributeBool(element, "excludeInvisibles"));
            ba.writeBoolean(getAttributeBool(element, "autoSizeDisabled"));
            ba.writeShort(getAttributeInt(element, "mainGridIndex", -1));
            break;
        case FObjectType.TEXT:
        case FObjectType.RICHTEXT:
            writeString(ba, getAttribute(element, "font"));
            ba.writeShort(getAttributeInt(element, "fontSize"));
            writeColorData(ba, getAttribute(element, "color"), false);
            writeAlignData(ba, getAttribute(element, "align"));
            writeValignData(ba, getAttribute(element, "vAlign"));
            ba.writeShort(getAttributeInt(element, "leading", 3));
            ba.writeShort(getAttributeInt(element, "letterSpacing"));
            ba.writeBoolean(getAttributeBool(element, "ubb"));
            writeTextSizeData(ba, getAttribute(element, "autoSize", "both"));
            ba.writeBoolean(getAttributeBool(element, "underline"));
            ba.writeBoolean(getAttributeBool(element, "italic"));
            ba.writeBoolean(getAttributeBool(element, "bold"));
            ba.writeBoolean(getAttributeBool(element, "singleLine"));
            _loc4_ = getAttribute(element, "strokeColor");
            if (_loc4_) {
                ba.writeBoolean(true);
                writeColorData(ba, _loc4_);
                ba.writeFloat(getAttributeInt(element, "strokeSize", 1));
            }
            else {
                ba.writeBoolean(false);
            }
            _loc4_ = getAttribute(element, "shadowColor");
            if (_loc4_) {
                ba.writeBoolean(true);
                writeColorData(ba, getAttribute(element, "shadowColor"));
                _loc4_ = getAttribute(element, "shadowOffset");
                if (_loc4_) {
                    _loc5_ = _loc4_.split(",");
                    ba.writeFloat(parseFloat(_loc5_[0]));
                    ba.writeFloat(parseFloat(_loc5_[1]));
                }
                else {
                    ba.writeFloat(1);
                    ba.writeFloat(1);
                }
            }
            else {
                ba.writeBoolean(false);
            }
            ba.writeBoolean(getAttributeBool(element, "vars"));
            break;
        case FObjectType.COMPONENT:
            break;
        case FObjectType.LIST:
            _loc19_ = getAttribute(element, "layout");
            switch (_loc19_) {
                case "column":
                    ba.writeByte(0);
                    break;
                case "row":
                    ba.writeByte(1);
                    break;
                case "flow_hz":
                    ba.writeByte(2);
                    break;
                case "flow_vt":
                    ba.writeByte(3);
                    break;
                case "pagination":
                    ba.writeByte(4);
                    break;
                default:
                    ba.writeByte(0);
            }
            _loc4_ = getAttribute(element, "selectionMode");
            switch (_loc4_) {
                case "single":
                    ba.writeByte(0);
                    break;
                case "multiple":
                    ba.writeByte(1);
                    break;
                case "multipleSingleClick":
                    ba.writeByte(2);
                    break;
                case "none":
                    ba.writeByte(3);
                    break;
                default:
                    ba.writeByte(0);
            }
            writeAlignData(ba, getAttribute(element, "align"));
            writeValignData(ba, getAttribute(element, "vAlign"));
            ba.writeShort(getAttributeInt(element, "lineGap"));
            ba.writeShort(getAttributeInt(element, "colGap"));
            _loc20_ = getAttributeInt(element, "lineItemCount");
            _loc21_ = getAttributeInt(element, "lineItemCount2");
            if (_loc19_ == "flow_hz") {
                ba.writeShort(0);
                ba.writeShort(_loc20_);
            }
            else if (_loc19_ == "flow_vt") {
                ba.writeShort(_loc20_);
                ba.writeShort(0);
            }
            else if (_loc19_ == "pagination") {
                ba.writeShort(_loc21_);
                ba.writeShort(_loc20_);
            }
            else {
                ba.writeShort(0);
                ba.writeShort(0);
            }
            if (!_loc19_ || _loc19_ == "row" || _loc19_ == "column") {
                ba.writeBoolean(getAttributeBool(element, "autoItemSize", true));
            }
            else {
                ba.writeBoolean(getAttributeBool(element, "autoItemSize", false));
            }
            _loc4_ = getAttribute(element, "renderOrder");
            switch (_loc4_) {
                case "ascent":
                    ba.writeByte(0);
                    break;
                case "descent":
                    ba.writeByte(1);
                    break;
                case "arch":
                    ba.writeByte(2);
                    break;
                default:
                    ba.writeByte(0);
            }
            ba.writeShort(getAttributeInt(element, "apex"));
            _loc4_ = getAttribute(element, "margin");
            if (_loc4_) {
                _loc5_ = _loc4_.split(",");
                ba.writeBoolean(true);
                ba.writeInt(parseInt(_loc5_[0]));
                ba.writeInt(parseInt(_loc5_[1]));
                ba.writeInt(parseInt(_loc5_[2]));
                ba.writeInt(parseInt(_loc5_[3]));
            }
            else {
                ba.writeBoolean(false);
            }
            _loc4_ = getAttribute(element, "overflow");
            if (_loc4_ == "hidden") {
                ba.writeByte(1);
            }
            else if (_loc4_ == "scroll") {
                ba.writeByte(2);
            }
            else {
                ba.writeByte(0);
            }
            _loc4_ = getAttribute(element, "clipSoftness");
            if (_loc4_) {
                _loc5_ = _loc4_.split(",");
                ba.writeBoolean(true);
                ba.writeInt(parseInt(_loc5_[0]));
                ba.writeInt(parseInt(_loc5_[1]));
            }
            else {
                ba.writeBoolean(false);
            }
            ba.writeBoolean(getAttributeBool(element, "scrollItemToViewOnClick", true));
            ba.writeBoolean(getAttributeBool(element, "foldInvisibleItems"));
            break;
        case FObjectType.SWF:
            ba.writeBoolean(getAttributeBool(element, "playing", true));
    }
    writeSegmentPos(ba, 6);
    switch (objectType) {
        case FObjectType.TEXT:
        case FObjectType.RICHTEXT:
            writeString(ba, getAttribute(element, "text"), true);
            break;
        case FObjectType.COMPONENT:
            gears = getChildren(element, ["Label","Button","Combobox","Slider","Scrollbar"]);
            for (let gear of gears) {
                switch (gear.type) {
                    case FObjectType.EXT_LABEL:
                        ba.writeByte(11);
                        writeString(ba, getAttribute(gear,"title"), true);
                        writeString(ba, getAttribute(gear,"icon"));
                        _loc4_ = getAttribute(gear,"titleColor");
                        if (_loc4_) {
                            ba.writeBoolean(true);
                            writeColorData(ba, _loc4_);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        ba.writeInt(getAttributeInt(gear,"titleFontSize"));
                        _loc22_ = getAttribute(gear,"prompt");
                        _loc23_ = getAttribute(gear,"restrict");
                        _loc24_ = getAttributeInt(gear,"maxLength");
                        _loc25_ = getAttributeInt(gear,"keyboardType");
                        _loc26_ = getAttributeBool(gear,"password");
                        if (_loc22_ || _loc23_ || _loc24_ || _loc25_ || _loc26_) {
                            ba.writeBoolean(true);
                            writeString(ba, _loc22_, true);
                            writeString(ba, _loc23_);
                            ba.writeInt(_loc24_);
                            ba.writeInt(_loc25_);
                            ba.writeBoolean(_loc26_);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        continue;
                    case FObjectType.EXT_BUTTON:
                        ba.writeByte(12);
                        writeString(ba, getAttribute(gear,"title"), true);
                        writeString(ba, getAttribute(gear,"selectedTitle"), true);
                        writeString(ba, getAttribute(gear,"icon"));
                        writeString(ba, getAttribute(gear,"selectedIcon"));
                        _loc4_ = getAttribute(gear,"titleColor");
                        if (_loc4_) {
                            ba.writeBoolean(true);
                            writeColorData(ba, _loc4_);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        ba.writeInt(getAttributeInt(gear,"titleFontSize"));
                        _loc4_ = getAttribute(gear,"controller");
                        if (_loc4_) {
                            _loc16_ = controllerCache[_loc4_];
                            if (_loc16_ != undefined) {
                                ba.writeShort(_loc16_);
                            }
                            else {
                                ba.writeShort(-1);
                            }
                        }
                        else {
                            ba.writeShort(-1);
                        }
                        writeString(ba, getAttribute(gear,"page"));
                        writeString(ba, getAttribute(gear,"sound"), false, false);
                        _loc4_ = getAttribute(gear,"volume");
                        if (_loc4_) {
                            ba.writeBoolean(true);
                            ba.writeFloat(parseInt(_loc4_) / 100);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        ba.writeBoolean(getAttributeBool(gear,"checked"));
                        continue;
                    case FObjectType.EXT_COMBOBOX:
                        ba.writeByte(13);
                        position = ba.position;
                        ba.writeShort(0);
                        // _loc28_ = getEnumerator("item");  // todo
                        idx = 0;
                        while (_loc28_.moveNext()) {
                            idx++;
                            _loc27_ = _loc28_.current;
                            tempByteBuffer = new ByteArray();
                            writeString(tempByteBuffer, _loc27_.getAttribute("title"), true, false);
                            writeString(tempByteBuffer, _loc27_.getAttribute("value"), false, false);
                            writeString(tempByteBuffer, _loc27_.getAttribute("icon"));
                            ba.writeShort(tempByteBuffer.length);
                            ba.writeBytes(tempByteBuffer);
                            tempByteBuffer.clear();
                        }
                        writeCount(ba, position, idx);
                        writeString(ba, getAttribute(gear,"title"), true);
                        writeString(ba, getAttribute(gear,"icon"));
                        _loc4_ = getAttribute(gear,"titleColor");
                        if (_loc4_) {
                            ba.writeBoolean(true);
                            writeColorData(ba, _loc4_);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        ba.writeInt(getAttributeInt(gear,"visibleItemCount"));
                        _loc4_ = getAttribute(gear,"direction");
                        switch (_loc4_) {
                            case "down":
                                ba.writeByte(2);
                                break;
                            case "up":
                                ba.writeByte(1);
                                break;
                            default:
                                ba.writeByte(0);
                        }
                        _loc4_ = getAttribute(gear,"selectionController");
                        if (_loc4_) {
                            _loc16_ = controllerCache[_loc4_];
                            if (_loc16_ != undefined) {
                                ba.writeShort(_loc16_);
                            }
                            else {
                                ba.writeShort(-1);
                            }
                        }
                        else {
                            ba.writeShort(-1);
                        }
                        continue;
                    case FObjectType.EXT_PROGRESS_BAR:
                        ba.writeByte(14);
                        ba.writeInt(getAttributeInt(gear,"value"));
                        ba.writeInt(getAttributeInt(gear,"max", 100));
                        ba.writeInt(getAttributeInt(gear,"min"));
                        continue;
                    case FObjectType.EXT_SLIDER:
                        ba.writeByte(15);
                        ba.writeInt(getAttributeInt(gear,"value"));
                        ba.writeInt(getAttributeInt(gear,"max", 100));
                        ba.writeInt(getAttributeInt(gear,"min"));
                        continue;
                    case FObjectType.EXT_SCROLLBAR:
                        ba.writeByte(16);
                        continue;
                    default:
                        continue;
                }
            }
            break;
        case FObjectType.LIST:
            _loc4_ = getAttribute(element, "selectionController");
            if (_loc4_) {
                _loc16_ = controllerCache[_loc4_];
                if (_loc16_ != undefined) {
                    ba.writeShort(_loc16_);
                }
                else {
                    ba.writeShort(-1);
                }
            }
            else {
                ba.writeShort(-1);
            }
    }
    if (objectType == FObjectType.LIST) {
        if (getAttribute(element, "overflow") == "scroll") {
            writeSegmentPos(ba, 7);
            tempByteBuffer = writeScrollData(element);
            ba.writeBytes(tempByteBuffer);
            tempByteBuffer.clear();
        }
        writeSegmentPos(ba, 8);
        writeString(ba, getAttribute(element, "defaultItem"));
        // _loc28_ = element.getEnumerator(element,"item");
        let items = (element as IListElement).item;
        let itemLen = items.length;
        idx = 0;
        helperIntList.length = idx;

        while (idx<itemLen) {
            let item = items[idx];
            _loc29_ = getAttributeInt(item,"level", 0);
            helperIntList[idx] = _loc29_;
            idx++;
        }

        _loc6_ = 0;
        ba.writeShort(idx);
        let itemIdx = 0;
        while (itemIdx<itemLen) {
            let item  = items[itemIdx];
            tempByteBuffer = new ByteArray();
            writeString(tempByteBuffer, getAttribute(item,"url"));
            if (type == 17) {
                _loc29_ = helperIntList[_loc6_];
                if (_loc6_ != idx - 1 && helperIntList[_loc6_ + 1] > _loc29_) {
                    tempByteBuffer.writeBoolean(true);
                }
                else {
                    tempByteBuffer.writeBoolean(false);
                }
                tempByteBuffer.writeByte(_loc29_);
            }
            writeString(tempByteBuffer, getAttribute(item,"title"), true);
            writeString(tempByteBuffer, getAttribute(item,"selectedTitle"), true);
            writeString(tempByteBuffer, getAttribute(item,"icon"));
            writeString(tempByteBuffer, getAttribute(item,"selectedIcon"));
            writeString(tempByteBuffer, getAttribute(item,"name"));
            _loc4_ = getAttribute(item,"controllers");
            if (_loc4_) {
                _loc5_ = _loc4_.split(",");
                tempByteBuffer.writeShort(_loc5_.length / 2);
                _loc6_ = 0;
                while (_loc6_ < _loc5_.length) {
                    writeString(tempByteBuffer, _loc5_[_loc6_]);
                    writeString(tempByteBuffer, _loc5_[_loc6_ + 1]);
                    _loc6_ = _loc6_ + 2;
                }
            }
            else {
                tempByteBuffer.writeShort(0);
            }
            writeControllerItem(_loc14_, tempByteBuffer);
            ba.writeShort(tempByteBuffer.length);
            ba.writeBytes(tempByteBuffer);
            tempByteBuffer.clear();
            _loc6_++;
        }
    }
    if (type == 17) {
        writeSegmentPos(ba, 9);
        ba.writeInt(getAttributeInt(element, "indent", 15));
        ba.writeByte(getAttributeInt(element, "clickToExpand"));
    }
    return ba;
}

function writeGearData(gearType: number, gear: IGearBase): ByteArray {
    var controller: string = "";
    var strArr: Array<string> = [];
    var strLength: number = 0;
    var idx: number = 0;
    var _loc9_: any = undefined;
    var controllerArr: Array<string> = [];
    var controllerDetails: Array<string> = [];
    var positionsInPercent: boolean = false;
    var condition: number = 0;
    controller = gear.controller;
    if (controller) {
        _loc9_ = controllerCache[controller];
        if (_loc9_ == undefined) {
            return null;
        }
        var ba: ByteArray = new ByteArray();
        ba.writeShort(_loc9_);
        if (gearType == 0 || gearType == 8) {
            controller = gear.pages;
            if (controller) {
                strArr = controller.split(",");
                strLength = strArr.length;
                if (strLength == 0) {
                    return null;
                }
                ba.writeShort(strLength);
                idx = 0;
                while (idx < strLength) {
                    writeString(ba, strArr[idx], false, false);
                    idx++;
                }
            }
            else {
                ba.writeShort(0);
            }
        }
        else {
            controller = gear.pages;
            if (controller) {
                controllerArr = controller.split(",");
            }
            else {
                controllerArr = [];
            }
            controller = gear.values;
            if (controller) {
                controllerDetails = controller.split("|");
            }
            else {
                controllerDetails = [];
            }
            strLength = controllerArr.length;
            ba.writeShort(strLength);
            idx = 0;
            while (idx < strLength) {
                controller = controllerDetails[idx];
                if (gearType != 6 && gearType != 7 && (!controller || controller == "-")) {
                    writeString(ba, null);
                }
                else {
                    writeString(ba, controllerArr[idx], false, false);
                    writeGearValue(gearType, controller, ba);
                }
                idx++;
            }
            controller = gear.default;
            if (controller) {
                ba.writeBoolean(true);
                writeGearValue(gearType, controller, ba);
            }
            else {
                ba.writeBoolean(false);
            }
        }
        if (getAttributeBool(gear, "tween")) {
            ba.writeBoolean(true);
            ba.writeByte(EaseType.parseEaseType(gear.ease));
            ba.writeFloat(getAttributeFloat(gear, "duration", 0.3));
            ba.writeFloat(getAttributeFloat(gear, "delay"));
        }
        else {
            ba.writeBoolean(false);
        }
        if (gearType == 1) {
            positionsInPercent = getAttributeBool(gear, "positionsInPercent");
            ba.writeBoolean(positionsInPercent);
            if (positionsInPercent) {
                idx = 0;
                while (idx < strLength) {
                    controller = controllerDetails[idx];
                    if (controller && controller != "-") {
                        writeString(ba, controllerArr[idx], false, false);
                        strArr = controller.split(",");
                        ba.writeFloat(parseFloat(strArr[2]));
                        ba.writeFloat(parseFloat(strArr[3]));
                    }
                    idx++;
                }
                controller = gear.default;
                if (controller) {
                    ba.writeBoolean(true);
                    strArr = controller.split(",");
                    ba.writeFloat(parseFloat(strArr[2]));
                    ba.writeFloat(parseFloat(strArr[3]));
                }
                else {
                    ba.writeBoolean(false);
                }
            }
        }
        if (gearType == 8) {
            condition = getAttributeInt(gear, "condition");
            ba.writeByte(condition);
        }
        return ba;
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

//   function encodeTransition(param1:String) : string
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

function writeHitTestImages() {
    //  var _loc2_:BitmapData = null;
    //  var _loc3_:BitmapData = null;
    //  var _loc4_:Matrix = null;
    var _loc5_: Array<number> = null;
    var _loc6_: number = 0;
    var _loc7_: number = 0;
    var _loc8_: number = 0;
    var _loc9_: number = 0;
    for (let hitTestImage of hitTestImages) {
        // if(hitTestImage)
        // {
        //    _loc3_ = new BitmapData(_loc2_.width / 2,_loc2_.height / 2,true,0);
        //    _loc4_ = new Matrix();
        //    _loc4_.scale(0.5,0.5);
        //    _loc3_.draw(_loc2_,_loc4_);
        //    _loc2_ = _loc3_;
        //    _loc5_ = _loc2_.getVector(_loc2_.rect);
        //    _loc6_ = _loc5_.length;
        //    hitTestData.writeUTF(_loc1_.id);
        //    hitTestData.writeInt(0);
        //    hitTestData.writeInt(_loc2_.width);
        //    hitTestData.writeByte(2);
        //    hitTestData.writeInt(Math.ceil(_loc6_ / 8));
        //    _loc2_.dispose();
        //    _loc7_ = 0;
        //    _loc8_ = 0;
        //    _loc9_ = 0;
        //    while(_loc9_ < _loc6_)
        //    {
        //       if((_loc5_[_loc9_] >> 24 & 255) > 10)
        //       {
        //          _loc7_ = _loc7_ + (1 << _loc8_);
        //       }
        //       _loc8_++;
        //       if(_loc8_ == 8)
        //       {
        //          hitTestData.writeByte(_loc7_);
        //          _loc7_ = 0;
        //          _loc8_ = 0;
        //       }
        //       _loc9_++;
        //    }
        //    if(_loc8_ != 0)
        //    {
        //       hitTestData.writeByte(_loc7_);
        //    }
        // }
    }
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
    } else {
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

function getChildren<U, T>(display: U, name?: string | Array<string>): Array<T> {
    let children = [];
    for (let [key, value] of Object.entries(display)) {
        if (name) { // 指定关键词
            let flag = false;
            if (Array.isArray(name)) {
                flag = name.includes(key);
            } else {
                flag = key.includes(name);
            }
            if (flag) {
                if (Array.isArray(value)) {
                    value.forEach((item) => {
                        item.type = key;
                        children.push(item);
                    })
                } else {
                    value.type = key;
                    children.push(value);
                }
            }
        } else {
            if (Array.isArray(value)) {
                value.forEach((item) => {
                    item.type = key;
                    children.push(item);
                })
            } else {
                value.type = key;
                children.push(value);
            }
        }

    }
    return children;
}

publish();



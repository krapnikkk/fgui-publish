// import FPackage from "./fairygui/gui/FPackage";
// import FProject from "./fairygui/gui/FProject";
// import PublishHandler from "./fairygui/publish/PublishHandler";
// async function publish() {

// let project = new FProject(basePath, projectName);
// await project.open();
// let pkg = new FPackage(project, pkgName); // 默认指定报名
// let publishHandler = new PublishHandler();
// publishHandler.publish(pkg, "", targetPath);
// }


import ByteArray from "./utils/ByteArray";
import fs from "fs";
import { parse } from "fast-xml-parser";
import ProjectType from "./fairygui/editor/api/ProjectType";
import { type } from "os";
import { isH5 } from "./utils/utils";
import FObjectType from "./fairygui/editor/api/FObjectType";
import FPackageItemType from "./fairygui/gui/FPackageItemType";

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

const stringMap: { [key: string]: number } = {},
    stringTable: string[] = [],
    xmlFileMap: { [key: string]: IComponentFile } = {};
const dependentElements = ["image", "component", "movieclip"];
let binaryFormat = false,
    projectType = ProjectType.UNITY,
    pkgId = "",
    pkgName = "Bag",
    version: number = 2;

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
        //skipLike: /\+[0-9]{10}/
    },
    arrayMode: false, //"strict"
    // attrValueProcessor: (val, attrName) => he.decode(val, { isAttributeValue: true }),//default is a=>a
    // tagValueProcessor: (val, tagName) => he.decode(val), //default is a=>a
    stopNodes: ["parse-me-as-string"],
    alwaysCreateTextNode: false
};


function getConfig() {
    console.log("getConfig");
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

// let loc7 = new ByteBuffer();
// startSegments(loc7, 6, false);
// writeSegmentPos(loc7, 0);

// let _loc9_ = [];
// let _loc26_: number = 0;
// let _loc22_: any;
// let _loc25_: any[] = _loc22_._dependentPackages;
// for (let key in _loc22_._dependentPackages) {
//     _loc9_.push(key);
// }

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

function writeString(ba: ByteArray, param2: string, param3: boolean = false, param4: boolean = true): void {
    let _loc5_;
    if (param4) {
        if (!param2) {
            ba.writeShort(65534);
            return;
        }
    } else {
        if (param2 == null) {
            ba.writeShort(65534);
            return;
        }
        if (param2.length == 0) {
            ba.writeShort(65533);
            return;
        }
    }
    if (!param3) {
        _loc5_ = stringMap[param2];
        if (_loc5_ != undefined) {
            ba.writeShort(Number(_loc5_));
            return;
        }
    }
    stringTable.push(param2);
    if (!param3) {
        stringMap[param2] = stringTable.length - 1;
    }
    ba.writeShort(stringTable.length - 1);
}

function getPackagesResource(resource: IResource): IPackageResource {
    let dependentMap = new Map();
    let resourceArr = [];
    // let { component } = resource;
    for (let [key, value] of Object.entries(resource)) {
        // switch (key) {
        //     case "component":
        if (Array.isArray(value)) {
            for (let i = 0; i < value.length; i++) {
                let item = value[i];
                item.type = key;
                // updateResourceType(key, item);
                resourceArr.push(item);
                if (key == "component") { // conponent组件
                    readXMLResource(item, dependentMap);
                }
            }
        } else {
            // updateResourceType(key, value);
            value.type = key;
            resourceArr.push(value);
            if (key == "component") {
                readXMLResource(value, dependentMap);
            }
        }
        //         break;
        //     default:
        //         console.log(`warninig!!!!${key}`);
        //         break;
        // }
    }

    return { dependentMap, resourceArr };
}

// 根据资源列表读取跨包资源情况
function readXMLResource(component: IComponentResource, dependentMap: Map<string, string>) {
    let { name, path, id } = component;
    let xml = fs.readFileSync(`${basePath}${assetsPath}${pkgName}${path}${name}`).toString();
    let data = parse(xml, xmlOptions).component as IComponentFile;
    xmlFileMap[id] = data;
    // 从package.xml中获取resources，然后从displayList中寻找跨包资源
    let { displayList } = data;

    for (let [key, value] of Object.entries(displayList)) {
        console.log(value);
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
            console.log(key);
        }
    }
}

function writeDependent() {
    let ba = new ByteArray();
    startSegments(ba, 6, false);
    writeSegmentPos(ba, 0);
    console.log("packageDescription");

    let xml = fs.readFileSync(`${basePath}${assetsPath}${pkgName}/${packageName}`).toString();
    let packageDescription = parse(xml, xmlOptions).packageDescription as IPackageDescription;
    let resources = packageDescription.resources;
    console.log("resources:", resources);
    // dependent
    let { dependentMap, resourceArr } = getPackagesResource(resources);

    ba.writeShort(dependentMap.size); // 写入依赖包的数目
    dependentMap.forEach(([id, name]) => {
        writeString(ba, id);
        writeString(ba, name);
    })

    // branches
    ba.writeShort(0);

    writeSegmentPos(ba, 1);

    ba.writeShort(resourceArr.length);
    // console.log(resourceArr);
    // debugger;
    resourceArr.forEach((element) => {
        let byteBuffer = writeResourceItem(element);
        ba.writeInt(byteBuffer.length);
        ba.writeBytes(byteBuffer);
        byteBuffer.clear();
    })

    writeSegmentPos(ba, 2);
    // let cnt = _spritesInfo.length;
    // ba.writeShort(cnt);



}

function publish() {
    getConfig();
    let ba = new ByteArray();
    writeHead(ba, { version, compress, pkgId, pkgName });
    if (compress) {
        // do compress
    }

    writeDependent();

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
    console.log(value);
    writeString(ba, value);
    writeString(ba, resource.name);
    writeString(ba, resource.path);
    if (type == FPackageItemType.SOUND || type == FPackageItemType.SWF || type == FPackageItemType.ATLAS || type == FPackageItemType.MISC) {
        writeString(ba, resource.file);
    }
    else {
        writeString(ba, null);
    }
    ba.writeBoolean(Boolean(resource.exported));
    _loc4_ = resource.size;
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
            // ba.writeBoolean(Boolean(resource.smoothing));
            // _loc9_ = xmlFileMap[value + ".xml"];
            // if (_loc9_) {
            //     _loc3_ = this.§_ - 3y§(value, _loc9_);
            //     ba.writeInt(_loc3_.length);
            //     ba.writeBytes(_loc3_);
            //     _loc3_.clear();
            // }
            // else {
            //     ba.writeInt(0);
            // }
            break;
        case FPackageItemType.FONT:
            // _loc4_ = xmlFileMap[value + ".fnt"];
            // if (_loc4_) {
            //     _loc3_ = this.§_ - Ox§(value, _loc4_);
            //     ba.writeInt(_loc3_.length);
            //     ba.writeBytes(_loc3_);
            //     _loc3_.clear();
            // }
            // else {
            //     ba.writeInt(0);
            // }
            break;
        case FPackageItemType.COMPONENT:
            _loc9_ = xmlFileMap[value + ".xml"];

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
                // _loc3_ = this.§_ - KC§(value, XData.attach(_loc9_));
                // ba.writeInt(_loc3_.length);
                // ba.writeBytes(_loc3_);
                // _loc3_.clear();
            }
            else {
                ba.writeByte(0);
                ba.writeInt(0);
            }
    }
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




publish();



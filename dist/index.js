'use strict';

var fs = require('fs');
var fastXmlParser = require('fast-xml-parser');

function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

var fs__default = /*#__PURE__*/_interopDefaultLegacy(fs);

class ByteArray {
    constructor(buffer) {
        this.$setArrayBuffer(buffer || new ArrayBuffer(0));
        this.endian = Endian.BIG_ENDIAN;
    }
    get buffer() { return this._data.buffer; }
    get data() { return this._data; }
    set data(value) {
        this._data = value;
    }
    get bufferOffset() { return this._data.byteOffset; }
    get position() { return this._position; }
    set position(value) {
        this._position = Math.max(0, Math.min(value, this.length));
    }
    get length() {
        return this._data.byteLength;
    }
    set length(value) {
        if (this.length == value)
            return;
        let tmp = new Uint8Array(new ArrayBuffer(value));
        tmp.set(new Uint8Array(this.buffer, 0 + this.bufferOffset, Math.min(this.length, value)));
        this._data = new DataView(tmp.buffer);
        this._position = Math.min(this._position, value);
    }
    get bytesAvailable() {
        return this._data.byteLength - this._position;
    }
    clear() {
        this.$setArrayBuffer(new ArrayBuffer(0));
    }
    readBoolean() {
        console.assert(this.bytesAvailable >= 1, "out of range");
        return this._data.getUint8(this.position++) != 0;
    }
    readByte() {
        console.assert(this.bytesAvailable >= 1, "out of range");
        return this._data.getInt8(this.position++);
    }
    readBytes(bytes, offset = 0, length = 0) {
        length = length || this.bytesAvailable;
        console.assert(this.bytesAvailable >= length, "out of range");
        bytes.position = offset;
        bytes.writeUint8Array(new Uint8Array(this.buffer, this._position + this.bufferOffset, length));
        this.position += length;
    }
    readDouble() {
        console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_FLOAT64, "out of range");
        let value = this._data.getFloat64(this.position, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_FLOAT64;
        return value;
    }
    readFloat() {
        console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_FLOAT32, "out of range");
        let value = this._data.getFloat32(this.position, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_FLOAT32;
        return value;
    }
    readInt() {
        console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_INT32, "out of range");
        let value = this._data.getInt32(this.position, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_INT32;
        return value;
    }
    readShort() {
        console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_INT16, "out of range");
        let value = this._data.getInt16(this.position, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_INT16;
        return value;
    }
    readUnsignedByte() {
        console.assert(this.bytesAvailable >= 1, "out of range");
        return this._data.getUint8(this.position++);
    }
    readUnsignedInt() {
        console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_UINT32, "out of range");
        let value = this._data.getUint32(this.position, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_UINT32;
        return value;
    }
    readUnsignedShort() {
        console.assert(this.bytesAvailable >= ByteArray.SIZE_OF_UINT16, "out of range");
        let value = this._data.getUint16(this.position, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_UINT16;
        return value;
    }
    readUTF() {
        let length = this.readUnsignedShort();
        if (length == 0)
            return "";
        return this.readUTFBytes(length);
    }
    readUTFBytes(length) {
        console.assert(this.bytesAvailable >= length, "out of range");
        let bytes = new Uint8Array(this.buffer, this.bufferOffset + this.position, length);
        this.position += length;
        return this.decodeUTF8(bytes);
    }
    readMultiByte(length, char) {
        if (char == "utf-8") {
            return this.readUTFBytes(length);
        }
        return "";
    }
    writeBoolean(value) {
        this.checkSize(ByteArray.SIZE_OF_BOOLEAN);
        this._data.setUint8(this.position++, value ? 1 : 0);
    }
    writeByte(value) {
        this.checkSize(ByteArray.SIZE_OF_INT8);
        this._data.setInt8(this.position++, value);
    }
    writeBytes(bytes, offset = 0, length = 0) {
        if (offset < 0 || length < 0)
            return;
        let total = bytes.length - offset;
        length = length || total;
        let writeLength = Math.min(total, length);
        if (writeLength == 0)
            return;
        this.checkSize(writeLength);
        new Uint8Array(this.buffer, this.position + this.bufferOffset, writeLength)
            .set(new Uint8Array(bytes.buffer, offset + bytes.bufferOffset, writeLength));
        this.position += writeLength;
    }
    writeDouble(value) {
        this.checkSize(ByteArray.SIZE_OF_FLOAT64);
        this._data.setFloat64(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_FLOAT64;
    }
    writeFloat(value) {
        this.checkSize(ByteArray.SIZE_OF_FLOAT32);
        this._data.setFloat32(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_FLOAT32;
    }
    writeInt(value) {
        this.checkSize(ByteArray.SIZE_OF_INT32);
        this._data.setInt32(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_INT32;
    }
    writeShort(value) {
        this.checkSize(ByteArray.SIZE_OF_INT16);
        this._data.setInt16(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_INT16;
    }
    writeUnsignedInt(value) {
        this.checkSize(ByteArray.SIZE_OF_UINT32);
        this._data.setUint32(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_UINT32;
    }
    writeUnsignedShort(value) {
        this.checkSize(ByteArray.SIZE_OF_UINT16);
        this._data.setUint16(this.position, value, this.endian == Endian.LITTLE_ENDIAN);
        this.position += ByteArray.SIZE_OF_UINT16;
    }
    writeUTF(value) {
        let utf8bytes = this.encodeUTF8(value);
        let length = utf8bytes.length;
        this.writeUnsignedShort(length);
        this.writeUint8Array(utf8bytes);
    }
    writeUTFBytes(value) {
        this.writeUint8Array(this.encodeUTF8(value));
    }
    writeMultiByte(value, charSet) {
        if (charSet == "utf-8") {
            this.writeUint8Array(this.encodeUTF8(value));
        }
    }
    toString() {
        return "[ByteArray] length:" + this.length + ", bytesAvailable:" + this.bytesAvailable;
    }
    writeUint8Array(bytes) {
        this.checkSize(bytes.length);
        new Uint8Array(this.buffer, this.position + this.bufferOffset).set(bytes);
        this.position += bytes.length;
    }
    getPlatformEndianness() {
        var buffer = new ArrayBuffer(2);
        new DataView(buffer).setInt16(0, 256, true);
        return new Int16Array(buffer)[0] === 256
            ? Endian.LITTLE_ENDIAN
            : Endian.BIG_ENDIAN;
    }
    $setArrayBuffer(buffer) {
        this._data = new DataView(buffer);
        this._position = 0;
    }
    checkSize(len) {
        this.length = Math.max(len + this._position, this.length);
    }
    encodeUTF8(str) { return UTF8.encode(str); }
    decodeUTF8(data) { return UTF8.decode(data); }
}
ByteArray.SIZE_OF_BOOLEAN = 1;
ByteArray.SIZE_OF_INT8 = 1;
ByteArray.SIZE_OF_INT16 = 2;
ByteArray.SIZE_OF_INT32 = 4;
ByteArray.SIZE_OF_UINT8 = 1;
ByteArray.SIZE_OF_UINT16 = 2;
ByteArray.SIZE_OF_UINT32 = 4;
ByteArray.SIZE_OF_FLOAT32 = 4;
ByteArray.SIZE_OF_FLOAT64 = 8;
class UTF8 {
    constructor() {
        this.EOF_byte = -1;
        this.EOF_code_point = -1;
    }
    static encode(str) { return new UTF8().encode(str); }
    static decode(data) { return new UTF8().decode(data); }
    encoderError(code_point) {
        console.error("UTF8 encoderError", code_point);
    }
    decoderError(fatal, opt_code_point) {
        if (fatal)
            console.error("UTF8 decoderError", opt_code_point);
        return opt_code_point || 0xFFFD;
    }
    inRange(a, min, max) {
        return min <= a && a <= max;
    }
    div(n, d) {
        return Math.floor(n / d);
    }
    stringToCodePoints(string) {
        let cps = [];
        let i = 0, n = string.length;
        while (i < string.length) {
            let c = string.charCodeAt(i);
            if (!this.inRange(c, 0xD800, 0xDFFF)) {
                cps.push(c);
            }
            else if (this.inRange(c, 0xDC00, 0xDFFF)) {
                cps.push(0xFFFD);
            }
            else {
                if (i == n - 1) {
                    cps.push(0xFFFD);
                }
                else {
                    let d = string.charCodeAt(i + 1);
                    if (this.inRange(d, 0xDC00, 0xDFFF)) {
                        let a = c & 0x3FF;
                        let b = d & 0x3FF;
                        i += 1;
                        cps.push(0x10000 + (a << 10) + b);
                    }
                    else {
                        cps.push(0xFFFD);
                    }
                }
            }
            i += 1;
        }
        return cps;
    }
    encode(str) {
        let pos = 0;
        let codePoints = this.stringToCodePoints(str);
        let outputBytes = [];
        while (codePoints.length > pos) {
            let code_point = codePoints[pos++];
            if (this.inRange(code_point, 0xD800, 0xDFFF)) {
                this.encoderError(code_point);
            }
            else if (this.inRange(code_point, 0x0000, 0x007f)) {
                outputBytes.push(code_point);
            }
            else {
                let count = 0, offset = 0;
                if (this.inRange(code_point, 0x0080, 0x07FF)) {
                    count = 1;
                    offset = 0xC0;
                }
                else if (this.inRange(code_point, 0x0800, 0xFFFF)) {
                    count = 2;
                    offset = 0xE0;
                }
                else if (this.inRange(code_point, 0x10000, 0x10FFFF)) {
                    count = 3;
                    offset = 0xF0;
                }
                outputBytes.push(this.div(code_point, Math.pow(64, count)) + offset);
                while (count > 0) {
                    let temp = this.div(code_point, Math.pow(64, count - 1));
                    outputBytes.push(0x80 + (temp % 64));
                    count -= 1;
                }
            }
        }
        return new Uint8Array(outputBytes);
    }
    decode(data) {
        let fatal = false;
        let pos = 0;
        let result = "";
        let code_point;
        let utf8_code_point = 0;
        let utf8_bytes_needed = 0;
        let utf8_bytes_seen = 0;
        let utf8_lower_boundary = 0;
        while (data.length > pos) {
            let _byte = data[pos++];
            if (_byte == this.EOF_byte) {
                if (utf8_bytes_needed != 0) {
                    code_point = this.decoderError(fatal);
                }
                else {
                    code_point = this.EOF_code_point;
                }
            }
            else {
                if (utf8_bytes_needed == 0) {
                    if (this.inRange(_byte, 0x00, 0x7F)) {
                        code_point = _byte;
                    }
                    else {
                        if (this.inRange(_byte, 0xC2, 0xDF)) {
                            utf8_bytes_needed = 1;
                            utf8_lower_boundary = 0x80;
                            utf8_code_point = _byte - 0xC0;
                        }
                        else if (this.inRange(_byte, 0xE0, 0xEF)) {
                            utf8_bytes_needed = 2;
                            utf8_lower_boundary = 0x800;
                            utf8_code_point = _byte - 0xE0;
                        }
                        else if (this.inRange(_byte, 0xF0, 0xF4)) {
                            utf8_bytes_needed = 3;
                            utf8_lower_boundary = 0x10000;
                            utf8_code_point = _byte - 0xF0;
                        }
                        else {
                            this.decoderError(fatal);
                        }
                        utf8_code_point = utf8_code_point * Math.pow(64, utf8_bytes_needed);
                        code_point = null;
                    }
                }
                else if (!this.inRange(_byte, 0x80, 0xBF)) {
                    utf8_code_point = 0;
                    utf8_bytes_needed = 0;
                    utf8_bytes_seen = 0;
                    utf8_lower_boundary = 0;
                    pos--;
                    code_point = this.decoderError(fatal, _byte);
                }
                else {
                    utf8_bytes_seen += 1;
                    utf8_code_point = utf8_code_point + (_byte - 0x80) * Math.pow(64, utf8_bytes_needed - utf8_bytes_seen);
                    if (utf8_bytes_seen !== utf8_bytes_needed) {
                        code_point = null;
                    }
                    else {
                        let cp = utf8_code_point;
                        let lower_boundary = utf8_lower_boundary;
                        utf8_code_point = 0;
                        utf8_bytes_needed = 0;
                        utf8_bytes_seen = 0;
                        utf8_lower_boundary = 0;
                        if (this.inRange(cp, lower_boundary, 0x10FFFF) && !this.inRange(cp, 0xD800, 0xDFFF)) {
                            code_point = cp;
                        }
                        else {
                            code_point = this.decoderError(fatal, _byte);
                        }
                    }
                }
            }
            if (code_point !== null && code_point !== this.EOF_code_point) {
                if (code_point <= 0xFFFF) {
                    if (code_point > 0)
                        result += String.fromCharCode(code_point);
                }
                else {
                    code_point -= 0x10000;
                    result += String.fromCharCode(0xD800 + ((code_point >> 10) & 0x3ff));
                    result += String.fromCharCode(0xDC00 + (code_point & 0x3ff));
                }
            }
        }
        return result;
    }
}
class Endian {
}
Endian.LITTLE_ENDIAN = "littleEndian";
Endian.BIG_ENDIAN = "bigEndian";

class ProjectType {
}
ProjectType.FLASH = "Flash";
ProjectType.STARLING = "Starling";
ProjectType.UNITY = "Unity";
ProjectType.EGRET = "Egret";
ProjectType.LAYABOX = "Layabox";
ProjectType.HAXE = "Haxe";
ProjectType.PIXI = "Pixi";
ProjectType.COCOS2DX = "Cocos2dx";
ProjectType.CRY = "Cry";
ProjectType.VISION = "Vision";
ProjectType.MONOGAME = "MonoGame";
ProjectType.COCOSCREATOR = "CocosCreator";
ProjectType.LIBGDX = "LibGDX";
ProjectType.UNREAL = "Unreal";
ProjectType.CORONA = "Corona";
ProjectType.THREE = "Three";

const isH5 = (type) => {
    return type == ProjectType.EGRET ||
        type == ProjectType.LAYABOX ||
        type == ProjectType.PIXI ||
        type == ProjectType.COCOSCREATOR;
};

class FObjectType {
}
FObjectType.PACKAGE = "package";
FObjectType.FOLDER = "folder";
FObjectType.IMAGE = "image";
FObjectType.GRAPH = "graph";
FObjectType.LIST = "list";
FObjectType.LOADER = "loader";
FObjectType.TEXT = "text";
FObjectType.RICHTEXT = "richtext";
FObjectType.GROUP = "group";
FObjectType.SWF = "swf";
FObjectType.MOVIECLIP = "movieclip";
FObjectType.COMPONENT = "component";
FObjectType.EXT_BUTTON = "Button";
FObjectType.EXT_LABEL = "Label";
FObjectType.EXT_COMBOBOX = "ComboBox";
FObjectType.EXT_PROGRESS_BAR = "ProgressBar";
FObjectType.EXT_SLIDER = "Slider";
FObjectType.EXT_SCROLLBAR = "ScrollBar";
FObjectType.NAME_PREFIX = {
    "image": "img",
    "graph": "graph",
    "list": "list",
    "loader": "loader",
    "text": "txt",
    "richtext": "txt",
    "group": "group",
    "swf": "swf",
    "movieclip": "mc",
    "component": "comp",
    "Button": "btn",
    "Label": "label",
    "ComboBox": "combo",
    "ProgressBar": "progress",
    "Slider": "slider",
    "ScrollBar": "scrollbar"
};

class FPackageItemType {
}
FPackageItemType.FOLDER = "folder";
FPackageItemType.IMAGE = "image";
FPackageItemType.SWF = "swf";
FPackageItemType.MOVIECLIP = "movieclip";
FPackageItemType.SOUND = "sound";
FPackageItemType.COMPONENT = "component";
FPackageItemType.FONT = "font";
FPackageItemType.MISC = "misc";
FPackageItemType.ATLAS = "atlas";
FPackageItemType.fileExtensionMap = {
    "jpg": FPackageItemType.IMAGE,
    "jpeg": FPackageItemType.IMAGE,
    "png": FPackageItemType.IMAGE,
    "psd": FPackageItemType.IMAGE,
    "tga": FPackageItemType.IMAGE,
    "svg": FPackageItemType.IMAGE,
    "plist": FPackageItemType.MOVIECLIP,
    "eas": FPackageItemType.MOVIECLIP,
    "jta": FPackageItemType.MOVIECLIP,
    "gif": FPackageItemType.MOVIECLIP,
    "wav": FPackageItemType.SOUND,
    "mp3": FPackageItemType.SOUND,
    "ogg": FPackageItemType.SOUND,
    "fnt": FPackageItemType.FONT,
    "swf": FPackageItemType.SWF,
    "xml": FPackageItemType.COMPONENT
};

process.on('uncaughtException', function (e) {
    console.log(e);
});
const compress = false, basePath = "./UIProject/", projectName = "example", extName = ".fairy", packageName = "package.xml", assetsPath = "assets/", targetPath = "./output";
const stringMap = {}, stringTable = [], xmlFileMap = {}, resourceMap = new Map;
const dependentElements = ["image", "component", "movieclip"];
let projectType = ProjectType.UNITY, pkgId = "", pkgName = "Bag", version = 2, spriteMap = new Map();
const xmlOptions = {
    attributeNamePrefix: "",
    textNodeName: "#text",
    ignoreAttributes: false,
    ignoreNameSpace: false,
    allowBooleanAttributes: false,
    parseNodeValue: true,
    parseAttributeValue: false,
    trimValues: true,
    cdataTagName: "__cdata",
    cdataPositionChar: "\\c",
    parseTrueNumberOnly: false,
    numParseOptions: {
        hex: true,
        leadingZeros: true,
    },
    arrayMode: false,
    stopNodes: ["parse-me-as-string"],
    alwaysCreateTextNode: false
};
function getProjectConfig() {
    console.log("getProjectConfig");
    let xml = fs__default["default"].readFileSync(`${basePath}${projectName}${extName}`).toString();
    let data = fastXmlParser.parse(xml, xmlOptions).projectDescription;
    let { type } = data;
    [projectType, version] = [type, +data.version];
}
function writeHead(ba, data) {
    let { version, pkgId, pkgName } = data;
    ba.writeByte("F".charCodeAt(0));
    ba.writeByte("G".charCodeAt(0));
    ba.writeByte("U".charCodeAt(0));
    ba.writeByte("I".charCodeAt(0));
    ba.writeInt(version);
    ba.writeBoolean(compress);
    ba.writeUTF(pkgId);
    ba.writeUTF(pkgName);
    let i = 0;
    while (i < 20) {
        ba.writeByte(0);
        i++;
    }
}
function getFileExtension(projectType) {
    let fileExtension = "fui";
    if (projectType == ProjectType.UNITY) {
        fileExtension = "bytes";
    }
    else if (projectType == ProjectType.COCOS2DX || projectType == ProjectType.VISION) {
        {
            fileExtension = "bytes";
        }
    }
    else if (projectType == ProjectType.CRY || projectType == ProjectType.MONOGAME || projectType == ProjectType.CORONA) {
        fileExtension = "fui";
    }
    else {
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
function getPackagesResource(resource) {
    let dependentMap = new Map();
    let resourceArr = [];
    for (let [key, value] of Object.entries(resource)) {
        if (Array.isArray(value)) {
            for (let i = 0; i < value.length; i++) {
                let item = value[i];
                item.type = key;
                resourceArr.push(item);
                resourceMap.set(item.id, item);
                if (key == "component") {
                    readXMLResource(item, dependentMap);
                }
                else if (key == "image") {
                    spriteMap.set(item.id, item);
                }
            }
        }
        else {
            value.type = key;
            resourceArr.push(value);
            resourceMap.set(value.id, value);
            if (key == "component") {
                readXMLResource(value, dependentMap);
            }
            else if (key == "image") {
                spriteMap.set(value.id, value);
            }
        }
    }
    console.log(spriteMap);
    return { dependentMap, resourceArr };
}
function readXMLResource(component, dependentMap) {
    let { name, path, id } = component;
    let xml = fs__default["default"].readFileSync(`${basePath}${assetsPath}${pkgName}${path}${name}`).toString();
    let data = fastXmlParser.parse(xml, xmlOptions).component;
    xmlFileMap[id] = data;
    Object.assign(resourceMap.get(id), data);
    let { displayList } = data;
    console.log(data);
    for (let [key, value] of Object.entries(displayList)) {
        if (dependentElements.includes(key)) {
            if (Array.isArray(value)) {
                for (let j = 0; j < value.length; j++) {
                    let element = value[j];
                    let { id, name, pkg } = element;
                    if (pkg) {
                        dependentMap.set(id, name);
                    }
                }
            }
            else {
                let { id, name, pkg } = value;
                if (pkg) {
                    dependentMap.set(id, name);
                }
            }
        }
    }
}
function encode(compress = false) {
    let headByteArray = new ByteArray();
    writeHead(headByteArray, { version, compress, pkgId, pkgName });
    let bodyByteArray = new ByteArray();
    startSegments(bodyByteArray, 6, false);
    writeSegmentPos(bodyByteArray, 0);
    console.log("packageDescription");
    let xml = fs__default["default"].readFileSync(`${basePath}${assetsPath}${pkgName}/${packageName}`).toString();
    let packageDescription = fastXmlParser.parse(xml, xmlOptions).packageDescription;
    let resources = packageDescription.resources;
    let { dependentMap, resourceArr } = getPackagesResource(resources);
    bodyByteArray.writeShort(dependentMap.size);
    dependentMap.forEach(([id, name]) => {
        writeString(bodyByteArray, id);
        writeString(bodyByteArray, name);
    });
    bodyByteArray.writeShort(0);
    writeSegmentPos(bodyByteArray, 1);
    bodyByteArray.writeShort(resourceArr.length);
    debugger;
    resourceArr.forEach((element) => {
        let byteBuffer = writeResourceItem(element);
        bodyByteArray.writeInt(byteBuffer.length);
        bodyByteArray.writeBytes(byteBuffer);
        byteBuffer.clear();
    });
    writeSegmentPos(bodyByteArray, 2);
    return headByteArray;
}
function publish() {
    getProjectConfig();
    let ba = encode();
    let fileExtension = getFileExtension(projectType);
    fs__default["default"].writeFileSync(`${targetPath}/${pkgName}.${fileExtension}`, ba.data);
}
function writeResourceItem(resource) {
    let _loc4_ = "";
    let _loc5_ = [];
    let _loc6_ = 0;
    let value = "";
    let _loc9_ = null;
    let _loc10_ = "";
    let ba = new ByteArray();
    let type = resource.type;
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
    _loc4_ = resource.size || "";
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
            ba.writeBoolean(Boolean(resource.smoothing));
            _loc9_ = xmlFileMap[value];
            ba.writeInt(0);
            break;
        case FPackageItemType.FONT:
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
            }
            else {
                ba.writeByte(0);
                ba.writeInt(0);
            }
    }
    _loc4_ = "";
    writeString(ba, _loc4_);
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
    return ba;
}
function startSegments(ba, segment, bool) {
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
function writeSegmentPos(ba, pos) {
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
function writeString(ba, str, param3 = false, param4 = true) {
    let value;
    if (param4) {
        if (!str) {
            ba.writeShort(65534);
            return;
        }
    }
    else {
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
publish();

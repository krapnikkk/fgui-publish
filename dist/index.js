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
const convertFromHtmlColor = (color, alpha = false) => {
    if (color == null || color.length < 1 || color.charAt(0) != "#") {
        return 0;
    }
    if (color.length == 9) {
        return (parseInt(color.substr(1, 2), 16) << 24) + parseInt(color.substr(3), 16);
    }
    if (alpha) {
        return 4278190080 + parseInt(color.substr(1), 16);
    }
    return parseInt(color.substr(1), 16);
};
const encodeHTML = (str) => {
    return str.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&apos;/g, "'");
};
const getAttributeBool = (data, key, defaultValue = false) => {
    var value = data[key];
    if (value == null) {
        return defaultValue;
    }
    return value == "true";
};
const getAttributeInt = (data, key, defaultValue = 0) => {
    var value = data[key];
    if (value == null) {
        return defaultValue;
    }
    return parseInt(value);
};
const getAttributeFloat = (data, key, defaultValue = 0) => {
    var value = data[key];
    if (value == null) {
        return defaultValue;
    }
    return parseFloat(value);
};
const getAttribute = (data, key, defaultValue = "") => {
    var value = data[key];
    if (value == null) {
        return defaultValue;
    }
    return value;
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
class FGearBase {
    static getIndexByName(name) {
        var index = this.nameToIndex[name];
        if (index == undefined) {
            return -1;
        }
        return index;
    }
}
FGearBase.nameToIndex = {
    "gearDisplay": 0,
    "gearXY": 1,
    "gearSize": 2,
    "gearLook": 3,
    "gearColor": 4,
    "gearAni": 5,
    "gearText": 6,
    "gearIcon": 7,
    "gearDisplay2": 8,
    "gearFontSize": 9
};
FGearBase.names = ["gearDisplay", "gearXY", "gearSize", "gearLook", "gearColor", "gearAni", "gearText", "gearIcon", "gearDisplay2", "gearFontSize"];
class EaseType {
    static parseEaseType(name) {
        let type = EaseType.easeTypeMap[name];
        if (type == undefined) {
            return 5;
        }
        return type;
    }
}
EaseType.Linear = 0;
EaseType.SineIn = 1;
EaseType.SineOut = 2;
EaseType.SineInOut = 3;
EaseType.QuadIn = 4;
EaseType.QuadOut = 5;
EaseType.QuadInOut = 6;
EaseType.CubicIn = 7;
EaseType.CubicOut = 8;
EaseType.CubicInOut = 9;
EaseType.QuartIn = 10;
EaseType.QuartOut = 11;
EaseType.QuartInOut = 12;
EaseType.QuintIn = 13;
EaseType.QuintOut = 14;
EaseType.QuintInOut = 15;
EaseType.ExpoIn = 16;
EaseType.ExpoOut = 17;
EaseType.ExpoInOut = 18;
EaseType.CircIn = 19;
EaseType.CircOut = 20;
EaseType.CircInOut = 21;
EaseType.ElasticIn = 22;
EaseType.ElasticOut = 23;
EaseType.ElasticInOut = 24;
EaseType.BackIn = 25;
EaseType.BackOut = 26;
EaseType.BackInOut = 27;
EaseType.BounceIn = 28;
EaseType.BounceOut = 29;
EaseType.BounceInOut = 30;
EaseType.Custom = 31;
EaseType.easeTypeMap = {
    "Linear": 0,
    "Elastic.In": 22,
    "Elastic.Out": 24,
    "Elastic.InOut": 24,
    "Quad.In": 4,
    "Quad.Out": 5,
    "Quad.InOut": 6,
    "Cube.In": 7,
    "Cube.Out": 8,
    "Cube.InOut": 9,
    "Quart.In": 10,
    "Quart.Out": 11,
    "Quart.InOut": 12,
    "Quint.In": 13,
    "Quint.Out": 14,
    "Quint.InOut": 15,
    "Sine.In": 1,
    "Sine.Out": 2,
    "Sine.InOut": 3,
    "Bounce.In": 28,
    "Bounce.Out": 29,
    "Bounce.InOut": 30,
    "Circ.In": 19,
    "Circ.Out": 20,
    "Circ.InOut": 21,
    "Expo.In": 16,
    "Expo.Out": 17,
    "Expo.InOut": 18,
    "Back.In": 25,
    "Back.Out": 26,
    "Back.InOut": 27
};

process.on('uncaughtException', function (e) {
    debugger;
    console.log(e);
});
const compress = false, basePath = "./UIProject/", projectName = "example", extName = ".fairy", packageName = "package.xml", assetsPath = "assets/", targetPath = "./output";
let controllerCnt = 0, controllerCache = {}, displayList = {};
const stringMap = {}, stringTable = [], xmlFileMap = {}, resourceMap = new Map;
const helperIntList = [];
const RelationNameToID = {
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
let projectType = ProjectType.UNITY, pkgId = "", pkgName = "Basics", version = 2, spriteMap = new Map();
let hitTestData = new ByteArray();
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
    name = encodeHTML(name);
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
    let ba = new ByteArray();
    let ba2 = new ByteArray();
    let i = 0;
    let str = "";
    var pos = 0;
    var len = 0;
    let longStrings;
    let cntPos = 0;
    startSegments(ba, 6, false);
    writeSegmentPos(ba, 0);
    console.log("packageDescription");
    let xml = fs__default["default"].readFileSync(`${basePath}${assetsPath}${pkgName}/${packageName}`).toString();
    let packageDescription = fastXmlParser.parse(xml, xmlOptions).packageDescription;
    let resources = packageDescription.resources;
    let { dependentMap, resourceArr } = getPackagesResource(resources);
    ba.writeShort(dependentMap.size);
    dependentMap.forEach(([id, name]) => {
        writeString(ba, id);
        writeString(ba, name);
    });
    ba.writeShort(0);
    writeSegmentPos(ba, 1);
    ba.writeShort(resourceArr.length);
    console.log(resourceArr);
    resourceArr.forEach((element) => {
        let byteBuffer = writeResourceItem(element);
        ba.writeInt(byteBuffer.length);
        ba.writeBytes(byteBuffer);
        byteBuffer.clear();
    });
    writeSegmentPos(ba, 2);
    let cnt = spriteMap.size;
    ba.writeShort(cnt);
    i = 0;
    if (hitTestData.length > 0) {
        writeSegmentPos(ba, 3);
        ba2 = hitTestData;
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
    var longStringsCnt = 0;
    cnt = stringTable.length;
    ba.writeInt(cnt);
    i = 0;
    while (i < cnt) {
        ba.writeUTF(stringTable[i]);
        ba.writeShort(0);
        if (longStrings == null) {
            longStrings = new ByteArray();
        }
        longStrings.writeShort(i);
        pos = longStrings.position;
        longStrings.writeInt(0);
        longStrings.writeUTFBytes(stringTable[i]);
        len = longStrings.position - pos - 4;
        longStrings.position = pos;
        longStrings.writeInt(len);
        longStrings.position = longStrings.length;
        longStringsCnt++;
        i++;
    }
    if (longStringsCnt > 0) {
        writeSegmentPos(ba, 5);
        ba.writeInt(longStringsCnt);
        ba.writeBytes(longStrings);
        longStrings.clear();
    }
    ba2 = ba;
    ba = new ByteArray();
    writeHead(ba, { version, pkgId, pkgName });
    ba.writeBytes(ba2);
    ba2.clear();
    return ba;
}
function publish() {
    getProjectConfig();
    console.log(`Publish start: ${pkgName}`);
    let ba = encode();
    let fileExtension = getFileExtension(projectType);
    fs__default["default"].writeFileSync(`${targetPath}/${pkgName}.${fileExtension}`, ba.data);
}
function writeResourceItem(resource) {
    let _loc3_ = null;
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
function writeGObjectData(value, xml) {
    var str = null;
    var strArr = null;
    var idx = 0;
    var childrenLen = 0;
    var children = null;
    var _loc9_ = null;
    var tempByteArray = null;
    var position = 0;
    var ba = new ByteArray();
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
    str = xml.restrictSize;
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeInt(parseInt(strArr[0]));
        ba.writeInt(parseInt(strArr[1]));
        ba.writeInt(parseInt(strArr[2]));
        ba.writeInt(parseInt(strArr[3]));
    }
    else {
        ba.writeBoolean(false);
    }
    str = xml.pivot;
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeFloat(parseFloat(strArr[0]));
        ba.writeFloat(parseFloat(strArr[1]));
        ba.writeBoolean(xml.anchor == "true");
    }
    else {
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
    }
    else {
        ba.writeBoolean(false);
    }
    str = xml.overflow;
    if (str == "hidden") {
        ba.writeByte(1);
    }
    else if (str == "scroll") {
        ba.writeByte(2);
    }
    else {
        ba.writeByte(0);
    }
    str = xml.clipSoftness;
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeInt(parseInt(strArr[0]));
        ba.writeInt(parseInt(strArr[1]));
    }
    else {
        ba.writeBoolean(false);
    }
    writeSegmentPos(ba, 1);
    childrenLen = 0;
    position = ba.position;
    ba.writeShort(0);
    var controllers = xml.controller;
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
        }
        else {
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
    }
    else {
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
    }
    else {
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
    }
    else {
        writeString(ba, null);
        ba.writeInt(0);
        ba.writeInt(0);
    }
    writeSegmentPos(ba, 5);
    childrenLen = 0;
    position = ba.position;
    ba.writeShort(0);
    return ba;
}
function writeScrollData(element) {
    var str = "";
    var strArr;
    var ba = new ByteArray();
    str = getAttribute(element, "scroll");
    if (str == "horizontal") {
        ba.writeByte(0);
    }
    else if (str == "both") {
        ba.writeByte(2);
    }
    else {
        ba.writeByte(1);
    }
    str = getAttribute(element, "scrollBar");
    if (str == "visible") {
        ba.writeByte(1);
    }
    else if (str == "auto") {
        ba.writeByte(2);
    }
    else if (str == "hidden") {
        ba.writeByte(3);
    }
    else {
        ba.writeByte(0);
    }
    ba.writeInt(getAttributeInt(element, "scrollBarFlags"));
    str = getAttribute(element, "scrollBarMargin");
    if (str) {
        strArr = str.split(",");
        ba.writeBoolean(true);
        ba.writeInt(parseInt(strArr[0]));
        ba.writeInt(parseInt(strArr[1]));
        ba.writeInt(parseInt(strArr[2]));
        ba.writeInt(parseInt(strArr[3]));
    }
    else {
        ba.writeBoolean(false);
    }
    str = getAttribute(element, "scrollBarRes");
    if (str) {
        strArr = str.split(",");
        writeString(ba, strArr[0]);
        writeString(ba, strArr[1]);
    }
    else {
        writeString(ba, null);
        writeString(ba, null);
    }
    str = getAttribute(element, "ptrRes");
    if (str) {
        strArr = str.split(",");
        writeString(ba, strArr[0]);
        writeString(ba, strArr[1]);
    }
    else {
        writeString(ba, null);
        writeString(ba, null);
    }
    return ba;
}
function writeControllerData(controller) {
    var _loc3_ = null;
    var str = null;
    var strArr = [];
    var _loc6_ = 0;
    var pageIdx = 0;
    var _loc8_ = 0;
    var homePageType = null;
    var homePage = null;
    var _loc13_ = 0;
    var ba = new ByteArray();
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
    }
    else {
        ba.writeShort(0);
        ba.writeByte(0);
    }
    writeSegmentPos(ba, 2);
    var actions = controller.action;
    pageIdx = 0;
    _loc8_ = ba.position;
    ba.writeShort(0);
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
        }
        else {
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
    writeCount(ba, _loc8_, pageIdx);
    return ba;
}
function writeActionData(action) {
    var fromPage = "";
    var strArr = [];
    var strLength = 0;
    var idx = 0;
    var ba = new ByteArray();
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
    }
    else {
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
    }
    else {
        ba.writeShort(0);
    }
    if (action.type == "play_transition") {
        writeString(ba, action.transition);
        let repeat = getAttributeInt(action, "repeat", 1);
        ba.writeInt(repeat);
        let delay = getAttributeFloat(action, "delay");
        ba.writeFloat(delay);
        let stopOnExit = getAttributeBool(action, "stopOnExit");
        ba.writeBoolean(stopOnExit);
    }
    else if (action.type == "change_page") {
        writeString(ba, action.objectId);
        writeString(ba, action.controller);
        writeString(ba, action.targetPage);
    }
    return ba;
}
function writeRelation(relations, ba, param3) {
    var _loc4_ = null;
    var _loc5_ = [];
    var relation;
    var _loc10_ = 0;
    var _loc11_ = [];
    var _loc12_ = null;
    var _loc15_ = false;
    var _loc16_ = 0;
    var _loc17_ = undefined;
    var _loc6_ = [];
    var _loc7_ = {};
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
function writeControllerItem(param1, ba) {
    ba.position;
    ba.writeShort(0);
}
function addComponent(element) {
    var tempByteBuffer;
    var _loc4_ = null;
    var _loc5_ = [];
    var _loc6_ = 0;
    var idx = 0;
    var gears = [];
    var position = 0;
    var type = 0;
    var _loc13_ = 0;
    var _loc14_;
    var gearType = 0;
    var _loc16_ = undefined;
    var _loc17_ = 0;
    var _loc18_ = 0;
    var _loc19_ = null;
    var _loc20_ = 0;
    var _loc21_ = 0;
    var _loc22_ = null;
    var _loc23_ = null;
    var _loc24_ = 0;
    var _loc25_ = 0;
    var _loc26_ = false;
    var _loc27_;
    var _loc28_ = null;
    var _loc29_ = 0;
    var ba = new ByteArray();
    var objectType = element.type;
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
    }
    else if (type == 10) {
        _loc13_ = 9;
    }
    else {
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
    }
    else {
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
    }
    else {
        ba.writeBoolean(false);
    }
    _loc4_ = element.scale;
    if (_loc4_) {
        ba.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        ba.writeFloat(parseFloat(_loc5_[0]));
        ba.writeFloat(parseFloat(_loc5_[1]));
    }
    else {
        ba.writeBoolean(false);
    }
    _loc4_ = element.skew;
    if (_loc4_) {
        ba.writeBoolean(true);
        _loc5_ = _loc4_.split(",");
        ba.writeFloat(parseFloat(_loc5_[0]));
        ba.writeFloat(parseFloat(_loc5_[1]));
    }
    else {
        ba.writeBoolean(false);
    }
    _loc4_ = element.pivot;
    if (_loc4_) {
        _loc5_ = _loc4_.split(",");
        ba.writeBoolean(true);
        ba.writeFloat(parseFloat(_loc5_[0]));
        ba.writeFloat(parseFloat(_loc5_[1]));
        ba.writeBoolean(getAttributeBool(element, "anchor"));
    }
    else {
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
    }
    else {
        ba.writeByte(0);
    }
    writeString(ba, element.customData, true);
    writeSegmentPos(ba, 1);
    writeString(ba, element.tooltips, true);
    _loc4_ = element.group;
    if (_loc4_ && displayList[_loc4_] != undefined) {
        ba.writeShort(displayList[_loc4_]);
    }
    else {
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
    }
    else if (type == 8) {
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
            _loc4_ = element.color;
            if (_loc4_) {
                ba.writeBoolean(true);
                writeColorData(ba, _loc4_, false);
            }
            else {
                ba.writeBoolean(false);
            }
            _loc4_ = element.flip;
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
            _loc4_ = element.fillMethod;
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
            gears = getChildren(element, ["Label", "Button", "Combobox", "Slider", "Scrollbar"]);
            for (let gear of gears) {
                switch (gear.type) {
                    case FObjectType.EXT_LABEL:
                        ba.writeByte(11);
                        writeString(ba, getAttribute(gear, "title"), true);
                        writeString(ba, getAttribute(gear, "icon"));
                        _loc4_ = getAttribute(gear, "titleColor");
                        if (_loc4_) {
                            ba.writeBoolean(true);
                            writeColorData(ba, _loc4_);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        ba.writeInt(getAttributeInt(gear, "titleFontSize"));
                        _loc22_ = getAttribute(gear, "prompt");
                        _loc23_ = getAttribute(gear, "restrict");
                        _loc24_ = getAttributeInt(gear, "maxLength");
                        _loc25_ = getAttributeInt(gear, "keyboardType");
                        _loc26_ = getAttributeBool(gear, "password");
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
                        writeString(ba, getAttribute(gear, "title"), true);
                        writeString(ba, getAttribute(gear, "selectedTitle"), true);
                        writeString(ba, getAttribute(gear, "icon"));
                        writeString(ba, getAttribute(gear, "selectedIcon"));
                        _loc4_ = getAttribute(gear, "titleColor");
                        if (_loc4_) {
                            ba.writeBoolean(true);
                            writeColorData(ba, _loc4_);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        ba.writeInt(getAttributeInt(gear, "titleFontSize"));
                        _loc4_ = getAttribute(gear, "controller");
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
                        writeString(ba, getAttribute(gear, "page"));
                        writeString(ba, getAttribute(gear, "sound"), false, false);
                        _loc4_ = getAttribute(gear, "volume");
                        if (_loc4_) {
                            ba.writeBoolean(true);
                            ba.writeFloat(parseInt(_loc4_) / 100);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        ba.writeBoolean(getAttributeBool(gear, "checked"));
                        continue;
                    case FObjectType.EXT_COMBOBOX:
                        ba.writeByte(13);
                        position = ba.position;
                        ba.writeShort(0);
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
                        writeString(ba, getAttribute(gear, "title"), true);
                        writeString(ba, getAttribute(gear, "icon"));
                        _loc4_ = getAttribute(gear, "titleColor");
                        if (_loc4_) {
                            ba.writeBoolean(true);
                            writeColorData(ba, _loc4_);
                        }
                        else {
                            ba.writeBoolean(false);
                        }
                        ba.writeInt(getAttributeInt(gear, "visibleItemCount"));
                        _loc4_ = getAttribute(gear, "direction");
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
                        _loc4_ = getAttribute(gear, "selectionController");
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
                        ba.writeInt(getAttributeInt(gear, "value"));
                        ba.writeInt(getAttributeInt(gear, "max", 100));
                        ba.writeInt(getAttributeInt(gear, "min"));
                        continue;
                    case FObjectType.EXT_SLIDER:
                        ba.writeByte(15);
                        ba.writeInt(getAttributeInt(gear, "value"));
                        ba.writeInt(getAttributeInt(gear, "max", 100));
                        ba.writeInt(getAttributeInt(gear, "min"));
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
        let items = element.item;
        let itemLen = items.length;
        idx = 0;
        helperIntList.length = idx;
        while (idx < itemLen) {
            let item = items[idx];
            _loc29_ = getAttributeInt(item, "level", 0);
            helperIntList[idx] = _loc29_;
            idx++;
        }
        _loc6_ = 0;
        ba.writeShort(idx);
        let itemIdx = 0;
        while (itemIdx < itemLen) {
            let item = items[itemIdx];
            tempByteBuffer = new ByteArray();
            writeString(tempByteBuffer, getAttribute(item, "url"));
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
            writeString(tempByteBuffer, getAttribute(item, "title"), true);
            writeString(tempByteBuffer, getAttribute(item, "selectedTitle"), true);
            writeString(tempByteBuffer, getAttribute(item, "icon"));
            writeString(tempByteBuffer, getAttribute(item, "selectedIcon"));
            writeString(tempByteBuffer, getAttribute(item, "name"));
            _loc4_ = getAttribute(item, "controllers");
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
function writeGearData(gearType, gear) {
    var controller = "";
    var strArr = [];
    var strLength = 0;
    var idx = 0;
    var _loc9_ = undefined;
    var controllerArr = [];
    var controllerDetails = [];
    var positionsInPercent = false;
    var condition = 0;
    controller = gear.controller;
    if (controller) {
        _loc9_ = controllerCache[controller];
        if (_loc9_ == undefined) {
            return null;
        }
        var ba = new ByteArray();
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
function writeGearValue(type, value, ba) {
    var _loc4_ = [];
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
function writeColorData(ba, color, alpha = true, param4 = 4.27819008E9) {
    var _loc5_ = 0;
    if (color) {
        _loc5_ = convertFromHtmlColor(color, alpha);
    }
    else {
        _loc5_ = param4;
    }
    ba.writeByte(_loc5_ >> 16 & 255);
    ba.writeByte(_loc5_ >> 8 & 255);
    ba.writeByte(_loc5_ & 255);
    if (alpha) {
        ba.writeByte(_loc5_ >> 24 & 255);
    }
    else {
        ba.writeByte(255);
    }
}
function writeAlignData(ba, type) {
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
function writeValignData(ba, type) {
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
function writeFillMethodData(ba, type) {
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
function writeTextSizeData(ba, type) {
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
function writeGraphData(ba, type) {
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
function writeCount(ba, position, count) {
    var _loc4_ = ba.position;
    ba.position = position;
    ba.writeShort(count);
    ba.position = _loc4_;
}
function getChildren(display, name) {
    let children = [];
    for (let [key, value] of Object.entries(display)) {
        if (name) {
            let flag = false;
            if (Array.isArray(name)) {
                flag = name.includes(key);
            }
            else {
                flag = key.includes(name);
            }
            if (flag) {
                if (Array.isArray(value)) {
                    value.forEach((item) => {
                        item.type = key;
                        children.push(item);
                    });
                }
                else {
                    value.type = key;
                    children.push(value);
                }
            }
        }
        else {
            if (Array.isArray(value)) {
                value.forEach((item) => {
                    item.type = key;
                    children.push(item);
                });
            }
            else {
                value.type = key;
                children.push(value);
            }
        }
    }
    return children;
}
publish();

import ByteArray from "src/utils/ByteArray";
import XData from "./XData";

export default class UtilsFile {

    private static helperBuffer: ByteArray = new ByteArray();

    private static elementBuffer: ByteArray = new ByteArray();

    public static browseForOpen(param1: string, param2: Array<any>, param3: Function, param4: File = null): void {
        // var title:string = param1;
        // var filters:Array<any> = param2;
        // var callback: = param3;
        // var initiator: File = param4;
        // if (initiator == null) {
        //     initiator = new File();
        // }
        // initiator.browseForOpen(title, filters);
        // initiator.addEventListener(Event.SELECT, (param1: Event): void {
        //     callback(param1.target as File);
        // });
    }

    public static browseForOpenMultiple(param1: string, param2: Array<any>, param3: Function, param4: File = null): void {
        // var title:string = param1;
        // var filters:Array<any> = param2;
        // var callback: = param3;
        // var initiator: File = param4;
        // if (initiator == null) {
        //     initiator = new File();
        // }
        // initiator.browseForOpenMultiple(title, filters);
        // initiator.addEventListener(Event.SELECT, (param1: Event): void {
        //     callback([param1.target]);
        // });
        // initiator.addEventListener(FileListEvent.SELECT_MULTIPLE, (param1: FileListEvent): void {
        //     callback(param1.files);
        // });
    }

    public static browseForDirectory(param1: string, param2: Function, param3: File = null): void {
        // var title:string = param1;
        // var callback: = param2;
        // var initiator: File = param3;
        // if (initiator == null) {
        //     initiator = new File();
        // }
        // initiator.browseForDirectory(title);
        // initiator.addEventListener(Event.SELECT, (param1: Event): void {
        //     callback(param1.target as File);
        // });
    }

    public static browseForSave(param1: string, param2: Function, param3: File = null): void {
        // var title:string = param1;
        // var callback: = param2;
        // var initiator: File = param3;
        // if (initiator == null) {
        //     initiator = new File();
        // }
        // initiator.browseForSave(title);
        // initiator.addEventListener(Event.SELECT, (param1: Event): void {
        //     callback(param1.target as File);
        // });
    }

    public static listAllFiles(param1: File, param2: Array<any>): void {
        // var _loc4_: File = null;
        // var _loc3_: Array<any> = param1.getDirectoryListing();
        // for (_loc4_ in _loc3_) {
        //     if (_loc4_.isDirectory) {
        //         listAllFiles(_loc4_, param2);
        //     }
        //     else {
        //         param2.push(_loc4_);
        //     }
        // }
    }

    public static loadString(param1: File, param2: string = null): string {
        var _loc4_: number = 0;
        var _loc5_: number = 0;
        var _loc3_: ByteArray = UtilsFile.loadBytes(param1);
        if (_loc3_ == null) {
            return null;
        }
        if (!param2) {
            if (_loc3_.bytesAvailable > 2) {
                _loc4_ = _loc3_.readUnsignedByte();
                _loc5_ = _loc3_.readUnsignedByte();
                if (_loc4_ == 239 && _loc5_ == 187) {
                    param2 = "utf-8";
                    _loc3_.position++;
                }
                else if (_loc4_ == 254 && _loc5_ == 255) {
                    param2 = "unicodeFFFE";
                }
                else if (_loc4_ == 255 && _loc5_ == 254) {
                    param2 = "unicode";
                }
                else {
                    param2 = "utf-8";
                    _loc3_.position = _loc3_.position - 2;
                }
            }
            else {
                param2 = "utf-8";
            }
        }
        if (param2.toLowerCase() == "utf-8") {
            return _loc3_.readUTFBytes(_loc3_.length - _loc3_.position);
        }
        return _loc3_.readMultiByte(_loc3_.length - _loc3_.position, param2);
    }

    public static saveString(param1: File, param2: string, param3: string = null): void {
        var _loc4_: ByteArray = new ByteArray();
        if (!param3 || param3.toUpperCase() == "UTF-8") {
            _loc4_.writeUTFBytes(param2);
        }
        else {
            _loc4_.writeMultiByte(param2, param3);
        }
        UtilsFile.saveBytes(param1, _loc4_);
    }

    public static loadBytes(param1: File): ByteArray {
        // if (!param1.exists) {
        //     return null;
        // }
        // var _loc2_: FileStream = new FileStream();
        // _loc2_.open(param1, FileMode.READ);
        var _loc3_: ByteArray = new ByteArray();
        // _loc2_.readBytes(_loc3_, 0, param1.size);
        // _loc2_.close();
        return _loc3_;
    }

    public static saveBytes(param1: File, param2: ByteArray): void {
        // var _loc3_: FileStream = new FileStream();
        // _loc3_.open(param1, FileMode.WRITE);
        // param2.position = 0;
        // _loc3_.writeBytes(param2);
        // _loc3_.close();
    }

    public static loadXMLRoot(param1: File): XData {
        // var i:number = 0;
        // var elementStart:number = 0;
        // var b:number = 0;
        // var str: string = null;
        // var file: File = param1;
        // if (!file.exists) {
        //     return null;
        // }
        // var fs: FileStream = new FileStream();
        // fs.open(file, FileMode.READ);
        // var len:number = Math.min(file.size, 1024);
        // UtilsFile.helperBuffer.length = 0;
        // fs.readBytes(UtilsFile.helperBuffer, 0, len);
        // fs.close();
        // while (i++ < len) {
        //     b = UtilsFile.helperBuffer.readByte();
        //     if (b == 60) {
        //         elementStart = i - 1;
        //         while (i++ < len) {
        //             b = UtilsFile.helperBuffer.readByte();
        //             if (b == 62) {
        //                 UtilsFile.helperBuffer.position = elementStart;
        //                 str = UtilsFile.helperBuffer.readUTFBytes(i - elementStart);
        //                 if (str.charCodeAt(1) != 63 && str.charCodeAt(1) != 33) {
        //                     if (str.charCodeAt(str.length - 2) != 47) {
        //                         i = str.indexOf(" ");
        //                         if (i == -1) {
        //                             i = str.length - 1;
        //                         }
        //                         str = str + "</" + str.substring(1, i) + ">";
        //                     }
        //                     try {
        //                         return XData.parse(str);
        //                     }
        //                     catch (err: Error) {
        //                         return null;
        //                     }
        //                     UtilsFile.helperBuffer.position = i;
        //                     break;
        //                 }
        //                 UtilsFile.helperBuffer.position = i;
        //                 break;
        //             }
        //         }
        //         continue;
        //     }
        // }
        return null;
    }

    // public static loadXML(param1: File): XML {
    //     // var _loc2_: string = UtilsFile.loadString(param1);
    //     // if (_loc2_) {
    //     //     return new XML(_loc2_);
    //     // }
    //     return null;
    // }

    // public static saveXML(param1: File, param2: XML): void {
    //     UtilsFile.saveString(param1, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" + param2.toXMLString());
    // }

    public static loadXData(param1: File): XData {
        var _loc2_: string = UtilsFile.loadString(param1);
        if (_loc2_) {
            return XData.parse(_loc2_);
        }
        return null;
    }

    public static saveXData(param1: File, param2: XData): void {
        // UtilsFile.saveXML(param1, param2.toXML());
    }

    public static loadJSON(param1: File): Object {
        var _loc2_: string = UtilsFile.loadString(param1);
        if (_loc2_) {
            return JSON.parse(_loc2_);
        }
        return null;
    }

    public static saveJSON(param1: File, param2: Object, param3: boolean = false): void {
        // if (param3) {
        //     UtilsFile.saveString(param1, OrderedJSONEncoder.encode(param2));
        // }
        // else {
        //     UtilsFile.saveString(param1, JSON.stringify(param2, null, "\t"));
        // }
    }

    public static deleteFile(param1: File, param2: boolean = false): boolean {
        // var file: File = param1;
        // var moveToTrash: boolean = param2;
        // try {
        //     if (moveToTrash) {
        //         file.moveToTrashAsync();
        //     }
        //     else {
        //         file.deleteFile();
        //     }
        //     return true;
        // }
        // catch (e: Error) {
        //     if (e.errorID == 3001 && !moveToTrash) {
        //         try {
        //             file.moveToTrashAsync();
        //         }
        //         catch (e: Error) {
        //         }
        //     }
        //     else if (e.errorID != 3003) {
        //     }
        // }
        return false;
    }

    public static copyFile(param1: File, param2: File): boolean {
        // var srcFile: File = param1;
        // var dstFile: File = param2;
        // if (srcFile.nativePath == dstFile.nativePath) {
        //     return true;
        // }
        // UtilsFile.deleteFile(dstFile);
        // try {
        //     if (srcFile.exists) {
        //         srcFile.copyTo(dstFile, true);
        //         return true;
        //     }
        //     return false;
        // }
        // catch (e: Error) {
        // }
        return false;
    }

    public static renameFile(param1: File, param2: File): void {
        // var _loc4_: File = null;
        // var _loc3_: any = param2.name.toLowerCase() == param1.name.toLowerCase();
        // if (param2.exists && !_loc3_) {
        //     throw new Error("file already exits");
        // }
        // if (_loc3_) {
        //     _loc4_ = new File(param2.nativePath + "_" + Math.random() * 1000);
        //     param1.moveTo(_loc4_);
        //     _loc4_.moveTo(param2);
        // }
        // else {
        //     param1.moveTo(param2);
        // }
    }
}


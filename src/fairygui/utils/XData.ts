import UtilsStr from "./UtilsStr";
import XDataEnumerator from "./XDataEnumerator";

export default class XData {


    private _children: Array<XData>;

    // private _xml: XML; // todo
    private _xml: any;

    public constructor() {

    }

    public static parse(param1: string): XData {
        var _loc2_: XData = new XData();
        // XML.ignoreWhitespace = true;
        // _loc2_._xml = new XML(param1);
        return _loc2_;
    }

    public static create(param1: string): XData {
        var _loc2_: XData = new XData();
        // _loc2_._xml = new XML("<" + param1 + "/>");
        return _loc2_;
    }

    // public static attach(param1: XML): XData {
    //     var _loc2_: XData = new XData();
    //     _loc2_._xml = param1;
    //     return _loc2_;
    // }

    public getName(): string {
        return this._xml.name().localName;
    }

    public setName(param1: string): void {
        this._xml.setLocalName(param1);
    }

    public getText(): string {
        return this._xml.text();
    }

    public setText(param1: string): void {
        this._xml.setChildren(param1);
    }

    public getAttribute(param1: string, param2: string = ""): string {
        // var _loc3_: XMLList = this._xml.attribute(param1);
        // if (_loc3_ && _loc3_.length()) {
        //     return _loc3_.toString();
        // }
        return param2;
    }

    public getAttributeInt(param1: string, param2: number = 0): number {
        var _loc3_: string = this.getAttribute(param1);
        if (_loc3_ == null) {
            return param2;
        }
        return parseInt(_loc3_);
    }

    public getAttributeFloat(param1: string, param2: Number = 0): Number {
        var _loc3_: string = this.getAttribute(param1);
        if (_loc3_ == null) {
            return param2;
        }
        return parseFloat(_loc3_);
    }

    public getAttributeBool(param1: string, param2:boolean = false):boolean {
        var _loc3_: string = this.getAttribute(param1);
        if (_loc3_ == null) {
            return param2;
        }
        return _loc3_ == "true";
    }

    public getAttributeColor(param1: string, param2:boolean, param3:number = 0):number {
        var _loc4_: string = this.getAttribute(param1);
        if (_loc4_ == null) {
            return param3;
        }
        return UtilsStr.convertFromHtmlColor(_loc4_, param2);
    }

    public setAttribute(param1: string, param2:any): void {
        this._xml[param1] = param2;
    }

    public removeAttribute(param1: string): void {
        delete this._xml[param1];
    }

    // public hasAttribute(param1: string):boolean {
    //     var _loc2_: XMLList = this._xml.attribute(param1);
    //     return _loc2_ && _loc2_.length() > 0;
    // }

    public hasAttributes():boolean {
        return this._xml.attributes().length() > 0;
    }

    private buildChildrenList(): void {
        // var _loc2_: XML;
        // var _loc3_: XData;
        // var _loc1_: XMLList = this._xml.children();
        // this._children = new Array<XData>();
        // for (_loc2_ in _loc1_) {
        //     _loc3_ = new XData();
        //     _loc3_._xml = _loc2_;
        //     this._children.push(_loc3_);
        // }
    }

    public getChild(param1: string): XData {
        var _loc2_: XData;
        // if (this._children == null) {
        //     this.buildChildrenList();
        // }
        // for (_loc2_ in this._children) {
        //     if (_loc2_.getName() == param1) {
        //         return _loc2_;
        //     }
        // }
        return null;
    }

    public getChildAt(param1: number): XData {
        if (this._children == null) {
            this.buildChildrenList();
        }
        if (param1 >= 0 && param1 < this._children.length) {
            return this._children[param1];
        }
        throw new Error("index out of bounds!");
    }

    public getChildren(): Array<XData> {
        if (this._children == null) {
            this.buildChildrenList();
        }
        return this._children;
    }

    public appendChild(param1: XData): XData {
        var _loc2_: XData;
        if (param1._xml.parent() == this._xml) {
            return param1;
        }
        this._xml.appendChild(param1._xml);
        if (this._children != null) {
            _loc2_ = new XData();
            _loc2_._xml = param1._xml;
            this._children.push(_loc2_);
        }
        return param1;
    }

    public removeChild(param1: XData): void {
        // var _loc2_: number = 0;
        // if (param1._xml.parent() == this._xml) {
        //     delete this._xml.children()[param1._xml.childIndex()];
        //     if (this._children != null) {
        //         _loc2_ = this._children.indexOf(param1);
        //         if (_loc2_ != -1) {
        //             this._children.removeAt(_loc2_);
        //         }
        //     }
        // }
    }

    public removeChildAt(param1: number): void {
        // if (param1 >= 0 && param1 < this._xml.children().length()) {
        //     delete this._xml.children()[param1];
        //     if (this._children != null) {
        //         this._children.removeAt(param1);
        //     }
        //     return;
        // }
        // throw new Error("index out of bounds!");
    }

    public removeChildren(param1: string = ""): void {
        // var _loc2_: XMLList;
        // var _loc3_: number = 0;
        // var _loc4_: number = 0;
        // if (param1 == null) {
        //     this._xml.setChildren("");
        //     if (this._children != null) {
        //         this._children.length = 0;
        //     }
        // }
        // else {
        //     _loc2_ = this._xml[param1];
        //     _loc3_ = _loc2_.length();
        //     if (_loc3_) {
        //         _loc4_ = _loc3_;
        //         while (_loc4_ >= 0) {
        //             delete _loc2_[_loc4_];
        //             if (this._children) {
        //                 this._children.splice(_loc4_, 1);
        //             }
        //             _loc4_--;
        //         }
        //     }
        // }
    }

    public getEnumerator(param1: string = ""): XDataEnumerator {
        return new XDataEnumerator(this, param1);
    }

    public copy(): XData {
        var _loc1_: XData = new XData();
        _loc1_._xml = this._xml.copy();
        return _loc1_;
    }

    public equals(param1: XData):boolean {
        return param1 && this._xml.toXMLString() == param1._xml.toXMLString();
    }

    // public toXML(): XML {
    //     return this._xml;
    // }

    public dispose(): void {
        if (this._xml) {
            // System.disposeXML(this._xml);
            // this._xml;
        }
    }
}


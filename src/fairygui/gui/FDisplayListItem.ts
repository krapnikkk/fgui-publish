import XData from "../utils/XData";
import FPackage from "./FPackage";
import FPackageItem from "./FPackageItem";

export default class FDisplayListItem {


    public packageItem: FPackageItem;

    public pkg: FPackage;

    public type: string;

    public desc: XData;

    // public missingInfo: MissingInfo;

    // public existingInstance: FObject;

    public constructor(param1: FPackageItem, param2: FPackage, param3: string) {
        this.packageItem = param1;
        this.pkg = param2;
        this.type = param3;
    }
}
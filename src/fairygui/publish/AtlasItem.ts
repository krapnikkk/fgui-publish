import FPackageItem from "../gui/FPackageItem";

export default class AtlasItem {
    public index: number;

    public id: string;

    //   public §_-E0§:boolean;
    public alphaChannel: boolean;

    public npot: boolean;

    public mof: boolean;

    public items: Array<FPackageItem>;

    public constructor() {
        this.items = [];
    }
}


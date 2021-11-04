import ByteArray from "src/utils/ByteArray";
import FPackage from "../gui/FPackage";
import FPackageItem from "../gui/FPackageItem";
import FProject from "../gui/FProject";
import AtlasItem from "./AtlasItem";
import AtlasOutput from "./AtlasOutput";

export default class PublishData {
    public project: FProject;

    public pkg: FPackage;

    // public $_O4$: boolean;
    public supportAtlas: boolean;

    public exportDescOnly: boolean;

    public path: string;

    public fileName: string;

    public fileExtension: string;

    public singlePackage: boolean;

    public extractAlpha: boolean;

    public genCode: boolean;

    public codePath: string;

    public includeHighResolution: number;

    public trimImage: boolean;

    public branch: string;

    public $_GR$: { [key: string]: any }

    public branches: number;

    public includeBranches: boolean;

    public allBranches: number; // §_ - Ho§

    public items: Array<FPackageItem>;

    public atlases: Array<AtlasItem>;

    public atlasOutput: Array<AtlasOutput>;

    public outputDesc: { [key: string]: any }

    public outputRes: { [key: string]: any }

    public outputClasses: { [key: string]: any }

    public sprites: string;

    public hitTestImages: Array<FPackageItem>;

    public hitTestData: ByteArray;

    public fontTextures: { [key: string]: any }

    public $_Fc$: Array<any>;

    public $_DJ$: { [key: string]: any }

    public $_BH$: number;

    public defaultPrevented: boolean;

    public constructor() {
        this.items = [];
        this.outputDesc = {};
        this.outputRes = {};
        this.outputClasses = {};
        this.hitTestImages = [];
        this.hitTestData = new ByteArray();
        this.fontTextures = {};
        this.$_Fc$ = [];
        this.$_DJ$ = {};
        this.$_GR$ = {};
        this.branches = 0;
        this.atlases = [];
        this.atlasOutput = [];
    }
}


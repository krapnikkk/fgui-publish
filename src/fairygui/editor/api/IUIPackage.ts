import FPackageItem from "src/fairygui/gui/FPackageItem";
import IUIProject from "./IUIProject";

export default interface IUIPackage {


    get project(): IUIProject;

    get id(): string;

    get name(): string;

    get basePath(): string;

    get rootItem(): FPackageItem;

    get items(): Array<FPackageItem>;

    get opened(): boolean;

    setChanged(): void;

    get publishSettings(): Object;

    getItemListing(param1: FPackageItem, param2: Array<any>, param3: boolean, param4: boolean, param5: Array<FPackageItem>): Array<FPackageItem>;

    // getFavoriteItems(param1: Array<FPackageItem> = null): Array<FPackageItem>;

    getItem(param1: string): FPackageItem;

    findItemByName(param1: string): FPackageItem;

    getItemByName(param1: FPackageItem, param2: string): FPackageItem;

    getItemByFileName(param1: FPackageItem, param2: string): FPackageItem;

    getItemByPath(param1: string): FPackageItem;

    getItemPath(param1: FPackageItem, param2: Array<FPackageItem>): Array<FPackageItem>;

    addItem(param1: FPackageItem): void;

    moveItem(param1: FPackageItem, param2: string): void;

    duplicateItem(param1: FPackageItem, param2: string): FPackageItem;

    renameItem(param1: FPackageItem, param2: string): void;

    deleteItem(param1: FPackageItem): number;

    setItemProperty(param1: FPackageItem, param2: string, param3: any): void;

    getNextId(): string;

    getSequenceName(param1: string): string;

    getUniqueName(param1: FPackageItem, param2: string): string;

    createBranch(param1: string): void;

    getBranchPath(param1: string): string;

    createFolder(param1: string, param2: string, param3: boolean): FPackageItem;

    createPath(param1: string): FPackageItem;

    createComponentItem(param1: string, param2: number, param3: number, param4: string, param5: string, param6: boolean, param7: boolean): FPackageItem;

    createFontItem(param1: string, param2: string, param3: boolean): FPackageItem;

    createMovieClipItem(param1: string, param2: string, param3: boolean): FPackageItem;

    importResource(param1: File, param2: string, param3: string, param4: Function): void;

    updateResource(param1: FPackageItem, param2: File, param3: Function): void;

    setVar(param1: string, param2: any): void;

    getVar(param1: string): any;

    get strings(): Object;

    set strings(param1: Object);

    beginBatch(): void;

    endBatch(): void;

    save(): void;
}


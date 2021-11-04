import FPackageItem from "src/fairygui/gui/FPackageItem";
import IUIPackage from "./IUIPackage";

export default interface IUIProject {


   //   get editor() : IEditor;

   get id(): string;

   get name(): string;

   get type(): string;

   set type(param1: string);

   get basePath(): string;

   get assetsPath(): string;

   get settingsPath(): string;

   get objsPath(): string;

   get versionCode(): number;

   get serialNumberSeed(): string;

   get lastChanged(): number;

   setChanged(): void;

   get supportAtlas():boolean;

   get isH5():boolean;

   get supportExtractAlpha():boolean;

   get supportAlphaMask():boolean;

   get supportCustomFileExtension():boolean;

   getSettings(param1: string): Object;

   getSetting(param1: string, param2: string): any;

   setSetting(param1: string, param2: string, param3: any): void;

   saveSettings(param1: string): void;

   getPackage(param1: string): IUIPackage;

   getPackageByName(param1: string): IUIPackage;

   get allPackages(): Array<IUIPackage>;

   get activeBranch(): string;

   set activeBranch(param1: string);

   get allBranches(): Array<string>;

   createBranch(param1: string): void;

   renameBranch(param1: string, param2: string): void;

   removeBranch(param1: string): void;

   createPackage(param1: string): IUIPackage;

   deletePackage(param1: string): void;

   addPackage(param1: File): IUIPackage;

   getItemByURL(param1: string): FPackageItem;

   findItemByFile(param1: File): FPackageItem;

   setVar(param1: string, param2: any): void;

   getVar(param1: string): any;

   registerCustomExtension(param1: string, param2: string, param3: string): void;

   getCustomExtension(param1: string): Object;

   clearCustomExtensions(): void;

   logError(param1: string, param2: any): void;

   playSound(param1: string, param2: Number): void;

   asyncRequest(param1: string, param2: any, param3: any, param4: any): void;
}

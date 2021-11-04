interface IBase {
    id: string;
}

interface IPackageHeader {
    version: number;
    compress: boolean;
    pkgId: string;
    pkgName: string;
}

interface IProjectDescription extends IBase {
    type: string;
    version: string;
}

interface IPackageDescription extends IBase {
    publish: IPublish;
    resources: IResource;
}

interface IPublish {
    name: string;
    atlas: {
        name: string;
        index: string
    }
}

interface IResource {
    component: IComponentResource | IComponentResource[];
    image: IImageResource | IImageResource[];
    movieclip: IMovieclipResource | IMovieclipResource[];
}

interface IBaseResource extends IBase {
    name: string;
    path: string;
    type: string;
    file?: string;
    exported?: string;
    size?:string;
    scale?: string;
    scale9grid?: string;
    gridTile?:string;
    smoothing?:string;
}

interface IImageResource extends IBaseResource {

}

interface IMovieclipResource extends IBaseResource {

}

interface IComponentResource extends IBaseResource {
}

type ResourceType = IImageResource | IMovieclipResource | IComponentResource;

// 组件文件
interface IComponentFile {
    size: string;
    controller?: IConroller | IConroller[];
    displayList: IDisplayList;
    extention?: string;
    initName?: string;
    Button?: string | { mode: string };
}

interface IDisplayList {
    component?: IComponentElement | IComponentElement[];
    image?: IImageElement | IImageElement[];
    list?: IListElement | IListElement[];
    loader?: ILoaderElement | ILoaderElement[];
    graph?: IGraphElement | IGraphElement[];
    group?: IGroupElement | IGroupElement[];
    movieclip?: IMovieClipElement | IMovieClipElement[];
    jta?: IMovieClipElement | IMovieClipElement[];
}

// 基础元件
interface IBaseElement extends IBase {
    name: string;
    size: string;
    src?: string; // text graph group
    pkg?: string; // 跨包依赖元件
    fileName?: string;
    xy: string;
    group?: string;
    touchable?: string;
    relation?: {
        sidePair: string;
        target: string;
    }
}

interface IComponentElement extends IBaseElement {
    // 扩展
    Label?: {
        title: string;
    }
}

interface IImageElement extends IBaseElement {
    aspect?: string;
    gearDisplay?: IGearBase;
    gearSize?: IGearBase;
    gearXY?: IGearBase
}


interface IListElement extends IBaseElement {
    clipSoftness: string;
    colGap: string;
    defaultItem: string;
    layout: string;
    lineGap: string;
    overflow: string;
    pageController: string;
    scroll: string;
    scrollBarFlags: string;
    item: string[];
}

interface ILoaderElement extends IBaseElement {
    align: string;
    vAlign: string;
}

interface IGraphElement extends IBaseElement {
    fillColor?: string;
    lineSize?: string;
    type?: string;
}

interface IGroupElement extends IBaseElement {
    advanced: string;
}

interface IMovieClipElement extends IBaseElement {
}

interface IjtaElement extends IBaseElement {

}

interface ITextElement extends IBaseElement {
    color: string;
    fontSize: string;
    text: string;
    autoSize: string;
}

interface IGearBase {
    controller: string;
    pages: string;
    default?: string;
    values?: string;
}

interface IConroller {
    name: string;
    page: string;
    selected: string;
}

type ElementType = IComponentElement | IImageElement | ITextElement | IMovieClipElement | IGroupElement | IGraphElement | ILoaderElement | IListElement | IjtaElement;


// ============
interface IPackageResource {
    dependentMap: Map<string, string>;
    resourceArr: ResourceType[];
}
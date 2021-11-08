interface IBase {
    id: string;
}

interface IPackageHeader {
    version: number;
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
    size?: string;
    scale?: string;
    scale9grid?: string;
    gridTile?: string;
    smoothing?: string;
}

interface IImageResource extends IBaseResource {

}

interface IMovieclipResource extends IBaseResource {

}

interface IComponentResource extends IBaseResource {
}

type ResourceType = IImageResource | IMovieclipResource | IComponentResource;

// 组件文件[xml]
interface IComponentFile {
    size: string;
    controller?: IController | IController[];
    displayList: IDisplayList;
    extention?: string;
    initName?: string;
    Button?: string | { mode: string }; // ext
    restrictSize?: string;
    pivot?: string;
    anchor?: string;
    margin?: string;
    overflow?: string;
    clipSoftness?: string;
    customData?: string;
    opaque?: string;
    mask?: string;
    reversedMask?: string;
    hitTest?: string;
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
    type?: string;
    src?: string; // text graph group
    pkg?: string; // 跨包依赖元件
    fileName?: string;
    xy: string;
    touchable?: string;
    restrictSize?:string;
    scale?:string;
    skew?:string;
    pivot?:string;
    anchor?:string;
    alpha?:string;
    rotation?:string;
    visible?:string;
    grayed?:string;
    blend?:string;
    filter?:string;
    filterData?:string;
    customData?:string;
    tooltips?:string;
    group?:string;
    pageController?:string,
    gearDisplay?: IGearBase;
    gearSize?: IGearBase;
    gearXY?: IGearBase
    controller?:string;
    relation?: {
        sidePair: string;
        target: string;
    }
}

interface IComponentElement extends IBaseElement {
    // 扩展
    Label?: {
        title: string;
        icon:string;
        titleColor:string;
    };
    Button?: {
        title?: string;
        selectedTitle?:string;
        icon?:string;
        selectedIcon?:string;
        titleColor?:string;
        titleFontSize?:string;
        controller?:string;
        page?:string;
        sound?:string;
        volume?:string;
        checked?:string;
    };
    Combobox?:{
        item?:string;
        visibleItemCount?:string;
        value?:string;
        icon?:string;
        title?:string;
        titleColor?:string;
        direction?:string;
        selectionController?:string;
    };
    Slider?:{
        value?:string;
        max?:string;
        min?:string;
    };
    Scrollbar?:{
    }
    
}

interface IImageElement extends IBaseElement {
    aspect?: string;
    color?:string;
    flip?:string;
    fillMethod?:string;
}


interface IListElement extends IBaseElement {
    clipSoftness: string;
    colGap: string;
    defaultItem: string;
    layout: string;
    lineGap: string;
    overflow: string;
    scroll: string;
    scrollBarFlags: string;
    item: IListElementItem[];
    treeView?:string;
}

interface IListElementItem{
    url:string;
    level:string;
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
    color?:string;
    frame?:string;
    playing?:string;
}

interface IjtaElement extends IBaseElement {

}

interface IScrollBarElement extends IBaseElement {
    
}

interface ITextElement extends IBaseElement {
    color: string;
    fontSize: string;
    text: string;
    autoSize: string;
}

interface IInpuTextElement extends ITextElement{
    prompt?:string;
    restrict?:string;
    maxLength?:string;
    keyboardType?:string;
    password?:string;
}

interface IGearBase {
    type?:string;
    controller: string;
    pages: string;
    default?: string;
    values?: string;
    ease?:string;
    condition?:string
}

interface IController {
    name: string;
    pages: string;
    selected: string;
    alias?: string;
    homePageType?: string;
    homePage?: string;
    exported?: string;
    autoRadioGroupDepth?: string;
    action?: IControllerActionType | IControllerActionType[];
}

type IControllerActionType = IControllerActionPage | IControllerActionTransition;

interface IControllerActionPage {
    type: "change_page";
    fromPage: string;
    toPage: string;
    targetPage: string;
    controller: string;
    objectId?: string;
}

interface IControllerActionTransition {
    type: "play_transition";
    fromPage: string;
    toPage: string;
    transition: string;
    repeat: string;
    delay: string;
    stopOnExit: string;
}

type ElementType = IComponentElement | IImageElement | ITextElement | IMovieClipElement | IGroupElement | IGraphElement | ILoaderElement | IListElement | IjtaElement;


interface IHitTestImage {
    width: number;
    height: number
}

// ============
interface IPackageResource {
    dependentMap: Map<string, string>;
    resourceArr: ResourceType[];
}
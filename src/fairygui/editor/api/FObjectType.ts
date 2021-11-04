export default class FObjectType {

    public static PACKAGE:string = "package";

    public static FOLDER:string = "folder";

    public static IMAGE:string = "image";

    public static GRAPH:string = "graph";

    public static LIST:string = "list";

    public static LOADER:string = "loader";

    public static TEXT:string = "text";

    public static RICHTEXT:string = "richtext";

    public static GROUP:string = "group";

    public static SWF:string = "swf";

    public static MOVIECLIP:string = "movieclip";

    public static COMPONENT:string = "component";

    public static EXT_BUTTON:string = "Button";

    public static EXT_LABEL:string = "Label";

    public static EXT_COMBOBOX:string = "ComboBox";

    public static EXT_PROGRESS_BAR:string = "ProgressBar";

    public static EXT_SLIDER:string = "Slider";

    public static EXT_SCROLLBAR:string = "ScrollBar";

    public static NAME_PREFIX: {[key:string]:string} = {
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
}


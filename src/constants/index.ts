export class FButton {
    static COMMON: String = "Common";

    static CHECK: String = "Check";

    static RADIO: String = "Radio";

    static UP: String = "up";

    static DOWN: String = "down";

    static OVER: String = "over";

    static SELECTED_OVER: String = "selectedOver";

    static DISABLED: String = "disabled";

    static SELECTED_DISABLED: String = "selectedDisabled";
}

export class FPackageItemType {

    public static FOLDER: string = "folder";

    public static IMAGE: string = "image";

    public static SWF: string = "swf";

    public static MOVIECLIP: string = "movieclip";

    public static SOUND: string = "sound";

    public static COMPONENT: string = "component";

    public static FONT: string = "font";

    public static MISC: string = "misc";

    public static ATLAS: string = "atlas";

    public static fileExtensionMap: { [key: string]: string } = {
        "jpg": FPackageItemType.IMAGE,
        "jpeg": FPackageItemType.IMAGE,
        "png": FPackageItemType.IMAGE,
        "psd": FPackageItemType.IMAGE,
        "tga": FPackageItemType.IMAGE,
        "svg": FPackageItemType.IMAGE,
        "plist": FPackageItemType.MOVIECLIP,
        "eas": FPackageItemType.MOVIECLIP,
        "jta": FPackageItemType.MOVIECLIP,
        "gif": FPackageItemType.MOVIECLIP,
        "wav": FPackageItemType.SOUND,
        "mp3": FPackageItemType.SOUND,
        "ogg": FPackageItemType.SOUND,
        "fnt": FPackageItemType.FONT,
        "swf": FPackageItemType.SWF,
        "xml": FPackageItemType.COMPONENT
    };
}

export class FGearBase {
    public static nameToIndex: { [key: string]: number } = {
        "gearDisplay": 0,
        "gearXY": 1,
        "gearSize": 2,
        "gearLook": 3,
        "gearColor": 4,
        "gearAni": 5,
        "gearText": 6,
        "gearIcon": 7,
        "gearDisplay2": 8,
        "gearFontSize": 9
    };

    public static names: Array<string> = ["gearDisplay", "gearXY", "gearSize", "gearLook", "gearColor", "gearAni", "gearText", "gearIcon", "gearDisplay2", "gearFontSize"];
    public static getIndexByName(name: string): number {
        var index: number = this.nameToIndex[name];
        if (index == undefined) {
            return -1;
        }
        return index;
    }
}

export class EaseType {

    public static Linear: number = 0;

    public static SineIn: number = 1;

    public static SineOut: number = 2;

    public static SineInOut: number = 3;

    public static QuadIn: number = 4;

    public static QuadOut: number = 5;

    public static QuadInOut: number = 6;

    public static CubicIn: number = 7;

    public static CubicOut: number = 8;

    public static CubicInOut: number = 9;

    public static QuartIn: number = 10;

    public static QuartOut: number = 11;

    public static QuartInOut: number = 12;

    public static QuintIn: number = 13;

    public static QuintOut: number = 14;

    public static QuintInOut: number = 15;

    public static ExpoIn: number = 16;

    public static ExpoOut: number = 17;

    public static ExpoInOut: number = 18;

    public static CircIn: number = 19;

    public static CircOut: number = 20;

    public static CircInOut: number = 21;

    public static ElasticIn: number = 22;

    public static ElasticOut: number = 23;

    public static ElasticInOut: number = 24;

    public static BackIn: number = 25;

    public static BackOut: number = 26;

    public static BackInOut: number = 27;

    public static BounceIn: number = 28;

    public static BounceOut: number = 29;

    public static BounceInOut: number = 30;

    public static Custom: number = 31;

    private static easeTypeMap: { [key: string]: number } = {
        "Linear": 0,
        "Elastic.In": 22,
        "Elastic.Out": 24,
        "Elastic.InOut": 24,
        "Quad.In": 4,
        "Quad.Out": 5,
        "Quad.InOut": 6,
        "Cube.In": 7,
        "Cube.Out": 8,
        "Cube.InOut": 9,
        "Quart.In": 10,
        "Quart.Out": 11,
        "Quart.InOut": 12,
        "Quint.In": 13,
        "Quint.Out": 14,
        "Quint.InOut": 15,
        "Sine.In": 1,
        "Sine.Out": 2,
        "Sine.InOut": 3,
        "Bounce.In": 28,
        "Bounce.Out": 29,
        "Bounce.InOut": 30,
        "Circ.In": 19,
        "Circ.Out": 20,
        "Circ.InOut": 21,
        "Expo.In": 16,
        "Expo.Out": 17,
        "Expo.InOut": 18,
        "Back.In": 25,
        "Back.Out": 26,
        "Back.InOut": 27
    };

    public static parseEaseType(name: string): number {
        let type: number = EaseType.easeTypeMap[name];
        if (type == undefined) {
            return 5;
        }
        return type;
    }
}

export class CurveType {
    public static CRSpline: number = 0;
    public static Bezier: number = 1;
    public static CubicBezier: number = 2;
    public static Straight: number = 3;
}
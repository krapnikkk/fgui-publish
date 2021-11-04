import ScrollBarDisplayConst from "src/fairygui/gui/ScrollBarDisplayConst";
import UtilsStr from "src/fairygui/utils/UtilsStr";
import IUIProject from "../api/IUIProject";
import Consts from "../Consts";
import SettingsBase from "./SettingsBase";

export default class CommonSettings extends SettingsBase {


    public font: string;

    public fontSize: number;

    public textColor: number;

    public fontAdjustment: boolean;

    public colorScheme: Array<string>;

    public fontSizeScheme: Array<string>;

    public fontScheme: Array<string>;

    public horizontalScrollBar: string;

    public verticalScrollBar: string;

    public defaultScrollBarDisplay: string;

    public tipsRes: string;

    public buttonClickSound: string;

    public pivot: string;

    public constructor(project: IUIProject) {
        super(project);
        this._fileName = "Common";
        this.colorScheme = [];
        this.fontSizeScheme = [];
        this.fontScheme = [];
        this.pivot = "default";
    }

    protected read(param1: { [key: string]: any }): void {
        super.read(param1);
        this.font = param1.font;
        this.fontSize = param1.fontSize;
        this.textColor = UtilsStr.convertFromHtmlColor(param1.textColor);
        if (param1.fontAdjustment != undefined && this._project.isH5) {
            this.fontAdjustment = param1.fontAdjustment;
        }
        else {
            this.fontAdjustment = true;
        }
        if (!this.font) {
            this.font = "_sans";
        }
        if (this.fontSize == 0) {
            this.fontSize = 12;
        }
        this.colorScheme = param1.colorScheme;
        if (!this.colorScheme) {
            this.colorScheme = [Consts.strings.text118 + " #FF0000"];
        }
        this.fontSizeScheme = param1.fontSizeScheme;
        if (!this.fontSizeScheme) {
            this.fontSizeScheme = [Consts.strings.text119 + " 30"];
        }
        this.fontScheme = param1.fontScheme;
        if (!this.fontScheme) {
            this.fontScheme = [Consts.strings.text343];
        }
        var _loc2_: { [key: string]: string } = param1.scrollBars;
        if (_loc2_) {
            this.verticalScrollBar = _loc2_.vertical;
            this.horizontalScrollBar = _loc2_.horizontal;
            this.defaultScrollBarDisplay = _loc2_.defaultDisplay;
            if (!this.defaultScrollBarDisplay) {
                this.defaultScrollBarDisplay = ScrollBarDisplayConst.VISIBLE;
            }
        }
        else {
            this.defaultScrollBarDisplay = ScrollBarDisplayConst.VISIBLE;
        }
        this.tipsRes = param1.tipsRes;
        this.buttonClickSound = param1.buttonClickSound;
        this.pivot = param1.pivot;
        if (!this.pivot) {
            this.pivot = "default";
        }
    }

    protected write(): Object {
        super.write();
        var _loc1_: { [key: string]: any } = {};
        _loc1_.font = this.font;
        _loc1_.fontSize = this.fontSize;
        _loc1_.textColor = UtilsStr.convertToHtmlColor(this.textColor);
        if (!this.fontAdjustment && this._project.isH5) {
            _loc1_.fontAdjustment = this.fontAdjustment;
        }
        _loc1_.colorScheme = this.colorScheme;
        _loc1_.fontSizeScheme = this.fontSizeScheme;
        _loc1_.fontScheme = this.fontScheme;
        var _loc2_: { [key: string]: string } = {};
        _loc1_.scrollBars = _loc2_;
        _loc2_.vertical = this.verticalScrollBar;
        _loc2_.horizontal = this.horizontalScrollBar;
        _loc2_.defaultDisplay = this.defaultScrollBarDisplay;
        _loc1_.tipsRes = this.tipsRes;
        _loc1_.buttonClickSound = this.buttonClickSound;
        _loc1_.pivot = this.pivot;
        this._project.setVar("ColorPresetMenu", undefined);
        this._project.setVar("FontPresetMenu", undefined);
        this._project.setVar("FontSizePresetMenu", undefined);
        return _loc1_;
    }
}


import UtilsStr from "src/fairygui/utils/UtilsStr";
import IUIProject from "../api/IUIProject";
import SettingsBase from "./SettingsBase";

export default class CustomProps extends SettingsBase {


    public all: Object;

    public constructor(project: IUIProject) {
        super(project);
        this._fileName = "CustomProperties";
        this.all = {};
    }

    protected read(param1: Object): void {
        // var _loc3_: Array = null;
        // var _loc4_: String = null;
        // this.all = param1;
        // var _loc2_: String = this.all.my_ubb_tags;
        // if (_loc2_) {
        //     _loc3_ = _loc2_.split(",");
        //     for each(_loc4_ in _loc3_)
        //     {
        //             UBBParser.inst.unrecognizedTags[UtilsStr.trim(_loc4_)] = true;
        //         }
        //  }
    }

    protected write(): Object {
        return this.all;
    }

    // public fillCombo(param1: GComboBox): void {
    //     var _loc4_: any = null;
    //     var _loc2_: Array = param1.items;
    //     var _loc3_: Array = param1.values;
    //     _loc2_.length = 0;
    //     _loc3_.length = 0;
    //     for (_loc4_ in this.all) {
    //         _loc2_.push(_loc4_);
    //         _loc3_.push(_loc4_);
    //     }
    //     param1.items = _loc2_;
    //     param1.values = _loc3_;
    //     param1.visibleItemCount = 20;
    // }
}


import FPackageItem from "src/fairygui/gui/FPackageItem";
import XData from "src/fairygui/utils/XData";

export default class FontSettings {
    public texture:string;
    public read(data: XData): void {
        this.texture = data.getAttribute("texture");
    }

    public write(data: XData): void {
        if (this.texture) {
            data.setAttribute("texture", this.texture);
        }
    }

    public copyFrom(param1: FontSettings): void {
        this.texture = param1.texture;
    }
}


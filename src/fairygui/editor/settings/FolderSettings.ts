import XData from "src/fairygui/utils/XData";

export default class FolderSettings {
    public atlas:string;

    public get empty():boolean {
        return this.atlas == null;
    }

    public read(data: XData): void {
        this.atlas = data.getAttribute("atlas");
    }

    public write(data: XData, param3:boolean): void {
        if (this.atlas != null && !param3) {
            data.setAttribute("atlas", this.atlas);
        }
    }
}

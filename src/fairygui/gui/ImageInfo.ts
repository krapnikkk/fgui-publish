import Rectangle from "../utils/Rectangle";

export default class ImageInfo {


    public targetQuality: number;

    public format: string;

    public file: File;

    public trimmedRect: Rectangle;

    public ImageInfo() {
        this.trimmedRect = new Rectangle();
    }

    public get needConversion(): boolean {
        return this.format == "psd" || this.format == "tga" || this.format == "svg" || this.targetQuality != 100;
    }
}
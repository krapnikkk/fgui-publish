import Rectangle from "src/fairygui/utils/Rectangle";

export default class AniFrame {
    public rect: Rectangle;

    public textureIndex: number;

    public delay: number;

    public constructor() {
        this.rect = new Rectangle();
    }
}
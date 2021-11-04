import NodeRect from "./NodeRect";

export default class Page {
    public outputRects: Array<NodeRect>;

    public remainingRects: Array<NodeRect>;

    public occupancy: Number;

    public width: number;

    public height: number;

    public Page() {
        this.occupancy = 0;
        this.outputRects = [];
    }
}
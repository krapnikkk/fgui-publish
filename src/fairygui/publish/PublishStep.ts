import PublishData from "./PublishData";

export default class PublishStep {
    public _publishData: PublishData;

    public constructor() {
    }

    public set publishData(param1: PublishData) {
        this._publishData = param1;
    }

    public get publishData(): PublishData {
        return this._publishData;
    }

    public run(): void {
    }
}
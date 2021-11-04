export default class ComProperty {


    public target: string;

    public propertyId: number;

    public label: string;

    public value: any;

    public constructor(param1: string = null, param2: number = 0, param3: string = null, param4: any = undefined) {
        this.target = param1;
        this.propertyId = param2;
        this.label = param3;
        this.value = param4;
    }

    public copyFrom(param1: ComProperty): void {
        this.target = param1.target;
        this.propertyId = param1.propertyId;
        this.label = param1.label;
        this.value = param1.value;
    }
}


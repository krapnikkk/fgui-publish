export default class Rectangle {
    public x: number;
    public y: number;
    public width: number;
    public height: number;
    private _empty:boolean = false;
    public clone(): Rectangle {
        return new Rectangle();
    }

    public isEmpty():boolean {
        return this._empty;
    }

    public setEmpty() {
        this._empty = false;
    }

    public copyFrom(){
        console.warn("todo");
    }
}
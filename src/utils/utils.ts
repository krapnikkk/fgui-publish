import ProjectType from "src/fairygui/editor/api/ProjectType";

export const isH5 = (type: ProjectType): boolean => {
    return type == ProjectType.EGRET ||
        type == ProjectType.LAYABOX ||
        type == ProjectType.PIXI ||
        type == ProjectType.COCOSCREATOR;
}

export const convertFromHtmlColor = (color: string, alpha: boolean = false): number => {
    if (color == null || color.length < 1 || color.charAt(0) != "#") {
        return 0;
    }
    if (color.length == 9) {
        return (parseInt(color.substr(1, 2), 16) << 24) + parseInt(color.substr(3), 16);
    }
    if (alpha) {
        return 4278190080 + parseInt(color.substr(1), 16);
    }
    return parseInt(color.substr(1), 16);
}
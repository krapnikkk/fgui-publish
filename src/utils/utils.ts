import ProjectType from "src/fairygui/editor/api/ProjectType";

export const isH5 = (type: ProjectType): boolean => {
    return type == ProjectType.EGRET ||
        type == ProjectType.LAYABOX ||
        type == ProjectType.PIXI ||
        type == ProjectType.COCOSCREATOR;
}
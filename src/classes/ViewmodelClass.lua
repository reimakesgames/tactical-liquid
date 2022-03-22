local AnimatorClass = require(script.Parent.AnimatorClass)

local class = {}

export type Class = {
    Viewmodel: Model;
    Animator: AnimatorClass.Class;
}

return class
import joi from "joi";
import { idValidation } from "../../utils/customValidation.js";

export const createCategorySchema = {
    body: joi.object({
        name: joi.string().min(3).max(20).required(),
    })
}

export const updateCategorySchema = {
    body: joi.object({
        name: joi.string().min(3).max(20).optional(),
    }),

    params: joi.object({
        categoryId: joi.string().custom(idValidation).required(),
    })
}


export const deleteCategorySchema = {
    params: joi.object({
        categoryId: joi.string().custom(idValidation).required(),
    })
}
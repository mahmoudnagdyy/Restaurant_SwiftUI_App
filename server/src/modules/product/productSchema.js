import joi from "joi";
import { idValidation } from "../../utils/customValidation.js";

export const createProductSchema = {
    body: joi.object({
        name: joi.string().min(3).max(30).required(),
        price: joi.number().greater(0).required(),
        description: joi.string().min(3).max(500).required(),
        categoryId: joi.string().custom(idValidation).required(),
    }),
};

export const updateProductSchema = {
    body: joi.object({
        name: joi.string().min(3).max(30).optional(),
        price: joi.number().min(0).optional(),
        description: joi.string().min(3).max(500).optional(),
        categoryId: joi.string().custom(idValidation).optional(),
    }),

    params: joi.object({
        productId: joi.string().custom(idValidation).required(),
    })
}

export const getProductsSchema = {
    params: joi.object({
        categoryId: joi.string().custom(idValidation).required(),
    })
}

export const deleteProductSchema = {
    params: joi.object({
        productId: joi.string().custom(idValidation).required(),
    })
}
import joi from "joi";

export const createOfferSchema = {

    body: joi.object({
        title: joi.string().min(3).max(100).required(),
        description: joi.string().min(10).max(500).required(),
        type: joi.string().valid("product", "bundle", "free_delivery").required(),
        products: joi.array().items(joi.string().length(24)).required(),
        discountType: joi.string().valid("percentage", "fixed").when("type", {
            is: joi.not("free_delivery"),
            then: joi.required()
        }),
        discountValue: joi.number().min(0).max(100).when("type", {
            is: joi.not("free_delivery"),
            then: joi.required()
        }),
        startDate: joi.date().greater("now").required(),
        endDate: joi.date().greater(joi.ref("startDate")).required()
    })

}

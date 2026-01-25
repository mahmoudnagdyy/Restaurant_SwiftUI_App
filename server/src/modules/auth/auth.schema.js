import joi from "joi";
import {idValidation} from '../../utils/customValidation.js'


export const signupSchema = {

    body: joi.object({
        name: joi.string().min(3).max(20).required(),
        email: joi.string().email().required(),
        password: joi.string().min(6).required(),
        phone: joi.string().length(11).pattern(new RegExp("^[0-9]{11}$")).required()
    })

}


export const verifySchema = {
    body: joi.object({
        userId: joi.string().custom(idValidation).required(),
        verificationCode: joi.string().length(6).required(),
    }),
}; 


export const loginSchema = {

    body: joi.object({
        email: joi.string().email().required(),
        password: joi.string().required(),
    })

}
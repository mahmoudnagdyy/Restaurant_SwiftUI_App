import { Types } from "mongoose"



export const idValidation = (value, helpers) => {
    return Types.ObjectId.isValid(value) ? value : helpers.message("In-valid id format")
}
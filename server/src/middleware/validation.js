import joi from "joi"


const dataMethods = ['body', 'params', 'query', "headers", "file", "files"]


export const validationMiddleware = (schema) => {
    return (req, res, next) => {
        const validationResult = []

        for (const key of dataMethods) {
            if(schema[key]) {
                const result = schema[key].validate(req[key], { abortEarly: false})
                
                if (result.error) {
                    for (const err of result.error.details) {
                        validationResult.push(err.path[0])
                    }
                }
            }
        }
        
        if (validationResult.length) {
            req.validationResult = validationResult
            next(new Error("Validation Error"))
        }

        next()
    }
}


export const asyncHandler = (fn) => {
    return (req, res, next) => {
        fn(req, res, next).catch((err) => {
            console.log(err);
            next(new Error(err))
        })
    }
}


export const globalErrorHandler = (err, req, res, next) => {
    if (req.validationResult) {
        return res.send({ message: err.message, validationErrors: req.validationResult })
    }
    return res.send({message: err.message, errstack: err.stack})
}
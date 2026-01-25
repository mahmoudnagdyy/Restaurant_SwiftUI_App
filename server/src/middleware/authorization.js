import userModel from '../../DB/models/User.model.js'
import {verifyToken} from '../utils/generateToken.js'


export const auth = (roles = []) => {
    return async (req, res, next) => {
        const {authorization} = req.headers

        if (!authorization.startsWith("marmoush__")) {
            next(new Error("In-valid token"))
        }

        const token = authorization.split("marmoush__")[1]
        const userId = verifyToken({token, signature: process.env.LOGIN_TOKEN_SIGNATURE})

        // authentication
        const checkUser = await userModel.findById(userId)
        if (!checkUser) {
            next(new Error("user not found"))
        }

        req.user = checkUser

        // authorization
        if (!roles.length) {
            return next(new Error("api roles are required"))
        }

        if(!roles.includes(checkUser.role)) {
            return next(new Error("you are not authorized"))
        }

        next()
    }
}
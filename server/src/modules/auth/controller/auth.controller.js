import { asyncHandler } from "../../../utils/errorHandler.js";
import userModel from '../../../../DB/models/User.model.js'
import {generateVerificationCode} from '../../../utils/verificationCode.js'
import {sendEmail} from '../../../utils/sendEmail.js'
import {generateToken} from '../../../utils/generateToken.js'
import bcrypt from 'bcryptjs'


export const signup = asyncHandler(
    async (req, res, next) => {
        const {name, email, password, phone} = req.body
        
        const checkUser = await userModel.findOne({email})
        if(checkUser) {
            return next(new Error("email already exists"))
        }

        const verificationCode = generateVerificationCode()

        sendEmail({
            to: email,
            subject: "Email Verification",
            text: `Your verification code is: ${verificationCode}`
        })

        const newUser = new userModel({name, email, password, phone, verificationCode})
        await newUser.save()
        return res.send({message: "done", userId: newUser._id})
    }
)


export const verifyEmail = asyncHandler(
    async (req, res, next) => {
        const {userId, verificationCode} = req.body
        
        const checkUser = await userModel.findById(userId)
        if(!checkUser) {
            return next(new Error("user not found"))
        }

        if(checkUser.isVerified) {
            return next(new Error("user already verified"))
        }

        if(checkUser.verificationCode != verificationCode) {
            return next(new Error("Wrong verification code"))
        }

        await userModel.updateOne({_id: userId}, {isVerified: true, verificationCode: null})

        sendEmail({
            to: checkUser.email,
            subject: "Email Verified",
            text: `Your email has been successfully verified.`
        })

        return res.send({message: "done"})
    }
)


export const resendCode = asyncHandler(
    async (req, res, next) => {
        const {email} = req.body

        const checkUser = await userModel.findOne({email})
        if(!checkUser){
            return next(new Error("user not found"))
        }

        if(checkUser.isVerified){
            return next(new Error("user already verified"))
        }

        const verificationCode = generateVerificationCode()

        sendEmail({
            to: email,
            subject: "Email Verification",
            text: `Your verification code is: ${verificationCode}`
        })

        await userModel.updateOne({_id: checkUser._id}, {verificationCode})

        return res.send({message: "verification code sent", userId: checkUser._id})
    }
)


export const login = asyncHandler(
    async (req, res, next) => {
        const {email, password} = req.body

        const checkUser = await userModel.findOne({email})
        if(!checkUser){
            return next(new Error("user not found"))
        }

        const checkPassword = bcrypt.compareSync(password, checkUser.password)
        if(!checkPassword){
            return next(new Error("wrong password"))
        }

        if(!checkUser.isVerified){
            return next(new Error("Email is not verified"))
        }

        const token = generateToken({
            payload: {id: checkUser._id}, 
            signature: process.env.LOGIN_TOKEN_SIGNATURE
        })

        return res.send({message: "done", token})
    }
)
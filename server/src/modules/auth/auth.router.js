import { Router } from "express";
import * as authController from "./controller/auth.controller.js";
import { validationMiddleware } from "../../middleware/validation.js";
import * as authSchemas from "./auth.schema.js";


const router = Router()

router.post("/signup", validationMiddleware(authSchemas.signupSchema), authController.signup)

router.put("/verify", validationMiddleware(authSchemas.verifySchema), authController.verifyEmail)

router.patch("/resendCode", authController.resendCode)

router.post("/login", validationMiddleware(authSchemas.loginSchema), authController.login)

export default router;
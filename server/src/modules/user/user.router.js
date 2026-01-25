import { Router } from "express";
import { auth } from "../../middleware/authorization.js";
import {userRoles} from './userRoles.js'
import * as userController from './controller/user.controller.js'
import { multerSetup } from "../../utils/multer.js";
import {allFilesExtensions} from '../../utils/allExtensions.js'


const router = Router()

router.get(
    "/",
    auth(userRoles.getUser),
    userController.getUser
)

router.put(
    "/",
    auth(userRoles.uploadPhoto),
    multerSetup(allFilesExtensions.image).single("image"),
    userController.uploadPhoto,
);




export default router
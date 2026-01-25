import { Router } from "express";
import * as categoryController from "./controller/category.controller.js";
import {auth} from '../../middleware/authorization.js'
import { categoryRoles } from "./categoryRoles.js";
import { validationMiddleware } from "../../middleware/validation.js";
import * as categorySchemas from "./categorySchema.js";
import {multerSetup} from '../../utils/multer.js'
import {allFilesExtensions} from '../../utils/allExtensions.js'

const router = Router()

router.post(
    "/", 
    auth(categoryRoles.createCategoryApi), 
    multerSetup(allFilesExtensions.image).single("image"),
    validationMiddleware(categorySchemas.createCategorySchema),
    categoryController.createCategory
)

router.get("/", 
    auth(categoryRoles.getAllCategoriesApi), 
    categoryController.getAllCategories
)

router.delete("/:categoryId", 
    auth(categoryRoles.deleteCategoryApi), 
    validationMiddleware(categorySchemas.deleteCategorySchema),
    categoryController.deleteCategory
)





export default router;
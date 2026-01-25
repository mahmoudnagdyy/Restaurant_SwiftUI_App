import { Router } from "express";
import { auth } from "../../middleware/authorization.js";
import {productRoles} from './productRoles.js'
import { validationMiddleware } from "../../middleware/validation.js";
import * as productController from './controller/product.controller.js'
import * as productSchemas from './productSchema.js'
import { multerSetup } from "../../utils/multer.js";
import { allFilesExtensions } from "../../utils/allExtensions.js";

const router = Router()


router.post(
    "/",
    auth(productRoles.createProduct),
    multerSetup(allFilesExtensions.image).single('image'),
    validationMiddleware(productSchemas.createProductSchema),
    productController.createProduct
)


router.put(
    "/:productId",
    auth(productRoles.updateProduct),
    multerSetup(allFilesExtensions.image).single('image'),
    validationMiddleware(productSchemas.updateProductSchema),
    productController.updateProduct
)

router.get(
    "/:categoryId",
    auth(productRoles.getProducts),
    validationMiddleware(productSchemas.getProductsSchema),
    productController.getProducts
)

router.delete(
    "/:productId",
    auth(productRoles.deleteProduct),
    validationMiddleware(productSchemas.deleteProductSchema),
    productController.deleteProduct
)





export default router;
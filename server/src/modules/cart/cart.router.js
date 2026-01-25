import { Router } from "express";
import { auth } from "../../middleware/authorization.js";
import * as cartController from "./controller/cart.controller.js";
import {cartRoles} from './cartRoles.js'

const router = Router()

router.post(
    "/:productId",
    auth(cartRoles.addToCart),
    cartController.addToCart
)

router.get(
    "/",
    auth(cartRoles.getCart),
    cartController.getCart
)

router.patch(
    "/:cartId",
    auth(cartRoles.updateCart),
    cartController.updateCart
)


router.delete(
    "/:cartId",
    auth(cartRoles.removeFromCart),
    cartController.removeFromCart
)








export default router
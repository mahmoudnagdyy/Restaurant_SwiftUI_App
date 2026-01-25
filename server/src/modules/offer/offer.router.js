import { Router } from "express";
import { auth } from "../../middleware/authorization.js";
import {offerRoles} from './offerRoles.js'
import * as offerController from './controller/offer.controller.js'
import { validationMiddleware } from "../../middleware/validation.js";
import * as offerSchemas from './offerSchema.js'

const router = Router()


router.post(
    "/", 
    auth(offerRoles.createOffer),
    validationMiddleware(offerSchemas.createOfferSchema),
    offerController.createOffer
)

router.get(
    "/",
    auth(offerRoles.getOffers),
    offerController.getOffers
)

router.delete(
    "/:offerId",
    auth(offerRoles.deleteOffer),
    offerController.deleteOffer
)



export default router;
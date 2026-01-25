import { appRoles } from "../../utils/appRoles.js";


export const offerRoles = {
    createOffer: [appRoles.admin],
    updateOffer: [appRoles.admin],
    deleteOffer: [appRoles.admin],
    getOffers: [appRoles.admin, appRoles.user]
}
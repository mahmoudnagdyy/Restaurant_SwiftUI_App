import { appRoles } from "../../utils/appRoles.js";



export const cartRoles = {
    addToCart: [appRoles.user, appRoles.admin],
    removeFromCart: [appRoles.user, appRoles.admin],
    getCart: [appRoles.user, appRoles.admin],
    updateCart: [appRoles.user, appRoles.admin],
};
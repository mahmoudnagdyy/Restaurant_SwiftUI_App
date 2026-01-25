import { appRoles } from "../../utils/appRoles.js";


export const productRoles = {
    createProduct: [appRoles.admin],
    updateProduct: [appRoles.admin],
    deleteProduct: [appRoles.admin],
    getProducts: [appRoles.admin, appRoles.user]
}
import { appRoles } from "../../utils/appRoles.js";


export const userRoles = {
    getUser: [appRoles.admin, appRoles.user],
    uploadPhoto: [appRoles.admin, appRoles.user]
}
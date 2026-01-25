import { appRoles } from "../../utils/appRoles.js";


export const categoryRoles = {
    createCategoryApi: [appRoles.admin],
    updateCategoryApi: [appRoles.admin],
    getAllCategoriesApi: [appRoles.admin, appRoles.user],
    deleteCategoryApi: [appRoles.admin],
};
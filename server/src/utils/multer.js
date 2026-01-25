import {v2 as cloudinary} from 'cloudinary'
import multer from 'multer'

cloudinary.config({
    cloud_name: "ddbxrwwmz",
    api_key: "797827295144815",
    api_secret: "AatKcubDyFThFk_I_lIixiIF81s",
});


const multerSetup = (fileExtensions = []) => {
    const storage = multer.diskStorage({});

    function fileFilter(req, file, cb) {
        if (!fileExtensions.includes(file.mimetype)) {
            cb(new Error("Invalid file type"), false);
        } 
        return cb(null, true);
    }

    const upload = multer({ storage: storage, fileFilter });
    return upload
}



export {
    cloudinary,
    multerSetup
}
import userModel from "../../../../DB/models/User.model.js";
import { asyncHandler } from "../../../utils/errorHandler.js";
import { cloudinary } from "../../../utils/multer.js";




export const getUser = asyncHandler(
    async (req, res, next) => {
        const user = req.user
        return res.send({message: "done", user})
    }
)

export const uploadPhoto = asyncHandler(
    async (req, res, next) => {
         
        const user = req.user

        if(user.profileImage.public_id != null) {
            await cloudinary.uploader.destroy(user.profileImage.public_id)
        }

        const { public_id, secure_url } = await cloudinary.uploader.upload(
            req.file.path,
            {
                folder: `Restaurant/users/${user._id}`,
            },
        );

        const savedUser = await userModel.findByIdAndUpdate(
            user._id,
            { profileImage: { public_id, secure_url } },
            { new: true },
        );
        
        return res.send({message: "done", user: savedUser})
    }
)
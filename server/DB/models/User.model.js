import { Schema, model } from "mongoose";
import bcrypt from "bcryptjs";
import { appRoles } from "../../src/utils/appRoles.js";

const userSchema = new Schema(
    {
        name: {
            type: String,
            required: true,
            lowercase: true
        },

        email: {
            type: String,
            required: true,
            unique: true,
            lowercase: true
        },

        password: {
            type: String,
            required: true
        },

        phone: {
            type: String,
            required: true
        },

        profileImage: {
            public_id: {
                type: String
            },
            secure_url: {
                type: String
            }
        },

        role: {
            type: String,
            enum: [appRoles.user, appRoles.admin],
            default: appRoles.admin
        },

        isVerified: {
            type: Boolean,
            default: false
        },

        verificationCode: String
    },
    {
        timestamps: true
    }
)
.pre("save", function () {
    this.password = bcrypt.hashSync(this.password, +process.env.SALT_ROUNDS)
})

const userModel = model("User", userSchema)
export default userModel
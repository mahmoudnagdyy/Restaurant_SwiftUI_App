import { Schema, model } from "mongoose";

const productSchema = new Schema(
    {
        name: {
            type: String,
            required: true,
            unique: true,
            lowercase: true,
        },

        description: {
            type: String,
        },

        price: {
            type: Number,
            required: true,
        },

        image: {
            public_id: {
                type: String,
                required: true,
            },
            secure_url: {
                type: String,
                required: true,
            },
        },

        categoryId: {
            type: Schema.Types.ObjectId,
            ref: "Category",
            required: true,
        },

        isAvailable: {
            type: Boolean,
            default: true,
        },

        totalOrders: {
            type: Number,
            default: 0,
        },

        customId: String,
    },
    { timestamps: true }
);

const productModel = model("Product", productSchema)
export default productModel
import { Schema, model } from "mongoose";

const cartSchema = new Schema(
    {
        user: {
            type: Schema.Types.ObjectId,
            ref: "User",
            required: true,
        },

        items: [
            {
                product: {
                    type: Schema.Types.ObjectId,
                    ref: "Product",
                },
                quantity: Number,
            },
        ],

        totalPrice: {
            type: Number,
            required: true,
            default: 0
        }
    },
    { timestamps: true }
)

const cartModel = model("Cart", cartSchema)
export default cartModel
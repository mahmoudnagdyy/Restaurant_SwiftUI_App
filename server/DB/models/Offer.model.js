import { Schema, model } from "mongoose";

const offerSchema = new Schema(
    {
        title: {
            type: String,
            required: true,
            unique: true,
            lowercase: true
        },
        description: {
            type: String,
            required: true
        },

        type: {
            type: String,
            enum: [
                "product",        // منتج واحد
                "bundle",         // أكتر من منتج
                "free_delivery"   // دليفري ببلاش
            ],
            required: true
        },

        products: [
            {
                type: Schema.Types.ObjectId,
                ref: "Product"
            }
        ],

        discountType: {
            type: String,
            enum: ["percentage", "fixed"],
            required: function () {
                return this.type !== "free_delivery";
            }
        },

        discountValue: {
            type: Number,
            required: function () {
                return this.type !== "free_delivery";
            }
        },

        startDate: {
            type: Date,
            required: true
        },
        endDate: {
            type: Date,
            required: true
        },

        isActive: {
            type: Boolean,
            default: true
        }
    },
    { timestamps: true }
)

const offerModel = model("Offer", offerSchema);
export default offerModel;
    
import moment from 'moment';
import offerModel from '../../../../DB/models/Offer.model.js'
import { asyncHandler } from '../../../utils/errorHandler.js'


export const createOffer = asyncHandler(
    async (req, res, next) => {
        const {
            title,
            description,
            type,
            products,
            discountType,
            discountValue,
            startDate,
            endDate
        } = req.body;

        const checkOffer = await offerModel.findOne({title})
        if (checkOffer) {
            return next(new Error("Offer already exists"))
        }

        if(moment(startDate).isAfter(moment(endDate)) || moment(startDate).isSame(moment(endDate))) {
            return next(new Error("Invalid offer dates"))
        }
        
        await offerModel.create({
            title,
            description,
            type,
            products,
            discountType,
            discountValue,
            startDate,
            endDate,
        });
        return res.json({ message: "Offer created successfully" })
    }
)


export const getOffers = asyncHandler(
    async (req, res, next) => {
        const offers = await offerModel.find().populate("products");
        return res.json({ offers });
    }
)

export const deleteOffer = asyncHandler(
    async (req, res, next) => {
        const { offerId } = req.params;

        const checkOffer = await offerModel.findById(offerId);
        if (!checkOffer) {
            return next(new Error("Offer not found"));
        }

        await offerModel.deleteOne({ _id: offerId });
        return res.json({ message: "Offer deleted successfully" });
    }
)
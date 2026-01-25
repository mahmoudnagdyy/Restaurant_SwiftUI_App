import { nanoid } from 'nanoid'
import productModel from '../../../../DB/models/Product.model.js'
import { asyncHandler } from '../../../utils/errorHandler.js'
import categoryModel from '../../../../DB/models/Category.model.js'
import { cloudinary } from '../../../utils/multer.js'


export const createProduct = asyncHandler(
    async (req, res, next) => {
        const { name, categoryId, price, description } = req.body
        
        if(!req.file){
            return next(new Error("image is required"))
        }

        const checkCategory = await categoryModel.findById(categoryId)
        if (!checkCategory) {
            return next(new Error("category not found"))
        }

        const checkProduct = await productModel.findOne({ name })
        if (checkProduct) {
            return next(new Error("product already exists"))
        }

        const customId = nanoid(5)

        const {public_id, secure_url} = await cloudinary.uploader.upload(req.file.path, {
            folder: `Restaurant/Categories/${checkCategory.customId}/products/${customId}`
        })

        const image = { public_id, secure_url }

        const product = await productModel.create({
            name,
            categoryId,
            price,
            description,
            image,
            customId
        })

        if(!product){
            await cloudinary.uploader.destroy(image.public_id)
            return next(new Error("failed to create product"))
        }

        console.log(product);
        

        return res.json({ message: "product created successfully" })
    }
)

export const updateProduct = asyncHandler(
    async (req, res, next) => {
        const { productId } = req.params
        const { name, categoryId, price, description } = req.body

        const product = await productModel.findById(productId).populate('categoryId')
        if (!product) {
            return next(new Error("product not found"));
        }

        if(name) {
            const checkProduct = await productModel.findOne({ name })
            if(checkProduct) {
                return next(new Error("product already exists with this name"))
            }
            product.name = name
        }

        if(categoryId) {
            const checkCategory = await categoryModel.findById(categoryId)
            if(!checkCategory) {
                return next(new Error("category not found"))
            }
            product.categoryId = categoryId
        }

        if(price) {
            if (product.price == price) {
                return next(new Error("please change the price to update"))
            }
            else if (price <= 0) {
                return next(new Error("price must be greater than zero"))
            }
            product.price = price
        }

        if(description) {
            product.description = description
        }

        if(req.file){
            // delete old image
            await cloudinary.uploader.destroy(product.image.public_id)
            // upload new image
            const {public_id, secure_url} = await cloudinary.uploader.upload(req.file.path, {
                folder: `Restaurant/Categories/${product.categoryId.customId}/products/${product.customId}`
            })
            product.image = { public_id, secure_url }
        }

        await product.save()
        return res.json({ message: "product updated successfully" })
    }
)

export const getProducts = asyncHandler(
    async (req, res, next) => {
        const { categoryId } = req.params
        const products = await productModel.find({ categoryId })
        return res.json(products);
    }
)

export const deleteProduct = asyncHandler(
    async (req, res, next) => {
        const { productId } = req.params
        const checkProduct = await productModel.findById(productId)
        if (!checkProduct) {
            return next(new Error("product not found"))
        }

        // delete image from cloudinary
        await cloudinary.uploader.destroy(checkProduct.image.public_id)
        
        // delete product from DB
        await productModel.deleteOne({ _id: productId })

        return res.json({ message: "product deleted successfully" })
    }
)
import { nanoid } from 'nanoid'
import categoryModel from '../../../../DB/models/Category.model.js'
import { asyncHandler } from '../../../utils/errorHandler.js'
import { cloudinary } from '../../../utils/multer.js'
import productModel from '../../../../DB/models/Product.model.js'
import cartModel from '../../../../DB/models/Cart.model.js'



export const createCategory = asyncHandler(
    async (req, res, next) => {
        const {name} = req.body

        if (!req.file) {
            return next(new Error("Image is required"))
        }

        const checkCategory = await categoryModel.findOne({name})
        if (checkCategory) {
            return next(new Error("Category already exists"))
        }

        const customId = nanoid(5)

        const { public_id, secure_url } = await cloudinary.uploader.upload(
            req.file.path,
            {
                folder: `Restaurant/Categories/${customId}`,
            }
        );

        const image = { public_id, secure_url };
        
        const category = await categoryModel.create({ name, image, customId });
        
        if (!category) {
            cloudinary.uploader.destroy(public_id)
            cloudinary.api.delete_folder(`Restaurant/Categories/${customId}`);
            return next(new Error("Failed to create category"))
        }
        return res.send({ message: "Category created successfully", category })
    }
)


export const getAllCategories = asyncHandler(
    async (req, res, next) => {
        const categories = await categoryModel.find().populate('products')
        return res.send(categories) 
    }
)


export const deleteCategory = asyncHandler(
    async (req, res, next) => {
        const { categoryId } = req.params        

        const checkCategory = await categoryModel.findById(categoryId)
        if (!checkCategory) {
            return next(new Error("Category not found"))
        }

        const cart = await cartModel.findOne({user: req.user._id})
        const categoryProducts = await productModel.find({categoryId})

        console.log(categoryProducts);
        

        let productsIds = categoryProducts.map((p) => p._id.toString())

        console.log(productsIds);
        
        
        cart.items = cart.items.filter((item) => {
            return !productsIds.includes(item.product.toString())
        })

        console.log(cart.items);
        

        let totalPrice = 0
        for (const item of cart.items) {
            const product = await productModel.findById(item.product)
            totalPrice += (product.price * item.quantity)
        }

        cart.totalPrice = totalPrice
        
        await cart.save()

        await productModel.deleteMany({categoryId: categoryId})

        await cloudinary.uploader.destroy(checkCategory.image.public_id)
        cloudinary.api.delete_folder(`Restaurant/Categories/${checkCategory.customId}`)

        await categoryModel.deleteOne({_id: categoryId})
        return res.send({ message: "Category deleted successfully" })
    } 
)
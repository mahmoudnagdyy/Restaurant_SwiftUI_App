import cartModel from '../../../../DB/models/Cart.model.js'
import productModel from '../../../../DB/models/Product.model.js'
import { asyncHandler } from '../../../utils/errorHandler.js'


export const addToCart = asyncHandler(
    async (req, res, next) => {
        const { productId } = req.params
        const userId = req.user._id

        const checkCart = await cartModel.findOne({ user: userId }).populate("items.product")

        console.log(checkCart);
        

        // not have cart
        if(!checkCart) {
            const product = await productModel.findById(productId)
            let totalPrice = product.price            
            await cartModel.create({user: userId, items: [{product: productId, quantity: 1}], totalPrice})
            return res.json({message: "Added to cart"})
        }

        // have cart
        const productIndex = checkCart.items.findIndex((item) => {
            return item.product._id.toString() == productId 
        }) 
        
        // product exists in cart
        if(productIndex > -1){
            checkCart.items[productIndex].quantity += 1 
            let totalPrice = 0; 
            for (const item of checkCart.items) {
                totalPrice += item.product.price * item.quantity;
            }
            checkCart.totalPrice = totalPrice
            await checkCart.save()
            return res.send({message: "quantity Added"})
        }

        // product not in cart
        let items = checkCart.items
        items.push({
            product: productId,
            quantity: 1
        }); 

        let totalPrice = 0
        for (const item of items) {
            if(item.product.price) {
                totalPrice += (item.product.price * item.quantity)
            }
            else{
                const product = await productModel.findById(productId)
                totalPrice += (product.price * item.quantity);
            }
        }
        
        await cartModel.updateOne({user: userId}, {items, totalPrice})
        return res.send({message: "Add to cart"})
    }
)


export const getCart = asyncHandler(
    async (req, res, next) => {
        const cart = await cartModel.findOne({user: req.user._id}).populate("items.product")                
        return res.send({message: "cart", cart})
    } 
)

export const updateCart = asyncHandler(
    async (req, res, next) => {
        const {cartId} = req.params
        const {productId, quantity} = req.body   

        const checkCart = await cartModel.findOne({user: req.user._id, _id: cartId})
        if(!checkCart) {
            return next(new Error("cart not found"))
        }

        const productIndex = checkCart.items.findIndex((item) => {
            return item.product == productId
        })

        if(quantity <= 0) {
            const product = await productModel.findById(productId);
            checkCart.totalPrice -= product.price
            checkCart.items.splice(productIndex, 1)
            await checkCart.save()
            return res.send({message: "item deleted from cart"})
        }
        
        checkCart.items[productIndex].quantity = quantity

        let totalPrice = 0
        for (const item of checkCart.items) {
            const product = await productModel.findById(item.product)
            totalPrice += (product.price * item.quantity)
        }

        checkCart.totalPrice = totalPrice

        await checkCart.save()
        return res.send({message: "quantity updated"})
    }
)

export const removeFromCart = asyncHandler(
    async (req, res, next) => {
        const {cartId} = req.params
        const {productId} = req.body

        const checkCart = await cartModel.findOne({_id: cartId, user: req.user._id})
        if(!checkCart) {
            return next(new Error("cart not exist"))
        }

        let productIndex = checkCart.items.findIndex((item) => {
            return item.product == productId
        })

        if(productIndex == -1) {
            return next(new Error("product not exist in cart"))
        }

        checkCart.items.splice(productIndex, 1)
        await checkCart.save()
        return res.send({message: "item deleted from cart"})
    }
)
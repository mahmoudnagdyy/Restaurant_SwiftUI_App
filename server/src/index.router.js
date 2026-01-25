import { connectDB } from "../DB/connection.js"
import { globalErrorHandler } from "./utils/errorHandler.js"
import authRouter from './modules/auth/auth.router.js'
import categoryRouter from './modules/category/category.router.js'
import productRouter from './modules/product/product.router.js'
import offerRouter from './modules/offer/offer.router.js'
import cartRouter from './modules/cart/cart.router.js'
import userRouter from './modules/user/user.router.js'



export const bootstrap = (app, express) => {

    app.use(express.json())
    
    app.use("/auth", authRouter)
    app.use("/user", userRouter)
    app.use("/category", categoryRouter)
    app.use("/product", productRouter)
    app.use("/offer", offerRouter)
    app.use("/cart", cartRouter)
    

    app.use(globalErrorHandler)

    connectDB()

}
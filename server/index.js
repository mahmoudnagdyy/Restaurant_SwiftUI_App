import express from 'express'
import dotenv from 'dotenv'
import { bootstrap } from './src/index.router.js'
dotenv.config()

const app = express()

app.get("/", (req, res, next) => {
    return res.send("server is on")
})

bootstrap(app, express)

app.listen(process.env.PORT, () => {
    console.log(`Server is running on port ... ${process.env.PORT}`);
})
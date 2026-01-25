import { customAlphabet } from "nanoid"


export const generateVerificationCode = () => {
    return customAlphabet("1234567890", 6)()
}
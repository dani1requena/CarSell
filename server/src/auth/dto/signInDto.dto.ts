import { IsString, MinLength } from 'class-validator'
import { AuthBody } from '../auth.interface'

export class signInDto implements AuthBody{
    @IsString()
    @MinLength(3)
    username: string
    @IsString()
    password: string
}
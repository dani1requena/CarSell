import { IsOptional, IsString, Length, MinLength } from 'class-validator'

export class createUserDto{
    @IsString()
    @MinLength(3)
    username: string
    @IsString()
    password: string
    @IsString()
    email: string
}

export class updateUserDto{
    @IsOptional()
    @IsString()
    username?: string
    @Length(1, 40)
    @IsOptional()
    password?: string
    @IsOptional()
    @IsString()
    email?: string
}
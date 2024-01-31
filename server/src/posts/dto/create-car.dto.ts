import { IsNotEmpty, IsNumber, IsOptional, IsPositive, IsString, Length, MinLength } from "class-validator"

export class createCarDto{
    @IsString()
    photo?: string;
    @IsString()
    @IsNotEmpty()
    @MinLength(3)
    brand: string;
    @IsPositive()
    kilometer: number;
    @IsPositive()
    horsepower: number;
    //@IsPositive()
    @IsNotEmpty()
    authorId: number;
    @IsString()
    description: string;
}

export class updateCarDto{
    @IsOptional()
    @IsString()
    photo?: string;
    @Length(1, 40)
    @IsOptional()
    brand?: string;
    @IsNumber()
    @IsOptional()
    kilometer?: number;
    @IsNumber()
    @IsOptional()
    horsepower?: number;
    @IsNotEmpty()
    authorId: number;
    @IsString()
    @IsOptional()
    description?: string;
}

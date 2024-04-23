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
    @IsString()
    description: string;
    @IsNumber()
    userId: number;
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
    @IsString()
    @IsOptional()
    description?: string;
}

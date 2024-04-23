import { Body, Controller, Delete, Get, HttpException, Param, ParseIntPipe, Patch, Post, Req, Res, UploadedFile, UseInterceptors} from "@nestjs/common";
import { createCarDto, updateCarDto } from "./dto/create-Car.dto";
import { CarService } from "./Car.service";
import { FileInterceptor } from "@nestjs/platform-express";
import * as multer from 'multer';
const path = require("path");
import * as fs from 'fs';
const express = require('express');
import { Request } from "express";

@Controller('cars')
export class CarController{
    
    constructor(private CarsService:CarService){}
    
    @Get('/images/:imageName') 
    getImage(@Param('imageName') imageName: string, @Res() res): any{ 
        const imagePath = path.join(process.cwd(), '../server/images/', imageName);
        res.sendFile(imagePath);
    }

    @Get()
    getCars(){
        return this.CarsService.getCars()
    }
    
    @Post()
    @UseInterceptors(FileInterceptor('photo', {
        storage: multer.diskStorage({
          destination: (req, file, cb) => {
            const destinationPath = path.join(process.cwd(), 'images');
            if (!fs.existsSync(destinationPath)) {
              fs.mkdirSync(destinationPath, { recursive: true });
            }
            console.log('Carpeta de destino:', destinationPath);
            cb(null, destinationPath); 
          },
          filename: (req, file, cb) => {
            const newFilename = Date.now() + '-' + file.originalname;
            cb(null, newFilename); 
          },
        }),
    }))
    async createCar(@Body() car: createCarDto, @UploadedFile() photo: Express.Multer.File) {
        console.log("Valor de userId en la sesión:", car.userId);
        try{
            const userId = car.userId;
            console.log("Id del usuario en controller: ", userId);
            if (photo) {
                const imagenReferencia = photo.filename;
                car.photo= imagenReferencia;
                const createdCar = await this.CarsService.createCar(car, userId);
                return { message: 'Coche creado correctamente', car: createdCar };
            } else {
                return { message: 'No se proporcionó una imagen válida' };
            }
        }catch(error){
            throw error;
        }
    }
    
    // @Get(':id')
    // getCarById(@Param('id', ParseIntPipe) id:number){
    //     return this.CarsService.getCar(id);
    // }

    @Delete(':id')
    deleteCar(@Param('id', ParseIntPipe) id: number){
        return this.CarsService.deleteCar(id)
    }

    @Patch(':id')
    updateCar(@Param('id', ParseIntPipe) id: number, @Body() car: updateCarDto){
        return this.CarsService.updateCar(id, car)
    }

    @Get('user-ads/:id')
    async getUserAds(@Param('id', ParseIntPipe) id: number) {
        return this.CarsService.getUserAds(id);
    }
    
    // @Get('user-ads/:id')
    // async getUserAds(@Req() request: Request & { session: { userId: number } }) {
    //     const userId = request.session.userId;
    //     return this.CarsService.getUserAds(userId);
    // }

    @Get(':id')
    async detailCar(@Param('id') id: string) {
        const carDetails = await this.CarsService.getCar(parseInt(id));
        return carDetails;
    }
}

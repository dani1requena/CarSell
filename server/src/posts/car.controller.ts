import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post, Res, UploadedFile, UploadedFiles, UseInterceptors} from "@nestjs/common";
import { createCarDto, updateCarDto } from "./dto/create-Car.dto";
import { CarService } from "./Car.service";
import { FileInterceptor } from "@nestjs/platform-express";
import * as multer from 'multer';
const path = require("path");
import * as fs from 'fs';
const express = require('express');
const router = express.Router();

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
            cb(null, newFilename); // Nombre original del archivo
          },
        }),
      })) // Utiliza FileInterceptor en lugar de FilesInterceptor
    async createCar(@Body() car: createCarDto, @UploadedFile() photo: Express.Multer.File) {
        try{
            if (photo) {
                const imagenReferencia = photo.filename;
                car.photo= imagenReferencia;
                const createdCar = await this.CarsService.createCar(car);
                return { message: 'Coche creado correctamente', car: createdCar };
            } else {
                return { message: 'No se proporcionó una imagen válida' };
            }
        }catch(error){
            throw new Error('Error al crear el producto');
        }
    }
    
    @Get(':id')
    getCarById(@Param('id', ParseIntPipe) id:number){
        return this.CarsService.getCar(id);
    }

    @Delete(':id')
    deleteCar(@Param('id', ParseIntPipe) id: number){
        return this.CarsService.deleteCar(id)
    }

    @Patch(':id')
    updateCar(@Param('id', ParseIntPipe) id: number, @Body() car: updateCarDto){
        return this.CarsService.updateCar(id, car)
    }
}
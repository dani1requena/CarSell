import { Body, Controller, Delete, Get, HttpException, Param, ParseIntPipe, Patch, Post, Query, Req, Res, UploadedFile, UseInterceptors} from "@nestjs/common";
import { createCarDto, updateCarDto } from "./dto/create-Car.dto";
import { CarService } from "./Car.service";
import { FileInterceptor } from "@nestjs/platform-express";
import * as multer from 'multer';
const path = require("path");
import * as fs from 'fs';
const express = require('express');

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

    @Get('filter')
    async filterCars(
      @Query('minPower') minPower?: string,
      @Query('maxPower') maxPower?: string,
      @Query('minKilometers') minKilometers?: string,
      @Query('maxKilometers') maxKilometers?: string,
    ) {

      const minPowerNum = minPower ? parseInt(minPower) : undefined;
      const maxPowerNum = maxPower ? parseInt(maxPower) : undefined;
      const minKilometersNum = minKilometers ? parseInt(minKilometers) : undefined;
      const maxKilometersNum = maxKilometers ? parseInt(maxKilometers) : undefined;
      if (
        minPowerNum !== undefined ||
        maxPowerNum !== undefined ||
        minKilometersNum !== undefined ||
        maxKilometersNum !== undefined
      ) {
        return this.CarsService.filterCars(
          minPowerNum,
          maxPowerNum,
          minKilometersNum,
          maxKilometersNum,
        );
      } else {
        return this.CarsService.getCars();
      }
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

    @Delete(':id')
    deleteCar(@Param('id', ParseIntPipe) id: number){
        return this.CarsService.deleteCar(id)
    }

    @Patch('update/:id')
    updateCar(@Param('id', ParseIntPipe) id: number, @Body() car: updateCarDto){
        return this.CarsService.updateCar(id, car)
    }

    @Get('user-ads/:id')
    async getUserAds(@Param('id', ParseIntPipe) id: number) {
        return this.CarsService.getUserAds(id);
    }

    @Get(':id')
    async detailCar(@Param('id') id: string) {
        const carDetails = await this.CarsService.getCar(parseInt(id));
        return carDetails;
    }

}

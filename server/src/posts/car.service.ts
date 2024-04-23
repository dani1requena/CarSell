import { HttpException, HttpStatus, Injectable, Req } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { UserService } from "src/users/user.service";
import { Car } from "./Car.entity";
import { Repository } from "typeorm";
import { createCarDto, updateCarDto } from "./dto/create-Car.dto";
import { Request } from "express";
import { CustomSession } from './car.interface'; 

@Injectable()
export class CarService{

    constructor(
    @InjectRepository(Car) private CarRepository: Repository<Car>, 
    private usersService: UserService ){}

    getCars(): Promise<Car[]>{
        return this.CarRepository.find({relations:['author']})
    }

    async createCar(Car: createCarDto, userId: number): Promise<Car> {
        try {
            const userFound = await this.usersService.getUserById(userId);
            
            if (!userFound) {
                throw new HttpException('User not found!', HttpStatus.BAD_REQUEST);
            }
    
            const newCar = this.CarRepository.create({ ...Car, authorId: userId });
            const savedCar = await this.CarRepository.save(newCar);
    
            return savedCar;
        } catch (error) {
            throw error;
        }
    }

    async deleteCar(id: number) {
        const result = await this.CarRepository.delete({ id });
    
        if (result.affected === 0) {
            return new HttpException('Car not found!', HttpStatus.NOT_FOUND);
        }
    
        return result; 
    }

    async getCar(id: number): Promise<Car> {
        return await this.CarRepository.findOne({where: {id}});
    }

    async updateCar(id: number, car: updateCarDto){
        const carFound= await this.CarRepository.findOne({where: {id}})

        if(!carFound){
          return new HttpException('Car not found!', HttpStatus.NOT_FOUND);
        }
    
        const carUpdate = Object.assign(carFound, car)
        return this.CarRepository.save(carUpdate)
    }

    async getUserCars(id: number): Promise<Car[]>{
        const userCar = await this.CarRepository.find({ where: { id} });
        return userCar;
    }

    // async getUserCars(userId: number): Promise<Car[]>{
    //     const userCar = await this.CarRepository.find({ where: { id: userId } });
    //     return userCar;
    // }

    async getUserAds(userId: number) {
        return this.CarRepository.find({ where: { authorId: userId } });
    }
}
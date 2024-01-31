import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { UserService } from "src/users/user.service";
import { Car } from "./Car.entity";
import { Repository } from "typeorm";
import { createCarDto, updateCarDto } from "./dto/create-Car.dto";

@Injectable()
export class CarService{

    constructor(
    @InjectRepository(Car) private CarRepository: Repository<Car>, 
    private usersService: UserService ){}

    getCars(): Promise<Car[]>{
        return this.CarRepository.find({relations:['author']})
    }

    async createCar(Car: createCarDto){
        const userFound = await this.usersService.getUserById(Car.authorId)
        
        if(!userFound){
            return new HttpException('User not found!', 400)
        }

        const newCar = this.CarRepository.create(Car)
        await this.CarRepository.save(newCar)
    }

    async deleteCar(id: number) {
        const result = await this.CarRepository.delete({ id });
    
        if (result.affected === 0) {
            return new HttpException('Car not found!', HttpStatus.NOT_FOUND);
        }
    
        return result; 
    }

    async getCar(id: number){
        const carFound= await this.CarRepository.findOne({
         where: {id:id}
        })
        if(!carFound){
         return new HttpException('Car not found!', HttpStatus.NOT_FOUND);
        }
 
        return carFound;
    }

    async updateCar(id: number, car: updateCarDto){
        const carFound= await this.CarRepository.findOne({where: {id}})

        if(!carFound){
          return new HttpException('Car not found!', HttpStatus.NOT_FOUND);
        }
    
        const carUpdate = Object.assign(carFound, car)
        return this.CarRepository.save(carUpdate)
    }
}
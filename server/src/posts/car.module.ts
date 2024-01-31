import { Module } from "@nestjs/common";
import { CarController } from "./Car.controller";
import { CarService } from "./Car.service";
import { TypeOrmModule } from "@nestjs/typeorm";
import { Car } from "./Car.entity";
import { UserModule } from "src/users/users.module";

@Module({
    imports:[TypeOrmModule.forFeature([Car]), UserModule],
    providers:[CarService],
    controllers:[CarController],
})
export class CarModule{}
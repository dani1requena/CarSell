import { HttpException, HttpStatus, Injectable, InternalServerErrorException, UnauthorizedException } from '@nestjs/common';
import { updateUserDto, createUserDto, createProfileDto } from './dto/user.dto';
import { InjectRepository} from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import { Profile } from './profile_user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {

    constructor(
        @InjectRepository(User) private userRepository: Repository<User>, 
        @InjectRepository(Profile) private profileRepository: Repository<Profile>
    ){}

    getAllUsers(){
       return this.userRepository.find();
    }

    async createUser(user: createUserDto){
        const userFound = await this.userRepository.findOne({where:{username: user.username}});
        if (userFound){
            return new HttpException('User already exists', 400)
        }
        user.password = await bcrypt.hash(
            user.password,
            +process.env.HASH_SALT
        );
        const newUser = this.userRepository.create(user);
        return this.userRepository.save(newUser);
    }

    async deleteUser(id: number) {
        const result = await this.userRepository.delete({ id });
    
        if (result.affected === 0) {
            return new HttpException('User not found!', HttpStatus.NOT_FOUND);
        }
    
        return result; 
    }

    async findBy({key, value}: {key: keyof createUserDto; value:any}): Promise<User | undefined>{
        console.log('Buscando usuario por ID:', key);
        console.log('Buscando usuario por ID:', value);
        try {
            const user: User = await this.userRepository.createQueryBuilder(
                'user',
            ).addSelect('user.password').where({[key]: value}).getOne();
            return user;
        } catch (error) {
            throw new InternalServerErrorException('Error interno del servidor');
        }
    }
    
    async getUserById(id: number): Promise<User>{
       const userFound= await this.userRepository.findOne({
        where: {id:id},
       })
       if(!userFound){
        throw new HttpException('User not found!', HttpStatus.NOT_FOUND);
       }
       return userFound;
    }

    async updateUser(id: number, user: updateUserDto){
        const userFound= await this.userRepository.findOne({where: {id}})

        if(!userFound){
          return new HttpException('User not found!', HttpStatus.NOT_FOUND);
        }
    
        const userUpdate = Object.assign(userFound, user)
        return this.userRepository.save(userUpdate)
    }
    
    async createProfile(id:number, profile: createProfileDto){
        const userFound = await this.userRepository.findOne({where:{id}})
        if(!userFound){
            return new HttpException('User not found!', HttpStatus.NOT_FOUND);
        }

        const newProfile = this.profileRepository.create(profile)
        const savedProfile = await this.profileRepository.save(newProfile)
        userFound.profile = savedProfile

        return this.userRepository.save(userFound)
    }
}

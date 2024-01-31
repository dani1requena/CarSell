import { Body, Controller, Delete, Get, Param, Patch, Post, ParseIntPipe, Res, HttpStatus, UnauthorizedException, HttpCode } from '@nestjs/common';
import { UserService } from './user.service';
import { createProfileDto, createUserDto, updateUserDto} from './dto/user.dto';
import { User } from './user.entity';

@Controller('users')
export class UsersController {
    constructor (private UserService: UserService){} 

    @Get()
    getAllUsers(): Promise <User[]>{
        return this.UserService.getAllUsers();
    }

    @Get(':id')
    getUser(@Param('id', ParseIntPipe) id:number){
        return this.UserService.getUserById(id);
    }

    @Post('/register')
    @HttpCode(HttpStatus.CREATED)
    createUser(@Body() newUser: createUserDto){
        return this.UserService.createUser(newUser);
    }

    @Delete(':id')
    deleteUser(@Param('id', ParseIntPipe) id: number){
        return this.UserService.deleteUser(id)
    }

    @Patch(':id')
    updateUser(@Param('id', ParseIntPipe) id: number, @Body() user: updateUserDto){
        return this.UserService.updateUser(id, user)
    }

    @Post(':id/profile')
    createProfile(@Param ('id', ParseIntPipe) id:number, @Body() profile: createProfileDto){
        return this.UserService.createProfile(id, profile)
    }
}

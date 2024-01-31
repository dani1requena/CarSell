import { Body, Controller, Post, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { signInDto } from './dto/signInDto.dto';

@Controller('auth')
export class AuthController {
    constructor(private authService: AuthService) {}

    @Post('login')
    async login(@Body() {username, password}: signInDto) {
        const userValidate = await this.authService.validateUser(
            username,
            password
        );
        if(!userValidate){
            throw new UnauthorizedException('Data not valid');
        }

        const jwt = await this.authService.generateJWT(userValidate);
        return jwt;
    }
}

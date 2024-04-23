import { Body, Controller, Post, Session, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { signInDto } from './dto/signInDto.dto';

@Controller('auth')
export class AuthController {
    constructor(private authService: AuthService) {}

    @Post('login')
    async login(@Body() {username, password}: signInDto, @Session() session: any) {
        const userValidate = await this.authService.validateUser(
            username,
            password
        );
        if(!userValidate){
            throw new UnauthorizedException('Data not valid');
        }

        const { accessToken } = await this.authService.generateJWT(userValidate);
        session.userId = userValidate.id;
        console.log("Id del usuario cuando loguea: ", session.userId);
        return { accessToken, userId: userValidate.id };
    }
}

import { Inject, Injectable } from '@nestjs/common';
import { UserService } from 'src/users/user.service';
import * as bcrypt from 'bcrypt' ;
import * as jwt from 'jsonwebtoken' ;
import { User } from 'src/users/user.entity';
import { PayloadToken } from './auth.interface';
import { ConfigType } from '@nestjs/config';
import config from 'src/config';

@Injectable()
export class AuthService {
    constructor(
        private readonly userService: UserService,
        @Inject(config.KEY) private configService: ConfigType<typeof config> 
        ){}
    
    public async validateUser(username:string, password:string){
        console.log('Validando usuario...');
        const userByUserName = await this.userService.findBy({
            key: 'username',
            value: username
        });
        if(userByUserName){
            const match = await bcrypt.compare(password, userByUserName.password);
            if(match) return userByUserName;            
        }
        
        return null;
    }

    public SignJWT({payload, secret, expires}: {payload:jwt.JwtPayload; secret:string; expires: number | string}){
        return jwt.sign(payload, secret, {expiresIn: expires});
    }

    public async generateJWT(user: User):Promise<any>{
        const getUser = await this.userService.getUserById(user.id);
        const payload: PayloadToken = {
            id: getUser.id
        }
        return{
            accessToken: this.SignJWT({
                payload,
                secret: process.env.JWT_SECRET,
                expires: '1h'
            })
        } 
    }
}

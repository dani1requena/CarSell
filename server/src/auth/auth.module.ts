import { Global, Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { UserService } from 'src/users/user.service';
import { UserModule } from 'src/users/users.module';
import { JwtModule } from '@nestjs/jwt';
import config from 'src/config';
import { ConfigType } from '@nestjs/config';
//import { AuthMiddleware } from './auth.middleware';

@Global()
@Module({
  imports: [
    UserModule,
    JwtModule.registerAsync({
      inject: [config.KEY],
      useFactory: (configService: ConfigType<typeof config>) => {
        return{
          secret:configService.JWT_SECRET,
          signOptions:{
            expiresIn:'10d',
          },
        };
      }
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService]
})
export class AuthModule {

}

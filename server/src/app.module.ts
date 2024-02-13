import { Module } from '@nestjs/common';
import { UserModule } from './users/users.module';
import { CarModule } from './posts/car.module';
import { MulterModule } from '@nestjs/platform-express';
import { dbdatasource } from '../data.source';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { ConfigModule } from '@nestjs/config';
import { environments } from './environments';
import * as Joi from 'joi';
import config from './config';

@Module({
  imports: [
    TypeOrmModule.forRoot(dbdatasource),
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: environments[process.env.NODE_ENV] || '.develop.env',
      load: [config],
      validationSchema:Joi.object({
        JWT_SECRET: Joi.string().required()
      })
    }),    
    UserModule,CarModule,AuthModule,MulterModule.register({
      dest: './images'
    })
  ],
  providers: [],
})
export class AppModule {}

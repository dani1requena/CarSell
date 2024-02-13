import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { UserService } from './user.service';
import { TypeOrmModule} from '@nestjs/typeorm';
import { User } from './user.entity';
import { Profile } from './profile_user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, Profile])],
  controllers: [UsersController],
  providers: [UserService],
  exports: [UserService, TypeOrmModule.forFeature([Profile])]
})
export class UserModule {}
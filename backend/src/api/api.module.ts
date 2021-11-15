import { Module } from '@nestjs/common';
import { DbModule } from 'src/db/db.module';
import { AuthController } from './auth/auth.controller';
import { ContentController } from './content/content.controller';
import { UserController } from './user/user.controller';
import { UserService } from './user/user.service';

@Module({
  imports: [DbModule],
  controllers: [ContentController, UserController, AuthController],
  providers: [UserService],
})
export class ApiModule {}

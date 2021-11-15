import { Module } from '@nestjs/common';
import { DbModule } from 'src/db/db.module';
import { ContentController } from './content/content.controller';
import { UserController } from './user/user.controller';
import { UserService } from './user/user.service';

@Module({
  imports: [DbModule],
  controllers: [ContentController, UserController],
  providers: [UserService],
})
export class ApiModule {}

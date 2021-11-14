import { Module } from '@nestjs/common';
import { DbModule } from 'src/db/db.module';
import { ContentController } from './content/content.controller';
import { UserController } from './user/user.controller';

@Module({
  imports: [DbModule],
  controllers: [ContentController, UserController],
})
export class ApiModule {}

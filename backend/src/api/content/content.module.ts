import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ContentController } from './content.controller';
import { Lesson, Page, Unit } from './content.entity';
import { ContentService } from './content.service';

@Module({
  imports: [TypeOrmModule.forFeature([Unit, Lesson, Page])],
  controllers: [ContentController],
  providers: [ContentService],
})
export class ContentModule {}

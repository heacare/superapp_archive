import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ContentController } from './content.controller';
import { Unit } from './content.entity';
import { ContentService } from './content.service';
import { QuizModule } from './quiz/quiz.module';

@Module({
  imports: [TypeOrmModule.forFeature([Unit]), QuizModule],
  controllers: [ContentController],
  providers: [ContentService],
})
export class ContentModule {}

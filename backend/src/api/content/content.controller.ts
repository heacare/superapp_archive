import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';
import { Chapter } from './content.entity';
import { ContentService } from './content.service';
import { Quiz } from './quiz/quiz.entity';
import { QuizService } from './quiz/quiz.service';

@Controller('/api/content')
@UseGuards(ApiAuthGuard)
@ApiBearerAuth()
export class ContentController {
  constructor(private content: ContentService, private quiz: QuizService) {}

  @Get('/quiz')
  async getAllQuizzes(): Promise<Quiz[]> {
    return await this.quiz.getAll();
  }

  @Get()
  async getAll(): Promise<Chapter[]> {
    return await this.content.getAll();
  }
}

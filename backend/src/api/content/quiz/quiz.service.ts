import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Quiz } from './quiz.entity';

@Injectable()
export class QuizService {
  constructor(@InjectRepository(Quiz) private quizzes: Repository<Quiz>) {}

  async getAll(): Promise<Quiz[]> {
    return this.quizzes.find();
  }
}

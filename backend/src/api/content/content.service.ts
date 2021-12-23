import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Unit } from './content.entity';

@Injectable()
export class ContentService {
  constructor(@InjectRepository(Unit) private units: Repository<Unit>) {}

  async getAll(): Promise<Unit[]> {
    return this.units
      .createQueryBuilder('unit')
      .innerJoinAndSelect('unit.lessons', 'lesson')
      .innerJoinAndSelect('lesson.pages', 'page')
      .leftJoinAndSelect('page.quizOptions', 'quiz_option')
      .orderBy({
        'unit.unitNum': 'ASC',
        'lesson.lessonNum': 'ASC',
        'page.pageNum': 'ASC',
      })
      .getMany();
  }
}

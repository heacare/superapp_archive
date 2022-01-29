import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Unit, Lesson, Page } from './content.entity';

@Injectable()
export class ContentService {
  constructor(
    @InjectRepository(Unit) private units: Repository<Unit>,
    @InjectRepository(Lesson) private lessons: Repository<Lesson>,
    @InjectRepository(Page) private pages: Repository<Page>,
  ) {}

  async getUnits(): Promise<Unit[]> {
    return this.units.find({ order: { moduleOrder: 'ASC' } });
  }

  async getLessons(unitId: string): Promise<Lesson[]> {
    return this.lessons
      .createQueryBuilder('lesson')
      .where('lesson.unitId = :unitId', { unitId: unitId })
      .orderBy({ 'lesson.lessonOrder': 'ASC' })
      .getMany();
  }

  async getPages(lessonId: string): Promise<Page[]> {
    return this.pages
      .createQueryBuilder('page')
      .where('page.lessonId = :lessonId', { lessonId: lessonId })
      .leftJoinAndSelect('page.quizOptions', 'quiz_option')
      .orderBy({
        'page.pageOrder': 'ASC',
      })
      .getMany();
  }

  async getAll(): Promise<Unit[]> {
    return this.units
      .createQueryBuilder('unit')
      .innerJoinAndSelect('unit.lessons', 'lesson')
      .innerJoinAndSelect('lesson.pages', 'page')
      .leftJoinAndSelect('page.quizOptions', 'quiz_option')
      .orderBy({
        'unit.unitOrder': 'ASC',
        'lesson.lessonOrder': 'ASC',
        'page.pageOrder': 'ASC',
      })
      .getMany();
  }
}

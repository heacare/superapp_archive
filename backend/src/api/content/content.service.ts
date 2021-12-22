import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Lesson } from './content.entity';

@Injectable()
export class ContentService {
  constructor(
    @InjectRepository(Lesson) private lessons: Repository<Lesson>,
  ) {}

  async getAll(): Promise<Lesson[]> {
    return this.lessons.find();
  }
}

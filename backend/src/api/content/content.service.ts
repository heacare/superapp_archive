import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Chapter } from './content.entity';

@Injectable()
export class ContentService {
  constructor(
    @InjectRepository(Chapter) private chapters: Repository<Chapter>,
  ) {}

  async getAll(): Promise<Chapter[]> {
    return this.chapters.find();
  }
}

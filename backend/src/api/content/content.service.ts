import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Unit } from './content.entity';

@Injectable()
export class ContentService {
  constructor(@InjectRepository(Unit) private units: Repository<Unit>) {}

  async getAll(): Promise<Unit[]> {
    return this.units.find();
  }
}

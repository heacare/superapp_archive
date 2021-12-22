import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Healer } from './healer.entity';

@Injectable()
export class HealerService {
  constructor(@InjectRepository(Healer) private healers: Repository<Healer>) {}

  async getAll(): Promise<Healer[]> {
    return this.healers.find();
  }
}

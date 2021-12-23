import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LocationDto } from '../common/common.dto';
import { Healer } from './healer.entity';

@Injectable()
export class HealerService {
  constructor(@InjectRepository(Healer) private healers: Repository<Healer>) {}

  async getNearby(location: LocationDto, radius: number): Promise<Healer[]> {
    // TODO
    return null;
  }
}

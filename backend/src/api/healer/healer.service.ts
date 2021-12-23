import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LocationDto } from '../common/common.dto';
import { AvailabilitySlotDto, NearbyHealersDto } from './healer.dto';
import { Healer } from './healer.entity';

@Injectable()
export class HealerService {
  constructor(@InjectRepository(Healer) private healers: Repository<Healer>) {}

  async getNearby(
    location: LocationDto,
    radius: number,
  ): Promise<NearbyHealersDto> {
    throw new Error('Method not implemented.');
  }

  // TODO make sure that only ppl who recently saw this
  // healer can access their availability
  async availability(
    healerId: number,
    start: Date,
    end: Date,
  ): Promise<AvailabilitySlotDto[]> {
    throw new Error('Method not implemented.');
  }
}

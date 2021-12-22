import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Healer } from './healer.entity';

@Injectable()
export class HealerService {
  constructor(@InjectRepository(Healer) private healers: Repository<Healer>) {}

  async getNearby(
    location_lat: number,
    location_lng: number,
    radius: number,
  ): Promise<Healer[]> {
    return this.healers.find({
      // TODO temporary hack that will annoy ppl during code review
      where: `(sqrt(power(location_lat - ${location_lat}, 2) + power(location_lng - ${location_lng}, 2))) < ${radius}`,
    });
  }
}

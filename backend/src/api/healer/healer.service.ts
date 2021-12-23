import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { rrulestr } from 'rrule';
import { isWithinRadius } from '../../util/geo';
import { Repository } from 'typeorm';
import { LocationDto } from '../common/common.dto';
import {
  AvailabilitySlotDto,
  MedicalProficiencyDto,
  NearbyHealerDto,
  NearbyHealersDto,
} from './healer.dto';
import { Healer, Slot } from './healer.entity';

@Injectable()
export class HealerService {
  constructor(@InjectRepository(Healer) private healers: Repository<Healer>) {}

  async getNearby(
    location: LocationDto,
    radius: number, // in m
  ): Promise<NearbyHealersDto> {
    const userLocation = location.toPoint();
    const nearbyHealers = await this.healers
      .createQueryBuilder('healer')
      .where(isWithinRadius('location', 'userLocation', 'radius'), {
        userLocation: JSON.stringify(userLocation),
        radius,
      })
      .leftJoinAndSelect('healer.slots', 'slots')
      .leftJoinAndSelect('healer.proficiencies', 'prof')
      .leftJoinAndSelect('prof.tag', 'tag')
      .getMany();

    const nearbyHealerDTOs = nearbyHealers.map((h) => {
      const hdto = new NearbyHealerDto();
      hdto.id = h.id;
      hdto.name = h.name;
      hdto.description = h.description;
      hdto.location = LocationDto.fromPoint(h.location);
      hdto.proficiencies = h.proficiencies.map((p) => {
        const prof = new MedicalProficiencyDto();
        prof.name = p.tag.name;
        prof.description = p.tag.description;
        prof.proficiency = p.proficiency;
        return prof;
      });

      // TODO dumb method use date lib
      const start = new Date();
      const end = new Date(start);
      end.setDate(start.getDate() + 7);

      hdto.availability = this.availabilitySlotsBetween(h.slots, start, end);
      return hdto;
    });

    const dto = new NearbyHealersDto();
    dto.healers = nearbyHealerDTOs;
    return dto;
  }

  // TODO make sure that only ppl who recently saw this
  // healer can access their availability
  async availability(
    healerId: number,
    start: Date,
    end: Date,
  ): Promise<AvailabilitySlotDto[]> {
    const healer = await this.healers.findOneOrFail(healerId, {
      relations: ['slots'],
    });
    return this.availabilitySlotsBetween(healer.slots, start, end);
  }

  availabilitySlotsBetween(slots: Slot[], start: Date, end: Date) {
    return slots.flatMap((slot) => {
      const rrule = rrulestr(slot.rrule);
      return rrule.between(start, end, true).map((d) => {
        const adto = new AvailabilitySlotDto();
        adto.start = d;
        // TODO dumb method use date lib
        adto.end = new Date(d);
        adto.end.setHours(adto.end.getHours() + 2); // TODO have a duration field
        adto.isHouseVisit = slot.isHouseVisit;
        return adto;
      });
    });
  }
}

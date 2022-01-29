import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { rrulestr } from 'rrule';
import { isWithinRadius } from '../../util/geo';
import { Repository } from 'typeorm';
import { LocationDto } from '../common/common.dto';
import { AvailabilitySlotDto, MedicalProficiencyDto, NearbyHealerDto, NearbyHealersDto } from './healer.dto';
import { Healer, Slot } from './healer.entity';
import { DateTime, Duration } from 'luxon';
import { AuthUser } from '../auth/auth.strategy';

@Injectable()
export class HealerService {
  constructor(@InjectRepository(Healer) private healers: Repository<Healer>) {}

  /**
   * Get nearby healers from a user's location, within a certain radius (in metres).
   * @param location Location of a user
   * @param radius Radius in metres
   */
  async getNearby(location: LocationDto, radius: number): Promise<NearbyHealersDto> {
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

      const start = DateTime.now();
      const end = start.plus({ week: 1 });

      hdto.availability = this.availabilitySlotsBetween(h.slots, start.toJSDate(), end.toJSDate());
      return hdto;
    });

    const dto = new NearbyHealersDto();
    dto.healers = nearbyHealerDTOs;
    return dto;
  }

  // TODO make sure that only ppl who recently saw this
  // healer can access their availability
  async availability(user: AuthUser, healerId: number, start: Date, end: Date): Promise<AvailabilitySlotDto[]> {
    const healer = await this.healers.findOneOrFail(healerId, {
      relations: ['slots'],
    });
    return this.availabilitySlotsBetween(healer.slots, start, end);
  }

  availabilitySlotsBetween(slots: Slot[], start: Date, end: Date) {
    return slots.flatMap((slot) => {
      const rrule = rrulestr(slot.rrule);

      return rrule.between(start, end, true).map((start) => {
        const adto = new AvailabilitySlotDto();
        adto.start = start;
        const duration = Duration.fromISO(slot.duration.toISOString());
        adto.end = DateTime.fromJSDate(start).plus(duration).toJSDate();
        adto.isHouseVisit = slot.isHouseVisit;
        return adto;
      });
    });
  }
}

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuthUser } from '../auth/auth.strategy';
import { LocationDto } from '../common/common.dto';
import { MedicalProficiencyDto } from '../healer/healer.dto';
import { Healer, MedicalProficiency } from '../healer/healer.entity';
import { BookingDto, UserSessionDto, UserSessionHealerDto } from './session.dto';
import { Session } from './session.entity';

@Injectable()
export class SessionService {
  constructor(
    @InjectRepository(Session) private session: Repository<Session>,
    @InjectRepository(Healer) private healers: Repository<Healer>,
  ) {}

  async listSessions(user: AuthUser): Promise<UserSessionDto[]> {
    const sessions = await this.session.find({
      where: { user: user.id },
      relations: ['healer', 'healer.proficiencies', 'healer.proficiences.tag'],
    });

    return sessions.map((s) => {
      const sdto = new UserSessionDto();
      sdto.id = s.id;
      sdto.start = s.start;
      sdto.end = s.end;
      sdto.location = LocationDto.fromPoint(s.location);
      sdto.isHouseVisit = s.isHouseVisit;
      sdto.healer = new UserSessionHealerDto();
      sdto.healer.name = s.healer.name;
      sdto.healer.description = s.healer.description;
      sdto.healer.proficiencies = s.healer.proficiencies.map((p) => {
        const prof = new MedicalProficiencyDto();
        prof.name = p.tag.name;
        prof.description = p.tag.description;
        prof.proficiency = p.proficiency;
        return prof;
      });
      return sdto;
    });
  }

  // TODO make sure that only ppl who recently saw this
  // healer can book for this healer
  async book(user: AuthUser, booking: BookingDto): Promise<void> {
    // TODO validate this booking's slot
    const healer = await this.healers.findOneOrFail(user.id);

    await this.session.save({
      location: healer.location,
      isHouseVisit: true, // TODO get from BookingDto?
      user: { id: user.id },
      healer: healer,
      start: booking.slot.start,
      end: booking.slot.end,
    });
  }
}

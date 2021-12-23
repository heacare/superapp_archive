import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BookingDto, UserSessionDto } from './session.dto';
import { Session } from './session.entity';

@Injectable()
export class SessionService {
  constructor(
    @InjectRepository(Session) private session: Repository<Session>,
  ) {}

  async listSessions(user: number): Promise<UserSessionDto[]> {
    return null;
  }

  // TODO make sure that only ppl who recently saw this
  // healer can book for this healer
  book(user: number, booking: BookingDto): Promise<void> {
    // TODO validate this booking's slot
    return;
  }
}

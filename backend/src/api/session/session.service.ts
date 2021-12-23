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

  async listSessions(id: number): Promise<UserSessionDto[]> {
    this.session.find({
      where: { user: id },
    });
    throw new Error('Method not implemented.');
  }

  // TODO make sure that only ppl who recently saw this
  // healer can book for this healer
  book(id: number, booking: BookingDto): Promise<void> {
    // TODO validate this booking's slot
    throw new Error('Method not implemented.');
  }
}

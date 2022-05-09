import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuthUser } from '../auth/auth.strategy';
import { LogDto } from './log.dto';
import { Log } from './log.entity';

@Injectable()
export class LoggingService {
  constructor(@InjectRepository(Log) private logs: Repository<Log>) {}

  async create(user: AuthUser, { key, date, value }: LogDto): Promise<void> {
    await this.logs.save({
      user: { id: user.id },
      timestamp: Date.parse(date),
      key,
      value,
    });
  }
}

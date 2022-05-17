import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, Repository } from 'typeorm';
import { AuthUser } from '../auth/auth.strategy';
import { LogDto } from './log.dto';
import { Log } from './log.entity';

@Injectable()
export class LoggingService {
  constructor(@InjectRepository(Log) private logs: Repository<Log>) {}

  async create(user: AuthUser, { key, ts, tz, value }: LogDto): Promise<void> {
    await this.logs.save({
      user: { id: user.id },
      timestamp: new Date(),
      tsClient: ts ? new Date(ts) : null,
      tzClient: tz,
      key,
      value,
    });
  }

  async dump(start: Date, end: Date): Promise<Log[]> {
    return await this.logs.find({
      where: {
        timestamp: Between(start, end),
      },
    });
  }
}

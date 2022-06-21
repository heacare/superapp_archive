import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Not, In, Between, Repository } from 'typeorm';
import { AuthUser } from '../auth/auth.strategy';
import { LogDto } from './log.dto';
import { Log } from './log.entity';

@Injectable()
export class LoggingService {
  constructor(@InjectRepository(Log) private logs: Repository<Log>) {}

  async create(user: AuthUser | null, { key, ts, tz, value, accountId }: LogDto): Promise<void> {
    await this.logs.save({
      user: user ? { id: user.id } : undefined,
      timestamp: new Date(),
      tsClient: ts ? new Date(ts) : null,
      tzClient: tz,
      key,
      value,
      accountId,
    });
  }

  async dump(start: Date, end: Date, skipPastHealthData = true): Promise<Log[]> {
    const ignored: string[] = [];
    if (skipPastHealthData) {
      ignored.push('past-health-data');
    }
    const logs = await this.logs.find({
      where: {
        timestamp: Between(start, end),
        key: Not(In(ignored)),
      },
      relations: ['user'],
      order: {
        timestamp: 'ASC',
      },
    });
    return logs;
  }
}

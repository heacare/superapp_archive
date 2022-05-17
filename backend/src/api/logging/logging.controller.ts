import { Body, Controller, Post, Param, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { AuthUser } from '../auth/auth.strategy';
import { RequiresAuth, RequiresAuthUser } from '../auth/requiresAuthUser.decorator';
import { LogDto } from './log.dto';
import { LoggingService } from './logging.service';
import { Log } from './log.entity';

const LOGGING_DUMP_SECRET = process.env.LOGGING_DUMP_SECRET;
if (!LOGGING_DUMP_SECRET) {
  throw new Error('LOGGING_DUMP_SECRET is required');
}

@Controller('/api/logging')
@RequiresAuth()
export class LoggingController {
  constructor(private logging: LoggingService) {}

  @Post('simple')
  async createLog(@RequiresAuthUser() user: AuthUser, @Body() log: LogDto): Promise<void> {
    await this.logging.create(user, log);
  }

  @Post('dump')
  async dumpLog(@Param() secret: string, @Param() start: string, @Param() end: string): Promise<Log[]> {
    if (secret != LOGGING_DUMP_SECRET) {
      throw new UnauthorizedException();
    }
    const startDate = new Date(start);
    const endDate = new Date(end);
    if (startDate.getTime() === NaN || endDate.getTime() === NaN) {
      throw new BadRequestException();
    }
    return this.logging.dump(startDate, endDate);
  }
}

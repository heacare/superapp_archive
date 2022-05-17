import { Body, Controller, Post, Get, Query, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { AuthUser } from '../auth/auth.strategy';
import { RequiresAuth, RequiresAuthUser } from '../auth/requiresAuthUser.decorator';
import { LogDto, LogDumpDto } from './log.dto';
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

  @Get('dump')
  async dumpLog(@Query() query: LogDumpDto): Promise<Log[]> {
    if (query.secret != LOGGING_DUMP_SECRET) {
      throw new UnauthorizedException();
    }
    const startDate = new Date(query.start);
    const endDate = new Date(query.end);
    if (startDate.getTime() === NaN || endDate.getTime() === NaN) {
      throw new BadRequestException();
    }
    return this.logging.dump(startDate, endDate);
  }
}

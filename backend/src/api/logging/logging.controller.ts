import { Body, Controller, Post, Get, Query, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { AuthUser } from '../auth/auth.strategy';
import { RequiresAuth, RequiresAuthUser } from '../auth/requiresAuthUser.decorator';
import { LogDto, LogDumpDto, LogDumpSimplifiedDto } from './log.dto';
import { LoggingService } from './logging.service';

const LOGGING_DUMP_SECRET = process.env.LOGGING_DUMP_SECRET;

@Controller('/api/logging')
export class LoggingController {
  constructor(private logging: LoggingService) {}

  @Post('simple')
  @RequiresAuth()
  async createLog(@RequiresAuthUser() user: AuthUser, @Body() log: LogDto): Promise<void> {
    await this.logging.create(user, log);
  }

  @Get('dump')
  async dumpLog(@Query() query: LogDumpDto): Promise<LogDumpSimplifiedDto[]> {
    if (!LOGGING_DUMP_SECRET) {
      throw new UnauthorizedException();
    }
    if (query.secret != LOGGING_DUMP_SECRET) {
      throw new UnauthorizedException();
    }
    const startDate = new Date(query.start);
    const endDate = new Date(query.end);
    if (startDate.getTime() === NaN || endDate.getTime() === NaN) {
      throw new BadRequestException();
    }
    const logs = await this.logging.dump(startDate, endDate);
    return logs.map((log): LogDumpSimplifiedDto => {
      return {
        ...log,
        user: {
          id: log.user.id,
        },
      };
    });
  }
}

import { Body, Controller, Post } from '@nestjs/common';
import { AuthUser } from '../auth/auth.strategy';
import { RequiresAuth, RequiresAuthUser } from '../auth/requiresAuthUser.decorator';
import { LogDto } from './log.dto';
import { LoggingService } from './logging.service';

@Controller('/api/logging')
@RequiresAuth()
export class LoggingController {
  constructor(private logging: LoggingService) {}

  @Post('simple')
  async createLog(@RequiresAuthUser() user: AuthUser, @Body() log: LogDto): Promise<void> {
    await this.logging.create(user, log);
  }
}

import { Body, Controller, Get, Post } from '@nestjs/common';
import { AuthUser } from '../auth/auth.strategy';
import { RequiresAuth, RequiresAuthUser } from '../auth/requiresAuthUser.decorator';
import { BookingDto, UserSessionDto } from './session.dto';
import { SessionService } from './session.service';

@Controller('/api/session')
@RequiresAuth()
export class SessionController {
  constructor(private session: SessionService) {}

  @Get('list')
  async listSessions(@RequiresAuthUser() user: AuthUser): Promise<UserSessionDto[]> {
    return this.session.listSessions(user);
  }

  @Post('book')
  book(@RequiresAuthUser() user: AuthUser, @Body() booking: BookingDto): Promise<void> {
    return this.session.book(user, booking);
  }
}

import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';
import { BookingDto, UserSessionDto } from './session.dto';
import { SessionService } from './session.service';

@UseGuards(ApiAuthGuard)
@ApiBearerAuth()
@Controller('/api/session')
export class SessionController {
  constructor(private session: SessionService) {}

  @Get('list')
  async listSessions(@Req() req): Promise<UserSessionDto[]> {
    return this.session.listSessions(req.user.id);
  }

  @Post('book')
  book(@Req() req, @Body() booking: BookingDto): Promise<void> {
    return this.session.book(req.user.id, booking);
  }
}

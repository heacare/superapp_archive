import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';
import { BookingDto, UserSessionDto } from './session.dto';

@UseGuards(ApiAuthGuard)
@ApiBearerAuth()
@Controller('/api/session')
export class SessionController {
  @Get('list')
  async getForUser(@Req() req): Promise<UserSessionDto[]> {
    return null;
  }

  @Post('book')
  // TODO make sure that only ppl who recently saw this
  // healer can book for this healer
  book(@Body() booking: BookingDto): Promise<void> {
    // TODO validate this booking's slot
    return;
  }
}

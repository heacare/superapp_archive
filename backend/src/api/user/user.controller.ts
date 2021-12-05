import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';
import { Onboarding } from './onboarding.dto';
import { User } from './user.entity';
import { UserService } from './user.service';

@Controller('/api/user')
// TODO make all rounds require guard, except for 1.
@UseGuards(ApiAuthGuard)
// TODO make bearer auth the default authentication.
@ApiBearerAuth()
export class UserController {
  constructor(private users: UserService) {}

  @Get('info')
  async getInfo(@Req() req): Promise<User> {
    // TODO case this to proper interface
    // TODO catch proper exception and return 400/404
    return await this.users.findOne(req.user.id);
  }

  @Post('onboard')
  async processOnboarding(@Body() onboarding: Onboarding) {
    // TODO
  }
}

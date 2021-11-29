import { Controller, Get, Req, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { User } from './user.entity';
import { UserService } from './user.service';

@Controller('/api/user')
export class UserController {
  constructor(private users: UserService) {}

  @Get('info')
  @UseGuards(AuthGuard('authv1'))
  async getInfo(@Req() req): Promise<User> {
    // TODO case this to proper interface
    return await this.users.findOne(req.user.id);
  }
}

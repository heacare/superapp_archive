import { Controller, Get } from '@nestjs/common';
import { User } from './user.entity';
import { UserService } from './user.service';

@Controller('/api/user')
export class UserController {
  constructor(private users: UserService) {}

  // TODO pass auth token
  // TODO make this a UserInfoDto
  @Get('info')
  async getInfo(): Promise<User> {
    return await this.users.findOne(1337);
  }
}

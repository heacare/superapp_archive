import { Body, Controller, Get, Post } from '@nestjs/common';
import { AuthUser } from '../auth/auth.strategy';
import { RequiresAuth, RequiresAuthUser } from '../auth/requiresAuthUser.decorator';
import { OnboardingDto } from './onboarding.dto';
import { User } from './user.entity';
import { UserService } from './user.service';

@Controller('/api/user')
@RequiresAuth()
export class UserController {
  constructor(private users: UserService) {}

  @Get('info')
  async getInfo(@RequiresAuthUser() user: AuthUser): Promise<User> {
    // TODO case this to proper interface
    // TODO catch proper exception and return 400/404
    return await this.users.findOne(user);
  }

  // TODO easier access to req.user.id
  @Post('onboard')
  async processOnboarding(@RequiresAuthUser() user: AuthUser, @Body() onboarding: OnboardingDto) {
    await this.users.update(user, onboarding);
  }
}

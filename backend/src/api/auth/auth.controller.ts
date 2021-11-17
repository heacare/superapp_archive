import { Body, Controller, Post } from '@nestjs/common';
import { AuthDto } from './auth.dto';
import { AuthService } from './auth.service';

@Controller('/api/auth')
export class AuthController {
  constructor(private authSvc: AuthService) {}

  @Post('verify')
  async verify(@Body() auth: AuthDto) {
    await this.authSvc.verified(auth);
  }
}

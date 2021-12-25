import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { ApiExtraModels, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { AuthRequestDto, AuthResponseDto } from './auth.dto';
import { AuthService } from './auth.service';
import { UnauthorizedResponseDto } from './requiresAuthUser.decorator';

@Controller('/api/auth')
export class AuthController {
  constructor(private authSvc: AuthService) {}

  /**
   * Given a [Firebase TokenId](https://firebase.google.com/docs/auth/admin/verify-id-tokens#android), verify the token and return
   * another a JWT to be used for future API calls to protected endpoints (in Bearer authentication).
   */
  @Post('verify')
  @HttpCode(200)
  @ApiUnauthorizedResponse({ description: 'Invalid/Expired Firebase token' })
  async verify(@Body() auth: AuthRequestDto): Promise<AuthResponseDto> {
    const jwt = await this.authSvc.verify(auth.firebaseToken);
    return { jwt };
  }
}

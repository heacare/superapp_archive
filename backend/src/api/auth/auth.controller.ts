import { Body, Controller, Post } from '@nestjs/common';
import { AuthRequestDto, AuthResponseDto } from './auth.dto';
import { AuthService } from './auth.service';

@Controller('/api/auth')
export class AuthController {
  constructor(private authSvc: AuthService) {}

  // TODO catch firebase token invalid and return to user
  // TODO catch our JWT's token invalid in Guards for other
  // methods then redirect them to here.

  /*
   * Given a [Firebase TokenId](https://firebase.google.com/docs/auth/admin/verify-id-tokens#android), verify the token and return
   * another a JWT to be used for future API calls to protected endpoints (in Bearer authentication).
   */
  @Post('verify')
  async verify(@Body() auth: AuthRequestDto): Promise<AuthResponseDto | undefined> {
    const jwt = await this.authSvc.verify(auth.firebaseToken);
    if (jwt === undefined) {
      return undefined;
    }
    return { jwt };
  }
}

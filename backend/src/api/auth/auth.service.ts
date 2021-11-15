import { Injectable } from '@nestjs/common';
import { AuthDto } from './auth.dto';

@Injectable()
export class AuthService {
  // Base this on https://firebase.google.com/docs/auth/admin/verify-id-tokens
  async verified(auth: AuthDto): Promise<boolean> {
    throw new Error('TODO');
  }
}

import { Injectable } from '@nestjs/common';
import { UserService } from '../user/user.service';
import { AuthDto } from './auth.dto';

@Injectable()
export class AuthService {
  constructor(private users: UserService) {}

  // Base this on https://firebase.google.com/docs/auth/admin/verify-id-tokens
  async verified(auth: AuthDto): Promise<boolean> {
    // TODO checking
    const user = await this.users.create(auth.firebaseUid);
    return user !== undefined;
  }
}

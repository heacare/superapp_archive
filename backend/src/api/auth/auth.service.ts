import { Injectable } from '@nestjs/common';
import { UserService } from '../user/user.service';
import { AuthDto } from './auth.dto';

@Injectable()
export class AuthService {
  constructor(private users: UserService) {}

  // Base this on https://firebase.google.com/docs/auth/admin/verify-id-tokens
  // TODO instead of boolean, return a token/something that can been cached to
  // represent that this user is a valid user to the client without incurring
  // a firebase api call everytime
  async verified(auth: AuthDto): Promise<boolean> {
    // TODO checking
    const user = await this.users.create(auth.firebaseUid);
    return user !== undefined;
  }
}

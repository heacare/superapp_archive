import { Injectable, Logger } from '@nestjs/common';
import { UserService } from '../user/user.service';
import { User } from '../user/user.entity';
import { JwtService } from '@nestjs/jwt';
import { FirebaseService } from './firebase.service';

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(private firebaseSvc: FirebaseService, private users: UserService, private jwt: JwtService) {}

  async verifyRetrieveUser(token: string): Promise<User | undefined> {
    const authId = await this.firebaseSvc.getAuthId(token);
    if (authId === undefined) return undefined;
    const user = await this.users.findOrCreate(authId);
    return user;
  }

  async verify(token: string): Promise<string | undefined> {
    const user = await this.verifyRetrieveUser(token);
    if (user === undefined) {
      return undefined;
    }
    return await this.jwt.signAsync({ sub: user.id });
  }
}

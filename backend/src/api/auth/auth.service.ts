import { Inject, Injectable } from '@nestjs/common';
import { UserService } from '../user/user.service';
import { AuthDto } from './auth.dto';
import {
  FIREBASE_ADMIN_INJECT,
  FirebaseAdminSDK,
} from '@tfarras/nestjs-firebase-admin';
import { User } from '../user/user.entity';

@Injectable()
export class AuthService {
  constructor(
    @Inject(FIREBASE_ADMIN_INJECT) private firebaseAdmin: FirebaseAdminSDK,
    private users: UserService,
  ) {}

  async getAuthId(token: string): Promise<string | undefined> {
    try {
      const userObj = await this.firebaseAdmin.auth().verifyIdToken(token);
      return userObj.uid;
    } catch (e) {
      // TODO remove this blasphemy
      console.error(e);
      return undefined;
    }
  }

  async getOrCreateUser(token: string): Promise<User | undefined> {
    const authId = await this.getAuthId(token);
    if (authId === undefined) return undefined;
    const user = await this.users.findOrCreate(authId);
    // TODO cache token---user in redis
    return user;
  }

  async verify(token: string): Promise<boolean> {
    return (await this.getOrCreateUser(token)) !== undefined;
  }
}

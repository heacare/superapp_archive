import { Inject, Injectable, Logger } from '@nestjs/common';
import { FIREBASE_ADMIN_INJECT, FirebaseAdminSDK } from '@tfarras/nestjs-firebase-admin';

@Injectable()
export class FirebaseService {
  private readonly logger = new Logger(FirebaseService.name);

  constructor(@Inject(FIREBASE_ADMIN_INJECT) private firebaseAdmin: FirebaseAdminSDK) {}

  async getAuthId(token: string): Promise<string | undefined> {
    try {
      const userObj = await this.firebaseAdmin.auth().verifyIdToken(token);
      return userObj.uid;
    } catch (e) {
      this.logger.error(e, token);
      return undefined;
    }
  }
}

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthController } from './auth/auth.controller';
import { AuthService } from './auth/auth.service';
import { ContentController } from './content/content.controller';
import { UserController } from './user/user.controller';
import { User } from './user/user.entity';
import { UserService } from './user/user.service';
import { FirebaseAdminModule } from '@tfarras/nestjs-firebase-admin';
import * as firebaseAdmin from 'firebase-admin';
import { resolve } from 'path';

export const FirebaseAppModule = FirebaseAdminModule.forRootAsync({
  useFactory: () => {
    const credential = firebaseAdmin.credential.cert(
      resolve(__dirname, '../../firebase.config.json'),
    );
    return { credential, projectId: 'happily-ever-after-4b2fe' };
  },
});

@Module({
  imports: [TypeOrmModule.forFeature([User]), FirebaseAppModule],
  controllers: [ContentController, UserController, AuthController],
  providers: [UserService, AuthService],
})
export class ApiModule {}

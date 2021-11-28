import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DbModule } from '../../src/db/db.module';
import { AuthController } from './auth/auth.controller';
import { AuthService } from './auth/auth.service';
import { ContentController } from './content/content.controller';
import { UserController } from './user/user.controller';
import { User } from './user/user.entity';
import { UserService } from './user/user.service';
import { FirebaseAdminModule } from '@tfarras/nestjs-firebase-admin';
import * as firebaseAdmin from 'firebase-admin';
import * as serviceAccount from '../../firebase.config.json';
import { ServiceAccount } from 'firebase-admin';

@Module({
  imports: [
    DbModule,
    TypeOrmModule.forFeature([User]),
    FirebaseAdminModule.forRootAsync({
      useFactory: () => ({
        credential: firebaseAdmin.credential.cert(
          serviceAccount as ServiceAccount,
        ),
      }),
    }),
  ],
  controllers: [ContentController, UserController, AuthController],
  providers: [UserService, AuthService],
})
export class ApiModule {}

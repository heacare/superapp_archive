import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthController } from './auth/auth.controller';
import { AuthService } from './auth/auth.service';
import { ContentController } from './content/content.controller';
import { Chapter } from './content/content.entity';
import { ContentService } from './content/content.service';
import { UserController } from './user/user.controller';
import { User } from './user/user.entity';
import { UserService } from './user/user.service';
import { FirebaseAdminModule } from '@tfarras/nestjs-firebase-admin';
import * as firebaseAdmin from 'firebase-admin';
import { resolve } from 'path';
import { JwtModule } from '@nestjs/jwt';
import { ApiAuthStrategy } from './auth/auth.strategy';
import { PassportModule } from '@nestjs/passport';

export const ApiFirebaseModule = FirebaseAdminModule.forRootAsync({
  useFactory: () => {
    const credential = firebaseAdmin.credential.cert(
      resolve(__dirname, '../../firebase.config.json'),
    );
    return { credential, projectId: 'happily-ever-after-4b2fe' };
  },
});

export const ApiJwtModule = JwtModule.register({
  secret: process.env.JWT_SECRET,
});

@Module({
  imports: [
    TypeOrmModule.forFeature([User]),
    TypeOrmModule.forFeature([Chapter]),
    ApiFirebaseModule,
    PassportModule,
    ApiJwtModule,
  ],
  controllers: [ContentController, UserController, AuthController],
  providers: [ContentService, UserService, AuthService, ApiAuthStrategy],
})
export class ApiModule {}

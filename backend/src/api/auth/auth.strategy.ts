import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class ApiAuthStrategy extends PassportStrategy(Strategy, 'api') {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET,
    });
  }

  // consider getting the actual database object then cache
  // it, rather than just a object with id
  async validate(payload: any) {
    return new AuthUser(payload.sub);
  }
}

export class AuthUser {
  id: number;

  constructor(id: number) {
    this.id = id;
  }
}

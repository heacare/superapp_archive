import { Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UnauthErrCause, UnauthorizedResponseDto } from './requiresAuthUser.decorator';

@Injectable()
export class ApiAuthGuard extends AuthGuard('api') {
  handleRequest(err: any, user: any, info: any, context: any, status?: any) {
    if (err || info || !user) {
      if (info?.name === 'TokenExpiredError') {
        throw new UnauthorizedException(new UnauthorizedResponseDto(UnauthErrCause.TOKEN_EXPIRED_ERROR));
      }
    }
    return super.handleRequest(err, user, info, context, status);
  }
}

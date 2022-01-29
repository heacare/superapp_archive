import { applyDecorators, createParamDecorator, ExecutionContext, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { ApiAuthGuard } from './auth.guard';

export enum UnauthErrCause {
  TOKEN_EXPIRED_ERROR = 'TOKEN_EXPIRED_ERROR',
}

export class UnauthorizedResponseDto {
  err: UnauthErrCause;

  constructor(err: UnauthErrCause) {
    this.err = err;
  }
}

export function RequiresAuth() {
  return applyDecorators(
    UseGuards(ApiAuthGuard),
    ApiBearerAuth(),
    ApiUnauthorizedResponse({
      description:
        'Unauthorized. Refer to /api/auth/verify for authentication. Body is empty unless token is expired (refer to example).',
      schema: {
        example: {
          err: UnauthErrCause.TOKEN_EXPIRED_ERROR,
        },
      },
    }),
  );
}
export const RequiresAuthUser = createParamDecorator((data: unknown, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest();
  return request.user;
});

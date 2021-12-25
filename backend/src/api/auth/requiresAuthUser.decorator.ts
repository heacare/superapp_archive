import { applyDecorators, createParamDecorator, ExecutionContext, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiResponse, ApiUnauthorizedResponse, getSchemaPath } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';
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
      description: 'Unauthorized. Refer to /api/auth/verify for authentication.',
    }),
  );
}
export const RequiresAuthUser = createParamDecorator((data: unknown, ctx: ExecutionContext) => {
  const request = ctx.switchToHttp().getRequest();
  return request.user;
});

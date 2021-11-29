import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';

@Controller('/api/content')
@UseGuards(ApiAuthGuard)
@ApiBearerAuth()
export class ContentController {
  @Get()
  getAll(): string {
    throw new Error('Actually return the correct type');
  }
}

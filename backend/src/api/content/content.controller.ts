import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';
import { Chapter } from './content.entity';
import { ContentService } from './content.service';

@Controller('/api/content')
@UseGuards(ApiAuthGuard)
@ApiBearerAuth()
export class ContentController {
  constructor(private content: ContentService) {}

  @Get()
  async getAll(): Promise<Chapter[]> {
    return await this.content.getAll();
  }
}

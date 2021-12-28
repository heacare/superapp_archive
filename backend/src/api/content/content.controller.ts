import { Controller, Get, Param } from '@nestjs/common';
import { Unit, Lesson, Page } from './content.entity';
import { RequiresAuth } from '../auth/requiresAuthUser.decorator';
import { ContentService } from './content.service';

@RequiresAuth()
@Controller('/api/content')
export class ContentController {
  constructor(private content: ContentService) {}

  /**
   *   Note: Module is synonymous with Unit, just that
   *         nestjs is unhappy if we call things Module
   */
  @Get('/modules')
  async getUnits(): Promise<Unit[]> {
    return await this.content.getUnits();
  }

  @Get('/lessons/:moduleId')
  async getLessons(@Param('moduleId') moduleId: string): Promise<Lesson[]> {
    return await this.content.getLessons(moduleId);
  }

  @Get('/pages/:lessonId')
  async getPages(@Param('lessonId') lessonId: string): Promise<Page[]> {
    return await this.content.getPages(lessonId);
  }

  @Get('/all')
  async getAll(): Promise<Unit[]> {
    return await this.content.getAll();
  }
}

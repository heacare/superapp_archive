import { Controller, Get } from '@nestjs/common';
import { RequiresAuth } from '../auth/requiresAuthUser.decorator';
import { Unit } from './content.entity';
import { ContentService } from './content.service';

@RequiresAuth()
@Controller('/api/content')
export class ContentController {
  constructor(private content: ContentService) {}

  @Get()
  async getAll(): Promise<Unit[]> {
    return await this.content.getAll();
  }
}

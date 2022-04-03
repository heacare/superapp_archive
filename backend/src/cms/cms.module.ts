import { Module } from '@nestjs/common';

import { CmsController } from './cms.controller';
import { NotionService } from './notion/notion.service';

@Module({
  imports: [],
  controllers: [CmsController],
  providers: [NotionService],
})
export class CmsModule {}

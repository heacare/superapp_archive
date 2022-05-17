import { Module } from '@nestjs/common';
import { ApiModule } from './api/api.module';
import { LandingModule } from './landing/landing.module';
import { DbModule } from './db/db.module';
import { CmsModule } from './cms/cms.module';

@Module({
  imports: [ApiModule, DbModule, LandingModule, CmsModule],
})
export class AppModule {}

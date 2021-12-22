import { Module } from '@nestjs/common';
import { ApiModule } from './api/api.module';
import { DbModule } from './db/db.module';
import { DbSeedModule } from './db/seeding/dbseed.module';

@Module({
  imports: [ApiModule, DbModule, DbSeedModule],
})
export class AppModule {}

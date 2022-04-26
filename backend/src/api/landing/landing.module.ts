import { Module } from '@nestjs/common';

import { LandingController } from './landing.controller';

@Module({
  imports: [],
  controllers: [LandingController],
  providers: [],
})
export class LandingModule {}

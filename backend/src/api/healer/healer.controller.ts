import { Controller, Get, Query } from '@nestjs/common';
import { AuthUser } from '../auth/auth.strategy';
import {
  RequiresAuth,
  RequiresAuthUser,
} from '../auth/requiresAuthUser.decorator';
import { LocationDto } from '../common/common.dto';
import { AvailabilitySlotDto, NearbyHealersDto } from './healer.dto';
import { HealerService } from './healer.service';

@Controller('/api/healer')
@RequiresAuth()
export class HealerController {
  constructor(private healers: HealerService) {}

  @Get('nearby')
  async nearby(@Query() location: LocationDto): Promise<NearbyHealersDto> {
    return await this.healers.getNearby(location, 5000.0);
  }

  @Get('availability')
  async availability(
    @RequiresAuthUser() user: AuthUser,
    @Query('healerId') healerId: number,
    @Query('start') start: Date,
    @Query('end') end: Date,
  ): Promise<AvailabilitySlotDto[]> {
    return await this.healers.availability(user, healerId, start, end);
  }
}

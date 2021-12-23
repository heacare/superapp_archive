import { Controller, Get, Query, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';
import { LocationDto } from '../common/common.dto';
import { AvailabilitySlotDto, NearbyHealersDto } from './healer.dto';
import { HealerService } from './healer.service';

@Controller('/api/healer')
export class HealerController {
  constructor(private healers: HealerService) {}

  @UseGuards(ApiAuthGuard)
  @ApiBearerAuth()
  @Get('nearby')
  async nearby(@Query() location: LocationDto): Promise<NearbyHealersDto> {
    return await this.healers.getNearby(location, 5000.0);
  }

  @UseGuards(ApiAuthGuard)
  @ApiBearerAuth()
  @Get('availability')
  async availability(
    @Req() req,
    @Query('healerId') healerId: number,
    @Query('start') start: Date,
    @Query('end') end: Date,
  ): Promise<AvailabilitySlotDto[]> {
    return await this.healers.availability(req.user.id, healerId, start, end);
  }
}

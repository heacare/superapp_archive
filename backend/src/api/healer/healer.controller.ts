import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';
import { LocationDto } from '../common/common.dto';
import {
  AvailabilitySlotDto,
  NearbyHealerDto,
  NearbyHealersDto,
} from './healer.dto';
import { HealerService } from './healer.service';

@Controller('/api/healer')
export class HealerController {
  constructor(private healers: HealerService) {}

  @UseGuards(ApiAuthGuard)
  @ApiBearerAuth()
  @Get('nearby')
  // TODO use geolocation type
  async nearby(
    @Query('lat') lat: number,
    @Query('lng') lng: number,
  ): Promise<NearbyHealersDto> {
    const location = new LocationDto();
    location.lat = lat;
    location.lng = lng;

    const healers = (await this.healers.getNearby(location, 50.0)).map((h) => {
      const healer = new NearbyHealerDto();
      healer.name = h.name;
      healer.description = h.description;
      // TODO use class-transformer
      return healer;
    });

    const dto = new NearbyHealersDto();
    dto.healers = healers;
    return dto;
  }

  @UseGuards(ApiAuthGuard)
  @ApiBearerAuth()
  @Get('availability')
  // TODO make sure that only ppl who recently saw this
  // healer can access their availability
  availability(
    @Query('healerId') healerId: number,
    @Query('start') start: Date,
    @Query('end') end: Date,
  ): Promise<AvailabilitySlotDto[]> {
    throw new Error('unimplemented');
  }
}

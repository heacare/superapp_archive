import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth } from '@nestjs/swagger';
import { ApiAuthGuard } from '../auth/auth.guard';
import {
  AvailabilitySlotDto,
  BookingDto,
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
    @Query() location_lat: number,
    @Query() location_lng: number,
  ): Promise<NearbyHealersDto> {
    const healers = (await this.healers.getAll()).map((h) => {
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
    @Query() healerId: number,
    @Query() start: Date,
    @Query() end: Date,
  ): Promise<AvailabilitySlotDto[]> {
    throw new Error('unimplemented');
  }

  @UseGuards(ApiAuthGuard)
  @ApiBearerAuth()
  @Post('book')
  // TODO make sure that only ppl who recently saw this
  // healer can book for this healer
  book(@Body() booking: BookingDto): Promise<void> {
    // TODO validate this booking's slot
    throw new Error('unimplemented');
  }
}

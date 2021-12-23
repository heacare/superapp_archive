import { LocationDto } from '../common/common.dto';
import {
  AvailabilitySlotDto,
  MedicalProficiencyDto,
} from '../healer/healer.dto';

export class UserSessionHealerDto {
  name: string;
  description: string;
  proficiencies: MedicalProficiencyDto[];
}

export class UserSessionDto {
  id: number;
  healer: UserSessionHealerDto;
  location: LocationDto;
  isHouseVisit: boolean;
  start: Date;
  end: Date;
}

export class BookingDto {
  healerId: number;
  slot: AvailabilitySlotDto;
}

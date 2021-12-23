import { LocationDto } from '../common/common.dto';

export class MedicalProficiencyDto {
  name: string;
  description: string;
  proficiency: number;
}

export class AvailabilitySlotDto {
  start: Date;
  end: Date;
}

export class NearbyHealerDto {
  id: number;
  name: string;
  description: string;
  proficiency: MedicalProficiencyDto[];
  availability: AvailabilitySlotDto[];
  location: LocationDto;
}

export class NearbyHealersDto {
  healers: NearbyHealerDto[];
}

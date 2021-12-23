import { LocationDto } from '../common/common.dto';

export class MedicalProficiencyDto {
  name: string;
  description: string;
  proficiency: number;
}

export class AvailabilitySlotDto {
  start: Date;
  end: Date;
  isHouseVisit: boolean;
}

export class NearbyHealerDto {
  id: number;
  name: string;
  description: string;
  proficiencies: MedicalProficiencyDto[];
  availability: AvailabilitySlotDto[];
  location: LocationDto;
}

export class NearbyHealersDto {
  healers: NearbyHealerDto[];
}

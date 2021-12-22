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
  location_lat: number;
  location_lng: number;
}

export class NearbyHealersDto {
  healers: NearbyHealerDto[];
}

export class BookingDto {
  healerId: number;
  slot: AvailabilitySlotDto;
}

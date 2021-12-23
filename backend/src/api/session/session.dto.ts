import { MedicalProficiencyDto } from '../healer/healer.dto';

export class UserSessionHealerDto {
  name: string;
  description: string;
  proficiency: MedicalProficiencyDto[];
}

export class UserSessionDto {
  id: number;
  healer: UserSessionHealerDto; // TODO
  where: string; // TODO
  isHouseVisit: boolean;
  start: Date;
  end: Date;
}

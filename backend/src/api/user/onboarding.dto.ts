// TODO actually fill these with valid values from the Notion

import {
  IsDate,
  IsDateString,
  IsInt,
  IsISO31661Alpha2,
  IsNotEmpty,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';

export enum AlcoholFrequency {
  NotAtAll,
  OnceAMonth,
  OnceAWeek,
  FewTimesAWeek,
  Everday,
}

export enum Outlook {
  Positive,
  Negative,
  Soulless,
}

export enum MaritalStatus {
  Single,
  Married,
  Widowed,
  Divorced,
}

export enum Gender {
  Male,
  Female,
  Others,
}

export enum SmokingPacks {
  LessOnePack,
  OneToTwoPacks,
  ThreeToFivePacks,
  FivePacks,
}

export class NonSmoker {
  isSmoker: false;
}

export class Smoker {
  isSmoker: true;
  packsPerDay: SmokingPacks;
  @IsInt()
  yearsSmoking: number;
}

export type SmokingInfo = NonSmoker | Smoker;

export class Onboarding {
  @IsNotEmpty()
  name: string;
  gender: Gender;
  birthday: Date;
  @Min(0.3)
  @Max(3.0)
  height: number;
  @Min(3.0)
  @Max(200.0)
  weight: number;
  @IsISO31661Alpha2()
  country: string;
  @ValidateNested()
  smoking: SmokingInfo;
  alcoholFreq: AlcoholFrequency;
  outlook: Outlook;
  maritalStatus: MaritalStatus;
  familyHistory: string | null;
  birthControl: string | null;
}

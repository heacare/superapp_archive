// TODO actually fill these with valid values from the Notion

import { Type } from 'class-transformer';
import {
  IsDateString,
  IsString,
  IsEnum,
  IsInt,
  IsISO31661Alpha2,
  IsNotEmpty,
  IsObject,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { IsNullable } from '../../util/validation';

export enum AlcoholFrequency {
  NotAtAll = 'NotAtAll',
  OnceAMonth = 'OnceAMonth',
  OnceAWeek = 'OnceAWeek',
  FewTimesAWeek = 'FewTimesAWeek',
  Everday = 'Everyday',
}

export enum Outlook {
  Positive = 'Positive',
  Negative = 'Negative',
  Soulless = 'Soulless',
}

export enum MaritalStatus {
  Single = 'Single',
  Married = 'Married',
  Widowed = 'Widowed',
  Divorced = 'Divorced',
}

export enum Gender {
  Male = 'Male',
  Female = 'Female',
  Others = 'Others',
}

export enum SmokingPacks {
  LessOnePack = 'LessOnePack',
  OneToTwoPacks = 'OneToTwoPacks',
  ThreeToFivePacks = 'ThreeToFivePacks',
  FivePacks = 'FivePacks',
}

export class SmokerInfo {
  @IsEnum(SmokingPacks)
  packsPerDay: SmokingPacks;
  @IsInt()
  @Min(0)
  years: number;
}

export class OnboardingDtoV1 {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsEnum(Gender)
  gender: Gender;

  /*
   * Birthday, but only the Date part is considered
   */
  @IsDateString()
  birthday: Date;

  @Min(0.3)
  @Max(3.0)
  height: number;

  @Min(3.0)
  @Max(200.0)
  weight: number;

  /*
   * ISO31661 2-letter alphabetical country code
   */
  @IsISO31661Alpha2()
  country: string;

  @IsObject()
  @IsNullable()
  @ValidateNested()
  @Type(() => SmokerInfo)
  smoking: SmokerInfo | null;

  @IsEnum(AlcoholFrequency)
  alcoholFreq: AlcoholFrequency;

  @IsEnum(Outlook)
  outlook: Outlook;

  @IsEnum(MaritalStatus)
  maritalStatus: MaritalStatus;

  @IsString()
  @IsNullable()
  familyHistory: string | null;

  @IsString()
  @IsNullable()
  birthControl: string | null;
}

// use IntersectionType(OnboardingV1, OnboardingV2) when we create new onboarding levels
export class OnboardingDto extends OnboardingDtoV1 {}

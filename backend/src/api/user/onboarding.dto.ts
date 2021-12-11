// TODO actually fill these with valid values from the Notion

import { ApiExtraModels, ApiProperty, getSchemaPath } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsDateString,
  IsString,
  IsEnum,
  IsInt,
  IsISO31661Alpha2,
  IsNotEmpty,
  IsNotEmptyObject,
  IsObject,
  Max,
  Min,
  ValidateNested,
  IsOptional,
} from 'class-validator';

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

abstract class SmokingInfo {
  isSmoker: boolean;
}

export class NonSmoker extends SmokingInfo {}

export class Smoker extends SmokingInfo {
  @IsEnum(SmokingPacks)
  packsPerDay: SmokingPacks;
  @IsInt()
  yearsSmoking: number;
}

@ApiExtraModels(Smoker, NonSmoker)
export class OnboardingV1 {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsEnum(Gender)
  gender: Gender;

  @IsDateString()
  birthday: Date;

  @Min(0.3)
  @Max(3.0)
  height: number;

  @Min(3.0)
  @Max(200.0)
  weight: number;

  @IsISO31661Alpha2()
  country: string;

  @IsNotEmptyObject()
  @IsObject()
  @ValidateNested()
  @Type(() => SmokingInfo, {
    discriminator: {
      property: 'isSmoker',
      subTypes: [
        { value: NonSmoker, name: false as any },
        { value: Smoker, name: true as any },
      ],
    },
    keepDiscriminatorProperty: true,
  })
  @ApiProperty({
    oneOf: [
      { $ref: getSchemaPath(NonSmoker) },
      { $ref: getSchemaPath(Smoker) },
    ],
  })
  smoking: NonSmoker | Smoker;

  @IsEnum(AlcoholFrequency)
  alcoholFreq: AlcoholFrequency;

  @IsEnum(Outlook)
  outlook: Outlook;

  @IsEnum(MaritalStatus)
  maritalStatus: MaritalStatus;

  @IsString()
  @IsOptional()
  familyHistory: string | null;

  @IsString()
  @IsOptional()
  birthControl: string | null;
}

// use IntersectionType(OnboardingV1, OnboardingV2) when we create new onboarding levels
export class Onboarding extends OnboardingV1 {}

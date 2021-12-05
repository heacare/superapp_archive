import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import {
  AlcoholFrequency,
  Gender,
  MaritalStatus,
  Outlook,
  SmokingPacks,
} from './onboarding.dto';

// Add more labels whenever we add questions so that we should
// force the user to answer questions
//
// Our DTOs will be of the form { level: 'filledv1', ...fields },
// where each field uses 'class-validator' for validation and checking existence.
export type RespondedLevel = 'uninit' | 'filledv1';

export interface HealthData {
  data_type: string;
  value: number | string;
  unit: string;
}

class Onboarding {
  @Column({ nullable: true })
  name?: string;

  @Column({ nullable: true })
  gender?: Gender;

  @Column({ nullable: true, type: 'date' }) // date only!
  birthday?: Date;

  @Column({ nullable: true })
  height?: number;

  @Column({ nullable: true })
  weight?: number;

  @Column({ nullable: true })
  country?: string;

  @Column({ nullable: true })
  isSmoker?: boolean;

  @Column({ nullable: true })
  smokingPacksPerDay?: SmokingPacks;

  @Column({ nullable: true })
  smokingYears?: number;

  @Column({ nullable: true })
  alcoholFreq?: AlcoholFrequency;

  @Column({ nullable: true })
  outlook?: Outlook;

  @Column({ nullable: true })
  maritalStatus?: MaritalStatus;

  @Column({ nullable: true })
  familyHistory?: string | undefined;

  @Column({ nullable: true })
  birthControl?: string | undefined;
}

@Entity()
export class User extends Onboarding {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  authId: string;

  @Column()
  level: RespondedLevel;

  // We will rarely be reading from HealthData
  // directly, thus this is a jsonb data for
  // efficiency rather than it's own table
  @Column({ type: 'jsonb' })
  healthData: HealthData[];

  static uninit(authId: string): User {
    const user = new User();
    user.authId = authId;
    user.level = 'uninit';
    user.healthData = [];
    return user;
  }
}

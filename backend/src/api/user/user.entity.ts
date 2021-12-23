import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Session } from '../session/session.entity';
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

@Entity()
export class User {
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

  @Column({ nullable: true })
  name?: string;

  @Column({ nullable: true, type: 'enum', enum: Gender })
  gender?: Gender;

  @Column({ nullable: true, type: 'date' }) // date only!
  birthday?: Date;

  @Column({ nullable: true, type: 'real' })
  height?: number;

  @Column({ nullable: true, type: 'real' })
  weight?: number;

  @Column({ nullable: true })
  country?: string;

  @Column({ nullable: true })
  isSmoker?: boolean;

  @Column({ nullable: true, type: 'enum', enum: SmokingPacks })
  smokingPacksPerDay?: SmokingPacks;

  @Column({ nullable: true, type: 'int' })
  smokingYears?: number;

  @Column({ nullable: true, type: 'enum', enum: AlcoholFrequency })
  alcoholFreq?: AlcoholFrequency;

  @Column({ nullable: true, type: 'enum', enum: Outlook })
  outlook?: Outlook;

  @Column({ nullable: true, type: 'enum', enum: MaritalStatus })
  maritalStatus?: MaritalStatus;

  @Column({ nullable: true })
  familyHistory?: string | undefined;

  @Column({ nullable: true })
  birthControl?: string | undefined;

  @OneToMany(() => Session, (sess) => sess.user)
  sessions: Session[];

  static uninit(authId: string): User {
    const user = new User();
    user.authId = authId;
    user.level = 'uninit';
    user.healthData = [];
    return user;
  }
}

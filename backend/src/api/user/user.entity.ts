import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

// TODO narrow down string types

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

export interface OnboardingResponses {
  alcoholFreq?: string;
  maritalStatus?: string;
  gender?: string;
}

@Entity()
export class User implements OnboardingResponses {
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

  @Column()
  alcoholFreq?: string;

  @Column()
  maritalStatus?: string;

  @Column()
  gender?: string;

  static uninit(authId: string): User {
    const user = new User();
    user.authId = authId;
    user.level = 'uninit';
    user.healthData = [];
    return user;
  }
}

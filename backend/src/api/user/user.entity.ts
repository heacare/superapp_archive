import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

// TODO narrow down string types

// add more whenever we add questions and we should
// force the user to answer questions
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
  level: RespondedLevel = 'uninit';

  @Column({ type: 'jsonb' })
  healthData: HealthData[];

  @Column()
  alcoholFreq?: string;

  @Column()
  maritalStatus?: string;

  @Column()
  gender: string;
}

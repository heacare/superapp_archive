import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from '../user/user.entity';

export type RespondedLevel = 'uninit' | 'filledv1';

@Entity()
export class Log {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, (user) => user.logs, { nullable: true })
  user?: User;

  @Column({ type: 'timestamp' })
  timestamp: Date;

  @Column({ type: 'timestamp', nullable: true })
  tsClient?: Date;

  @Column({ nullable: true })
  tzClient?: string;

  @Column()
  key: string;

  @Column()
  value: string;

  @Column({ nullable: true })
  accountId?: string;
}

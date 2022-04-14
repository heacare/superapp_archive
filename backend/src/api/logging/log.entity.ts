import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { User } from '../user/user.entity';

export type RespondedLevel = 'uninit' | 'filledv1';

@Entity()
export class Log {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, (user) => user.logs)
  user: User;

  @Column({ type: 'timestamp' })
  timestamp: Date;

  @Column()
  key: string;

  @Column()
  value: string;
}
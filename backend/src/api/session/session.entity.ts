import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Healer } from '../healer/healer.entity';
import { User } from '../user/user.entity';

@Entity()
export class Session {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Healer, (healer) => healer.sessions)
  healer: Healer;

  @ManyToOne(() => User, (user) => user.sessions)
  user: User;

  @Column()
  where: string; // TODO geoloc type

  @Column()
  isHouseVisit: boolean;

  @Column()
  start: Date;

  @Column()
  end: Date;
}

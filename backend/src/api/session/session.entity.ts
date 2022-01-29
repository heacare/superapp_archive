import { Point } from 'geojson';
import { Column, Entity, Index, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
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

  @Index({ spatial: true })
  @Column({
    type: 'geography',
    spatialFeatureType: 'Point',
    srid: 4326,
  })
  location: Point;

  @Column()
  isHouseVisit: boolean;

  @Column()
  start: Date;

  @Column()
  end: Date;
}

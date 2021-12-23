import { Point } from 'geojson';
import {
  Column,
  Entity,
  Index,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Session } from '../session/session.entity';

@Entity()
export class Healer {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  description: string;

  // Spatial Columns : https://stackoverflow.com/questions/65041545/how-can-i-use-longitude-and-latitude-with-typeorm-and-postgres
  // Spatial Query   : https://github.com/typeorm/typeorm/blob/master/docs/entities.md#spatial-columns
  @Index({ spatial: true })
  @Column({
    type: 'geography',
    spatialFeatureType: 'Point',
    srid: 4326,
  })
  location: Point;

  @OneToMany(() => MedicalProficiency, (prof) => prof.healer, { cascade: true })
  proficiencies: MedicalProficiency[];

  @OneToMany(() => Slot, (slot) => slot.healer, { cascade: true })
  slots: Slot[];

  @OneToMany(() => Session, (sess) => sess.healer, { cascade: true })
  sessions: Session[];
}

@Entity()
export class MedicalTag {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  description: string;

  @OneToMany(() => MedicalProficiency, (prof) => prof.tag, { cascade: true })
  proficiencies: MedicalProficiency[];
}

@Entity()
export class MedicalProficiency {
  @ManyToOne(() => Healer, (healer) => healer.proficiencies, { primary: true })
  healer: Healer;

  @ManyToOne(() => MedicalTag, (tag) => tag.proficiencies, { primary: true })
  tag: MedicalTag;

  @Column('int')
  proficiency: number;
}

@Entity()
export class Slot {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Healer, (healer) => healer.slots)
  healer: Healer;

  @Column()
  isHouseVisit: boolean;

  // RFC5545 RRULE
  @Column()
  rrule: string;
}

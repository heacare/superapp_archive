import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity()
export class Healer {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  description: string;

  // TODO use Spatial Columns https://stackoverflow.com/questions/65041545/how-can-i-use-longitude-and-latitude-with-typeorm-and-postgres
  // TODO Query using https://github.com/typeorm/typeorm/blob/master/docs/entities.md#spatial-columns

  @Column()
  location_lat: number;

  @Column()
  location_lng: number;

  @OneToMany(() => MedicalProficiency, (prof) => prof.healer)
  proficiencies: MedicalProficiency[];
}

@Entity()
export class MedicalTag {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  description: string;

  @OneToMany(() => MedicalProficiency, (prof) => prof.tag)
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

export class Slot {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Healer, (healer) => healer.proficiencies, { primary: true })
  healer: Healer;

  @Column()
  start: Date;

  @Column()
  end: Date;

  @Column()
  isHouseVisit: boolean;

  // RFC5545 RRULE
  // TODO check if can alr put date here :)
  @Column()
  rrule: string;
}

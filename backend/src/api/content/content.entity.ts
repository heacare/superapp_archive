import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity()
export class Unit {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  moduleNum: number;

  @Column()
  icon: string;

  @Column()
  title: string;

  @OneToMany(() => Lesson, (lesson) => lesson.unit)
  lessons: Lesson[];
}

@Entity()
export class Lesson {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  lessonNum: number;

  @Column()
  icon: string;

  @Column()
  title: string;

  @Column()
  callToAction: string;

  @ManyToOne(() => Unit, (unit) => unit.lessons)
  unit: Unit;

  @OneToMany(() => Page, (page) => page.lesson)
  pages: Page[];
}

@Entity()
export class Page {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  pageNum: number;

  @Column()
  icon: string;

  @Column()
  text: string;

  @ManyToOne(() => Lesson, (lesson) => lesson.pages)
  lesson: Lesson;
}

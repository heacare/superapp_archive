import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity()
export class Chapter {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  chapterNum: number;

  @Column()
  icon: string;

  @Column()
  title: string;

  @OneToMany(() => Subchapter, (subchapter) => subchapter.chapter)
  subchapters: Subchapter[];
}

@Entity()
export class Subchapter {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  subchapterNum: number;

  @Column()
  icon: string;

  @Column()
  title: string;

  @Column()
  callToAction: string;

  @ManyToOne(() => Chapter, (chapter) => chapter.subchapters)
  chapter: Chapter;

  @OneToMany(() => Page, (page) => page.subchapter)
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

  @ManyToOne(() => Subchapter, (subchapter) => subchapter.pages)
  subchapter: Subchapter;
}

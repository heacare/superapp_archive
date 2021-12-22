import {
  Column,
  ChildEntity,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  TableInheritance,
  AfterLoad,
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

  @OneToMany(() => Lesson, (lesson) => lesson.unit, {
    cascade: true,
    eager: true,
  })
  lessons: Lesson[];

  constructor(moduleNum: number, icon: string, title: string, lessons?: Lesson[]) {
    this.moduleNum = moduleNum;
    this.icon = icon;
    this.title = title;
    if (lessons) {
      this.lessons = lessons;
    }
  }
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

  @ManyToOne(() => Unit, (unit) => unit.lessons)
  unit: Unit;

  @OneToMany(() => Page, (page) => page.lesson, {
    cascade: true,
    eager: true,
  })
  pages: Page[];

  constructor(lessonNum: number, icon: string, title: string, pages?: Page[]) {
    this.lessonNum = lessonNum;
    this.icon = icon;
    this.title = title;
    if (pages) {
      this.pages = pages;
    }
  }
}

@Entity()
@TableInheritance({ column: { type: 'varchar', name: 'pageType' } })
export class Page {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  pageNum: number;

  @Column()
  icon: string;

  @Column()
  title: string;

  @Column()
  text: string;

  @ManyToOne(() => Lesson, (lesson) => lesson.pages)
  lesson: Lesson;

  constructor(pageNum: number, icon: string, title: string, text: string) {
    this.pageNum = pageNum;
    this.icon = icon;
    this.title = title;
    this.text = text;
  }
}

@ChildEntity()
export class TextPage extends Page {
  constructor(pageNum: number, icon: string, title: string, text: string) {
    super(pageNum, icon, title, text);
  }
}

@ChildEntity()
export class QuizPage extends Page {
  @OneToMany(() => QuizOption, (quizOption) => quizOption.quiz, {
    eager: true,
    cascade: true,
  })
  quizOptions: QuizOption[];

  constructor(pageNum: number, icon: string, title: string, text: string, quizOptions?: QuizOption[]) {
    super(pageNum, icon, title, text);
    if (quizOptions) {
      this.quizOptions = quizOptions;
    }
  }
}

@Entity()
export class QuizOption {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  text: string;

  @Column()
  isAnswer: boolean;

  @ManyToOne(() => QuizPage, (quiz) => quiz.quizOptions)
  quiz: QuizPage;

  constructor(text: string, isAnswer: boolean) {
    this.text = text;
    this.isAnswer = isAnswer;
  }
}

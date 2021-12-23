import { Column, ChildEntity, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, TableInheritance } from 'typeorm';

@Entity()
export class Unit {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  unitOrder: number;

  @Column()
  icon: string;

  @Column()
  title: string;

  @OneToMany(() => Lesson, (lesson) => lesson.unit, {
    cascade: true,
  })
  lessons: Lesson[];

  constructor(unitOrder: number, icon: string, title: string, lessons?: Lesson[]) {
    this.unitOrder = unitOrder;
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
  lessonOrder: number;

  @Column()
  icon: string;

  @Column()
  title: string;

  @ManyToOne(() => Unit, (unit) => unit.lessons)
  unit: Unit;

  @OneToMany(() => Page, (page) => page.lesson, {
    cascade: true,
  })
  pages: Page[];

  constructor(lessonOrder: number, icon: string, title: string, pages?: Page[]) {
    this.lessonOrder = lessonOrder;
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
  pageOrder: number;

  @Column()
  icon: string;

  @Column()
  title: string;

  @Column()
  text: string;

  @ManyToOne(() => Lesson, (lesson) => lesson.pages)
  lesson: Lesson;

  constructor(pageOrder: number, icon: string, title: string, text: string) {
    this.pageOrder = pageOrder;
    this.icon = icon;
    this.title = title;
    this.text = text;
  }
}

@ChildEntity()
export class TextPage extends Page {
  constructor(pageOrder: number, icon: string, title: string, text: string) {
    super(pageOrder, icon, title, text);
  }
}

@ChildEntity()
export class QuizPage extends Page {
  @OneToMany(() => QuizOption, (quizOption) => quizOption.quiz, {
    cascade: true,
  })
  quizOptions: QuizOption[];

  constructor(pageOrder: number, icon: string, title: string, text: string, quizOptions?: QuizOption[]) {
    super(pageOrder, icon, title, text);
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

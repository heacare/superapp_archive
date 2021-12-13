import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity()
export class Quiz {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  text: string;

  @OneToMany(() => QuizOption, (quizOption) => quizOption.quiz)
  quizOptions: QuizOption[];
}

@Entity()
export class QuizOption {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  text: string;

  @Column()
  isAnswer: boolean;

  @ManyToOne(() => Quiz, (quiz) => quiz.quizOptions)
  quiz: Quiz;
}

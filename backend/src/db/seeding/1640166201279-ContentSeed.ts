import { MigrationInterface, QueryRunner } from 'typeorm';
import { Unit, Lesson, TextPage, QuizPage, QuizOption } from '../../api/content/content.entity';

import * as data from './data.json';

/*
 *  Template generated with `npx typeorm migration:create --name ContentSeed`
 */

export class ContentSeed1640166201279 implements MigrationInterface {
  public async up({ connection }: QueryRunner): Promise<void> {
    console.log('Seeding content...');

    let unitOrder = 0;
    let lessonOrder = 0;
    let pageOrder = 0;

    // Parse JSON
    let units = data.units.map(
      (unit) =>
        new Unit(
          unitOrder++,
          unit.icon,
          unit.title,
          unit.lessons.map(
            (lesson) =>
              new Lesson(
                lessonOrder++,
                lesson.icon,
                lesson.title,
                lesson.pages.map((page) => {
                  if ('quizOptions' in page) {
                    return new QuizPage(
                      pageOrder++,
                      page.icon,
                      page.title,
                      page.text,
                      page.quizOptions.map(
                        (quizOption) => new QuizOption(quizOption.text, quizOption.isAnswer ?? false),
                      ),
                    );
                  } else {
                    return new TextPage(pageOrder++, page.icon, page.title, page.text);
                  }
                }),
              ),
          ),
        ),
    );

    connection.getRepository(Unit).create(units);
    await connection.getRepository(Unit).save(units);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // No need to implement
  }
}

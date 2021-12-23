import * as parse from 'postgres-interval';
import {
  Healer,
  MedicalProficiency,
  MedicalTag,
  Slot,
} from 'src/api/healer/healer.entity';
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
    const units = data.units.map(
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

    const sleep = new MedicalTag();
    sleep.name = 'Sleep';
    sleep.description = 'Crucial for health!';

    const tags = [sleep];
    connection.getRepository(MedicalTag).create(tags);
    await connection.getRepository(MedicalTag).save(tags);

    const sleepProf = new MedicalProficiency();
    sleepProf.tag = sleep;
    sleepProf.proficiency = 8;

    const slot1 = new Slot();
    slot1.isHouseVisit = false;
    slot1.duration = parse('02:00:00');
    slot1.rrule =
      'DTSTART:20120201T093000Z\nRRULE:FREQ=WEEKLY;UNTIL=20250130T230000Z;BYDAY=MO';

    const dan = new Healer();
    dan.name = 'Dan Green';
    dan.description = "Hello, I'm Dan!";
    dan.location = { type: 'Point', coordinates: [1.359365, 103.751329] };
    dan.proficiencies = [sleepProf];
    dan.slots = [slot1];

    const healers = [dan];
    connection.getRepository(Healer).create(healers);
    await connection.getRepository(Healer).save(healers);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // No need to implement
  }
}

import { MigrationInterface, QueryRunner } from 'typeorm';
import { Healer, MedicalProficiency, MedicalTag, Slot } from 'src/api/healer/healer.entity';

/*
 *  Template generated with `npx typeorm migration:create --name ContentSeed`
 */

export class HealerSeed1640339847546 implements MigrationInterface {
  public async up({ connection }: QueryRunner): Promise<void> {
    console.log('Seeding healers...');

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
    slot1.rrule = 'DTSTART:20120201T093000Z\nRRULE:FREQ=WEEKLY;UNTIL=20250130T230000Z;BYDAY=MO';

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

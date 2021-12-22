import { Injectable, Module, OnApplicationBootstrap } from '@nestjs/common';
import { Connection } from 'typeorm';
import { Unit, Lesson, Page } from '../../api/content/content.entity';

import * as data from './data.json';

@Injectable()
export default class ContentSeederService implements OnApplicationBootstrap {
  constructor(private readonly connection: Connection) {}

  onApplicationBootstrap() {
    // TODO check for previous seed
    console.log('Seeding DB...');
    this.seed();
  }

  private async seed(): Promise<any> {
    let unitNum = 0;
    let lessonNum = 0;
    let pageNum = 0;

    // Parse JSON
    let units = data.units.map(
      (unit) =>
        new Unit(
          unitNum++,
          unit.icon,
          unit.title,
          unit.lessons.map(
            (lesson) =>
              new Lesson(
                lessonNum++,
                lesson.icon,
                lesson.title,
                lesson.pages.map(
                  (page) =>
                    new Page(pageNum++, page.icon, page.title, page.text),
                ),
              ),
          ),
        ),
    );

    this.connection.getRepository(Unit).create(units);
    await this.connection.getRepository(Unit).save(units);
  }
}

@Module({
  providers: [ContentSeederService],
})
export class DbSeedModule {}

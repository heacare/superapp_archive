import { DynamicModule } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { TypeOrmModule } from '@nestjs/typeorm';
import { writeFileSync } from 'fs';
import { Connection } from 'typeorm';
import { PostgresConnectionOptions } from 'typeorm/driver/postgres/PostgresConnectionOptions';
import { ApiModule } from './api/api.module';
import { configSwagger } from './main';

// TODO move to config module
// TOOD ALSO MOVE THIS TO AUTHMODULE so that we can override module (see below)
process.env.JWT_SECRET = 'nothingisasecret';

// FIXME BIG HACK
// Waiting on https://github.com/nestjs/nest/pull/8777 to override module
// then we can directly use AppModule then override the DbModule.
function createDummyDbModule(): DynamicModule {
  const options: PostgresConnectionOptions = { type: 'postgres' };
  const module = TypeOrmModule.forRoot(options);

  // Replace the exported connection to do _nothing_
  // except consider that all types are valid entiies
  // and thus have non-undefined getRespository
  for (const imp of module.imports) {
    for (const v of (imp as any).exports) {
      if (v.provide == Connection) {
        v.useFactory = () => {
          return {
            options,
            getRepository: () => null,
          };
        };
      }
    }
  }

  return module;
}

async function generate() {
  const mod = await Test.createTestingModule({
    imports: [createDummyDbModule(), ApiModule],
  }).compile();

  const app = mod.createNestApplication();
  const document = await configSwagger(app);

  // writes most recent OpenAPI document to file system
  writeFileSync('./openapi.json', JSON.stringify(document));
  console.log('File written!');
  process.exit(0);
}

(async () => {
  await generate();
})();

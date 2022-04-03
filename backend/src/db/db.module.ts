import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.POSTGRES_HOST || 'db',
      port: 5432,
      username: process.env.POSTGRES_USER,
      password: process.env.POSTGRES_PASSWORD,
      entities: ['dist/**/*.entity{ .ts,.js}'],
      // TODO: !! Remove this in prod !!
      synchronize: true,
      // For content seeding
      migrations: ['dist/db/seeding/*{.ts,.js}'],
      migrationsTransactionMode: 'each',
      migrationsRun: true,
    }),
  ],
})
export class DbModule {}

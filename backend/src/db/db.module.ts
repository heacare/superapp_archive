import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'db',
      port: 1001, // TODO find postgres port
      entities: ['../../../dist/**/*.entity{.ts,.js}'],
      synchronize: true,
    }),
  ],
})
export class DbModule {}

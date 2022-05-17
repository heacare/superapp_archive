import { Log } from './log.entity';
import { IsString, IsISO8601, IsNotEmpty, IsOptional } from 'class-validator';

export class LogDto {
  @IsNotEmpty()
  @IsString()
  key: string;

  @IsISO8601()
  @IsOptional()
  ts?: string;

  @IsString()
  @IsOptional()
  tz?: string;

  @IsString()
  value: string;
}

export class LogDumpDto {
  @IsString()
  secret: string;

  @IsISO8601()
  start: string;

  @IsISO8601()
  end: string;
}

export interface LogDumpSimplifiedDto extends Omit<Log, 'user'> {
  user: {
    id: number;
  };
}

import { IsString, IsISO8601, IsNotEmpty } from 'class-validator';

export class LogDto {
  @IsNotEmpty()
  @IsString()
  key: string;

  @IsISO8601()
  ts: string;

  @IsString()
  tz: string;

  @IsString()
  value: string;
}

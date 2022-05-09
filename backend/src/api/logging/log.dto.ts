import { IsString, IsISO8601, IsNotEmpty } from 'class-validator';

export class LogDto {
  @IsNotEmpty()
  @IsString()
  key: string;

  @IsISO8601()
  date: string;

  @IsString()
  value: string;
}

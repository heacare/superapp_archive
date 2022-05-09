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

import {
  IsString,
  IsNotEmpty,
} from 'class-validator';

export class LogDto {
  @IsNotEmpty()
	@IsString()
	key: string

	@IsString()
	value: string
}

import { IsNotEmpty, IsString } from 'class-validator';

export class AuthRequestDto {
  @IsString()
  @IsNotEmpty()
  firebaseToken: string;
}

export class AuthResponseDto {
  jwt: string;
}

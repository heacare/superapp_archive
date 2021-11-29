import { createMock } from '@golevelup/ts-jest';
import { JwtService } from '@nestjs/jwt';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiFirebaseModule } from '../api.module';
import { UserService } from '../user/user.service';
import { AuthService } from './auth.service';

describe('AuthService', () => {
  let service: AuthService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [ApiFirebaseModule],
      providers: [
        AuthService,
        {
          provide: UserService,
          useValue: createMock(),
        },
        {
          provide: JwtService,
          useValue: createMock(),
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('getAuthId returns undefined for invalid ids', async () => {
    expect(await service.getAuthId('aaaayyylmao')).toBeUndefined();
  });
});

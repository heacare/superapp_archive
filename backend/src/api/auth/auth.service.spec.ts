import { createMock } from '@golevelup/ts-jest';
import { Test, TestingModule } from '@nestjs/testing';
import { FirebaseAppModule } from '../api.module';
import { UserService } from '../user/user.service';
import { AuthService } from './auth.service';

describe('AuthService', () => {
  let service: AuthService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [FirebaseAppModule],
      providers: [
        AuthService,
        {
          provide: UserService,
          useValue: createMock(),
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('returns null for invalid ids', async () => {
    expect(await service.getAuthId('aaaayyylmao')).toBeUndefined();
  });
});

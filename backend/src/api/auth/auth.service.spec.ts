import { Test, TestingModule } from '@nestjs/testing';
import { ApiModule } from '../api.module';
import { AuthService } from './auth.service';

describe('AuthService', () => {
  let service: AuthService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [ApiModule],
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

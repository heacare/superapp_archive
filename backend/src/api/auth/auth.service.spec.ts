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

  it('returns true for valid id', async () => {
    const token =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6IjgwNTg1Zjk5MjExMmZmODgxMTEzOTlhMzY5NzU2MTc1YWExYjRjZjkiLCJ0eXAiOiJKV1QifQ' +
      '.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vaGFwcGlseS1ldmVyLWFmdGVyLTRiMmZlIiwiYXVkIjoiaGFwc' +
      'GlseS1ldmVyLWFmdGVyLTRiMmZlIiwiYXV0aF90aW1lIjoxNjM4MTU3Nzg5LCJ1c2VyX2lkIjoiUGxJd2pkdWk4ZFFQOGJXTnk2SjV' +
      'jekhMVjBsMSIsInN1YiI6IlBsSXdqZHVpOGRRUDhiV055Nko1Y3pITFYwbDEiLCJpYXQiOjE2MzgxNTc3ODksImV4cCI6MTYzODE2M' +
      'TM4OSwiZW1haWwiOiJ0ZXN0QHRlc3Rlcy5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXM' +
      'iOnsiZW1haWwiOlsidGVzdEB0ZXN0ZXMuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.CC1sIxOer51YFm-Uu' +
      'DT4Y6N0wBu6g_TfLK-8Aws4uqyucWhJWZ_H4SqhmQ2ka2aq8Dfc6aYljp-pSLle9f1Dyh6h9y3E4rAiAr_aliISzG0jaUgyb1m-RN5' +
      'jpnhiALTAgurwrgxNYxOTLup6pdj5BXyh6wpm0Yxu-WTa0HnIqdX_ApBBb7WAOYr89DFQvGpx1SoCWYNhAFmLLoswW6TxSHsiA9fIb' +
      't3hb43qbUjOprffBjePkdmpsSWQ6qj73DL5d-hdT5dyJpzLi09hgSzip-976v81QNetsksvdrvY6UIy2x4EwlEUyp_BPZD8KbJsdG6' +
      'I1c2H-RKg0y-DjsmrYw';
    expect(await service.getAuthId(token)).toBeTruthy();
  });
});

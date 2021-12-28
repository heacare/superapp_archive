import { createMock } from '@golevelup/ts-jest';
import { Test, TestingModule } from '@nestjs/testing';
import { validateOrReject } from 'class-validator';
import { OnboardingDto } from './onboarding.dto';
import { UserController } from './user.controller';
import { UserService } from './user.service';

describe('UserController', () => {
  let controller: UserController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserController],
      providers: [
        {
          provide: UserService,
          useValue: createMock(),
        },
      ],
    }).compile();

    controller = module.get<UserController>(UserController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('onboard', () => {
    it('should be defined', () => {
      expect(controller.processOnboarding).toBeDefined();
    });

    it('fails validation', () => {
      const obj = new OnboardingDto();
      expect(validateOrReject(obj)).rejects.toBeCalled();
    });
  });
});

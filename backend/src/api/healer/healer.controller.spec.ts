import { createMock } from '@golevelup/ts-jest';
import { Test, TestingModule } from '@nestjs/testing';
import { HealerController } from './healer.controller';
import { HealerService } from './healer.service';

describe('HealerController', () => {
  let controller: HealerController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HealerController],
      providers: [
        {
          provide: HealerService,
          useValue: createMock(),
        },
      ],
    }).compile();

    controller = module.get<HealerController>(HealerController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});

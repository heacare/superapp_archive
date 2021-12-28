import { Test, TestingModule } from '@nestjs/testing';
import { HealerController } from './healer.controller';

describe('HealerController', () => {
  let controller: HealerController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HealerController],
    }).compile();

    controller = module.get<HealerController>(HealerController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});

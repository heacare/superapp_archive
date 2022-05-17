import { Controller, Get, Render } from '@nestjs/common';

@Controller('/landing')
export class LandingController {
  @Get('/press-back')
  @Render('landing/press-back')
  async pressBack(): Promise<void> {
    return;
  }
}

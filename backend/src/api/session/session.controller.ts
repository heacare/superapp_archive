import { Controller, Get } from '@nestjs/common';

@Controller('/api/session')
export class SessionController {
  @Get()
  async getForUser() {

  }
}

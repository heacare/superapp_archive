import { Controller, Get } from '@nestjs/common';

@Controller('/api/content')
export class ContentController {
  @Get()
  getAll(): string {
    throw new Error('Actually return the correct type');
  }
}

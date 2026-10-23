import { Controller, Get } from '@nestjs/common';
import { IdentityService } from '../application/identity.service';

@Controller()
export class IdentityController {
  constructor(private readonly identityService: IdentityService) {}

  @Get()
  getHello(): { message: string } {
    return this.identityService.getHello();
  }
}

import { Injectable } from '@nestjs/common';

@Injectable()
export class IdentityService {
  getHello(): { message: string } {
    return { message: 'Hello World!' };
  }
}

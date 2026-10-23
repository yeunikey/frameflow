import { Injectable } from '@nestjs/common';

@Injectable()
export class DocumentsService {
  getHello(): { message: string } {
    return { message: 'Hello World!' };
  }
}

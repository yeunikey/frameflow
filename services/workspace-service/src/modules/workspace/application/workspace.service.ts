import { Injectable } from '@nestjs/common';

@Injectable()
export class WorkspaceService {
  getHello(): { message: string } {
    return { message: 'Hello World!' };
  }
}

import { Controller, Get } from '@nestjs/common';
import { DocumentsService } from '../application/documents.service';

@Controller()
export class DocumentsController {
  constructor(private readonly documentsService: DocumentsService) {}

  @Get()
  getHello(): { message: string } {
    return this.documentsService.getHello();
  }
}

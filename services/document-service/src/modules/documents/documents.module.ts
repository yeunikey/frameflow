import { Module } from '@nestjs/common';
import { DocumentsService } from './application/documents.service';
import { DocumentsController } from './presentation/documents.controller';

@Module({
  controllers: [DocumentsController],
  providers: [DocumentsService],
})
export class DocumentsModule {}

import { Module } from '@nestjs/common';
import { WorkspaceService } from './application/workspace.service';
import { WorkspaceController } from './presentation/workspace.controller';

@Module({
  controllers: [WorkspaceController],
  providers: [WorkspaceService],
})
export class WorkspaceModule {}

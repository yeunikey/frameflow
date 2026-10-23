import { Module } from '@nestjs/common';
import { WorkspaceModule } from './modules/workspace/workspace.module';

@Module({
  imports: [WorkspaceModule],
})
export class AppModule {}

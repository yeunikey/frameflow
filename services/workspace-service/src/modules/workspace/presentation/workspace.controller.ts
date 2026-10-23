import { Controller, Get } from '@nestjs/common';
import { WorkspaceService } from '../application/workspace.service';

@Controller()
export class WorkspaceController {
  constructor(private readonly workspaceService: WorkspaceService) {}

  @Get()
  getHello(): { message: string } {
    return this.workspaceService.getHello();
  }
}

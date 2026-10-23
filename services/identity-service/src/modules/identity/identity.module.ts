import { Module } from '@nestjs/common';
import { IdentityService } from './application/identity.service';
import { IdentityController } from './presentation/identity.controller';

@Module({
  controllers: [IdentityController],
  providers: [IdentityService],
})
export class IdentityModule {}

import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  app.enableShutdownHooks();
  await app.listen(Number(process.env.HTTP_PORT ?? 3001), process.env.HTTP_HOST ?? '0.0.0.0');
}

bootstrap().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});

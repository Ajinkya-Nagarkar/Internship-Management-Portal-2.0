import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({
  path: path.resolve(process.cwd(), '.env'),
});

import { NestFactory, Reflector } from '@nestjs/core';
import { AppModule } from './app.module';
import { ClassSerializerInterceptor } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const reflector = app.get(Reflector);
  app.useGlobalInterceptors(new ClassSerializerInterceptor(reflector));
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
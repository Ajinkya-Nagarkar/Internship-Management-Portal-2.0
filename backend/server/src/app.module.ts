import { Module } from '@nestjs/common';
// import { ConfigModule } from '@nestjs/config';
import * as path from 'path';

import configuration from './config/configuration';
import { DatabaseModule } from './database/database.module';
import { HealthModule } from './health/health.module';

@Module({
  imports: [
    // ConfigModule.forRoot({
    //   isGlobal: true,
    //   // load: [configuration],
    //   envFilePath: path.resolve(process.cwd(), '../.env'),
    // }),
    DatabaseModule,
    HealthModule,
  ],
})
export class AppModule { }
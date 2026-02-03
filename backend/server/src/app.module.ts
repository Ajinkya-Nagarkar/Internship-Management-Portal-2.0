import { Module } from '@nestjs/common';
// import { ConfigModule } from '@nestjs/config';
import * as path from 'path';

import configuration from './config/configuration';
import { DatabaseModule } from './database/database.module';
import { HealthModule } from './health/health.module';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    DatabaseModule,
    HealthModule,
    UsersModule,
  ],
})
export class AppModule { }
import { TypeOrmModuleOptions } from '@nestjs/typeorm';

// console.log('DB_PASSWORD from env:', process.env.DB_PASSWORD);

export const databaseConfig = (): TypeOrmModuleOptions => ({
    type: 'postgres',
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT),
    username: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,

    synchronize: false,   // VERY IMPORTANT (schema already exists)
    autoLoadEntities: false,
    logging: true,
});
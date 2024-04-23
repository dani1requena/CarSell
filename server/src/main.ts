import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { CORS } from './constants';
import * as session from 'express-session';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: ['debug', 'error', 'log', 'warn'],
  });
  const configService = app.get(ConfigService);

  app.use(
    session({
      secret: configService.get<string>('JWT_SECRET'),
      resave: false,
      saveUninitialized: false,
      cookie: { secure: false },
      name: 'session_id',
    }),
  );
  app.enableCors(CORS);
  await app.listen(4000);
}
bootstrap();

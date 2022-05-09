import { join } from 'path';
import * as cookieParser from 'cookie-parser';
import { json } from 'express';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

import { AppModule } from './app.module';

export async function configSwagger(app: INestApplication) {
  const config = new DocumentBuilder()
    .setTitle('HEA Backend')
    .setDescription('See /api/auth/verify for authentication')
    .setVersion('0.5')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);
  return document;
}

async function configRender(app: NestExpressApplication) {
  app.useStaticAssets(join(__dirname, '..', 'public'));
  app.setBaseViewsDir(join(__dirname, '..', 'views'));
  app.setViewEngine('hbs');
}

async function configCookie(app: NestExpressApplication) {
  app.use(cookieParser());
}

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  await configSwagger(app);
  await configRender(app);
  await configCookie(app);

  app.use(json({ limit: '10mb' }));

  app.useGlobalPipes(
    new ValidationPipe({
      skipMissingProperties: false,
      skipUndefinedProperties: false,
      enableDebugMessages: true,
      whitelist: true,
      transform: true,
    }),
  );

  await app.listen(3000);
}

bootstrap();

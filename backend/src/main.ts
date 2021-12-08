import { INestApplication, ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { writeFile } from 'fs';
import { promisify } from 'util';
import { AppModule } from './app.module';

async function configSwagger(app: INestApplication) {
  const config = new DocumentBuilder()
    .setTitle('HEA Backend')
    .setDescription('See /api/auth/verify for authentication')
    .setVersion('0.5')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);
  // writes most recent OpenAPI document to file system
  await promisify(writeFile)('./openapi.json', JSON.stringify(document));
}

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  await configSwagger(app);
  app.useGlobalPipes(new ValidationPipe());

  await app.listen(3000);
}

bootstrap();

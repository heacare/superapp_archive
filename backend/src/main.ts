import { INestApplication, ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
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

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  await configSwagger(app);

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

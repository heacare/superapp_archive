import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { writeFileSync } from 'fs';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle('HEA Backend')
    .setDescription("API for HEA's backend")
    .setVersion('0.5')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  // writes most recent OpenAPI document to file system
  writeFileSync('./openapi.json', JSON.stringify(document));

  await app.listen(3000);
}
bootstrap();

import { Request, Response } from 'express';
import { Client } from '@notionhq/client';
import type { SearchResponse } from '@notionhq/client/build/src/api-endpoints';
import { Controller, Get, Post, Query, Body, Req, Res, Redirect, Render } from '@nestjs/common';

import { FindPageDto } from './find-page.dto';
import { NotionService } from './notion/notion.service';
import { OAuthInfo, AccessToken } from './notion/notion.entity';

interface LoggedIn {
  logged_in: boolean;
}

@Controller('/cms')
export class CmsController {
  constructor(private notionService: NotionService) {}

  @Get('/')
  @Render('cms/index')
  async index(@Req() request: Request): Promise<OAuthInfo | LoggedIn> {
    return {
      ...this.notionService.getOAuthInfo(),
      logged_in: request.cookies['access'],
    };
  }

  @Post('/')
  @Render('cms/index')
  async findPage(
    @Body() findPage: FindPageDto,
    @Req() request: Request,
  ): Promise<OAuthInfo | LoggedIn | SearchResponse> {
    let response = {};
    if (request.cookies['access']) {
      const access = JSON.parse(request.cookies['access']);
      const client = new Client({
        auth: access.access_token,
      });
      response = await client.search({
        query: findPage.query,
        filter: {
          property: 'object',
          value: 'page',
        },
      });
    }
    return {
      ...this.notionService.getOAuthInfo(),
      logged_in: !!request.cookies['access'],
      ...response,
    };
  }

  @Post('/logout')
  @Redirect('/cms/', 303)
  async logout(@Res({ passthrough: true }) response: Response): Promise<void> {
    response.cookie('access', '', {
      path: '/cms',
      expires: new Date(0),
    });
  }

  @Get('/auth')
  @Redirect('/cms/', 303)
  async auth(
    @Query('code') code: string,
    @Query('state') state: string,
    @Res({ passthrough: true }) response: Response,
  ): Promise<void> {
    const access = await this.notionService.getAccessFromGrant(code);
    response.cookie('access', JSON.stringify(access), {
      path: '/cms',
    });
  }
}
